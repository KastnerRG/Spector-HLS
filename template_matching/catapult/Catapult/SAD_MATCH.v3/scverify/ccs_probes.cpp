#include "ccs_probes.h"


#include <ccs_probe_comparator.h>

class ccs_probe_monitor : public sc_module
{
public:

  sc_in_clk       clk;
  sc_in<sc_logic> rst;

  SC_HAS_PROCESS(ccs_probe_monitor);
  ccs_probe_monitor(const sc_module_name& name)
    : sc_module(name)
    , clk("clk")
    , rst("rst")
  {
#if defined(MC_SIMULATOR_VCS) && defined(CCS_DUT_VHDL)
#warning SCVerify ac_probe monitoring does not work with VHDL netlists simulated in VCS
    std::cerr << "Warning: SCVerify ac_probe monitoring does not work with VHDL netlists simulated in VCS" << std::endl;
#endif
  }
};
