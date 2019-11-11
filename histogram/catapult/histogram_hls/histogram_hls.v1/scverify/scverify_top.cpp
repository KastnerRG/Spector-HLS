#include <string>
#include <fstream>
#include <iostream>
#include "mc_testbench.h"
#include <mc_reset.h>
#include <mc_transactors.h>
#include <mc_scverify.h>
#include <mc_stall_ctrl.h>
#include "/usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/pkgs/ccs_libs/interfaces/amba/ccs_axi4_slave_mem_trans_rsc.h"
#include <mc_monitor.h>
#include <mc_simulator_extensions.h>
#include "mc_dut_wrapper.h"
#include "ccs_probes.cpp"
#include <mt19937ar.c>
#ifndef TO_QUOTED_STRING
#define TO_QUOTED_STRING(x) TO_QUOTED_STRING1(x)
#define TO_QUOTED_STRING1(x) #x
#endif
#ifndef TOP_HDL_ENTITY
#define TOP_HDL_ENTITY histogram_hls
#endif
// Hold time for the SCVerify testbench to account for the gate delay after downstream synthesis in pico second(s)
// Hold time value is obtained from 'top_gate_constraints.cpp', which is generated at the end of RTL synthesis
#ifdef CCS_DUT_GATE
extern double __scv_hold_time;
extern double __scv_hold_time_RSCID_1;
extern double __scv_hold_time_RSCID_2;
#else
double __scv_hold_time = 0.0; // default for non-gate simulation is zero
double __scv_hold_time_RSCID_1 = 0;
double __scv_hold_time_RSCID_2 = 0;
#endif

class scverify_top : public sc_module
{
public:
  sc_signal<sc_logic>                                                                  rst;
  sc_signal<sc_logic>                                                                  rst_n;
  sc_signal<sc_logic>                                                                  SIG_SC_LOGIC_0;
  sc_signal<sc_logic>                                                                  SIG_SC_LOGIC_1;
  sc_signal<sc_logic>                                                                  TLS_design_is_idle;
  sc_signal<bool>                                                                      TLS_design_is_idle_reg;
  sc_clock                                                                             clk;
  mc_programmable_reset                                                                rst_driver;
  sc_signal<sc_logic>                                                                  TLS_rst;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_s_tdone;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_tr_write_done;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_RREADY;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_RVALID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_RUSER;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_RLAST;
  sc_signal<sc_lv<2> >                                                                 TLS_data_in_rsc_RRESP;
  sc_signal<sc_lv<16> >                                                                TLS_data_in_rsc_RDATA;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_RID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_ARREADY;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_ARVALID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_ARUSER;
  sc_signal<sc_lv<4> >                                                                 TLS_data_in_rsc_ARREGION;
  sc_signal<sc_lv<4> >                                                                 TLS_data_in_rsc_ARQOS;
  sc_signal<sc_lv<3> >                                                                 TLS_data_in_rsc_ARPROT;
  sc_signal<sc_lv<4> >                                                                 TLS_data_in_rsc_ARCACHE;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_ARLOCK;
  sc_signal<sc_lv<2> >                                                                 TLS_data_in_rsc_ARBURST;
  sc_signal<sc_lv<3> >                                                                 TLS_data_in_rsc_ARSIZE;
  sc_signal<sc_lv<8> >                                                                 TLS_data_in_rsc_ARLEN;
  sc_signal<sc_lv<13> >                                                                TLS_data_in_rsc_ARADDR;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_ARID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_BREADY;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_BVALID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_BUSER;
  sc_signal<sc_lv<2> >                                                                 TLS_data_in_rsc_BRESP;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_BID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_WREADY;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_WVALID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_WUSER;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_WLAST;
  sc_signal<sc_lv<2> >                                                                 TLS_data_in_rsc_WSTRB;
  sc_signal<sc_lv<16> >                                                                TLS_data_in_rsc_WDATA;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_AWREADY;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_AWVALID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_AWUSER;
  sc_signal<sc_lv<4> >                                                                 TLS_data_in_rsc_AWREGION;
  sc_signal<sc_lv<4> >                                                                 TLS_data_in_rsc_AWQOS;
  sc_signal<sc_lv<3> >                                                                 TLS_data_in_rsc_AWPROT;
  sc_signal<sc_lv<4> >                                                                 TLS_data_in_rsc_AWCACHE;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_AWLOCK;
  sc_signal<sc_lv<2> >                                                                 TLS_data_in_rsc_AWBURST;
  sc_signal<sc_lv<3> >                                                                 TLS_data_in_rsc_AWSIZE;
  sc_signal<sc_lv<8> >                                                                 TLS_data_in_rsc_AWLEN;
  sc_signal<sc_lv<13> >                                                                TLS_data_in_rsc_AWADDR;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_AWID;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_req_vz;
  sc_signal<sc_logic>                                                                  TLS_data_in_rsc_rls_lz;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_s_tdone;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_tr_write_done;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_RREADY;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_RVALID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_RUSER;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_RLAST;
  sc_signal<sc_lv<2> >                                                                 TLS_hist_out_rsc_RRESP;
  sc_signal<sc_lv<8> >                                                                 TLS_hist_out_rsc_RDATA;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_RID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_ARREADY;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_ARVALID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_ARUSER;
  sc_signal<sc_lv<4> >                                                                 TLS_hist_out_rsc_ARREGION;
  sc_signal<sc_lv<4> >                                                                 TLS_hist_out_rsc_ARQOS;
  sc_signal<sc_lv<3> >                                                                 TLS_hist_out_rsc_ARPROT;
  sc_signal<sc_lv<4> >                                                                 TLS_hist_out_rsc_ARCACHE;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_ARLOCK;
  sc_signal<sc_lv<2> >                                                                 TLS_hist_out_rsc_ARBURST;
  sc_signal<sc_lv<3> >                                                                 TLS_hist_out_rsc_ARSIZE;
  sc_signal<sc_lv<8> >                                                                 TLS_hist_out_rsc_ARLEN;
  sc_signal<sc_lv<12> >                                                                TLS_hist_out_rsc_ARADDR;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_ARID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_BREADY;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_BVALID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_BUSER;
  sc_signal<sc_lv<2> >                                                                 TLS_hist_out_rsc_BRESP;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_BID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_WREADY;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_WVALID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_WUSER;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_WLAST;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_WSTRB;
  sc_signal<sc_lv<8> >                                                                 TLS_hist_out_rsc_WDATA;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_AWREADY;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_AWVALID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_AWUSER;
  sc_signal<sc_lv<4> >                                                                 TLS_hist_out_rsc_AWREGION;
  sc_signal<sc_lv<4> >                                                                 TLS_hist_out_rsc_AWQOS;
  sc_signal<sc_lv<3> >                                                                 TLS_hist_out_rsc_AWPROT;
  sc_signal<sc_lv<4> >                                                                 TLS_hist_out_rsc_AWCACHE;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_AWLOCK;
  sc_signal<sc_lv<2> >                                                                 TLS_hist_out_rsc_AWBURST;
  sc_signal<sc_lv<3> >                                                                 TLS_hist_out_rsc_AWSIZE;
  sc_signal<sc_lv<8> >                                                                 TLS_hist_out_rsc_AWLEN;
  sc_signal<sc_lv<12> >                                                                TLS_hist_out_rsc_AWADDR;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_AWID;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_req_vz;
  sc_signal<sc_logic>                                                                  TLS_hist_out_rsc_rls_lz;
  ccs_DUT_wrapper                                                                      histogram_hls_INST;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_AWID;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_data_in_rsc_AWID;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_AWUSER;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_data_in_rsc_AWUSER;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_WUSER;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_data_in_rsc_WUSER;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_BID;
  ccs_sc_logic_to_sc_lv1_adapter                                                       CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BID;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_BUSER;
  ccs_sc_logic_to_sc_lv1_adapter                                                       CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BUSER;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_ARID;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_data_in_rsc_ARID;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_ARUSER;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_data_in_rsc_ARUSER;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_RID;
  ccs_sc_logic_to_sc_lv1_adapter                                                       CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RID;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_data_in_rsc_RUSER;
  ccs_sc_logic_to_sc_lv1_adapter                                                       CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RUSER;
  ccs_axi4_slave_mem_trans_rsc<8192,16,16,13,0,0,13,16,0,0 >                           data_in_rsc_INST;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_AWID;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_hist_out_rsc_AWID;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_AWUSER;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_hist_out_rsc_AWUSER;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_WSTRB;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_hist_out_rsc_WSTRB;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_WUSER;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_hist_out_rsc_WUSER;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_BID;
  ccs_sc_logic_to_sc_lv1_adapter                                                       CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BID;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_BUSER;
  ccs_sc_logic_to_sc_lv1_adapter                                                       CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BUSER;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_ARID;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_hist_out_rsc_ARID;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_ARUSER;
  ccs_sc_lv1_to_sc_logic_adapter                                                       CCS_ADAPTOR_TLS_hist_out_rsc_ARUSER;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_RID;
  ccs_sc_logic_to_sc_lv1_adapter                                                       CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RID;
  sc_signal<sc_lv<1> >                                                                 CCS_ADAPTOR_hist_out_rsc_RUSER;
  ccs_sc_logic_to_sc_lv1_adapter                                                       CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RUSER;
  ccs_axi4_slave_mem_trans_rsc<256,8,8,8,0,0,12,8,0,0 >                                hist_out_rsc_INST;
  tlm::tlm_fifo<mgc_sysc_ver_array1D<ac_int<16, false >,8192> >                        TLS_in_fifo_data_in_data;
  tlm::tlm_fifo<mc_wait_ctrl>                                                          TLS_in_wait_ctrl_fifo_data_in_data;
  tlm::tlm_fifo<int>                                                                   TLS_in_fifo_data_in_data_sizecount;
  mc_channel_input_transactor<mgc_sysc_ver_array1D<ac_int<16, false >,8192>,16,false>  transactor_data_in_data;
  tlm::tlm_fifo<mgc_sysc_ver_array1D<ac_int<8, false >,256> >                          TLS_out_fifo_hist_out_data;
  tlm::tlm_fifo<mc_wait_ctrl>                                                          TLS_out_wait_ctrl_fifo_hist_out_data;
  mc_output_transactor<mgc_sysc_ver_array1D<ac_int<8, false >,256>,8,false>            transactor_hist_out_data;
  mc_testbench                                                                         testbench_INST;
  sc_signal<sc_logic>                                                                  catapult_start;
  sc_signal<sc_logic>                                                                  catapult_done;
  sc_signal<sc_logic>                                                                  catapult_ready;
  sc_signal<sc_logic>                                                                  in_sync;
  sc_signal<sc_logic>                                                                  out_sync;
  sc_signal<sc_logic>                                                                  inout_sync;
  sc_signal<unsigned>                                                                  wait_for_init;
  sync_generator                                                                       sync_generator_INST;
  catapult_monitor                                                                     catapult_monitor_INST;
  ccs_probe_monitor                                                                   *ccs_probe_monitor_INST;
  sc_event                                                                             generate_reset_event;
  sc_event                                                                             deadlock_event;
  sc_signal<sc_logic>                                                                  deadlocked;
  sc_signal<sc_logic>                                                                  maxsimtime;
  sc_event                                                                             max_sim_time_event;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_staller_inst_core_wen;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsci_inst_histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl_inst_data_in_rsci_s_re_core_sct;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsci_inst_histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl_inst_data_in_rsci_s_rrdy;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsci_inst_histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_raddr_core_sct;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst_hist_out_rsci_s_re_core_sct;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst_hist_out_rsci_s_we_core_sct;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst_hist_out_rsci_s_rrdy;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst_hist_out_rsci_s_wrdy;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_raddr_core_sct;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_waddr_core_sct;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsc_rls_obj_inst_histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl_inst_hist_out_rsc_rls_obj_ld_core_sct;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsc_rls_obj_inst_histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl_inst_data_in_rsc_rls_obj_ld_core_sct;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsc_req_obj_inst_histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl_inst_data_in_rsc_req_obj_vd;
  sc_signal<sc_logic>                                                                  OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsc_req_obj_inst_histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl_inst_hist_out_rsc_req_obj_vd;
  sc_signal<sc_logic>                                                                  TLS_enable_stalls;
  sc_signal<unsigned short>                                                            TLS_stall_coverage;

  void TLS_rst_method();
  void max_sim_time_notify();
  void start_of_simulation();
  void setup_debug();
  void debug(const char* varname, int flags, int count);
  void generate_reset();
  void install_observe_foreign_signals();
  void deadlock_watch();
  void deadlock_notify();

  // Constructor
  SC_HAS_PROCESS(scverify_top);
  scverify_top(const sc_module_name& name)
    : rst("rst")
    , rst_n("rst_n")
    , SIG_SC_LOGIC_0("SIG_SC_LOGIC_0")
    , SIG_SC_LOGIC_1("SIG_SC_LOGIC_1")
    , TLS_design_is_idle("TLS_design_is_idle")
    , TLS_design_is_idle_reg("TLS_design_is_idle_reg")
    , CCS_CLK_CTOR(clk, "clk", 10, SC_NS, 0.5, 0, SC_NS, false)
    , rst_driver("rst_driver", 120.000000, false)
    , TLS_rst("TLS_rst")
    , TLS_data_in_rsc_s_tdone("TLS_data_in_rsc_s_tdone")
    , TLS_data_in_rsc_tr_write_done("TLS_data_in_rsc_tr_write_done")
    , TLS_data_in_rsc_RREADY("TLS_data_in_rsc_RREADY")
    , TLS_data_in_rsc_RVALID("TLS_data_in_rsc_RVALID")
    , TLS_data_in_rsc_RUSER("TLS_data_in_rsc_RUSER")
    , TLS_data_in_rsc_RLAST("TLS_data_in_rsc_RLAST")
    , TLS_data_in_rsc_RRESP("TLS_data_in_rsc_RRESP")
    , TLS_data_in_rsc_RDATA("TLS_data_in_rsc_RDATA")
    , TLS_data_in_rsc_RID("TLS_data_in_rsc_RID")
    , TLS_data_in_rsc_ARREADY("TLS_data_in_rsc_ARREADY")
    , TLS_data_in_rsc_ARVALID("TLS_data_in_rsc_ARVALID")
    , TLS_data_in_rsc_ARUSER("TLS_data_in_rsc_ARUSER")
    , TLS_data_in_rsc_ARREGION("TLS_data_in_rsc_ARREGION")
    , TLS_data_in_rsc_ARQOS("TLS_data_in_rsc_ARQOS")
    , TLS_data_in_rsc_ARPROT("TLS_data_in_rsc_ARPROT")
    , TLS_data_in_rsc_ARCACHE("TLS_data_in_rsc_ARCACHE")
    , TLS_data_in_rsc_ARLOCK("TLS_data_in_rsc_ARLOCK")
    , TLS_data_in_rsc_ARBURST("TLS_data_in_rsc_ARBURST")
    , TLS_data_in_rsc_ARSIZE("TLS_data_in_rsc_ARSIZE")
    , TLS_data_in_rsc_ARLEN("TLS_data_in_rsc_ARLEN")
    , TLS_data_in_rsc_ARADDR("TLS_data_in_rsc_ARADDR")
    , TLS_data_in_rsc_ARID("TLS_data_in_rsc_ARID")
    , TLS_data_in_rsc_BREADY("TLS_data_in_rsc_BREADY")
    , TLS_data_in_rsc_BVALID("TLS_data_in_rsc_BVALID")
    , TLS_data_in_rsc_BUSER("TLS_data_in_rsc_BUSER")
    , TLS_data_in_rsc_BRESP("TLS_data_in_rsc_BRESP")
    , TLS_data_in_rsc_BID("TLS_data_in_rsc_BID")
    , TLS_data_in_rsc_WREADY("TLS_data_in_rsc_WREADY")
    , TLS_data_in_rsc_WVALID("TLS_data_in_rsc_WVALID")
    , TLS_data_in_rsc_WUSER("TLS_data_in_rsc_WUSER")
    , TLS_data_in_rsc_WLAST("TLS_data_in_rsc_WLAST")
    , TLS_data_in_rsc_WSTRB("TLS_data_in_rsc_WSTRB")
    , TLS_data_in_rsc_WDATA("TLS_data_in_rsc_WDATA")
    , TLS_data_in_rsc_AWREADY("TLS_data_in_rsc_AWREADY")
    , TLS_data_in_rsc_AWVALID("TLS_data_in_rsc_AWVALID")
    , TLS_data_in_rsc_AWUSER("TLS_data_in_rsc_AWUSER")
    , TLS_data_in_rsc_AWREGION("TLS_data_in_rsc_AWREGION")
    , TLS_data_in_rsc_AWQOS("TLS_data_in_rsc_AWQOS")
    , TLS_data_in_rsc_AWPROT("TLS_data_in_rsc_AWPROT")
    , TLS_data_in_rsc_AWCACHE("TLS_data_in_rsc_AWCACHE")
    , TLS_data_in_rsc_AWLOCK("TLS_data_in_rsc_AWLOCK")
    , TLS_data_in_rsc_AWBURST("TLS_data_in_rsc_AWBURST")
    , TLS_data_in_rsc_AWSIZE("TLS_data_in_rsc_AWSIZE")
    , TLS_data_in_rsc_AWLEN("TLS_data_in_rsc_AWLEN")
    , TLS_data_in_rsc_AWADDR("TLS_data_in_rsc_AWADDR")
    , TLS_data_in_rsc_AWID("TLS_data_in_rsc_AWID")
    , TLS_data_in_rsc_req_vz("TLS_data_in_rsc_req_vz")
    , TLS_data_in_rsc_rls_lz("TLS_data_in_rsc_rls_lz")
    , TLS_hist_out_rsc_s_tdone("TLS_hist_out_rsc_s_tdone")
    , TLS_hist_out_rsc_tr_write_done("TLS_hist_out_rsc_tr_write_done")
    , TLS_hist_out_rsc_RREADY("TLS_hist_out_rsc_RREADY")
    , TLS_hist_out_rsc_RVALID("TLS_hist_out_rsc_RVALID")
    , TLS_hist_out_rsc_RUSER("TLS_hist_out_rsc_RUSER")
    , TLS_hist_out_rsc_RLAST("TLS_hist_out_rsc_RLAST")
    , TLS_hist_out_rsc_RRESP("TLS_hist_out_rsc_RRESP")
    , TLS_hist_out_rsc_RDATA("TLS_hist_out_rsc_RDATA")
    , TLS_hist_out_rsc_RID("TLS_hist_out_rsc_RID")
    , TLS_hist_out_rsc_ARREADY("TLS_hist_out_rsc_ARREADY")
    , TLS_hist_out_rsc_ARVALID("TLS_hist_out_rsc_ARVALID")
    , TLS_hist_out_rsc_ARUSER("TLS_hist_out_rsc_ARUSER")
    , TLS_hist_out_rsc_ARREGION("TLS_hist_out_rsc_ARREGION")
    , TLS_hist_out_rsc_ARQOS("TLS_hist_out_rsc_ARQOS")
    , TLS_hist_out_rsc_ARPROT("TLS_hist_out_rsc_ARPROT")
    , TLS_hist_out_rsc_ARCACHE("TLS_hist_out_rsc_ARCACHE")
    , TLS_hist_out_rsc_ARLOCK("TLS_hist_out_rsc_ARLOCK")
    , TLS_hist_out_rsc_ARBURST("TLS_hist_out_rsc_ARBURST")
    , TLS_hist_out_rsc_ARSIZE("TLS_hist_out_rsc_ARSIZE")
    , TLS_hist_out_rsc_ARLEN("TLS_hist_out_rsc_ARLEN")
    , TLS_hist_out_rsc_ARADDR("TLS_hist_out_rsc_ARADDR")
    , TLS_hist_out_rsc_ARID("TLS_hist_out_rsc_ARID")
    , TLS_hist_out_rsc_BREADY("TLS_hist_out_rsc_BREADY")
    , TLS_hist_out_rsc_BVALID("TLS_hist_out_rsc_BVALID")
    , TLS_hist_out_rsc_BUSER("TLS_hist_out_rsc_BUSER")
    , TLS_hist_out_rsc_BRESP("TLS_hist_out_rsc_BRESP")
    , TLS_hist_out_rsc_BID("TLS_hist_out_rsc_BID")
    , TLS_hist_out_rsc_WREADY("TLS_hist_out_rsc_WREADY")
    , TLS_hist_out_rsc_WVALID("TLS_hist_out_rsc_WVALID")
    , TLS_hist_out_rsc_WUSER("TLS_hist_out_rsc_WUSER")
    , TLS_hist_out_rsc_WLAST("TLS_hist_out_rsc_WLAST")
    , TLS_hist_out_rsc_WSTRB("TLS_hist_out_rsc_WSTRB")
    , TLS_hist_out_rsc_WDATA("TLS_hist_out_rsc_WDATA")
    , TLS_hist_out_rsc_AWREADY("TLS_hist_out_rsc_AWREADY")
    , TLS_hist_out_rsc_AWVALID("TLS_hist_out_rsc_AWVALID")
    , TLS_hist_out_rsc_AWUSER("TLS_hist_out_rsc_AWUSER")
    , TLS_hist_out_rsc_AWREGION("TLS_hist_out_rsc_AWREGION")
    , TLS_hist_out_rsc_AWQOS("TLS_hist_out_rsc_AWQOS")
    , TLS_hist_out_rsc_AWPROT("TLS_hist_out_rsc_AWPROT")
    , TLS_hist_out_rsc_AWCACHE("TLS_hist_out_rsc_AWCACHE")
    , TLS_hist_out_rsc_AWLOCK("TLS_hist_out_rsc_AWLOCK")
    , TLS_hist_out_rsc_AWBURST("TLS_hist_out_rsc_AWBURST")
    , TLS_hist_out_rsc_AWSIZE("TLS_hist_out_rsc_AWSIZE")
    , TLS_hist_out_rsc_AWLEN("TLS_hist_out_rsc_AWLEN")
    , TLS_hist_out_rsc_AWADDR("TLS_hist_out_rsc_AWADDR")
    , TLS_hist_out_rsc_AWID("TLS_hist_out_rsc_AWID")
    , TLS_hist_out_rsc_req_vz("TLS_hist_out_rsc_req_vz")
    , TLS_hist_out_rsc_rls_lz("TLS_hist_out_rsc_rls_lz")
    , histogram_hls_INST("rtl", TO_QUOTED_STRING(TOP_HDL_ENTITY))
    , CCS_ADAPTOR_TLS_data_in_rsc_AWID("CCS_ADAPTOR_TLS_data_in_rsc_AWID")
    , CCS_ADAPTOR_TLS_data_in_rsc_AWUSER("CCS_ADAPTOR_TLS_data_in_rsc_AWUSER")
    , CCS_ADAPTOR_TLS_data_in_rsc_WUSER("CCS_ADAPTOR_TLS_data_in_rsc_WUSER")
    , CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BID("CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BID")
    , CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BUSER("CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BUSER")
    , CCS_ADAPTOR_TLS_data_in_rsc_ARID("CCS_ADAPTOR_TLS_data_in_rsc_ARID")
    , CCS_ADAPTOR_TLS_data_in_rsc_ARUSER("CCS_ADAPTOR_TLS_data_in_rsc_ARUSER")
    , CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RID("CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RID")
    , CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RUSER("CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RUSER")
    , data_in_rsc_INST("data_in_rsc", true)
    , CCS_ADAPTOR_TLS_hist_out_rsc_AWID("CCS_ADAPTOR_TLS_hist_out_rsc_AWID")
    , CCS_ADAPTOR_TLS_hist_out_rsc_AWUSER("CCS_ADAPTOR_TLS_hist_out_rsc_AWUSER")
    , CCS_ADAPTOR_TLS_hist_out_rsc_WSTRB("CCS_ADAPTOR_TLS_hist_out_rsc_WSTRB")
    , CCS_ADAPTOR_TLS_hist_out_rsc_WUSER("CCS_ADAPTOR_TLS_hist_out_rsc_WUSER")
    , CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BID("CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BID")
    , CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BUSER("CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BUSER")
    , CCS_ADAPTOR_TLS_hist_out_rsc_ARID("CCS_ADAPTOR_TLS_hist_out_rsc_ARID")
    , CCS_ADAPTOR_TLS_hist_out_rsc_ARUSER("CCS_ADAPTOR_TLS_hist_out_rsc_ARUSER")
    , CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RID("CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RID")
    , CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RUSER("CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RUSER")
    , hist_out_rsc_INST("hist_out_rsc", true)
    , TLS_in_fifo_data_in_data("TLS_in_fifo_data_in_data", -1)
    , TLS_in_wait_ctrl_fifo_data_in_data("TLS_in_wait_ctrl_fifo_data_in_data", -1)
    , TLS_in_fifo_data_in_data_sizecount("TLS_in_fifo_data_in_data_sizecount", 1)
    , transactor_data_in_data("transactor_data_in_data", 0, 131072, 0)
    , TLS_out_fifo_hist_out_data("TLS_out_fifo_hist_out_data", -1)
    , TLS_out_wait_ctrl_fifo_hist_out_data("TLS_out_wait_ctrl_fifo_hist_out_data", -1)
    , transactor_hist_out_data("transactor_hist_out_data", 0, 2048, 0)
    , testbench_INST("user_tb")
    , catapult_start("catapult_start")
    , catapult_done("catapult_done")
    , catapult_ready("catapult_ready")
    , in_sync("in_sync")
    , out_sync("out_sync")
    , inout_sync("inout_sync")
    , wait_for_init("wait_for_init")
    , sync_generator_INST("sync_generator", true, false, false, false, 12548, 12548, 0)
    , catapult_monitor_INST("Monitor", clk, true, 12548LL, 12547LL)
    , ccs_probe_monitor_INST(NULL)
    , deadlocked("deadlocked")
    , maxsimtime("maxsimtime")
  {
    rst_driver.reset_out(TLS_rst);

    histogram_hls_INST.clk(clk);
    histogram_hls_INST.rst(TLS_rst);
    histogram_hls_INST.data_in_rsc_s_tdone(TLS_data_in_rsc_s_tdone);
    histogram_hls_INST.data_in_rsc_tr_write_done(TLS_data_in_rsc_tr_write_done);
    histogram_hls_INST.data_in_rsc_RREADY(TLS_data_in_rsc_RREADY);
    histogram_hls_INST.data_in_rsc_RVALID(TLS_data_in_rsc_RVALID);
    histogram_hls_INST.data_in_rsc_RUSER(TLS_data_in_rsc_RUSER);
    histogram_hls_INST.data_in_rsc_RLAST(TLS_data_in_rsc_RLAST);
    histogram_hls_INST.data_in_rsc_RRESP(TLS_data_in_rsc_RRESP);
    histogram_hls_INST.data_in_rsc_RDATA(TLS_data_in_rsc_RDATA);
    histogram_hls_INST.data_in_rsc_RID(TLS_data_in_rsc_RID);
    histogram_hls_INST.data_in_rsc_ARREADY(TLS_data_in_rsc_ARREADY);
    histogram_hls_INST.data_in_rsc_ARVALID(TLS_data_in_rsc_ARVALID);
    histogram_hls_INST.data_in_rsc_ARUSER(TLS_data_in_rsc_ARUSER);
    histogram_hls_INST.data_in_rsc_ARREGION(TLS_data_in_rsc_ARREGION);
    histogram_hls_INST.data_in_rsc_ARQOS(TLS_data_in_rsc_ARQOS);
    histogram_hls_INST.data_in_rsc_ARPROT(TLS_data_in_rsc_ARPROT);
    histogram_hls_INST.data_in_rsc_ARCACHE(TLS_data_in_rsc_ARCACHE);
    histogram_hls_INST.data_in_rsc_ARLOCK(TLS_data_in_rsc_ARLOCK);
    histogram_hls_INST.data_in_rsc_ARBURST(TLS_data_in_rsc_ARBURST);
    histogram_hls_INST.data_in_rsc_ARSIZE(TLS_data_in_rsc_ARSIZE);
    histogram_hls_INST.data_in_rsc_ARLEN(TLS_data_in_rsc_ARLEN);
    histogram_hls_INST.data_in_rsc_ARADDR(TLS_data_in_rsc_ARADDR);
    histogram_hls_INST.data_in_rsc_ARID(TLS_data_in_rsc_ARID);
    histogram_hls_INST.data_in_rsc_BREADY(TLS_data_in_rsc_BREADY);
    histogram_hls_INST.data_in_rsc_BVALID(TLS_data_in_rsc_BVALID);
    histogram_hls_INST.data_in_rsc_BUSER(TLS_data_in_rsc_BUSER);
    histogram_hls_INST.data_in_rsc_BRESP(TLS_data_in_rsc_BRESP);
    histogram_hls_INST.data_in_rsc_BID(TLS_data_in_rsc_BID);
    histogram_hls_INST.data_in_rsc_WREADY(TLS_data_in_rsc_WREADY);
    histogram_hls_INST.data_in_rsc_WVALID(TLS_data_in_rsc_WVALID);
    histogram_hls_INST.data_in_rsc_WUSER(TLS_data_in_rsc_WUSER);
    histogram_hls_INST.data_in_rsc_WLAST(TLS_data_in_rsc_WLAST);
    histogram_hls_INST.data_in_rsc_WSTRB(TLS_data_in_rsc_WSTRB);
    histogram_hls_INST.data_in_rsc_WDATA(TLS_data_in_rsc_WDATA);
    histogram_hls_INST.data_in_rsc_AWREADY(TLS_data_in_rsc_AWREADY);
    histogram_hls_INST.data_in_rsc_AWVALID(TLS_data_in_rsc_AWVALID);
    histogram_hls_INST.data_in_rsc_AWUSER(TLS_data_in_rsc_AWUSER);
    histogram_hls_INST.data_in_rsc_AWREGION(TLS_data_in_rsc_AWREGION);
    histogram_hls_INST.data_in_rsc_AWQOS(TLS_data_in_rsc_AWQOS);
    histogram_hls_INST.data_in_rsc_AWPROT(TLS_data_in_rsc_AWPROT);
    histogram_hls_INST.data_in_rsc_AWCACHE(TLS_data_in_rsc_AWCACHE);
    histogram_hls_INST.data_in_rsc_AWLOCK(TLS_data_in_rsc_AWLOCK);
    histogram_hls_INST.data_in_rsc_AWBURST(TLS_data_in_rsc_AWBURST);
    histogram_hls_INST.data_in_rsc_AWSIZE(TLS_data_in_rsc_AWSIZE);
    histogram_hls_INST.data_in_rsc_AWLEN(TLS_data_in_rsc_AWLEN);
    histogram_hls_INST.data_in_rsc_AWADDR(TLS_data_in_rsc_AWADDR);
    histogram_hls_INST.data_in_rsc_AWID(TLS_data_in_rsc_AWID);
    histogram_hls_INST.data_in_rsc_req_vz(TLS_data_in_rsc_req_vz);
    histogram_hls_INST.data_in_rsc_rls_lz(TLS_data_in_rsc_rls_lz);
    histogram_hls_INST.hist_out_rsc_s_tdone(TLS_hist_out_rsc_s_tdone);
    histogram_hls_INST.hist_out_rsc_tr_write_done(TLS_hist_out_rsc_tr_write_done);
    histogram_hls_INST.hist_out_rsc_RREADY(TLS_hist_out_rsc_RREADY);
    histogram_hls_INST.hist_out_rsc_RVALID(TLS_hist_out_rsc_RVALID);
    histogram_hls_INST.hist_out_rsc_RUSER(TLS_hist_out_rsc_RUSER);
    histogram_hls_INST.hist_out_rsc_RLAST(TLS_hist_out_rsc_RLAST);
    histogram_hls_INST.hist_out_rsc_RRESP(TLS_hist_out_rsc_RRESP);
    histogram_hls_INST.hist_out_rsc_RDATA(TLS_hist_out_rsc_RDATA);
    histogram_hls_INST.hist_out_rsc_RID(TLS_hist_out_rsc_RID);
    histogram_hls_INST.hist_out_rsc_ARREADY(TLS_hist_out_rsc_ARREADY);
    histogram_hls_INST.hist_out_rsc_ARVALID(TLS_hist_out_rsc_ARVALID);
    histogram_hls_INST.hist_out_rsc_ARUSER(TLS_hist_out_rsc_ARUSER);
    histogram_hls_INST.hist_out_rsc_ARREGION(TLS_hist_out_rsc_ARREGION);
    histogram_hls_INST.hist_out_rsc_ARQOS(TLS_hist_out_rsc_ARQOS);
    histogram_hls_INST.hist_out_rsc_ARPROT(TLS_hist_out_rsc_ARPROT);
    histogram_hls_INST.hist_out_rsc_ARCACHE(TLS_hist_out_rsc_ARCACHE);
    histogram_hls_INST.hist_out_rsc_ARLOCK(TLS_hist_out_rsc_ARLOCK);
    histogram_hls_INST.hist_out_rsc_ARBURST(TLS_hist_out_rsc_ARBURST);
    histogram_hls_INST.hist_out_rsc_ARSIZE(TLS_hist_out_rsc_ARSIZE);
    histogram_hls_INST.hist_out_rsc_ARLEN(TLS_hist_out_rsc_ARLEN);
    histogram_hls_INST.hist_out_rsc_ARADDR(TLS_hist_out_rsc_ARADDR);
    histogram_hls_INST.hist_out_rsc_ARID(TLS_hist_out_rsc_ARID);
    histogram_hls_INST.hist_out_rsc_BREADY(TLS_hist_out_rsc_BREADY);
    histogram_hls_INST.hist_out_rsc_BVALID(TLS_hist_out_rsc_BVALID);
    histogram_hls_INST.hist_out_rsc_BUSER(TLS_hist_out_rsc_BUSER);
    histogram_hls_INST.hist_out_rsc_BRESP(TLS_hist_out_rsc_BRESP);
    histogram_hls_INST.hist_out_rsc_BID(TLS_hist_out_rsc_BID);
    histogram_hls_INST.hist_out_rsc_WREADY(TLS_hist_out_rsc_WREADY);
    histogram_hls_INST.hist_out_rsc_WVALID(TLS_hist_out_rsc_WVALID);
    histogram_hls_INST.hist_out_rsc_WUSER(TLS_hist_out_rsc_WUSER);
    histogram_hls_INST.hist_out_rsc_WLAST(TLS_hist_out_rsc_WLAST);
    histogram_hls_INST.hist_out_rsc_WSTRB(TLS_hist_out_rsc_WSTRB);
    histogram_hls_INST.hist_out_rsc_WDATA(TLS_hist_out_rsc_WDATA);
    histogram_hls_INST.hist_out_rsc_AWREADY(TLS_hist_out_rsc_AWREADY);
    histogram_hls_INST.hist_out_rsc_AWVALID(TLS_hist_out_rsc_AWVALID);
    histogram_hls_INST.hist_out_rsc_AWUSER(TLS_hist_out_rsc_AWUSER);
    histogram_hls_INST.hist_out_rsc_AWREGION(TLS_hist_out_rsc_AWREGION);
    histogram_hls_INST.hist_out_rsc_AWQOS(TLS_hist_out_rsc_AWQOS);
    histogram_hls_INST.hist_out_rsc_AWPROT(TLS_hist_out_rsc_AWPROT);
    histogram_hls_INST.hist_out_rsc_AWCACHE(TLS_hist_out_rsc_AWCACHE);
    histogram_hls_INST.hist_out_rsc_AWLOCK(TLS_hist_out_rsc_AWLOCK);
    histogram_hls_INST.hist_out_rsc_AWBURST(TLS_hist_out_rsc_AWBURST);
    histogram_hls_INST.hist_out_rsc_AWSIZE(TLS_hist_out_rsc_AWSIZE);
    histogram_hls_INST.hist_out_rsc_AWLEN(TLS_hist_out_rsc_AWLEN);
    histogram_hls_INST.hist_out_rsc_AWADDR(TLS_hist_out_rsc_AWADDR);
    histogram_hls_INST.hist_out_rsc_AWID(TLS_hist_out_rsc_AWID);
    histogram_hls_INST.hist_out_rsc_req_vz(TLS_hist_out_rsc_req_vz);
    histogram_hls_INST.hist_out_rsc_rls_lz(TLS_hist_out_rsc_rls_lz);

    CCS_ADAPTOR_TLS_data_in_rsc_AWID.inVECTOR(CCS_ADAPTOR_data_in_rsc_AWID);
    CCS_ADAPTOR_TLS_data_in_rsc_AWID.outSCALAR(TLS_data_in_rsc_AWID);

    CCS_ADAPTOR_TLS_data_in_rsc_AWUSER.inVECTOR(CCS_ADAPTOR_data_in_rsc_AWUSER);
    CCS_ADAPTOR_TLS_data_in_rsc_AWUSER.outSCALAR(TLS_data_in_rsc_AWUSER);

    CCS_ADAPTOR_TLS_data_in_rsc_WUSER.inVECTOR(CCS_ADAPTOR_data_in_rsc_WUSER);
    CCS_ADAPTOR_TLS_data_in_rsc_WUSER.outSCALAR(TLS_data_in_rsc_WUSER);

    CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BID.inSCALAR(TLS_data_in_rsc_BID);
    CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BID.outVECTOR(CCS_ADAPTOR_data_in_rsc_BID);

    CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BUSER.inSCALAR(TLS_data_in_rsc_BUSER);
    CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_BUSER.outVECTOR(CCS_ADAPTOR_data_in_rsc_BUSER);

    CCS_ADAPTOR_TLS_data_in_rsc_ARID.inVECTOR(CCS_ADAPTOR_data_in_rsc_ARID);
    CCS_ADAPTOR_TLS_data_in_rsc_ARID.outSCALAR(TLS_data_in_rsc_ARID);

    CCS_ADAPTOR_TLS_data_in_rsc_ARUSER.inVECTOR(CCS_ADAPTOR_data_in_rsc_ARUSER);
    CCS_ADAPTOR_TLS_data_in_rsc_ARUSER.outSCALAR(TLS_data_in_rsc_ARUSER);

    CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RID.inSCALAR(TLS_data_in_rsc_RID);
    CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RID.outVECTOR(CCS_ADAPTOR_data_in_rsc_RID);

    CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RUSER.inSCALAR(TLS_data_in_rsc_RUSER);
    CCS_ADAPTOR_CCS_ADAPTOR_data_in_rsc_RUSER.outVECTOR(CCS_ADAPTOR_data_in_rsc_RUSER);

    data_in_rsc_INST.ACLK(clk);
    data_in_rsc_INST.ARESETn(rst);
    data_in_rsc_INST.AWID(CCS_ADAPTOR_data_in_rsc_AWID);
    data_in_rsc_INST.AWADDR(TLS_data_in_rsc_AWADDR);
    data_in_rsc_INST.AWLEN(TLS_data_in_rsc_AWLEN);
    data_in_rsc_INST.AWSIZE(TLS_data_in_rsc_AWSIZE);
    data_in_rsc_INST.AWBURST(TLS_data_in_rsc_AWBURST);
    data_in_rsc_INST.AWLOCK(TLS_data_in_rsc_AWLOCK);
    data_in_rsc_INST.AWCACHE(TLS_data_in_rsc_AWCACHE);
    data_in_rsc_INST.AWPROT(TLS_data_in_rsc_AWPROT);
    data_in_rsc_INST.AWQOS(TLS_data_in_rsc_AWQOS);
    data_in_rsc_INST.AWREGION(TLS_data_in_rsc_AWREGION);
    data_in_rsc_INST.AWUSER(CCS_ADAPTOR_data_in_rsc_AWUSER);
    data_in_rsc_INST.AWVALID(TLS_data_in_rsc_AWVALID);
    data_in_rsc_INST.AWREADY(TLS_data_in_rsc_AWREADY);
    data_in_rsc_INST.WDATA(TLS_data_in_rsc_WDATA);
    data_in_rsc_INST.WSTRB(TLS_data_in_rsc_WSTRB);
    data_in_rsc_INST.WLAST(TLS_data_in_rsc_WLAST);
    data_in_rsc_INST.WUSER(CCS_ADAPTOR_data_in_rsc_WUSER);
    data_in_rsc_INST.WVALID(TLS_data_in_rsc_WVALID);
    data_in_rsc_INST.WREADY(TLS_data_in_rsc_WREADY);
    data_in_rsc_INST.BID(CCS_ADAPTOR_data_in_rsc_BID);
    data_in_rsc_INST.BRESP(TLS_data_in_rsc_BRESP);
    data_in_rsc_INST.BUSER(CCS_ADAPTOR_data_in_rsc_BUSER);
    data_in_rsc_INST.BVALID(TLS_data_in_rsc_BVALID);
    data_in_rsc_INST.BREADY(TLS_data_in_rsc_BREADY);
    data_in_rsc_INST.ARID(CCS_ADAPTOR_data_in_rsc_ARID);
    data_in_rsc_INST.ARADDR(TLS_data_in_rsc_ARADDR);
    data_in_rsc_INST.ARLEN(TLS_data_in_rsc_ARLEN);
    data_in_rsc_INST.ARSIZE(TLS_data_in_rsc_ARSIZE);
    data_in_rsc_INST.ARBURST(TLS_data_in_rsc_ARBURST);
    data_in_rsc_INST.ARLOCK(TLS_data_in_rsc_ARLOCK);
    data_in_rsc_INST.ARCACHE(TLS_data_in_rsc_ARCACHE);
    data_in_rsc_INST.ARPROT(TLS_data_in_rsc_ARPROT);
    data_in_rsc_INST.ARQOS(TLS_data_in_rsc_ARQOS);
    data_in_rsc_INST.ARREGION(TLS_data_in_rsc_ARREGION);
    data_in_rsc_INST.ARUSER(CCS_ADAPTOR_data_in_rsc_ARUSER);
    data_in_rsc_INST.ARVALID(TLS_data_in_rsc_ARVALID);
    data_in_rsc_INST.ARREADY(TLS_data_in_rsc_ARREADY);
    data_in_rsc_INST.RID(CCS_ADAPTOR_data_in_rsc_RID);
    data_in_rsc_INST.RDATA(TLS_data_in_rsc_RDATA);
    data_in_rsc_INST.RRESP(TLS_data_in_rsc_RRESP);
    data_in_rsc_INST.RLAST(TLS_data_in_rsc_RLAST);
    data_in_rsc_INST.RUSER(CCS_ADAPTOR_data_in_rsc_RUSER);
    data_in_rsc_INST.RVALID(TLS_data_in_rsc_RVALID);
    data_in_rsc_INST.RREADY(TLS_data_in_rsc_RREADY);
    data_in_rsc_INST.tr_write_done(TLS_data_in_rsc_tr_write_done);
    data_in_rsc_INST.s_tdone(TLS_data_in_rsc_s_tdone);
    data_in_rsc_INST.add_attribute(*(new sc_attribute<double>("CLK_SKEW_DELAY", __scv_hold_time_RSCID_1)));

    CCS_ADAPTOR_TLS_hist_out_rsc_AWID.inVECTOR(CCS_ADAPTOR_hist_out_rsc_AWID);
    CCS_ADAPTOR_TLS_hist_out_rsc_AWID.outSCALAR(TLS_hist_out_rsc_AWID);

    CCS_ADAPTOR_TLS_hist_out_rsc_AWUSER.inVECTOR(CCS_ADAPTOR_hist_out_rsc_AWUSER);
    CCS_ADAPTOR_TLS_hist_out_rsc_AWUSER.outSCALAR(TLS_hist_out_rsc_AWUSER);

    CCS_ADAPTOR_TLS_hist_out_rsc_WSTRB.inVECTOR(CCS_ADAPTOR_hist_out_rsc_WSTRB);
    CCS_ADAPTOR_TLS_hist_out_rsc_WSTRB.outSCALAR(TLS_hist_out_rsc_WSTRB);

    CCS_ADAPTOR_TLS_hist_out_rsc_WUSER.inVECTOR(CCS_ADAPTOR_hist_out_rsc_WUSER);
    CCS_ADAPTOR_TLS_hist_out_rsc_WUSER.outSCALAR(TLS_hist_out_rsc_WUSER);

    CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BID.inSCALAR(TLS_hist_out_rsc_BID);
    CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BID.outVECTOR(CCS_ADAPTOR_hist_out_rsc_BID);

    CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BUSER.inSCALAR(TLS_hist_out_rsc_BUSER);
    CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_BUSER.outVECTOR(CCS_ADAPTOR_hist_out_rsc_BUSER);

    CCS_ADAPTOR_TLS_hist_out_rsc_ARID.inVECTOR(CCS_ADAPTOR_hist_out_rsc_ARID);
    CCS_ADAPTOR_TLS_hist_out_rsc_ARID.outSCALAR(TLS_hist_out_rsc_ARID);

    CCS_ADAPTOR_TLS_hist_out_rsc_ARUSER.inVECTOR(CCS_ADAPTOR_hist_out_rsc_ARUSER);
    CCS_ADAPTOR_TLS_hist_out_rsc_ARUSER.outSCALAR(TLS_hist_out_rsc_ARUSER);

    CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RID.inSCALAR(TLS_hist_out_rsc_RID);
    CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RID.outVECTOR(CCS_ADAPTOR_hist_out_rsc_RID);

    CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RUSER.inSCALAR(TLS_hist_out_rsc_RUSER);
    CCS_ADAPTOR_CCS_ADAPTOR_hist_out_rsc_RUSER.outVECTOR(CCS_ADAPTOR_hist_out_rsc_RUSER);

    hist_out_rsc_INST.ACLK(clk);
    hist_out_rsc_INST.ARESETn(rst);
    hist_out_rsc_INST.AWID(CCS_ADAPTOR_hist_out_rsc_AWID);
    hist_out_rsc_INST.AWADDR(TLS_hist_out_rsc_AWADDR);
    hist_out_rsc_INST.AWLEN(TLS_hist_out_rsc_AWLEN);
    hist_out_rsc_INST.AWSIZE(TLS_hist_out_rsc_AWSIZE);
    hist_out_rsc_INST.AWBURST(TLS_hist_out_rsc_AWBURST);
    hist_out_rsc_INST.AWLOCK(TLS_hist_out_rsc_AWLOCK);
    hist_out_rsc_INST.AWCACHE(TLS_hist_out_rsc_AWCACHE);
    hist_out_rsc_INST.AWPROT(TLS_hist_out_rsc_AWPROT);
    hist_out_rsc_INST.AWQOS(TLS_hist_out_rsc_AWQOS);
    hist_out_rsc_INST.AWREGION(TLS_hist_out_rsc_AWREGION);
    hist_out_rsc_INST.AWUSER(CCS_ADAPTOR_hist_out_rsc_AWUSER);
    hist_out_rsc_INST.AWVALID(TLS_hist_out_rsc_AWVALID);
    hist_out_rsc_INST.AWREADY(TLS_hist_out_rsc_AWREADY);
    hist_out_rsc_INST.WDATA(TLS_hist_out_rsc_WDATA);
    hist_out_rsc_INST.WSTRB(CCS_ADAPTOR_hist_out_rsc_WSTRB);
    hist_out_rsc_INST.WLAST(TLS_hist_out_rsc_WLAST);
    hist_out_rsc_INST.WUSER(CCS_ADAPTOR_hist_out_rsc_WUSER);
    hist_out_rsc_INST.WVALID(TLS_hist_out_rsc_WVALID);
    hist_out_rsc_INST.WREADY(TLS_hist_out_rsc_WREADY);
    hist_out_rsc_INST.BID(CCS_ADAPTOR_hist_out_rsc_BID);
    hist_out_rsc_INST.BRESP(TLS_hist_out_rsc_BRESP);
    hist_out_rsc_INST.BUSER(CCS_ADAPTOR_hist_out_rsc_BUSER);
    hist_out_rsc_INST.BVALID(TLS_hist_out_rsc_BVALID);
    hist_out_rsc_INST.BREADY(TLS_hist_out_rsc_BREADY);
    hist_out_rsc_INST.ARID(CCS_ADAPTOR_hist_out_rsc_ARID);
    hist_out_rsc_INST.ARADDR(TLS_hist_out_rsc_ARADDR);
    hist_out_rsc_INST.ARLEN(TLS_hist_out_rsc_ARLEN);
    hist_out_rsc_INST.ARSIZE(TLS_hist_out_rsc_ARSIZE);
    hist_out_rsc_INST.ARBURST(TLS_hist_out_rsc_ARBURST);
    hist_out_rsc_INST.ARLOCK(TLS_hist_out_rsc_ARLOCK);
    hist_out_rsc_INST.ARCACHE(TLS_hist_out_rsc_ARCACHE);
    hist_out_rsc_INST.ARPROT(TLS_hist_out_rsc_ARPROT);
    hist_out_rsc_INST.ARQOS(TLS_hist_out_rsc_ARQOS);
    hist_out_rsc_INST.ARREGION(TLS_hist_out_rsc_ARREGION);
    hist_out_rsc_INST.ARUSER(CCS_ADAPTOR_hist_out_rsc_ARUSER);
    hist_out_rsc_INST.ARVALID(TLS_hist_out_rsc_ARVALID);
    hist_out_rsc_INST.ARREADY(TLS_hist_out_rsc_ARREADY);
    hist_out_rsc_INST.RID(CCS_ADAPTOR_hist_out_rsc_RID);
    hist_out_rsc_INST.RDATA(TLS_hist_out_rsc_RDATA);
    hist_out_rsc_INST.RRESP(TLS_hist_out_rsc_RRESP);
    hist_out_rsc_INST.RLAST(TLS_hist_out_rsc_RLAST);
    hist_out_rsc_INST.RUSER(CCS_ADAPTOR_hist_out_rsc_RUSER);
    hist_out_rsc_INST.RVALID(TLS_hist_out_rsc_RVALID);
    hist_out_rsc_INST.RREADY(TLS_hist_out_rsc_RREADY);
    hist_out_rsc_INST.tr_write_done(TLS_hist_out_rsc_tr_write_done);
    hist_out_rsc_INST.s_tdone(TLS_hist_out_rsc_s_tdone);
    hist_out_rsc_INST.add_attribute(*(new sc_attribute<double>("CLK_SKEW_DELAY", __scv_hold_time_RSCID_2)));

    transactor_data_in_data.in_fifo(TLS_in_fifo_data_in_data);
    transactor_data_in_data.in_wait_ctrl_fifo(TLS_in_wait_ctrl_fifo_data_in_data);
    transactor_data_in_data.sizecount_fifo(TLS_in_fifo_data_in_data_sizecount);
    transactor_data_in_data.bind_clk(clk, true, rst);
    transactor_data_in_data.add_attribute(*(new sc_attribute<int>("MC_TRANSACTOR_EVENT", 0 )));
    transactor_data_in_data.register_block(&data_in_rsc_INST, data_in_rsc_INST.basename(), TLS_data_in_rsc_rls_lz,
        0, 8191, 1);

    transactor_hist_out_data.out_fifo(TLS_out_fifo_hist_out_data);
    transactor_hist_out_data.out_wait_ctrl_fifo(TLS_out_wait_ctrl_fifo_hist_out_data);
    transactor_hist_out_data.bind_clk(clk, true, rst);
    transactor_hist_out_data.add_attribute(*(new sc_attribute<int>("MC_TRANSACTOR_EVENT", 0 )));
    transactor_hist_out_data.register_block(&hist_out_rsc_INST, hist_out_rsc_INST.basename(), TLS_hist_out_rsc_rls_lz,
        0, 255, 1);

    testbench_INST.clk(clk);
    testbench_INST.ccs_data_in_data(TLS_in_fifo_data_in_data);
    testbench_INST.ccs_wait_ctrl_data_in_data(TLS_in_wait_ctrl_fifo_data_in_data);
    testbench_INST.ccs_sizecount_data_in_data(TLS_in_fifo_data_in_data_sizecount);
    testbench_INST.ccs_hist_out_data(TLS_out_fifo_hist_out_data);
    testbench_INST.ccs_wait_ctrl_hist_out_data(TLS_out_wait_ctrl_fifo_hist_out_data);
    testbench_INST.design_is_idle(TLS_design_is_idle_reg);
    testbench_INST.enable_stalls(TLS_enable_stalls);
    testbench_INST.stall_coverage(TLS_stall_coverage);

    sync_generator_INST.clk(clk);
    sync_generator_INST.rst(rst);
    sync_generator_INST.in_sync(in_sync);
    sync_generator_INST.out_sync(out_sync);
    sync_generator_INST.inout_sync(inout_sync);
    sync_generator_INST.wait_for_init(wait_for_init);
    sync_generator_INST.catapult_start(catapult_start);
    sync_generator_INST.catapult_ready(catapult_ready);
    sync_generator_INST.catapult_done(catapult_done);

    catapult_monitor_INST.rst(rst);


    SC_METHOD(TLS_rst_method);
      sensitive_pos << TLS_rst;
      dont_initialize();

    SC_METHOD(max_sim_time_notify);
      sensitive << max_sim_time_event;
      dont_initialize();

    SC_METHOD(generate_reset);
      sensitive << generate_reset_event;
      sensitive << testbench_INST.reset_request_event;

    SC_METHOD(deadlock_watch);
      sensitive << clk;
      dont_initialize();

    SC_METHOD(deadlock_notify);
      sensitive << deadlock_event;
      dont_initialize();


    TLS_data_in_rsc_req_vz.write(SC_LOGIC_1);
    TLS_hist_out_rsc_req_vz.write(SC_LOGIC_1);
    #if defined(CCS_SCVERIFY) && defined(CCS_DUT_RTL) && !defined(CCS_DUT_SYSC) && !defined(CCS_SYSC) && !defined(CCS_DUT_POWER)
        ccs_probe_monitor_INST = new ccs_probe_monitor("ccs_probe_monitor");
    ccs_probe_monitor_INST->clk(clk);
    ccs_probe_monitor_INST->rst(rst);
    #endif
    SIG_SC_LOGIC_0.write(SC_LOGIC_0);
    SIG_SC_LOGIC_1.write(SC_LOGIC_1);
    mt19937_init_genrand(19650218UL);
    install_observe_foreign_signals();
  }
};
void scverify_top::TLS_rst_method() {
  std::ostringstream msg;
  msg << "TLS_rst active @ " << sc_time_stamp();
  SC_REPORT_INFO("HW reset", msg.str().c_str());
  data_in_rsc_INST.clear();
  hist_out_rsc_INST.clear();
}

void scverify_top::max_sim_time_notify() {
  testbench_INST.set_failed(true);
  testbench_INST.check_results();
  SC_REPORT_ERROR("System", "Specified maximum simulation time reached");
  sc_stop();
}

void scverify_top::start_of_simulation() {
  char *SCVerify_AUTOWAIT = getenv("SCVerify_AUTOWAIT");
  if (SCVerify_AUTOWAIT) {
    int l = atoi(SCVerify_AUTOWAIT);
    transactor_data_in_data.set_auto_wait_limit(l);
    transactor_hist_out_data.set_auto_wait_limit(l);
  }
}

void scverify_top::setup_debug() {
#ifdef MC_DEFAULT_TRANSACTOR_LOG
  static int transactor_data_in_data_flags = MC_DEFAULT_TRANSACTOR_LOG;
  static int transactor_hist_out_data_flags = MC_DEFAULT_TRANSACTOR_LOG;
#else
  static int transactor_data_in_data_flags = MC_TRANSACTOR_UNDERFLOW | MC_TRANSACTOR_WAIT;
  static int transactor_hist_out_data_flags = MC_TRANSACTOR_UNDERFLOW | MC_TRANSACTOR_WAIT;
#endif
  static int transactor_data_in_data_count = -1;
  static int transactor_hist_out_data_count = -1;

  // At the breakpoint, modify the local variables
  // above to turn on/off different levels of transaction
  // logging for each variable. Available flags are:
  //   MC_TRANSACTOR_EMPTY       - log empty FIFOs (on by default)
  //   MC_TRANSACTOR_UNDERFLOW   - log FIFOs that run empty and then are loaded again (off)
  //   MC_TRANSACTOR_READ        - log all read events
  //   MC_TRANSACTOR_WRITE       - log all write events
  //   MC_TRANSACTOR_LOAD        - log all FIFO load events
  //   MC_TRANSACTOR_DUMP        - log all FIFO dump events
  //   MC_TRANSACTOR_STREAMCNT   - log all streamed port index counter events
  //   MC_TRANSACTOR_WAIT        - log user specified handshake waits
  //   MC_TRANSACTOR_SIZE        - log input FIFO size updates

  std::ifstream debug_cmds;
  debug_cmds.open("scverify.cmd",std::fstream::in);
  if (debug_cmds.is_open()) {
    std::cout << "Reading SCVerify debug commands from file 'scverify.cmd'" << std::endl;
    std::string line;
    while (getline(debug_cmds,line)) {
      std::size_t pos1 = line.find(" ");
      if (pos1 == std::string::npos) continue;
      std::size_t pos2 = line.find(" ", pos1+1);
      std::string varname = line.substr(0,pos1);
      std::string flags = line.substr(pos1+1,pos2-pos1-1);
      std::string count = line.substr(pos2+1);
      debug(varname.c_str(),std::atoi(flags.c_str()),std::atoi(count.c_str()));
    }
    debug_cmds.close();
  } else {
    debug("transactor_data_in_data",transactor_data_in_data_flags,transactor_data_in_data_count);
    debug("transactor_hist_out_data",transactor_hist_out_data_flags,transactor_hist_out_data_count);
  }
}

void scverify_top::debug(const char* varname, int flags, int count) {
  sc_module *xlator_p = 0;
  sc_attr_base *debug_attr_p = 0;
  if (strcmp(varname,"transactor_data_in_data") == 0)
    xlator_p = &transactor_data_in_data;
  if (strcmp(varname,"transactor_hist_out_data") == 0)
    xlator_p = &transactor_hist_out_data;
  if (xlator_p) {
    debug_attr_p = xlator_p->get_attribute("MC_TRANSACTOR_EVENT");
    if (!debug_attr_p) {
      debug_attr_p = new sc_attribute<int>("MC_TRANSACTOR_EVENT",flags);
      xlator_p->add_attribute(*debug_attr_p);
    }
    ((sc_attribute<int>*)debug_attr_p)->value = flags;
  }

  if (count>=0) {
    debug_attr_p = xlator_p->get_attribute("MC_TRANSACTOR_COUNT");
    if (!debug_attr_p) {
      debug_attr_p = new sc_attribute<int>("MC_TRANSACTOR_COUNT",count);
      xlator_p->add_attribute(*debug_attr_p);
    }
    ((sc_attribute<int>*)debug_attr_p)->value = count;
  }
}

// Process: SC_METHOD generate_reset
void scverify_top::generate_reset() {
  static bool activate_reset = true;
  static bool toggle_hw_reset = false;
  if (activate_reset || sc_time_stamp() == SC_ZERO_TIME) {
    setup_debug();
    activate_reset = false;
    rst.write(SC_LOGIC_1);
    rst_driver.reset_driver();
    generate_reset_event.notify(120.000000 , SC_NS);
  } else {
    if (toggle_hw_reset) {
      toggle_hw_reset = false;
      generate_reset_event.notify(120.000000 , SC_NS);
    } else {
      transactor_data_in_data.reset_streams();
      transactor_hist_out_data.reset_streams();
      rst.write(SC_LOGIC_0);
    }
    activate_reset = true;
  }
}

void scverify_top::install_observe_foreign_signals() {
#if !defined(CCS_DUT_SYSC) && defined(DEADLOCK_DETECTION)
#if defined(CCS_DUT_CYCLE) || defined(CCS_DUT_RTL)
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_staller_inst_core_wen,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_staller_inst/core_wen);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsci_inst_histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl_inst_data_in_rsci_s_re_core_sct,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_data_in_rsci_inst/histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl_inst/data_in_rsci_s_re_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsci_inst_histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl_inst_data_in_rsci_s_rrdy,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_data_in_rsci_inst/histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl_inst/data_in_rsci_s_rrdy);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsci_inst_histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_raddr_core_sct,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_data_in_rsci_inst/histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst/data_in_rsci_s_raddr_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst_hist_out_rsci_s_re_core_sct,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_hist_out_rsci_inst/histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst/hist_out_rsci_s_re_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst_hist_out_rsci_s_we_core_sct,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_hist_out_rsci_inst/histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst/hist_out_rsci_s_we_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst_hist_out_rsci_s_rrdy,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_hist_out_rsci_inst/histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst/hist_out_rsci_s_rrdy);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst_hist_out_rsci_s_wrdy,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_hist_out_rsci_inst/histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst/hist_out_rsci_s_wrdy);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_raddr_core_sct,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_hist_out_rsci_inst/histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst/hist_out_rsci_s_raddr_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsci_inst_histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_waddr_core_sct,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_hist_out_rsci_inst/histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst/hist_out_rsci_s_waddr_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsc_rls_obj_inst_histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl_inst_hist_out_rsc_rls_obj_ld_core_sct,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_hist_out_rsc_rls_obj_inst/histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl_inst/hist_out_rsc_rls_obj_ld_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsc_rls_obj_inst_histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl_inst_data_in_rsc_rls_obj_ld_core_sct,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_data_in_rsc_rls_obj_inst/histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl_inst/data_in_rsc_rls_obj_ld_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_data_in_rsc_req_obj_inst_histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl_inst_data_in_rsc_req_obj_vd,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_data_in_rsc_req_obj_inst/histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl_inst/data_in_rsc_req_obj_vd);
  OBSERVE_FOREIGN_SIGNAL(OFS_histogram_hls_struct_inst_histogram_hls_core_inst_histogram_hls_core_hist_out_rsc_req_obj_inst_histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl_inst_hist_out_rsc_req_obj_vd,
      /scverify_top/rtl/histogram_hls_struct_inst/histogram_hls_core_inst/histogram_hls_core_hist_out_rsc_req_obj_inst/histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl_inst/hist_out_rsc_req_obj_vd);
#endif
#endif
}

void scverify_top::deadlock_watch() {
#if !defined(CCS_DUT_SYSC) && defined(DEADLOCK_DETECTION)
#if defined(CCS_DUT_CYCLE) || defined(CCS_DUT_RTL)
#if defined(MTI_SYSTEMC) || defined(NCSC) || defined(VCS_SYSTEMC)
#endif
#endif
#endif
}

void scverify_top::deadlock_notify() {
  if (deadlocked.read() == SC_LOGIC_1) {
    testbench_INST.check_results();
    SC_REPORT_ERROR("System", "Simulation deadlock detected");
    sc_stop();
  }
}

#if defined(MC_SIMULATOR_OSCI) || defined(MC_SIMULATOR_VCS)
int sc_main(int argc, char *argv[]) {
  sc_report_handler::set_actions("/IEEE_Std_1666/deprecated", SC_DO_NOTHING);
  scverify_top scverify_top("scverify_top");
  sc_start();
  return scverify_top.testbench_INST.failed();
}
#else
MC_MODULE_EXPORT(scverify_top);
#endif
