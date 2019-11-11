void mc_testbench_capture_IN( ac_channel<DATA_MEM > &data_in,  ac_channel<HIST_MEM > &hist_out) { mc_testbench::capture_IN(data_in,hist_out); }
void mc_testbench_capture_OUT( ac_channel<DATA_MEM > &data_in,  ac_channel<HIST_MEM > &hist_out) { mc_testbench::capture_OUT(data_in,hist_out); }
void mc_testbench_wait_for_idle_sync() {mc_testbench::wait_for_idle_sync(); }

