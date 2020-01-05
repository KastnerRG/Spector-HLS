# ----------------------------------------------------------------------------
# RTL Verilog output 'rtl.v' vs Untimed C++
#
#    HLS version: 10.4b/841621 Production Release
#       HLS date: Thu Oct 24 17:20:07 PDT 2019
#  Flow Packages: HDL_Tcl 8.0a, SCVerify 10.4
#
#   Generated by: mdk@mdk-FX504
# Generated date: Sat Jan 04 23:55:00 PST 2020
#
# ----------------------------------------------------------------------------
# ===================================================
# DEFAULT GOAL is the help target
.PHONY: all
all: help

# ===================================================
# Directories (at the time this makefile was created)
#   MGC_HOME      /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home
#   PROJECT_HOME  /home/mdk/Spector-HLS/template_matching/catapult
#   SOLUTION_DIR  /home/mdk/Spector-HLS/template_matching/catapult/Catapult/SAD_MATCH.v3
#   WORKING_DIR   /home/mdk/Spector-HLS/template_matching/catapult/Catapult/SAD_MATCH.v3/.

# ===================================================
# VARIABLES
# 
MGC_HOME          = /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home
export MGC_HOME

WORK_DIR  = $(CURDIR)
WORK2PROJ = ../..
WORK2SOLN = .
PROJ2WORK = ./Catapult/SAD_MATCH.v3
PROJ2SOLN = ./Catapult/SAD_MATCH.v3
export WORK_DIR
export WORK2PROJ
export WORK2SOLN
export PROJ2WORK
export PROJ2SOLN

# Variables that can be overridden from the make command line
ifeq "$(INCL_DIRS)" ""
INCL_DIRS                   = ./scverify . ../..
endif
export INCL_DIRS
ifeq "$(STAGE)" ""
STAGE                       = rtl
endif
export STAGE
ifeq "$(NETLIST_LEAF)" ""
NETLIST_LEAF                = rtl
endif
export NETLIST_LEAF
ifeq "$(SIMTOOL)" ""
SIMTOOL                     = msim
endif
export SIMTOOL
ifeq "$(NETLIST)" ""
NETLIST                     = v
endif
export NETLIST
ifeq "$(RTL_NETLIST_FNAME)" ""
RTL_NETLIST_FNAME           = /home/mdk/Spector-HLS/template_matching/catapult/Catapult/SAD_MATCH.v3/rtl.v
endif
export RTL_NETLIST_FNAME
ifeq "$(INVOKE_ARGS)" ""
INVOKE_ARGS                 = 
endif
export INVOKE_ARGS
export SCVLIBS
export MODELSIM
TOP_HDL_ENTITY           := SAD_MATCH
TOP_DU                   := scverify_top
CXX_TYPE                 := gcc
MSIM_SCRIPT              := ./Catapult/SAD_MATCH.v3/scverify_msim.tcl
TARGET                   := scverify/$(NETLIST_LEAF)_$(NETLIST)_$(SIMTOOL)
export TOP_HDL_ENTITY
export TARGET

ifeq ($(RECUR),)
ifeq ($(STAGE),mapped)
ifeq ($(RTLTOOL),)
   $(error This makefile requires specifying the RTLTOOL variable on the make command line)
endif
endif
endif
# ===================================================
# Include environment variables set by flow options
include ./ccs_env.mk

# ===================================================
# Include makefile for default commands and variables
include $(MGC_HOME)/shared/include/mkfiles/ccs_default_cmds.mk

SYNTHESIS_FLOWPKG := Vivado
SYN_FLOW          := Vivado
# ===================================================
# SOURCES
# 
# Specify list of Questa SIM libraries to create
HDL_LIB_NAMES = mgc_hls work
# ===================================================
# Simulation libraries required by loaded Catapult libraries or gate simulation
SIMLIBS_V   += 
SIMLIBS_VHD += 
# 
# Specify list of source files - MUST be ordered properly
ifeq ($(STAGE),gate)
ifeq ($(RTLTOOL),)
ifeq ($(GATE_VHDL_DEP),)
GATE_VHDL_DEP = 
endif
ifeq ($(GATE_VLOG_DEP),)
GATE_VLOG_DEP = ./rtl.v/rtl.v.vts
endif
endif
VHDL_SRC +=  $(GATE_VHDL_DEP)
VLOG_SRC += $(MGC_HOME)/pkgs/siflibs/ccs_in_wait_v1.v/ccs_in_wait_v1.v.vts $(MGC_HOME)/pkgs/siflibs/ccs_out_wait_v1.v/ccs_out_wait_v1.v.vts $(MGC_HOME)/pkgs/ccs_xilinx/hdl/BLOCK_1R1W_RBW.v/BLOCK_1R1W_RBW.v.vts $(GATE_VLOG_DEP)
else
VHDL_SRC += 
VLOG_SRC += $(MGC_HOME)/pkgs/siflibs/ccs_in_wait_v1.v/ccs_in_wait_v1.v.vts $(MGC_HOME)/pkgs/siflibs/ccs_out_wait_v1.v/ccs_out_wait_v1.v.vts $(MGC_HOME)/pkgs/ccs_xilinx/hdl/BLOCK_1R1W_RBW.v/BLOCK_1R1W_RBW.v.vts ./rtl.v/rtl.v.vts
endif
CXX_SRC  = ../../src/fpga_temp_match.cpp/fpga_temp_match.cpp.cxxts ./scverify/mc_testbench.cpp/mc_testbench.cpp.cxxts ./scverify/scverify_top.cpp/scverify_top.cpp.cxxts
# Specify RTL synthesis scripts (if any)
RTL_SCRIPT = 

# Specify hold time file name (for verifying synthesized netlists)
HLD_CONSTRAINT_FNAME = top_gate_constraints.cpp

# ===================================================
# GLOBAL OPTIONS
# 
# CXXFLAGS - global C++ options (apply to all C++ compilations) except for include file search paths
CXXFLAGS += -DCCS_SCVERIFY -DSC_INCLUDE_DYNAMIC_PROCESSES -DSC_USE_STD_STRING -DTOP_HDL_ENTITY=$(TOP_HDL_ENTITY) -DCCS_DESIGN_FUNC_SAD_MATCH -DCCS_DESIGN_TOP_$(TOP_HDL_ENTITY) -DCCS_MISMATCHED_OUTPUTS_ONLY $(F_WRAP_OPT)
# 
# If the make command line includes a definition of the special variable MC_DEFAULT_TRANSACTOR_LOG
# then define that value for all compilations as well
ifneq "$(MC_DEFAULT_TRANSACTOR_LOG)" ""
CXXFLAGS += -DMC_DEFAULT_TRANSACTOR_LOG=$(MC_DEFAULT_TRANSACTOR_LOG)
endif
# 
# CXX_INCLUDES - include file search paths
CXX_INCLUDES = ./scverify . ../..
# 
# TCL shell
TCLSH_CMD = /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home/bin/tclsh8.5

# Pass along SCVerify_DEADLOCK_DETECTION option
ifneq "$(SCVerify_DEADLOCK_DETECTION)" "false"
CXXFLAGS += -DDEADLOCK_DETECTION
endif
# ===================================================
# PER SOURCE FILE SPECIALIZATIONS
# 
# Specify source file paths
ifeq ($(STAGE),gate)
ifneq ($(GATE_VHDL_DEP),)
$(TARGET)/$(notdir $(GATE_VHDL_DEP)): $(dir $(GATE_VHDL_DEP))
endif
ifneq ($(GATE_VLOG_DEP),)
$(TARGET)/$(notdir $(GATE_VLOG_DEP)): $(dir $(GATE_VLOG_DEP))
endif
endif
$(TARGET)/ccs_in_wait_v1.v.vts: $(MGC_HOME)/pkgs/siflibs/ccs_in_wait_v1.v
$(TARGET)/ccs_out_wait_v1.v.vts: $(MGC_HOME)/pkgs/siflibs/ccs_out_wait_v1.v
$(TARGET)/BLOCK_1R1W_RBW.v.vts: $(MGC_HOME)/pkgs/ccs_xilinx/hdl/BLOCK_1R1W_RBW.v
$(TARGET)/rtl.v.vts: ./rtl.v
$(TARGET)/fpga_temp_match.cpp.cxxts: ../../src/fpga_temp_match.cpp
$(TARGET)/mc_testbench.cpp.cxxts: ./scverify/mc_testbench.cpp
$(TARGET)/scverify_top.cpp.cxxts: ./scverify/scverify_top.cpp
# 
# Specify additional C++ options per C++ source by setting CXX_OPTS
$(TARGET)/fpga_temp_match.cpp.cxxts: CXX_OPTS=
$(TARGET)/scverify_top.cpp.cxxts: CXX_OPTS=
$(TARGET)/mc_testbench.cpp.cxxts: CXX_OPTS=$(F_WRAP_OPT)
# 
# Specify dependencies
$(TARGET)/fpga_temp_match.cpp.cxxts: .ccs_env_opts/SCVerify_USE_CCS_BLOCK.ts
$(TARGET)/mc_testbench.cpp.cxxts: .ccs_env_opts/SCVerify_USE_CCS_BLOCK.ts
$(TARGET)/scverify_top.cpp.cxxts: .ccs_env_opts/SCVerify_USE_CCS_BLOCK.ts .ccs_env_opts/SCVerify_DEADLOCK_DETECTION.ts
# 
# Specify compilation library for HDL source
$(TARGET)/ccs_out_wait_v1.v.vts: HDL_LIB=mgc_hls
$(TARGET)/BLOCK_1R1W_RBW.v.vts: HDL_LIB=mgc_hls
$(TARGET)/ccs_in_wait_v1.v.vts: HDL_LIB=mgc_hls
$(TARGET)/rtl.v.vts: HDL_LIB=work
ifeq ($(STAGE),gate)
ifneq ($(GATE_VHDL_DEP),)
$(TARGET)/$(notdir $(GATE_VHDL_DEP)): HDL_LIB=work
endif
ifneq ($(GATE_VLOG_DEP),)
$(TARGET)/$(notdir $(GATE_VLOG_DEP)): HDL_LIB=work
endif
endif
# 
# Specify additional HDL source compilation options if any
$(TARGET)/ccs_out_wait_v1.v.vts: VLOG_F_OPTS=
$(TARGET)/BLOCK_1R1W_RBW.v.vts: VLOG_F_OPTS=
$(TARGET)/ccs_in_wait_v1.v.vts: VLOG_F_OPTS=
$(TARGET)/rtl.v.vts: VLOG_F_OPTS=
$(TARGET)/ccs_out_wait_v1.v.vts: NCVLOG_F_OPTS=
$(TARGET)/BLOCK_1R1W_RBW.v.vts: NCVLOG_F_OPTS=
$(TARGET)/ccs_in_wait_v1.v.vts: NCVLOG_F_OPTS=
$(TARGET)/rtl.v.vts: NCVLOG_F_OPTS=
$(TARGET)/ccs_out_wait_v1.v.vts: VCS_F_OPTS=
$(TARGET)/BLOCK_1R1W_RBW.v.vts: VCS_F_OPTS=
$(TARGET)/ccs_in_wait_v1.v.vts: VCS_F_OPTS=
$(TARGET)/rtl.v.vts: VCS_F_OPTS=
# 
# Specify top design unit for HDL source
$(TARGET)/rtl.v.vts: DUT_E=SAD_MATCH

# Specify top design unit
$(TARGET)/rtl.v.vts: VLOG_TOP=1

ifneq "$(RTLTOOL)" ""
# ===================================================
# Include makefile for RTL synthesis
include $(MGC_HOME)/shared/include/mkfiles/ccs_$(RTLTOOL).mk
else
# ===================================================
# Include makefile for simulator
include $(MGC_HOME)/shared/include/mkfiles/ccs_questasim.mk
endif

