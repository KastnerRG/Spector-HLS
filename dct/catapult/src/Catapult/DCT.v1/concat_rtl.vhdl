
--------> /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home/pkgs/siflibs/ccs_out_wait_v1.vhd 
--------------------------------------------------------------------------------
-- Catapult Synthesis - Sample I/O Port Library
--
-- Copyright (c) 2003-2017 Mentor Graphics Corp.
--       All Rights Reserved
--
-- This document may be used and distributed without restriction provided that
-- this copyright statement is not removed from the file and that any derivative
-- work contains this copyright notice.
--
-- The design information contained in this file is intended to be an example
-- of the functionality which the end user may study in preparation for creating
-- their own custom interfaces. This design does not necessarily present a 
-- complete implementation of the named protocol or standard.
--
--------------------------------------------------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

PACKAGE ccs_out_wait_pkg_v1 IS

COMPONENT ccs_out_wait_v1
  GENERIC (
    rscid    : INTEGER;
    width    : INTEGER
  );
  PORT (
    dat    : OUT std_logic_vector(width-1 DOWNTO 0);
    irdy   : OUT std_logic;
    vld    : OUT std_logic;
    idat   : IN  std_logic_vector(width-1 DOWNTO 0);
    rdy    : IN  std_logic;
    ivld   : IN  std_logic
  );
END COMPONENT;

END ccs_out_wait_pkg_v1;

LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; -- Prevent STARC 2.1.1.2 violation

ENTITY ccs_out_wait_v1 IS
  GENERIC (
    rscid : INTEGER;
    width : INTEGER
  );
  PORT (
    dat   : OUT std_logic_vector(width-1 DOWNTO 0);
    irdy  : OUT std_logic;
    vld   : OUT std_logic;
    idat  : IN  std_logic_vector(width-1 DOWNTO 0);
    rdy   : IN  std_logic;
    ivld  : IN  std_logic
  );
END ccs_out_wait_v1;

ARCHITECTURE beh OF ccs_out_wait_v1 IS
BEGIN

  dat  <= idat;
  irdy <= rdy;
  vld  <= ivld;

END beh;


--------> /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home/pkgs/siflibs/ccs_in_wait_v1.vhd 
--------------------------------------------------------------------------------
-- Catapult Synthesis - Sample I/O Port Library
--
-- Copyright (c) 2003-2017 Mentor Graphics Corp.
--       All Rights Reserved
--
-- This document may be used and distributed without restriction provided that
-- this copyright statement is not removed from the file and that any derivative
-- work contains this copyright notice.
--
-- The design information contained in this file is intended to be an example
-- of the functionality which the end user may study in preparation for creating
-- their own custom interfaces. This design does not necessarily present a 
-- complete implementation of the named protocol or standard.
--
--------------------------------------------------------------------------------

LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

PACKAGE ccs_in_wait_pkg_v1 IS

COMPONENT ccs_in_wait_v1
  GENERIC (
    rscid    : INTEGER;
    width    : INTEGER
  );
  PORT (
    idat   : OUT std_logic_vector(width-1 DOWNTO 0);
    rdy    : OUT std_logic;
    ivld   : OUT std_logic;
    dat    : IN  std_logic_vector(width-1 DOWNTO 0);
    irdy   : IN  std_logic;
    vld    : IN  std_logic
   );
END COMPONENT;

END ccs_in_wait_pkg_v1;

LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; -- Prevent STARC 2.1.1.2 violation

ENTITY ccs_in_wait_v1 IS
  GENERIC (
    rscid : INTEGER;
    width : INTEGER
  );
  PORT (
    idat  : OUT std_logic_vector(width-1 DOWNTO 0);
    rdy   : OUT std_logic;
    ivld  : OUT std_logic;
    dat   : IN  std_logic_vector(width-1 DOWNTO 0);
    irdy  : IN  std_logic;
    vld   : IN  std_logic
  );
END ccs_in_wait_v1;

ARCHITECTURE beh OF ccs_in_wait_v1 IS
BEGIN

  idat <= dat;
  rdy  <= irdy;
  ivld <= vld;

END beh;


--------> /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4b-841621/Mgc_home/pkgs/ccs_xilinx/hdl/BLOCK_1R1W_RBW.vhd 

LIBRARY IEEE;

   USE IEEE.STD_LOGIC_1164.ALL;
   USE IEEE.Numeric_Std.ALL;

PACKAGE BLOCK_1R1W_RBW_pkg IS

   COMPONENT BLOCK_1R1W_RBW
      GENERIC (
         data_width    : integer := 8;
         addr_width : integer := 7;
         depth         : integer := 128
      );
      PORT (
         clk  : IN  std_logic;
         radr : IN  std_logic_vector(addr_width-1 DOWNTO 0);
         wadr : IN  std_logic_vector(addr_width-1 DOWNTO 0);
         we   : IN  std_logic;
         re   : IN  std_logic;
         d    : IN  std_logic_vector(data_width-1 DOWNTO 0);
         q    : OUT std_logic_vector(data_width-1  DOWNTO 0)
      );
   END COMPONENT;

END BLOCK_1R1W_RBW_pkg;


LIBRARY IEEE;

   USE IEEE.STD_LOGIC_1164.ALL;
   USE IEEE.Numeric_Std.ALL;

ENTITY BLOCK_1R1W_RBW IS
      GENERIC (
         data_width    : integer := 8;
         addr_width : integer := 7;
         depth         : integer := 128
      );
      PORT (
         clk  : IN  std_logic;
         radr : IN  std_logic_vector(addr_width-1 DOWNTO 0);
         wadr : IN  std_logic_vector(addr_width-1 DOWNTO 0);
         we   : IN  std_logic;
         re   : IN  std_logic;
         d    : IN  std_logic_vector(data_width-1 DOWNTO 0);
         q    : OUT std_logic_vector(data_width-1  DOWNTO 0)
      );
END BLOCK_1R1W_RBW;

ARCHITECTURE rtl OF BLOCK_1R1W_RBW IS

   TYPE ram_t IS ARRAY (depth-1 DOWNTO 0) OF std_logic_vector(data_width-1 DOWNTO 0);
   SIGNAL mem : ram_t := (OTHERS => (OTHERS => '0'));

   ATTRIBUTE ram_style: STRING;
   ATTRIBUTE ram_style OF mem : SIGNAL IS "BLOCK";
   ATTRIBUTE syn_ramstyle: STRING;
   ATTRIBUTE syn_ramstyle OF mem : SIGNAL IS "block_ram";

BEGIN
   PROCESS (clk)
   BEGIN
      IF (rising_edge(clk)) THEN
         IF (we='1') THEN
           mem(to_integer(unsigned(wadr))) <= d;
         END IF;
         IF (re='1') THEN
            q <= mem(to_integer(unsigned(radr))) ; -- read port
         END IF; 
      END IF;
   END PROCESS;
END rtl;


--------> ./rtl.vhdl 
-- ----------------------------------------------------------------------
--  HLS HDL:        VHDL Netlister
--  HLS Version:    10.4b/841621 Production Release
--  HLS Date:       Thu Oct 24 17:20:07 PDT 2019
-- 
--  Generated by:   mdk@mdk-FX504
--  Generated date: Fri Jan  3 06:36:57 2020
-- ----------------------------------------------------------------------

-- 
-- ------------------------------------------------------------------
--  Design Unit:    DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_4_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_4_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
  );
END DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_4_gen;

ARCHITECTURE v1 OF DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_4_gen IS
  -- Default Constants

BEGIN
  we <= (we_d);
  d <= (d_d);
  wadr <= (wadr_d);
  re <= (re_d);
  q_d <= q;
  radr <= (radr_d);
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_3_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_3_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
  );
END DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_3_gen;

ARCHITECTURE v1 OF DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_3_gen IS
  -- Default Constants

BEGIN
  we <= (we_d);
  d <= (d_d);
  wadr <= (wadr_d);
  re <= (re_d);
  q_d <= q;
  radr <= (radr_d);
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_core_fsm
--  FSM Module
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_core_fsm IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    fsm_output : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
    loop_lmm_C_1_tr0 : IN STD_LOGIC;
    loop_6_C_2_tr0 : IN STD_LOGIC;
    loop_5_C_1_tr0 : IN STD_LOGIC;
    loop_7_C_1_tr0 : IN STD_LOGIC;
    loop_3_C_2_tr0 : IN STD_LOGIC;
    loop_12_C_2_tr0 : IN STD_LOGIC;
    loop_11_C_1_tr0 : IN STD_LOGIC;
    loop_13_C_1_tr0 : IN STD_LOGIC;
    loop_9_C_2_tr0 : IN STD_LOGIC;
    loop_2_C_0_tr0 : IN STD_LOGIC;
    loop_1_C_0_tr0 : IN STD_LOGIC;
    loop_out_C_2_tr0 : IN STD_LOGIC
  );
END DCT_core_core_fsm;

ARCHITECTURE v1 OF DCT_core_core_fsm IS
  -- Default Constants

  -- FSM State Type Declaration for DCT_core_core_fsm_1
  TYPE DCT_core_core_fsm_1_ST IS (main_C_0, loop_lmm_C_0, loop_lmm_C_1, loop_5_C_0,
      loop_6_C_0, loop_6_C_1, loop_6_C_2, loop_5_C_1, loop_3_C_0, loop_3_C_1, loop_7_C_0,
      loop_7_C_1, loop_3_C_2, loop_11_C_0, loop_12_C_0, loop_12_C_1, loop_12_C_2,
      loop_11_C_1, loop_9_C_0, loop_9_C_1, loop_13_C_0, loop_13_C_1, loop_9_C_2,
      loop_2_C_0, loop_1_C_0, loop_out_C_0, loop_out_C_1, loop_out_C_2);

  SIGNAL state_var : DCT_core_core_fsm_1_ST;
  SIGNAL state_var_NS : DCT_core_core_fsm_1_ST;

BEGIN
  DCT_core_core_fsm_1 : PROCESS (loop_lmm_C_1_tr0, loop_6_C_2_tr0, loop_5_C_1_tr0,
      loop_7_C_1_tr0, loop_3_C_2_tr0, loop_12_C_2_tr0, loop_11_C_1_tr0, loop_13_C_1_tr0,
      loop_9_C_2_tr0, loop_2_C_0_tr0, loop_1_C_0_tr0, loop_out_C_2_tr0, state_var)
  BEGIN
    CASE state_var IS
      WHEN loop_lmm_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000000000010");
        state_var_NS <= loop_lmm_C_1;
      WHEN loop_lmm_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000000000100");
        IF ( loop_lmm_C_1_tr0 = '1' ) THEN
          state_var_NS <= loop_5_C_0;
        ELSE
          state_var_NS <= loop_lmm_C_0;
        END IF;
      WHEN loop_5_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000000001000");
        state_var_NS <= loop_6_C_0;
      WHEN loop_6_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000000010000");
        state_var_NS <= loop_6_C_1;
      WHEN loop_6_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000000100000");
        state_var_NS <= loop_6_C_2;
      WHEN loop_6_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000001000000");
        IF ( loop_6_C_2_tr0 = '1' ) THEN
          state_var_NS <= loop_5_C_1;
        ELSE
          state_var_NS <= loop_6_C_0;
        END IF;
      WHEN loop_5_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000010000000");
        IF ( loop_5_C_1_tr0 = '1' ) THEN
          state_var_NS <= loop_3_C_0;
        ELSE
          state_var_NS <= loop_5_C_0;
        END IF;
      WHEN loop_3_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000100000000");
        state_var_NS <= loop_3_C_1;
      WHEN loop_3_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000001000000000");
        state_var_NS <= loop_7_C_0;
      WHEN loop_7_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000010000000000");
        state_var_NS <= loop_7_C_1;
      WHEN loop_7_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000100000000000");
        IF ( loop_7_C_1_tr0 = '1' ) THEN
          state_var_NS <= loop_3_C_2;
        ELSE
          state_var_NS <= loop_7_C_0;
        END IF;
      WHEN loop_3_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000001000000000000");
        IF ( loop_3_C_2_tr0 = '1' ) THEN
          state_var_NS <= loop_11_C_0;
        ELSE
          state_var_NS <= loop_5_C_0;
        END IF;
      WHEN loop_11_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000010000000000000");
        state_var_NS <= loop_12_C_0;
      WHEN loop_12_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000100000000000000");
        state_var_NS <= loop_12_C_1;
      WHEN loop_12_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000001000000000000000");
        state_var_NS <= loop_12_C_2;
      WHEN loop_12_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000010000000000000000");
        IF ( loop_12_C_2_tr0 = '1' ) THEN
          state_var_NS <= loop_11_C_1;
        ELSE
          state_var_NS <= loop_12_C_0;
        END IF;
      WHEN loop_11_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000100000000000000000");
        IF ( loop_11_C_1_tr0 = '1' ) THEN
          state_var_NS <= loop_9_C_0;
        ELSE
          state_var_NS <= loop_11_C_0;
        END IF;
      WHEN loop_9_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000001000000000000000000");
        state_var_NS <= loop_9_C_1;
      WHEN loop_9_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000010000000000000000000");
        state_var_NS <= loop_13_C_0;
      WHEN loop_13_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000100000000000000000000");
        state_var_NS <= loop_13_C_1;
      WHEN loop_13_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000001000000000000000000000");
        IF ( loop_13_C_1_tr0 = '1' ) THEN
          state_var_NS <= loop_9_C_2;
        ELSE
          state_var_NS <= loop_13_C_0;
        END IF;
      WHEN loop_9_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000010000000000000000000000");
        IF ( loop_9_C_2_tr0 = '1' ) THEN
          state_var_NS <= loop_2_C_0;
        ELSE
          state_var_NS <= loop_11_C_0;
        END IF;
      WHEN loop_2_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000100000000000000000000000");
        IF ( loop_2_C_0_tr0 = '1' ) THEN
          state_var_NS <= loop_1_C_0;
        ELSE
          state_var_NS <= loop_5_C_0;
        END IF;
      WHEN loop_1_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0001000000000000000000000000");
        IF ( loop_1_C_0_tr0 = '1' ) THEN
          state_var_NS <= loop_out_C_0;
        ELSE
          state_var_NS <= loop_5_C_0;
        END IF;
      WHEN loop_out_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0010000000000000000000000000");
        state_var_NS <= loop_out_C_1;
      WHEN loop_out_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "0100000000000000000000000000");
        state_var_NS <= loop_out_C_2;
      WHEN loop_out_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "1000000000000000000000000000");
        IF ( loop_out_C_2_tr0 = '1' ) THEN
          state_var_NS <= main_C_0;
        ELSE
          state_var_NS <= loop_out_C_0;
        END IF;
      -- main_C_0
      WHEN OTHERS =>
        fsm_output <= STD_LOGIC_VECTOR'( "0000000000000000000000000001");
        state_var_NS <= loop_lmm_C_0;
    END CASE;
  END PROCESS DCT_core_core_fsm_1;

  DCT_core_core_fsm_1_REG : PROCESS (clk)
  BEGIN
    IF clk'event AND ( clk = '1' ) THEN
      IF ( rst = '1' ) THEN
        state_var <= main_C_0;
      ELSE
        IF ( core_wen = '1' ) THEN
          state_var <= state_var_NS;
        END IF;
      END IF;
    END IF;
  END PROCESS DCT_core_core_fsm_1_REG;

END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_staller
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_staller IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    core_wen : OUT STD_LOGIC;
    core_wten : OUT STD_LOGIC;
    dst_rsci_wen_comp : IN STD_LOGIC;
    src_rsci_wen_comp : IN STD_LOGIC
  );
END DCT_core_staller;

ARCHITECTURE v1 OF DCT_core_staller IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL core_wen_drv : STD_LOGIC;

  -- Interconnect Declarations
  SIGNAL core_wten_reg : STD_LOGIC;

BEGIN
  -- Output Reader Assignments
  core_wen <= core_wen_drv;

  core_wen_drv <= dst_rsci_wen_comp AND src_rsci_wen_comp;
  core_wten <= core_wten_reg;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        core_wten_reg <= '0';
      ELSE
        core_wten_reg <= NOT core_wen_drv;
      END IF;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    msrc_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_radr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_d_d_core : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_biwt : IN STD_LOGIC;
    msrc_data_rsci_bdwt : IN STD_LOGIC;
    msrc_data_rsci_radr_d_core_sct : IN STD_LOGIC;
    msrc_data_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp;

ARCHITECTURE v1 OF DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL msrc_data_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (19 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL msrc_data_rsci_bcwt : STD_LOGIC;
  SIGNAL msrc_data_rsci_q_d_bfwt : STD_LOGIC_VECTOR (19 DOWNTO 0);

  FUNCTION MUX_v_11_2_2(input_0 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(10 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_20_2_2(input_0 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(19 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

BEGIN
  -- Output Reader Assignments
  msrc_data_rsci_q_d_mxwt <= msrc_data_rsci_q_d_mxwt_drv;

  msrc_data_rsci_q_d_mxwt_drv <= MUX_v_20_2_2(msrc_data_rsci_q_d, msrc_data_rsci_q_d_bfwt,
      msrc_data_rsci_bcwt);
  msrc_data_rsci_radr_d <= MUX_v_11_2_2(STD_LOGIC_VECTOR'("00000000000"), msrc_data_rsci_radr_d_core,
      msrc_data_rsci_radr_d_core_sct);
  msrc_data_rsci_wadr_d <= MUX_v_11_2_2(STD_LOGIC_VECTOR'("00000000000"), msrc_data_rsci_wadr_d_core,
      msrc_data_rsci_wadr_d_core_sct_pff);
  msrc_data_rsci_d_d <= MUX_v_20_2_2(STD_LOGIC_VECTOR'("00000000000000000000"), msrc_data_rsci_d_d_core,
      msrc_data_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        msrc_data_rsci_bcwt <= '0';
      ELSE
        msrc_data_rsci_bcwt <= NOT((NOT(msrc_data_rsci_bcwt OR msrc_data_rsci_biwt))
            OR msrc_data_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( msrc_data_rsci_bcwt = '0' ) THEN
        msrc_data_rsci_q_d_bfwt <= msrc_data_rsci_q_d_mxwt_drv;
      END IF;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    msrc_data_rsci_oswt : IN STD_LOGIC;
    msrc_data_rsci_biwt : OUT STD_LOGIC;
    msrc_data_rsci_bdwt : OUT STD_LOGIC;
    msrc_data_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    msrc_data_rsci_oswt_pff : IN STD_LOGIC;
    msrc_data_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    msrc_data_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_ctrl;

ARCHITECTURE v1 OF DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  msrc_data_rsci_bdwt <= msrc_data_rsci_oswt AND core_wen;
  msrc_data_rsci_biwt <= (NOT core_wten) AND msrc_data_rsci_oswt;
  msrc_data_rsci_radr_d_core_sct_pff <= msrc_data_rsci_oswt_pff AND core_wen;
  msrc_data_rsci_wadr_d_core_sct_pff <= msrc_data_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    mdst_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    mdst_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    mdst_data_rsci_radr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_d_d_core : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    mdst_data_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    mdst_data_rsci_biwt : IN STD_LOGIC;
    mdst_data_rsci_bdwt : IN STD_LOGIC;
    mdst_data_rsci_radr_d_core_sct : IN STD_LOGIC;
    mdst_data_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp;

ARCHITECTURE v1 OF DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL mdst_data_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (19 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL mdst_data_rsci_bcwt : STD_LOGIC;
  SIGNAL mdst_data_rsci_q_d_bfwt : STD_LOGIC_VECTOR (19 DOWNTO 0);

  FUNCTION MUX_v_11_2_2(input_0 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(10 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_20_2_2(input_0 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(19 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

BEGIN
  -- Output Reader Assignments
  mdst_data_rsci_q_d_mxwt <= mdst_data_rsci_q_d_mxwt_drv;

  mdst_data_rsci_q_d_mxwt_drv <= MUX_v_20_2_2(mdst_data_rsci_q_d, mdst_data_rsci_q_d_bfwt,
      mdst_data_rsci_bcwt);
  mdst_data_rsci_radr_d <= MUX_v_11_2_2(STD_LOGIC_VECTOR'("00000000000"), mdst_data_rsci_radr_d_core,
      mdst_data_rsci_radr_d_core_sct);
  mdst_data_rsci_wadr_d <= MUX_v_11_2_2(STD_LOGIC_VECTOR'("00000000000"), mdst_data_rsci_wadr_d_core,
      mdst_data_rsci_wadr_d_core_sct_pff);
  mdst_data_rsci_d_d <= MUX_v_20_2_2(STD_LOGIC_VECTOR'("00000000000000000000"), mdst_data_rsci_d_d_core,
      mdst_data_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        mdst_data_rsci_bcwt <= '0';
      ELSE
        mdst_data_rsci_bcwt <= NOT((NOT(mdst_data_rsci_bcwt OR mdst_data_rsci_biwt))
            OR mdst_data_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( mdst_data_rsci_bcwt = '0' ) THEN
        mdst_data_rsci_q_d_bfwt <= mdst_data_rsci_q_d_mxwt_drv;
      END IF;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    mdst_data_rsci_oswt : IN STD_LOGIC;
    mdst_data_rsci_biwt : OUT STD_LOGIC;
    mdst_data_rsci_bdwt : OUT STD_LOGIC;
    mdst_data_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    mdst_data_rsci_oswt_pff : IN STD_LOGIC;
    mdst_data_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    mdst_data_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_ctrl;

ARCHITECTURE v1 OF DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  mdst_data_rsci_bdwt <= mdst_data_rsci_oswt AND core_wen;
  mdst_data_rsci_biwt <= (NOT core_wten) AND mdst_data_rsci_oswt;
  mdst_data_rsci_radr_d_core_sct_pff <= mdst_data_rsci_oswt_pff AND core_wen;
  mdst_data_rsci_wadr_d_core_sct_pff <= mdst_data_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_src_rsci_src_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_src_rsci_src_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    src_rsci_oswt : IN STD_LOGIC;
    src_rsci_wen_comp : OUT STD_LOGIC;
    src_rsci_idat_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    src_rsci_biwt : IN STD_LOGIC;
    src_rsci_bdwt : IN STD_LOGIC;
    src_rsci_bcwt : OUT STD_LOGIC;
    src_rsci_idat : IN STD_LOGIC_VECTOR (19 DOWNTO 0)
  );
END DCT_core_src_rsci_src_wait_dp;

ARCHITECTURE v1 OF DCT_core_src_rsci_src_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL src_rsci_idat_mxwt_drv : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL src_rsci_bcwt_drv : STD_LOGIC;

  -- Interconnect Declarations
  SIGNAL src_rsci_idat_bfwt : STD_LOGIC_VECTOR (19 DOWNTO 0);

  FUNCTION MUX_v_20_2_2(input_0 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(19 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

BEGIN
  -- Output Reader Assignments
  src_rsci_idat_mxwt <= src_rsci_idat_mxwt_drv;
  src_rsci_bcwt <= src_rsci_bcwt_drv;

  src_rsci_wen_comp <= (NOT src_rsci_oswt) OR src_rsci_biwt OR src_rsci_bcwt_drv;
  src_rsci_idat_mxwt_drv <= MUX_v_20_2_2(src_rsci_idat, src_rsci_idat_bfwt, src_rsci_bcwt_drv);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        src_rsci_bcwt_drv <= '0';
      ELSE
        src_rsci_bcwt_drv <= NOT((NOT(src_rsci_bcwt_drv OR src_rsci_biwt)) OR src_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      src_rsci_idat_bfwt <= src_rsci_idat_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_src_rsci_src_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_src_rsci_src_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    src_rsci_oswt : IN STD_LOGIC;
    src_rsci_biwt : OUT STD_LOGIC;
    src_rsci_bdwt : OUT STD_LOGIC;
    src_rsci_bcwt : IN STD_LOGIC;
    src_rsci_irdy_core_sct : OUT STD_LOGIC;
    src_rsci_ivld : IN STD_LOGIC
  );
END DCT_core_src_rsci_src_wait_ctrl;

ARCHITECTURE v1 OF DCT_core_src_rsci_src_wait_ctrl IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL src_rsci_ogwt : STD_LOGIC;

BEGIN
  src_rsci_bdwt <= src_rsci_oswt AND core_wen;
  src_rsci_biwt <= src_rsci_ogwt AND src_rsci_ivld;
  src_rsci_ogwt <= src_rsci_oswt AND (NOT src_rsci_bcwt);
  src_rsci_irdy_core_sct <= src_rsci_ogwt;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_dst_rsci_dst_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_dst_rsci_dst_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    dst_rsci_oswt : IN STD_LOGIC;
    dst_rsci_wen_comp : OUT STD_LOGIC;
    dst_rsci_biwt : IN STD_LOGIC;
    dst_rsci_bdwt : IN STD_LOGIC;
    dst_rsci_bcwt : OUT STD_LOGIC
  );
END DCT_core_dst_rsci_dst_wait_dp;

ARCHITECTURE v1 OF DCT_core_dst_rsci_dst_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL dst_rsci_bcwt_drv : STD_LOGIC;

BEGIN
  -- Output Reader Assignments
  dst_rsci_bcwt <= dst_rsci_bcwt_drv;

  dst_rsci_wen_comp <= (NOT dst_rsci_oswt) OR dst_rsci_biwt OR dst_rsci_bcwt_drv;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        dst_rsci_bcwt_drv <= '0';
      ELSE
        dst_rsci_bcwt_drv <= NOT((NOT(dst_rsci_bcwt_drv OR dst_rsci_biwt)) OR dst_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_dst_rsci_dst_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_dst_rsci_dst_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    dst_rsci_oswt : IN STD_LOGIC;
    dst_rsci_irdy : IN STD_LOGIC;
    dst_rsci_biwt : OUT STD_LOGIC;
    dst_rsci_bdwt : OUT STD_LOGIC;
    dst_rsci_bcwt : IN STD_LOGIC;
    dst_rsci_ivld_core_sct : OUT STD_LOGIC
  );
END DCT_core_dst_rsci_dst_wait_ctrl;

ARCHITECTURE v1 OF DCT_core_dst_rsci_dst_wait_ctrl IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL dst_rsci_ogwt : STD_LOGIC;

BEGIN
  dst_rsci_bdwt <= dst_rsci_oswt AND core_wen;
  dst_rsci_biwt <= dst_rsci_ogwt AND dst_rsci_irdy;
  dst_rsci_ogwt <= dst_rsci_oswt AND (NOT dst_rsci_bcwt);
  dst_rsci_ivld_core_sct <= dst_rsci_ogwt;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_msrc_data_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_msrc_data_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    msrc_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_we_d : OUT STD_LOGIC;
    msrc_data_rsci_re_d : OUT STD_LOGIC;
    msrc_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    msrc_data_rsci_oswt : IN STD_LOGIC;
    msrc_data_rsci_radr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_d_d_core : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_oswt_pff : IN STD_LOGIC;
    msrc_data_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END DCT_core_msrc_data_rsci_1;

ARCHITECTURE v1 OF DCT_core_msrc_data_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL msrc_data_rsci_biwt : STD_LOGIC;
  SIGNAL msrc_data_rsci_bdwt : STD_LOGIC;
  SIGNAL msrc_data_rsci_radr_d_reg : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL msrc_data_rsci_wadr_d_reg : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL msrc_data_rsci_d_d_reg : STD_LOGIC_VECTOR (19 DOWNTO 0);

  COMPONENT DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      msrc_data_rsci_oswt : IN STD_LOGIC;
      msrc_data_rsci_biwt : OUT STD_LOGIC;
      msrc_data_rsci_bdwt : OUT STD_LOGIC;
      msrc_data_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      msrc_data_rsci_oswt_pff : IN STD_LOGIC;
      msrc_data_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      msrc_data_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      msrc_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_radr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_d_d_core : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_biwt : IN STD_LOGIC;
      msrc_data_rsci_bdwt : IN STD_LOGIC;
      msrc_data_rsci_radr_d_core_sct : IN STD_LOGIC;
      msrc_data_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_radr_d
      : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_wadr_d
      : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_d_d
      : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_q_d
      : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_radr_d_core
      : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_d_d_core
      : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (19 DOWNTO 0);

BEGIN
  DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_ctrl_inst : DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      msrc_data_rsci_oswt => msrc_data_rsci_oswt,
      msrc_data_rsci_biwt => msrc_data_rsci_biwt,
      msrc_data_rsci_bdwt => msrc_data_rsci_bdwt,
      msrc_data_rsci_radr_d_core_sct_pff => msrc_data_rsci_radr_d_core_sct_iff,
      msrc_data_rsci_oswt_pff => msrc_data_rsci_oswt_pff,
      msrc_data_rsci_wadr_d_core_sct_pff => msrc_data_rsci_wadr_d_core_sct_iff,
      msrc_data_rsci_iswt0_1_pff => msrc_data_rsci_iswt0_1_pff
    );
  DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst : DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      msrc_data_rsci_radr_d => DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_radr_d,
      msrc_data_rsci_wadr_d => DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_wadr_d,
      msrc_data_rsci_d_d => DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_d_d,
      msrc_data_rsci_q_d => DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_q_d,
      msrc_data_rsci_radr_d_core => DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_radr_d_core,
      msrc_data_rsci_wadr_d_core => DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_wadr_d_core,
      msrc_data_rsci_d_d_core => DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_d_d_core,
      msrc_data_rsci_q_d_mxwt => DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_q_d_mxwt,
      msrc_data_rsci_biwt => msrc_data_rsci_biwt,
      msrc_data_rsci_bdwt => msrc_data_rsci_bdwt,
      msrc_data_rsci_radr_d_core_sct => msrc_data_rsci_radr_d_core_sct_iff,
      msrc_data_rsci_wadr_d_core_sct_pff => msrc_data_rsci_wadr_d_core_sct_iff
    );
  msrc_data_rsci_radr_d_reg <= DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_radr_d;
  msrc_data_rsci_wadr_d_reg <= DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_wadr_d;
  msrc_data_rsci_d_d_reg <= DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_d_d;
  DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_q_d <= msrc_data_rsci_q_d;
  DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_radr_d_core
      <= msrc_data_rsci_radr_d_core;
  DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_wadr_d_core
      <= msrc_data_rsci_wadr_d_core;
  DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_d_d_core <=
      msrc_data_rsci_d_d_core;
  msrc_data_rsci_q_d_mxwt <= DCT_core_msrc_data_rsci_1_msrc_data_rsc_wait_dp_inst_msrc_data_rsci_q_d_mxwt;

  msrc_data_rsci_radr_d <= msrc_data_rsci_radr_d_reg;
  msrc_data_rsci_wadr_d <= msrc_data_rsci_wadr_d_reg;
  msrc_data_rsci_d_d <= msrc_data_rsci_d_d_reg;
  msrc_data_rsci_we_d <= msrc_data_rsci_wadr_d_core_sct_iff;
  msrc_data_rsci_re_d <= msrc_data_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_mdst_data_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_mdst_data_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    mdst_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    mdst_data_rsci_we_d : OUT STD_LOGIC;
    mdst_data_rsci_re_d : OUT STD_LOGIC;
    mdst_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    mdst_data_rsci_oswt : IN STD_LOGIC;
    mdst_data_rsci_radr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_d_d_core : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    mdst_data_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    mdst_data_rsci_oswt_pff : IN STD_LOGIC;
    mdst_data_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END DCT_core_mdst_data_rsci_1;

ARCHITECTURE v1 OF DCT_core_mdst_data_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL mdst_data_rsci_biwt : STD_LOGIC;
  SIGNAL mdst_data_rsci_bdwt : STD_LOGIC;
  SIGNAL mdst_data_rsci_radr_d_reg : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL mdst_data_rsci_wadr_d_reg : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL mdst_data_rsci_d_d_reg : STD_LOGIC_VECTOR (19 DOWNTO 0);

  COMPONENT DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      mdst_data_rsci_oswt : IN STD_LOGIC;
      mdst_data_rsci_biwt : OUT STD_LOGIC;
      mdst_data_rsci_bdwt : OUT STD_LOGIC;
      mdst_data_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      mdst_data_rsci_oswt_pff : IN STD_LOGIC;
      mdst_data_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      mdst_data_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      mdst_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      mdst_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      mdst_data_rsci_radr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_d_d_core : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      mdst_data_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      mdst_data_rsci_biwt : IN STD_LOGIC;
      mdst_data_rsci_bdwt : IN STD_LOGIC;
      mdst_data_rsci_radr_d_core_sct : IN STD_LOGIC;
      mdst_data_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_radr_d
      : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_wadr_d
      : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_d_d
      : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_q_d
      : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_radr_d_core
      : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_d_d_core
      : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (19 DOWNTO 0);

BEGIN
  DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_ctrl_inst : DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      mdst_data_rsci_oswt => mdst_data_rsci_oswt,
      mdst_data_rsci_biwt => mdst_data_rsci_biwt,
      mdst_data_rsci_bdwt => mdst_data_rsci_bdwt,
      mdst_data_rsci_radr_d_core_sct_pff => mdst_data_rsci_radr_d_core_sct_iff,
      mdst_data_rsci_oswt_pff => mdst_data_rsci_oswt_pff,
      mdst_data_rsci_wadr_d_core_sct_pff => mdst_data_rsci_wadr_d_core_sct_iff,
      mdst_data_rsci_iswt0_1_pff => mdst_data_rsci_iswt0_1_pff
    );
  DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst : DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      mdst_data_rsci_radr_d => DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_radr_d,
      mdst_data_rsci_wadr_d => DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_wadr_d,
      mdst_data_rsci_d_d => DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_d_d,
      mdst_data_rsci_q_d => DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_q_d,
      mdst_data_rsci_radr_d_core => DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_radr_d_core,
      mdst_data_rsci_wadr_d_core => DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_wadr_d_core,
      mdst_data_rsci_d_d_core => DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_d_d_core,
      mdst_data_rsci_q_d_mxwt => DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_q_d_mxwt,
      mdst_data_rsci_biwt => mdst_data_rsci_biwt,
      mdst_data_rsci_bdwt => mdst_data_rsci_bdwt,
      mdst_data_rsci_radr_d_core_sct => mdst_data_rsci_radr_d_core_sct_iff,
      mdst_data_rsci_wadr_d_core_sct_pff => mdst_data_rsci_wadr_d_core_sct_iff
    );
  mdst_data_rsci_radr_d_reg <= DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_radr_d;
  mdst_data_rsci_wadr_d_reg <= DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_wadr_d;
  mdst_data_rsci_d_d_reg <= DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_d_d;
  DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_q_d <= mdst_data_rsci_q_d;
  DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_radr_d_core
      <= mdst_data_rsci_radr_d_core;
  DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_wadr_d_core
      <= mdst_data_rsci_wadr_d_core;
  DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_d_d_core <=
      mdst_data_rsci_d_d_core;
  mdst_data_rsci_q_d_mxwt <= DCT_core_mdst_data_rsci_1_mdst_data_rsc_wait_dp_inst_mdst_data_rsci_q_d_mxwt;

  mdst_data_rsci_radr_d <= mdst_data_rsci_radr_d_reg;
  mdst_data_rsci_wadr_d <= mdst_data_rsci_wadr_d_reg;
  mdst_data_rsci_d_d <= mdst_data_rsci_d_d_reg;
  mdst_data_rsci_we_d <= mdst_data_rsci_wadr_d_core_sct_iff;
  mdst_data_rsci_re_d <= mdst_data_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_src_rsci
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_src_rsci IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    src_rsc_dat : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    src_rsc_vld : IN STD_LOGIC;
    src_rsc_rdy : OUT STD_LOGIC;
    core_wen : IN STD_LOGIC;
    src_rsci_oswt : IN STD_LOGIC;
    src_rsci_wen_comp : OUT STD_LOGIC;
    src_rsci_idat_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
  );
END DCT_core_src_rsci;

ARCHITECTURE v1 OF DCT_core_src_rsci IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL src_rsci_biwt : STD_LOGIC;
  SIGNAL src_rsci_bdwt : STD_LOGIC;
  SIGNAL src_rsci_bcwt : STD_LOGIC;
  SIGNAL src_rsci_irdy_core_sct : STD_LOGIC;
  SIGNAL src_rsci_ivld : STD_LOGIC;
  SIGNAL src_rsci_idat : STD_LOGIC_VECTOR (19 DOWNTO 0);

  SIGNAL src_rsci_dat : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL src_rsci_idat_1 : STD_LOGIC_VECTOR (19 DOWNTO 0);

  COMPONENT DCT_core_src_rsci_src_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      src_rsci_oswt : IN STD_LOGIC;
      src_rsci_biwt : OUT STD_LOGIC;
      src_rsci_bdwt : OUT STD_LOGIC;
      src_rsci_bcwt : IN STD_LOGIC;
      src_rsci_irdy_core_sct : OUT STD_LOGIC;
      src_rsci_ivld : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT DCT_core_src_rsci_src_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      src_rsci_oswt : IN STD_LOGIC;
      src_rsci_wen_comp : OUT STD_LOGIC;
      src_rsci_idat_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      src_rsci_biwt : IN STD_LOGIC;
      src_rsci_bdwt : IN STD_LOGIC;
      src_rsci_bcwt : OUT STD_LOGIC;
      src_rsci_idat : IN STD_LOGIC_VECTOR (19 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL DCT_core_src_rsci_src_wait_dp_inst_src_rsci_idat_mxwt : STD_LOGIC_VECTOR
      (19 DOWNTO 0);
  SIGNAL DCT_core_src_rsci_src_wait_dp_inst_src_rsci_idat : STD_LOGIC_VECTOR (19
      DOWNTO 0);

BEGIN
  src_rsci : work.ccs_in_wait_pkg_v1.ccs_in_wait_v1
    GENERIC MAP(
      rscid => 2,
      width => 20
      )
    PORT MAP(
      rdy => src_rsc_rdy,
      vld => src_rsc_vld,
      dat => src_rsci_dat,
      irdy => src_rsci_irdy_core_sct,
      ivld => src_rsci_ivld,
      idat => src_rsci_idat_1
    );
  src_rsci_dat <= src_rsc_dat;
  src_rsci_idat <= src_rsci_idat_1;

  DCT_core_src_rsci_src_wait_ctrl_inst : DCT_core_src_rsci_src_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      src_rsci_oswt => src_rsci_oswt,
      src_rsci_biwt => src_rsci_biwt,
      src_rsci_bdwt => src_rsci_bdwt,
      src_rsci_bcwt => src_rsci_bcwt,
      src_rsci_irdy_core_sct => src_rsci_irdy_core_sct,
      src_rsci_ivld => src_rsci_ivld
    );
  DCT_core_src_rsci_src_wait_dp_inst : DCT_core_src_rsci_src_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      src_rsci_oswt => src_rsci_oswt,
      src_rsci_wen_comp => src_rsci_wen_comp,
      src_rsci_idat_mxwt => DCT_core_src_rsci_src_wait_dp_inst_src_rsci_idat_mxwt,
      src_rsci_biwt => src_rsci_biwt,
      src_rsci_bdwt => src_rsci_bdwt,
      src_rsci_bcwt => src_rsci_bcwt,
      src_rsci_idat => DCT_core_src_rsci_src_wait_dp_inst_src_rsci_idat
    );
  src_rsci_idat_mxwt <= DCT_core_src_rsci_src_wait_dp_inst_src_rsci_idat_mxwt;
  DCT_core_src_rsci_src_wait_dp_inst_src_rsci_idat <= src_rsci_idat;

END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core_dst_rsci
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core_dst_rsci IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    dst_rsc_dat : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    dst_rsc_vld : OUT STD_LOGIC;
    dst_rsc_rdy : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    dst_rsci_oswt : IN STD_LOGIC;
    dst_rsci_wen_comp : OUT STD_LOGIC;
    dst_rsci_idat : IN STD_LOGIC_VECTOR (19 DOWNTO 0)
  );
END DCT_core_dst_rsci;

ARCHITECTURE v1 OF DCT_core_dst_rsci IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL dst_rsci_irdy : STD_LOGIC;
  SIGNAL dst_rsci_biwt : STD_LOGIC;
  SIGNAL dst_rsci_bdwt : STD_LOGIC;
  SIGNAL dst_rsci_bcwt : STD_LOGIC;
  SIGNAL dst_rsci_ivld_core_sct : STD_LOGIC;

  SIGNAL dst_rsci_idat_1 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL dst_rsci_dat : STD_LOGIC_VECTOR (19 DOWNTO 0);

  COMPONENT DCT_core_dst_rsci_dst_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      dst_rsci_oswt : IN STD_LOGIC;
      dst_rsci_irdy : IN STD_LOGIC;
      dst_rsci_biwt : OUT STD_LOGIC;
      dst_rsci_bdwt : OUT STD_LOGIC;
      dst_rsci_bcwt : IN STD_LOGIC;
      dst_rsci_ivld_core_sct : OUT STD_LOGIC
    );
  END COMPONENT;
  COMPONENT DCT_core_dst_rsci_dst_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      dst_rsci_oswt : IN STD_LOGIC;
      dst_rsci_wen_comp : OUT STD_LOGIC;
      dst_rsci_biwt : IN STD_LOGIC;
      dst_rsci_bdwt : IN STD_LOGIC;
      dst_rsci_bcwt : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN
  dst_rsci : work.ccs_out_wait_pkg_v1.ccs_out_wait_v1
    GENERIC MAP(
      rscid => 1,
      width => 20
      )
    PORT MAP(
      irdy => dst_rsci_irdy,
      ivld => dst_rsci_ivld_core_sct,
      idat => dst_rsci_idat_1,
      rdy => dst_rsc_rdy,
      vld => dst_rsc_vld,
      dat => dst_rsci_dat
    );
  dst_rsci_idat_1 <= dst_rsci_idat;
  dst_rsc_dat <= dst_rsci_dat;

  DCT_core_dst_rsci_dst_wait_ctrl_inst : DCT_core_dst_rsci_dst_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      dst_rsci_oswt => dst_rsci_oswt,
      dst_rsci_irdy => dst_rsci_irdy,
      dst_rsci_biwt => dst_rsci_biwt,
      dst_rsci_bdwt => dst_rsci_bdwt,
      dst_rsci_bcwt => dst_rsci_bcwt,
      dst_rsci_ivld_core_sct => dst_rsci_ivld_core_sct
    );
  DCT_core_dst_rsci_dst_wait_dp_inst : DCT_core_dst_rsci_dst_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      dst_rsci_oswt => dst_rsci_oswt,
      dst_rsci_wen_comp => dst_rsci_wen_comp,
      dst_rsci_biwt => dst_rsci_biwt,
      dst_rsci_bdwt => dst_rsci_bdwt,
      dst_rsci_bcwt => dst_rsci_bcwt
    );
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT_core
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT_core IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    dst_rsc_dat : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    dst_rsc_vld : OUT STD_LOGIC;
    dst_rsc_rdy : IN STD_LOGIC;
    src_rsc_dat : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    src_rsc_vld : IN STD_LOGIC;
    src_rsc_rdy : OUT STD_LOGIC;
    mdst_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    mdst_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    mdst_data_rsci_we_d : OUT STD_LOGIC;
    mdst_data_rsci_re_d : OUT STD_LOGIC;
    mdst_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
    msrc_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    msrc_data_rsci_we_d : OUT STD_LOGIC;
    msrc_data_rsci_re_d : OUT STD_LOGIC;
    msrc_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0)
  );
END DCT_core;

ARCHITECTURE v1 OF DCT_core IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL core_wen : STD_LOGIC;
  SIGNAL core_wten : STD_LOGIC;
  SIGNAL dst_rsci_wen_comp : STD_LOGIC;
  SIGNAL dst_rsci_idat : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL src_rsci_wen_comp : STD_LOGIC;
  SIGNAL src_rsci_idat_mxwt : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsci_q_d_mxwt : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsci_q_d_mxwt : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL fsm_output : STD_LOGIC_VECTOR (27 DOWNTO 0);
  SIGNAL or_dcpl_42 : STD_LOGIC;
  SIGNAL or_dcpl_45 : STD_LOGIC;
  SIGNAL or_dcpl_51 : STD_LOGIC;
  SIGNAL or_dcpl_58 : STD_LOGIC;
  SIGNAL or_dcpl_59 : STD_LOGIC;
  SIGNAL or_dcpl_61 : STD_LOGIC;
  SIGNAL or_dcpl_62 : STD_LOGIC;
  SIGNAL or_tmp_28 : STD_LOGIC;
  SIGNAL and_110_cse : STD_LOGIC;
  SIGNAL loop_lmm_i_11_0_sva_10_0 : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL buf_0_lpi_5 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL loop_11_x_3_0_sva_2_0 : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL loop_11_and_stg_1_1_sva : STD_LOGIC;
  SIGNAL loop_11_and_stg_1_2_sva : STD_LOGIC;
  SIGNAL loop_11_and_stg_1_3_sva : STD_LOGIC;
  SIGNAL loop_11_and_stg_1_0_sva : STD_LOGIC;
  SIGNAL loop_12_y_3_0_sva_1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL loop_12_y_3_0_sva_2_0 : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL reg_dst_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_src_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_mdst_data_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_msrc_data_rsci_oswt_cse : STD_LOGIC;
  SIGNAL mdst_data_nor_2_cse : STD_LOGIC;
  SIGNAL mdst_data_rsci_radr_d_reg : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL or_99_rmff : STD_LOGIC;
  SIGNAL mdst_data_rsci_wadr_d_reg : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_d_d_reg : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsci_we_d_reg : STD_LOGIC;
  SIGNAL mdst_data_rsci_re_d_reg : STD_LOGIC;
  SIGNAL msrc_data_rsci_radr_d_reg : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_wadr_d_reg : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_d_d_reg : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsci_we_d_reg : STD_LOGIC;
  SIGNAL msrc_data_rsci_re_d_reg : STD_LOGIC;
  SIGNAL loop_2_j_11_3_sva_7_0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL loop_3_k_3_0_sva_2_0 : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL buf_1_lpi_5 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL buf_2_lpi_5 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL buf_3_lpi_5 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL buf_4_lpi_5 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL buf_5_lpi_5 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL buf_6_lpi_5 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL buf_7_lpi_5 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL or_tmp_83 : STD_LOGIC;
  SIGNAL z_out : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL z_out_1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL z_out_2 : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL loop_12_mux_8_itm : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL loop_12_asn_23_itm : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL loop_12_mux_9_itm : STD_LOGIC_VECTOR (13 DOWNTO 0);
  SIGNAL loop_12_slc_loop_12_acc_9_3_itm : STD_LOGIC;
  SIGNAL loop_3_k_3_0_sva_2_0_mx0c1 : STD_LOGIC;
  SIGNAL loop_11_x_3_0_sva_2_0_mx0c0 : STD_LOGIC;
  SIGNAL loop_11_x_3_0_sva_2_0_mx0c2 : STD_LOGIC;
  SIGNAL loop_11_x_3_0_sva_2_0_mx0c3 : STD_LOGIC;
  SIGNAL loop_11_and_stg_1_3_sva_1 : STD_LOGIC;
  SIGNAL loop_11_and_stg_1_2_sva_1 : STD_LOGIC;
  SIGNAL loop_11_and_stg_1_1_sva_1 : STD_LOGIC;
  SIGNAL loop_6_loop_6_acc_1_ctmp_sva_1 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL loop_12_loop_12_nor_rgt : STD_LOGIC;
  SIGNAL loop_12_and_2_rgt : STD_LOGIC;
  SIGNAL loop_12_and_3_rgt : STD_LOGIC;
  SIGNAL loop_12_and_4_rgt : STD_LOGIC;
  SIGNAL loop_12_and_5_rgt : STD_LOGIC;
  SIGNAL loop_12_and_6_rgt : STD_LOGIC;
  SIGNAL loop_12_and_7_rgt : STD_LOGIC;
  SIGNAL loop_12_and_8_rgt : STD_LOGIC;
  SIGNAL or_184_cse : STD_LOGIC;
  SIGNAL loop_11_and_3_cse : STD_LOGIC;
  SIGNAL or_tmp : STD_LOGIC;
  SIGNAL or_tmp_91 : STD_LOGIC;
  SIGNAL mux_tmp : STD_LOGIC;
  SIGNAL or_tmp_93 : STD_LOGIC;
  SIGNAL mux_tmp_2 : STD_LOGIC;
  SIGNAL or_tmp_95 : STD_LOGIC;
  SIGNAL mux_tmp_4 : STD_LOGIC;
  SIGNAL or_tmp_97 : STD_LOGIC;
  SIGNAL mux_tmp_6 : STD_LOGIC;
  SIGNAL or_202_tmp : STD_LOGIC;
  SIGNAL or_199_tmp : STD_LOGIC;
  SIGNAL and_156_tmp : STD_LOGIC;
  SIGNAL or_198_tmp : STD_LOGIC;
  SIGNAL and_149_tmp : STD_LOGIC;
  SIGNAL or_197_tmp : STD_LOGIC;
  SIGNAL and_142_tmp : STD_LOGIC;
  SIGNAL or_196_tmp : STD_LOGIC;
  SIGNAL and_135_tmp : STD_LOGIC;
  SIGNAL or_193_tmp : STD_LOGIC;
  SIGNAL and_128_tmp : STD_LOGIC;
  SIGNAL or_190_tmp : STD_LOGIC;
  SIGNAL and_121_tmp : STD_LOGIC;
  SIGNAL or_187_tmp : STD_LOGIC;
  SIGNAL and_114_tmp : STD_LOGIC;
  SIGNAL loop_6_or_1_itm : STD_LOGIC;

  SIGNAL loop_lmm_i_mux_nl : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL loop_1_i_loop_1_i_and_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL loop_1_i_mux_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL nor_16_nl : STD_LOGIC;
  SIGNAL or_96_nl : STD_LOGIC;
  SIGNAL loop_lmm_i_nor_nl : STD_LOGIC;
  SIGNAL loop_5_loop_5_nand_12_nl : STD_LOGIC;
  SIGNAL nor_20_nl : STD_LOGIC;
  SIGNAL loop_5_loop_5_nand_14_nl : STD_LOGIC;
  SIGNAL nor_21_nl : STD_LOGIC;
  SIGNAL loop_5_loop_5_nand_16_nl : STD_LOGIC;
  SIGNAL nor_22_nl : STD_LOGIC;
  SIGNAL loop_5_loop_5_nand_22_nl : STD_LOGIC;
  SIGNAL nor_23_nl : STD_LOGIC;
  SIGNAL loop_5_loop_5_nand_20_nl : STD_LOGIC;
  SIGNAL nor_24_nl : STD_LOGIC;
  SIGNAL loop_5_loop_5_nand_18_nl : STD_LOGIC;
  SIGNAL nor_25_nl : STD_LOGIC;
  SIGNAL loop_5_loop_5_nand_8_nl : STD_LOGIC;
  SIGNAL nor_26_nl : STD_LOGIC;
  SIGNAL loop_out_i_mux_nl : STD_LOGIC_VECTOR (11 DOWNTO 0);
  SIGNAL loop_out_acc_1_nl : STD_LOGIC_VECTOR (11 DOWNTO 0);
  SIGNAL loop_5_loop_5_nand_10_nl : STD_LOGIC;
  SIGNAL and_246_nl : STD_LOGIC;
  SIGNAL and_167_nl : STD_LOGIC;
  SIGNAL loop_3_k_mux1h_3_nl : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL loop_11_x_not_nl : STD_LOGIC;
  SIGNAL loop_12_y_mux_nl : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL or_162_nl : STD_LOGIC;
  SIGNAL loop_6_mux_9_nl : STD_LOGIC_VECTOR (13 DOWNTO 0);
  SIGNAL operator_40_16_true_AC_TRN_AC_WRAP_mul_1_nl : STD_LOGIC_VECTOR (31 DOWNTO
      0);
  SIGNAL nor_19_nl : STD_LOGIC;
  SIGNAL nor_18_nl : STD_LOGIC;
  SIGNAL nor_17_nl : STD_LOGIC;
  SIGNAL nor_nl : STD_LOGIC;
  SIGNAL mux_6_nl : STD_LOGIC;
  SIGNAL mux_8_nl : STD_LOGIC;
  SIGNAL mux_10_nl : STD_LOGIC;
  SIGNAL mux_12_nl : STD_LOGIC;
  SIGNAL mux_13_nl : STD_LOGIC;
  SIGNAL mux_14_nl : STD_LOGIC;
  SIGNAL mux_15_nl : STD_LOGIC;
  SIGNAL mux_16_nl : STD_LOGIC;
  SIGNAL loop_6_and_2_nl : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL loop_6_mux1h_10_nl : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL not_154_nl : STD_LOGIC;
  SIGNAL loop_6_or_9_nl : STD_LOGIC;
  SIGNAL loop_6_loop_6_mux_2_nl : STD_LOGIC;
  SIGNAL loop_6_mux1h_11_nl : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL loop_6_and_3_nl : STD_LOGIC_VECTOR (16 DOWNTO 0);
  SIGNAL loop_6_mux1h_12_nl : STD_LOGIC_VECTOR (16 DOWNTO 0);
  SIGNAL not_155_nl : STD_LOGIC;
  SIGNAL loop_6_mux1h_13_nl : STD_LOGIC;
  SIGNAL loop_6_mux1h_14_nl : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL loop_12_mux1h_15_nl : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL or_203_nl : STD_LOGIC;
  SIGNAL or_204_nl : STD_LOGIC;
  SIGNAL loop_6_mux1h_15_nl : STD_LOGIC_VECTOR (4 DOWNTO 0);
  SIGNAL loop_6_mux1h_16_nl : STD_LOGIC;
  SIGNAL loop_6_mux1h_17_nl : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL loop_6_loop_6_mux_3_nl : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL loop_6_or_10_nl : STD_LOGIC;
  COMPONENT DCT_core_dst_rsci
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      dst_rsc_dat : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      dst_rsc_vld : OUT STD_LOGIC;
      dst_rsc_rdy : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      dst_rsci_oswt : IN STD_LOGIC;
      dst_rsci_wen_comp : OUT STD_LOGIC;
      dst_rsci_idat : IN STD_LOGIC_VECTOR (19 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL DCT_core_dst_rsci_inst_dst_rsc_dat : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_dst_rsci_inst_dst_rsci_idat : STD_LOGIC_VECTOR (19 DOWNTO 0);

  COMPONENT DCT_core_src_rsci
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      src_rsc_dat : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      src_rsc_vld : IN STD_LOGIC;
      src_rsc_rdy : OUT STD_LOGIC;
      core_wen : IN STD_LOGIC;
      src_rsci_oswt : IN STD_LOGIC;
      src_rsci_wen_comp : OUT STD_LOGIC;
      src_rsci_idat_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL DCT_core_src_rsci_inst_src_rsc_dat : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_src_rsci_inst_src_rsci_idat_mxwt : STD_LOGIC_VECTOR (19 DOWNTO
      0);

  COMPONENT DCT_core_mdst_data_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      mdst_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      mdst_data_rsci_we_d : OUT STD_LOGIC;
      mdst_data_rsci_re_d : OUT STD_LOGIC;
      mdst_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      mdst_data_rsci_oswt : IN STD_LOGIC;
      mdst_data_rsci_radr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_d_d_core : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      mdst_data_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      mdst_data_rsci_oswt_pff : IN STD_LOGIC;
      mdst_data_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_radr_d : STD_LOGIC_VECTOR
      (10 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_wadr_d : STD_LOGIC_VECTOR
      (10 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_d_d : STD_LOGIC_VECTOR (19
      DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_q_d : STD_LOGIC_VECTOR (19
      DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_radr_d_core : STD_LOGIC_VECTOR
      (10 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (10 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_d_d_core : STD_LOGIC_VECTOR
      (19 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (19 DOWNTO 0);
  SIGNAL DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT DCT_core_msrc_data_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      msrc_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_we_d : OUT STD_LOGIC;
      msrc_data_rsci_re_d : OUT STD_LOGIC;
      msrc_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      msrc_data_rsci_oswt : IN STD_LOGIC;
      msrc_data_rsci_radr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_d_d_core : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_oswt_pff : IN STD_LOGIC;
      msrc_data_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_radr_d : STD_LOGIC_VECTOR
      (10 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_wadr_d : STD_LOGIC_VECTOR
      (10 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_d_d : STD_LOGIC_VECTOR (19
      DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_q_d : STD_LOGIC_VECTOR (19
      DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_radr_d_core : STD_LOGIC_VECTOR
      (10 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (10 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_d_d_core : STD_LOGIC_VECTOR
      (19 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (19 DOWNTO 0);
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_oswt_pff : STD_LOGIC;
  SIGNAL DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT DCT_core_staller
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      core_wen : OUT STD_LOGIC;
      core_wten : OUT STD_LOGIC;
      dst_rsci_wen_comp : IN STD_LOGIC;
      src_rsci_wen_comp : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT DCT_core_core_fsm
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      fsm_output : OUT STD_LOGIC_VECTOR (27 DOWNTO 0);
      loop_lmm_C_1_tr0 : IN STD_LOGIC;
      loop_6_C_2_tr0 : IN STD_LOGIC;
      loop_5_C_1_tr0 : IN STD_LOGIC;
      loop_7_C_1_tr0 : IN STD_LOGIC;
      loop_3_C_2_tr0 : IN STD_LOGIC;
      loop_12_C_2_tr0 : IN STD_LOGIC;
      loop_11_C_1_tr0 : IN STD_LOGIC;
      loop_13_C_1_tr0 : IN STD_LOGIC;
      loop_9_C_2_tr0 : IN STD_LOGIC;
      loop_2_C_0_tr0 : IN STD_LOGIC;
      loop_1_C_0_tr0 : IN STD_LOGIC;
      loop_out_C_2_tr0 : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL DCT_core_core_fsm_inst_fsm_output : STD_LOGIC_VECTOR (27 DOWNTO 0);
  SIGNAL DCT_core_core_fsm_inst_loop_lmm_C_1_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_6_C_2_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_5_C_1_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_7_C_1_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_3_C_2_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_12_C_2_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_11_C_1_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_13_C_1_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_9_C_2_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_2_C_0_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_1_C_0_tr0 : STD_LOGIC;
  SIGNAL DCT_core_core_fsm_inst_loop_out_C_2_tr0 : STD_LOGIC;

  FUNCTION CONV_SL_1_1(input:BOOLEAN)
  RETURN STD_LOGIC IS
  BEGIN
    IF input THEN RETURN '1';ELSE RETURN '0';END IF;
  END;

  FUNCTION MUX1HOT_s_1_3_2(input_2 : STD_LOGIC;
  input_1 : STD_LOGIC;
  input_0 : STD_LOGIC;
  sel : STD_LOGIC_VECTOR(2 DOWNTO 0))
  RETURN STD_LOGIC IS
    VARIABLE result : STD_LOGIC;
    VARIABLE tmp : STD_LOGIC;

    BEGIN
      tmp := sel(0);
      result := input_0 and tmp;
      tmp := sel(1);
      result := result or ( input_1 and tmp);
      tmp := sel(2);
      result := result or ( input_2 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_11_3_2(input_2 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(2 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(10 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(10 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_17_3_2(input_2 : STD_LOGIC_VECTOR(16 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(16 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(2 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(16 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(16 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_19_8_2(input_7 : STD_LOGIC_VECTOR(18 DOWNTO 0);
  input_6 : STD_LOGIC_VECTOR(18 DOWNTO 0);
  input_5 : STD_LOGIC_VECTOR(18 DOWNTO 0);
  input_4 : STD_LOGIC_VECTOR(18 DOWNTO 0);
  input_3 : STD_LOGIC_VECTOR(18 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(18 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(18 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(18 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(7 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(18 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(18 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
      tmp := (OTHERS=>sel( 3));
      result := result or ( input_3 and tmp);
      tmp := (OTHERS=>sel( 4));
      result := result or ( input_4 and tmp);
      tmp := (OTHERS=>sel( 5));
      result := result or ( input_5 and tmp);
      tmp := (OTHERS=>sel( 6));
      result := result or ( input_6 and tmp);
      tmp := (OTHERS=>sel( 7));
      result := result or ( input_7 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_20_3_2(input_2 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(2 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(19 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(19 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_20_4_2(input_3 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(3 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(19 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(19 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
      tmp := (OTHERS=>sel( 3));
      result := result or ( input_3 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_20_8_2(input_7 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_6 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_5 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_4 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_3 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(7 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(19 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(19 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
      tmp := (OTHERS=>sel( 3));
      result := result or ( input_3 and tmp);
      tmp := (OTHERS=>sel( 4));
      result := result or ( input_4 and tmp);
      tmp := (OTHERS=>sel( 5));
      result := result or ( input_5 and tmp);
      tmp := (OTHERS=>sel( 6));
      result := result or ( input_6 and tmp);
      tmp := (OTHERS=>sel( 7));
      result := result or ( input_7 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_2_3_2(input_2 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(2 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(1 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(1 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_3_3_2(input_2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(2 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(2 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(2 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_5_4_2(input_3 : STD_LOGIC_VECTOR(4 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(4 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(3 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(4 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(4 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
      tmp := (OTHERS=>sel( 3));
      result := result or ( input_3 and tmp);
    RETURN result;
  END;

  FUNCTION MUX_s_1_2_2(input_0 : STD_LOGIC;
  input_1 : STD_LOGIC;
  sel : STD_LOGIC)
  RETURN STD_LOGIC IS
    VARIABLE result : STD_LOGIC;

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_11_2_2(input_0 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(10 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(10 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_12_2_2(input_0 : STD_LOGIC_VECTOR(11 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(11 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(11 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_14_16_2(input_0 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_3 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_4 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_5 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_6 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_7 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_8 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_9 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_10 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_11 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_12 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_13 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_14 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_15 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(3 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(13 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN "0000" =>
          result := input_0;
        WHEN "0001" =>
          result := input_1;
        WHEN "0010" =>
          result := input_2;
        WHEN "0011" =>
          result := input_3;
        WHEN "0100" =>
          result := input_4;
        WHEN "0101" =>
          result := input_5;
        WHEN "0110" =>
          result := input_6;
        WHEN "0111" =>
          result := input_7;
        WHEN "1000" =>
          result := input_8;
        WHEN "1001" =>
          result := input_9;
        WHEN "1010" =>
          result := input_10;
        WHEN "1011" =>
          result := input_11;
        WHEN "1100" =>
          result := input_12;
        WHEN "1101" =>
          result := input_13;
        WHEN "1110" =>
          result := input_14;
        WHEN others =>
          result := input_15;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_14_2_2(input_0 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(13 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(13 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_17_2_2(input_0 : STD_LOGIC_VECTOR(16 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(16 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(16 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_20_2_2(input_0 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(19 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(19 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_2_2_2(input_0 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(1 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_3_2_2(input_0 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(2 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_8_2_2(input_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(7 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

BEGIN
  DCT_core_dst_rsci_inst : DCT_core_dst_rsci
    PORT MAP(
      clk => clk,
      rst => rst,
      dst_rsc_dat => DCT_core_dst_rsci_inst_dst_rsc_dat,
      dst_rsc_vld => dst_rsc_vld,
      dst_rsc_rdy => dst_rsc_rdy,
      core_wen => core_wen,
      dst_rsci_oswt => reg_dst_rsci_oswt_cse,
      dst_rsci_wen_comp => dst_rsci_wen_comp,
      dst_rsci_idat => DCT_core_dst_rsci_inst_dst_rsci_idat
    );
  dst_rsc_dat <= DCT_core_dst_rsci_inst_dst_rsc_dat;
  DCT_core_dst_rsci_inst_dst_rsci_idat <= dst_rsci_idat;

  DCT_core_src_rsci_inst : DCT_core_src_rsci
    PORT MAP(
      clk => clk,
      rst => rst,
      src_rsc_dat => DCT_core_src_rsci_inst_src_rsc_dat,
      src_rsc_vld => src_rsc_vld,
      src_rsc_rdy => src_rsc_rdy,
      core_wen => core_wen,
      src_rsci_oswt => reg_src_rsci_oswt_cse,
      src_rsci_wen_comp => src_rsci_wen_comp,
      src_rsci_idat_mxwt => DCT_core_src_rsci_inst_src_rsci_idat_mxwt
    );
  DCT_core_src_rsci_inst_src_rsc_dat <= src_rsc_dat;
  src_rsci_idat_mxwt <= DCT_core_src_rsci_inst_src_rsci_idat_mxwt;

  DCT_core_mdst_data_rsci_1_inst : DCT_core_mdst_data_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      mdst_data_rsci_radr_d => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_radr_d,
      mdst_data_rsci_wadr_d => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_wadr_d,
      mdst_data_rsci_d_d => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_d_d,
      mdst_data_rsci_we_d => mdst_data_rsci_we_d_reg,
      mdst_data_rsci_re_d => mdst_data_rsci_re_d_reg,
      mdst_data_rsci_q_d => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      mdst_data_rsci_oswt => reg_mdst_data_rsci_oswt_cse,
      mdst_data_rsci_radr_d_core => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_radr_d_core,
      mdst_data_rsci_wadr_d_core => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_wadr_d_core,
      mdst_data_rsci_d_d_core => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_d_d_core,
      mdst_data_rsci_q_d_mxwt => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_q_d_mxwt,
      mdst_data_rsci_oswt_pff => or_99_rmff,
      mdst_data_rsci_iswt0_1_pff => DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_iswt0_1_pff
    );
  mdst_data_rsci_radr_d_reg <= DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_radr_d;
  mdst_data_rsci_wadr_d_reg <= DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_wadr_d;
  mdst_data_rsci_d_d_reg <= DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_d_d;
  DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_q_d <= mdst_data_rsci_q_d;
  DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_radr_d_core <= (MUX_v_8_2_2(loop_2_j_11_3_sva_7_0,
      (loop_lmm_i_11_0_sva_10_0(10 DOWNTO 3)), fsm_output(25))) & (MUX_v_3_2_2(loop_3_k_3_0_sva_2_0,
      (loop_lmm_i_11_0_sva_10_0(2 DOWNTO 0)), fsm_output(25)));
  DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_wadr_d_core <= loop_2_j_11_3_sva_7_0
      & (MUX_v_3_2_2(STD_LOGIC_VECTOR'("000"), (MUX_v_3_2_2(loop_11_x_3_0_sva_2_0,
      loop_3_k_3_0_sva_2_0, (fsm_output(18)) OR (fsm_output(20)))), ((fsm_output(18))
      OR (fsm_output(10)) OR (fsm_output(20)))));
  DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_d_d_core <= STD_LOGIC_VECTOR(CONV_SIGNED(SIGNED(MUX1HOT_v_19_8_2((z_out(27
      DOWNTO 9)), (buf_1_lpi_5(19 DOWNTO 1)), (buf_2_lpi_5(19 DOWNTO 1)), (buf_3_lpi_5(19
      DOWNTO 1)), (buf_4_lpi_5(19 DOWNTO 1)), (buf_5_lpi_5(19 DOWNTO 1)), (buf_6_lpi_5(19
      DOWNTO 1)), (buf_7_lpi_5(19 DOWNTO 1)), STD_LOGIC_VECTOR'( (NOT or_dcpl_45)
      & (CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("001")) AND or_dcpl_45)
      & (CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("010")) AND or_dcpl_45)
      & (CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("011")) AND or_dcpl_45)
      & ((loop_11_x_3_0_sva_2_0(2)) AND mdst_data_nor_2_cse AND or_dcpl_45) & (CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("101"))
      AND or_dcpl_45) & (CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("110"))
      AND or_dcpl_45) & (CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("111"))
      AND or_dcpl_45)))),20));
  mdst_data_rsci_q_d_mxwt <= DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_q_d_mxwt;
  DCT_core_mdst_data_rsci_1_inst_mdst_data_rsci_iswt0_1_pff <= (fsm_output(8)) OR
      (fsm_output(18)) OR or_dcpl_45;

  DCT_core_msrc_data_rsci_1_inst : DCT_core_msrc_data_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      msrc_data_rsci_radr_d => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_radr_d,
      msrc_data_rsci_wadr_d => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_wadr_d,
      msrc_data_rsci_d_d => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_d_d,
      msrc_data_rsci_we_d => msrc_data_rsci_we_d_reg,
      msrc_data_rsci_re_d => msrc_data_rsci_re_d_reg,
      msrc_data_rsci_q_d => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      msrc_data_rsci_oswt => reg_msrc_data_rsci_oswt_cse,
      msrc_data_rsci_radr_d_core => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_radr_d_core,
      msrc_data_rsci_wadr_d_core => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_wadr_d_core,
      msrc_data_rsci_d_d_core => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_d_d_core,
      msrc_data_rsci_q_d_mxwt => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_q_d_mxwt,
      msrc_data_rsci_oswt_pff => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_oswt_pff,
      msrc_data_rsci_iswt0_1_pff => DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_iswt0_1_pff
    );
  msrc_data_rsci_radr_d_reg <= DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_radr_d;
  msrc_data_rsci_wadr_d_reg <= DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_wadr_d;
  msrc_data_rsci_d_d_reg <= DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_d_d;
  DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_q_d <= msrc_data_rsci_q_d;
  DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_radr_d_core <= loop_2_j_11_3_sva_7_0
      & loop_12_y_3_0_sva_2_0;
  DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_wadr_d_core <= loop_lmm_i_11_0_sva_10_0;
  DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_d_d_core <= src_rsci_idat_mxwt;
  msrc_data_rsci_q_d_mxwt <= DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_q_d_mxwt;
  DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_oswt_pff <= fsm_output(4);
  DCT_core_msrc_data_rsci_1_inst_msrc_data_rsci_iswt0_1_pff <= fsm_output(1);

  DCT_core_staller_inst : DCT_core_staller
    PORT MAP(
      clk => clk,
      rst => rst,
      core_wen => core_wen,
      core_wten => core_wten,
      dst_rsci_wen_comp => dst_rsci_wen_comp,
      src_rsci_wen_comp => src_rsci_wen_comp
    );
  DCT_core_core_fsm_inst : DCT_core_core_fsm
    PORT MAP(
      clk => clk,
      rst => rst,
      core_wen => core_wen,
      fsm_output => DCT_core_core_fsm_inst_fsm_output,
      loop_lmm_C_1_tr0 => DCT_core_core_fsm_inst_loop_lmm_C_1_tr0,
      loop_6_C_2_tr0 => DCT_core_core_fsm_inst_loop_6_C_2_tr0,
      loop_5_C_1_tr0 => DCT_core_core_fsm_inst_loop_5_C_1_tr0,
      loop_7_C_1_tr0 => DCT_core_core_fsm_inst_loop_7_C_1_tr0,
      loop_3_C_2_tr0 => DCT_core_core_fsm_inst_loop_3_C_2_tr0,
      loop_12_C_2_tr0 => DCT_core_core_fsm_inst_loop_12_C_2_tr0,
      loop_11_C_1_tr0 => DCT_core_core_fsm_inst_loop_11_C_1_tr0,
      loop_13_C_1_tr0 => DCT_core_core_fsm_inst_loop_13_C_1_tr0,
      loop_9_C_2_tr0 => DCT_core_core_fsm_inst_loop_9_C_2_tr0,
      loop_2_C_0_tr0 => DCT_core_core_fsm_inst_loop_2_C_0_tr0,
      loop_1_C_0_tr0 => DCT_core_core_fsm_inst_loop_1_C_0_tr0,
      loop_out_C_2_tr0 => DCT_core_core_fsm_inst_loop_out_C_2_tr0
    );
  fsm_output <= DCT_core_core_fsm_inst_fsm_output;
  DCT_core_core_fsm_inst_loop_lmm_C_1_tr0 <= buf_0_lpi_5(11);
  DCT_core_core_fsm_inst_loop_6_C_2_tr0 <= loop_12_y_3_0_sva_1(3);
  DCT_core_core_fsm_inst_loop_5_C_1_tr0 <= z_out_1(3);
  DCT_core_core_fsm_inst_loop_7_C_1_tr0 <= loop_12_y_3_0_sva_1(3);
  DCT_core_core_fsm_inst_loop_3_C_2_tr0 <= z_out_1(3);
  DCT_core_core_fsm_inst_loop_12_C_2_tr0 <= loop_12_y_3_0_sva_1(3);
  DCT_core_core_fsm_inst_loop_11_C_1_tr0 <= z_out_1(3);
  DCT_core_core_fsm_inst_loop_13_C_1_tr0 <= loop_12_y_3_0_sva_1(3);
  DCT_core_core_fsm_inst_loop_9_C_2_tr0 <= z_out_1(3);
  DCT_core_core_fsm_inst_loop_2_C_0_tr0 <= z_out_2(8);
  DCT_core_core_fsm_inst_loop_1_C_0_tr0 <= z_out_2(8);
  DCT_core_core_fsm_inst_loop_out_C_2_tr0 <= buf_0_lpi_5(11);

  or_99_rmff <= (fsm_output(25)) OR (fsm_output(14));
  mdst_data_nor_2_cse <= NOT(CONV_SL_1_1(loop_11_x_3_0_sva_2_0(1 DOWNTO 0)/=STD_LOGIC_VECTOR'("00")));
  loop_11_and_3_cse <= core_wen AND (NOT(or_dcpl_62 OR (fsm_output(14)) OR (fsm_output(16))
      OR (fsm_output(6))));
  loop_12_loop_12_nor_rgt <= NOT(CONV_SL_1_1(loop_11_x_3_0_sva_2_0/=STD_LOGIC_VECTOR'("000"))
      OR or_dcpl_61);
  loop_12_and_2_rgt <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("001"))
      AND (NOT or_dcpl_61);
  loop_12_and_3_rgt <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("010"))
      AND (NOT or_dcpl_61);
  loop_12_and_4_rgt <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("011"))
      AND (NOT or_dcpl_61);
  loop_12_and_5_rgt <= (loop_11_x_3_0_sva_2_0(2)) AND mdst_data_nor_2_cse AND (NOT
      or_dcpl_61);
  loop_12_and_6_rgt <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("101"))
      AND (NOT or_dcpl_61);
  loop_12_and_7_rgt <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("110"))
      AND (NOT or_dcpl_61);
  loop_12_and_8_rgt <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0=STD_LOGIC_VECTOR'("111"))
      AND (NOT or_dcpl_61);
  loop_11_and_stg_1_3_sva_1 <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0(1 DOWNTO 0)=STD_LOGIC_VECTOR'("11"));
  loop_11_and_stg_1_2_sva_1 <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0(1 DOWNTO 0)=STD_LOGIC_VECTOR'("10"));
  loop_11_and_stg_1_1_sva_1 <= CONV_SL_1_1(loop_11_x_3_0_sva_2_0(1 DOWNTO 0)=STD_LOGIC_VECTOR'("01"));
  operator_40_16_true_AC_TRN_AC_WRAP_mul_1_nl <= STD_LOGIC_VECTOR(CONV_SIGNED(SIGNED'(
      SIGNED(z_out) * SIGNED'( loop_12_slc_loop_12_acc_9_3_itm & '1')), 32));
  loop_6_loop_6_acc_1_ctmp_sva_1 <= STD_LOGIC_VECTOR(CONV_SIGNED(SIGNED(loop_12_mux_8_itm)
      + SIGNED(operator_40_16_true_AC_TRN_AC_WRAP_mul_1_nl(31 DOWNTO 12)), 20));
  or_dcpl_42 <= (fsm_output(1)) OR (fsm_output(25));
  or_dcpl_45 <= (fsm_output(10)) OR (fsm_output(20));
  or_dcpl_51 <= (fsm_output(16)) OR (fsm_output(6));
  or_dcpl_58 <= or_dcpl_42 OR (fsm_output(26));
  or_dcpl_59 <= (fsm_output(7)) OR (fsm_output(17));
  or_dcpl_61 <= (fsm_output(5)) OR (fsm_output(15));
  or_dcpl_62 <= or_dcpl_61 OR (fsm_output(4));
  or_tmp_28 <= (fsm_output(13)) OR (fsm_output(3));
  and_110_cse <= NOT((fsm_output(13)) OR (fsm_output(16)) OR (fsm_output(6)) OR (fsm_output(3)));
  loop_3_k_3_0_sva_2_0_mx0c1 <= (fsm_output(22)) OR ((NOT (z_out_1(3))) AND (fsm_output(12)));
  loop_11_x_3_0_sva_2_0_mx0c0 <= (fsm_output(22)) OR (fsm_output(12)) OR (fsm_output(2))
      OR (fsm_output(23)) OR (fsm_output(24));
  loop_11_x_3_0_sva_2_0_mx0c2 <= (fsm_output(19)) OR (fsm_output(9));
  loop_11_x_3_0_sva_2_0_mx0c3 <= (fsm_output(21)) OR (fsm_output(11));
  mdst_data_rsci_radr_d <= mdst_data_rsci_radr_d_reg;
  mdst_data_rsci_wadr_d <= mdst_data_rsci_wadr_d_reg;
  mdst_data_rsci_d_d <= mdst_data_rsci_d_d_reg;
  mdst_data_rsci_we_d <= mdst_data_rsci_we_d_reg;
  mdst_data_rsci_re_d <= mdst_data_rsci_re_d_reg;
  msrc_data_rsci_radr_d <= msrc_data_rsci_radr_d_reg;
  msrc_data_rsci_wadr_d <= msrc_data_rsci_wadr_d_reg;
  msrc_data_rsci_d_d <= msrc_data_rsci_d_d_reg;
  msrc_data_rsci_we_d <= msrc_data_rsci_we_d_reg;
  msrc_data_rsci_re_d <= msrc_data_rsci_re_d_reg;
  or_184_cse <= (fsm_output(14)) OR (fsm_output(4));
  or_tmp_83 <= (fsm_output(18)) OR (fsm_output(8));
  or_tmp <= or_tmp_28 OR or_dcpl_51;
  or_tmp_91 <= loop_11_and_stg_1_1_sva OR (NOT or_dcpl_51);
  nor_19_nl <= NOT(or_tmp_28 OR (NOT or_tmp_91));
  mux_tmp <= MUX_s_1_2_2(nor_19_nl, or_tmp_91, loop_11_and_stg_1_1_sva_1);
  or_tmp_93 <= loop_11_and_stg_1_2_sva OR (NOT or_dcpl_51);
  nor_18_nl <= NOT(or_tmp_28 OR (NOT or_tmp_93));
  mux_tmp_2 <= MUX_s_1_2_2(nor_18_nl, or_tmp_93, loop_11_and_stg_1_2_sva_1);
  or_tmp_95 <= loop_11_and_stg_1_3_sva OR (NOT or_dcpl_51);
  nor_17_nl <= NOT(or_tmp_28 OR (NOT or_tmp_95));
  mux_tmp_4 <= MUX_s_1_2_2(nor_17_nl, or_tmp_95, loop_11_and_stg_1_3_sva_1);
  or_tmp_97 <= loop_11_and_stg_1_0_sva OR (NOT or_dcpl_51);
  nor_nl <= NOT(or_tmp_28 OR (NOT or_tmp_97));
  mux_tmp_6 <= MUX_s_1_2_2(nor_nl, or_tmp_97, mdst_data_nor_2_cse);
  mux_6_nl <= MUX_s_1_2_2((NOT mux_tmp), or_tmp, loop_11_x_3_0_sva_2_0(2));
  or_187_tmp <= mux_6_nl OR and_110_cse;
  and_114_tmp <= loop_11_and_stg_1_1_sva AND (NOT (loop_11_x_3_0_sva_2_0(2))) AND
      or_dcpl_51;
  mux_8_nl <= MUX_s_1_2_2((NOT mux_tmp_2), or_tmp, loop_11_x_3_0_sva_2_0(2));
  or_190_tmp <= mux_8_nl OR and_110_cse;
  and_121_tmp <= loop_11_and_stg_1_2_sva AND (NOT (loop_11_x_3_0_sva_2_0(2))) AND
      or_dcpl_51;
  mux_10_nl <= MUX_s_1_2_2((NOT mux_tmp_4), or_tmp, loop_11_x_3_0_sva_2_0(2));
  or_193_tmp <= mux_10_nl OR and_110_cse;
  and_128_tmp <= loop_11_and_stg_1_3_sva AND (NOT (loop_11_x_3_0_sva_2_0(2))) AND
      or_dcpl_51;
  mux_12_nl <= MUX_s_1_2_2(or_tmp, (NOT mux_tmp_6), loop_11_x_3_0_sva_2_0(2));
  or_196_tmp <= mux_12_nl OR and_110_cse;
  and_135_tmp <= loop_11_and_stg_1_0_sva AND (loop_11_x_3_0_sva_2_0(2)) AND or_dcpl_51;
  mux_13_nl <= MUX_s_1_2_2(or_tmp, (NOT mux_tmp), loop_11_x_3_0_sva_2_0(2));
  or_197_tmp <= mux_13_nl OR and_110_cse;
  and_142_tmp <= loop_11_and_stg_1_1_sva AND (loop_11_x_3_0_sva_2_0(2)) AND or_dcpl_51;
  mux_14_nl <= MUX_s_1_2_2(or_tmp, (NOT mux_tmp_2), loop_11_x_3_0_sva_2_0(2));
  or_198_tmp <= mux_14_nl OR and_110_cse;
  and_149_tmp <= loop_11_and_stg_1_2_sva AND (loop_11_x_3_0_sva_2_0(2)) AND or_dcpl_51;
  mux_15_nl <= MUX_s_1_2_2(or_tmp, (NOT mux_tmp_4), loop_11_x_3_0_sva_2_0(2));
  or_199_tmp <= mux_15_nl OR and_110_cse;
  and_156_tmp <= loop_11_and_stg_1_3_sva AND (loop_11_x_3_0_sva_2_0(2)) AND or_dcpl_51;
  mux_16_nl <= MUX_s_1_2_2((NOT mux_tmp_6), or_tmp, loop_11_x_3_0_sva_2_0(2));
  or_202_tmp <= mux_16_nl OR or_dcpl_59 OR or_dcpl_62 OR (fsm_output(14));
  loop_6_or_1_itm <= or_184_cse OR or_dcpl_61;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND (fsm_output(26))) = '1' ) THEN
        dst_rsci_idat <= mdst_data_rsci_q_d_mxwt;
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( core_wen = '1' ) THEN
        loop_lmm_i_11_0_sva_10_0 <= MUX_v_11_2_2(STD_LOGIC_VECTOR'("00000000000"),
            loop_lmm_i_mux_nl, loop_lmm_i_nor_nl);
        buf_1_lpi_5 <= MUX1HOT_v_20_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_5_loop_5_nand_12_nl,
            1),20)), loop_6_loop_6_acc_1_ctmp_sva_1, buf_1_lpi_5, STD_LOGIC_VECTOR'(
            nor_20_nl & and_114_tmp & or_187_tmp));
        buf_2_lpi_5 <= MUX1HOT_v_20_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_5_loop_5_nand_14_nl,
            1),20)), loop_6_loop_6_acc_1_ctmp_sva_1, buf_2_lpi_5, STD_LOGIC_VECTOR'(
            nor_21_nl & and_121_tmp & or_190_tmp));
        buf_3_lpi_5 <= MUX1HOT_v_20_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_5_loop_5_nand_16_nl,
            1),20)), loop_6_loop_6_acc_1_ctmp_sva_1, buf_3_lpi_5, STD_LOGIC_VECTOR'(
            nor_22_nl & and_128_tmp & or_193_tmp));
        buf_4_lpi_5 <= MUX1HOT_v_20_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_5_loop_5_nand_22_nl,
            1),20)), loop_6_loop_6_acc_1_ctmp_sva_1, buf_4_lpi_5, STD_LOGIC_VECTOR'(
            nor_23_nl & and_135_tmp & or_196_tmp));
        buf_5_lpi_5 <= MUX1HOT_v_20_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_5_loop_5_nand_20_nl,
            1),20)), loop_6_loop_6_acc_1_ctmp_sva_1, buf_5_lpi_5, STD_LOGIC_VECTOR'(
            nor_24_nl & and_142_tmp & or_197_tmp));
        buf_6_lpi_5 <= MUX1HOT_v_20_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_5_loop_5_nand_18_nl,
            1),20)), loop_6_loop_6_acc_1_ctmp_sva_1, buf_6_lpi_5, STD_LOGIC_VECTOR'(
            nor_25_nl & and_149_tmp & or_198_tmp));
        buf_7_lpi_5 <= MUX1HOT_v_20_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_5_loop_5_nand_8_nl,
            1),20)), loop_6_loop_6_acc_1_ctmp_sva_1, buf_7_lpi_5, STD_LOGIC_VECTOR'(
            nor_26_nl & and_156_tmp & or_199_tmp));
        loop_12_y_3_0_sva_2_0 <= MUX_v_3_2_2(STD_LOGIC_VECTOR'("000"), loop_12_y_mux_nl,
            or_162_nl);
        loop_12_mux_9_itm <= MUX_v_14_2_2(loop_6_mux_9_nl, loop_12_mux_9_itm, or_dcpl_61);
        loop_12_asn_23_itm <= MUX_v_20_2_2(msrc_data_rsci_q_d_mxwt, mdst_data_rsci_q_d_mxwt,
            fsm_output(15));
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        reg_dst_rsci_oswt_cse <= '0';
        reg_src_rsci_oswt_cse <= '0';
        reg_mdst_data_rsci_oswt_cse <= '0';
        reg_msrc_data_rsci_oswt_cse <= '0';
        buf_0_lpi_5 <= STD_LOGIC_VECTOR'( "00000000000000000000");
      ELSIF ( core_wen = '1' ) THEN
        reg_dst_rsci_oswt_cse <= fsm_output(26);
        reg_src_rsci_oswt_cse <= NOT((NOT((fsm_output(0)) OR (fsm_output(2)))) OR
            ((buf_0_lpi_5(11)) AND (fsm_output(2))));
        reg_mdst_data_rsci_oswt_cse <= or_99_rmff;
        reg_msrc_data_rsci_oswt_cse <= fsm_output(4);
        buf_0_lpi_5 <= MUX1HOT_v_20_4_2((STD_LOGIC_VECTOR'( "00000000") & loop_out_i_mux_nl),
            STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_5_loop_5_nand_10_nl, 1),20)),
            loop_6_loop_6_acc_1_ctmp_sva_1, buf_0_lpi_5, STD_LOGIC_VECTOR'( or_dcpl_58
            & and_246_nl & and_167_nl & or_202_tmp));
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND ((fsm_output(23)) OR (fsm_output(2)) OR (fsm_output(24))))
          = '1' ) THEN
        loop_2_j_11_3_sva_7_0 <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), (z_out_2(7
            DOWNTO 0)), (fsm_output(23)));
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND ((fsm_output(2)) OR (fsm_output(23)) OR (fsm_output(24))
          OR ((z_out_1(3)) AND (fsm_output(12))) OR loop_3_k_3_0_sva_2_0_mx0c1))
          = '1' ) THEN
        loop_3_k_3_0_sva_2_0 <= MUX_v_3_2_2(STD_LOGIC_VECTOR'("000"), (z_out_1(2
            DOWNTO 0)), loop_3_k_3_0_sva_2_0_mx0c1);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        loop_11_x_3_0_sva_2_0 <= STD_LOGIC_VECTOR'( "000");
      ELSIF ( (core_wen AND (loop_11_x_3_0_sva_2_0_mx0c0 OR or_dcpl_59 OR loop_11_x_3_0_sva_2_0_mx0c2
          OR loop_11_x_3_0_sva_2_0_mx0c3)) = '1' ) THEN
        loop_11_x_3_0_sva_2_0 <= MUX_v_3_2_2(STD_LOGIC_VECTOR'("000"), loop_3_k_mux1h_3_nl,
            loop_11_x_not_nl);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        loop_11_and_stg_1_0_sva <= '0';
        loop_11_and_stg_1_1_sva <= '0';
        loop_11_and_stg_1_2_sva <= '0';
        loop_11_and_stg_1_3_sva <= '0';
      ELSIF ( loop_11_and_3_cse = '1' ) THEN
        loop_11_and_stg_1_0_sva <= mdst_data_nor_2_cse;
        loop_11_and_stg_1_1_sva <= loop_11_and_stg_1_1_sva_1;
        loop_11_and_stg_1_2_sva <= loop_11_and_stg_1_2_sva_1;
        loop_11_and_stg_1_3_sva <= loop_11_and_stg_1_3_sva_1;
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND (loop_12_loop_12_nor_rgt OR loop_12_and_2_rgt OR loop_12_and_3_rgt
          OR loop_12_and_4_rgt OR loop_12_and_5_rgt OR loop_12_and_6_rgt OR loop_12_and_7_rgt
          OR loop_12_and_8_rgt)) = '1' ) THEN
        loop_12_mux_8_itm <= MUX1HOT_v_20_8_2(buf_0_lpi_5, buf_1_lpi_5, buf_2_lpi_5,
            buf_3_lpi_5, buf_4_lpi_5, buf_5_lpi_5, buf_6_lpi_5, buf_7_lpi_5, STD_LOGIC_VECTOR'(
            loop_12_loop_12_nor_rgt & loop_12_and_2_rgt & loop_12_and_3_rgt & loop_12_and_4_rgt
            & loop_12_and_5_rgt & loop_12_and_6_rgt & loop_12_and_7_rgt & loop_12_and_8_rgt));
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        loop_12_y_3_0_sva_1 <= STD_LOGIC_VECTOR'( "0000");
      ELSIF ( (core_wen AND ((fsm_output(4)) OR (fsm_output(14)) OR or_dcpl_45))
          = '1' ) THEN
        loop_12_y_3_0_sva_1 <= z_out_1;
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND (loop_11_and_stg_1_1_sva OR loop_11_and_stg_1_2_sva OR loop_11_and_stg_1_0_sva
          OR loop_11_and_stg_1_3_sva)) = '1' ) THEN
        loop_12_slc_loop_12_acc_9_3_itm <= z_out_2(3);
      END IF;
    END IF;
  END PROCESS;
  loop_1_i_mux_nl <= MUX_v_8_2_2((loop_lmm_i_11_0_sva_10_0(7 DOWNTO 0)), (z_out_2(7
      DOWNTO 0)), fsm_output(24));
  nor_16_nl <= NOT(or_dcpl_58 OR (fsm_output(0)) OR (fsm_output(27)) OR (fsm_output(2)));
  loop_1_i_loop_1_i_and_nl <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), loop_1_i_mux_nl,
      nor_16_nl);
  or_96_nl <= (fsm_output(27)) OR ((NOT (buf_0_lpi_5(11))) AND (fsm_output(2)));
  loop_lmm_i_mux_nl <= MUX_v_11_2_2((STD_LOGIC_VECTOR'( "000") & loop_1_i_loop_1_i_and_nl),
      (buf_0_lpi_5(10 DOWNTO 0)), or_96_nl);
  loop_lmm_i_nor_nl <= NOT(or_dcpl_42 OR (fsm_output(26)) OR (fsm_output(0)) OR ((z_out_2(8))
      AND (fsm_output(24))));
  loop_5_loop_5_nand_12_nl <= NOT(loop_11_and_stg_1_1_sva_1 AND (NOT (loop_11_x_3_0_sva_2_0(2))));
  nor_20_nl <= NOT(and_114_tmp OR or_187_tmp);
  loop_5_loop_5_nand_14_nl <= NOT(loop_11_and_stg_1_2_sva_1 AND (NOT (loop_11_x_3_0_sva_2_0(2))));
  nor_21_nl <= NOT(and_121_tmp OR or_190_tmp);
  loop_5_loop_5_nand_16_nl <= NOT(loop_11_and_stg_1_3_sva_1 AND (NOT (loop_11_x_3_0_sva_2_0(2))));
  nor_22_nl <= NOT(and_128_tmp OR or_193_tmp);
  loop_5_loop_5_nand_22_nl <= NOT(mdst_data_nor_2_cse AND (loop_11_x_3_0_sva_2_0(2)));
  nor_23_nl <= NOT(and_135_tmp OR or_196_tmp);
  loop_5_loop_5_nand_20_nl <= NOT(loop_11_and_stg_1_1_sva_1 AND (loop_11_x_3_0_sva_2_0(2)));
  nor_24_nl <= NOT(and_142_tmp OR or_197_tmp);
  loop_5_loop_5_nand_18_nl <= NOT(loop_11_and_stg_1_2_sva_1 AND (loop_11_x_3_0_sva_2_0(2)));
  nor_25_nl <= NOT(and_149_tmp OR or_198_tmp);
  loop_5_loop_5_nand_8_nl <= NOT(loop_11_and_stg_1_3_sva_1 AND (loop_11_x_3_0_sva_2_0(2)));
  nor_26_nl <= NOT(and_156_tmp OR or_199_tmp);
  loop_out_acc_1_nl <= STD_LOGIC_VECTOR(CONV_UNSIGNED(CONV_UNSIGNED(CONV_UNSIGNED(UNSIGNED(loop_lmm_i_11_0_sva_10_0),
      11), 12) + UNSIGNED'( "000000000001"), 12));
  loop_out_i_mux_nl <= MUX_v_12_2_2(STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(loop_out_acc_1_nl),
      12)), (buf_0_lpi_5(11 DOWNTO 0)), fsm_output(26));
  loop_5_loop_5_nand_10_nl <= NOT(mdst_data_nor_2_cse AND (NOT (loop_11_x_3_0_sva_2_0(2))));
  and_246_nl <= or_tmp_28 AND (NOT or_202_tmp);
  and_167_nl <= or_dcpl_51 AND (NOT or_202_tmp);
  loop_12_y_mux_nl <= MUX_v_3_2_2(loop_12_y_3_0_sva_2_0, (loop_12_y_3_0_sva_1(2 DOWNTO
      0)), or_dcpl_51);
  or_162_nl <= (fsm_output(4)) OR (fsm_output(14)) OR (fsm_output(16)) OR (fsm_output(6));
  loop_6_mux_9_nl <= MUX_v_14_16_2(STD_LOGIC_VECTOR'( "01000000000000"), STD_LOGIC_VECTOR'(
      "00111110110001"), STD_LOGIC_VECTOR'( "00111011001000"), STD_LOGIC_VECTOR'(
      "00110101001101"), STD_LOGIC_VECTOR'( "00101101010000"), STD_LOGIC_VECTOR'(
      "00100011100011"), STD_LOGIC_VECTOR'( "00011000011111"), STD_LOGIC_VECTOR'(
      "00001100011111"), STD_LOGIC_VECTOR'( "00000000000000"), STD_LOGIC_VECTOR'(
      "11110011100000"), STD_LOGIC_VECTOR'( "11100111100000"), STD_LOGIC_VECTOR'(
      "11011100011100"), STD_LOGIC_VECTOR'( "11010010101111"), STD_LOGIC_VECTOR'(
      "11001010110010"), STD_LOGIC_VECTOR'( "11000100110111"), STD_LOGIC_VECTOR'(
      "11000001001110"), (z_out_2(2 DOWNTO 0)) & (loop_11_x_3_0_sva_2_0(0)));
  loop_3_k_mux1h_3_nl <= MUX1HOT_v_3_3_2((z_out_1(2 DOWNTO 0)), STD_LOGIC_VECTOR'(
      "001"), (loop_12_y_3_0_sva_1(2 DOWNTO 0)), STD_LOGIC_VECTOR'( or_dcpl_59 &
      loop_11_x_3_0_sva_2_0_mx0c2 & loop_11_x_3_0_sva_2_0_mx0c3));
  loop_11_x_not_nl <= NOT loop_11_x_3_0_sva_2_0_mx0c0;
  loop_6_mux1h_10_nl <= MUX1HOT_v_11_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_12_y_3_0_sva_2_0(2),
      1),11)), (loop_12_mux_9_itm(13 DOWNTO 3)), STD_LOGIC_VECTOR'( "00000010110"),
      STD_LOGIC_VECTOR'( or_184_cse & or_dcpl_51 & or_tmp_83));
  not_154_nl <= NOT or_dcpl_61;
  loop_6_and_2_nl <= MUX_v_11_2_2(STD_LOGIC_VECTOR'("00000000000"), loop_6_mux1h_10_nl,
      not_154_nl);
  loop_6_loop_6_mux_2_nl <= MUX_s_1_2_2((loop_12_y_3_0_sva_2_0(2)), (loop_12_mux_9_itm(2)),
      or_dcpl_51);
  loop_6_or_9_nl <= loop_6_loop_6_mux_2_nl OR or_tmp_83;
  loop_6_mux1h_11_nl <= MUX1HOT_v_2_3_2((loop_12_y_3_0_sva_2_0(1 DOWNTO 0)), (loop_12_mux_9_itm(1
      DOWNTO 0)), STD_LOGIC_VECTOR'( "01"), STD_LOGIC_VECTOR'( loop_6_or_1_itm &
      or_dcpl_51 & or_tmp_83));
  loop_6_mux1h_12_nl <= MUX1HOT_v_17_3_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(loop_11_x_3_0_sva_2_0(2),
      1),17)), (loop_12_asn_23_itm(19 DOWNTO 3)), (buf_0_lpi_5(19 DOWNTO 3)), STD_LOGIC_VECTOR'(
      or_184_cse & or_dcpl_51 & or_tmp_83));
  not_155_nl <= NOT or_dcpl_61;
  loop_6_and_3_nl <= MUX_v_17_2_2(STD_LOGIC_VECTOR'("00000000000000000"), loop_6_mux1h_12_nl,
      not_155_nl);
  loop_6_mux1h_13_nl <= MUX1HOT_s_1_3_2((loop_11_x_3_0_sva_2_0(2)), (loop_12_asn_23_itm(2)),
      (buf_0_lpi_5(2)), STD_LOGIC_VECTOR'( loop_6_or_1_itm & or_dcpl_51 & or_tmp_83));
  loop_6_mux1h_14_nl <= MUX1HOT_v_2_3_2((loop_11_x_3_0_sva_2_0(1 DOWNTO 0)), (loop_12_asn_23_itm(1
      DOWNTO 0)), (buf_0_lpi_5(1 DOWNTO 0)), STD_LOGIC_VECTOR'( loop_6_or_1_itm &
      or_dcpl_51 & or_tmp_83));
  z_out <= STD_LOGIC_VECTOR(CONV_UNSIGNED(SIGNED'( SIGNED(loop_6_and_2_nl & loop_6_or_9_nl
      & loop_6_mux1h_11_nl) * SIGNED(loop_6_and_3_nl & loop_6_mux1h_13_nl & loop_6_mux1h_14_nl)),
      32));
  or_203_nl <= (fsm_output(20)) OR (fsm_output(17)) OR (fsm_output(10)) OR (fsm_output(7));
  or_204_nl <= (fsm_output(22)) OR (fsm_output(12));
  loop_12_mux1h_15_nl <= MUX1HOT_v_3_3_2(loop_12_y_3_0_sva_2_0, loop_11_x_3_0_sva_2_0,
      loop_3_k_3_0_sva_2_0, STD_LOGIC_VECTOR'( or_184_cse & or_203_nl & or_204_nl));
  z_out_1 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(CONV_UNSIGNED(UNSIGNED(loop_12_mux1h_15_nl),
      4) + UNSIGNED'( "0001"), 4));
  loop_6_mux1h_15_nl <= MUX1HOT_v_5_4_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(z_out(2),
      1),5)), (STD_LOGIC_VECTOR'( "0000") & (z_out(3))), (loop_2_j_11_3_sva_7_0(7
      DOWNTO 3)), (loop_lmm_i_11_0_sva_10_0(7 DOWNTO 3)), STD_LOGIC_VECTOR'( or_184_cse
      & or_dcpl_61 & (fsm_output(23)) & (fsm_output(24))));
  loop_6_mux1h_16_nl <= MUX1HOT_s_1_3_2((z_out(2)), (loop_2_j_11_3_sva_7_0(2)), (loop_lmm_i_11_0_sva_10_0(2)),
      STD_LOGIC_VECTOR'( loop_6_or_1_itm & (fsm_output(23)) & (fsm_output(24))));
  loop_6_mux1h_17_nl <= MUX1HOT_v_2_3_2((z_out(1 DOWNTO 0)), (loop_2_j_11_3_sva_7_0(1
      DOWNTO 0)), (loop_lmm_i_11_0_sva_10_0(1 DOWNTO 0)), STD_LOGIC_VECTOR'( loop_6_or_1_itm
      & (fsm_output(23)) & (fsm_output(24))));
  loop_6_or_10_nl <= CONV_SL_1_1(fsm_output(24 DOWNTO 23)/=STD_LOGIC_VECTOR'("00"));
  loop_6_loop_6_mux_3_nl <= MUX_v_2_2_2((loop_11_x_3_0_sva_2_0(2 DOWNTO 1)), STD_LOGIC_VECTOR'(
      "01"), loop_6_or_10_nl);
  z_out_2 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(CONV_UNSIGNED(CONV_UNSIGNED(UNSIGNED(loop_6_mux1h_15_nl
      & loop_6_mux1h_16_nl & loop_6_mux1h_17_nl), 8), 9) + CONV_UNSIGNED(UNSIGNED(loop_6_loop_6_mux_3_nl),
      9), 9));
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    DCT
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_out_wait_pkg_v1.ALL;
USE work.ccs_in_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY DCT IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    dst_rsc_dat : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    dst_rsc_vld : OUT STD_LOGIC;
    dst_rsc_rdy : IN STD_LOGIC;
    src_rsc_dat : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
    src_rsc_vld : IN STD_LOGIC;
    src_rsc_rdy : OUT STD_LOGIC
  );
END DCT;

ARCHITECTURE v1 OF DCT IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL mdst_data_rsci_radr_d : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_wadr_d : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_d_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsci_we_d : STD_LOGIC;
  SIGNAL mdst_data_rsci_re_d : STD_LOGIC;
  SIGNAL mdst_data_rsci_q_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsci_radr_d : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_wadr_d : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_d_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsci_we_d : STD_LOGIC;
  SIGNAL msrc_data_rsci_re_d : STD_LOGIC;
  SIGNAL msrc_data_rsci_q_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsc_we : STD_LOGIC;
  SIGNAL mdst_data_rsc_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsc_wadr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsc_re : STD_LOGIC;
  SIGNAL mdst_data_rsc_q : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsc_radr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsc_we : STD_LOGIC;
  SIGNAL msrc_data_rsc_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsc_wadr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsc_re : STD_LOGIC;
  SIGNAL msrc_data_rsc_q : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsc_radr : STD_LOGIC_VECTOR (10 DOWNTO 0);

  SIGNAL mdst_data_rsc_comp_radr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsc_comp_wadr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsc_comp_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsc_comp_q : STD_LOGIC_VECTOR (19 DOWNTO 0);

  SIGNAL msrc_data_rsc_comp_radr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsc_comp_wadr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsc_comp_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsc_comp_q : STD_LOGIC_VECTOR (19 DOWNTO 0);

  COMPONENT DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_3_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL mdst_data_rsci_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsci_wadr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_q : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsci_radr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_radr_d_1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_wadr_d_1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL mdst_data_rsci_d_d_1 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL mdst_data_rsci_q_d_1 : STD_LOGIC_VECTOR (19 DOWNTO 0);

  COMPONENT DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_4_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL msrc_data_rsci_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsci_wadr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_q : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsci_radr : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_radr_d_1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_wadr_d_1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL msrc_data_rsci_d_d_1 : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL msrc_data_rsci_q_d_1 : STD_LOGIC_VECTOR (19 DOWNTO 0);

  COMPONENT DCT_core
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      dst_rsc_dat : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      dst_rsc_vld : OUT STD_LOGIC;
      dst_rsc_rdy : IN STD_LOGIC;
      src_rsc_dat : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      src_rsc_vld : IN STD_LOGIC;
      src_rsc_rdy : OUT STD_LOGIC;
      mdst_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      mdst_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      mdst_data_rsci_we_d : OUT STD_LOGIC;
      mdst_data_rsci_re_d : OUT STD_LOGIC;
      mdst_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_radr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_wadr_d : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
      msrc_data_rsci_d_d : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      msrc_data_rsci_we_d : OUT STD_LOGIC;
      msrc_data_rsci_re_d : OUT STD_LOGIC;
      msrc_data_rsci_q_d : IN STD_LOGIC_VECTOR (19 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL DCT_core_inst_dst_rsc_dat : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_inst_src_rsc_dat : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_inst_mdst_data_rsci_radr_d : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_inst_mdst_data_rsci_wadr_d : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_inst_mdst_data_rsci_d_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_inst_mdst_data_rsci_q_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_inst_msrc_data_rsci_radr_d : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_inst_msrc_data_rsci_wadr_d : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL DCT_core_inst_msrc_data_rsci_d_d : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL DCT_core_inst_msrc_data_rsci_q_d : STD_LOGIC_VECTOR (19 DOWNTO 0);

BEGIN
  mdst_data_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 20,
      addr_width => 11,
      depth => 2048
      )
    PORT MAP(
      radr => mdst_data_rsc_comp_radr,
      wadr => mdst_data_rsc_comp_wadr,
      d => mdst_data_rsc_comp_d,
      we => mdst_data_rsc_we,
      re => mdst_data_rsc_re,
      clk => clk,
      q => mdst_data_rsc_comp_q
    );
  mdst_data_rsc_comp_radr <= mdst_data_rsc_radr;
  mdst_data_rsc_comp_wadr <= mdst_data_rsc_wadr;
  mdst_data_rsc_comp_d <= mdst_data_rsc_d;
  mdst_data_rsc_q <= mdst_data_rsc_comp_q;

  msrc_data_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 20,
      addr_width => 11,
      depth => 2048
      )
    PORT MAP(
      radr => msrc_data_rsc_comp_radr,
      wadr => msrc_data_rsc_comp_wadr,
      d => msrc_data_rsc_comp_d,
      we => msrc_data_rsc_we,
      re => msrc_data_rsc_re,
      clk => clk,
      q => msrc_data_rsc_comp_q
    );
  msrc_data_rsc_comp_radr <= msrc_data_rsc_radr;
  msrc_data_rsc_comp_wadr <= msrc_data_rsc_wadr;
  msrc_data_rsc_comp_d <= msrc_data_rsc_d;
  msrc_data_rsc_q <= msrc_data_rsc_comp_q;

  mdst_data_rsci : DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_3_gen
    PORT MAP(
      we => mdst_data_rsc_we,
      d => mdst_data_rsci_d,
      wadr => mdst_data_rsci_wadr,
      re => mdst_data_rsc_re,
      q => mdst_data_rsci_q,
      radr => mdst_data_rsci_radr,
      radr_d => mdst_data_rsci_radr_d_1,
      wadr_d => mdst_data_rsci_wadr_d_1,
      d_d => mdst_data_rsci_d_d_1,
      we_d => mdst_data_rsci_we_d,
      re_d => mdst_data_rsci_re_d,
      q_d => mdst_data_rsci_q_d_1
    );
  mdst_data_rsc_d <= mdst_data_rsci_d;
  mdst_data_rsc_wadr <= mdst_data_rsci_wadr;
  mdst_data_rsci_q <= mdst_data_rsc_q;
  mdst_data_rsc_radr <= mdst_data_rsci_radr;
  mdst_data_rsci_radr_d_1 <= mdst_data_rsci_radr_d;
  mdst_data_rsci_wadr_d_1 <= mdst_data_rsci_wadr_d;
  mdst_data_rsci_d_d_1 <= mdst_data_rsci_d_d;
  mdst_data_rsci_q_d <= mdst_data_rsci_q_d_1;

  msrc_data_rsci : DCT_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_20_11_2048_4_gen
    PORT MAP(
      we => msrc_data_rsc_we,
      d => msrc_data_rsci_d,
      wadr => msrc_data_rsci_wadr,
      re => msrc_data_rsc_re,
      q => msrc_data_rsci_q,
      radr => msrc_data_rsci_radr,
      radr_d => msrc_data_rsci_radr_d_1,
      wadr_d => msrc_data_rsci_wadr_d_1,
      d_d => msrc_data_rsci_d_d_1,
      we_d => msrc_data_rsci_we_d,
      re_d => msrc_data_rsci_re_d,
      q_d => msrc_data_rsci_q_d_1
    );
  msrc_data_rsc_d <= msrc_data_rsci_d;
  msrc_data_rsc_wadr <= msrc_data_rsci_wadr;
  msrc_data_rsci_q <= msrc_data_rsc_q;
  msrc_data_rsc_radr <= msrc_data_rsci_radr;
  msrc_data_rsci_radr_d_1 <= msrc_data_rsci_radr_d;
  msrc_data_rsci_wadr_d_1 <= msrc_data_rsci_wadr_d;
  msrc_data_rsci_d_d_1 <= msrc_data_rsci_d_d;
  msrc_data_rsci_q_d <= msrc_data_rsci_q_d_1;

  DCT_core_inst : DCT_core
    PORT MAP(
      clk => clk,
      rst => rst,
      dst_rsc_dat => DCT_core_inst_dst_rsc_dat,
      dst_rsc_vld => dst_rsc_vld,
      dst_rsc_rdy => dst_rsc_rdy,
      src_rsc_dat => DCT_core_inst_src_rsc_dat,
      src_rsc_vld => src_rsc_vld,
      src_rsc_rdy => src_rsc_rdy,
      mdst_data_rsci_radr_d => DCT_core_inst_mdst_data_rsci_radr_d,
      mdst_data_rsci_wadr_d => DCT_core_inst_mdst_data_rsci_wadr_d,
      mdst_data_rsci_d_d => DCT_core_inst_mdst_data_rsci_d_d,
      mdst_data_rsci_we_d => mdst_data_rsci_we_d,
      mdst_data_rsci_re_d => mdst_data_rsci_re_d,
      mdst_data_rsci_q_d => DCT_core_inst_mdst_data_rsci_q_d,
      msrc_data_rsci_radr_d => DCT_core_inst_msrc_data_rsci_radr_d,
      msrc_data_rsci_wadr_d => DCT_core_inst_msrc_data_rsci_wadr_d,
      msrc_data_rsci_d_d => DCT_core_inst_msrc_data_rsci_d_d,
      msrc_data_rsci_we_d => msrc_data_rsci_we_d,
      msrc_data_rsci_re_d => msrc_data_rsci_re_d,
      msrc_data_rsci_q_d => DCT_core_inst_msrc_data_rsci_q_d
    );
  dst_rsc_dat <= DCT_core_inst_dst_rsc_dat;
  DCT_core_inst_src_rsc_dat <= src_rsc_dat;
  mdst_data_rsci_radr_d <= DCT_core_inst_mdst_data_rsci_radr_d;
  mdst_data_rsci_wadr_d <= DCT_core_inst_mdst_data_rsci_wadr_d;
  mdst_data_rsci_d_d <= DCT_core_inst_mdst_data_rsci_d_d;
  DCT_core_inst_mdst_data_rsci_q_d <= mdst_data_rsci_q_d;
  msrc_data_rsci_radr_d <= DCT_core_inst_msrc_data_rsci_radr_d;
  msrc_data_rsci_wadr_d <= DCT_core_inst_msrc_data_rsci_wadr_d;
  msrc_data_rsci_d_d <= DCT_core_inst_msrc_data_rsci_d_d;
  DCT_core_inst_msrc_data_rsci_q_d <= msrc_data_rsci_q_d;

END v1;



