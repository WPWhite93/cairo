use core::{
    integer,
    integer::{
        BoundedInt, u128_sqrt, u128_wrapping_sub, u16_sqrt, u256_sqrt, u256_wide_mul, u32_sqrt,
        u512_safe_div_rem_by_u256, u512, u64_sqrt, u8_sqrt
    }
};
use core::test::test_utils::{assert_eq, assert_ne, assert_le, assert_lt, assert_gt, assert_ge};

#[test]
fn test_u8_operators() {
    assert_eq(@1_u8, @1_u8, '1 == 1');
    assert_ne(@1_u8, @2_u8, '1 != 2');
    assert_eq(@(1_u8 + 3_u8), @4_u8, '1 + 3 == 4');
    assert_eq(@(3_u8 + 6_u8), @9_u8, '3 + 6 == 9');
    assert_eq(@(3_u8 - 1_u8), @2_u8, '3 - 1 == 2');
    assert_eq(@(1_u8 * 3_u8), @3_u8, '1 * 3 == 3');
    assert_eq(@(2_u8 * 4_u8), @8_u8, '2 * 4 == 8');
    assert_eq(@(19_u8 / 7_u8), @2_u8, '19 / 7 == 2');
    assert_eq(@(19_u8 % 7_u8), @5_u8, '19 % 7 == 5');
    assert_eq(@(231_u8 - 131_u8), @100_u8, '231-131=100');
    assert_eq(@((1_u8 | 2_u8)), @3_u8, '1 | 2 == 3');
    assert_eq(@((1_u8 & 2_u8)), @0_u8, '1 & 2 == 0');
    assert_eq(@((1_u8 ^ 2_u8)), @3_u8, '1 ^ 2 == 3');
    assert_eq(@((2_u8 | 2_u8)), @2_u8, '2 | 2 == 2');
    assert_eq(@((2_u8 & 2_u8)), @2_u8, '2 & 2 == 2');
    assert_eq(@((2_u8 & 3_u8)), @2_u8, '2 & 3 == 2');
    assert_eq(@((3_u8 ^ 6_u8)), @5_u8, '3 ^ 6 == 5');
    assert_lt(1_u8, 4_u8, '1 < 4');
    assert_le(1_u8, 4_u8, '1 <= 4');
    assert(!(4_u8 < 4_u8), '!(4 < 4)');
    assert_le(5_u8, 5_u8, '5 <= 5');
    assert(!(5_u8 <= 4_u8), '!(5 <= 8)');
    assert_gt(5_u8, 2_u8, '5 > 2');
    assert_ge(5_u8, 2_u8, '5 >= 2');
    assert(!(3_u8 > 3_u8), '!(3 > 3)');
    assert_ge(3_u8, 3_u8, '3 >= 3');
    assert_eq(@u8_sqrt(9), @3, 'u8_sqrt(9) == 3');
    assert_eq(@u8_sqrt(10), @3, 'u8_sqrt(10) == 3');
    assert_eq(@u8_sqrt(0x40), @0x8, 'u8_sqrt(2^6) == 2^3');
    assert_eq(@u8_sqrt(0xff), @0xf, 'Wrong square root result.');
    assert_eq(@u8_sqrt(1), @1, 'u8_sqrt(1) == 1');
    assert_eq(@u8_sqrt(0), @0, 'u8_sqrt(0) == 0');
    assert_eq(@~0x00_u8, @0xff, '~0x00 == 0xff');
    assert_eq(@~0x81_u8, @0x7e, '~0x81 == 0x7e');
}

#[test]
#[should_panic]
fn test_u8_sub_overflow_1() {
    0_u8 - 1_u8;
}

#[test]
#[should_panic]
fn test_u8_sub_overflow_2() {
    0_u8 - 3_u8;
}

#[test]
#[should_panic]
fn test_u8_sub_overflow_3() {
    1_u8 - 3_u8;
}

#[test]
#[should_panic]
fn test_u8_sub_overflow_4() {
    100_u8 - 250_u8;
}

#[test]
#[should_panic]
fn test_u8_add_overflow_1() {
    128_u8 + 128_u8;
}

#[test]
#[should_panic]
fn test_u8_add_overflow_2() {
    200_u8 + 60_u8;
}

#[test]
#[should_panic]
fn test_u8_mul_overflow_1() {
    0x10_u8 * 0x10_u8;
}

#[test]
#[should_panic]
fn test_u8_mul_overflow_2() {
    0x11_u8 * 0x10_u8;
}

#[test]
#[should_panic]
fn test_u8_mul_overflow_3() {
    2_u8 * 0x80_u8;
}

#[test]
#[should_panic(expected: ('Division by 0',))]
fn test_u8_div_by_0() {
    2_u8 / 0_u8;
}

#[test]
#[should_panic]
fn test_u8_mod_by_0() {
    2_u8 % 0_u8;
}

#[test]
fn test_u16_operators() {
    assert_eq(@1_u16, @1_u16, '1 == 1');
    assert_ne(@1_u16, @2_u16, '1 != 2');
    assert_eq(@(1_u16 + 3_u16), @4_u16, '1 + 3 == 4');
    assert_eq(@(3_u16 + 6_u16), @9_u16, '3 + 6 == 9');
    assert_eq(@(3_u16 - 1_u16), @2_u16, '3 - 1 == 2');
    assert_eq(@(231_u16 - 131_u16), @100_u16, '231-131=100');
    assert_eq(@(1_u16 * 3_u16), @3_u16, '1 * 3 == 3');
    assert_eq(@(2_u16 * 4_u16), @8_u16, '2 * 4 == 8');
    assert_eq(@(51725_u16 / 7_u16), @7389_u16, '51725 / 7 == 7389');
    assert_eq(@(51725_u16 % 7_u16), @2_u16, '51725 % 7 == 2');
    assert_eq(@((1_u16 | 2_u16)), @3_u16, '1 | 2 == 3');
    assert_eq(@((1_u16 & 2_u16)), @0_u16, '1 & 2 == 0');
    assert_eq(@((1_u16 ^ 2_u16)), @3_u16, '1 ^ 2 == 3');
    assert_eq(@((2_u16 | 2_u16)), @2_u16, '2 | 2 == 2');
    assert_eq(@((2_u16 & 2_u16)), @2_u16, '2 & 2 == 2');
    assert_eq(@((2_u16 & 3_u16)), @2_u16, '2 & 3 == 2');
    assert_eq(@((3_u16 ^ 6_u16)), @5_u16, '3 ^ 6 == 5');
    assert_lt(1_u16, 4_u16, '1 < 4');
    assert_le(1_u16, 4_u16, '1 <= 4');
    assert(!(4_u16 < 4_u16), '!(4 < 4)');
    assert_le(4_u16, 4_u16, '4 <= 4');
    assert_gt(5_u16, 2_u16, '5 > 2');
    assert_ge(5_u16, 2_u16, '5 >= 2');
    assert(!(3_u16 > 3_u16), '!(3 > 3)');
    assert_ge(3_u16, 3_u16, '3 >= 3');
    assert_eq(@u16_sqrt(9), @3, 'u16_sqrt(9) == 3');
    assert_eq(@u16_sqrt(10), @3, 'u16_sqrt(10) == 3');
    assert_eq(@u16_sqrt(0x400), @0x20, 'u16_sqrt(2^10) == 2^5');
    assert_eq(@u16_sqrt(0xffff), @0xff, 'Wrong square root result.');
    assert_eq(@u16_sqrt(1), @1, 'u64_sqrt(1) == 1');
    assert_eq(@u16_sqrt(0), @0, 'u64_sqrt(0) == 0');
    assert_eq(@~0x0000_u16, @0xffff, '~0x0000 == 0xffff');
    assert_eq(@~0x8421_u16, @0x7bde, '~0x8421 == 0x7bde');
}

#[test]
#[should_panic]
fn test_u16_sub_overflow_1() {
    0_u16 - 1_u16;
}

#[test]
#[should_panic]
fn test_u16_sub_overflow_2() {
    0_u16 - 3_u16;
}

#[test]
#[should_panic]
fn test_u16_sub_overflow_3() {
    1_u16 - 3_u16;
}

#[test]
#[should_panic]
fn test_u16_sub_overflow_4() {
    100_u16 - 250_u16;
}

#[test]
#[should_panic]
fn test_u16_add_overflow_1() {
    0x8000_u16 + 0x8000_u16;
}

#[test]
#[should_panic]
fn test_u16_add_overflow_2() {
    0x9000_u16 + 0x8001_u16;
}

#[test]
#[should_panic]
fn test_u16_mul_overflow_1() {
    0x100_u16 * 0x100_u16;
}

#[test]
#[should_panic]
fn test_u16_mul_overflow_2() {
    0x101_u16 * 0x100_u16;
}

#[test]
#[should_panic]
fn test_u16_mul_overflow_3() {
    2_u16 * 0x8000_u16;
}

#[test]
#[should_panic(expected: ('Division by 0',))]
fn test_u16_div_by_0() {
    2_u16 / 0_u16;
}

#[test]
#[should_panic]
fn test_u16_mod_by_0() {
    0_u16 % 0_u16;
}

#[test]
fn test_u32_operators() {
    assert_eq(@1_u32, @1_u32, '1 == 1');
    assert_ne(@1_u32, @2_u32, '1 != 2');
    assert_eq(@(1_u32 + 3_u32), @4_u32, '1 + 3 == 4');
    assert_eq(@(3_u32 + 6_u32), @9_u32, '3 + 6 == 9');
    assert_eq(@(3_u32 - 1_u32), @2_u32, '3 - 1 == 2');
    assert_eq(@(231_u32 - 131_u32), @100_u32, '231-131=100');
    assert_eq(@(1_u32 * 3_u32), @3_u32, '1 * 3 == 3');
    assert_eq(@(2_u32 * 4_u32), @8_u32, '2 * 4 == 8');
    assert_eq(@(510670725_u32 / 7_u32), @72952960_u32, '510670725 / 7 == 72952960');
    assert_eq(@(510670725_u32 % 7_u32), @5_u32, '510670725 % 7 == 5');
    assert_eq(@((1_u32 | 2_u32)), @3_u32, '1 | 2 == 3');
    assert_eq(@((1_u32 & 2_u32)), @0_u32, '1 & 2 == 0');
    assert_eq(@((1_u32 ^ 2_u32)), @3_u32, '1 ^ 2 == 3');
    assert_eq(@((2_u32 | 2_u32)), @2_u32, '2 | 2 == 2');
    assert_eq(@((2_u32 & 2_u32)), @2_u32, '2 & 2 == 2');
    assert_eq(@((2_u32 & 3_u32)), @2_u32, '2 & 3 == 2');
    assert_eq(@((3_u32 ^ 6_u32)), @5_u32, '3 ^ 6 == 5');
    assert_lt(1_u32, 4_u32, '1 < 4');
    assert_le(1_u32, 4_u32, '1 <= 4');
    assert(!(4_u32 < 4_u32), '!(4 < 4)');
    assert_le(4_u32, 4_u32, '4 <= 4');
    assert_gt(5_u32, 2_u32, '5 > 2');
    assert_ge(5_u32, 2_u32, '5 >= 2');
    assert(!(3_u32 > 3_u32), '!(3 > 3)');
    assert_ge(3_u32, 3_u32, '3 >= 3');
    assert_eq(@u32_sqrt(9), @3, 'u32_sqrt(9) == 3');
    assert_eq(@u32_sqrt(10), @3, 'u32_sqrt(10) == 3');
    assert_eq(@u32_sqrt(0x100000), @0x400, 'u32_sqrt(2^20) == 2^10');
    assert_eq(@u32_sqrt(0xffffffff), @0xffff, 'Wrong square root result.');
    assert_eq(@u32_sqrt(1), @1, 'u64_sqrt(1) == 1');
    assert_eq(@u32_sqrt(0), @0, 'u64_sqrt(0) == 0');
    assert_eq(@~0x00000000_u32, @0xffffffff, '~0x00000000 == 0xffffffff');
    assert_eq(@~0x12345678_u32, @0xedcba987, '~0x12345678 == 0xedcba987');
}

#[test]
#[should_panic]
fn test_u32_sub_overflow_1() {
    0_u32 - 1_u32;
}

#[test]
#[should_panic]
fn test_u32_sub_overflow_2() {
    0_u32 - 3_u32;
}

#[test]
#[should_panic]
fn test_u32_sub_overflow_3() {
    1_u32 - 3_u32;
}

#[test]
#[should_panic]
fn test_u32_sub_overflow_4() {
    100_u32 - 250_u32;
}

#[test]
#[should_panic]
fn test_u32_add_overflow_1() {
    0x80000000_u32 + 0x80000000_u32;
}

#[test]
#[should_panic]
fn test_u32_add_overflow_2() {
    0x90000000_u32 + 0x80000001_u32;
}

#[test]
#[should_panic]
fn test_u32_mul_overflow_1() {
    0x10000_u32 * 0x10000_u32;
}

#[test]
#[should_panic]
fn test_u32_mul_overflow_2() {
    0x10001_u32 * 0x10000_u32;
}

#[test]
#[should_panic]
fn test_u32_mul_overflow_3() {
    2_u32 * 0x80000000_u32;
}

#[test]
#[should_panic(expected: ('Division by 0',))]
fn test_u32_div_by_0() {
    2_u32 / 0_u32;
}

#[test]
#[should_panic]
fn test_u32_mod_by_0() {
    0_u32 % 0_u32;
}

#[test]
fn test_u64_operators() {
    assert_eq(@1_u64, @1_u64, '1 == 1');
    assert_ne(@1_u64, @2_u64, '1 != 2');
    assert_eq(@(1_u64 + 3_u64), @4_u64, '1 + 3 == 4');
    assert_eq(@(3_u64 + 6_u64), @9_u64, '3 + 6 == 9');
    assert_eq(@(3_u64 - 1_u64), @2_u64, '3 - 1 == 2');
    assert_eq(@(231_u64 - 131_u64), @100_u64, '231-131=100');
    assert_eq(@(1_u64 * 3_u64), @3_u64, '1 * 3 == 3');
    assert_eq(@(2_u64 * 4_u64), @8_u64, '2 * 4 == 8');
    assert_eq(
        @(5010670477878974275_u64 / 7_u64), @715810068268424896_u64, 'Wrong division result.'
    );
    assert_eq(@(5010670477878974275_u64 % 7_u64), @3_u64, '5010670477878974275 % 7 == 3');
    assert_eq(@((1_u64 | 2_u64)), @3_u64, '1 | 2 == 3');
    assert_eq(@((1_u64 & 2_u64)), @0_u64, '1 & 2 == 0');
    assert_eq(@((1_u64 ^ 2_u64)), @3_u64, '1 ^ 2 == 3');
    assert_eq(@((2_u64 | 2_u64)), @2_u64, '2 | 2 == 2');
    assert_eq(@((2_u64 & 2_u64)), @2_u64, '2 & 2 == 2');
    assert_eq(@((2_u64 & 3_u64)), @2_u64, '2 & 3 == 2');
    assert_eq(@((3_u64 ^ 6_u64)), @5_u64, '3 ^ 6 == 5');
    assert_lt(1_u64, 4_u64, '1 < 4');
    assert_le(1_u64, 4_u64, '1 <= 4');
    assert(!(4_u64 < 4_u64), '!(4 < 4)');
    assert_le(4_u64, 4_u64, '4 <= 4');
    assert_gt(5_u64, 2_u64, '5 > 2');
    assert_ge(5_u64, 2_u64, '5 >= 2');
    assert(!(3_u64 > 3_u64), '!(3 > 3)');
    assert_ge(3_u64, 3_u64, '3 >= 3');
    assert_eq(@u64_sqrt(9), @3, 'u64_sqrt(9) == 3');
    assert_eq(@u64_sqrt(10), @3, 'u64_sqrt(10) == 3');
    assert_eq(@u64_sqrt(0x10000000000), @0x100000, 'u64_sqrt(2^40) == 2^20');
    assert_eq(@u64_sqrt(0xffffffffffffffff), @0xffffffff, 'Wrong square root result.');
    assert_eq(@u64_sqrt(1), @1, 'u64_sqrt(1) == 1');
    assert_eq(@u64_sqrt(0), @0, 'u64_sqrt(0) == 0');
    assert_eq(@~0x0000000000000000_u64, @0xffffffffffffffff, '~0x0..0 == 0xf..f');
    assert_eq(@~0x123456789abcdef1_u64, @0xedcba9876543210e, '~0x12..ef1 == 0xed..10e');
}

#[test]
#[should_panic]
fn test_u64_sub_overflow_1() {
    0_u64 - 1_u64;
}

#[test]
#[should_panic]
fn test_u64_sub_overflow_2() {
    0_u64 - 3_u64;
}

#[test]
#[should_panic]
fn test_u64_sub_overflow_3() {
    1_u64 - 3_u64;
}

#[test]
#[should_panic]
fn test_u64_sub_overflow_4() {
    100_u64 - 250_u64;
}

#[test]
#[should_panic]
fn test_u64_add_overflow_1() {
    0x8000000000000000_u64 + 0x8000000000000000_u64;
}

#[test]
#[should_panic]
fn test_u64_add_overflow_2() {
    0x9000000000000000_u64 + 0x8000000000000001_u64;
}

#[test]
#[should_panic]
fn test_u64_mul_overflow_1() {
    0x100000000_u64 * 0x100000000_u64;
}

#[test]
#[should_panic]
fn test_u64_mul_overflow_2() {
    0x100000001_u64 * 0x100000000_u64;
}

#[test]
#[should_panic]
fn test_u64_mul_overflow_3() {
    2_u64 * 0x8000000000000000_u64;
}

#[test]
#[should_panic(expected: ('Division by 0',))]
fn test_u64_div_by_0() {
    2_u64 / 0_u64;
}

#[test]
#[should_panic]
fn test_u64_mod_by_0() {
    0_u64 % 0_u64;
}

#[test]
fn test_u128_operators() {
    assert_eq(@1_u128, @1_u128, '1 == 1');
    assert_ne(@1_u128, @2_u128, '1 != 2');
    assert_eq(@(1_u128 + 3_u128), @4_u128, '1 + 3 == 4');
    assert_eq(@(3_u128 + 6_u128), @9_u128, '3 + 6 == 9');
    assert_eq(@(3_u128 - 1_u128), @2_u128, '3 - 1 == 2');
    assert_eq(@(1231_u128 - 231_u128), @1000_u128, '1231-231=1000');
    assert_eq(@(1_u128 * 3_u128), @3_u128, '1 * 3 == 3');
    assert_eq(@(2_u128 * 4_u128), @8_u128, '2 * 4 == 8');
    assert_eq(@(8_u128 / 2_u128), @4_u128, '8 / 2 == 4');
    assert_eq(@(8_u128 % 2_u128), @0_u128, '8 % 2 == 0');
    assert_eq(@(7_u128 / 3_u128), @2_u128, '7 / 3 == 2');
    assert_eq(@(7_u128 % 3_u128), @1_u128, '7 % 3 == 1');
    assert_lt(1_u128, 4_u128, '1 < 4');
    assert_le(1_u128, 4_u128, '1 <= 4');
    assert(!(4_u128 < 4_u128), '!(4 < 4)');
    assert_le(4_u128, 4_u128, '4 <= 4');
    assert_gt(5_u128, 2_u128, '5 > 2');
    assert_ge(5_u128, 2_u128, '5 >= 2');
    assert(!(3_u128 > 3_u128), '!(3 > 3)');
    assert_ge(3_u128, 3_u128, '3 >= 3');
    assert_eq(@((1_u128 | 2_u128)), @3_u128, '1 | 2 == 3');
    assert_eq(@((1_u128 & 2_u128)), @0_u128, '1 & 2 == 0');
    assert_eq(@((1_u128 ^ 2_u128)), @3_u128, '1 ^ 2 == 3');
    assert_eq(@((2_u128 | 2_u128)), @2_u128, '2 | 2 == 2');
    assert_eq(@((2_u128 & 2_u128)), @2_u128, '2 & 2 == 2');
    assert_eq(@((2_u128 & 3_u128)), @2_u128, '2 & 3 == 2');
    assert_eq(@((3_u128 ^ 6_u128)), @5_u128, '3 ^ 6 == 5');
    assert_eq(@u128_sqrt(9), @3, 'u128_sqrt(9) == 3');
    assert_eq(@u128_sqrt(10), @3, 'u128_sqrt(10) == 3');
    assert_eq(
        @u128_sqrt(0x10000000000000000000000000), @0x4000000000000, 'u128_sqrt(2^100) == 2^50'
    );
    assert_eq(
        @u128_sqrt(0xffffffffffffffffffffffffffffffff),
        @0xffffffffffffffff,
        'Wrong square root result.'
    );
    assert_eq(@u128_sqrt(1), @1, 'u128_sqrt(1) == 1');
    assert_eq(@u128_sqrt(0), @0, 'u128_sqrt(0) == 0');
    assert_eq(
        @~0x00000000000000000000000000000000_u128,
        @0xffffffffffffffffffffffffffffffff,
        '~0x0..0 == 0xf..f'
    );
    assert_eq(
        @~0x123456789abcdef123456789abcdef12_u128,
        @0xedcba9876543210edcba9876543210ed,
        '~0x12..ef12 == 0xed..10ed'
    );
}

fn pow_2_64() -> u128 {
    0x10000000000000000_u128
}

#[test]
#[should_panic]
fn test_u128_sub_overflow_1() {
    0_u128 - 1_u128;
}

#[test]
#[should_panic]
fn test_u128_sub_overflow_2() {
    0_u128 - 3_u128;
}

#[test]
#[should_panic]
fn test_u128_sub_overflow_3() {
    1_u128 - 3_u128;
}

#[test]
#[should_panic]
fn test_u128_sub_overflow_4() {
    100_u128 - 1000_u128;
}

#[test]
fn test_u128_wrapping_sub_1() {
    let max_u128: u128 = BoundedInt::max();
    let should_be_max = u128_wrapping_sub(0_u128, 1_u128);
    assert_eq(@max_u128, @should_be_max, 'Should be max u128')
}

#[test]
fn test_u128_wrapping_sub_2() {
    let max_u128_minus_two: u128 = BoundedInt::max() - 2;
    let should_be_max = u128_wrapping_sub(0_u128, 3_u128);
    assert_eq(@max_u128_minus_two, @should_be_max, 'Should be max u128 - 2')
}

#[test]
fn test_u128_wrapping_sub_3() {
    let max_u128_minus_899: u128 = BoundedInt::max() - 899;
    let should_be_max = u128_wrapping_sub(100, 1000);
    assert_eq(@max_u128_minus_899, @should_be_max, 'Should be max u128 - 899')
}

#[test]
fn test_u128_wrapping_sub_4() {
    let should_be_zero = u128_wrapping_sub(0_u128, 0_u128);
    assert_eq(@should_be_zero, @0, 'Should be 0')
}

#[test]
#[should_panic]
fn test_u128_add_overflow_1() {
    0x80000000000000000000000000000000_u128 + 0x80000000000000000000000000000000_u128;
}

#[test]
#[should_panic]
fn test_u128_add_overflow_2() {
    (0x80000000000000000000000000000000_u128 + 12_u128) + 0x80000000000000000000000000000000_u128;
}

#[test]
#[should_panic]
fn test_u128_mul_overflow_1() {
    pow_2_64() * pow_2_64();
}

#[test]
#[should_panic]
fn test_u128_mul_overflow_2() {
    (pow_2_64() + 1_u128) * pow_2_64();
}

#[test]
#[should_panic]
fn test_u128_mul_overflow_3() {
    2_u128 * 0x80000000000000000000000000000000_u128;
}

#[test]
#[should_panic(expected: ('Division by 0',))]
fn test_u128_div_by_0() {
    2_u128 / 0_u128;
}

#[test]
#[should_panic]
fn test_u128_mod_by_0() {
    2_u128 % 0_u128;
}

fn pow_2_127() -> u256 {
    0x80000000000000000000000000000000_u256
}

#[test]
fn test_u256_from_felt252() {
    assert_eq(@1.into(), @1_u256, 'into 1');
    assert_eq(
        @(170141183460469231731687303715884105728 * 2).into(),
        @0x100000000000000000000000000000000_u256,
        'into 2**128'
    );
}

#[test]
fn test_u256_operators() {
    let max_u128 = 0xffffffffffffffffffffffffffffffff_u256;
    assert_eq(
        @(0x100000000000000000000000000000001 + 0x300000000000000000000000000000002),
        @0x400000000000000000000000000000003_u256,
        'no Overflow'
    );
    assert_eq(
        @(0x180000000000000000000000000000000 + 0x380000000000000000000000000000000),
        @0x500000000000000000000000000000000_u256,
        'basic Overflow'
    );
    assert_eq(
        @(0x400000000000000000000000000000003 - 0x100000000000000000000000000000001),
        @0x300000000000000000000000000000002_u256,
        'no UF'
    );
    assert_eq(
        @(0x500000000000000000000000000000000 - 0x180000000000000000000000000000000),
        @0x380000000000000000000000000000000_u256,
        'basic UF'
    );
    assert_eq(
        @(0x400000000000000000000000000000003 * 1),
        @0x400000000000000000000000000000003_u256,
        'mul by 1'
    );
    assert_eq(
        @(0x400000000000000000000000000000003 * 2),
        @0x800000000000000000000000000000006_u256,
        'mul by 2'
    );
    assert_eq(
        @(0x80000000000000000000000000000000 * 2),
        @0x100000000000000000000000000000000_u256,
        'basic mul Overflow'
    );
    assert_eq(
        @(max_u128 * max_u128),
        @0xfffffffffffffffffffffffffffffffe00000000000000000000000000000001_u256,
        'max_u128 * max_u128'
    );
    assert_eq(@(max_u128 * 1), @max_u128, 'max_u128 * 1');
    assert_eq(@(1 * max_u128), @max_u128, '1 * max_u128');
    let v0_2: u256 = 0x000000000000000000000000000000002;
    let v0_3: u256 = 0x000000000000000000000000000000003;
    let v1_1: u256 = 0x100000000000000000000000000000001;
    let v1_2: u256 = 0x100000000000000000000000000000002;
    let v2_0: u256 = 0x200000000000000000000000000000000;
    let v2_1: u256 = 0x200000000000000000000000000000001;
    let v2_2: u256 = 0x200000000000000000000000000000002;
    let v2_3: u256 = 0x200000000000000000000000000000003;
    let v3_0: u256 = 0x300000000000000000000000000000000;
    let v3_2: u256 = 0x300000000000000000000000000000002;
    assert_eq(@(v1_2 | v2_2), @v3_2, '1.2|2.2==3.2');
    assert_eq(@(v2_1 | v2_2), @v2_3, '2.1|2.2==2.3');
    assert_eq(@(v2_2 | v1_2), @v3_2, '2.2|1.2==3.2');
    assert_eq(@(v2_2 | v2_1), @v2_3, '2.2|2.1==2.3');
    assert_eq(@(v1_2 & v2_2), @v0_2, '1.2&2.2==0.2');
    assert_eq(@(v2_1 & v2_2), @v2_0, '2.1&2.2==2.0');
    assert_eq(@(v2_2 & v1_2), @v0_2, '2.2&1.2==0.2');
    assert_eq(@(v2_2 & v2_1), @v2_0, '2.2&2.1==2.0');
    assert_eq(@(v1_2 ^ v2_2), @v3_0, '1.2^2.2==3.0');
    assert_eq(@(v2_1 ^ v2_2), @v0_3, '2.1^2.2==0.3');
    assert_eq(@(v2_2 ^ v1_2), @v3_0, '2.2^1.2==3.0');
    assert_eq(@(v2_2 ^ v2_1), @v0_3, '2.2^2.1==0.3');
    assert_lt(v1_2, v2_2, '1.2<2.2');
    assert_lt(v2_1, v2_2, '2.1<2.2');
    assert(!(v2_2 < v1_2), '2.2<1.2');
    assert(!(v2_2 < v2_1), '2.2<2.1');
    assert(!(v2_2 < v2_2), '2.2<2.2');
    assert_le(v1_2, v2_2, '1.2<=2.2');
    assert_le(v2_1, v2_2, '2.1<=2.2');
    assert(!(v2_2 <= v1_2), '2.2<=1.2');
    assert(!(v2_2 <= v2_1), '2.2<=2.1');
    assert_le(v2_2, v2_2, '2.2<=2.2');
    assert(!(v1_2 > v2_2), '1.2>2.2');
    assert(!(v2_1 > v2_2), '2.1>2.2');
    assert_gt(v2_2, v1_2, '2.2>1.2');
    assert_gt(v2_2, v2_1, '2.2>2.1');
    assert(!(v2_2 > v2_2), '2.2>2.2');
    assert(!(v1_2 >= v2_2), '1.2>=2.2');
    assert(!(v2_1 >= v2_2), '2.1>=2.2');
    assert_ge(v2_2, v1_2, '2.2>=1.2');
    assert_ge(v2_2, v2_1, '2.2>=2.1');
    assert_ge(v2_2, v2_2, '2.2>=2.2');

    assert_eq(@(v3_2 / v1_1), @v0_2, 'u256 div');
    assert_eq(
        @(0x400000000000000000000000000000002 / 3),
        @0x155555555555555555555555555555556_u256,
        'u256 div'
    );
    assert_eq(@(0x400000000000000000000000000000002 % 3), @0_u256, 'u256 mod');
    assert_eq(@(0x10000000000000000 / 0x10000000000000000), @1_u256, 'u256 div');
    assert_eq(@(0x10000000000000000 % 0x10000000000000000), @0_u256, 'u256 mod');
    assert_eq(
        @(0x1000000000000000000000000000000000000000000000000
            / 0x1000000000000000000000000000000000000000000000000),
        @1_u256,
        'u256 div'
    );
    assert_eq(
        @(0x1000000000000000000000000000000000000000000000000 % 0x1000000000000000000000000000000000000000000000000),
        @0_u256,
        'u256 mod'
    );
    assert_eq(@(BoundedInt::max() % 0x100000000), @0xffffffff_u256, 'u256 mod');
    assert_eq(@(BoundedInt::max() % 0x10000000000000000), @0xffffffffffffffff_u256, 'u256 mod');
    assert_eq(
        @(BoundedInt::max() / 0x10000000000000000000000000000000000000000),
        @0xffffffffffffffffffffffff_u256,
        'u256 div'
    );
    assert_eq(
        @(BoundedInt::max() / 0x1000000000000000000000000000000000000000000000000),
        @0xffffffffffffffff_u256,
        'u256 div'
    );
    assert_eq(
        @~max_u128,
        @0xffffffffffffffffffffffffffffffff00000000000000000000000000000000,
        '~0x0..0f..f == 0xf..f0..0'
    );
    assert_eq(
        @~0xffffffffffffffffffffffffffffffff00000000000000000000000000000000,
        @max_u128,
        '~0xf..f0..0 == 0x0..0f..f'
    );
}

#[test]
#[should_panic]
fn test_u256_add_overflow() {
    let v = 0x8000000000000000000000000000000000000000000000000000000000000001_u256;
    v + v;
}

#[test]
#[should_panic]
fn test_u256_sub_overflow() {
    0x100000000000000000000000000000001_u256 - 0x100000000000000000000000000000002;
}

#[test]
#[should_panic]
fn test_u256_mul_overflow_1() {
    0x100000000000000000000000000000001_u256 * 0x100000000000000000000000000000002;
}

#[test]
#[should_panic]
fn test_u256_mul_overflow_2() {
    pow_2_127() * 0x200000000000000000000000000000000;
}

#[test]
fn test_u256_wide_mul() {
    assert_eq(@u256_wide_mul(0, 0), @u512 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, '0 * 0 != 0');
    assert_eq(
        @u256_wide_mul(
            0x1001001001001001001001001001001001001001001001001001,
            0x1000100010001000100010001000100010001000100010001000100010001
        ),
        @u512 {
            limb0: 0x33233223222222122112111111011001,
            limb1: 0x54455445544554454444443443343333,
            limb2: 0x21222222322332333333433443444444,
            limb3: 0x1001101111112112
        },
        'long calculation failed'
    );
}

#[test]
fn test_u512_safe_div_rem_by_u256() {
    let zero = u512 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
    let one = u512 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 };
    let large_num = u512 {
        limb0: 0x33233223222222122112111111011001,
        limb1: 0x54455445544554454444443443343333,
        limb2: 0x21222222322332333333433443444444,
        limb3: 0x1001101111112112
    };
    let (q, r) = u512_safe_div_rem_by_u256(zero, 1_u256.try_into().unwrap());
    assert(q == zero, '0 / 1 != 0');
    assert(r == 0, '0 % 1 != 0');
    let (q, r) = u512_safe_div_rem_by_u256(one, 1_u256.try_into().unwrap());
    assert(q == one, '1 / 1 != 1');
    assert(r == 0, '1 % 1 != 0');
    let (q, r) = u512_safe_div_rem_by_u256(large_num, 1_u256.try_into().unwrap());
    assert(q == large_num, 'LARGE / 1 != LARGE');
    assert(r == 0, 'LARGE % 1 != 0');
    let (q, r) = u512_safe_div_rem_by_u256(
        large_num, 0x33233223222222122112111111011001_u256.try_into().unwrap()
    );
    assert(
        q == u512 {
            limb0: 0x365ec98ac1c2c57afaff780a20a0b2b1,
            limb1: 0xf3dfa68ede27c4236ef0c6eb66a8e0a2,
            limb2: 0x501e5b7ba7f4ec12,
            limb3: 0
        },
        'large div failed'
    );
    assert(r == 0x1e0eb905027d0150d2618bbd71844d50, 'large rem failed');
}

#[test]
fn test_u512_try_into_u256() {
    assert!(
        u512 { limb0: 1, limb1: 2, limb2: 0, limb3: 0 }
            .try_into() == Option::Some(0x200000000000000000000000000000001_u256)
    );
    assert!(u512 { limb0: 1, limb1: 2, limb2: 3, limb3: 0 }.try_into() == Option::<u256>::None);
    assert!(u512 { limb0: 1, limb1: 2, limb2: 0, limb3: 4 }.try_into() == Option::<u256>::None);
    assert!(u512 { limb0: 1, limb1: 2, limb2: 3, limb3: 4 }.try_into() == Option::<u256>::None);
}

#[test]
fn test_min() {
    let min_u8: u8 = BoundedInt::min();
    let min_u16: u16 = BoundedInt::min();
    let min_u32: u32 = BoundedInt::min();
    let min_u64: u64 = BoundedInt::min();
    let min_u128: u128 = BoundedInt::min();
    let min_u256: u256 = BoundedInt::min();
    assert_eq(@min_u8, @0_u8, 'not zero');
    assert_eq(@min_u16, @0_u16, 'not zero');
    assert_eq(@min_u32, @0_u32, 'not zero');
    assert_eq(@min_u64, @0_u64, 'not zero');
    assert_eq(@min_u128, @0_u128, 'not zero');
    assert_eq(@min_u256, @0_u256, 'not zero');
}

#[test]
fn test_max() {
    let max_u8: u8 = BoundedInt::max();
    let max_u16: u16 = BoundedInt::max();
    let max_u32: u32 = BoundedInt::max();
    let max_u64: u64 = BoundedInt::max();
    let max_u128: u128 = BoundedInt::max();
    let max_u256: u256 = BoundedInt::max();
    assert_eq(@max_u8, @0xff_u8, 'not max');
    assert_eq(@max_u16, @0xffff_u16, 'not max');
    assert_eq(@max_u32, @0xffffffff_u32, 'not max');
    assert_eq(@max_u64, @0xffffffffffffffff_u64, 'not max');
    assert_eq(@max_u128, @0xffffffffffffffffffffffffffffffff_u128, 'not max');
    assert_eq(
        @max_u256,
        @0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff_u256,
        'not max'
    );
}

#[test]
#[should_panic]
fn test_max_u8_plus_1_overflow() {
    BoundedInt::max() + 1_u8;
}

#[test]
#[should_panic]
fn test_max_u16_plus_1_overflow() {
    BoundedInt::max() + 1_u16;
}

#[test]
#[should_panic]
fn test_max_u32_plus_1_overflow() {
    BoundedInt::max() + 1_u32;
}
#[test]
#[should_panic]
fn test_max_u64_plus_1_overflow() {
    BoundedInt::max() + 1_u64;
}

#[test]
#[should_panic]
fn test_max_u128_plus_1_overflow() {
    BoundedInt::max() + 1_u128;
}

#[test]
#[should_panic]
fn test_max_u256_plus_1_overflow() {
    BoundedInt::max() + Into::<felt252, u256>::into(1);
}

#[test]
fn test_default_values() {
    assert_eq(@Default::default(), @0, '0 == 0');
    assert_eq(@Default::default(), @0_u8, '0 == 0');
    assert_eq(@Default::default(), @0_u16, '0 == 0');
    assert_eq(@Default::default(), @0_u32, '0 == 0');
    assert_eq(@Default::default(), @0_u64, '0 == 0');
    assert_eq(@Default::default(), @0_u128, '0 == 0');
    assert_eq(@Default::default(), @0_u256, '0 == 0');
    assert_eq(@Default::default(), @0_i8, '0 == 0');
    assert_eq(@Default::default(), @0_i16, '0 == 0');
    assert_eq(@Default::default(), @0_i32, '0 == 0');
    assert_eq(@Default::default(), @0_i64, '0 == 0');
    assert_eq(@Default::default(), @0_i128, '0 == 0');
}

#[test]
fn test_default_felt252dict_values() {
    assert_eq(@Felt252DictValue::zero_default(), @0, '0 == 0');
    assert_eq(@Felt252DictValue::zero_default(), @0_u8, '0 == 0');
    assert_eq(@Felt252DictValue::zero_default(), @0_u16, '0 == 0');
    assert_eq(@Felt252DictValue::zero_default(), @0_u32, '0 == 0');
    assert_eq(@Felt252DictValue::zero_default(), @0_u64, '0 == 0');
    assert_eq(@Felt252DictValue::zero_default(), @0_u128, '0 == 0');
}

#[test]
fn test_u256_sqrt() {
    assert_eq(@u256_sqrt(9.into()), @3, 'u256_sqrt(9) == 3');
    assert_eq(@u256_sqrt(10.into()), @3, 'u256_sqrt(10) == 3');
    assert_eq(
        @u256_sqrt(1267650600228229401496703205376.into()),
        @1125899906842624,
        'u256_sqrt(2^100) == 2^50'
    );
    assert_eq(
        @u256_sqrt(340282366920938463463374607431768211455.into()),
        @18446744073709551615,
        'Wrong square root result.'
    );
    assert_eq(@u256_sqrt(1.into()), @1, 'u256_sqrt(1) == 1');
    assert_eq(@u256_sqrt(0.into()), @0, 'u256_sqrt(0) == 0');

    assert_eq(@u256_sqrt(BoundedInt::max()), @BoundedInt::max(), 'u256::MAX**0.5==u128::MAX');
    let (high, low) = integer::u128_wide_mul(BoundedInt::max(), BoundedInt::max());
    assert_eq(@u256_sqrt(u256 { low, high }), @BoundedInt::max(), '(u128::MAX**2)**0.5==u128::MAX');
}

#[test]
fn test_u256_try_into_felt252() {
    assert_eq(@1_u256.try_into().unwrap(), @1_felt252, '1 == 1'_felt252);
    assert_eq(
        @0x800000000000011000000000000000000000000000000000000000000000000_u256.try_into().unwrap(),
        @0x800000000000011000000000000000000000000000000000000000000000000_felt252,
        'P-1 == P-1'_felt252
    );
    assert_eq(
        @0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffff_u256.try_into().unwrap(),
        @0x800000000000010ffffffffffffffffffffffffffffffffffffffffffffffff_felt252,
        'P-2 == P-2'_felt252
    );
    let f: Option<felt252> = 0x800000000000011000000000000000000000000000000000000000000000001_u256
        .try_into();
    assert(f.is_none(), 'prime is not felt252');
    let f: Option<felt252> = 0x800000000000011000000000000000000000000000000000000000000000002_u256
        .try_into();
    assert(f.is_none(), 'prime+1 is not felt252');
    let f: Option<felt252> = 0x800000000000011000000000000000100000000000000000000000000000001_u256
        .try_into();
    assert(f.is_none(), 'prime+2**128 is not felt252');
}

/// Checks if `b` is out of range of `A`.
fn is_out_of_range<A, B, +Drop<A>, +TryInto<B, A>>(b: B) -> bool {
    let no_a: Option<A> = b.try_into();
    no_a.is_none()
}

/// Checks if `SubType` is trivially castable to `SuperType`.
fn cast_subtype_valid<
    SubType,
    SuperType,
    +Drop<SubType>,
    +Drop<SuperType>,
    +Copy<SubType>,
    +Copy<SuperType>,
    +BoundedInt<SubType>,
    +PartialEq<SubType>,
    +PartialEq<SuperType>,
    +Into<SubType, SuperType>,
    +TryInto<SuperType, SubType>
>() -> bool {
    let max_sub: SubType = BoundedInt::max();
    let max_sub_as_super: SuperType = max_sub.into();
    let min_sub: SubType = BoundedInt::min();
    let min_sub_as_super: SuperType = min_sub.into();
    min_sub_as_super.try_into().unwrap() == min_sub
        && max_sub_as_super.try_into().unwrap() == max_sub
}

/// Checks that `A::max()` is castable to `B`, and `A::max() + 1` is in `B`s range, and not
/// castable back to `A`.
fn validate_max_strictly_contained<
    A,
    B,
    +Drop<A>,
    +Drop<B>,
    +Copy<A>,
    +Copy<B>,
    +Add<B>,
    +BoundedInt<A>,
    +PartialEq<A>,
    +PartialEq<B>,
    +TryInto<A, B>,
    +TryInto<B, A>,
    +TryInto<felt252, B>
>(
    err: felt252
) {
    let max_a: A = BoundedInt::max();
    let max_a_as_b: B = max_a.try_into().expect(err);
    assert(Option::Some(max_a) == max_a_as_b.try_into(), err);
    assert(is_out_of_range::<A>(max_a_as_b + 1.try_into().unwrap()), err);
}

/// Checks that `A::min()` is castable to `B`, and `A::min() - 1` is in `B`s range, and not
/// castable back to `A`.
fn validate_min_strictly_contained<
    A,
    B,
    +Drop<A>,
    +Drop<B>,
    +Copy<A>,
    +Copy<B>,
    +Sub<B>,
    +BoundedInt<A>,
    +PartialEq<A>,
    +PartialEq<B>,
    +TryInto<A, B>,
    +TryInto<B, A>,
    +TryInto<felt252, B>
>(
    err: felt252
) {
    let min_sub: A = BoundedInt::min();
    let min_sub_as_super: B = min_sub.try_into().expect(err);
    assert(Option::Some(min_sub) == min_sub_as_super.try_into(), err);
    assert(is_out_of_range::<A>(min_sub_as_super - 1.try_into().unwrap()), err);
}

/// Checks that castings from `SubType` to `SuperType` are correct around the bounds, where
/// `SubType` is strictly contained (in both bounds) in `SuperType`.
fn validate_cast_bounds_strictly_contained<
    SubType,
    SuperType,
    +Drop<SubType>,
    +Drop<SuperType>,
    +Copy<SubType>,
    +Copy<SuperType>,
    +Add<SuperType>,
    +Sub<SuperType>,
    +BoundedInt<SubType>,
    +PartialEq<SubType>,
    +PartialEq<SuperType>,
    +Into<SubType, SuperType>,
    +TryInto<SuperType, SubType>,
    +TryInto<felt252, SuperType>
>(
    err: felt252
) {
    assert(cast_subtype_valid::<SubType, SuperType>(), err);
    validate_min_strictly_contained::<SubType, SuperType>(err);
    validate_max_strictly_contained::<SubType, SuperType>(err);
}

/// Checks that castings from `SubType` to `SuperType` are correct around the bounds, where
/// `SubType` has the same min as `SuperType`, but has a lower max.
fn validate_cast_bounds_contained_same_min<
    SubType,
    SuperType,
    +Drop<SubType>,
    +Drop<SuperType>,
    +Copy<SubType>,
    +Copy<SuperType>,
    +Add<SuperType>,
    +Sub<SuperType>,
    +BoundedInt<SubType>,
    +BoundedInt<SuperType>,
    +PartialEq<SubType>,
    +PartialEq<SuperType>,
    +Into<SubType, SuperType>,
    +TryInto<SuperType, SubType>,
    +TryInto<felt252, SuperType>
>(
    err: felt252
) {
    assert(cast_subtype_valid::<SubType, SuperType>(), err);
    assert(BoundedInt::<SubType>::min().into() == BoundedInt::<SuperType>::min(), err);
    validate_max_strictly_contained::<SubType, SuperType>(err);
}

/// Checks that castings from `A` to `B` are correct around the bounds.
/// Assumes that the ordering of the bounds is: `a_min < b_min < a_max < b_max`.
fn validate_cast_bounds_overlapping<
    A,
    B,
    +Drop<A>,
    +Drop<B>,
    +Copy<A>,
    +Copy<B>,
    +Sub<A>,
    +Add<B>,
    +BoundedInt<A>,
    +BoundedInt<B>,
    +PartialEq<A>,
    +PartialEq<B>,
    +TryInto<A, B>,
    +TryInto<B, A>,
    +TryInto<felt252, A>,
    +TryInto<felt252, B>
>(
    err: felt252
) {
    validate_min_strictly_contained::<B, A>(err);
    validate_max_strictly_contained::<A, B>(err);
}

#[test]
fn proper_cast() {
    validate_cast_bounds_contained_same_min::<u8, u16>('u8 u16 casts');
    validate_cast_bounds_contained_same_min::<u8, u32>('u8 u32 casts');
    validate_cast_bounds_contained_same_min::<u8, u64>('u8 u64 casts');
    validate_cast_bounds_contained_same_min::<u8, u128>('u8 u128 casts');
    validate_cast_bounds_contained_same_min::<u16, u32>('u16 u32 casts');
    validate_cast_bounds_contained_same_min::<u16, u64>('u16 u64 casts');
    validate_cast_bounds_contained_same_min::<u16, u128>('u16 u128 casts');
    validate_cast_bounds_contained_same_min::<u32, u64>('u32 u64 casts');
    validate_cast_bounds_contained_same_min::<u32, u128>('u32 u128 casts');
    validate_cast_bounds_contained_same_min::<u64, u128>('u64 u128 casts');

    validate_cast_bounds_strictly_contained::<u8, i16>('u8 i16 casts');
    validate_cast_bounds_strictly_contained::<u8, i32>('u8 i32 casts');
    validate_cast_bounds_strictly_contained::<u8, i64>('u8 i64 casts');
    validate_cast_bounds_strictly_contained::<u8, i128>('u8 i128 casts');
    validate_cast_bounds_strictly_contained::<u16, i32>('u16 i32 casts');
    validate_cast_bounds_strictly_contained::<u16, i64>('u16 i64 casts');
    validate_cast_bounds_strictly_contained::<u16, i128>('u16 i128 casts');
    validate_cast_bounds_strictly_contained::<u32, i64>('u32 i64 casts');
    validate_cast_bounds_strictly_contained::<u32, i128>('u32 i128 casts');
    validate_cast_bounds_strictly_contained::<u64, i128>('u64 i128 casts');

    validate_cast_bounds_strictly_contained::<i8, i16>('i8 i16 casts');
    validate_cast_bounds_strictly_contained::<i8, i32>('i8 i32 casts');
    validate_cast_bounds_strictly_contained::<i8, i64>('i8 i64 casts');
    validate_cast_bounds_strictly_contained::<i8, i128>('i8 i128 casts');
    validate_cast_bounds_strictly_contained::<i16, i32>('i16 i32 casts');
    validate_cast_bounds_strictly_contained::<i16, i64>('i16 i64 casts');
    validate_cast_bounds_strictly_contained::<i16, i128>('i16 i128 casts');
    validate_cast_bounds_strictly_contained::<i32, i64>('i32 i64 casts');
    validate_cast_bounds_strictly_contained::<i32, i128>('i32 i128 casts');
    validate_cast_bounds_strictly_contained::<i64, i128>('i64 i128 casts');

    validate_cast_bounds_overlapping::<i8, u8>('i8 u8 casts');
    validate_cast_bounds_overlapping::<i8, u16>('i8 u16 casts');
    validate_cast_bounds_overlapping::<i8, u32>('i8 u32 casts');
    validate_cast_bounds_overlapping::<i8, u64>('i8 u64 casts');
    validate_cast_bounds_overlapping::<i8, u128>('i8 u128 casts');
    validate_cast_bounds_overlapping::<i16, u16>('i16 u16 casts');
    validate_cast_bounds_overlapping::<i16, u32>('i16 u32 casts');
    validate_cast_bounds_overlapping::<i16, u64>('i16 u64 casts');
    validate_cast_bounds_overlapping::<i16, u128>('i16 u128 casts');
    validate_cast_bounds_overlapping::<i32, u32>('i32 u32 casts');
    validate_cast_bounds_overlapping::<i32, u64>('i32 u64 casts');
    validate_cast_bounds_overlapping::<i32, u128>('i32 u128 casts');
    validate_cast_bounds_overlapping::<i64, u64>('i64 u64 casts');
    validate_cast_bounds_overlapping::<i64, u128>('i64 u128 casts');
    validate_cast_bounds_overlapping::<i128, u128>('i128 u128 casts');
}

#[test]
fn test_into_self_type() {
    assert_eq(@0xFF_u8.into(), @0xFF_u8, 'u8 into u8');
    assert_eq(@0xFFFF_u16.into(), @0xFFFF_u16, 'u16 into u16');
    assert_eq(@0xFFFFFFFF_u32.into(), @0xFFFFFFFF_u32, 'u32 into u32');
    assert_eq(@0xFFFFFFFFFFFFFFFF_u64.into(), @0xFFFFFFFFFFFFFFFF_u64, 'u64 into u64');
    assert_eq(
        @0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF_u128.into(),
        @0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF_u128,
        'u128 into u128'
    );
    assert_eq(
        @u256 { low: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, high: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF }
            .into(),
        @u256 { high: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, low: 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF },
        'u256 into u256'
    );
}

#[test]
#[should_panic]
fn panic_u16_u8_1() {
    let _out: u8 = (0xFF_u16 + 1_u16).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u16_u8_2() {
    let max_u16: u16 = 0xFFFF;
    let _out: u8 = max_u16.try_into().unwrap();
}
#[test]
#[should_panic]
fn panic_u32_u8_1() {
    let _out: u8 = (0xFF_u32 + 1_u32).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u32_u8_2() {
    let max_u32: u32 = 0xFFFFFFFF;
    let _out: u8 = max_u32.try_into().unwrap();
}
#[test]
#[should_panic]
fn panic_u64_u8_1() {
    let _out: u8 = (0xFF_u64 + 1_u64).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u64_u8_2() {
    let max_u64: u64 = 0xFFFFFFFFFFFFFFFF;
    let _out: u8 = max_u64.try_into().unwrap();
}
#[test]
#[should_panic]
fn panic_u128_u8_1() {
    let _out: u8 = (0xFF_u128 + 1_u128).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u128_u8_2() {
    let max_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    let _out: u8 = max_u128.try_into().unwrap();
}
#[test]
#[should_panic]
fn panic_u32_u16_1() {
    let _out: u16 = (0xFFFF_u32 + 1_u32).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u32_u16_2() {
    let max_u32: u32 = 0xFFFFFFFF;
    let _out: u16 = max_u32.try_into().unwrap();
}
#[test]
#[should_panic]
fn panic_u64_u16_1() {
    let _out: u16 = (0xFFFF_u64 + 1_u64).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u64_u16_2() {
    let max_u64: u64 = 0xFFFFFFFFFFFFFFFF;
    let _out: u16 = max_u64.try_into().unwrap();
}
#[test]
#[should_panic]
fn panic_u128_u16_1() {
    let _out: u16 = (0xFFFF_u128 + 1_u128).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u128_u16_2() {
    let max_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    let _out: u16 = max_u128.try_into().unwrap();
}
#[test]
#[should_panic]
fn panic_u64_u32_1() {
    let _out: u32 = (0xFFFFFFFF_u64 + 1_u64).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u64_u32_2() {
    let max_u64: u64 = 0xFFFFFFFFFFFFFFFF;
    let _out: u32 = max_u64.try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u128_u32_1() {
    let _out: u32 = (0xFFFFFFFF_u128 + 1_u128).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u128_u32_2() {
    let max_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    let _out: u32 = max_u128.try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u128_u64_1() {
    let _out: u64 = (0xFFFFFFFFFFFFFFFF_u128 + 1_u128).try_into().unwrap();
}

#[test]
#[should_panic]
fn panic_u128_u64_2() {
    let max_u128: u128 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    let _out: u64 = max_u128.try_into().unwrap();
}

#[test]
fn test_u128_byte_reverse() {
    assert_eq(
        @integer::u128_byte_reverse(0x000102030405060708090a0b0c0d0e0f),
        @0x0f0e0d0c0b0a09080706050403020100,
        'Wrong byte reverse'
    );
}

#[test]
fn test_i8_operators() {
    assert_eq(@1_i8, @1_i8, '1 == 1');
    assert_ne(@1_i8, @2_i8, '1 != 2');
    assert_eq(@0x7f_felt252.try_into().unwrap(), @0x7f_i8, '0x7f is not i8');
    let v: Option<i8> = 0x80_felt252.try_into();
    assert(v.is_none(), '0x80 is i8');
    assert_eq(@(-0x80_felt252).try_into().unwrap(), @-0x80_i8, '-0x80 is not i8');
    let v: Option<i8> = (-0x81_felt252).try_into();
    assert(v.is_none(), '-0x81 is i8');
    assert_eq(@(1_i8 + 3_i8), @4_i8, '1 + 3 == 4');
    assert_eq(@(3_i8 + 6_i8), @9_i8, '3 + 6 == 9');
    assert_eq(@(3_i8 - 1_i8), @2_i8, '3 - 1 == 2');
    assert_eq(@(121_i8 - 21_i8), @100_i8, '121-21=100');
    assert_eq(@(-1_i8 + -3_i8), @-4_i8, '-1 + -3 == -4');
    assert_eq(@(-3_i8 + -6_i8), @-9_i8, '-3 + -6 == -9');
    assert_eq(@(-3_i8 - -1_i8), @-2_i8, '-3 - -1 == -2');
    assert_eq(@(-121_i8 - -21_i8), @-100_i8, '-121--21=-100');
    assert_eq(@(1_i8 * 3_i8), @3_i8, '1 * 3 == 3');
    assert_eq(@(2_i8 * 4_i8), @8_i8, '2 * 4 == 8');
    assert_eq(@(-1_i8 * 3_i8), @-3_i8, '-1 * 3 == 3');
    assert_eq(@(-2_i8 * 4_i8), @-8_i8, '-2 * 4 == 8');
    assert_eq(@(1_i8 * -3_i8), @-3_i8, '1 * -3 == -3');
    assert_eq(@(2_i8 * -4_i8), @-8_i8, '2 * -4 == -8');
    assert_eq(@(-1_i8 * -3_i8), @3_i8, '-1 * -3 == 3');
    assert_eq(@(-2_i8 * -4_i8), @8_i8, '-2 * -4 == 8');
    assert_lt(1_i8, 4_i8, '1 < 4');
    assert_le(1_i8, 4_i8, '1 <= 4');
    assert(!(4_i8 < 4_i8), '!(4 < 4)');
    assert_le(5_i8, 5_i8, '5 <= 5');
    assert(!(5_i8 <= 4_i8), '!(5 <= 8)');
    assert_gt(5_i8, 2_i8, '5 > 2');
    assert_ge(5_i8, 2_i8, '5 >= 2');
    assert(!(3_i8 > 3_i8), '!(3 > 3)');
    assert_ge(3_i8, 3_i8, '3 >= 3');
}

#[test]
#[should_panic(expected: ('i8_sub Underflow',))]
fn test_i8_sub_underflow_1() {
    -0x80_i8 - 1_i8;
}

#[test]
#[should_panic(expected: ('i8_sub Underflow',))]
fn test_i8_sub_underflow_2() {
    -0x80_i8 - 3_i8;
}

#[test]
#[should_panic(expected: ('i8_sub Underflow',))]
fn test_i8_sub_underflow_3() {
    -0x7f_i8 - 3_i8;
}

#[test]
#[should_panic(expected: ('i8_sub Underflow',))]
fn test_i8_sub_underflow_4() {
    -0x32_i8 - 0x7d_i8;
}

#[test]
#[should_panic(expected: ('i8_sub Overflow',))]
fn test_i8_sub_overflow() {
    0x32_i8 - -0x7d_i8;
}

#[test]
#[should_panic(expected: ('i8_add Overflow',))]
fn test_i8_add_overflow_1() {
    0x40_i8 + 0x40_i8;
}

#[test]
#[should_panic(expected: ('i8_add Overflow',))]
fn test_i8_add_overflow_2() {
    0x64_i8 + 0x1e_i8;
}

#[test]
#[should_panic(expected: ('i8_add Underflow',))]
fn test_i8_add_underflow() {
    -0x64_i8 + -0x1e_i8;
}

#[test]
#[should_panic]
fn test_i8_mul_overflow_1() {
    0x10_i8 * 0x10_i8;
}

#[test]
#[should_panic]
fn test_i8_mul_overflow_2() {
    0x11_i8 * 0x10_i8;
}

#[test]
#[should_panic]
fn test_i8_mul_overflow_3() {
    2_i8 * 0x40_i8;
}

#[test]
fn test_i16_operators() {
    assert_eq(@1_i16, @1_i16, '1 == 1');
    assert_ne(@1_i16, @2_i16, '1 != 2');
    assert_eq(@0x7fff_felt252.try_into().unwrap(), @0x7fff_i16, '0x7fff is not i16');
    let v: Option<i16> = 0x8000_felt252.try_into();
    assert(v.is_none(), '0x8000 is i16');
    assert_eq(@(-0x8000_felt252).try_into().unwrap(), @-0x8000_i16, '-0x8000 is not i16');
    let v: Option<i16> = (-0x8001_felt252).try_into();
    assert(v.is_none(), '-0x8001 is i16');
    assert_eq(@(1_i16 + 3_i16), @4_i16, '1 + 3 == 4');
    assert_eq(@(3_i16 + 6_i16), @9_i16, '3 + 6 == 9');
    assert_eq(@(3_i16 - 1_i16), @2_i16, '3 - 1 == 2');
    assert_eq(@(231_i16 - 131_i16), @100_i16, '231-131=100');
    assert_eq(@(-1_i16 + -3_i16), @-4_i16, '-1 + -3 == -4');
    assert_eq(@(-3_i16 + -6_i16), @-9_i16, '-3 + -6 == -9');
    assert_eq(@(-3_i16 - -1_i16), @-2_i16, '-3 - -1 == -2');
    assert_eq(@(-231_i16 - -131_i16), @-100_i16, '-231--131=-100');
    assert_eq(@(1_i16 * 3_i16), @3_i16, '1 * 3 == 3');
    assert_eq(@(2_i16 * 4_i16), @8_i16, '2 * 4 == 8');
    assert_eq(@(-1_i16 * 3_i16), @-3_i16, '-1 * 3 == 3');
    assert_eq(@(-2_i16 * 4_i16), @-8_i16, '-2 * 4 == 8');
    assert_eq(@(1_i16 * -3_i16), @-3_i16, '1 * -3 == -3');
    assert_eq(@(2_i16 * -4_i16), @-8_i16, '2 * -4 == -8');
    assert_eq(@(-1_i16 * -3_i16), @3_i16, '-1 * -3 == 3');
    assert_eq(@(-2_i16 * -4_i16), @8_i16, '-2 * -4 == 8');
    assert_lt(1_i16, 4_i16, '1 < 4');
    assert_le(1_i16, 4_i16, '1 <= 4');
    assert(!(4_i16 < 4_i16), '!(4 < 4)');
    assert_le(5_i16, 5_i16, '5 <= 5');
    assert(!(5_i16 <= 4_i16), '!(5 <= 8)');
    assert_gt(5_i16, 2_i16, '5 > 2');
    assert_ge(5_i16, 2_i16, '5 >= 2');
    assert(!(3_i16 > 3_i16), '!(3 > 3)');
    assert_ge(3_i16, 3_i16, '3 >= 3');
}

#[test]
#[should_panic(expected: ('i16_sub Underflow',))]
fn test_i16_sub_underflow_1() {
    -0x8000_i16 - 1_i16;
}

#[test]
#[should_panic(expected: ('i16_sub Underflow',))]
fn test_i16_sub_underflow_2() {
    -0x8000_i16 - 3_i16;
}

#[test]
#[should_panic(expected: ('i16_sub Underflow',))]
fn test_i16_sub_underflow_3() {
    -0x7fff_i16 - 3_i16;
}

#[test]
#[should_panic(expected: ('i16_sub Underflow',))]
fn test_i16_sub_underflow_4() {
    -0x3200_i16 - 0x7d00_i16;
}

#[test]
#[should_panic(expected: ('i16_sub Overflow',))]
fn test_i16_sub_overflow() {
    0x3200_i16 - -0x7d00_i16;
}

#[test]
#[should_panic(expected: ('i16_add Overflow',))]
fn test_i16_add_overflow_1() {
    0x4000_i16 + 0x4000_i16;
}

#[test]
#[should_panic(expected: ('i16_add Overflow',))]
fn test_i16_add_overflow_2() {
    0x6400_i16 + 0x1e00_i16;
}

#[test]
#[should_panic(expected: ('i16_add Underflow',))]
fn test_i16_add_underflow() {
    -0x6400_i16 + -0x1e00_i16;
}

#[test]
#[should_panic]
fn test_i16_mul_overflow_1() {
    0x1000_i16 * 0x1000_i16;
}

#[test]
#[should_panic]
fn test_i16_mul_overflow_2() {
    0x1100_i16 * 0x1000_i16;
}

#[test]
#[should_panic]
fn test_i16_mul_overflow_3() {
    2_i16 * 0x4000_i16;
}

#[test]
fn test_i32_operators() {
    assert_eq(@1_i32, @1_i32, '1 == 1');
    assert_ne(@1_i32, @2_i32, '1 != 2');
    assert_eq(@0x7fffffff_felt252.try_into().unwrap(), @0x7fffffff_i32, '0x7fffffff is not i32');
    let v: Option<i32> = 0x80000000_felt252.try_into();
    assert(v.is_none(), '0x80000000 is i32');
    assert_eq(@(-0x80000000_felt252).try_into().unwrap(), @-0x80000000_i32, '-0x8000 is not i32');
    let v: Option<i32> = (-0x80000001_felt252).try_into();
    assert(v.is_none(), '-0x80000001 is i32');
    assert_eq(@(1_i32 + 3_i32), @4_i32, '1 + 3 == 4');
    assert_eq(@(3_i32 + 6_i32), @9_i32, '3 + 6 == 9');
    assert_eq(@(3_i32 - 1_i32), @2_i32, '3 - 1 == 2');
    assert_eq(@(231_i32 - 131_i32), @100_i32, '231-131=100');
    assert_eq(@(-1_i32 + -3_i32), @-4_i32, '-1 + -3 == -4');
    assert_eq(@(-3_i32 + -6_i32), @-9_i32, '-3 + -6 == -9');
    assert_eq(@(-3_i32 - -1_i32), @-2_i32, '-3 - -1 == -2');
    assert_eq(@(-231_i32 - -131_i32), @-100_i32, '-231--131=-100');
    assert_eq(@(1_i32 * 3_i32), @3_i32, '1 * 3 == 3');
    assert_eq(@(2_i32 * 4_i32), @8_i32, '2 * 4 == 8');
    assert_eq(@(-1_i32 * 3_i32), @-3_i32, '-1 * 3 == 3');
    assert_eq(@(-2_i32 * 4_i32), @-8_i32, '-2 * 4 == 8');
    assert_eq(@(1_i32 * -3_i32), @-3_i32, '1 * -3 == -3');
    assert_eq(@(2_i32 * -4_i32), @-8_i32, '2 * -4 == -8');
    assert_eq(@(-1_i32 * -3_i32), @3_i32, '-1 * -3 == 3');
    assert_eq(@(-2_i32 * -4_i32), @8_i32, '-2 * -4 == 8');
    assert_lt(1_i32, 4_i32, '1 < 4');
    assert_le(1_i32, 4_i32, '1 <= 4');
    assert(!(4_i32 < 4_i32), '!(4 < 4)');
    assert_le(5_i32, 5_i32, '5 <= 5');
    assert(!(5_i32 <= 4_i32), '!(5 <= 8)');
    assert_gt(5_i32, 2_i32, '5 > 2');
    assert_ge(5_i32, 2_i32, '5 >= 2');
    assert(!(3_i32 > 3_i32), '!(3 > 3)');
    assert_ge(3_i32, 3_i32, '3 >= 3');
}

#[test]
#[should_panic(expected: ('i32_sub Underflow',))]
fn test_i32_sub_underflow_1() {
    -0x80000000_i32 - 1_i32;
}

#[test]
#[should_panic(expected: ('i32_sub Underflow',))]
fn test_i32_sub_underflow_2() {
    -0x80000000_i32 - 3_i32;
}

#[test]
#[should_panic(expected: ('i32_sub Underflow',))]
fn test_i32_sub_underflow_3() {
    -0x7fffffff_i32 - 3_i32;
}

#[test]
#[should_panic(expected: ('i32_sub Underflow',))]
fn test_i32_sub_underflow_4() {
    -0x32000000_i32 - 0x7d000000_i32;
}

#[test]
#[should_panic(expected: ('i32_sub Overflow',))]
fn test_i32_sub_overflow() {
    0x32000000_i32 - -0x7d000000_i32;
}

#[test]
#[should_panic(expected: ('i32_add Overflow',))]
fn test_i32_add_overflow_1() {
    0x40000000_i32 + 0x40000000_i32;
}

#[test]
#[should_panic(expected: ('i32_add Overflow',))]
fn test_i32_add_overflow_2() {
    0x64000000_i32 + 0x1e000000_i32;
}

#[test]
#[should_panic(expected: ('i32_add Underflow',))]
fn test_i32_add_underflow() {
    -0x64000000_i32 + -0x1e000000_i32;
}

#[test]
#[should_panic]
fn test_i32_mul_overflow_1() {
    0x10000000_i32 * 0x10000000_i32;
}

#[test]
#[should_panic]
fn test_i32_mul_overflow_2() {
    0x11000000_i32 * 0x10000000_i32;
}

#[test]
#[should_panic]
fn test_i32_mul_overflow_3() {
    2_i32 * 0x40000000_i32;
}

#[test]
fn test_i64_operators() {
    assert_eq(@1_i64, @1_i64, '1 == 1');
    assert_ne(@1_i64, @2_i64, '1 != 2');
    assert_eq(
        @0x7fffffffffffffff_felt252.try_into().unwrap(),
        @0x7fffffffffffffff_i64,
        '0x7fffffffffffffff is not i64'
    );
    let v: Option<i64> = 0x8000000000000000_felt252.try_into();
    assert(v.is_none(), '0x8000000000000000 is i64');
    assert_eq(
        @(-0x8000000000000000_felt252).try_into().unwrap(),
        @-0x8000000000000000_i64,
        '-0x8000000000000000 is not i64'
    );
    let v: Option<i64> = (-0x8000000000000001_felt252).try_into();
    assert(v.is_none(), '-0x8000000000000001 is i64');
    assert_eq(@(1_i64 + 3_i64), @4_i64, '1 + 3 == 4');
    assert_eq(@(3_i64 + 6_i64), @9_i64, '3 + 6 == 9');
    assert_eq(@(3_i64 - 1_i64), @2_i64, '3 - 1 == 2');
    assert_eq(@(231_i64 - 131_i64), @100_i64, '231-131=100');
    assert_eq(@(-1_i64 + -3_i64), @-4_i64, '-1 + -3 == -4');
    assert_eq(@(-3_i64 + -6_i64), @-9_i64, '-3 + -6 == -9');
    assert_eq(@(-3_i64 - -1_i64), @-2_i64, '-3 - -1 == -2');
    assert_eq(@(-231_i64 - -131_i64), @-100_i64, '-231--131=-100');
    assert_eq(@(1_i64 * 3_i64), @3_i64, '1 * 3 == 3');
    assert_eq(@(2_i64 * 4_i64), @8_i64, '2 * 4 == 8');
    assert_eq(@(-1_i64 * 3_i64), @-3_i64, '-1 * 3 == 3');
    assert_eq(@(-2_i64 * 4_i64), @-8_i64, '-2 * 4 == 8');
    assert_eq(@(1_i64 * -3_i64), @-3_i64, '1 * -3 == -3');
    assert_eq(@(2_i64 * -4_i64), @-8_i64, '2 * -4 == -8');
    assert_eq(@(-1_i64 * -3_i64), @3_i64, '-1 * -3 == 3');
    assert_eq(@(-2_i64 * -4_i64), @8_i64, '-2 * -4 == 8');
    assert_lt(1_i64, 4_i64, '1 < 4');
    assert_le(1_i64, 4_i64, '1 <= 4');
    assert(!(4_i64 < 4_i64), '!(4 < 4)');
    assert_le(5_i64, 5_i64, '5 <= 5');
    assert(!(5_i64 <= 4_i64), '!(5 <= 8)');
    assert_gt(5_i64, 2_i64, '5 > 2');
    assert_ge(5_i64, 2_i64, '5 >= 2');
    assert(!(3_i64 > 3_i64), '!(3 > 3)');
    assert_ge(3_i64, 3_i64, '3 >= 3');
}

#[test]
#[should_panic(expected: ('i64_sub Underflow',))]
fn test_i64_sub_underflow_1() {
    -0x8000000000000000_i64 - 1_i64;
}

#[test]
#[should_panic(expected: ('i64_sub Underflow',))]
fn test_i64_sub_underflow_2() {
    -0x8000000000000000_i64 - 3_i64;
}

#[test]
#[should_panic(expected: ('i64_sub Underflow',))]
fn test_i64_sub_underflow_3() {
    -0x7fffffffffffffff_i64 - 3_i64;
}

#[test]
#[should_panic(expected: ('i64_sub Underflow',))]
fn test_i64_sub_underflow_4() {
    -0x3200000000000000_i64 - 0x7d00000000000000_i64;
}

#[test]
#[should_panic(expected: ('i64_sub Overflow',))]
fn test_i64_sub_overflow() {
    0x3200000000000000_i64 - -0x7d00000000000000_i64;
}

#[test]
#[should_panic(expected: ('i64_add Overflow',))]
fn test_i64_add_overflow_1() {
    0x4000000000000000_i64 + 0x4000000000000000_i64;
}

#[test]
#[should_panic(expected: ('i64_add Overflow',))]
fn test_i64_add_overflow_2() {
    0x6400000000000000_i64 + 0x1e00000000000000_i64;
}

#[test]
#[should_panic(expected: ('i64_add Underflow',))]
fn test_i64_add_underflow() {
    -0x6400000000000000_i64 + -0x1e00000000000000_i64;
}

#[test]
#[should_panic]
fn test_i64_mul_overflow_1() {
    0x1000000000000000_i64 * 0x1000000000000000_i64;
}

#[test]
#[should_panic]
fn test_i64_mul_overflow_2() {
    0x1100000000000000_i64 * 0x1000000000000000_i64;
}

#[test]
#[should_panic]
fn test_i64_mul_overflow_3() {
    2_i64 * 0x4000000000000000_i64;
}

#[test]
fn test_i128_operators() {
    assert_eq(@1_i128, @1_i128, '1 == 1');
    assert_ne(@1_i128, @2_i128, '1 != 2');
    assert_eq(
        @0x7fffffffffffffffffffffffffffffff_felt252.try_into().unwrap(),
        @0x7fffffffffffffffffffffffffffffff_i128,
        '0x7f..f is not i128'
    );
    let v: Option<i128> = 0x80000000000000000000000000000000_felt252.try_into();
    assert(v.is_none(), '0x80..0 is i128');
    assert_eq(
        @(-0x80000000000000000000000000000000_felt252).try_into().unwrap(),
        @-0x80000000000000000000000000000000_i128,
        '-0x80..0 is not i128'
    );
    let v: Option<i128> = (-0x80000000000000000000000000000001_felt252).try_into();
    assert(v.is_none(), '-0x80..01 is i128');
    assert_eq(@(1_i128 + 3_i128), @4_i128, '1 + 3 == 4');
    assert_eq(@(3_i128 + 6_i128), @9_i128, '3 + 6 == 9');
    assert_eq(@(3_i128 - 1_i128), @2_i128, '3 - 1 == 2');
    assert_eq(@(231_i128 - 131_i128), @100_i128, '231-131=100');
    assert_eq(@(-1_i128 + -3_i128), @-4_i128, '-1 + -3 == -4');
    assert_eq(@(-3_i128 + -6_i128), @-9_i128, '-3 + -6 == -9');
    assert_eq(@(-3_i128 - -1_i128), @-2_i128, '-3 - -1 == -2');
    assert_eq(@(-231_i128 - -131_i128), @-100_i128, '-231--131=-100');
    assert_eq(@(1_i128 * 3_i128), @3_i128, '1 * 3 == 3');
    assert_eq(@(7_i128 * 0_i128), @0_i128, '7 * 0 == 0');
    assert_eq(@(2_i128 * 4_i128), @8_i128, '2 * 4 == 8');
    assert_eq(@(-1_i128 * 3_i128), @-3_i128, '-1 * 3 == -3');
    assert_eq(@(-2_i128 * 4_i128), @-8_i128, '-2 * 4 == -8');
    assert_eq(@(1_i128 * -3_i128), @-3_i128, '1 * -3 == -3');
    assert_eq(@(2_i128 * -4_i128), @-8_i128, '2 * -4 == -8');
    assert_eq(@(-1_i128 * -3_i128), @3_i128, '-1 * -3 == 3');
    assert_eq(@(-2_i128 * -4_i128), @8_i128, '-2 * -4 == 8');
    assert_eq(
        @(0x800000000000000_i128 * -0x100000000000000000_i128),
        @-0x80000000000000000000000000000000_i128,
        'failed MIN_I128 as mul result'
    );
    assert_lt(1_i128, 4_i128, '1 < 4');
    assert_le(1_i128, 4_i128, '1 <= 4');
    assert(!(4_i128 < 4_i128), '!(4 < 4)');
    assert_le(5_i128, 5_i128, '5 <= 5');
    assert(!(5_i128 <= 4_i128), '!(5 <= 8)');
    assert_gt(5_i128, 2_i128, '5 > 2');
    assert_ge(5_i128, 2_i128, '5 >= 2');
    assert(!(3_i128 > 3_i128), '!(3 > 3)');
    assert_ge(3_i128, 3_i128, '3 >= 3');
}

#[test]
#[should_panic]
fn test_i128_sub_underflow_1() {
    -0x80000000000000000000000000000000_i128 - 1_i128;
}

#[test]
#[should_panic(expected: ('i128_sub Underflow',))]
fn test_i128_sub_underflow_2() {
    -0x80000000000000000000000000000000_i128 - 3_i128;
}

#[test]
#[should_panic(expected: ('i128_sub Underflow',))]
fn test_i128_sub_underflow_3() {
    -0x7fffffffffffffffffffffffffffffff_i128 - 3_i128;
}

#[test]
#[should_panic(expected: ('i128_sub Underflow',))]
fn test_i128_sub_underflow_4() {
    -0x32000000000000000000000000000000_i128 - 0x7d000000000000000000000000000000_i128;
}

#[test]
#[should_panic(expected: ('i128_sub Overflow',))]
fn test_i128_sub_overflow() {
    0x32000000000000000000000000000000_i128 - -0x7d000000000000000000000000000000_i128;
}

#[test]
#[should_panic(expected: ('i128_add Overflow',))]
fn test_i128_add_overflow_1() {
    0x40000000000000000000000000000000_i128 + 0x40000000000000000000000000000000_i128;
}

#[test]
#[should_panic(expected: ('i128_add Overflow',))]
fn test_i128_add_overflow_2() {
    0x64000000000000000000000000000000_i128 + 0x1e000000000000000000000000000000_i128;
}

#[test]
#[should_panic(expected: ('i128_add Underflow',))]
fn test_i128_add_underflow() {
    -0x64000000000000000000000000000000_i128 + -0x1e000000000000000000000000000000_i128;
}

#[test]
#[should_panic]
fn test_i128_mul_overflow_1() {
    0x10000000000000000000000000000000_i128 * 0x10000000000000000000000000000000_i128;
}

#[test]
#[should_panic]
fn test_i128_mul_overflow_2() {
    0x11000000000000000000000000000000_i128 * 0x10000000000000000000000000000000_i128;
}

#[test]
#[should_panic]
fn test_i128_mul_overflow_3() {
    2_i128 * 0x40000000000000000000000000000000_i128;
}

#[test]
fn test_signed_int_diff() {
    assert_eq(@integer::i8_diff(3, 3).unwrap(), @0, 'i8: 3 - 3 == 0');
    assert_eq(@integer::i8_diff(4, 3).unwrap(), @1, 'i8: 4 - 3 == 1');
    assert_eq(@integer::i8_diff(3, 5).unwrap_err(), @~(2 - 1), 'i8: 3 - 5 == -2');
    assert_eq(@integer::i16_diff(3, 3).unwrap(), @0, 'i16: 3 - 3 == 0');
    assert_eq(@integer::i16_diff(4, 3).unwrap(), @1, 'i16: 4 - 3 == 1');
    assert_eq(@integer::i16_diff(3, 5).unwrap_err(), @~(2 - 1), 'i16: 3 - 5 == -2');
    assert_eq(@integer::i32_diff(3, 3).unwrap(), @0, 'i32: 3 - 3 == 0');
    assert_eq(@integer::i32_diff(4, 3).unwrap(), @1, 'i32: 4 - 3 == 1');
    assert_eq(@integer::i32_diff(3, 5).unwrap_err(), @~(2 - 1), 'i32: 3 - 5 == -2');
    assert_eq(@integer::i64_diff(3, 3).unwrap(), @0, 'i64: 3 - 3 == 0');
    assert_eq(@integer::i64_diff(4, 3).unwrap(), @1, 'i64: 4 - 3 == 1');
    assert_eq(@integer::i64_diff(3, 5).unwrap_err(), @~(2 - 1), 'i64: 3 - 5 == -2');
    assert_eq(@integer::i128_diff(3, 3).unwrap(), @0, 'i128: 3 - 3 == 0');
    assert_eq(@integer::i128_diff(4, 3).unwrap(), @1, 'i128: 4 - 3 == 1');
    assert_eq(@integer::i128_diff(3, 5).unwrap_err(), @~(2 - 1), 'i128: 3 - 5 == -2');
}

mod bounded_int {
    use core::internal::BoundedInt;
    extern fn downcast<T, S>(index: T) -> Option<S> implicits(RangeCheck) nopanic;
    extern fn upcast<T, S>(index: T) -> S nopanic;

    type SingleInt<const VALUE: felt252> = BoundedInt<VALUE, VALUE>;
    const U128_UPPER: felt252 = 0x100000000000000000000000000000000;
    const U128_MAX: felt252 = U128_UPPER - 1;

    /// Is `value` the equivalent value of `expected` in `T` type.
    fn is_some_of<T>(value: Option<T>, expected: felt252) -> bool {
        match value {
            Option::Some(v) => upcast(v) == expected,
            Option::None => false,
        }
    }

    /// Is `value` the equivalent value (as `felt252`) of `expected` in `T` type.
    fn felt252_downcast_valid<T>(value: felt252) -> bool {
        is_some_of(downcast::<felt252, T>(value), value)
    }

    /// Is `value` the equivalent value (as `felt252`) of `expected` in `T` type.
    fn downcast_invalid<T, S>(value: T) -> bool {
        match downcast::<T, S>(value) {
            Option::Some(v) => {
                // Just as a drop for `v`.
                upcast::<_, felt252>(v);
                false
            },
            Option::None => true,
        }
    }

    #[test]
    fn test_felt252_downcasts() {
        assert!(downcast_invalid::<felt252, SingleInt<0>>(1));
        assert!(felt252_downcast_valid::<SingleInt<0>>(0));
        assert!(downcast_invalid::<felt252, SingleInt<0>>(-1));
        assert!(downcast_invalid::<felt252, SingleInt<-1>>(-2));
        assert!(felt252_downcast_valid::<SingleInt<-1>>(-1));
        assert!(downcast_invalid::<felt252, SingleInt<-1>>(0));
        assert!(downcast_invalid::<felt252, BoundedInt<120, 180>>(119));
        assert!(felt252_downcast_valid::<BoundedInt<120, 180>>(120));
        assert!(felt252_downcast_valid::<BoundedInt<120, 180>>(180));
        assert!(downcast_invalid::<felt252, BoundedInt<120, 180>>(181));
        assert!(downcast_invalid::<felt252, SingleInt<U128_MAX>>(U128_MAX - 1));
        assert!(felt252_downcast_valid::<SingleInt<U128_MAX>>(U128_MAX));
        assert!(downcast_invalid::<felt252, SingleInt<U128_MAX>>(U128_MAX + 1));
        assert!(downcast_invalid::<felt252, SingleInt<U128_UPPER>>(U128_UPPER - 1));
        assert!(felt252_downcast_valid::<SingleInt<U128_UPPER>>(U128_UPPER));
        assert!(downcast_invalid::<felt252, SingleInt<U128_UPPER>>(U128_UPPER + 1));
    }

    const ONE_MINUS_P: felt252 = -0x800000000000011000000000000000000000000000000000000000000000000;

    // Full prime range, but where the max element is 0.
    type OneMinusPToZero = BoundedInt<ONE_MINUS_P, 0>;

    fn bi_const<const V: felt252>() -> SingleInt<V> {
        downcast(V).unwrap()
    }

    #[test]
    fn test_bounded_int_casts() {
        assert!(downcast::<OneMinusPToZero, u8>(upcast(bi_const::<-1>())).is_none());
        assert!(downcast::<OneMinusPToZero, u8>(0) == Option::Some(0));
        assert!(downcast::<OneMinusPToZero, u8>(upcast(bi_const::<ONE_MINUS_P>())).is_none());
        assert!(downcast::<BoundedInt<100, 200>, BoundedInt<120, 180>>(119).is_none());
        assert!(is_some_of(downcast::<BoundedInt<100, 200>, BoundedInt<120, 180>>(120), 120));
        assert!(is_some_of(downcast::<BoundedInt<100, 200>, BoundedInt<120, 180>>(180), 180));
        assert!(downcast::<BoundedInt<100, 200>, BoundedInt<120, 180>>(181).is_none());
    }

    trait BIOps<T1, T2> {
        type AddT;
        type SubT;
        type MulT;
    }
    impl U8BIOps of BIOps<u8, u8> {
        type AddT = BoundedInt<0, 510>;
        type SubT = BoundedInt<-255, 255>;
        type MulT = BoundedInt<0, { 255 * 255 }>;
    }
    impl I8BIOps of BIOps<i8, i8> {
        type AddT = BoundedInt<-256, 254>;
        type SubT = BoundedInt<-255, 255>;
        type MulT = BoundedInt<{ 127 * -128 }, { 128 * 128 }>;
    }
    extern fn bounded_int_add<T1, T2, impl Ops: BIOps<T1, T2>>(a: T1, b: T2) -> Ops::AddT nopanic;

    #[test]
    fn test_add() {
        assert!(upcast(bounded_int_add(0_u8, 0_u8)) == 0_felt252);
        assert!(upcast(bounded_int_add(0_u8, 255_u8)) == 255_felt252);
        assert!(upcast(bounded_int_add(255_u8, 0_u8)) == 255_felt252);
        assert!(upcast(bounded_int_add(255_u8, 255_u8)) == 510_felt252);
        assert!(upcast(bounded_int_add(-128_i8, -128_i8)) == -256_felt252);
        assert!(upcast(bounded_int_add(-128_i8, 127_i8)) == -1_felt252);
        assert!(upcast(bounded_int_add(127_i8, -128_i8)) == -1_felt252);
        assert!(upcast(bounded_int_add(127_i8, 127_i8)) == 254_felt252);
    }

    extern fn bounded_int_sub<T1, T2, impl Ops: BIOps<T1, T2>>(a: T1, b: T2) -> Ops::SubT nopanic;

    #[test]
    fn test_sub() {
        assert!(upcast(bounded_int_sub(0_u8, 0_u8)) == 0_felt252);
        assert!(upcast(bounded_int_sub(0_u8, 255_u8)) == -255_felt252);
        assert!(upcast(bounded_int_sub(255_u8, 0_u8)) == 255_felt252);
        assert!(upcast(bounded_int_sub(255_u8, 255_u8)) == 0_felt252);
        assert!(upcast(bounded_int_sub(-128_i8, -128_i8)) == 0_felt252);
        assert!(upcast(bounded_int_sub(-128_i8, 127_i8)) == -255_felt252);
        assert!(upcast(bounded_int_sub(127_i8, -128_i8)) == 255_felt252);
        assert!(upcast(bounded_int_sub(127_i8, 127_i8)) == 0_felt252);
    }

    extern fn bounded_int_mul<T1, T2, impl Ops: BIOps<T1, T2>>(a: T1, b: T2) -> Ops::MulT nopanic;

    #[test]
    fn test_mul() {
        assert!(upcast(bounded_int_mul(0_u8, 0_u8)) == 0_felt252);
        assert!(upcast(bounded_int_mul(0_u8, 255_u8)) == 0_felt252);
        assert!(upcast(bounded_int_mul(255_u8, 0_u8)) == 0_felt252);
        assert!(upcast(bounded_int_mul(255_u8, 255_u8)) == 255_felt252 * 255);
        assert!(upcast(bounded_int_mul(-128_i8, -128_i8)) == -128_felt252 * -128);
        assert!(upcast(bounded_int_mul(-128_i8, 127_i8)) == -128_felt252 * 127);
        assert!(upcast(bounded_int_mul(127_i8, -128_i8)) == 127_felt252 * -128);
        assert!(upcast(bounded_int_mul(127_i8, 127_i8)) == 127_felt252 * 127);
    }

    fn bi_value<const MIN: felt252, const MAX: felt252>(v: u128) -> BoundedInt<MIN, MAX> {
        downcast(v).unwrap()
    }

    trait DivRemRes<T1, T2> {
        type DivT;
        type RemT;
    }
    extern fn bounded_int_div_rem<T1, T2, impl DRR: DivRemRes<T1, T2>>(
        a: T1, b: NonZero<T2>
    ) -> (DRR::DivT, DRR::RemT) implicits(RangeCheck) nopanic;
    extern fn bounded_int_wrap_non_zero<T>(v: T) -> NonZero<T> nopanic;

    /// Same as `bounded_int_div_rem`, but unwraps the result into felt252s.
    fn bounded_int_div_rem_unwrapped<T1, T2, impl DRR: DivRemRes<T1, T2>>(
        a: T1, b: T2
    ) -> (felt252, felt252) {
        let (q, r) = bounded_int_div_rem(a, bounded_int_wrap_non_zero(b));
        (upcast(q), upcast(r))
    }

    impl SmallNumDivRemRes of DivRemRes<BoundedInt<128, 255>, BoundedInt<3, 8>> {
        type DivT = BoundedInt<16, 85>;
        type RemT = BoundedInt<0, 7>;
    }
    fn div_rem_helper(a: u128, b: u128) -> (felt252, felt252) {
        bounded_int_div_rem_unwrapped(bi_value::<128, 255>(a), bi_value::<3, 8>(b))
    }

    #[test]
    fn test_div_rem() {
        assert!(div_rem_helper(128, 3) == (42, 2));
        assert!(div_rem_helper(255, 3) == (85, 0));
        assert!(div_rem_helper(128, 8) == (16, 0));
        assert!(div_rem_helper(255, 8) == (31, 7));
    }

    impl U128DivRemRes of DivRemRes<u128, BoundedInt<1, 0xffffffffffffffffffffffffffffffff>> {
        type DivT = BoundedInt<0, 0xffffffffffffffffffffffffffffffff>;
        type RemT = BoundedInt<0, 0xfffffffffffffffffffffffffffffffe>;
    }
    fn div_rem_wide_helper(a: u128, b: u128) -> (felt252, felt252) {
        bounded_int_div_rem_unwrapped(a, bi_value::<1, 0xffffffffffffffffffffffffffffffff>(b))
    }

    #[test]
    fn test_div_rem_wide() {
        assert!(div_rem_wide_helper(128, 3) == (42, 2));
        assert!(div_rem_wide_helper(255, 3) == (85, 0));
        assert!(div_rem_wide_helper(128, 8) == (16, 0));
        assert!(div_rem_wide_helper(255, 8) == (31, 7));
    }

    mod helpers {
        pub impl DivRemResImpl<
            const A: felt252, const B: felt252, const MAX_Q: felt252, const MAX_R: felt252
        > of super::DivRemRes<super::BoundedInt<0, A>, super::BoundedInt<B, B>> {
            type DivT = super::BoundedInt<0, MAX_Q>;
            type RemT = super::BoundedInt<0, MAX_R>;
        }
    }

    fn div_rem_small_quotient_helper<
        const A_MAX: felt252,
        const B: felt252,
        const A: felt252,
        +DivRemRes<BoundedInt<0, A_MAX>, BoundedInt<B, B>>,
    >(
        a: BoundedInt<A, A>
    ) -> (felt252, felt252) {
        bounded_int_div_rem_unwrapped::<BoundedInt<0, A_MAX>>(upcast(a), bi_const::<B>())
    }

    const POW_2_124: felt252 = 0x10000000000000000000000000000000;
    const MASK4: felt252 = 0xf;
    const MASK124: felt252 = POW_2_124 - 1;
    const POW_2_251: felt252 = 0x800000000000000000000000000000000000000000000000000000000000000;
    const POW_2_123: felt252 = 0x8000000000000000000000000000000;

    impl U128Pow124DivRemRes = helpers::DivRemResImpl<U128_MAX, POW_2_124, MASK4, MASK124>;
    impl U251Pow128DivRemRes =
        helpers::DivRemResImpl<POW_2_251, U128_MAX, POW_2_123, { U128_MAX - 1 }>;

    // Test an extreme case where BoundedIntDivRemAlgorithm::KnownSmallLhs is used,
    // and `min{b, q} = lhs_upper_sqrt - 1`.
    type MaxRootLhs =
        BoundedInt<1, 0x1000000000000000000000000000001000000000000000000000000000001>;
    type MaxRootRhs =
        BoundedInt<0x20000000000000000000000000000, { 0x100000000000000000000000000000000 - 1 }>;
    impl MaxRootDivRemRes of DivRemRes<MaxRootLhs, MaxRootRhs,> {
        type DivT = BoundedInt<0, 0x80000000000000000000000000000080>;
        type RemT = BoundedInt<0, { 0x100000000000000000000000000000000 - 2 }>;
    }

    #[test]
    fn test_div_rem_small_quotient() {
        assert!(div_rem_small_quotient_helper::<U128_MAX, POW_2_124>(bi_const::<0>()) == (0, 0));
        let dividend = bi_const::<{ 0x5 * POW_2_124 + 0x32 }>();
        assert!(div_rem_small_quotient_helper::<U128_MAX, POW_2_124>(dividend) == (0x5, 0x32));
        let dividend = bi_const::<{ 0xf * POW_2_124 + 0x12345 }>();
        assert!(div_rem_small_quotient_helper::<U128_MAX, POW_2_124>(dividend) == (0xf, 0x12345));
        let dividend = bi_const::<U128_MAX>();
        assert!(div_rem_small_quotient_helper::<U128_MAX, POW_2_124>(dividend) == (MASK4, MASK124));
        let dividend = bi_const::<POW_2_251>();
        assert!(
            div_rem_small_quotient_helper::<POW_2_251, U128_MAX>(dividend) == (POW_2_123, POW_2_123)
        );
        assert!(
            bounded_int_div_rem_unwrapped::<
                MaxRootLhs, MaxRootRhs
            >(
                0x1000000000000000000000000000001000000000000000000000000000000,
                0x1000000000000000000000000000000
            ) == (0x1000000000000000000000000000001, 0)
        );
    }

    trait BIConstrain<T, const BOUNDARY: felt252> {
        type LowT;
        type HighT;
    }
    extern fn bounded_int_constrain<T, const BOUNDARY: felt252, impl BIC: BIConstrain<T, BOUNDARY>>(
        value: T
    ) -> Result<BIC::LowT, BIC::HighT> implicits(RangeCheck) nopanic;

    fn test_constrain_helper<T, const BOUNDARY: felt252, +BIConstrain<T, BOUNDARY>, +Copy<T>,>(
        value: T
    ) -> bool {
        match bounded_int_constrain::<_, BOUNDARY>(value) {
            Result::Ok(result) => upcast(result),
            Result::Err(result) => upcast(result),
        } == upcast::<_, felt252>(value)
    }

    impl U8BIConstrain of BIConstrain<u8, 0x80> {
        type LowT = BoundedInt<0, 0x7f>;
        type HighT = BoundedInt<0x80, 0xff>;
    }
    impl I8BIConstrain of BIConstrain<i8, 0> {
        type LowT = BoundedInt<-0x80, -1>;
        type HighT = BoundedInt<0, 0x7f>;
    }
    const U129_MAX: felt252 = U128_MAX + U128_UPPER;
    type u129 = BoundedInt<0, U129_MAX>;
    impl U129BIConstrain of BIConstrain<u129, U128_UPPER> {
        type LowT = BoundedInt<0, U128_MAX>;
        type HighT = BoundedInt<U128_UPPER, U129_MAX>;
    }

    #[test]
    fn test_constrain() {
        assert!(test_constrain_helper::<u8, 0x80>(0));
        assert!(test_constrain_helper::<u8, 0x80>(0x7f));
        assert!(test_constrain_helper::<u8, 0x80>(0x80));
        assert!(test_constrain_helper::<u8, 0x80>(0xff));
        assert!(test_constrain_helper::<i8, 0>(-0x80));
        assert!(test_constrain_helper::<i8, 0>(-1));
        assert!(test_constrain_helper::<i8, 0>(0));
        assert!(test_constrain_helper::<i8, 0>(0x7f));
        assert!(test_constrain_helper::<u129, U128_UPPER>(upcast(bi_const::<0>())));
        assert!(test_constrain_helper::<u129, U128_UPPER>(upcast(bi_const::<U128_MAX>())));
        assert!(test_constrain_helper::<u129, U128_UPPER>(upcast(bi_const::<U128_UPPER>())));
        assert!(test_constrain_helper::<u129, U128_UPPER>(upcast(bi_const::<U129_MAX>())));
    }
}
