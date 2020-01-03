#include <string>
#include <fstream>
#include <iostream>
#include "mc_testbench.h"
#include <mc_reset.h>
#include <mc_transactors.h>
#include <mc_scverify.h>
#include <mc_stall_ctrl.h>
#include "ccs_ioport_trans_rsc_v1.h"
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
#define TOP_HDL_ENTITY DCT
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
  sc_signal<sc_logic>                                                           rst;
  sc_signal<sc_logic>                                                           rst_n;
  sc_signal<sc_logic>                                                           SIG_SC_LOGIC_0;
  sc_signal<sc_logic>                                                           SIG_SC_LOGIC_1;
  sc_signal<sc_logic>                                                           TLS_design_is_idle;
  sc_signal<bool>                                                               TLS_design_is_idle_reg;
  sc_clock                                                                      clk;
  mc_programmable_reset                                                         rst_driver;
  sc_signal<sc_logic>                                                           TLS_rst;
  sc_signal<sc_lv<20> >                                                         TLS_dst_rsc_dat;
  sc_signal<sc_logic>                                                           TLS_dst_rsc_vld;
  sc_signal<sc_logic>                                                           TLS_dst_rsc_rdy;
  sc_signal<sc_lv<20> >                                                         TLS_src_rsc_dat;
  sc_signal<sc_logic>                                                           TLS_src_rsc_vld;
  sc_signal<sc_logic>                                                           TLS_src_rsc_rdy;
  ccs_DUT_wrapper                                                               DCT_INST;
  ccs_out_wait_trans_rsc_v1<1,20 >                                              dst_rsc_INST;
  ccs_in_wait_trans_rsc_v1<1,20 >                                               src_rsc_INST;
  tlm::tlm_fifo<ac_fixed<20, 8, true, AC_TRN, AC_WRAP > >                       TLS_out_fifo_dst;
  tlm::tlm_fifo<mc_wait_ctrl>                                                   TLS_out_wait_ctrl_fifo_dst;
  sc_signal<sc_logic>                                                           TLS_dst_rsc_trdone;
  mc_output_transactor<ac_fixed<20, 8, true, AC_TRN, AC_WRAP >,20,true>         transactor_dst;
  tlm::tlm_fifo<ac_fixed<20, 8, true, AC_TRN, AC_WRAP > >                       TLS_in_fifo_src;
  tlm::tlm_fifo<mc_wait_ctrl>                                                   TLS_in_wait_ctrl_fifo_src;
  tlm::tlm_fifo<int>                                                            TLS_in_fifo_src_sizecount;
  sc_signal<sc_logic>                                                           TLS_src_rsc_trdone;
  mc_channel_input_transactor<ac_fixed<20, 8, true, AC_TRN, AC_WRAP >,20,true>  transactor_src;
  mc_testbench                                                                  testbench_INST;
  sc_signal<sc_logic>                                                           catapult_start;
  sc_signal<sc_logic>                                                           catapult_done;
  sc_signal<sc_logic>                                                           catapult_ready;
  sc_signal<sc_logic>                                                           in_sync;
  sc_signal<sc_logic>                                                           out_sync;
  sc_signal<sc_logic>                                                           inout_sync;
  sc_signal<unsigned>                                                           wait_for_init;
  sync_generator                                                                sync_generator_INST;
  catapult_monitor                                                              catapult_monitor_INST;
  ccs_probe_monitor                                                            *ccs_probe_monitor_INST;
  sc_event                                                                      generate_reset_event;
  sc_event                                                                      deadlock_event;
  sc_signal<sc_logic>                                                           deadlocked;
  sc_signal<sc_logic>                                                           maxsimtime;
  sc_event                                                                      max_sim_time_event;
  sc_signal<sc_logic>                                                           OFS_DCT_core_inst_DCT_core_staller_inst_core_wen;
  sc_signal<sc_logic>                                                           OFS_DCT_core_inst_DCT_core_dst_rsci_inst_DCT_core_dst_rsci_dst_wait_ctrl_inst_dst_rsci_irdy;
  sc_signal<sc_logic>                                                           OFS_DCT_core_inst_DCT_core_dst_rsci_inst_DCT_core_dst_rsci_dst_wait_ctrl_inst_dst_rsci_ivld_core_sct;
  sc_signal<sc_logic>                                                           OFS_DCT_core_inst_DCT_core_src_rsci_inst_DCT_core_src_rsci_src_wait_ctrl_inst_src_rsci_irdy_core_sct;
  sc_signal<sc_logic>                                                           OFS_DCT_core_inst_DCT_core_src_rsci_inst_DCT_core_src_rsci_src_wait_ctrl_inst_src_rsci_ivld;
  sc_signal<sc_logic>                                                           OFS_dst_rsc_rdy;
  sc_signal<sc_logic>                                                           OFS_src_rsc_vld;
  sc_signal<sc_logic>                                                           TLS_enable_stalls;
  sc_signal<unsigned short>                                                     TLS_stall_coverage;

  void TLS_rst_method();
  void drive_TLS_dst_rsc_trdone();
  void drive_TLS_src_rsc_trdone();
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
    , TLS_dst_rsc_dat("TLS_dst_rsc_dat")
    , TLS_dst_rsc_vld("TLS_dst_rsc_vld")
    , TLS_dst_rsc_rdy("TLS_dst_rsc_rdy")
    , TLS_src_rsc_dat("TLS_src_rsc_dat")
    , TLS_src_rsc_vld("TLS_src_rsc_vld")
    , TLS_src_rsc_rdy("TLS_src_rsc_rdy")
    , DCT_INST("rtl", TO_QUOTED_STRING(TOP_HDL_ENTITY))
    , dst_rsc_INST("dst_rsc", true)
    , src_rsc_INST("src_rsc", true)
    , TLS_out_fifo_dst("TLS_out_fifo_dst", -1)
    , TLS_out_wait_ctrl_fifo_dst("TLS_out_wait_ctrl_fifo_dst", -1)
    , TLS_dst_rsc_trdone("TLS_dst_rsc_trdone")
    , transactor_dst("transactor_dst", 0, 20, 0)
    , TLS_in_fifo_src("TLS_in_fifo_src", -1)
    , TLS_in_wait_ctrl_fifo_src("TLS_in_wait_ctrl_fifo_src", -1)
    , TLS_in_fifo_src_sizecount("TLS_in_fifo_src_sizecount", 1)
    , TLS_src_rsc_trdone("TLS_src_rsc_trdone")
    , transactor_src("transactor_src", 0, 20, 0)
    , testbench_INST("user_tb")
    , catapult_start("catapult_start")
    , catapult_done("catapult_done")
    , catapult_ready("catapult_ready")
    , in_sync("in_sync")
    , out_sync("out_sync")
    , inout_sync("inout_sync")
    , wait_for_init("wait_for_init")
    , sync_generator_INST("sync_generator", true, false, false, false, 236005633, 236005633, 0)
    , catapult_monitor_INST("Monitor", clk, true, 236005633LL, 236005633LL)
    , ccs_probe_monitor_INST(NULL)
    , deadlocked("deadlocked")
    , maxsimtime("maxsimtime")
  {
    rst_driver.reset_out(TLS_rst);

    DCT_INST.clk(clk);
    DCT_INST.rst(TLS_rst);
    DCT_INST.dst_rsc_dat(TLS_dst_rsc_dat);
    DCT_INST.dst_rsc_vld(TLS_dst_rsc_vld);
    DCT_INST.dst_rsc_rdy(TLS_dst_rsc_rdy);
    DCT_INST.src_rsc_dat(TLS_src_rsc_dat);
    DCT_INST.src_rsc_vld(TLS_src_rsc_vld);
    DCT_INST.src_rsc_rdy(TLS_src_rsc_rdy);

    dst_rsc_INST.rdy(TLS_dst_rsc_rdy);
    dst_rsc_INST.vld(TLS_dst_rsc_vld);
    dst_rsc_INST.dat(TLS_dst_rsc_dat);
    dst_rsc_INST.clk(clk);
    dst_rsc_INST.add_attribute(*(new sc_attribute<double>("CLK_SKEW_DELAY", __scv_hold_time_RSCID_1)));

    src_rsc_INST.rdy(TLS_src_rsc_rdy);
    src_rsc_INST.vld(TLS_src_rsc_vld);
    src_rsc_INST.dat(TLS_src_rsc_dat);
    src_rsc_INST.clk(clk);
    src_rsc_INST.add_attribute(*(new sc_attribute<double>("CLK_SKEW_DELAY", __scv_hold_time_RSCID_2)));

    transactor_dst.out_fifo(TLS_out_fifo_dst);
    transactor_dst.out_wait_ctrl_fifo(TLS_out_wait_ctrl_fifo_dst);
    transactor_dst.bind_clk(clk, true, rst);
    transactor_dst.add_attribute(*(new sc_attribute<int>("MC_TRANSACTOR_EVENT", 0 )));
    transactor_dst.register_block(&dst_rsc_INST, dst_rsc_INST.basename(), TLS_dst_rsc_trdone, 0, 0, 1);

    transactor_src.in_fifo(TLS_in_fifo_src);
    transactor_src.in_wait_ctrl_fifo(TLS_in_wait_ctrl_fifo_src);
    transactor_src.sizecount_fifo(TLS_in_fifo_src_sizecount);
    transactor_src.bind_clk(clk, true, rst);
    transactor_src.add_attribute(*(new sc_attribute<int>("MC_TRANSACTOR_EVENT", 0 )));
    transactor_src.register_block(&src_rsc_INST, src_rsc_INST.basename(), TLS_src_rsc_trdone, 0, 0, 1);

    testbench_INST.clk(clk);
    testbench_INST.ccs_dst(TLS_out_fifo_dst);
    testbench_INST.ccs_wait_ctrl_dst(TLS_out_wait_ctrl_fifo_dst);
    testbench_INST.ccs_src(TLS_in_fifo_src);
    testbench_INST.ccs_wait_ctrl_src(TLS_in_wait_ctrl_fifo_src);
    testbench_INST.ccs_sizecount_src(TLS_in_fifo_src_sizecount);
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

    SC_METHOD(drive_TLS_dst_rsc_trdone);
      sensitive << TLS_dst_rsc_vld;
      sensitive << TLS_dst_rsc_rdy;

    SC_METHOD(drive_TLS_src_rsc_trdone);
      sensitive << TLS_src_rsc_rdy;
      sensitive << TLS_src_rsc_vld;
      sensitive << rst;

    SC_METHOD(max_sim_time_notify);
      sensitive << max_sim_time_event;
      dont_initialize();

    SC_METHOD(generate_reset);
      sensitive << generate_reset_event;
      sensitive << testbench_INST.reset_request_event;

    SC_METHOD(deadlock_watch);
      sensitive << clk;
      sensitive << OFS_DCT_core_inst_DCT_core_staller_inst_core_wen;
      dont_initialize();

    SC_METHOD(deadlock_notify);
      sensitive << deadlock_event;
      dont_initialize();


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
  dst_rsc_INST.clear();
  src_rsc_INST.clear();
}

void scverify_top::drive_TLS_dst_rsc_trdone() {
  if (rst.read()==sc_dt::Log_1) { assert(TLS_dst_rsc_vld.read()!= SC_LOGIC_1); }
  TLS_dst_rsc_trdone.write(TLS_dst_rsc_vld.read() & TLS_dst_rsc_rdy.read());
}

void scverify_top::drive_TLS_src_rsc_trdone() {
  if (rst.read()==sc_dt::Log_1) { assert(TLS_src_rsc_rdy.read()!= SC_LOGIC_1); }
  TLS_src_rsc_trdone.write(TLS_src_rsc_rdy.read() & TLS_src_rsc_vld.read() & ~rst.read());
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
    transactor_dst.set_auto_wait_limit(l);
    transactor_src.set_auto_wait_limit(l);
  }
}

void scverify_top::setup_debug() {
#ifdef MC_DEFAULT_TRANSACTOR_LOG
  static int transactor_dst_flags = MC_DEFAULT_TRANSACTOR_LOG;
  static int transactor_src_flags = MC_DEFAULT_TRANSACTOR_LOG;
#else
  static int transactor_dst_flags = MC_TRANSACTOR_UNDERFLOW | MC_TRANSACTOR_WAIT;
  static int transactor_src_flags = MC_TRANSACTOR_UNDERFLOW | MC_TRANSACTOR_WAIT;
#endif
  static int transactor_dst_count = -1;
  static int transactor_src_count = -1;

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
    debug("transactor_dst",transactor_dst_flags,transactor_dst_count);
    debug("transactor_src",transactor_src_flags,transactor_src_count);
  }
}

void scverify_top::debug(const char* varname, int flags, int count) {
  sc_module *xlator_p = 0;
  sc_attr_base *debug_attr_p = 0;
  if (strcmp(varname,"transactor_dst") == 0)
    xlator_p = &transactor_dst;
  if (strcmp(varname,"transactor_src") == 0)
    xlator_p = &transactor_src;
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
      transactor_dst.reset_streams();
      transactor_src.reset_streams();
      rst.write(SC_LOGIC_0);
    }
    activate_reset = true;
  }
}

void scverify_top::install_observe_foreign_signals() {
#if !defined(CCS_DUT_SYSC) && defined(DEADLOCK_DETECTION)
#if defined(CCS_DUT_CYCLE) || defined(CCS_DUT_RTL)
  OBSERVE_FOREIGN_SIGNAL(OFS_DCT_core_inst_DCT_core_staller_inst_core_wen, /scverify_top/rtl/DCT_core_inst/DCT_core_staller_inst/core_wen);
  OBSERVE_FOREIGN_SIGNAL(OFS_DCT_core_inst_DCT_core_dst_rsci_inst_DCT_core_dst_rsci_dst_wait_ctrl_inst_dst_rsci_irdy,
      /scverify_top/rtl/DCT_core_inst/DCT_core_dst_rsci_inst/DCT_core_dst_rsci_dst_wait_ctrl_inst/dst_rsci_irdy);
  OBSERVE_FOREIGN_SIGNAL(OFS_DCT_core_inst_DCT_core_dst_rsci_inst_DCT_core_dst_rsci_dst_wait_ctrl_inst_dst_rsci_ivld_core_sct,
      /scverify_top/rtl/DCT_core_inst/DCT_core_dst_rsci_inst/DCT_core_dst_rsci_dst_wait_ctrl_inst/dst_rsci_ivld_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_DCT_core_inst_DCT_core_src_rsci_inst_DCT_core_src_rsci_src_wait_ctrl_inst_src_rsci_irdy_core_sct,
      /scverify_top/rtl/DCT_core_inst/DCT_core_src_rsci_inst/DCT_core_src_rsci_src_wait_ctrl_inst/src_rsci_irdy_core_sct);
  OBSERVE_FOREIGN_SIGNAL(OFS_DCT_core_inst_DCT_core_src_rsci_inst_DCT_core_src_rsci_src_wait_ctrl_inst_src_rsci_ivld,
      /scverify_top/rtl/DCT_core_inst/DCT_core_src_rsci_inst/DCT_core_src_rsci_src_wait_ctrl_inst/src_rsci_ivld);
  OBSERVE_FOREIGN_SIGNAL(OFS_dst_rsc_rdy, /scverify_top/rtl/dst_rsc_rdy);
  OBSERVE_FOREIGN_SIGNAL(OFS_src_rsc_vld, /scverify_top/rtl/src_rsc_vld);
#endif
#endif
}

void scverify_top::deadlock_watch() {
#if !defined(CCS_DUT_SYSC) && defined(DEADLOCK_DETECTION)
#if defined(CCS_DUT_CYCLE) || defined(CCS_DUT_RTL)
#if defined(MTI_SYSTEMC) || defined(NCSC) || defined(VCS_SYSTEMC)
  if (!clk) {
    if (rst == SC_LOGIC_0 &&
      (OFS_DCT_core_inst_DCT_core_staller_inst_core_wen.read() == SC_LOGIC_0)
      && (OFS_dst_rsc_rdy.read() == SC_LOGIC_1)
      && (OFS_src_rsc_vld.read() == SC_LOGIC_1)
    ) {
      deadlocked.write(SC_LOGIC_1);
      deadlock_event.notify(21240506800, SC_NS);
    } else {
      if (deadlocked.read() == SC_LOGIC_1)
        deadlock_event.cancel();
      deadlocked.write(SC_LOGIC_0);
    }
  }
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
