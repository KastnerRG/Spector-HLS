void mc_testbench_capture_IN( ac_channel<ac_fixed<20, 8, true, AC_TRN, AC_WRAP > > &dst,  ac_channel<ac_fixed<20, 8, true, AC_TRN, AC_WRAP > > &src) { mc_testbench::capture_IN(dst,src); }
void mc_testbench_capture_OUT( ac_channel<ac_fixed<20, 8, true, AC_TRN, AC_WRAP > > &dst,  ac_channel<ac_fixed<20, 8, true, AC_TRN, AC_WRAP > > &src) { mc_testbench::capture_OUT(dst,src); }
void mc_testbench_wait_for_idle_sync() {mc_testbench::wait_for_idle_sync(); }

