use cairo_lang_casm::builder::CasmBuilder;
use cairo_lang_casm::cell_expression::CellExpression;
use cairo_lang_casm::hints::CoreHint;
use cairo_lang_casm::operand::{CellRef, Register};
use cairo_lang_casm::{casm, casm_build_extend};
use cairo_lang_sierra::extensions::circuit::{
    CircuitConcreteLibfunc, CircuitInfo, BUILTIN_INSTANCE_SIZE, OFFSETS_PER_GATE, VALUE_SIZE,
};
use cairo_lang_sierra::ids::ConcreteTypeId;
use cairo_lang_utils::casts::IntoOrPanic;

use super::misc::build_identity;
use super::{CompiledInvocation, CompiledInvocationBuilder, InvocationError};
use crate::invocations::{add_input_variables, get_non_fallthrough_statement_id};
use crate::references::ReferenceExpression;
use crate::relocations::{Relocation, RelocationEntry};

/// Builds instructions for Sierra array operations.
pub fn build(
    libfunc: &CircuitConcreteLibfunc,
    builder: CompiledInvocationBuilder<'_>,
) -> Result<CompiledInvocation, InvocationError> {
    match libfunc {
        CircuitConcreteLibfunc::U384IsZero(_libfunc) => build_u384_is_zero(builder),
        CircuitConcreteLibfunc::FillInput(_libfunc) => build_fill_input(builder),
        CircuitConcreteLibfunc::Eval(libfunc) => build_circuit_eval(&libfunc.ty, builder),
        CircuitConcreteLibfunc::GetDescriptor(libfunc) => {
            build_get_descriptor(&libfunc.ty, builder)
        }
        CircuitConcreteLibfunc::GetOutput(libfunc) => {
            build_get_output(&libfunc.circuit_ty, &libfunc.output_ty, builder)
        }
        CircuitConcreteLibfunc::InitCircuitData(libfunc) => {
            build_init_circuit_data(&libfunc.ty, builder)
        }
        CircuitConcreteLibfunc::FailureGuaranteeVerify(_) => {
            build_failure_guarantee_verify(builder)
        }
        CircuitConcreteLibfunc::IntoU96Guarantee(_) => build_identity(builder),
    }
}

/// Handles a Sierra statement for initializing circuit data.
fn build_init_circuit_data(
    circuit_ty: &ConcreteTypeId,
    builder: CompiledInvocationBuilder<'_>,
) -> Result<CompiledInvocation, InvocationError> {
    let [expr_rc96] = builder.try_get_refs()?;
    let rc96 = expr_rc96.try_unpack_single()?;

    let circ_info = builder.program_info.circuits_info.circuits.get(circuit_ty).unwrap();
    let n_inputs = circ_info.n_inputs;
    let rc96_usage = circ_info.rc96_usage();

    let mut casm_builder = CasmBuilder::default();

    add_input_variables! {casm_builder,
        buffer(1) rc96;
    };
    casm_build_extend! {casm_builder,
        const value_size = VALUE_SIZE;
        let inputs_start = rc96 + value_size;
        // This size of all the inputs including the input 1.
        const inputs_size = (1 + n_inputs) * VALUE_SIZE;
        let inputs_end = rc96 + inputs_size;
        const rc96_usage = rc96_usage;
        let vals_end = rc96 + rc96_usage;
    };

    Ok(builder.build_from_casm_builder(
        casm_builder,
        [("Fallthrough", &[&[vals_end], &[inputs_start, inputs_end]], None)],
        Default::default(),
    ))
}

/// Handles a Sierra statement for popping an element from the beginning of an array.
fn build_fill_input(
    builder: CompiledInvocationBuilder<'_>,
) -> Result<CompiledInvocation, InvocationError> {
    let [expr_handle, elem] = builder.try_get_refs()?;
    let [start, end] = expr_handle.try_unpack()?;

    let mut casm_builder = CasmBuilder::default();
    add_input_variables! {casm_builder,
        buffer(elem.cells.len() as i16) start;
        deref end;
    };
    for cell in &elem.cells {
        add_input_variables!(casm_builder, deref cell;);
        casm_build_extend!(casm_builder, assert cell = *(start++););
    }

    casm_build_extend! {casm_builder,
        tempvar new_start = start;
        tempvar remaining = end - new_start;
        jump More if remaining != 0;
        Done:
    };
    let more_handle = get_non_fallthrough_statement_id(&builder);

    Ok(builder.build_from_casm_builder(
        casm_builder,
        [("Fallthrough", &[&[end]], None), ("More", &[&[new_start, end]], Some(more_handle))],
        Default::default(),
    ))
}

/// Builds instructions for `get_circuit_descriptor` libfunc.
fn build_get_descriptor(
    circuit_ty: &ConcreteTypeId,
    builder: CompiledInvocationBuilder<'_>,
) -> Result<CompiledInvocation, InvocationError> {
    let CircuitInfo { add_offsets, mul_offsets, .. } =
        builder.program_info.circuits_info.circuits.get(circuit_ty).unwrap();

    let ctx = casm! {
        // The relocation will point the `call` to the `ret;` instruction that precedes the
        // relevant const.
        call rel 0;
        // The relocation table will add const offset to the `1` below, making it point to the
        // constant value (the `1` is to skip the `ret` instruction).
        // TODO(Gil): Support relocatable CellExpression and return an unstored "[ap - 1] + 1".
        [ap] = [ap - 1] + 1, ap++;
        [ap] = (add_offsets.len()), ap++;
        [ap] = [ap - 2] + (add_offsets.len() * OFFSETS_PER_GATE), ap++;
        [ap] = (mul_offsets.len()), ap++;
    };

    let relocations = vec![
        RelocationEntry {
            instruction_idx: 0,
            relocation: Relocation::CircuitStart(circuit_ty.clone()),
        },
        RelocationEntry {
            instruction_idx: 1,
            relocation: Relocation::CircuitStart(circuit_ty.clone()),
        },
    ];
    Ok(builder.build(
        ctx.instructions,
        relocations,
        [vec![ReferenceExpression {
            cells: vec![
                CellExpression::Deref(CellRef { register: Register::AP, offset: -4 }),
                CellExpression::Deref(CellRef { register: Register::AP, offset: -3 }),
                CellExpression::Deref(CellRef { register: Register::AP, offset: -2 }),
                CellExpression::Deref(CellRef { register: Register::AP, offset: -1 }),
            ],
        }]
        .into_iter()]
        .into_iter(),
    ))
}

/// Builds instructions for `circuit_eval` libfunc.
fn build_circuit_eval(
    circuit_ty: &ConcreteTypeId,
    builder: CompiledInvocationBuilder<'_>,
) -> Result<CompiledInvocation, InvocationError> {
    let [expr_add_mod, expr_mul_mod, expr_desc, expr_data, modulus_expr, expr_zero, expr_one] =
        builder.try_get_refs()?;
    let add_mod = expr_add_mod.try_unpack_single()?;
    let mul_mod = expr_mul_mod.try_unpack_single()?;
    let [add_mod_offsets, n_adds, mul_mod_offsets, n_muls] = expr_desc.try_unpack()?;
    let [modulus0, modulus1, modulus2, modulus3] = modulus_expr.try_unpack()?;
    let inputs_end = expr_data.try_unpack_single()?;

    let zero = expr_zero.try_unpack_single()?;
    let one = expr_one.try_unpack_single()?;
    let mut casm_builder = CasmBuilder::default();

    let instance_size = BUILTIN_INSTANCE_SIZE.into_or_panic();
    add_input_variables! {casm_builder,
        buffer(instance_size) add_mod;
        buffer(instance_size) mul_mod;
        buffer(VALUE_SIZE.into_or_panic()) inputs_end;
        deref add_mod_offsets;
        deref n_adds;
        deref mul_mod_offsets;
        deref n_muls;

        deref modulus0;
        deref modulus1;
        deref modulus2;
        deref modulus3;

        deref zero;
        deref one;
    };

    let CircuitInfo { add_offsets, mul_offsets, n_inputs, .. } =
        builder.program_info.circuits_info.circuits.get(circuit_ty).unwrap();

    casm_build_extend! {casm_builder,
        // input size including the input 1.
        const inputs_size = (n_inputs + 1) * VALUE_SIZE;
        tempvar values = inputs_end - inputs_size;

        // Add the input 1 at the end of the inputs.
        assert one = values[0];
        assert zero = values[1];
        assert zero = values[2];
        assert zero = values[3];
    };

    casm_build_extend! {casm_builder,
        assert modulus0 = add_mod[0];
        assert modulus1 = add_mod[1];
        assert modulus2 = add_mod[2];
        assert modulus3 = add_mod[3];
        assert values = add_mod[4];
        assert add_mod_offsets = add_mod[5];
        assert n_adds = add_mod[6];



        tempvar computed_gates;
        hint CoreHint::EvalCircuit {
            values_ptr: values,
            n_add_mods: n_adds, add_mod_offsets: add_mod_offsets,
            n_mul_mods: n_muls, mul_mod_offsets: mul_mod_offsets,
            modulus: modulus0
        } into {computed_gates_out: computed_gates};

        assert modulus0 = mul_mod[0];
        assert modulus1 = mul_mod[1];
        assert modulus2 = mul_mod[2];
        assert modulus3 = mul_mod[3];
        assert values = mul_mod[4];
        assert mul_mod_offsets = mul_mod[5];
        assert computed_gates = mul_mod[6];



        const add_mod_usage = (BUILTIN_INSTANCE_SIZE * add_offsets.len());
        let new_add_mod = add_mod + add_mod_usage;


        // Compute the number of mul gates that were not evaluated.
        tempvar skipped_gates = n_muls - computed_gates;
        jump Failure if skipped_gates != 0;


        const mul_mod_usage = (BUILTIN_INSTANCE_SIZE * mul_offsets.len());
        let new_mul_mod = mul_mod + mul_mod_usage;


        jump Success;
    };

    casm_build_extend! {casm_builder,
        Failure:

        // TODO(ilya): Consider always consuming `mul_offsets.len()` mulmod instances.
        const instance_size = BUILTIN_INSTANCE_SIZE;
        tempvar mul_mod_usage = computed_gates * instance_size;
        let failure_mul_mod = mul_mod + mul_mod_usage;

    };

    let success_handle = get_non_fallthrough_statement_id(&builder);

    Ok(builder.build_from_casm_builder(
        casm_builder,
        [
            // Failure.
            (
                "Fallthrough",
                &[
                    &[new_add_mod],
                    &[failure_mul_mod],
                    // CircuitPartialOutputs
                    &[values, modulus0, modulus1, modulus2, modulus3, computed_gates],
                    // CircuitFailureGuarantee
                    &[
                        mul_mod_offsets,
                        n_muls,
                        computed_gates,
                        values,
                        modulus0,
                        modulus1,
                        modulus2,
                        modulus3,
                    ],
                ],
                None,
            ),
            (
                "Success",
                &[
                    &[new_add_mod],
                    &[new_mul_mod],
                    &[values, modulus0, modulus1, modulus2, modulus3],
                ],
                Some(success_handle),
            ),
        ],
        Default::default(),
    ))
}

/// Generates casm instructions for `u384_is_zero()`.
fn build_u384_is_zero(
    builder: CompiledInvocationBuilder<'_>,
) -> Result<CompiledInvocation, InvocationError> {
    let [l0, l1, l2, l3] = builder.try_get_refs::<1>()?[0].try_unpack()?;

    let mut casm_builder = CasmBuilder::default();
    add_input_variables!(casm_builder, deref l0; deref l1; deref l2; deref l3;);
    casm_build_extend! {casm_builder,
        jump Target if l0 != 0;
        jump Target if l1 != 0;
        jump Target if l2 != 0;
        jump Target if l3 != 0;
    };

    let target_statement_id = get_non_fallthrough_statement_id(&builder);
    Ok(builder.build_from_casm_builder(
        casm_builder,
        [("Fallthrough", &[], None), ("Target", &[&[l0, l1, l2, l3]], Some(target_statement_id))],
        Default::default(),
    ))
}

/// Builds instructions for `circuit_failure_guarantee_verify` libfunc.
fn build_failure_guarantee_verify(
    builder: CompiledInvocationBuilder<'_>,
) -> Result<CompiledInvocation, InvocationError> {
    let [expr_rc96, expr_mul_mod, expr_guarantee, expr_zero, expr_one] = builder.try_get_refs()?;
    let rc96 = expr_rc96.try_unpack_single()?;

    let mul_mod = expr_mul_mod.try_unpack_single()?;
    let [orig_mul_mod_offsets, n_muls, fail_idx, values, modulus0, modulus1, modulus2, modulus3] =
        expr_guarantee.try_unpack()?;

    let zero = expr_zero.try_unpack_single()?;
    let one = expr_one.try_unpack_single()?;

    let mut casm_builder = CasmBuilder::default();
    let rc_usage = (2 + VALUE_SIZE).into_or_panic();

    let instance_size = BUILTIN_INSTANCE_SIZE.into_or_panic();
    add_input_variables! {casm_builder,
        buffer(rc_usage) rc96;
        buffer(instance_size) mul_mod;
        deref orig_mul_mod_offsets;

        deref modulus0;
        deref modulus1;
        deref modulus2;
        deref modulus3;

        deref values;
        deref zero;
        deref one;
        deref n_muls;
        deref fail_idx;
    };

    casm_build_extend! {casm_builder,
        const offsets_per_gate = OFFSETS_PER_GATE;
        tempvar failing_gate_offset = fail_idx * offsets_per_gate;
        tempvar failing_gate_ptr = orig_mul_mod_offsets + failing_gate_offset;

        tempvar nullifier_offset = failing_gate_ptr[0];
        tempvar zero_divisor_offset = failing_gate_ptr[1];
        // The output of the failing gate points to the const zero.
        assert zero = failing_gate_ptr[2];

        tempvar zero_offset = rc96 - values;
        // Write the value 0 to rc96.
        assert zero = *(rc96++);
        assert zero = *(rc96++);
        assert zero = *(rc96++);
        assert zero = *(rc96++);

        tempvar mul_mod_offsets;
        hint AllocSegment {} into {dst: mul_mod_offsets};

        assert nullifier_offset = mul_mod_offsets[0];
        assert zero_divisor_offset = mul_mod_offsets[1];
        assert zero_offset = mul_mod_offsets[2];


        // Check that 0 <= fail_idx <= n_muls;
        // Note that since we are in the failure case we know that fail_idx != n_muls.
        assert fail_idx = *(rc96++);
        tempvar diff = n_muls - fail_idx;
        assert diff = *(rc96++);

        assert modulus0 = mul_mod[0];
        assert modulus1 = mul_mod[1];
        assert modulus2 = mul_mod[2];
        assert modulus3 = mul_mod[3];
        assert values = mul_mod[4];
        assert mul_mod_offsets = mul_mod[5];
        assert one = mul_mod[6];

        tempvar nullifier_ptr = values + nullifier_offset;
        tempvar nullifier0 = nullifier_ptr[0];
        tempvar nullifier1 = nullifier_ptr[1];
        tempvar nullifier2 = nullifier_ptr[2];
        tempvar nullifier3 = nullifier_ptr[3];
        jump Done if nullifier0 != 0;
        jump Done if nullifier1 != 0;
        jump Done if nullifier2 != 0;
        jump Done if nullifier3 != 0;

        // If the nullifer is zero, add an unsatisfiable constraint.
        assert one = zero;

        Done:
        const mul_mod_usage = BUILTIN_INSTANCE_SIZE;
        let new_mul_mod = mul_mod + mul_mod_usage;

    };

    Ok(builder.build_from_casm_builder(
        casm_builder,
        [(
            "Fallthrough",
            &[
                &[rc96],
                &[new_mul_mod],
                &[
                    nullifier0, nullifier1, nullifier2, nullifier3, modulus0, modulus1, modulus2,
                    modulus3,
                ],
            ],
            None,
        )],
        Default::default(),
    ))
}

/// Builds instructions for `get_output` libfunc.
fn build_get_output(
    circuit_ty: &ConcreteTypeId,
    output_ty: &ConcreteTypeId,
    builder: CompiledInvocationBuilder<'_>,
) -> Result<CompiledInvocation, InvocationError> {
    let [expr_outputs] = builder.try_get_refs()?;
    let [values_ptr, modulus0, modulus1, modulus2, modulus3] = expr_outputs.try_unpack()?;

    let mut casm_builder = CasmBuilder::default();

    let CircuitInfo { values, .. } =
        builder.program_info.circuits_info.circuits.get(circuit_ty).unwrap();

    let output_offset = values.get(output_ty).unwrap();

    add_input_variables! {casm_builder,

        deref values_ptr;

        deref modulus0;
        deref modulus1;
        deref modulus2;
        deref modulus3;


    };

    casm_build_extend! {casm_builder,

        const output_offset = output_offset * VALUE_SIZE;
        // We compute output_ptr instead of using an offset to overcome the 15 bit offset limit.
        tempvar output_ptr = values_ptr + output_offset;

        tempvar output0 = output_ptr[0];
        tempvar output1 = output_ptr[1];
        tempvar output2 = output_ptr[2];
        tempvar output3 = output_ptr[3];
    };

    Ok(builder.build_from_casm_builder(
        casm_builder,
        [(
            "Fallthrough",
            &[
                &[output0, output1, output2, output3],
                &[output0, output1, output2, output3, modulus0, modulus1, modulus2, modulus3],
            ],
            None,
        )],
        Default::default(),
    ))
}
