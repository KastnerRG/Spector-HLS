ifeq "$(CXX_HOME)" ""
CXX_HOME                                            := /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home
export CXX_HOME
endif
ifeq "$(CXX_TYPE)" ""
CXX_TYPE                                            := gcc
export CXX_TYPE
endif
ifeq "$(CXX_VCO)" ""
CXX_VCO                                             := aol
export CXX_VCO
endif
ifeq "$(Option_CppStandard)" ""
Option_CppStandard                                  := c++11
export Option_CppStandard
endif
ifeq "$(SYN_DIR)" ""
SYN_DIR                                             := gate_synthesis_xv
export SYN_DIR
endif
ifeq "$(HLD_CONSTRAINT_FNAME)" ""
HLD_CONSTRAINT_FNAME                                := top_gate_constraints.cpp
export HLD_CONSTRAINT_FNAME
endif
ifeq "$(TCLSH_CMD)" ""
TCLSH_CMD                                           := /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home/bin/tclsh8.5
export TCLSH_CMD
endif
ifeq "$(QuestaSIM_Path)" ""
QuestaSIM_Path                                      := $(MODEL_TECH)
export QuestaSIM_Path
endif
ifeq "$(QuestaSIM_FORCE_32BIT)" ""
QuestaSIM_FORCE_32BIT                               := 
export QuestaSIM_FORCE_32BIT
endif
ifeq "$(QuestaSIM_DEF_MODELSIM_INI)" ""
QuestaSIM_DEF_MODELSIM_INI                          := 
export QuestaSIM_DEF_MODELSIM_INI
endif
ifeq "$(QuestaSIM_ENABLE_VOPT)" ""
QuestaSIM_ENABLE_VOPT                               := true
export QuestaSIM_ENABLE_VOPT
endif
ifeq "$(QuestaSIM_VCOM_OPTS)" ""
QuestaSIM_VCOM_OPTS                                 := 
export QuestaSIM_VCOM_OPTS
endif
ifeq "$(QuestaSIM_VLOG_OPTS)" ""
QuestaSIM_VLOG_OPTS                                 := 
export QuestaSIM_VLOG_OPTS
endif
ifeq "$(QuestaSIM_SCCOM_OPTS)" ""
QuestaSIM_SCCOM_OPTS                                := -g -x c++ -Wall -Wno-unused-label -Wno-unknown-pragmas
export QuestaSIM_SCCOM_OPTS
endif
ifeq "$(QuestaSIM_VOPT_ARGS)" ""
QuestaSIM_VOPT_ARGS                                 := +acc=npr
export QuestaSIM_VOPT_ARGS
endif
ifeq "$(QuestaSIM_VSIM_OPTS)" ""
QuestaSIM_VSIM_OPTS                                 := -t ps
export QuestaSIM_VSIM_OPTS
endif
ifeq "$(QuestaSIM_GATE_VSIM_OPTS)" ""
QuestaSIM_GATE_VSIM_OPTS                            := +notimingchecks -sdfnoerror -noglitch
export QuestaSIM_GATE_VSIM_OPTS
endif
ifeq "$(QuestaSIM_RADIX)" ""
QuestaSIM_RADIX                                     := hex
export QuestaSIM_RADIX
endif
ifeq "$(QuestaSIM_MSIM_AC_TYPES)" ""
QuestaSIM_MSIM_AC_TYPES                             := true
export QuestaSIM_MSIM_AC_TYPES
endif
ifeq "$(QuestaSIM_MSIM_DOFILE)" ""
QuestaSIM_MSIM_DOFILE                               := 
export QuestaSIM_MSIM_DOFILE
endif
ifeq "$(QuestaSIM_VCD_SIZE_LIMIT)" ""
QuestaSIM_VCD_SIZE_LIMIT                            := 2000
export QuestaSIM_VCD_SIZE_LIMIT
endif
ifeq "$(QuestaSIM_ENABLE_CODE_COVERAGE)" ""
QuestaSIM_ENABLE_CODE_COVERAGE                      := false
export QuestaSIM_ENABLE_CODE_COVERAGE
endif
ifeq "$(QuestaSIM_QHOME)" ""
QuestaSIM_QHOME                                     := $(QHOME)
export QuestaSIM_QHOME
endif
ifeq "$(QuestaSIM_WITNESS_WAVEFORM)" ""
QuestaSIM_WITNESS_WAVEFORM                          := false
export QuestaSIM_WITNESS_WAVEFORM
endif
ifeq "$(QuestaSIM_COVERCHECK_TIMEOUT)" ""
QuestaSIM_COVERCHECK_TIMEOUT                        := 2m
export QuestaSIM_COVERCHECK_TIMEOUT
endif
ifeq "$(QuestaSIM_COVERCHECK_TCL)" ""
QuestaSIM_COVERCHECK_TCL                            := 
export QuestaSIM_COVERCHECK_TCL
endif
ifeq "$(QuestaSIM_SYSC_VERSION)" ""
QuestaSIM_SYSC_VERSION                              := 2.3
export QuestaSIM_SYSC_VERSION
endif
ifeq "$(QuestaSIM_SUPPRESS_WAVEFORMS)" ""
QuestaSIM_SUPPRESS_WAVEFORMS                        := false
export QuestaSIM_SUPPRESS_WAVEFORMS
endif
ifeq "$(QuestaSIM_QUESTA_VISUALIZER)" ""
QuestaSIM_QUESTA_VISUALIZER                         := $(VISUALIZER_HOME)
export QuestaSIM_QUESTA_VISUALIZER
endif
ifeq "$(QuestaSIM_ENABLE_QWAVE)" ""
QuestaSIM_ENABLE_QWAVE                              := false
export QuestaSIM_ENABLE_QWAVE
endif
ifeq "$(QuestaSIM_ALLOW_DUP_SYMS)" ""
QuestaSIM_ALLOW_DUP_SYMS                            := false
export QuestaSIM_ALLOW_DUP_SYMS
endif
ifeq "$(QuestaSIM_SHOW_LIST)" ""
QuestaSIM_SHOW_LIST                                 := false
export QuestaSIM_SHOW_LIST
endif
ifeq "$(QuestaSIM_ENABLE_OLD_MSIM_FLOW)" ""
QuestaSIM_ENABLE_OLD_MSIM_FLOW                      := false
export QuestaSIM_ENABLE_OLD_MSIM_FLOW
endif
ifeq "$(QuestaSIM_Flags)" ""
QuestaSIM_Flags                                     := 
export QuestaSIM_Flags
endif
ifeq "$(NCSim_NC_ROOT)" ""
NCSim_NC_ROOT                                       := $(NC_ROOT)
export NCSim_NC_ROOT
endif
ifeq "$(NCSim_FORCE_32BIT)" ""
NCSim_FORCE_32BIT                                   := 
export NCSim_FORCE_32BIT
endif
ifeq "$(NCSim_GCC_HOME)" ""
NCSim_GCC_HOME                                      := 
export NCSim_GCC_HOME
endif
ifeq "$(NCSim_NCSIM_GCCVERSION)" ""
NCSim_NCSIM_GCCVERSION                              := 
export NCSim_NCSIM_GCCVERSION
endif
ifeq "$(NCSim_NCVHDL_OPTS)" ""
NCSim_NCVHDL_OPTS                                   := -v93 -linedebug
export NCSim_NCVHDL_OPTS
endif
ifeq "$(NCSim_NCVLOG_OPTS)" ""
NCSim_NCVLOG_OPTS                                   := -linedebug
export NCSim_NCVLOG_OPTS
endif
ifeq "$(NCSim_NCSC_OPTS)" ""
NCSim_NCSC_OPTS                                     := 
export NCSim_NCSC_OPTS
endif
ifeq "$(NCSim_NCSC_CXX_OPTS)" ""
NCSim_NCSC_CXX_OPTS                                 := -x c++ -Wall -Wno-unknown-pragmas -Wno-deprecated
export NCSim_NCSC_CXX_OPTS
endif
ifeq "$(NCSim_NCELAB_OPTS)" ""
NCSim_NCELAB_OPTS                                   := 
export NCSim_NCELAB_OPTS
endif
ifeq "$(NCSim_NCSIM_OPTS)" ""
NCSim_NCSIM_OPTS                                    := 
export NCSim_NCSIM_OPTS
endif
ifeq "$(NCSim_NCSIM_TIMESCALE)" ""
NCSim_NCSIM_TIMESCALE                               := 1 ns / 1 ps
export NCSim_NCSIM_TIMESCALE
endif
ifeq "$(NCSim_NCSIM_SAIF_OPTIONS)" ""
NCSim_NCSIM_SAIF_OPTIONS                            := -verbose -overwrite -internal -hierarchy
export NCSim_NCSIM_SAIF_OPTIONS
endif
ifeq "$(NCSim_NCSIM_DOFILE)" ""
NCSim_NCSIM_DOFILE                                  := 
export NCSim_NCSIM_DOFILE
endif
ifeq "$(OSCI_SYSTEMC_INCLUDE)" ""
OSCI_SYSTEMC_INCLUDE                                := /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home/shared/include
export OSCI_SYSTEMC_INCLUDE
endif
ifeq "$(OSCI_SYSTEMC_LIB)" ""
OSCI_SYSTEMC_LIB                                    := /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home/shared/lib/$(CXX_OS)/$(CXX_TYPE)
export OSCI_SYSTEMC_LIB
endif
ifeq "$(OSCI_SYSTEMC_NAME)" ""
OSCI_SYSTEMC_NAME                                   := systemc
export OSCI_SYSTEMC_NAME
endif
ifeq "$(OSCI_COMP_FLAGS)" ""
OSCI_COMP_FLAGS                                     := -Wall -Wno-unknown-pragmas -Wno-unused-label
export OSCI_COMP_FLAGS
endif
ifeq "$(OSCI_USE_32BIT_COMPILER)" ""
OSCI_USE_32BIT_COMPILER                             := false
export OSCI_USE_32BIT_COMPILER
endif
ifeq "$(OSCI_GDBGUI)" ""
OSCI_GDBGUI                                         := ddd
export OSCI_GDBGUI
endif
ifeq "$(OSCI_GCOV)" ""
OSCI_GCOV                                           := false
export OSCI_GCOV
endif
ifeq "$(OSCI_LCOVDIR)" ""
OSCI_LCOVDIR                                        := $(LCOVDIR)
export OSCI_LCOVDIR
endif
ifeq "$(Novas_NOVAS_INST_DIR)" ""
Novas_NOVAS_INST_DIR                                := $(NOVAS_INST_DIR)
export Novas_NOVAS_INST_DIR
endif
ifeq "$(Novas_NOVAS_PLATFORM)" ""
Novas_NOVAS_PLATFORM                                := LINUX
export Novas_NOVAS_PLATFORM
endif
ifeq "$(Novas_NOVAS_MSIM_PLI)" ""
Novas_NOVAS_MSIM_PLI                                := modelsim_fli61
export Novas_NOVAS_MSIM_PLI
endif
ifeq "$(Novas_NOVAS_NCSIM_VER)" ""
Novas_NOVAS_NCSIM_VER                               := nc57_vhdl
export Novas_NOVAS_NCSIM_VER
endif
ifeq "$(Novas_NOVAS_NCSIM_PLI)" ""
Novas_NOVAS_NCSIM_PLI                               := ncsc57/lib-linux_gcc3_23
export Novas_NOVAS_NCSIM_PLI
endif
ifeq "$(Novas_NOVAS_NCSIM_LDV)" ""
Novas_NOVAS_NCSIM_LDV                               := ius_vhpi_latest
export Novas_NOVAS_NCSIM_LDV
endif
ifeq "$(Novas_NOVAS_NCSIM_FSDBW)" ""
Novas_NOVAS_NCSIM_FSDBW                             := LINUX_GNU_296
export Novas_NOVAS_NCSIM_FSDBW
endif
ifeq "$(Novas_VERDI_VERSION)" ""
Novas_VERDI_VERSION                                 := N-2017.12
export Novas_VERDI_VERSION
endif
ifeq "$(Valgrind_VALGRIND)" ""
Valgrind_VALGRIND                                   := /usr/opt/bin/valgrind
export Valgrind_VALGRIND
endif
ifeq "$(Valgrind_VALGRIND_OPTS)" ""
Valgrind_VALGRIND_OPTS                              := --demangle=yes --leak-check=no --undef-value-errors=yes
export Valgrind_VALGRIND_OPTS
endif
ifeq "$(VCS_VCS_HOME)" ""
VCS_VCS_HOME                                        := $(VCS_HOME)
export VCS_VCS_HOME
endif
ifeq "$(VCS_FORCE_32BIT)" ""
VCS_FORCE_32BIT                                     := 
export VCS_FORCE_32BIT
endif
ifeq "$(VCS_VG_GNU_PACKAGE)" ""
VCS_VG_GNU_PACKAGE                                  := $(VG_GNU_PACKAGE)
export VCS_VG_GNU_PACKAGE
endif
ifeq "$(VCS_VG_ENV32_SCRIPT)" ""
VCS_VG_ENV32_SCRIPT                                 := source_me_32.csh
export VCS_VG_ENV32_SCRIPT
endif
ifeq "$(VCS_VG_ENV64_SCRIPT)" ""
VCS_VG_ENV64_SCRIPT                                 := source_me_64.csh
export VCS_VG_ENV64_SCRIPT
endif
ifeq "$(VCS_COMP_FLAGS)" ""
VCS_COMP_FLAGS                                      := -g -Wall -Wno-unknown-pragmas
export VCS_COMP_FLAGS
endif
ifeq "$(VCS_VHDLAN_OPTS)" ""
VCS_VHDLAN_OPTS                                     := 
export VCS_VHDLAN_OPTS
endif
ifeq "$(VCS_VLOGAN_OPTS)" ""
VCS_VLOGAN_OPTS                                     := +v2k
export VCS_VLOGAN_OPTS
endif
ifeq "$(VCS_VCSELAB_OPTS)" ""
VCS_VCSELAB_OPTS                                    := -debug_all -timescale=1ps/1ps -sysc=blocksync
export VCS_VCSELAB_OPTS
endif
ifeq "$(VCS_VCSSIM_OPTS)" ""
VCS_VCSSIM_OPTS                                     := 
export VCS_VCSSIM_OPTS
endif
ifeq "$(VCS_VCS_GCC_VER)" ""
VCS_VCS_GCC_VER                                     := 4.2.2
export VCS_VCS_GCC_VER
endif
ifeq "$(VCS_VCS_DOFILE)" ""
VCS_VCS_DOFILE                                      := 
export VCS_VCS_DOFILE
endif
ifeq "$(VCS_SYSC_VERSION)" ""
VCS_SYSC_VERSION                                    := 2.3
export VCS_SYSC_VERSION
endif
ifeq "$(VCS_LIC_QUEUE)" ""
VCS_LIC_QUEUE                                       := false
export VCS_LIC_QUEUE
endif
ifeq "$(VCS_ENABLE_CODE_COVERAGE)" ""
VCS_ENABLE_CODE_COVERAGE                            := false
export VCS_ENABLE_CODE_COVERAGE
endif
ifeq "$(DesignAnalyzer_Exe)" ""
DesignAnalyzer_Exe                                  := $(CATAPULT_DESIGN_ANALYZER)
export DesignAnalyzer_Exe
endif
ifeq "$(DesignAnalyzer_lddDebug)" ""
DesignAnalyzer_lddDebug                             := false
export DesignAnalyzer_lddDebug
endif
ifeq "$(SCVerify_RESET_CYCLES)" ""
SCVerify_RESET_CYCLES                               := 2
export SCVerify_RESET_CYCLES
endif
ifeq "$(SCVerify_SYNC_ALL_RESETS)" ""
SCVerify_SYNC_ALL_RESETS                            := true
export SCVerify_SYNC_ALL_RESETS
endif
ifeq "$(SCVerify_TB_STACKSIZE)" ""
SCVerify_TB_STACKSIZE                               := 64000000
export SCVerify_TB_STACKSIZE
endif
ifeq "$(SCVerify_INVOKE_ARGS)" ""
SCVerify_INVOKE_ARGS                                := 
export SCVerify_INVOKE_ARGS
endif
ifeq "$(SCVerify_REPLAY_ARGS)" ""
SCVerify_REPLAY_ARGS                                := 
export SCVerify_REPLAY_ARGS
endif
ifeq "$(SCVerify_QUESTASIM_DEBUG)" ""
SCVerify_QUESTASIM_DEBUG                            := false
export SCVerify_QUESTASIM_DEBUG
endif
ifeq "$(SCVerify_MAX_ERROR_CNT)" ""
SCVerify_MAX_ERROR_CNT                              := 0
export SCVerify_MAX_ERROR_CNT
endif
ifeq "$(SCVerify_DEADLOCK_DETECTION)" ""
SCVerify_DEADLOCK_DETECTION                         := true
export SCVerify_DEADLOCK_DETECTION
endif
ifeq "$(SCVerify_MAX_SIM_TIME)" ""
SCVerify_MAX_SIM_TIME                               := 0
export SCVerify_MAX_SIM_TIME
endif
ifeq "$(SCVerify_MAX_DEADLOCK_TIMER)" ""
SCVerify_MAX_DEADLOCK_TIMER                         := 0
export SCVerify_MAX_DEADLOCK_TIMER
endif
ifeq "$(SCVerify_INCL_DIRS)" ""
SCVerify_INCL_DIRS                                  := 
export SCVerify_INCL_DIRS
endif
ifeq "$(SCVerify_LINK_LIBPATHS)" ""
SCVerify_LINK_LIBPATHS                              := 
export SCVerify_LINK_LIBPATHS
endif
ifeq "$(SCVerify_LINK_LIBNAMES)" ""
SCVerify_LINK_LIBNAMES                              := 
export SCVerify_LINK_LIBNAMES
endif
ifeq "$(SCVerify_USE_QUESTASIM)" ""
SCVerify_USE_QUESTASIM                              := true
export SCVerify_USE_QUESTASIM
endif
ifeq "$(SCVerify_USE_OSCI)" ""
SCVerify_USE_OSCI                                   := true
export SCVerify_USE_OSCI
endif
ifeq "$(SCVerify_USE_NCSIM)" ""
SCVerify_USE_NCSIM                                  := false
export SCVerify_USE_NCSIM
endif
ifeq "$(SCVerify_USE_VCS)" ""
SCVerify_USE_VCS                                    := false
export SCVerify_USE_VCS
endif
ifeq "$(SCVerify_DISABLE_EMPTY_INPUTS)" ""
SCVerify_DISABLE_EMPTY_INPUTS                       := false
export SCVerify_DISABLE_EMPTY_INPUTS
endif
ifeq "$(SCVerify_IDLE_SYNCHRONIZATION_MODE)" ""
SCVerify_IDLE_SYNCHRONIZATION_MODE                  := false
export SCVerify_IDLE_SYNCHRONIZATION_MODE
endif
ifeq "$(SCVerify_MISMATCHED_OUTPUTS_ONLY)" ""
SCVerify_MISMATCHED_OUTPUTS_ONLY                    := true
export SCVerify_MISMATCHED_OUTPUTS_ONLY
endif
ifeq "$(SCVerify_WAVE_PROBES)" ""
SCVerify_WAVE_PROBES                                := false
export SCVerify_WAVE_PROBES
endif
ifeq "$(SCVerify_OPTIMIZE_WRAPPERS)" ""
SCVerify_OPTIMIZE_WRAPPERS                          := false
export SCVerify_OPTIMIZE_WRAPPERS
endif
ifeq "$(SCVerify_GENERATE_STAGES)" ""
SCVerify_GENERATE_STAGES                            := schedule extract switching power
export SCVerify_GENERATE_STAGES
endif
ifeq "$(SCVerify_USE_CCS_BLOCK)" ""
SCVerify_USE_CCS_BLOCK                              := false
export SCVerify_USE_CCS_BLOCK
endif
ifeq "$(SCVerify_AUTOWAIT)" ""
SCVerify_AUTOWAIT                                   := 0
export SCVerify_AUTOWAIT
endif
ifeq "$(SCVerify_ENABLE_STALL_TOGGLE)" ""
SCVerify_ENABLE_STALL_TOGGLE                        := false
export SCVerify_ENABLE_STALL_TOGGLE
endif
ifeq "$(SCVerify_ENABLE_RESET_TOGGLE)" ""
SCVerify_ENABLE_RESET_TOGGLE                        := false
export SCVerify_ENABLE_RESET_TOGGLE
endif
ifeq "$(SCVerify_USE_VISTA)" ""
SCVerify_USE_VISTA                                  := false
export SCVerify_USE_VISTA
endif
ifeq "$(SCVerify_ENABLE_REPLAY_VERIFICATION)" ""
SCVerify_ENABLE_REPLAY_VERIFICATION                 := false
export SCVerify_ENABLE_REPLAY_VERIFICATION
endif
ifeq "$(SCVerify_ENABLE_CPP_SCVERIFY_TOP)" ""
SCVerify_ENABLE_CPP_SCVERIFY_TOP                    := true
export SCVerify_ENABLE_CPP_SCVERIFY_TOP
endif
ifeq "$(SCVerify_KEEP_UNUSED_TRANSACTION_CTRLS)" ""
SCVerify_KEEP_UNUSED_TRANSACTION_CTRLS              := true
export SCVerify_KEEP_UNUSED_TRANSACTION_CTRLS
endif
ifeq "$(SCVerify_USE_MSIM)" ""
SCVerify_USE_MSIM                                   := true
export SCVerify_USE_MSIM
endif
ifeq "$(SCVerify_MSIM_DEBUG)" ""
SCVerify_MSIM_DEBUG                                 := false
export SCVerify_MSIM_DEBUG
endif
ifeq "$(LowPower_GLOBAL_OPTIONS)" ""
LowPower_GLOBAL_OPTIONS                             := 
export LowPower_GLOBAL_OPTIONS
endif
ifeq "$(LowPower_WIRELOAD_MODE)" ""
LowPower_WIRELOAD_MODE                              := top
export LowPower_WIRELOAD_MODE
endif
ifeq "$(LowPower_WIRELOAD_MODEL)" ""
LowPower_WIRELOAD_MODEL                             := 
export LowPower_WIRELOAD_MODEL
endif
ifeq "$(LowPower_CLOCK_TREE_BUFFER)" ""
LowPower_CLOCK_TREE_BUFFER                          := 
export LowPower_CLOCK_TREE_BUFFER
endif
ifeq "$(LowPower_CLOCK_TREE_FANOUT)" ""
LowPower_CLOCK_TREE_FANOUT                          := 16
export LowPower_CLOCK_TREE_FANOUT
endif
ifeq "$(LowPower_CLOCK_TREE_ROOT_BUFFER)" ""
LowPower_CLOCK_TREE_ROOT_BUFFER                     := 
export LowPower_CLOCK_TREE_ROOT_BUFFER
endif
ifeq "$(LowPower_CLOCK_TREE_ROOT_BUFFER_FANOUT)" ""
LowPower_CLOCK_TREE_ROOT_BUFFER_FANOUT              := 8
export LowPower_CLOCK_TREE_ROOT_BUFFER_FANOUT
endif
ifeq "$(LowPower_CLOCK_TREE_FINAL_BUFFER)" ""
LowPower_CLOCK_TREE_FINAL_BUFFER                    := 
export LowPower_CLOCK_TREE_FINAL_BUFFER
endif
ifeq "$(LowPower_CLOCK_TREE_FINAL_BUFFER_FANOUT)" ""
LowPower_CLOCK_TREE_FINAL_BUFFER_FANOUT             := 32
export LowPower_CLOCK_TREE_FINAL_BUFFER_FANOUT
endif
ifeq "$(LowPower_SWITCHING_ACTIVITY_TYPE)" ""
LowPower_SWITCHING_ACTIVITY_TYPE                    := fsdb
export LowPower_SWITCHING_ACTIVITY_TYPE
endif
ifeq "$(LowPower_STARTUP_SCRIPT_PATH)" ""
LowPower_STARTUP_SCRIPT_PATH                        := 
export LowPower_STARTUP_SCRIPT_PATH
endif
ifeq "$(LowPower_SPEF_FILE)" ""
LowPower_SPEF_FILE                                  := 
export LowPower_SPEF_FILE
endif
ifeq "$(LowPower_CLOCK_GATING_MIN_WIDTH)" ""
LowPower_CLOCK_GATING_MIN_WIDTH                     := 0
export LowPower_CLOCK_GATING_MIN_WIDTH
endif
ifeq "$(LowPower_INSERT_OBS)" ""
LowPower_INSERT_OBS                                 := true
export LowPower_INSERT_OBS
endif
ifeq "$(LowPower_OBS_EFFORT_LEVEL)" ""
LowPower_OBS_EFFORT_LEVEL                           := high
export LowPower_OBS_EFFORT_LEVEL
endif
ifeq "$(LowPower_INSERT_STB_C)" ""
LowPower_INSERT_STB_C                               := true
export LowPower_INSERT_STB_C
endif
ifeq "$(LowPower_STB_C_EFFORT_LEVEL)" ""
LowPower_STB_C_EFFORT_LEVEL                         := high
export LowPower_STB_C_EFFORT_LEVEL
endif
ifeq "$(LowPower_INSERT_STB_S)" ""
LowPower_INSERT_STB_S                               := true
export LowPower_INSERT_STB_S
endif
ifeq "$(LowPower_STB_S_EFFORT_LEVEL)" ""
LowPower_STB_S_EFFORT_LEVEL                         := high
export LowPower_STB_S_EFFORT_LEVEL
endif
ifeq "$(LowPower_CG_OVERRIDE)" ""
LowPower_CG_OVERRIDE                                := 
export LowPower_CG_OVERRIDE
endif
ifeq "$(LowPower_ENABLE_SLECPRO)" ""
LowPower_ENABLE_SLECPRO                             := disabled
export LowPower_ENABLE_SLECPRO
endif
ifeq "$(LowPower_SLECPRO_QUEUELIC_LIMIT)" ""
LowPower_SLECPRO_QUEUELIC_LIMIT                     := 0s
export LowPower_SLECPRO_QUEUELIC_LIMIT
endif
ifeq "$(LowPower_USE_SLECPRO_MAP_FILE)" ""
LowPower_USE_SLECPRO_MAP_FILE                       := false
export LowPower_USE_SLECPRO_MAP_FILE
endif
ifeq "$(LowPower_DEBUG)" ""
LowPower_DEBUG                                      := false
export LowPower_DEBUG
endif
ifeq "$(LowPower_NO_LIBERTY)" ""
LowPower_NO_LIBERTY                                 := false
export LowPower_NO_LIBERTY
endif
ifeq "$(LowPower_NO_VECTORS)" ""
LowPower_NO_VECTORS                                 := false
export LowPower_NO_VECTORS
endif
ifeq "$(LowPower_ITERATIVE_WRITE_RTL)" ""
LowPower_ITERATIVE_WRITE_RTL                        := true
export LowPower_ITERATIVE_WRITE_RTL
endif
ifeq "$(LowPower_NUMERICAL_SOLVERS)" ""
LowPower_NUMERICAL_SOLVERS                          := false
export LowPower_NUMERICAL_SOLVERS
endif
ifeq "$(LowPower_DEBUG_LEVEL)" ""
LowPower_DEBUG_LEVEL                                := 0
export LowPower_DEBUG_LEVEL
endif
ifeq "$(LowPower_EFFORT_LEVEL)" ""
LowPower_EFFORT_LEVEL                               := high
export LowPower_EFFORT_LEVEL
endif
ifeq "$(CDesignChecker_SLEC_HOME)" ""
CDesignChecker_SLEC_HOME                            := 
export CDesignChecker_SLEC_HOME
endif
ifeq "$(CDesignChecker_XTERM_CMD)" ""
CDesignChecker_XTERM_CMD                            := xterm
export CDesignChecker_XTERM_CMD
endif
ifeq "$(CDesignChecker_WAIVER_FILE)" ""
CDesignChecker_WAIVER_FILE                          := 
export CDesignChecker_WAIVER_FILE
endif
ifeq "$(CDesignChecker_SOFT_RUNTIME_LIMIT)" ""
CDesignChecker_SOFT_RUNTIME_LIMIT                   := 0
export CDesignChecker_SOFT_RUNTIME_LIMIT
endif
ifeq "$(CDesignChecker_PER_PROBLEM_TIME_LIMIT)" ""
CDesignChecker_PER_PROBLEM_TIME_LIMIT               := 1
export CDesignChecker_PER_PROBLEM_TIME_LIMIT
endif
ifeq "$(CDesignChecker_TIME_LIMIT_INCREASE_FACTOR)" ""
CDesignChecker_TIME_LIMIT_INCREASE_FACTOR           := 2.0
export CDesignChecker_TIME_LIMIT_INCREASE_FACTOR
endif
ifeq "$(CDesignChecker_TIME_LIMIT_INCREASE_DELTA)" ""
CDesignChecker_TIME_LIMIT_INCREASE_DELTA            := 0
export CDesignChecker_TIME_LIMIT_INCREASE_DELTA
endif
ifeq "$(CDesignChecker_MAX_SIM_TRANS_COUNT)" ""
CDesignChecker_MAX_SIM_TRANS_COUNT                  := 500
export CDesignChecker_MAX_SIM_TRANS_COUNT
endif
ifeq "$(CDesignChecker_SIM_TIME_LIMIT)" ""
CDesignChecker_SIM_TIME_LIMIT                       := 900
export CDesignChecker_SIM_TIME_LIMIT
endif
ifeq "$(CDesignChecker_MAX_VIOLATIONS)" ""
CDesignChecker_MAX_VIOLATIONS                       := 20
export CDesignChecker_MAX_VIOLATIONS
endif
ifeq "$(CDesignChecker_SYMBOLIC_MEMSIZE_THRESHOLD)" ""
CDesignChecker_SYMBOLIC_MEMSIZE_THRESHOLD           := 256
export CDesignChecker_SYMBOLIC_MEMSIZE_THRESHOLD
endif
ifeq "$(CDesignChecker_VERIFICATION_EFFORT)" ""
CDesignChecker_VERIFICATION_EFFORT                  := medium
export CDesignChecker_VERIFICATION_EFFORT
endif
ifeq "$(CDesignChecker_CHECK_ABR)" ""
CDesignChecker_CHECK_ABR                            := Enable
export CDesignChecker_CHECK_ABR
endif
ifeq "$(CDesignChecker_CHECK_ABW)" ""
CDesignChecker_CHECK_ABW                            := Enable
export CDesignChecker_CHECK_ABW
endif
ifeq "$(CDesignChecker_CHECK_ACC)" ""
CDesignChecker_CHECK_ACC                            := Enable
export CDesignChecker_CHECK_ACC
endif
ifeq "$(CDesignChecker_CHECK_ACS)" ""
CDesignChecker_CHECK_ACS                            := Enable
export CDesignChecker_CHECK_ACS
endif
ifeq "$(CDesignChecker_CHECK_AIC)" ""
CDesignChecker_CHECK_AIC                            := Enable
export CDesignChecker_CHECK_AIC
endif
ifeq "$(CDesignChecker_CHECK_ALS)" ""
CDesignChecker_CHECK_ALS                            := Enable
export CDesignChecker_CHECK_ALS
endif
ifeq "$(CDesignChecker_CHECK_AOB)" ""
CDesignChecker_CHECK_AOB                            := Enable
export CDesignChecker_CHECK_AOB
endif
ifeq "$(CDesignChecker_CHECK_APT)" ""
CDesignChecker_CHECK_APT                            := Enable
export CDesignChecker_CHECK_APT
endif
ifeq "$(CDesignChecker_CHECK_CAS)" ""
CDesignChecker_CHECK_CAS                            := Enable
export CDesignChecker_CHECK_CAS
endif
ifeq "$(CDesignChecker_CHECK_CCC)" ""
CDesignChecker_CHECK_CCC                            := Enable
export CDesignChecker_CHECK_CCC
endif
ifeq "$(CDesignChecker_CHECK_CIA)" ""
CDesignChecker_CHECK_CIA                            := Enable
export CDesignChecker_CHECK_CIA
endif
ifeq "$(CDesignChecker_CHECK_CMC)" ""
CDesignChecker_CHECK_CMC                            := Enable
export CDesignChecker_CHECK_CMC
endif
ifeq "$(CDesignChecker_CHECK_CNS)" ""
CDesignChecker_CHECK_CNS                            := Enable
export CDesignChecker_CHECK_CNS
endif
ifeq "$(CDesignChecker_CHECK_CWB)" ""
CDesignChecker_CHECK_CWB                            := Enable
export CDesignChecker_CHECK_CWB
endif
ifeq "$(CDesignChecker_CHECK_DBZ)" ""
CDesignChecker_CHECK_DBZ                            := Enable
export CDesignChecker_CHECK_DBZ
endif
ifeq "$(CDesignChecker_CHECK_FXD)" ""
CDesignChecker_CHECK_FXD                            := Enable
export CDesignChecker_CHECK_FXD
endif
ifeq "$(CDesignChecker_CHECK_ISE)" ""
CDesignChecker_CHECK_ISE                            := Enable
export CDesignChecker_CHECK_ISE
endif
ifeq "$(CDesignChecker_CHECK_LRC)" ""
CDesignChecker_CHECK_LRC                            := Enable
export CDesignChecker_CHECK_LRC
endif
ifeq "$(CDesignChecker_CHECK_MXS)" ""
CDesignChecker_CHECK_MXS                            := Enable
export CDesignChecker_CHECK_MXS
endif
ifeq "$(CDesignChecker_CHECK_OSL)" ""
CDesignChecker_CHECK_OSL                            := Disable
export CDesignChecker_CHECK_OSL
endif
ifeq "$(CDesignChecker_CHECK_OVL)" ""
CDesignChecker_CHECK_OVL                            := Enable
export CDesignChecker_CHECK_OVL
endif
ifeq "$(CDesignChecker_CHECK_PDD)" ""
CDesignChecker_CHECK_PDD                            := Enable
export CDesignChecker_CHECK_PDD
endif
ifeq "$(CDesignChecker_CHECK_RRT)" ""
CDesignChecker_CHECK_RRT                            := Enable
export CDesignChecker_CHECK_RRT
endif
ifeq "$(CDesignChecker_CHECK_SAT)" ""
CDesignChecker_CHECK_SAT                            := Enable
export CDesignChecker_CHECK_SAT
endif
ifeq "$(CDesignChecker_CHECK_STF)" ""
CDesignChecker_CHECK_STF                            := Enable
export CDesignChecker_CHECK_STF
endif
ifeq "$(CDesignChecker_CHECK_SUD)" ""
CDesignChecker_CHECK_SUD                            := Enable
export CDesignChecker_CHECK_SUD
endif
ifeq "$(CDesignChecker_CHECK_UMR)" ""
CDesignChecker_CHECK_UMR                            := Enable
export CDesignChecker_CHECK_UMR
endif
ifeq "$(CDesignChecker_ADD_WAVES)" ""
CDesignChecker_ADD_WAVES                            := false
export CDesignChecker_ADD_WAVES
endif
ifeq "$(CDesignChecker_USE_64BIT)" ""
CDesignChecker_USE_64BIT                            := false
export CDesignChecker_USE_64BIT
endif
ifeq "$(CDesignChecker_PROPERTY_ABR)" ""
CDesignChecker_PROPERTY_ABR                         := false
export CDesignChecker_PROPERTY_ABR
endif
ifeq "$(CDesignChecker_PROPERTY_ABW)" ""
CDesignChecker_PROPERTY_ABW                         := false
export CDesignChecker_PROPERTY_ABW
endif
ifeq "$(CDesignChecker_PROPERTY_ASC)" ""
CDesignChecker_PROPERTY_ASC                         := false
export CDesignChecker_PROPERTY_ASC
endif
ifeq "$(CDesignChecker_PROPERTY_CAS)" ""
CDesignChecker_PROPERTY_CAS                         := false
export CDesignChecker_PROPERTY_CAS
endif
ifeq "$(CDesignChecker_PROPERTY_DBZ)" ""
CDesignChecker_PROPERTY_DBZ                         := false
export CDesignChecker_PROPERTY_DBZ
endif
ifeq "$(CDesignChecker_PROPERTY_ISE)" ""
CDesignChecker_PROPERTY_ISE                         := false
export CDesignChecker_PROPERTY_ISE
endif
ifeq "$(CDesignChecker_PROPERTY_UMR)" ""
CDesignChecker_PROPERTY_UMR                         := false
export CDesignChecker_PROPERTY_UMR
endif
ifeq "$(CDesignChecker_STATIC_RPT_FNAME)" ""
CDesignChecker_STATIC_RPT_FNAME                     := static_design_check
export CDesignChecker_STATIC_RPT_FNAME
endif
ifeq "$(CDesignChecker_FORMAL_RPT_FNAME)" ""
CDesignChecker_FORMAL_RPT_FNAME                     := Design_Check
export CDesignChecker_FORMAL_RPT_FNAME
endif
ifeq "$(CDesignChecker_FULL_REPORT)" ""
CDesignChecker_FULL_REPORT                          := false
export CDesignChecker_FULL_REPORT
endif
ifeq "$(CDesignChecker_GLOBAL_OPTIONS)" ""
CDesignChecker_GLOBAL_OPTIONS                       := 
export CDesignChecker_GLOBAL_OPTIONS
endif
ifeq "$(LINK_LIBPATHS)" ""
LINK_LIBPATHS                                       := 
export LINK_LIBPATHS
endif
ifeq "$(LINK_LIBNAMES)" ""
LINK_LIBNAMES                                       := 
export LINK_LIBNAMES
endif
ifeq "$(INCL_DIRS)" ""
INCL_DIRS                                           := 
export INCL_DIRS
endif
