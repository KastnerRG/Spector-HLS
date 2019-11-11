// ccs_block_macros.h
#include "ccs_testbench.h"

#ifndef EXCLUDE_CCS_BLOCK_INTERCEPT
#ifndef INCLUDE_CCS_BLOCK_INTERCEPT
#define INCLUDE_CCS_BLOCK_INTERCEPT
#ifdef  CCS_DESIGN_FUNC_histogram_hls
extern void mc_testbench_capture_IN( ac_channel<DATA_MEM > &data_in,  ac_channel<HIST_MEM > &hist_out);
extern void mc_testbench_capture_OUT( ac_channel<DATA_MEM > &data_in,  ac_channel<HIST_MEM > &hist_out);
extern void mc_testbench_wait_for_idle_sync();

#define ccs_intercept_histogram_hls_7 \
  ccs_real_histogram_hls(ac_channel<DATA_MEM > &data_in,ac_channel<HIST_MEM > &hist_out);\
  void histogram_hls(ac_channel<DATA_MEM > &data_in,ac_channel<HIST_MEM > &hist_out)\
{\
    static bool ccs_intercept_flag = false;\
    if (!ccs_intercept_flag) {\
      std::cout << "SCVerify intercepting C++ function 'histogram_hls' for RTL block 'histogram_hls'" << std::endl;\
      ccs_intercept_flag=true;\
    }\
    mc_testbench_capture_IN(data_in,hist_out);\
    ccs_real_histogram_hls(data_in,hist_out);\
    mc_testbench_capture_OUT(data_in,hist_out);\
}\
  void ccs_real_histogram_hls
#else
#define ccs_intercept_histogram_hls_7 histogram_hls
#endif //CCS_DESIGN_FUNC_histogram_hls
#endif //INCLUDE_CCS_BLOCK_INTERCEPT
#endif //EXCLUDE_CCS_BLOCK_INTERCEPT

// iv 1332 INLINE
#define ccs_intercept_iv_1332 iv
// const 1496 INLINE
#define ccs_intercept_const_1496 const
// const 1497 INLINE
#define ccs_intercept_const_1497 const
// set_slc 1506 INLINE
#define ccs_intercept_set_slc_1506 set_slc
// const 1380 INLINE
#define ccs_intercept_const_1380 const
// const 1454 INLINE
#define ccs_intercept_const_1454 const
// iv 1329 INLINE
#define ccs_intercept_iv_1329 iv
// const 1499 INLINE
#define ccs_intercept_const_1499 const
// const 1502 INLINE
#define ccs_intercept_const_1502 const
// set_slc 1509 INLINE
#define ccs_intercept_set_slc_1509 set_slc
// set_slc 1515 INLINE
#define ccs_intercept_set_slc_1515 set_slc
// mgc_floor 162 INLINE
#define ccs_intercept_mgc_floor_162 mgc_floor
// ac_assert 166 INLINE
#define ccs_intercept_ac_assert_166 ac_assert
// ldexpr32 215 INLINE
#define ccs_intercept_ldexpr32_215 ldexpr32
// ldexpr32 216 INLINE
#define ccs_intercept_ldexpr32_216 ldexpr32
// ldexpr32 217 INLINE
#define ccs_intercept_ldexpr32_217 ldexpr32
// ldexpr32 218 INLINE
#define ccs_intercept_ldexpr32_218 ldexpr32
// ldexpr32 219 INLINE
#define ccs_intercept_ldexpr32_219 ldexpr32
// iv_copy 231 INLINE
#define ccs_intercept_iv_copy_231 iv_copy
// iv_copy 234 INLINE
#define ccs_intercept_iv_copy_234 iv_copy
// iv_equal_zero 246 INLINE
#define ccs_intercept_iv_equal_zero_246 iv_equal_zero
// iv_equal_zero 247 INLINE
#define ccs_intercept_iv_equal_zero_247 iv_equal_zero
// iv_equal_zero 250 INLINE
#define ccs_intercept_iv_equal_zero_250 iv_equal_zero
// iv_equal_ones 261 INLINE
#define ccs_intercept_iv_equal_ones_261 iv_equal_ones
// iv_equal_ones 262 INLINE
#define ccs_intercept_iv_equal_ones_262 iv_equal_ones
// iv_equal_ones 265 INLINE
#define ccs_intercept_iv_equal_ones_265 iv_equal_ones
// iv_equal 284 INLINE
#define ccs_intercept_iv_equal_284 iv_equal
// iv_equal_ones_from 294 INLINE
#define ccs_intercept_iv_equal_ones_from_294 iv_equal_ones_from
// iv_equal_ones_from 297 INLINE
#define ccs_intercept_iv_equal_ones_from_297 iv_equal_ones_from
// iv_equal_zeros_from 307 INLINE
#define ccs_intercept_iv_equal_zeros_from_307 iv_equal_zeros_from
// iv_equal_zeros_from 310 INLINE
#define ccs_intercept_iv_equal_zeros_from_310 iv_equal_zeros_from
// iv_equal_ones_to 320 INLINE
#define ccs_intercept_iv_equal_ones_to_320 iv_equal_ones_to
// iv_equal_ones_to 323 INLINE
#define ccs_intercept_iv_equal_ones_to_323 iv_equal_ones_to
// iv_equal_zeros_to 333 INLINE
#define ccs_intercept_iv_equal_zeros_to_333 iv_equal_zeros_to
// iv_equal_zeros_to 336 INLINE
#define ccs_intercept_iv_equal_zeros_to_336 iv_equal_zeros_to
// iv_compare 361 INLINE
#define ccs_intercept_iv_compare_361 iv_compare
// iv_compare 364 INLINE
#define ccs_intercept_iv_compare_364 iv_compare
// iv_extend 373 INLINE
#define ccs_intercept_iv_extend_373 iv_extend
// iv_extend 374 INLINE
#define ccs_intercept_iv_extend_374 iv_extend
// iv_extend 375 INLINE
#define ccs_intercept_iv_extend_375 iv_extend
// iv_extend 376 INLINE
#define ccs_intercept_iv_extend_376 iv_extend
// iv_extend 379 INLINE
#define ccs_intercept_iv_extend_379 iv_extend
// iv_assign_int64 392 INLINE
#define ccs_intercept_iv_assign_int64_392 iv_assign_int64
// iv_assign_int64 395 INLINE
#define ccs_intercept_iv_assign_int64_395 iv_assign_int64
// iv_assign_uint64 408 INLINE
#define ccs_intercept_iv_assign_uint64_408 iv_assign_uint64
// iv_assign_uint64 411 INLINE
#define ccs_intercept_iv_assign_uint64_411 iv_assign_uint64
// mult_u_u 416 INLINE
#define ccs_intercept_mult_u_u_416 mult_u_u
// mult_u_s 419 INLINE
#define ccs_intercept_mult_u_s_419 mult_u_s
// mult_s_u 422 INLINE
#define ccs_intercept_mult_s_u_422 mult_s_u
// mult_s_s 425 INLINE
#define ccs_intercept_mult_s_s_425 mult_s_s
// accumulate 428 INLINE
#define ccs_intercept_accumulate_428 accumulate
// accumulate 432 INLINE
#define ccs_intercept_accumulate_432 accumulate
// iv_mult 492 INLINE
#define ccs_intercept_iv_mult_492 iv_mult
// iv_mult 495 INLINE
#define ccs_intercept_iv_mult_495 iv_mult
// iv_uadd_carry 509 INLINE
#define ccs_intercept_iv_uadd_carry_509 iv_uadd_carry
// iv_uadd_carry 510 INLINE
#define ccs_intercept_iv_uadd_carry_510 iv_uadd_carry
// iv_add_int_carry 537 INLINE
#define ccs_intercept_iv_add_int_carry_537 iv_add_int_carry
// iv_add_int_carry 538 INLINE
#define ccs_intercept_iv_add_int_carry_538 iv_add_int_carry
// iv_uadd_n 554 INLINE
#define ccs_intercept_iv_uadd_n_554 iv_uadd_n
// iv_uadd_n 555 INLINE
#define ccs_intercept_iv_uadd_n_555 iv_uadd_n
// iv_uadd_n 560 INLINE
#define ccs_intercept_iv_uadd_n_560 iv_uadd_n
// iv_add 586 INLINE
#define ccs_intercept_iv_add_586 iv_add
// iv_add 589 INLINE
#define ccs_intercept_iv_add_589 iv_add
// iv_sub_int_borrow 612 INLINE
#define ccs_intercept_iv_sub_int_borrow_612 iv_sub_int_borrow
// iv_sub_int_borrow 613 INLINE
#define ccs_intercept_iv_sub_int_borrow_613 iv_sub_int_borrow
// iv_sub_int_borrow 638 INLINE
#define ccs_intercept_iv_sub_int_borrow_638 iv_sub_int_borrow
// iv_sub_int_borrow 639 INLINE
#define ccs_intercept_iv_sub_int_borrow_639 iv_sub_int_borrow
// iv_usub_n 655 INLINE
#define ccs_intercept_iv_usub_n_655 iv_usub_n
// iv_usub_n 660 INLINE
#define ccs_intercept_iv_usub_n_660 iv_usub_n
// iv_sub 686 INLINE
#define ccs_intercept_iv_sub_686 iv_sub
// iv_sub 689 INLINE
#define ccs_intercept_iv_sub_689 iv_sub
// iv_all_bits_same 701 INLINE
#define ccs_intercept_iv_all_bits_same_701 iv_all_bits_same
// iv_all_bits_same 702 INLINE
#define ccs_intercept_iv_all_bits_same_702 iv_all_bits_same
// iv_bitwise_complement_n 910 INLINE
#define ccs_intercept_iv_bitwise_complement_n_910 iv_bitwise_complement_n
// iv_bitwise_complement_n 913 INLINE
#define ccs_intercept_iv_bitwise_complement_n_913 iv_bitwise_complement_n
// iv_bitwise_and_n 930 INLINE
#define ccs_intercept_iv_bitwise_and_n_930 iv_bitwise_and_n
// iv_bitwise_and_n 933 INLINE
#define ccs_intercept_iv_bitwise_and_n_933 iv_bitwise_and_n
// iv_bitwise_or_n 958 INLINE
#define ccs_intercept_iv_bitwise_or_n_958 iv_bitwise_or_n
// iv_bitwise_or_n 961 INLINE
#define ccs_intercept_iv_bitwise_or_n_961 iv_bitwise_or_n
// iv_bitwise_xor_n 986 INLINE
#define ccs_intercept_iv_bitwise_xor_n_986 iv_bitwise_xor_n
// iv_bitwise_xor_n 989 INLINE
#define ccs_intercept_iv_bitwise_xor_n_989 iv_bitwise_xor_n
// iv_shift_l2 1053 INLINE
#define ccs_intercept_iv_shift_l2_1053 iv_shift_l2
// iv_shift_l2 1056 INLINE
#define ccs_intercept_iv_shift_l2_1056 iv_shift_l2
// iv_shift_r2 1070 INLINE
#define ccs_intercept_iv_shift_r2_1070 iv_shift_r2
// iv_shift_r2 1073 INLINE
#define ccs_intercept_iv_shift_r2_1073 iv_shift_r2
// iv_const_shift_l 1110 INLINE
#define ccs_intercept_iv_const_shift_l_1110 iv_const_shift_l
// iv_const_shift_l 1113 INLINE
#define ccs_intercept_iv_const_shift_l_1113 iv_const_shift_l
// iv_const_shift_r 1141 INLINE
#define ccs_intercept_iv_const_shift_r_1141 iv_const_shift_r
// iv_const_shift_r 1144 INLINE
#define ccs_intercept_iv_const_shift_r_1144 iv_const_shift_r
// to_str 1195 INLINE
#define ccs_intercept_to_str_1195 to_str
// to_string 1249 INLINE
#define ccs_intercept_to_string_1249 to_string
// to_str 1172 INLINE
#define ccs_intercept_to_str_1172 to_str
// iv_leading_bits 1282 INLINE
#define ccs_intercept_iv_leading_bits_1282 iv_leading_bits
// iv_add 570 INLINE
#define ccs_intercept_iv_add_570 iv_add
// value 2965 INLINE
#define ccs_intercept_value_2965 value
// value 2966 INLINE
#define ccs_intercept_value_2966 value
// value 2967 INLINE
#define ccs_intercept_value_2967 value
// value 2968 INLINE
#define ccs_intercept_value_2968 value
// value 2969 INLINE
#define ccs_intercept_value_2969 value
// value 2970 INLINE
#define ccs_intercept_value_2970 value
// value 2971 INLINE
#define ccs_intercept_value_2971 value
// value 2972 INLINE
#define ccs_intercept_value_2972 value
// value 2973 INLINE
#define ccs_intercept_value_2973 value
// value 2974 INLINE
#define ccs_intercept_value_2974 value
// value 2975 INLINE
#define ccs_intercept_value_2975 value
// value 2976 INLINE
#define ccs_intercept_value_2976 value
// ac_exception 74 INLINE
#define ccs_intercept_ac_exception_74 ac_exception
// msg 89 INLINE
#define ccs_intercept_msg_89 msg
// histogram_main 13 BLOCK
#define ccs_intercept_histogram_main_13 histogram_main
