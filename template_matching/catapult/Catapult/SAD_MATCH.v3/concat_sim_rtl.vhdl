
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
--  Generated date: Sat Jan  4 23:54:58 2020
-- ----------------------------------------------------------------------

-- 
-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_6_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_6_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_6_gen;

ARCHITECTURE v3 OF SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_6_gen IS
  -- Default Constants

BEGIN
  we <= (we_d);
  d <= (d_d);
  wadr <= (wadr_d);
  re <= (re_d);
  q_d <= q;
  radr <= (radr_d);
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_5_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_5_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_5_gen;

ARCHITECTURE v3 OF SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_5_gen IS
  -- Default Constants

BEGIN
  we <= (we_d);
  d <= (d_d);
  wadr <= (wadr_d);
  re <= (re_d);
  q_d <= q;
  radr <= (radr_d);
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_core_fsm
--  FSM Module
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_core_fsm IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    fsm_output : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    loop_3_C_2_tr0 : IN STD_LOGIC;
    loop_2_C_0_tr0 : IN STD_LOGIC;
    loop_4_C_2_tr0 : IN STD_LOGIC;
    loop_6_C_1_tr0 : IN STD_LOGIC;
    loop_5_C_0_tr0 : IN STD_LOGIC;
    loop_lmm_C_2_tr0 : IN STD_LOGIC;
    loop_8_C_2_tr0 : IN STD_LOGIC;
    loop_7_C_0_tr0 : IN STD_LOGIC;
    loop_lmm_C_4_tr0 : IN STD_LOGIC
  );
END SAD_MATCH_core_core_fsm;

ARCHITECTURE v3 OF SAD_MATCH_core_core_fsm IS
  -- Default Constants

  -- FSM State Type Declaration for SAD_MATCH_core_core_fsm_1
  TYPE SAD_MATCH_core_core_fsm_1_ST IS (main_C_0, loop_lmm_C_0, loop_lmm_C_1, loop_3_C_0,
      loop_3_C_1, loop_3_C_2, loop_2_C_0, loop_4_C_0, loop_4_C_1, loop_4_C_2, loop_6_C_0,
      loop_6_C_1, loop_5_C_0, loop_lmm_C_2, loop_8_C_0, loop_8_C_1, loop_8_C_2, loop_7_C_0,
      loop_lmm_C_3, loop_lmm_C_4);

  SIGNAL state_var : SAD_MATCH_core_core_fsm_1_ST;
  SIGNAL state_var_NS : SAD_MATCH_core_core_fsm_1_ST;

BEGIN
  SAD_MATCH_core_core_fsm_1 : PROCESS (loop_3_C_2_tr0, loop_2_C_0_tr0, loop_4_C_2_tr0,
      loop_6_C_1_tr0, loop_5_C_0_tr0, loop_lmm_C_2_tr0, loop_8_C_2_tr0, loop_7_C_0_tr0,
      loop_lmm_C_4_tr0, state_var)
  BEGIN
    CASE state_var IS
      WHEN loop_lmm_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000000010");
        state_var_NS <= loop_lmm_C_1;
      WHEN loop_lmm_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000000100");
        state_var_NS <= loop_3_C_0;
      WHEN loop_3_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000001000");
        state_var_NS <= loop_3_C_1;
      WHEN loop_3_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000010000");
        state_var_NS <= loop_3_C_2;
      WHEN loop_3_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000100000");
        IF ( loop_3_C_2_tr0 = '1' ) THEN
          state_var_NS <= loop_2_C_0;
        ELSE
          state_var_NS <= loop_3_C_0;
        END IF;
      WHEN loop_2_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000001000000");
        IF ( loop_2_C_0_tr0 = '1' ) THEN
          state_var_NS <= loop_4_C_0;
        ELSE
          state_var_NS <= loop_3_C_0;
        END IF;
      WHEN loop_4_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000010000000");
        state_var_NS <= loop_4_C_1;
      WHEN loop_4_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000100000000");
        state_var_NS <= loop_4_C_2;
      WHEN loop_4_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000001000000000");
        IF ( loop_4_C_2_tr0 = '1' ) THEN
          state_var_NS <= loop_6_C_0;
        ELSE
          state_var_NS <= loop_4_C_0;
        END IF;
      WHEN loop_6_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000010000000000");
        state_var_NS <= loop_6_C_1;
      WHEN loop_6_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000100000000000");
        IF ( loop_6_C_1_tr0 = '1' ) THEN
          state_var_NS <= loop_5_C_0;
        ELSE
          state_var_NS <= loop_6_C_0;
        END IF;
      WHEN loop_5_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000001000000000000");
        IF ( loop_5_C_0_tr0 = '1' ) THEN
          state_var_NS <= loop_lmm_C_2;
        ELSE
          state_var_NS <= loop_6_C_0;
        END IF;
      WHEN loop_lmm_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000010000000000000");
        IF ( loop_lmm_C_2_tr0 = '1' ) THEN
          state_var_NS <= loop_lmm_C_3;
        ELSE
          state_var_NS <= loop_8_C_0;
        END IF;
      WHEN loop_8_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000100000000000000");
        state_var_NS <= loop_8_C_1;
      WHEN loop_8_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00001000000000000000");
        state_var_NS <= loop_8_C_2;
      WHEN loop_8_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00010000000000000000");
        IF ( loop_8_C_2_tr0 = '1' ) THEN
          state_var_NS <= loop_7_C_0;
        ELSE
          state_var_NS <= loop_8_C_0;
        END IF;
      WHEN loop_7_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00100000000000000000");
        IF ( loop_7_C_0_tr0 = '1' ) THEN
          state_var_NS <= loop_lmm_C_3;
        ELSE
          state_var_NS <= loop_8_C_0;
        END IF;
      WHEN loop_lmm_C_3 =>
        fsm_output <= STD_LOGIC_VECTOR'( "01000000000000000000");
        state_var_NS <= loop_lmm_C_4;
      WHEN loop_lmm_C_4 =>
        fsm_output <= STD_LOGIC_VECTOR'( "10000000000000000000");
        IF ( loop_lmm_C_4_tr0 = '1' ) THEN
          state_var_NS <= main_C_0;
        ELSE
          state_var_NS <= loop_lmm_C_0;
        END IF;
      -- main_C_0
      WHEN OTHERS =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000000001");
        state_var_NS <= loop_lmm_C_0;
    END CASE;
  END PROCESS SAD_MATCH_core_core_fsm_1;

  SAD_MATCH_core_core_fsm_1_REG : PROCESS (clk)
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
  END PROCESS SAD_MATCH_core_core_fsm_1_REG;

END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_staller
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_staller IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    core_wen : OUT STD_LOGIC;
    core_wten : OUT STD_LOGIC;
    INPUT_rsci_wen_comp : IN STD_LOGIC;
    OUTPUT_rsci_wen_comp : IN STD_LOGIC
  );
END SAD_MATCH_core_staller;

ARCHITECTURE v3 OF SAD_MATCH_core_staller IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL core_wen_drv : STD_LOGIC;

  -- Interconnect Declarations
  SIGNAL core_wten_reg : STD_LOGIC;

BEGIN
  -- Output Reader Assignments
  core_wen <= core_wen_drv;

  core_wen_drv <= INPUT_rsci_wen_comp AND OUTPUT_rsci_wen_comp;
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
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    win_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_radr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_d_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_biwt : IN STD_LOGIC;
    win_buf_rsci_bdwt : IN STD_LOGIC;
    win_buf_rsci_radr_d_core_sct : IN STD_LOGIC;
    win_buf_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp;

ARCHITECTURE v3 OF SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL win_buf_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (7 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL win_buf_rsci_bcwt : STD_LOGIC;
  SIGNAL win_buf_rsci_q_d_bfwt : STD_LOGIC_VECTOR (7 DOWNTO 0);

  FUNCTION MUX_v_7_2_2(input_0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(6 DOWNTO 0);

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
  -- Output Reader Assignments
  win_buf_rsci_q_d_mxwt <= win_buf_rsci_q_d_mxwt_drv;

  win_buf_rsci_q_d_mxwt_drv <= MUX_v_8_2_2(win_buf_rsci_q_d, win_buf_rsci_q_d_bfwt,
      win_buf_rsci_bcwt);
  win_buf_rsci_radr_d <= MUX_v_7_2_2(STD_LOGIC_VECTOR'("0000000"), win_buf_rsci_radr_d_core,
      win_buf_rsci_radr_d_core_sct);
  win_buf_rsci_wadr_d <= MUX_v_7_2_2(STD_LOGIC_VECTOR'("0000000"), win_buf_rsci_wadr_d_core,
      win_buf_rsci_wadr_d_core_sct_pff);
  win_buf_rsci_d_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), win_buf_rsci_d_d_core,
      win_buf_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        win_buf_rsci_bcwt <= '0';
      ELSE
        win_buf_rsci_bcwt <= NOT((NOT(win_buf_rsci_bcwt OR win_buf_rsci_biwt)) OR
            win_buf_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      win_buf_rsci_q_d_bfwt <= win_buf_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    win_buf_rsci_oswt : IN STD_LOGIC;
    win_buf_rsci_biwt : OUT STD_LOGIC;
    win_buf_rsci_bdwt : OUT STD_LOGIC;
    win_buf_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    win_buf_rsci_oswt_pff : IN STD_LOGIC;
    win_buf_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    win_buf_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_ctrl;

ARCHITECTURE v3 OF SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  win_buf_rsci_bdwt <= win_buf_rsci_oswt AND core_wen;
  win_buf_rsci_biwt <= (NOT core_wten) AND win_buf_rsci_oswt;
  win_buf_rsci_radr_d_core_sct_pff <= win_buf_rsci_oswt_pff AND core_wen;
  win_buf_rsci_wadr_d_core_sct_pff <= win_buf_rsci_iswt0_1_pff AND core_wen;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    row_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    row_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    row_buf_rsci_radr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_d_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    row_buf_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    row_buf_rsci_biwt : IN STD_LOGIC;
    row_buf_rsci_bdwt : IN STD_LOGIC;
    row_buf_rsci_radr_d_core_sct : IN STD_LOGIC;
    row_buf_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp;

ARCHITECTURE v3 OF SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL row_buf_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (7 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL row_buf_rsci_bcwt : STD_LOGIC;
  SIGNAL row_buf_rsci_q_d_bfwt : STD_LOGIC_VECTOR (7 DOWNTO 0);

  FUNCTION MUX_v_7_2_2(input_0 : STD_LOGIC_VECTOR(6 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(6 DOWNTO 0);

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
  -- Output Reader Assignments
  row_buf_rsci_q_d_mxwt <= row_buf_rsci_q_d_mxwt_drv;

  row_buf_rsci_q_d_mxwt_drv <= MUX_v_8_2_2(row_buf_rsci_q_d, row_buf_rsci_q_d_bfwt,
      row_buf_rsci_bcwt);
  row_buf_rsci_radr_d <= MUX_v_7_2_2(STD_LOGIC_VECTOR'("0000000"), row_buf_rsci_radr_d_core,
      row_buf_rsci_radr_d_core_sct);
  row_buf_rsci_wadr_d <= MUX_v_7_2_2(STD_LOGIC_VECTOR'("0000000"), row_buf_rsci_wadr_d_core,
      row_buf_rsci_wadr_d_core_sct_pff);
  row_buf_rsci_d_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), row_buf_rsci_d_d_core,
      row_buf_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        row_buf_rsci_bcwt <= '0';
      ELSE
        row_buf_rsci_bcwt <= NOT((NOT(row_buf_rsci_bcwt OR row_buf_rsci_biwt)) OR
            row_buf_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      row_buf_rsci_q_d_bfwt <= row_buf_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    row_buf_rsci_oswt : IN STD_LOGIC;
    row_buf_rsci_biwt : OUT STD_LOGIC;
    row_buf_rsci_bdwt : OUT STD_LOGIC;
    row_buf_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    row_buf_rsci_oswt_pff : IN STD_LOGIC;
    row_buf_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    row_buf_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_ctrl;

ARCHITECTURE v3 OF SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  row_buf_rsci_bdwt <= row_buf_rsci_oswt AND core_wen;
  row_buf_rsci_biwt <= (NOT core_wten) AND row_buf_rsci_oswt;
  row_buf_rsci_radr_d_core_sct_pff <= row_buf_rsci_oswt_pff AND core_wen;
  row_buf_rsci_wadr_d_core_sct_pff <= row_buf_rsci_iswt0_1_pff AND core_wen;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    OUTPUT_rsci_oswt : IN STD_LOGIC;
    OUTPUT_rsci_wen_comp : OUT STD_LOGIC;
    OUTPUT_rsci_biwt : IN STD_LOGIC;
    OUTPUT_rsci_bdwt : IN STD_LOGIC;
    OUTPUT_rsci_bcwt : OUT STD_LOGIC
  );
END SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_dp;

ARCHITECTURE v3 OF SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL OUTPUT_rsci_bcwt_drv : STD_LOGIC;

BEGIN
  -- Output Reader Assignments
  OUTPUT_rsci_bcwt <= OUTPUT_rsci_bcwt_drv;

  OUTPUT_rsci_wen_comp <= (NOT OUTPUT_rsci_oswt) OR OUTPUT_rsci_biwt OR OUTPUT_rsci_bcwt_drv;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        OUTPUT_rsci_bcwt_drv <= '0';
      ELSE
        OUTPUT_rsci_bcwt_drv <= NOT((NOT(OUTPUT_rsci_bcwt_drv OR OUTPUT_rsci_biwt))
            OR OUTPUT_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    OUTPUT_rsci_oswt : IN STD_LOGIC;
    OUTPUT_rsci_irdy : IN STD_LOGIC;
    OUTPUT_rsci_biwt : OUT STD_LOGIC;
    OUTPUT_rsci_bdwt : OUT STD_LOGIC;
    OUTPUT_rsci_bcwt : IN STD_LOGIC;
    OUTPUT_rsci_ivld_core_sct : OUT STD_LOGIC
  );
END SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_ctrl;

ARCHITECTURE v3 OF SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_ctrl IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL OUTPUT_rsci_ogwt : STD_LOGIC;

BEGIN
  OUTPUT_rsci_bdwt <= OUTPUT_rsci_oswt AND core_wen;
  OUTPUT_rsci_biwt <= OUTPUT_rsci_ogwt AND OUTPUT_rsci_irdy;
  OUTPUT_rsci_ogwt <= OUTPUT_rsci_oswt AND (NOT OUTPUT_rsci_bcwt);
  OUTPUT_rsci_ivld_core_sct <= OUTPUT_rsci_ogwt;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    INPUT_rsci_oswt : IN STD_LOGIC;
    INPUT_rsci_wen_comp : OUT STD_LOGIC;
    INPUT_rsci_idat_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    INPUT_rsci_biwt : IN STD_LOGIC;
    INPUT_rsci_bdwt : IN STD_LOGIC;
    INPUT_rsci_bcwt : OUT STD_LOGIC;
    INPUT_rsci_idat : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp;

ARCHITECTURE v3 OF SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL INPUT_rsci_idat_mxwt_drv : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INPUT_rsci_bcwt_drv : STD_LOGIC;

  -- Interconnect Declarations
  SIGNAL INPUT_rsci_idat_bfwt : STD_LOGIC_VECTOR (7 DOWNTO 0);

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
  -- Output Reader Assignments
  INPUT_rsci_idat_mxwt <= INPUT_rsci_idat_mxwt_drv;
  INPUT_rsci_bcwt <= INPUT_rsci_bcwt_drv;

  INPUT_rsci_wen_comp <= (NOT INPUT_rsci_oswt) OR INPUT_rsci_biwt OR INPUT_rsci_bcwt_drv;
  INPUT_rsci_idat_mxwt_drv <= MUX_v_8_2_2(INPUT_rsci_idat, INPUT_rsci_idat_bfwt,
      INPUT_rsci_bcwt_drv);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        INPUT_rsci_bcwt_drv <= '0';
      ELSE
        INPUT_rsci_bcwt_drv <= NOT((NOT(INPUT_rsci_bcwt_drv OR INPUT_rsci_biwt))
            OR INPUT_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      INPUT_rsci_idat_bfwt <= INPUT_rsci_idat_mxwt_drv;
    END IF;
  END PROCESS;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_INPUT_rsci_INPUT_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_INPUT_rsci_INPUT_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    INPUT_rsci_oswt : IN STD_LOGIC;
    INPUT_rsci_biwt : OUT STD_LOGIC;
    INPUT_rsci_bdwt : OUT STD_LOGIC;
    INPUT_rsci_bcwt : IN STD_LOGIC;
    INPUT_rsci_irdy_core_sct : OUT STD_LOGIC;
    INPUT_rsci_ivld : IN STD_LOGIC
  );
END SAD_MATCH_core_INPUT_rsci_INPUT_wait_ctrl;

ARCHITECTURE v3 OF SAD_MATCH_core_INPUT_rsci_INPUT_wait_ctrl IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL INPUT_rsci_ogwt : STD_LOGIC;

BEGIN
  INPUT_rsci_bdwt <= INPUT_rsci_oswt AND core_wen;
  INPUT_rsci_biwt <= INPUT_rsci_ogwt AND INPUT_rsci_ivld;
  INPUT_rsci_ogwt <= INPUT_rsci_oswt AND (NOT INPUT_rsci_bcwt);
  INPUT_rsci_irdy_core_sct <= INPUT_rsci_ogwt;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_win_buf_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_win_buf_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    win_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_we_d : OUT STD_LOGIC;
    win_buf_rsci_re_d : OUT STD_LOGIC;
    win_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    win_buf_rsci_oswt : IN STD_LOGIC;
    win_buf_rsci_radr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_d_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_oswt_pff : IN STD_LOGIC;
    win_buf_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END SAD_MATCH_core_win_buf_rsci_1;

ARCHITECTURE v3 OF SAD_MATCH_core_win_buf_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL win_buf_rsci_biwt : STD_LOGIC;
  SIGNAL win_buf_rsci_bdwt : STD_LOGIC;
  SIGNAL win_buf_rsci_radr_d_reg : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL win_buf_rsci_wadr_d_reg : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL win_buf_rsci_d_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);

  COMPONENT SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      win_buf_rsci_oswt : IN STD_LOGIC;
      win_buf_rsci_biwt : OUT STD_LOGIC;
      win_buf_rsci_bdwt : OUT STD_LOGIC;
      win_buf_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      win_buf_rsci_oswt_pff : IN STD_LOGIC;
      win_buf_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      win_buf_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      win_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_radr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_d_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_biwt : IN STD_LOGIC;
      win_buf_rsci_bdwt : IN STD_LOGIC;
      win_buf_rsci_radr_d_core_sct : IN STD_LOGIC;
      win_buf_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_radr_d
      : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_wadr_d
      : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_d_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_q_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_radr_d_core
      : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_d_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
  SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_ctrl_inst : SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      win_buf_rsci_oswt => win_buf_rsci_oswt,
      win_buf_rsci_biwt => win_buf_rsci_biwt,
      win_buf_rsci_bdwt => win_buf_rsci_bdwt,
      win_buf_rsci_radr_d_core_sct_pff => win_buf_rsci_radr_d_core_sct_iff,
      win_buf_rsci_oswt_pff => win_buf_rsci_oswt_pff,
      win_buf_rsci_wadr_d_core_sct_pff => win_buf_rsci_wadr_d_core_sct_iff,
      win_buf_rsci_iswt0_1_pff => win_buf_rsci_iswt0_1_pff
    );
  SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst : SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      win_buf_rsci_radr_d => SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_radr_d,
      win_buf_rsci_wadr_d => SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_wadr_d,
      win_buf_rsci_d_d => SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_d_d,
      win_buf_rsci_q_d => SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_q_d,
      win_buf_rsci_radr_d_core => SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_radr_d_core,
      win_buf_rsci_wadr_d_core => SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_wadr_d_core,
      win_buf_rsci_d_d_core => SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_d_d_core,
      win_buf_rsci_q_d_mxwt => SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_q_d_mxwt,
      win_buf_rsci_biwt => win_buf_rsci_biwt,
      win_buf_rsci_bdwt => win_buf_rsci_bdwt,
      win_buf_rsci_radr_d_core_sct => win_buf_rsci_radr_d_core_sct_iff,
      win_buf_rsci_wadr_d_core_sct_pff => win_buf_rsci_wadr_d_core_sct_iff
    );
  win_buf_rsci_radr_d_reg <= SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_radr_d;
  win_buf_rsci_wadr_d_reg <= SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_wadr_d;
  win_buf_rsci_d_d_reg <= SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_d_d;
  SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_q_d <= win_buf_rsci_q_d;
  SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_radr_d_core
      <= win_buf_rsci_radr_d_core;
  SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_wadr_d_core
      <= win_buf_rsci_wadr_d_core;
  SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_d_d_core <=
      win_buf_rsci_d_d_core;
  win_buf_rsci_q_d_mxwt <= SAD_MATCH_core_win_buf_rsci_1_win_buf_rsc_wait_dp_inst_win_buf_rsci_q_d_mxwt;

  win_buf_rsci_radr_d <= win_buf_rsci_radr_d_reg;
  win_buf_rsci_wadr_d <= win_buf_rsci_wadr_d_reg;
  win_buf_rsci_d_d <= win_buf_rsci_d_d_reg;
  win_buf_rsci_we_d <= win_buf_rsci_wadr_d_core_sct_iff;
  win_buf_rsci_re_d <= win_buf_rsci_radr_d_core_sct_iff;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_row_buf_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_row_buf_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    row_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    row_buf_rsci_we_d : OUT STD_LOGIC;
    row_buf_rsci_re_d : OUT STD_LOGIC;
    row_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    row_buf_rsci_oswt : IN STD_LOGIC;
    row_buf_rsci_radr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_d_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    row_buf_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    row_buf_rsci_oswt_pff : IN STD_LOGIC;
    row_buf_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END SAD_MATCH_core_row_buf_rsci_1;

ARCHITECTURE v3 OF SAD_MATCH_core_row_buf_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL row_buf_rsci_biwt : STD_LOGIC;
  SIGNAL row_buf_rsci_bdwt : STD_LOGIC;
  SIGNAL row_buf_rsci_radr_d_reg : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL row_buf_rsci_wadr_d_reg : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL row_buf_rsci_d_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);

  COMPONENT SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      row_buf_rsci_oswt : IN STD_LOGIC;
      row_buf_rsci_biwt : OUT STD_LOGIC;
      row_buf_rsci_bdwt : OUT STD_LOGIC;
      row_buf_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      row_buf_rsci_oswt_pff : IN STD_LOGIC;
      row_buf_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      row_buf_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      row_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      row_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      row_buf_rsci_radr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_d_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      row_buf_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      row_buf_rsci_biwt : IN STD_LOGIC;
      row_buf_rsci_bdwt : IN STD_LOGIC;
      row_buf_rsci_radr_d_core_sct : IN STD_LOGIC;
      row_buf_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_radr_d
      : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_wadr_d
      : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_d_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_q_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_radr_d_core
      : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_d_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
  SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_ctrl_inst : SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      row_buf_rsci_oswt => row_buf_rsci_oswt,
      row_buf_rsci_biwt => row_buf_rsci_biwt,
      row_buf_rsci_bdwt => row_buf_rsci_bdwt,
      row_buf_rsci_radr_d_core_sct_pff => row_buf_rsci_radr_d_core_sct_iff,
      row_buf_rsci_oswt_pff => row_buf_rsci_oswt_pff,
      row_buf_rsci_wadr_d_core_sct_pff => row_buf_rsci_wadr_d_core_sct_iff,
      row_buf_rsci_iswt0_1_pff => row_buf_rsci_iswt0_1_pff
    );
  SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst : SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      row_buf_rsci_radr_d => SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_radr_d,
      row_buf_rsci_wadr_d => SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_wadr_d,
      row_buf_rsci_d_d => SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_d_d,
      row_buf_rsci_q_d => SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_q_d,
      row_buf_rsci_radr_d_core => SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_radr_d_core,
      row_buf_rsci_wadr_d_core => SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_wadr_d_core,
      row_buf_rsci_d_d_core => SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_d_d_core,
      row_buf_rsci_q_d_mxwt => SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_q_d_mxwt,
      row_buf_rsci_biwt => row_buf_rsci_biwt,
      row_buf_rsci_bdwt => row_buf_rsci_bdwt,
      row_buf_rsci_radr_d_core_sct => row_buf_rsci_radr_d_core_sct_iff,
      row_buf_rsci_wadr_d_core_sct_pff => row_buf_rsci_wadr_d_core_sct_iff
    );
  row_buf_rsci_radr_d_reg <= SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_radr_d;
  row_buf_rsci_wadr_d_reg <= SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_wadr_d;
  row_buf_rsci_d_d_reg <= SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_d_d;
  SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_q_d <= row_buf_rsci_q_d;
  SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_radr_d_core
      <= row_buf_rsci_radr_d_core;
  SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_wadr_d_core
      <= row_buf_rsci_wadr_d_core;
  SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_d_d_core <=
      row_buf_rsci_d_d_core;
  row_buf_rsci_q_d_mxwt <= SAD_MATCH_core_row_buf_rsci_1_row_buf_rsc_wait_dp_inst_row_buf_rsci_q_d_mxwt;

  row_buf_rsci_radr_d <= row_buf_rsci_radr_d_reg;
  row_buf_rsci_wadr_d <= row_buf_rsci_wadr_d_reg;
  row_buf_rsci_d_d <= row_buf_rsci_d_d_reg;
  row_buf_rsci_we_d <= row_buf_rsci_wadr_d_core_sct_iff;
  row_buf_rsci_re_d <= row_buf_rsci_radr_d_core_sct_iff;
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_OUTPUT_rsci
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_OUTPUT_rsci IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    OUTPUT_rsc_dat : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    OUTPUT_rsc_vld : OUT STD_LOGIC;
    OUTPUT_rsc_rdy : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    OUTPUT_rsci_oswt : IN STD_LOGIC;
    OUTPUT_rsci_wen_comp : OUT STD_LOGIC;
    OUTPUT_rsci_idat : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END SAD_MATCH_core_OUTPUT_rsci;

ARCHITECTURE v3 OF SAD_MATCH_core_OUTPUT_rsci IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL OUTPUT_rsci_irdy : STD_LOGIC;
  SIGNAL OUTPUT_rsci_biwt : STD_LOGIC;
  SIGNAL OUTPUT_rsci_bdwt : STD_LOGIC;
  SIGNAL OUTPUT_rsci_bcwt : STD_LOGIC;
  SIGNAL OUTPUT_rsci_ivld_core_sct : STD_LOGIC;

  SIGNAL OUTPUT_rsci_idat_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL OUTPUT_rsci_dat : STD_LOGIC_VECTOR (7 DOWNTO 0);

  COMPONENT SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      OUTPUT_rsci_oswt : IN STD_LOGIC;
      OUTPUT_rsci_irdy : IN STD_LOGIC;
      OUTPUT_rsci_biwt : OUT STD_LOGIC;
      OUTPUT_rsci_bdwt : OUT STD_LOGIC;
      OUTPUT_rsci_bcwt : IN STD_LOGIC;
      OUTPUT_rsci_ivld_core_sct : OUT STD_LOGIC
    );
  END COMPONENT;
  COMPONENT SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      OUTPUT_rsci_oswt : IN STD_LOGIC;
      OUTPUT_rsci_wen_comp : OUT STD_LOGIC;
      OUTPUT_rsci_biwt : IN STD_LOGIC;
      OUTPUT_rsci_bdwt : IN STD_LOGIC;
      OUTPUT_rsci_bcwt : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN
  OUTPUT_rsci : work.ccs_out_wait_pkg_v1.ccs_out_wait_v1
    GENERIC MAP(
      rscid => 2,
      width => 8
      )
    PORT MAP(
      irdy => OUTPUT_rsci_irdy,
      ivld => OUTPUT_rsci_ivld_core_sct,
      idat => OUTPUT_rsci_idat_1,
      rdy => OUTPUT_rsc_rdy,
      vld => OUTPUT_rsc_vld,
      dat => OUTPUT_rsci_dat
    );
  OUTPUT_rsci_idat_1 <= STD_LOGIC_VECTOR'( "0000000") & (OUTPUT_rsci_idat(0));
  OUTPUT_rsc_dat <= OUTPUT_rsci_dat;

  SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_ctrl_inst : SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      OUTPUT_rsci_oswt => OUTPUT_rsci_oswt,
      OUTPUT_rsci_irdy => OUTPUT_rsci_irdy,
      OUTPUT_rsci_biwt => OUTPUT_rsci_biwt,
      OUTPUT_rsci_bdwt => OUTPUT_rsci_bdwt,
      OUTPUT_rsci_bcwt => OUTPUT_rsci_bcwt,
      OUTPUT_rsci_ivld_core_sct => OUTPUT_rsci_ivld_core_sct
    );
  SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_dp_inst : SAD_MATCH_core_OUTPUT_rsci_OUTPUT_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      OUTPUT_rsci_oswt => OUTPUT_rsci_oswt,
      OUTPUT_rsci_wen_comp => OUTPUT_rsci_wen_comp,
      OUTPUT_rsci_biwt => OUTPUT_rsci_biwt,
      OUTPUT_rsci_bdwt => OUTPUT_rsci_bdwt,
      OUTPUT_rsci_bcwt => OUTPUT_rsci_bcwt
    );
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core_INPUT_rsci
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core_INPUT_rsci IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    INPUT_rsc_dat : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    INPUT_rsc_vld : IN STD_LOGIC;
    INPUT_rsc_rdy : OUT STD_LOGIC;
    core_wen : IN STD_LOGIC;
    INPUT_rsci_oswt : IN STD_LOGIC;
    INPUT_rsci_wen_comp : OUT STD_LOGIC;
    INPUT_rsci_idat_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END SAD_MATCH_core_INPUT_rsci;

ARCHITECTURE v3 OF SAD_MATCH_core_INPUT_rsci IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL INPUT_rsci_biwt : STD_LOGIC;
  SIGNAL INPUT_rsci_bdwt : STD_LOGIC;
  SIGNAL INPUT_rsci_bcwt : STD_LOGIC;
  SIGNAL INPUT_rsci_irdy_core_sct : STD_LOGIC;
  SIGNAL INPUT_rsci_ivld : STD_LOGIC;
  SIGNAL INPUT_rsci_idat : STD_LOGIC_VECTOR (7 DOWNTO 0);

  SIGNAL INPUT_rsci_dat : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INPUT_rsci_idat_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);

  COMPONENT SAD_MATCH_core_INPUT_rsci_INPUT_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      INPUT_rsci_oswt : IN STD_LOGIC;
      INPUT_rsci_biwt : OUT STD_LOGIC;
      INPUT_rsci_bdwt : OUT STD_LOGIC;
      INPUT_rsci_bcwt : IN STD_LOGIC;
      INPUT_rsci_irdy_core_sct : OUT STD_LOGIC;
      INPUT_rsci_ivld : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      INPUT_rsci_oswt : IN STD_LOGIC;
      INPUT_rsci_wen_comp : OUT STD_LOGIC;
      INPUT_rsci_idat_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      INPUT_rsci_biwt : IN STD_LOGIC;
      INPUT_rsci_bdwt : IN STD_LOGIC;
      INPUT_rsci_bcwt : OUT STD_LOGIC;
      INPUT_rsci_idat : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp_inst_INPUT_rsci_idat_mxwt : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp_inst_INPUT_rsci_idat : STD_LOGIC_VECTOR
      (7 DOWNTO 0);

BEGIN
  INPUT_rsci : work.ccs_in_wait_pkg_v1.ccs_in_wait_v1
    GENERIC MAP(
      rscid => 1,
      width => 8
      )
    PORT MAP(
      rdy => INPUT_rsc_rdy,
      vld => INPUT_rsc_vld,
      dat => INPUT_rsci_dat,
      irdy => INPUT_rsci_irdy_core_sct,
      ivld => INPUT_rsci_ivld,
      idat => INPUT_rsci_idat_1
    );
  INPUT_rsci_dat <= INPUT_rsc_dat;
  INPUT_rsci_idat <= INPUT_rsci_idat_1;

  SAD_MATCH_core_INPUT_rsci_INPUT_wait_ctrl_inst : SAD_MATCH_core_INPUT_rsci_INPUT_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      INPUT_rsci_oswt => INPUT_rsci_oswt,
      INPUT_rsci_biwt => INPUT_rsci_biwt,
      INPUT_rsci_bdwt => INPUT_rsci_bdwt,
      INPUT_rsci_bcwt => INPUT_rsci_bcwt,
      INPUT_rsci_irdy_core_sct => INPUT_rsci_irdy_core_sct,
      INPUT_rsci_ivld => INPUT_rsci_ivld
    );
  SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp_inst : SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      INPUT_rsci_oswt => INPUT_rsci_oswt,
      INPUT_rsci_wen_comp => INPUT_rsci_wen_comp,
      INPUT_rsci_idat_mxwt => SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp_inst_INPUT_rsci_idat_mxwt,
      INPUT_rsci_biwt => INPUT_rsci_biwt,
      INPUT_rsci_bdwt => INPUT_rsci_bdwt,
      INPUT_rsci_bcwt => INPUT_rsci_bcwt,
      INPUT_rsci_idat => SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp_inst_INPUT_rsci_idat
    );
  INPUT_rsci_idat_mxwt <= SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp_inst_INPUT_rsci_idat_mxwt;
  SAD_MATCH_core_INPUT_rsci_INPUT_wait_dp_inst_INPUT_rsci_idat <= INPUT_rsci_idat;

END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH_core
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH_core IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    INPUT_rsc_dat : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    INPUT_rsc_vld : IN STD_LOGIC;
    INPUT_rsc_rdy : OUT STD_LOGIC;
    OUTPUT_rsc_dat : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    OUTPUT_rsc_vld : OUT STD_LOGIC;
    OUTPUT_rsc_rdy : IN STD_LOGIC;
    row_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    row_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    row_buf_rsci_we_d : OUT STD_LOGIC;
    row_buf_rsci_re_d : OUT STD_LOGIC;
    row_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
    win_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    win_buf_rsci_we_d : OUT STD_LOGIC;
    win_buf_rsci_re_d : OUT STD_LOGIC;
    win_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END SAD_MATCH_core;

ARCHITECTURE v3 OF SAD_MATCH_core IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL core_wen : STD_LOGIC;
  SIGNAL core_wten : STD_LOGIC;
  SIGNAL INPUT_rsci_wen_comp : STD_LOGIC;
  SIGNAL INPUT_rsci_idat_mxwt : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL OUTPUT_rsci_wen_comp : STD_LOGIC;
  SIGNAL row_buf_rsci_q_d_mxwt : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsci_q_d_mxwt : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL OUTPUT_rsci_idat_0 : STD_LOGIC;
  SIGNAL fsm_output : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL and_dcpl_49 : STD_LOGIC;
  SIGNAL or_dcpl_81 : STD_LOGIC;
  SIGNAL or_dcpl_83 : STD_LOGIC;
  SIGNAL or_dcpl_85 : STD_LOGIC;
  SIGNAL or_tmp_46 : STD_LOGIC;
  SIGNAL loop_lmm_loop_lmm_nor_itm : STD_LOGIC;
  SIGNAL k_sva_3 : STD_LOGIC;
  SIGNAL loop_3_slc_loop_3_acc_3_itm : STD_LOGIC;
  SIGNAL k_sva_1_mx1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL k_sva_1_mx2_3 : STD_LOGIC;
  SIGNAL reg_INPUT_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_OUTPUT_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_row_buf_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_win_buf_rsci_oswt_cse : STD_LOGIC;
  SIGNAL row_buf_rsci_radr_d_reg : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL or_141_rmff : STD_LOGIC;
  SIGNAL row_buf_rsci_wadr_d_reg : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_d_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsci_we_d_reg : STD_LOGIC;
  SIGNAL row_buf_rsci_re_d_reg : STD_LOGIC;
  SIGNAL win_buf_rsci_radr_d_reg : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_wadr_d_reg : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_d_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsci_we_d_reg : STD_LOGIC;
  SIGNAL win_buf_rsci_re_d_reg : STD_LOGIC;
  SIGNAL j_3_0_sva : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL k_sva_7_6 : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL k_sva_5_4 : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL loop_8_acc_10_itm : STD_LOGIC_VECTOR (5 DOWNTO 0);
  SIGNAL k_sva_31_8 : STD_LOGIC_VECTOR (23 DOWNTO 0);
  SIGNAL loop_1_z_3_0_sva : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL loop_3_acc_14_psp : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL loop_3_acc_12_sdt_3_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL loop_3_acc_11_sdt_3_0_1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL z_out : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL or_tmp_86 : STD_LOGIC;
  SIGNAL z_out_3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_tmp_89 : STD_LOGIC;
  SIGNAL z_out_4 : STD_LOGIC_VECTOR (32 DOWNTO 0);
  SIGNAL z_out_6 : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL z_out_7 : STD_LOGIC_VECTOR (5 DOWNTO 0);
  SIGNAL loop_lmm_i_15_0_sva : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL i_15_0_sva : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL loop_op_i_15_0_sva : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL loop_1_sad_lpi_4 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL k_sva_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL o_7_0_sva_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL i_15_0_sva_2 : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL j_3_0_sva_mx0c1 : STD_LOGIC;
  SIGNAL j_3_0_sva_mx0c2 : STD_LOGIC;
  SIGNAL loop_1_loop_1_nand_seb_1 : STD_LOGIC;
  SIGNAL loop_1_or_3_ssc : STD_LOGIC;
  SIGNAL loop_8_or_ssc : STD_LOGIC;
  SIGNAL and_cse : STD_LOGIC;
  SIGNAL loop_1_loop_1_and_2_cse : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL or_218_ssc : STD_LOGIC;
  SIGNAL z_out_1_3 : STD_LOGIC;
  SIGNAL z_out_2_3_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL z_out_5_31_0 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL loop_op_i_not_nl : STD_LOGIC;
  SIGNAL not_111_nl : STD_LOGIC;
  SIGNAL k_mux_5_nl : STD_LOGIC_VECTOR (23 DOWNTO 0);
  SIGNAL loop_8_loop_8_and_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL loop_8_mux_1_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_211_nl : STD_LOGIC;
  SIGNAL k_not_nl : STD_LOGIC;
  SIGNAL k_mux_4_nl : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL nor_29_nl : STD_LOGIC;
  SIGNAL nor_37_nl : STD_LOGIC;
  SIGNAL k_mux1h_10_nl : STD_LOGIC;
  SIGNAL loop_1_loop_1_and_nl : STD_LOGIC;
  SIGNAL and_146_nl : STD_LOGIC;
  SIGNAL k_k_and_nl : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL k_mux_3_nl : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL nor_32_nl : STD_LOGIC;
  SIGNAL nor_31_nl : STD_LOGIC;
  SIGNAL loop_1_z_mux_nl : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL j_not_nl : STD_LOGIC;
  SIGNAL n_mux1h_nl : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL or_163_nl : STD_LOGIC;
  SIGNAL nor_nl : STD_LOGIC;
  SIGNAL loop_lmm_acc_nl : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL loop_op_acc_nl : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL loop_3_mux_5_nl : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL loop_3_or_4_nl : STD_LOGIC;
  SIGNAL loop_3_loop_3_mux_1_nl : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL loop_3_mux_6_nl : STD_LOGIC;
  SIGNAL loop_3_mux_7_nl : STD_LOGIC;
  SIGNAL loop_3_mux_8_nl : STD_LOGIC;
  SIGNAL acc_2_nl : STD_LOGIC_VECTOR (4 DOWNTO 0);
  SIGNAL loop_4_mux_1_nl : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL loop_4_or_1_nl : STD_LOGIC;
  SIGNAL loop_4_mux1h_1_nl : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL loop_8_mux_7_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL loop_8_mux_8_nl : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL loop_1_mux1h_4_nl : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL loop_1_or_4_nl : STD_LOGIC;
  SIGNAL loop_1_or_5_nl : STD_LOGIC;
  SIGNAL loop_1_or_6_nl : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL loop_1_loop_1_or_1_nl : STD_LOGIC;
  SIGNAL loop_1_mux1h_5_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL loop_8_mux1h_4_nl : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL loop_8_loop_8_or_3_nl : STD_LOGIC;
  SIGNAL loop_8_loop_8_or_4_nl : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL loop_8_not_4_nl : STD_LOGIC;
  SIGNAL loop_8_loop_8_or_5_nl : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL loop_8_not_5_nl : STD_LOGIC;
  SIGNAL loop_lmm_mux_3_nl : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL loop_8_mux_9_nl : STD_LOGIC_VECTOR (5 DOWNTO 0);
  COMPONENT SAD_MATCH_core_INPUT_rsci
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      INPUT_rsc_dat : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      INPUT_rsc_vld : IN STD_LOGIC;
      INPUT_rsc_rdy : OUT STD_LOGIC;
      core_wen : IN STD_LOGIC;
      INPUT_rsci_oswt : IN STD_LOGIC;
      INPUT_rsci_wen_comp : OUT STD_LOGIC;
      INPUT_rsci_idat_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_INPUT_rsci_inst_INPUT_rsc_dat : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL SAD_MATCH_core_INPUT_rsci_inst_INPUT_rsci_idat_mxwt : STD_LOGIC_VECTOR (7
      DOWNTO 0);

  COMPONENT SAD_MATCH_core_OUTPUT_rsci
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      OUTPUT_rsc_dat : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      OUTPUT_rsc_vld : OUT STD_LOGIC;
      OUTPUT_rsc_rdy : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      OUTPUT_rsci_oswt : IN STD_LOGIC;
      OUTPUT_rsci_wen_comp : OUT STD_LOGIC;
      OUTPUT_rsci_idat : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_OUTPUT_rsci_inst_OUTPUT_rsc_dat : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL SAD_MATCH_core_OUTPUT_rsci_inst_OUTPUT_rsci_idat : STD_LOGIC_VECTOR (7 DOWNTO
      0);

  COMPONENT SAD_MATCH_core_row_buf_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      row_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      row_buf_rsci_we_d : OUT STD_LOGIC;
      row_buf_rsci_re_d : OUT STD_LOGIC;
      row_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      row_buf_rsci_oswt : IN STD_LOGIC;
      row_buf_rsci_radr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_d_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      row_buf_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      row_buf_rsci_oswt_pff : IN STD_LOGIC;
      row_buf_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_radr_d : STD_LOGIC_VECTOR
      (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_wadr_d : STD_LOGIC_VECTOR
      (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_d_d : STD_LOGIC_VECTOR (7
      DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_q_d : STD_LOGIC_VECTOR (7
      DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_radr_d_core : STD_LOGIC_VECTOR
      (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_d_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT SAD_MATCH_core_win_buf_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      win_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_we_d : OUT STD_LOGIC;
      win_buf_rsci_re_d : OUT STD_LOGIC;
      win_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      win_buf_rsci_oswt : IN STD_LOGIC;
      win_buf_rsci_radr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_d_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_oswt_pff : IN STD_LOGIC;
      win_buf_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_radr_d : STD_LOGIC_VECTOR
      (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_wadr_d : STD_LOGIC_VECTOR
      (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_d_d : STD_LOGIC_VECTOR (7
      DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_q_d : STD_LOGIC_VECTOR (7
      DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_radr_d_core : STD_LOGIC_VECTOR
      (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_d_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT SAD_MATCH_core_staller
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      core_wen : OUT STD_LOGIC;
      core_wten : OUT STD_LOGIC;
      INPUT_rsci_wen_comp : IN STD_LOGIC;
      OUTPUT_rsci_wen_comp : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT SAD_MATCH_core_core_fsm
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      fsm_output : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      loop_3_C_2_tr0 : IN STD_LOGIC;
      loop_2_C_0_tr0 : IN STD_LOGIC;
      loop_4_C_2_tr0 : IN STD_LOGIC;
      loop_6_C_1_tr0 : IN STD_LOGIC;
      loop_5_C_0_tr0 : IN STD_LOGIC;
      loop_lmm_C_2_tr0 : IN STD_LOGIC;
      loop_8_C_2_tr0 : IN STD_LOGIC;
      loop_7_C_0_tr0 : IN STD_LOGIC;
      loop_lmm_C_4_tr0 : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_core_fsm_inst_fsm_output : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL SAD_MATCH_core_core_fsm_inst_loop_3_C_2_tr0 : STD_LOGIC;
  SIGNAL SAD_MATCH_core_core_fsm_inst_loop_2_C_0_tr0 : STD_LOGIC;
  SIGNAL SAD_MATCH_core_core_fsm_inst_loop_4_C_2_tr0 : STD_LOGIC;
  SIGNAL SAD_MATCH_core_core_fsm_inst_loop_6_C_1_tr0 : STD_LOGIC;
  SIGNAL SAD_MATCH_core_core_fsm_inst_loop_5_C_0_tr0 : STD_LOGIC;
  SIGNAL SAD_MATCH_core_core_fsm_inst_loop_lmm_C_2_tr0 : STD_LOGIC;
  SIGNAL SAD_MATCH_core_core_fsm_inst_loop_8_C_2_tr0 : STD_LOGIC;
  SIGNAL SAD_MATCH_core_core_fsm_inst_loop_7_C_0_tr0 : STD_LOGIC;

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

  FUNCTION MUX1HOT_v_32_4_2(input_3 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(3 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(31 DOWNTO 0);

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

  FUNCTION MUX1HOT_v_4_3_2(input_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(2 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(3 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(3 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_8_3_2(input_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(2 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(7 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(7 DOWNTO 0);

    BEGIN
      tmp := (OTHERS=>sel(0));
      result := input_0 and tmp;
      tmp := (OTHERS=>sel( 1));
      result := result or ( input_1 and tmp);
      tmp := (OTHERS=>sel( 2));
      result := result or ( input_2 and tmp);
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

  FUNCTION MUX_v_16_2_2(input_0 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(15 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_24_2_2(input_0 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(23 DOWNTO 0);

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

  FUNCTION MUX_v_32_2_2(input_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(31 DOWNTO 0);

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

  FUNCTION MUX_v_4_2_2(input_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(3 DOWNTO 0);

    BEGIN
      CASE sel IS
        WHEN '0' =>
          result := input_0;
        WHEN others =>
          result := input_1;
      END CASE;
    RETURN result;
  END;

  FUNCTION MUX_v_6_2_2(input_0 : STD_LOGIC_VECTOR(5 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(5 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(5 DOWNTO 0);

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

  FUNCTION MUX_v_9_2_2(input_0 : STD_LOGIC_VECTOR(8 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(8 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(8 DOWNTO 0);

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
  SAD_MATCH_core_INPUT_rsci_inst : SAD_MATCH_core_INPUT_rsci
    PORT MAP(
      clk => clk,
      rst => rst,
      INPUT_rsc_dat => SAD_MATCH_core_INPUT_rsci_inst_INPUT_rsc_dat,
      INPUT_rsc_vld => INPUT_rsc_vld,
      INPUT_rsc_rdy => INPUT_rsc_rdy,
      core_wen => core_wen,
      INPUT_rsci_oswt => reg_INPUT_rsci_oswt_cse,
      INPUT_rsci_wen_comp => INPUT_rsci_wen_comp,
      INPUT_rsci_idat_mxwt => SAD_MATCH_core_INPUT_rsci_inst_INPUT_rsci_idat_mxwt
    );
  SAD_MATCH_core_INPUT_rsci_inst_INPUT_rsc_dat <= INPUT_rsc_dat;
  INPUT_rsci_idat_mxwt <= SAD_MATCH_core_INPUT_rsci_inst_INPUT_rsci_idat_mxwt;

  SAD_MATCH_core_OUTPUT_rsci_inst : SAD_MATCH_core_OUTPUT_rsci
    PORT MAP(
      clk => clk,
      rst => rst,
      OUTPUT_rsc_dat => SAD_MATCH_core_OUTPUT_rsci_inst_OUTPUT_rsc_dat,
      OUTPUT_rsc_vld => OUTPUT_rsc_vld,
      OUTPUT_rsc_rdy => OUTPUT_rsc_rdy,
      core_wen => core_wen,
      OUTPUT_rsci_oswt => reg_OUTPUT_rsci_oswt_cse,
      OUTPUT_rsci_wen_comp => OUTPUT_rsci_wen_comp,
      OUTPUT_rsci_idat => SAD_MATCH_core_OUTPUT_rsci_inst_OUTPUT_rsci_idat
    );
  OUTPUT_rsc_dat <= SAD_MATCH_core_OUTPUT_rsci_inst_OUTPUT_rsc_dat;
  SAD_MATCH_core_OUTPUT_rsci_inst_OUTPUT_rsci_idat <= STD_LOGIC_VECTOR(UNSIGNED'(
      "0000000") & CONV_UNSIGNED(OUTPUT_rsci_idat_0, 1));

  SAD_MATCH_core_row_buf_rsci_1_inst : SAD_MATCH_core_row_buf_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      row_buf_rsci_radr_d => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_radr_d,
      row_buf_rsci_wadr_d => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_wadr_d,
      row_buf_rsci_d_d => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_d_d,
      row_buf_rsci_we_d => row_buf_rsci_we_d_reg,
      row_buf_rsci_re_d => row_buf_rsci_re_d_reg,
      row_buf_rsci_q_d => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      row_buf_rsci_oswt => reg_row_buf_rsci_oswt_cse,
      row_buf_rsci_radr_d_core => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_radr_d_core,
      row_buf_rsci_wadr_d_core => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_wadr_d_core,
      row_buf_rsci_d_d_core => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_d_d_core,
      row_buf_rsci_q_d_mxwt => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_q_d_mxwt,
      row_buf_rsci_oswt_pff => or_141_rmff,
      row_buf_rsci_iswt0_1_pff => SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_iswt0_1_pff
    );
  row_buf_rsci_radr_d_reg <= SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_radr_d;
  row_buf_rsci_wadr_d_reg <= SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_wadr_d;
  row_buf_rsci_d_d_reg <= SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_d_d;
  SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_q_d <= row_buf_rsci_q_d;
  SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_radr_d_core <= (MUX_v_6_2_2(z_out_7,
      STD_LOGIC_VECTOR(CONV_UNSIGNED(CONV_UNSIGNED(UNSIGNED(j_3_0_sva & STD_LOGIC_VECTOR'(
      "01")) + CONV_UNSIGNED(CONV_UNSIGNED(UNSIGNED((z_out_4(1 DOWNTO 0)) & (j_3_0_sva(1
      DOWNTO 0))), 4), 6), 6) + UNSIGNED(k_sva_31_8(6 DOWNTO 1)), 6)), fsm_output(14)))
      & (MUX_s_1_2_2((loop_8_acc_10_itm(0)), (k_sva_31_8(0)), fsm_output(14)));
  SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_wadr_d_core <= (MUX_v_6_2_2((z_out_4(5
      DOWNTO 0)), loop_8_acc_10_itm, fsm_output(15))) & (MUX_s_1_2_2((loop_8_acc_10_itm(0)),
      (k_sva_31_8(0)), fsm_output(15)));
  SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_d_d_core <= MUX_v_8_2_2(INPUT_rsci_idat_mxwt,
      row_buf_rsci_q_d_mxwt, fsm_output(15));
  row_buf_rsci_q_d_mxwt <= SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_q_d_mxwt;
  SAD_MATCH_core_row_buf_rsci_1_inst_row_buf_rsci_iswt0_1_pff <= (fsm_output(1))
      OR (fsm_output(15));

  SAD_MATCH_core_win_buf_rsci_1_inst : SAD_MATCH_core_win_buf_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      win_buf_rsci_radr_d => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_radr_d,
      win_buf_rsci_wadr_d => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_wadr_d,
      win_buf_rsci_d_d => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_d_d,
      win_buf_rsci_we_d => win_buf_rsci_we_d_reg,
      win_buf_rsci_re_d => win_buf_rsci_re_d_reg,
      win_buf_rsci_q_d => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      win_buf_rsci_oswt => reg_win_buf_rsci_oswt_cse,
      win_buf_rsci_radr_d_core => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_radr_d_core,
      win_buf_rsci_wadr_d_core => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_wadr_d_core,
      win_buf_rsci_d_d_core => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_d_d_core,
      win_buf_rsci_q_d_mxwt => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_q_d_mxwt,
      win_buf_rsci_oswt_pff => or_tmp_46,
      win_buf_rsci_iswt0_1_pff => SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_iswt0_1_pff
    );
  win_buf_rsci_radr_d_reg <= SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_radr_d;
  win_buf_rsci_wadr_d_reg <= SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_wadr_d;
  win_buf_rsci_d_d_reg <= SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_d_d;
  SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_q_d <= win_buf_rsci_q_d;
  SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_radr_d_core <= (MUX_v_4_2_2(STD_LOGIC_VECTOR(CONV_UNSIGNED(CONV_UNSIGNED(CONV_UNSIGNED(UNSIGNED(loop_3_acc_11_sdt_3_0_1(3
      DOWNTO 2)), 2), 4) + UNSIGNED(loop_1_z_3_0_sva), 4)), z_out, fsm_output(10)))
      & (MUX_v_2_2_2((loop_3_acc_11_sdt_3_0_1(1 DOWNTO 0)), (z_out_2_3_0(1 DOWNTO
      0)), fsm_output(10))) & (MUX_s_1_2_2((z_out_4(0)), (loop_1_z_3_0_sva(0)), fsm_output(10)));
  SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_wadr_d_core <= (MUX_v_4_2_2(loop_3_acc_14_psp,
      loop_3_acc_12_sdt_3_0, fsm_output(8))) & (MUX_v_2_2_2((loop_3_acc_12_sdt_3_0(1
      DOWNTO 0)), (j_3_0_sva(1 DOWNTO 0)), fsm_output(8))) & ((j_3_0_sva(0)) OR (NOT
      (fsm_output(4))));
  SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_d_d_core <= MUX_v_8_2_2(win_buf_rsci_q_d_mxwt,
      row_buf_rsci_q_d_mxwt, fsm_output(8));
  win_buf_rsci_q_d_mxwt <= SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_q_d_mxwt;
  SAD_MATCH_core_win_buf_rsci_1_inst_win_buf_rsci_iswt0_1_pff <= (fsm_output(8))
      OR (fsm_output(4));

  SAD_MATCH_core_staller_inst : SAD_MATCH_core_staller
    PORT MAP(
      clk => clk,
      rst => rst,
      core_wen => core_wen,
      core_wten => core_wten,
      INPUT_rsci_wen_comp => INPUT_rsci_wen_comp,
      OUTPUT_rsci_wen_comp => OUTPUT_rsci_wen_comp
    );
  SAD_MATCH_core_core_fsm_inst : SAD_MATCH_core_core_fsm
    PORT MAP(
      clk => clk,
      rst => rst,
      core_wen => core_wen,
      fsm_output => SAD_MATCH_core_core_fsm_inst_fsm_output,
      loop_3_C_2_tr0 => SAD_MATCH_core_core_fsm_inst_loop_3_C_2_tr0,
      loop_2_C_0_tr0 => SAD_MATCH_core_core_fsm_inst_loop_2_C_0_tr0,
      loop_4_C_2_tr0 => SAD_MATCH_core_core_fsm_inst_loop_4_C_2_tr0,
      loop_6_C_1_tr0 => SAD_MATCH_core_core_fsm_inst_loop_6_C_1_tr0,
      loop_5_C_0_tr0 => SAD_MATCH_core_core_fsm_inst_loop_5_C_0_tr0,
      loop_lmm_C_2_tr0 => SAD_MATCH_core_core_fsm_inst_loop_lmm_C_2_tr0,
      loop_8_C_2_tr0 => SAD_MATCH_core_core_fsm_inst_loop_8_C_2_tr0,
      loop_7_C_0_tr0 => SAD_MATCH_core_core_fsm_inst_loop_7_C_0_tr0,
      loop_lmm_C_4_tr0 => loop_lmm_loop_lmm_nor_itm
    );
  fsm_output <= SAD_MATCH_core_core_fsm_inst_fsm_output;
  SAD_MATCH_core_core_fsm_inst_loop_3_C_2_tr0 <= NOT loop_3_slc_loop_3_acc_3_itm;
  SAD_MATCH_core_core_fsm_inst_loop_2_C_0_tr0 <= NOT (z_out_3(4));
  SAD_MATCH_core_core_fsm_inst_loop_4_C_2_tr0 <= NOT loop_3_slc_loop_3_acc_3_itm;
  SAD_MATCH_core_core_fsm_inst_loop_6_C_1_tr0 <= NOT loop_3_slc_loop_3_acc_3_itm;
  SAD_MATCH_core_core_fsm_inst_loop_5_C_0_tr0 <= NOT z_out_1_3;
  SAD_MATCH_core_core_fsm_inst_loop_lmm_C_2_tr0 <= CONV_SL_1_1(z_out_5_31_0/=STD_LOGIC_VECTOR'("00000000000000000000000011001000"));
  SAD_MATCH_core_core_fsm_inst_loop_8_C_2_tr0 <= NOT k_sva_3;
  SAD_MATCH_core_core_fsm_inst_loop_7_C_0_tr0 <= NOT (z_out_3(4));

  and_cse <= ((fsm_output(18)) OR (fsm_output(0))) AND core_wen;
  loop_op_i_not_nl <= NOT (fsm_output(0));
  loop_1_loop_1_and_2_cse <= MUX_v_16_2_2(STD_LOGIC_VECTOR'("0000000000000000"),
      z_out_6, loop_op_i_not_nl);
  or_141_rmff <= (fsm_output(7)) OR (fsm_output(14));
  i_15_0_sva_2 <= STD_LOGIC_VECTOR(CONV_SIGNED(SIGNED(i_15_0_sva) + SIGNED'( "0000000000000001"),
      16));
  loop_3_acc_11_sdt_3_0_1 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(loop_1_z_3_0_sva)
      + CONV_UNSIGNED(CONV_UNSIGNED(UNSIGNED(z_out_4(3 DOWNTO 1)), 3), 4), 4));
  k_sva_1_mx1 <= MUX_v_32_2_2(k_sva_1, z_out_5_31_0, fsm_output(13));
  k_sva_1_mx2_3 <= MUX_s_1_2_2((k_sva_1(3)), (z_out_5_31_0(3)), fsm_output(13));
  loop_1_loop_1_nand_seb_1 <= NOT(CONV_SL_1_1(k_sva_1_mx1(7 DOWNTO 6)=STD_LOGIC_VECTOR'("11"))
      AND k_sva_1_mx2_3 AND (NOT((k_sva_1_mx1(31)) OR (k_sva_1_mx1(30)) OR (k_sva_1_mx1(29))
      OR (k_sva_1_mx1(28)) OR (k_sva_1_mx1(27)) OR (k_sva_1_mx1(26)) OR (k_sva_1_mx1(25))
      OR (k_sva_1_mx1(24)) OR (k_sva_1_mx1(23)) OR (k_sva_1_mx1(22)) OR (k_sva_1_mx1(21))
      OR (k_sva_1_mx1(20)) OR (k_sva_1_mx1(19)) OR (k_sva_1_mx1(18)) OR (k_sva_1_mx1(17))
      OR (k_sva_1_mx1(16)) OR (k_sva_1_mx1(15)) OR (k_sva_1_mx1(14)) OR (k_sva_1_mx1(13))
      OR (k_sva_1_mx1(12)) OR (k_sva_1_mx1(11)) OR (k_sva_1_mx1(10)) OR (k_sva_1_mx1(9))
      OR (k_sva_1_mx1(8)) OR (k_sva_1_mx1(5)) OR (k_sva_1_mx1(4)) OR (k_sva_1_mx1(2))
      OR (k_sva_1_mx1(1)) OR (k_sva_1_mx1(0)))));
  and_dcpl_49 <= NOT((fsm_output(16)) OR (fsm_output(17)) OR (fsm_output(13)));
  or_dcpl_81 <= (fsm_output(17)) OR (fsm_output(13));
  or_dcpl_83 <= CONV_SL_1_1(fsm_output(15 DOWNTO 14)/=STD_LOGIC_VECTOR'("00"));
  or_dcpl_85 <= (fsm_output(18)) OR (fsm_output(16));
  or_tmp_46 <= (fsm_output(10)) OR (fsm_output(3));
  j_3_0_sva_mx0c1 <= (fsm_output(12)) OR (fsm_output(17)) OR ((z_out_3(4)) AND (fsm_output(6)));
  j_3_0_sva_mx0c2 <= (fsm_output(2)) OR (fsm_output(13)) OR ((NOT loop_3_slc_loop_3_acc_3_itm)
      AND (fsm_output(9))) OR ((NOT (z_out_3(4))) AND (fsm_output(6)));
  row_buf_rsci_radr_d <= row_buf_rsci_radr_d_reg;
  row_buf_rsci_wadr_d <= row_buf_rsci_wadr_d_reg;
  row_buf_rsci_d_d <= row_buf_rsci_d_d_reg;
  row_buf_rsci_we_d <= row_buf_rsci_we_d_reg;
  row_buf_rsci_re_d <= row_buf_rsci_re_d_reg;
  win_buf_rsci_radr_d <= win_buf_rsci_radr_d_reg;
  win_buf_rsci_wadr_d <= win_buf_rsci_wadr_d_reg;
  win_buf_rsci_d_d <= win_buf_rsci_d_d_reg;
  win_buf_rsci_we_d <= win_buf_rsci_we_d_reg;
  win_buf_rsci_re_d <= win_buf_rsci_re_d_reg;
  or_tmp_86 <= (fsm_output(17)) OR (fsm_output(6));
  or_tmp_89 <= (fsm_output(17)) OR (fsm_output(6)) OR (fsm_output(12)) OR (fsm_output(7));
  loop_1_or_3_ssc <= or_tmp_89 OR (fsm_output(3)) OR (fsm_output(14));
  loop_8_or_ssc <= or_tmp_46 OR (fsm_output(13));
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( and_cse = '1' ) THEN
        loop_op_i_15_0_sva <= loop_1_loop_1_and_2_cse;
        i_15_0_sva <= MUX_v_16_2_2(STD_LOGIC_VECTOR'("0000000000000000"), i_15_0_sva_2,
            not_111_nl);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND (fsm_output(18))) = '1' ) THEN
        OUTPUT_rsci_idat_0 <= z_out_4(32);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND ((fsm_output(0)) OR (fsm_output(16)) OR (fsm_output(17))
          OR (fsm_output(13)) OR (fsm_output(14)) OR (fsm_output(19)))) = '1' ) THEN
        k_sva_31_8 <= MUX_v_24_2_2(STD_LOGIC_VECTOR'("000000000000000000000000"),
            k_mux_5_nl, k_not_nl);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( core_wen = '1' ) THEN
        k_sva_7_6 <= MUX_v_2_2_2(STD_LOGIC_VECTOR'("00"), k_mux_4_nl, nor_37_nl);
        k_sva_3 <= k_mux1h_10_nl AND (NOT((fsm_output(16)) OR (fsm_output(0))));
        loop_8_acc_10_itm <= MUX_v_6_2_2(z_out_7, (STD_LOGIC_VECTOR'( "000") & k_k_and_nl),
            nor_31_nl);
        loop_1_z_3_0_sva <= MUX_v_4_2_2(STD_LOGIC_VECTOR'("0000"), n_mux1h_nl, nor_nl);
        loop_3_acc_14_psp <= z_out;
        loop_3_acc_12_sdt_3_0 <= z_out_2_3_0;
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        reg_INPUT_rsci_oswt_cse <= '0';
        reg_OUTPUT_rsci_oswt_cse <= '0';
        reg_row_buf_rsci_oswt_cse <= '0';
        reg_win_buf_rsci_oswt_cse <= '0';
        loop_lmm_loop_lmm_nor_itm <= '0';
      ELSIF ( core_wen = '1' ) THEN
        reg_INPUT_rsci_oswt_cse <= NOT((NOT((fsm_output(19)) OR (fsm_output(0))))
            OR (loop_lmm_loop_lmm_nor_itm AND (fsm_output(19))));
        reg_OUTPUT_rsci_oswt_cse <= fsm_output(18);
        reg_row_buf_rsci_oswt_cse <= or_141_rmff;
        reg_win_buf_rsci_oswt_cse <= or_tmp_46;
        loop_lmm_loop_lmm_nor_itm <= NOT((loop_lmm_acc_nl(10)) OR (z_out_5_31_0(10))
            OR (loop_op_acc_nl(10)));
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND ((fsm_output(0)) OR (fsm_output(19)))) = '1' ) THEN
        k_sva_5_4 <= MUX_v_2_2_2(STD_LOGIC_VECTOR'("00"), (k_sva_1(5 DOWNTO 4)),
            (fsm_output(19)));
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( ((CONV_SL_1_1(fsm_output(1 DOWNTO 0)/=STD_LOGIC_VECTOR'("00"))) AND core_wen)
          = '1' ) THEN
        loop_lmm_i_15_0_sva <= loop_1_loop_1_and_2_cse;
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND ((loop_3_slc_loop_3_acc_3_itm AND (fsm_output(9))) OR j_3_0_sva_mx0c1
          OR j_3_0_sva_mx0c2)) = '1' ) THEN
        j_3_0_sva <= MUX_v_4_2_2(STD_LOGIC_VECTOR'("0000"), loop_1_z_mux_nl, j_not_nl);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND ((fsm_output(7)) OR or_tmp_46)) = '1' ) THEN
        loop_3_slc_loop_3_acc_3_itm <= z_out_1_3;
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND ((fsm_output(11)) OR (fsm_output(9)))) = '1' ) THEN
        loop_1_sad_lpi_4 <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
            (z_out_4(31 DOWNTO 0)), (fsm_output(11)));
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        k_sva_1 <= STD_LOGIC_VECTOR'( "00000000000000000000000000000000");
      ELSIF ( (core_wen AND (NOT(or_dcpl_85 OR (fsm_output(17)) OR or_dcpl_83)))
          = '1' ) THEN
        k_sva_1 <= z_out_5_31_0;
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND (fsm_output(14))) = '1' ) THEN
        o_7_0_sva_1 <= z_out_3;
      END IF;
    END IF;
  END PROCESS;
  not_111_nl <= NOT (fsm_output(0));
  loop_8_mux_1_nl <= MUX_v_8_2_2((k_sva_31_8(7 DOWNTO 0)), o_7_0_sva_1, fsm_output(16));
  or_211_nl <= (fsm_output(16)) OR (fsm_output(14));
  loop_8_loop_8_and_nl <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), loop_8_mux_1_nl,
      or_211_nl);
  k_mux_5_nl <= MUX_v_24_2_2((STD_LOGIC_VECTOR'( "0000000000000000") & loop_8_loop_8_and_nl),
      (k_sva_1(31 DOWNTO 8)), fsm_output(19));
  k_not_nl <= NOT (fsm_output(0));
  nor_29_nl <= NOT((NOT and_dcpl_49) OR (fsm_output(14)) OR (fsm_output(15)) OR (fsm_output(0)));
  k_mux_4_nl <= MUX_v_2_2_2((k_sva_1_mx1(7 DOWNTO 6)), k_sva_7_6, nor_29_nl);
  nor_37_nl <= NOT((fsm_output(0)) OR (fsm_output(14)) OR (fsm_output(15)) OR (fsm_output(16))
      OR (NOT(and_dcpl_49 OR loop_1_loop_1_nand_seb_1)));
  loop_1_loop_1_and_nl <= k_sva_1_mx2_3 AND loop_1_loop_1_nand_seb_1;
  and_146_nl <= and_dcpl_49 AND (NOT (fsm_output(14))) AND (NOT (fsm_output(0)));
  k_mux1h_10_nl <= MUX1HOT_s_1_3_2(loop_1_loop_1_and_nl, (z_out_5_31_0(5)), k_sva_3,
      STD_LOGIC_VECTOR'( or_dcpl_81 & (fsm_output(14)) & and_146_nl));
  k_mux_3_nl <= MUX_v_3_2_2((loop_8_acc_10_itm(2 DOWNTO 0)), (k_sva_1(2 DOWNTO 0)),
      fsm_output(19));
  nor_32_nl <= NOT(or_dcpl_85 OR or_dcpl_81 OR or_dcpl_83 OR (fsm_output(0)));
  k_k_and_nl <= MUX_v_3_2_2(STD_LOGIC_VECTOR'("000"), k_mux_3_nl, nor_32_nl);
  nor_31_nl <= NOT(CONV_SL_1_1(fsm_output(18 DOWNTO 13)/=STD_LOGIC_VECTOR'("000000")));
  or_163_nl <= (fsm_output(8)) OR (fsm_output(5)) OR (fsm_output(11)) OR (fsm_output(4));
  n_mux1h_nl <= MUX1HOT_v_4_3_2((z_out_5_31_0(3 DOWNTO 0)), loop_1_z_3_0_sva, (z_out_4(3
      DOWNTO 0)), STD_LOGIC_VECTOR'( or_tmp_46 & or_163_nl & (fsm_output(7))));
  nor_nl <= NOT((fsm_output(2)) OR (fsm_output(6)) OR (fsm_output(12)) OR (fsm_output(9)));
  loop_lmm_acc_nl <= STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(CONV_UNSIGNED(UNSIGNED(loop_lmm_i_15_0_sva(15
      DOWNTO 6)), 10), 11) + SIGNED'( "10110001111"), 11));
  loop_op_acc_nl <= STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(CONV_UNSIGNED(UNSIGNED(z_out_6(15
      DOWNTO 6)), 10), 11) + SIGNED'( "10110001111"), 11));
  loop_1_z_mux_nl <= MUX_v_4_2_2(loop_1_z_3_0_sva, (z_out_4(3 DOWNTO 0)), j_3_0_sva_mx0c1);
  j_not_nl <= NOT j_3_0_sva_mx0c2;
  loop_3_or_4_nl <= or_141_rmff OR (fsm_output(10));
  loop_3_mux_5_nl <= MUX_v_4_2_2(loop_1_z_3_0_sva, j_3_0_sva, loop_3_or_4_nl);
  loop_3_loop_3_mux_1_nl <= MUX_v_2_2_2((z_out_2_3_0(3 DOWNTO 2)), (j_3_0_sva(3 DOWNTO
      2)), or_141_rmff);
  z_out <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(loop_3_mux_5_nl) + CONV_UNSIGNED(UNSIGNED(loop_3_loop_3_mux_1_nl),
      4), 4));
  or_218_ssc <= (fsm_output(12)) OR (fsm_output(7));
  loop_3_mux_6_nl <= MUX_s_1_2_2((z_out_5_31_0(1)), (z_out_4(1)), or_218_ssc);
  loop_3_mux_7_nl <= MUX_s_1_2_2((z_out_5_31_0(2)), (z_out_4(2)), or_218_ssc);
  loop_3_mux_8_nl <= MUX_s_1_2_2((z_out_5_31_0(3)), (z_out_4(3)), or_218_ssc);
  z_out_1_3 <= NOT((loop_3_mux_6_nl OR loop_3_mux_7_nl) AND loop_3_mux_8_nl);
  loop_4_mux_1_nl <= MUX_v_4_2_2(j_3_0_sva, loop_1_z_3_0_sva, fsm_output(3));
  loop_4_or_1_nl <= (NOT((fsm_output(3)) OR (fsm_output(10)))) OR (fsm_output(7));
  loop_4_mux1h_1_nl <= MUX1HOT_v_3_3_2(('0' & (j_3_0_sva(3 DOWNTO 2))), (j_3_0_sva(3
      DOWNTO 1)), (loop_1_z_3_0_sva(3 DOWNTO 1)), STD_LOGIC_VECTOR'( (fsm_output(7))
      & (fsm_output(3)) & (fsm_output(10))));
  acc_2_nl <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(loop_4_mux_1_nl & loop_4_or_1_nl)
      + CONV_UNSIGNED(CONV_UNSIGNED(UNSIGNED(loop_4_mux1h_1_nl & '1'), 4), 5), 5));
  z_out_2_3_0 <= acc_2_nl(4 DOWNTO 1);
  loop_8_mux_7_nl <= MUX_v_8_2_2((k_sva_31_8(7 DOWNTO 0)), STD_LOGIC_VECTOR'( "11110111"),
      or_tmp_86);
  loop_8_mux_8_nl <= MUX_v_4_2_2(STD_LOGIC_VECTOR'( "0001"), (z_out_4(3 DOWNTO 0)),
      or_tmp_86);
  z_out_3 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(loop_8_mux_7_nl) + CONV_UNSIGNED(UNSIGNED(loop_8_mux_8_nl),
      8), 8));
  loop_1_or_4_nl <= (fsm_output(18)) OR (fsm_output(11));
  loop_1_or_5_nl <= or_tmp_89 OR (fsm_output(3));
  loop_1_mux1h_4_nl <= MUX1HOT_v_32_4_2(loop_1_sad_lpi_4, STD_LOGIC_VECTOR(CONV_SIGNED(SIGNED(j_3_0_sva),32)),
      (STD_LOGIC_VECTOR'( "000000000000000000000000000000") & (j_3_0_sva(3 DOWNTO
      2))), STD_LOGIC_VECTOR(CONV_SIGNED(SIGNED((k_sva_7_6(0)) & k_sva_5_4 & k_sva_3
      & (loop_8_acc_10_itm(2 DOWNTO 1))),32)), STD_LOGIC_VECTOR'( loop_1_or_4_nl
      & loop_1_or_5_nl & (fsm_output(14)) & (fsm_output(1))));
  loop_1_loop_1_or_1_nl <= (NOT((fsm_output(11)) OR loop_1_or_3_ssc)) OR (fsm_output(1));
  loop_1_mux1h_5_nl <= MUX1HOT_v_8_3_2(win_buf_rsci_q_d_mxwt, STD_LOGIC_VECTOR'(
      "00000001"), STD_LOGIC_VECTOR'( "11101101"), STD_LOGIC_VECTOR'( (fsm_output(11))
      & loop_1_or_3_ssc & (fsm_output(1))));
  loop_1_or_6_nl <= MUX_v_9_2_2((loop_1_loop_1_or_1_nl & loop_1_mux1h_5_nl), STD_LOGIC_VECTOR'("111111111"),
      (fsm_output(18)));
  z_out_4 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(CONV_UNSIGNED(SIGNED(loop_1_mux1h_4_nl),
      33) + CONV_UNSIGNED(SIGNED(loop_1_or_6_nl), 33), 33));
  loop_8_mux1h_4_nl <= MUX1HOT_v_32_4_2((STD_LOGIC_VECTOR'( "000000000000000000000000000")
      & (z_out_3(7 DOWNTO 3))), STD_LOGIC_VECTOR(CONV_SIGNED(SIGNED(loop_1_z_3_0_sva),32)),
      (k_sva_31_8 & k_sva_7_6 & k_sva_5_4 & k_sva_3 & (loop_8_acc_10_itm(2 DOWNTO
      0))), (STD_LOGIC_VECTOR'( "0000000000000000000000") & (i_15_0_sva_2(15 DOWNTO
      6))), STD_LOGIC_VECTOR'( (fsm_output(14)) & or_tmp_46 & (fsm_output(13)) &
      (fsm_output(18))));
  loop_8_loop_8_or_3_nl <= (NOT loop_8_or_ssc) OR (fsm_output(14));
  loop_8_not_4_nl <= NOT loop_8_or_ssc;
  loop_8_loop_8_or_4_nl <= MUX_v_2_2_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(fsm_output(14),
      1),2)), STD_LOGIC_VECTOR'("11"), loop_8_not_4_nl);
  loop_8_not_5_nl <= NOT loop_8_or_ssc;
  loop_8_loop_8_or_5_nl <= MUX_v_2_2_2(STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(fsm_output(18),
      1),2)), STD_LOGIC_VECTOR'("11"), loop_8_not_5_nl);
  z_out_5_31_0 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(loop_8_mux1h_4_nl) + CONV_UNSIGNED(CONV_SIGNED(SIGNED(loop_8_loop_8_or_3_nl
      & (fsm_output(14)) & loop_8_loop_8_or_4_nl & STD_LOGIC_VECTOR(CONV_SIGNED(CONV_SIGNED(fsm_output(14),
      1),2)) & '0' & (fsm_output(18)) & loop_8_loop_8_or_5_nl & '1'), 11), 32), 32));
  loop_lmm_mux_3_nl <= MUX_v_16_2_2(loop_lmm_i_15_0_sva, loop_op_i_15_0_sva, fsm_output(18));
  z_out_6 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(loop_lmm_mux_3_nl) + UNSIGNED'(
      "0000000000000001"), 16));
  loop_8_mux_9_nl <= MUX_v_6_2_2((k_sva_31_8(6 DOWNTO 1)), ((k_sva_7_6(0)) & k_sva_5_4
      & k_sva_3 & (loop_8_acc_10_itm(2 DOWNTO 1))), fsm_output(7));
  z_out_7 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(z_out & (j_3_0_sva(1 DOWNTO
      0))) + UNSIGNED(loop_8_mux_9_nl), 6));
END v3;

-- ------------------------------------------------------------------
--  Design Unit:    SAD_MATCH
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.ccs_in_wait_pkg_v1.ALL;
USE work.ccs_out_wait_pkg_v1.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY SAD_MATCH IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    INPUT_rsc_dat : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    INPUT_rsc_vld : IN STD_LOGIC;
    INPUT_rsc_rdy : OUT STD_LOGIC;
    OUTPUT_rsc_dat : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    OUTPUT_rsc_vld : OUT STD_LOGIC;
    OUTPUT_rsc_rdy : IN STD_LOGIC
  );
END SAD_MATCH;

ARCHITECTURE v3 OF SAD_MATCH IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL row_buf_rsci_radr_d : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_wadr_d : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_d_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsci_we_d : STD_LOGIC;
  SIGNAL row_buf_rsci_re_d : STD_LOGIC;
  SIGNAL row_buf_rsci_q_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsci_radr_d : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_wadr_d : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_d_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsci_we_d : STD_LOGIC;
  SIGNAL win_buf_rsci_re_d : STD_LOGIC;
  SIGNAL win_buf_rsci_q_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsc_we : STD_LOGIC;
  SIGNAL row_buf_rsc_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsc_wadr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsc_re : STD_LOGIC;
  SIGNAL row_buf_rsc_q : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsc_radr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsc_we : STD_LOGIC;
  SIGNAL win_buf_rsc_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsc_wadr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsc_re : STD_LOGIC;
  SIGNAL win_buf_rsc_q : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsc_radr : STD_LOGIC_VECTOR (6 DOWNTO 0);

  SIGNAL row_buf_rsc_comp_radr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsc_comp_wadr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsc_comp_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsc_comp_q : STD_LOGIC_VECTOR (7 DOWNTO 0);

  SIGNAL win_buf_rsc_comp_radr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsc_comp_wadr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsc_comp_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsc_comp_q : STD_LOGIC_VECTOR (7 DOWNTO 0);

  COMPONENT SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_5_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL row_buf_rsci_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsci_wadr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_q : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsci_radr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_radr_d_1 : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_wadr_d_1 : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL row_buf_rsci_d_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL row_buf_rsci_q_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);

  COMPONENT SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_6_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL win_buf_rsci_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsci_wadr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_q : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsci_radr : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_radr_d_1 : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_wadr_d_1 : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL win_buf_rsci_d_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL win_buf_rsci_q_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);

  COMPONENT SAD_MATCH_core
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      INPUT_rsc_dat : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      INPUT_rsc_vld : IN STD_LOGIC;
      INPUT_rsc_rdy : OUT STD_LOGIC;
      OUTPUT_rsc_dat : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      OUTPUT_rsc_vld : OUT STD_LOGIC;
      OUTPUT_rsc_rdy : IN STD_LOGIC;
      row_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      row_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      row_buf_rsci_we_d : OUT STD_LOGIC;
      row_buf_rsci_re_d : OUT STD_LOGIC;
      row_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_radr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_wadr_d : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
      win_buf_rsci_d_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      win_buf_rsci_we_d : OUT STD_LOGIC;
      win_buf_rsci_re_d : OUT STD_LOGIC;
      win_buf_rsci_q_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL SAD_MATCH_core_inst_INPUT_rsc_dat : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_OUTPUT_rsc_dat : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_row_buf_rsci_radr_d : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_row_buf_rsci_wadr_d : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_row_buf_rsci_d_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_row_buf_rsci_q_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_win_buf_rsci_radr_d : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_win_buf_rsci_wadr_d : STD_LOGIC_VECTOR (6 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_win_buf_rsci_d_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL SAD_MATCH_core_inst_win_buf_rsci_q_d : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
  row_buf_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 8,
      addr_width => 7,
      depth => 100
      )
    PORT MAP(
      radr => row_buf_rsc_comp_radr,
      wadr => row_buf_rsc_comp_wadr,
      d => row_buf_rsc_comp_d,
      we => row_buf_rsc_we,
      re => row_buf_rsc_re,
      clk => clk,
      q => row_buf_rsc_comp_q
    );
  row_buf_rsc_comp_radr <= row_buf_rsc_radr;
  row_buf_rsc_comp_wadr <= row_buf_rsc_wadr;
  row_buf_rsc_comp_d <= row_buf_rsc_d;
  row_buf_rsc_q <= row_buf_rsc_comp_q;

  win_buf_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 8,
      addr_width => 7,
      depth => 100
      )
    PORT MAP(
      radr => win_buf_rsc_comp_radr,
      wadr => win_buf_rsc_comp_wadr,
      d => win_buf_rsc_comp_d,
      we => win_buf_rsc_we,
      re => win_buf_rsc_re,
      clk => clk,
      q => win_buf_rsc_comp_q
    );
  win_buf_rsc_comp_radr <= win_buf_rsc_radr;
  win_buf_rsc_comp_wadr <= win_buf_rsc_wadr;
  win_buf_rsc_comp_d <= win_buf_rsc_d;
  win_buf_rsc_q <= win_buf_rsc_comp_q;

  row_buf_rsci : SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_5_gen
    PORT MAP(
      we => row_buf_rsc_we,
      d => row_buf_rsci_d,
      wadr => row_buf_rsci_wadr,
      re => row_buf_rsc_re,
      q => row_buf_rsci_q,
      radr => row_buf_rsci_radr,
      radr_d => row_buf_rsci_radr_d_1,
      wadr_d => row_buf_rsci_wadr_d_1,
      d_d => row_buf_rsci_d_d_1,
      we_d => row_buf_rsci_we_d,
      re_d => row_buf_rsci_re_d,
      q_d => row_buf_rsci_q_d_1
    );
  row_buf_rsc_d <= row_buf_rsci_d;
  row_buf_rsc_wadr <= row_buf_rsci_wadr;
  row_buf_rsci_q <= row_buf_rsc_q;
  row_buf_rsc_radr <= row_buf_rsci_radr;
  row_buf_rsci_radr_d_1 <= row_buf_rsci_radr_d;
  row_buf_rsci_wadr_d_1 <= row_buf_rsci_wadr_d;
  row_buf_rsci_d_d_1 <= row_buf_rsci_d_d;
  row_buf_rsci_q_d <= row_buf_rsci_q_d_1;

  win_buf_rsci : SAD_MATCH_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_8_7_100_6_gen
    PORT MAP(
      we => win_buf_rsc_we,
      d => win_buf_rsci_d,
      wadr => win_buf_rsci_wadr,
      re => win_buf_rsc_re,
      q => win_buf_rsci_q,
      radr => win_buf_rsci_radr,
      radr_d => win_buf_rsci_radr_d_1,
      wadr_d => win_buf_rsci_wadr_d_1,
      d_d => win_buf_rsci_d_d_1,
      we_d => win_buf_rsci_we_d,
      re_d => win_buf_rsci_re_d,
      q_d => win_buf_rsci_q_d_1
    );
  win_buf_rsc_d <= win_buf_rsci_d;
  win_buf_rsc_wadr <= win_buf_rsci_wadr;
  win_buf_rsci_q <= win_buf_rsc_q;
  win_buf_rsc_radr <= win_buf_rsci_radr;
  win_buf_rsci_radr_d_1 <= win_buf_rsci_radr_d;
  win_buf_rsci_wadr_d_1 <= win_buf_rsci_wadr_d;
  win_buf_rsci_d_d_1 <= win_buf_rsci_d_d;
  win_buf_rsci_q_d <= win_buf_rsci_q_d_1;

  SAD_MATCH_core_inst : SAD_MATCH_core
    PORT MAP(
      clk => clk,
      rst => rst,
      INPUT_rsc_dat => SAD_MATCH_core_inst_INPUT_rsc_dat,
      INPUT_rsc_vld => INPUT_rsc_vld,
      INPUT_rsc_rdy => INPUT_rsc_rdy,
      OUTPUT_rsc_dat => SAD_MATCH_core_inst_OUTPUT_rsc_dat,
      OUTPUT_rsc_vld => OUTPUT_rsc_vld,
      OUTPUT_rsc_rdy => OUTPUT_rsc_rdy,
      row_buf_rsci_radr_d => SAD_MATCH_core_inst_row_buf_rsci_radr_d,
      row_buf_rsci_wadr_d => SAD_MATCH_core_inst_row_buf_rsci_wadr_d,
      row_buf_rsci_d_d => SAD_MATCH_core_inst_row_buf_rsci_d_d,
      row_buf_rsci_we_d => row_buf_rsci_we_d,
      row_buf_rsci_re_d => row_buf_rsci_re_d,
      row_buf_rsci_q_d => SAD_MATCH_core_inst_row_buf_rsci_q_d,
      win_buf_rsci_radr_d => SAD_MATCH_core_inst_win_buf_rsci_radr_d,
      win_buf_rsci_wadr_d => SAD_MATCH_core_inst_win_buf_rsci_wadr_d,
      win_buf_rsci_d_d => SAD_MATCH_core_inst_win_buf_rsci_d_d,
      win_buf_rsci_we_d => win_buf_rsci_we_d,
      win_buf_rsci_re_d => win_buf_rsci_re_d,
      win_buf_rsci_q_d => SAD_MATCH_core_inst_win_buf_rsci_q_d
    );
  SAD_MATCH_core_inst_INPUT_rsc_dat <= INPUT_rsc_dat;
  OUTPUT_rsc_dat <= SAD_MATCH_core_inst_OUTPUT_rsc_dat;
  row_buf_rsci_radr_d <= SAD_MATCH_core_inst_row_buf_rsci_radr_d;
  row_buf_rsci_wadr_d <= SAD_MATCH_core_inst_row_buf_rsci_wadr_d;
  row_buf_rsci_d_d <= SAD_MATCH_core_inst_row_buf_rsci_d_d;
  SAD_MATCH_core_inst_row_buf_rsci_q_d <= row_buf_rsci_q_d;
  win_buf_rsci_radr_d <= SAD_MATCH_core_inst_win_buf_rsci_radr_d;
  win_buf_rsci_wadr_d <= SAD_MATCH_core_inst_win_buf_rsci_wadr_d;
  win_buf_rsci_d_d <= SAD_MATCH_core_inst_win_buf_rsci_d_d;
  SAD_MATCH_core_inst_win_buf_rsci_q_d <= win_buf_rsci_q_d;

END v3;



