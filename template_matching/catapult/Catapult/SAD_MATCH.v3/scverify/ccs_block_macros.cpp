void mc_testbench_capture_IN( ac_channel<ac_int<8, false > > &INPUT,  ac_channel<ac_int<8, false > > &OUTPUT) { mc_testbench::capture_IN(INPUT,OUTPUT); }
void mc_testbench_capture_OUT( ac_channel<ac_int<8, false > > &INPUT,  ac_channel<ac_int<8, false > > &OUTPUT) { mc_testbench::capture_OUT(INPUT,OUTPUT); }
void mc_testbench_wait_for_idle_sync() {mc_testbench::wait_for_idle_sync(); }

