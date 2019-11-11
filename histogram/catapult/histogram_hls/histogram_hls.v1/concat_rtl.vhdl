
--------> /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/pkgs/ccs_libs/interfaces/amba/amba_comps.vhd 
--//////////////////////////////////////////////////////////////////////////////
-- Catapult Synthesis - Custom Interfaces
--
-- Copyright (c) 2016 Mentor Graphics Corp.
--       All Rights Reserved
-- 
-- This document contains information that is proprietary to Mentor Graphics
-- Corp. The original recipient of this document may duplicate this  
-- document in whole or in part for internal business purposes only, provided  
-- that this entire notice appears in all copies. In duplicating any part of  
-- this document, the recipient agrees to make every reasonable effort to  
-- prevent the unauthorized use and distribution of the proprietary information.
-- 
-- The design information contained in this file is intended to be an example
-- of the functionality which the end user may study in prepartion for creating
-- their own custom interfaces. This design does not present a complete
-- implementation of the named protocol or standard.
--
-- NO WARRANTY.
-- MENTOR GRAPHICS CORP. EXPRESSLY DISCLAIMS ALL WARRANTY
-- FOR THE SOFTWARE. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE
-- LAW, THE SOFTWARE AND ANY RELATED DOCUMENTATION IS PROVIDED "AS IS"
-- AND WITH ALL FAULTS AND WITHOUT WARRANTIES OR CONDITIONS OF ANY
-- KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
-- PURPOSE, OR NONINFRINGEMENT. THE ENTIRE RISK ARISING OUT OF USE OR
-- DISTRIBUTION OF THE SOFTWARE REMAINS WITH YOU.
-- 
--//////////////////////////////////////////////////////////////////////////////

-- --------------------------------------------------------------------------
-- LIBRARY: amba
--
-- CONTENTS:
--    axi4stream_w_wire, axi4stream_r_wire, axi4svideo_w_wire, axi4svideo_r_wire
--      Catapult AXI-4 Stream bus definitions
--    ccs_axi4stream_in
--      AXI4-Streaming input interface
--    ccs_axi4stream_out
--      AXI4-Streaming output interface
--    ccs_axi4stream_pipe
--      AXI4-Streaming FIFO interconnect component
--    ccs_axi4svideo_in
--      AXI4-Streaming video input interface
--    ccs_axi4svideo_out
--      AXI4-Streaming video output interface
--    ccs_axi4svideo_pipe
--      AXI4-Streaming video FIFO interconnect component
--
--    axi4_busdef
--      Catapult AXI-4 bus definition
--
--    ccs_axi4_slave_mem
--      Catapult AXI-4 slave memory
---
--    ccs_axi4_master
--      Catapult AXI4 master interface for read/write data
--
--    apb_busdef
--      Catapult APB bus definition
--    apb_slave_mem
--      APB Slave Memory interface
--
-- CHANGE LOG:
--
--  10/01/16 - dgb - Initial implementation
--
-- --------------------------------------------------------------------------

-- --------------------------------------------------------------------------
-- PACKAGE:     amba_comps
--
-- DESCRIPTION:
--   Contains component declarations for all design units in this file.
--
-- CHANGE LOG:
--
--  10/01/16 - dgb - Initial implementation
--
-- --------------------------------------------------------------------------

LIBRARY ieee;

   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_arith.all;
   USE ieee.std_logic_unsigned.all;

PACKAGE amba_comps IS

  -- ==============================================================
  -- AXI-4 Stream Components
  -- ------------------------------ TSTRB/TKEEP controls --------------------
  --    TKEEP   TSTRB   Data Type         Description
  --    high    high    Data byte         Valid data byte (supported in these models)
  --    high    low     Position byte     Byte is position not data/null (not supported)
  --    low     low     Null byte         Byte is null (not supported)
  --    low     high    Reserved          Do not use (not supported)

  COMPONENT axi4stream_w_wire -- slave interface pin direction
    GENERIC(
      width            : INTEGER RANGE 3 TO 1026 := 33;           -- Catapult read/write operator width (includes data,last and user bits)
      AXI4_DATA_WIDTH  : INTEGER RANGE 8 TO 1024 := 16;           -- AXI4 Bus width
      AXI4_USER_WIDTH  : INTEGER RANGE 1 TO 8 := 1                -- AXI4 User data width
    );
    PORT(
      -- AXI-4 Stream interface                                          -- Src->Dst  Description
      TVALID    : IN   std_logic;                                        -- M->S      Indicates master is driving a valid transfer
      TREADY    : OUT  std_logic;                                        -- S->M      Indicates slave can accept a transfer
      TDATA     : IN   std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);     -- M->S      Primary payload (width-1 must be multiple of 8)
      TSTRB     : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 indicates data byte, 0 indicates position byte
      TKEEP     : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 valid byte, 0 indicates null byte
      TLAST     : IN   std_logic;                                        -- M->S      Indicates boundary of a packet
      TUSER     : IN   std_logic_vector(AXI4_USER_WIDTH-1 downto 0)      -- M->S      Optional user-defined sideband data
    );
  END COMPONENT;

  COMPONENT axi4stream_r_wire -- master interface pin direction
    GENERIC(
      width            : INTEGER RANGE 3 TO 1026 := 33;           -- Catapult read/write operator width (includes data,last and user bits)
      AXI4_DATA_WIDTH  : INTEGER RANGE 8 TO 1024 := 16;           -- AXI4 Bus width
      AXI4_USER_WIDTH  : INTEGER RANGE 1 TO 8 := 1                -- AXI4 User data width
    );
    PORT(
      -- AXI-4 Stream interface                                          -- Src->Dst  Description
      TVALID    : OUT  std_logic;                                        -- M->S      Indicates master is driving a valid transfer
      TREADY    : IN   std_logic;                                        -- S->M      Indicates slave can accept a transfer
      TDATA     : OUT  std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);     -- M->S      Primary payload (width-1 must be multiple of 8)
      TSTRB     : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 indicates data byte, 0 indicates position byte
      TKEEP     : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 valid byte, 0 indicates null byte
      TLAST     : OUT  std_logic;                                        -- M->S      Indicates boundary of a packet
      TUSER     : OUT  std_logic_vector(AXI4_USER_WIDTH-1 downto 0)      -- M->S      Optional user-defined sideband data
    );
  END COMPONENT;

  COMPONENT axi4svideo_w_wire -- slave interface pin direction
    GENERIC(
      width            : INTEGER RANGE 3 TO 1024 := 33;           -- Catapult read/write operator width
      AXI4_DATA_WIDTH  : INTEGER                 := 16            -- AXI4 Bus width
    );
    PORT(
      -- AXI-4 Stream interface                                          -- Src->Dst  Description
      TVALID    : IN   std_logic;                                        -- M->S      Indicates master is driving a valid transfer
      TREADY    : OUT  std_logic;                                        -- S->M      Indicates slave can accept a transfer
      TDATA     : IN   std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);     -- M->S      Primary payload (width-1 must be multiple of 8)
      TSTRB     : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 indicates data byte, 0 indicates position byte
      TKEEP     : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 valid byte, 0 indicates null byte
      TUSER     : IN   std_logic;                                        -- M->S      Start of Frame
      TLAST     : IN   std_logic                                         -- M->S      End of Line
    );
  END COMPONENT;

  COMPONENT axi4svideo_r_wire -- master interface pin direction
    GENERIC(
      width            : INTEGER RANGE 3 TO 1024 := 33;           -- Catapult read/write operator width
      AXI4_DATA_WIDTH  : INTEGER                 := 16            -- AXI4 Bus width
    );
    PORT(
      -- AXI-4 Stream interface                                          -- Src->Dst  Description
      TVALID    : OUT  std_logic;                                        -- M->S      Indicates master is driving a valid transfer
      TREADY    : IN   std_logic;                                        -- S->M      Indicates slave can accept a transfer
      TDATA     : OUT  std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);     -- M->S      Primary payload (width-1 must be multiple of 8)
      TSTRB     : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 indicates data byte, 0 indicates position byte
      TKEEP     : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 valid byte, 0 indicates null byte
      TUSER     : OUT  std_logic;                                        -- M->S      Start of Frame
      TLAST     : OUT  std_logic                                         -- M->S      End of Line
    );
  END COMPONENT;

  COMPONENT ccs_axi4stream_in
    GENERIC(
      width            : INTEGER RANGE 3 TO 1026 := 33;           -- Catapult read/write operator width (includes data,last and user bits)
      AXI4_DATA_WIDTH  : INTEGER RANGE 8 TO 1024 := 32;           -- AXI4 Bus width
      AXI4_USER_WIDTH  : INTEGER RANGE 1 TO 8 := 1                -- AXI4 User data width
    );
    PORT(
      -- AXI-4 Master Clock/Reset
      ACLK      : IN   std_logic;                                        -- clk src   Rising edge clock
      ARESETn   : IN   std_logic;                                        -- rst src   Active LOW synchronous reset
      -- AXI-4 Stream interface                                          -- Src->Dst  Description
      TVALID    : IN   std_logic;                                        -- M->S      Indicates master is driving a valid transfer
      TREADY    : OUT  std_logic;                                        -- S->M      Indicates slave can accept a transfer
      TDATA     : IN   std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);     -- M->S      Primary payload (width-1 must be multiple of 8)
      TSTRB     : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 indicates data byte, 0 indicates position byte
      TKEEP     : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 valid byte, 0 indicates null byte
      TLAST     : IN   std_logic;                                        -- M->S      Indicates boundary of a packet
      TUSER     : IN   std_logic_vector(AXI4_USER_WIDTH-1 downto 0);     -- M->S      Optional user-defined sideband data
      -- Catapult interface (equiv to mgc_in_wire_wait)
      d         : OUT  std_logic_vector(width-1 downto 0);               -- d  - msb TLAST TUSER(...) TDATA(...) lsb
      vd        : OUT  std_logic;                                        -- vd - TVALID
      ld        : IN   std_logic                                         -- ld - TREADY
    );
  END COMPONENT;

  COMPONENT ccs_axi4stream_out
    GENERIC(
      width            : INTEGER RANGE 3 TO 1026 := 33;           -- Catapult read/write operator width (includes data,last and user bits)
      AXI4_DATA_WIDTH  : INTEGER RANGE 8 TO 1024 := 32;           -- AXI4 Bus width
      AXI4_USER_WIDTH  : INTEGER RANGE 1 TO 8 := 1                -- AXI4 User data width
    );
    PORT(
      -- AXI-4 Master Clock/Reset
      ACLK      : IN   std_logic;                                        -- clk src   Rising edge clock
      ARESETn   : IN   std_logic;                                        -- rst src   Active LOW synchronous reset
      -- AXI-4 Stream interface                                          -- Src->Dst  Description
      TVALID    : OUT  std_logic;                                        -- M->S      Indicates master is driving a valid transfer
      TREADY    : IN   std_logic;                                        -- S->M      Indicates slave can accept a transfer
      TDATA     : OUT  std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);     -- M->S      Primary payload (width-1 must be multiple of 8)
      TSTRB     : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 indicates data byte, 0 indicates position byte
      TKEEP     : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 valid byte, 0 indicates null byte
      TLAST     : OUT  std_logic;                                        -- M->S      Indicates boundary of a packet
      TUSER     : OUT  std_logic_vector(AXI4_USER_WIDTH-1 downto 0);     -- M->S      Optional user-defined sideband data
      -- Catapult interface (equiv to mgc_out_stdreg_wait)
      d         : IN   std_logic_vector(width-1 downto 0);               -- d  - msb TLAST TUSER(...) TDATA(...) lsb
      vd        : OUT  std_logic;                                        -- vd - TREADY
      ld        : IN   std_logic                                         -- ld - TVALID
    );
  END COMPONENT;

  -- This implementation currently does not work - the 'width' parameter is not configured properly
  COMPONENT ccs_axi4stream_pipe
    GENERIC(
      rscid            : INTEGER := 1;                            -- Resource ID from Catapult
      width            : INTEGER RANGE 3 TO 1026 := 33;           -- Catapult read/write operator width (includes data,last and user bits)
      fifo_sz          : INTEGER RANGE 0 TO 128 := 0;            -- Fifo size
      AXI4_DATA_WIDTH  : INTEGER RANGE 8 TO 1024 := 32;           -- AXI4 Bus width
      AXI4_USER_WIDTH  : INTEGER RANGE 1 TO 8 := 1                -- AXI4 User data width
    );
    PORT(
      -- AXI-4 Master Clock/Reset
      ACLK      : IN   std_logic;                                          -- clk src   Rising edge clock
      ARESETn   : IN   std_logic;                                          -- rst src   Active LOW asynchronous reset
      -- AXI-4 Stream interface input                                      -- Src->Dst  Description
      sTVALID   : IN   std_logic;                                          -- M->S      Indicates master is driving a valid transfer
      sTREADY   : OUT  std_logic;                                          -- S->M      Indicates slave can accept a transfer
      sTDATA    : IN   std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);       -- M->S      Primary payload (width-1 must be multiple of 8)
      sTSTRB    : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0);   -- M->S      1 indicates data byte, 0 indicates position byte
      sTKEEP    : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0);   -- M->S      1 valid byte, 0 indicates null byte
      sTLAST    : IN   std_logic;                                          -- M->S      Indicates boundary of a packet
      sTUSER    : IN   std_logic_vector(AXI4_USER_WIDTH-1 downto 0);       -- M->S      Optional user-defined sideband data
      -- AXI-4 Stream interface output                                     -- Src->Dst  Description
      mTVALID   : OUT  std_logic;                                          -- M->S      Indicates master is driving a valid transfer
      mTREADY   : IN   std_logic;                                          -- S->M      Indicates slave can accept a transfer
      mTDATA    : OUT  std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);       -- M->S      Primary payload (width-1 must be multiple of 8)
      mTSTRB    : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0);   -- M->S      1 indicates data byte, 0 indicates position byte
      mTKEEP    : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0);   -- M->S      1 valid byte, 0 indicates null byte
      mTLAST    : OUT  std_logic;                                          -- M->S      Indicates boundary of a packet
      mTUSER    : OUT  std_logic_vector(AXI4_USER_WIDTH-1 downto 0)        -- M->S      Optional user-defined sideband data
    );
  END COMPONENT;

  COMPONENT ccs_axi4svideo_in
    GENERIC(
      width            : INTEGER RANGE 3 TO 1026 := 33;           -- Catapult read/write operator width (includes data,last and user bits)
      AXI4_DATA_WIDTH  : INTEGER RANGE 8 TO 1024 := 32            -- AXI4 Bus width
    );
    PORT(
      -- AXI-4 Master Clock/Reset
      ACLK      : IN   std_logic;                                        -- clk src   Rising edge clock
      ARESETn   : IN   std_logic;                                        -- rst src   Active LOW asynchronous reset
      -- AXI-4 Stream interface                                          -- Src->Dst  Description
      TVALID    : IN   std_logic;                                        -- M->S      Indicates master is driving a valid transfer
      TREADY    : OUT  std_logic;                                        -- S->M      Indicates slave can accept a transfer
      TDATA     : IN   std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);     -- M->S      Primary payload (width-1 must be multiple of 8)
      TSTRB     : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 indicates data byte, 0 indicates position byte
      TKEEP     : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 valid byte, 0 indicates null byte
      TLAST     : IN   std_logic;                                        -- M->S      End-of-line
      TUSER     : IN   std_logic;                                        -- M->S      Start-of-frame
      -- Catapult interface (equiv to mgc_in_wire_wait)
      d         : OUT  std_logic_vector(width-1 downto 0);               -- d  - msb TLAST TUSER TDATA(...) lsb
      vd        : OUT  std_logic;                                        -- vd - TVALID
      ld        : IN   std_logic                                         -- ld - TREADY
    );
  END COMPONENT;

  COMPONENT ccs_axi4svideo_out
    GENERIC(
      width            : INTEGER RANGE 3 TO 1026 := 33;           -- Catapult read/write operator width (includes data,last and user bits)
      AXI4_DATA_WIDTH  : INTEGER RANGE 8 TO 1024 := 32            -- AXI4 Bus width
    );
    PORT(
      -- AXI-4 Master Clock/Reset
      ACLK      : IN   std_logic;                                        -- clk src   Rising edge clock
      ARESETn   : IN   std_logic;                                        -- rst src   Active LOW asynchronous reset
      -- AXI-4 Stream interface                                          -- Src->Dst  Description
      TVALID    : OUT  std_logic;                                        -- M->S      Indicates master is driving a valid transfer
      TREADY    : IN   std_logic;                                        -- S->M      Indicates slave can accept a transfer
      TDATA     : OUT  std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);     -- M->S      Primary payload (width-1 must be multiple of 8)
      TSTRB     : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 indicates data byte, 0 indicates position byte
      TKEEP     : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0); -- M->S      1 valid byte, 0 indicates null byte
      TLAST     : OUT  std_logic;                                        -- M->S      End-of-line
      TUSER     : OUT  std_logic;                                        -- M->S      Start-of-frame
      -- Catapult interface (equiv to mgc_out_stdreg_wait)
      d         : IN   std_logic_vector(width-1 downto 0);               -- d  - msb TLAST TUSER TDATA(...) lsb
      vd        : OUT  std_logic;                                        -- vd - TREADY
      ld        : IN   std_logic                                         -- ld - TVALID
    );
  END COMPONENT;

  COMPONENT ccs_axi4svideo_pipe
    GENERIC(
      rscid            : INTEGER := 1;                                 -- Resource ID from Catapult
      width            : INTEGER RANGE 3 TO 1026 := 33;           -- Catapult read/write operator width (includes data,last and user bits)
      fifo_sz          : INTEGER RANGE 0 TO 128 := 0;            -- Fifo size
      AXI4_DATA_WIDTH  : INTEGER RANGE 8 TO 1024 := 32            -- AXI4 Bus width
    );
    PORT(
      -- AXI-4 Master Clock/Reset
      ACLK      : IN   std_logic;                                          -- clk src   Rising edge clock
      ARESETn   : IN   std_logic;                                          -- rst src   Active LOW asynchronous reset
      -- AXI-4 Stream interface input                                      -- Src->Dst  Description
      sTVALID   : IN   std_logic;                                          -- M->S      Indicates master is driving a valid transfer
      sTREADY   : OUT  std_logic;                                          -- S->M      Indicates slave can accept a transfer
      sTDATA    : IN   std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);       -- M->S      Primary payload (width-1 must be multiple of 8)
      sTSTRB    : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0);   -- M->S      1 indicates data byte, 0 indicates position byte
      sTKEEP    : IN   std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0);   -- M->S      1 valid byte, 0 indicates null byte
      sTLAST    : IN   std_logic;                                          -- M->S      End-of-line
      sTUSER    : IN   std_logic;                                          -- M->S      Start-of-frame
      -- AXI-4 Stream interface output                                     -- Src->Dst  Description
      mTVALID   : OUT  std_logic;                                          -- M->S      Indicates master is driving a valid transfer
      mTREADY   : IN   std_logic;                                          -- S->M      Indicates slave can accept a transfer
      mTDATA    : OUT  std_logic_vector(AXI4_DATA_WIDTH-1 downto 0);       -- M->S      Primary payload (width-1 must be multiple of 8)
      mTSTRB    : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0);   -- M->S      1 indicates data byte, 0 indicates position byte
      mTKEEP    : OUT  std_logic_vector((AXI4_DATA_WIDTH/8)-1 downto 0);   -- M->S      1 valid byte, 0 indicates null byte
      mTLAST    : OUT  std_logic;                                          -- M->S      End-of-line
      mTUSER    : OUT  std_logic                                           -- M->S      Start-of-frame
    );
  END COMPONENT;

  -- ==============================================================
  -- AXI-4 Bus Components

  -- Used to define the AXI-4 bus definition (direction of signals is from the slave's perspective)
    -- Pin directions are based on the usage of this busdef as a "master" driving an input slave.
    -- To use the bus in the reverse direction set the interface to "slave".
  COMPONENT axi4_busdef -- 
    GENERIC(   
      host_tidw      : INTEGER RANGE 1 TO 11 := 4;            -- Width of transaction ID fields
      host_userw     : INTEGER RANGE 1 TO 16 := 4;            -- Width of user-defined signals
      ADDR_WIDTH     : INTEGER RANGE 1 TO 64 := 32;           -- Host address width
      DATA_WIDTH     : INTEGER RANGE 8 TO 64 := 8             -- Host data width
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                 -- Rising edge clock
      ARESETn    : IN   std_logic;                                 -- Active LOW synchronous reset

      -- ============== AXI4 Write Address Channel Signals
      AWID       : OUT  std_logic_vector(host_tidw-1 downto 0);    -- Write address ID
      AWADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);      -- Write address
      AWLEN      : OUT  std_logic_vector(7 downto 0);              -- Write burst length    - must always be 0 in AXI4-Lite
      AWSIZE     : OUT  std_logic_vector(1 downto 0);              -- Write burst size      - must equal host_dw_bytes-2
      AWBURST    : OUT  std_logic_vector(1 downto 0);              -- Write burst mode      - must always be 0 (fixed mode) in AXI4-Lite
      AWLOCK     : OUT  std_logic;                                 -- Lock type             - must always be 0 (Normal access) in AXI4-Lite
      AWCACHE    : OUT  std_logic_vector(3 downto 0);              -- Memory type           - must always be 0 (Non-modifiable, Non-bufferable) in AXI4-Lite
      AWPROT     : OUT  std_logic_vector(2 downto 0);              -- Protection Type       - ignored in this model
      AWQOS      : OUT  std_logic_vector(3 downto 0);              -- Quality of Service
      AWREGION   : OUT  std_logic_vector(3 downto 0);              -- Region identifier
      AWUSER     : OUT  std_logic_vector(host_userw-1 downto 0);   -- User signal
      AWVALID    : OUT  std_logic;                                 -- Write address valid
      AWREADY    : IN   std_logic;                                 -- Write address ready (slave is ready to accept AWADDR)
      
      -- ============== AXI4 Write Data Channel
      WDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0); -- Write data
      WSTRB      : OUT  std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe (bytewise) - ignored in AXI-4 Lite
      WLAST      : OUT  std_logic;                                        -- Write last
      WUSER      : OUT  std_logic_vector(host_userw-1 downto 0);          -- User signal
      WVALID     : OUT  std_logic;                                        -- Write data is valid
      WREADY     : IN   std_logic;                                        -- Write ready (slave is ready to accept WDATA)
      
      -- ============== AXI4 Write Response Channel Signals
      BID        : IN   std_logic_vector(host_tidw-1 downto 0);    -- Response ID tag
      BRESP      : IN   std_logic_vector(1 downto 0);              -- Write response (of slave) - only OKAY, SLVERR, DECERR supported in AXI-4 Lite
      BUSER      : IN   std_logic_vector(host_userw-1 downto 0);   -- User signal
      BVALID     : IN   std_logic;                                 -- Write response valid (slave accepted WDATA)
      BREADY     : OUT  std_logic;                                 -- Response ready (master can accept slave's write response)
      
      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(host_tidw-1 downto 0);    -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);      -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);              -- Read burst length     - must always be 0 in AXI4-Lite
      ARSIZE     : OUT  std_logic_vector(1 downto 0);              -- Read burst size       - must equal host_dw_bytes-2
      ARBURST    : OUT  std_logic_vector(1 downto 0);              -- Read burst mode       - must always be 0 (fixed mode) in AXI4-Lite
      ARLOCK     : OUT  std_logic;                                 -- Lock type             - must always be 0 (Normal access) in AXI4-Lite
      ARCACHE    : OUT  std_logic_vector(3 downto 0);              -- Memory type           - must always be 0 (Non-modifiable, Non-bufferable) in AXI4-Lite
      ARPROT     : OUT  std_logic_vector(2 downto 0);              -- Protection Type       - ignored in this model
      ARQOS      : OUT  std_logic_vector(3 downto 0);              -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);              -- Region identifier
      ARUSER     : OUT  std_logic_vector(host_userw-1 downto 0);   -- User signal
      ARVALID    : OUT  std_logic;                                 -- Read address valid
      ARREADY    : IN   std_logic;                                 -- Read address ready (slave is ready to accept ARADDR)
      
      -- ============== AXI4 Read Data Channel Signals
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0); -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                      -- Read response (of slave) - only OKAY, SLVERR, DECERR supported in AXI-4 Lite
      RVALID     : IN   std_logic;                                         -- Read valid (slave providing RDATA)
      RREADY     : OUT  std_logic;                                         -- Read ready (master ready to receive RDATA)
      RID        : OUT  std_logic_vector(host_tidw-1 downto 0);            -- Read ID tag
      RLAST      : IN   std_logic;                                         -- Read last
      RUSER      : IN   std_logic_vector(host_userw-1 downto 0)            -- User signal
    );
  END COMPONENT;

  -- AXI4 Lite GPIO with CDC
  COMPONENT ccs_axi4_lite_slave_cdc
    GENERIC(
      rscid          : INTEGER               := 1;            -- Required resource ID parameter
      op_width       : INTEGER RANGE 1 TO 64 := 1;            -- Operator width (dummy parameter)
      cwidth         : INTEGER RANGE 1 TO 256 := 32;          -- Internal register width
      nopreload      : INTEGER RANGE 0 TO 1 := 0;             -- 1=disable required preload before Catapult can read
      ADDR_WIDTH     : INTEGER RANGE 12 TO 32 := 32;          -- AXI4-Lite host address width
      DATA_WIDTH     : INTEGER RANGE 32 TO 64 := 32           -- AXI4-Lite host data width (must be 32 or 64)
    );
    PORT(
      -- AXI-4 Lite Interface
      ACLK       : IN   std_logic;                                 -- AXI-4 Bus Clock - Rising edge
      ARESETn    : IN   std_logic;                                 -- Active LOW synchronous reset
      -- ============== AXI4-Lite Write Address Channel Signals
      AWADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);               -- Write address
      AWVALID    : IN   std_logic;                                          -- Write address valid
      AWREADY    : OUT  std_logic;                                          -- Write address ready (slave is ready to accept AWADDR)
      -- ============== AXI4-Lite Write Data Channel
      WDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0); -- Write data
      WSTRB      : IN   std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe (bytewise) - ignored in AXI-4 Lite
      WVALID     : IN   std_logic;                                          -- Write data is valid
      WREADY     : OUT  std_logic;                                          -- Write ready (slave is ready to accept WDATA)
      -- ============== AXI4-Lite Write Response Channel Signals
      BRESP      : OUT  std_logic_vector(1 downto 0);                       -- Write response (of slave) - only OKAY, SLVERR, DECERR supported in AXI-4 Lite
      BVALID     : OUT  std_logic;                                          -- Write response valid (slave accepted WDATA)
      BREADY     : IN   std_logic;                                          -- Response ready (master can accept slave's write response)
      -- ============== AXI4-Lite Read Address Channel Signals
      ARADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);               -- Read address
      ARVALID    : IN   std_logic;                                          -- Read address valid
      ARREADY    : OUT  std_logic;                                          -- Read address ready (slave is ready to accept ARADDR)
      -- ============== AXI4-Lite Read Data Channel Signals
      RDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0); -- Read data
      RRESP      : OUT  std_logic_vector(1 downto 0);                       -- Read response (of slave) - only OKAY, SLVERR, DECERR supported in AXI-4 Lite
      RVALID     : OUT  std_logic;                                          -- Read valid (slave providing RDATA)
      RREADY     : IN   std_logic;                                          -- Read ready (master ready to receive RDATA)

      -- Catapult interface assuming sidebyside packing 
      clk        : IN   std_logic;                                     -- Catapult Clock
      arst_n     : IN   std_logic;                                     -- Reset
--    d_from_ccs : IN   std_logic_vector(cwidth-1 downto 0);           -- Data out of Catapult block
--    d_from_vld : IN   std_logic;                                     -- Data out is valid
      d_to_ccs   : OUT  std_logic_vector(cwidth-1 downto 0)            -- Data into Catapult bloc
    );
  END COMPONENT;

  
  -- AXI4 Lite Slave Output
  COMPONENT ccs_axi4_lite_slave_out
    GENERIC(
      rscid          : INTEGER               := 1;            -- Required resource ID parameter
      op_width       : INTEGER RANGE 1 TO 64 := 1;            -- Operator width (dummy parameter)
      cwidth         : INTEGER RANGE 1 TO 256 := 32;          -- Internal register width
      nopreload      : INTEGER RANGE 0 TO 1 := 0;             -- 1=disable required preload before Catapult can read
      ADDR_WIDTH     : INTEGER RANGE 12 TO 32 := 32;          -- AXI4-Lite host address width
      DATA_WIDTH     : INTEGER RANGE 32 TO 64 := 32           -- AXI4-Lite host data width (must be 32 or 64)
    );
    PORT(
      -- AXI-4 Lite Interface
      ACLK       : IN   std_logic;                                     -- AXI-4 Bus Clock - Rising edge
      ARESETn    : IN   std_logic;                                     -- Active LOW synchronous reset
      -- ============== AXI4-Lite Write Address Channel Signals
      AWADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Write address
      AWVALID    : IN   std_logic;                                     -- Write address valid
      AWREADY    : OUT  std_logic;                                     -- Write address ready (slave is ready to accept AWADDR)
      --AWLEN      : IN   std_logic_vector(7 downto 0);                -- Write burst length    - must always be 0 in AXI4-Lite
      --AWSIZE     : IN   std_logic_vector(1 downto 0);                -- Write burst size      - must equal host_dw_bytes-2
      --AWBURST    : IN   std_logic_vector(1 downto 0);                -- Write burst mode      - must always be 0 (fixed mode) in AXI4-Lite
      --AWLOCK     : IN   std_logic;                                   -- Lock type             - must always be 0 (Normal access) in AXI4-Lite
      --AWCACHE    : IN   std_logic_vector(3 downto 0);                -- Memory type           - must always be 0 (Non-modifiable, Non-bufferable) in AXI4-Lite
      --AWPROT     : IN   std_logic_vector(2 downto 0);                -- Protection Type       - ignored in this model
      -- ============== AXI4-Lite Write Data Channel
      WDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);       -- Write data
      WSTRB      : IN   std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe (bytewise) - ignored in AXI-4 Lite
      WVALID     : IN   std_logic;                                     -- Write data is valid
      WREADY     : OUT  std_logic;                                     -- Write ready (slave is ready to accept WDATA)
      -- ============== AXI4-Lite Write Response Channel Signals
      BRESP      : OUT  std_logic_vector(1 downto 0);                  -- Write response (of slave) - only OKAY, SLVERR, DECERR supported in AXI-4 Lite
      BVALID     : OUT  std_logic;                                     -- Write response valid (slave accepted WDATA)
      BREADY     : IN   std_logic;                                     -- Response ready (master can accept slave's write response)
      -- ============== AXI4-Lite Read Address Channel Signals
      ARADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Read address
      ARVALID    : IN   std_logic;                                     -- Read address valid
      ARREADY    : OUT  std_logic;                                     -- Read address ready (slave is ready to accept ARADDR)
      --ARLEN      : IN   std_logic_vector(7 downto 0);                -- Read burst length     - must always be 0 in AXI4-Lite
      --ARSIZE     : IN   std_logic_vector(1 downto 0);                -- Read burst size       - must equal host_dw_bytes-2
      --ARBURST    : IN   std_logic_vector(1 downto 0);                -- Read burst mode       - must always be 0 (fixed mode) in AXI4-Lite
      --ARLOCK     : IN   std_logic;                                   -- Lock type             - must always be 0 (Normal access) in AXI4-Lite
      --ARCACHE    : IN   std_logic_vector(3 downto 0);                -- Memory type           - must always be 0 (Non-modifiable, Non-bufferable) in AXI4-Lite
      --ARPROT     : IN   std_logic_vector(2 downto 0);                -- Protection Type       - ignored in this model
      -- ============== AXI4-Lite Read Data Channel Signals
      RDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);       -- Read data
      RRESP      : OUT  std_logic_vector(1 downto 0);                  -- Read response (of slave) - only OKAY, SLVERR, DECERR supported in AXI-4 Lite
      RVALID     : OUT  std_logic;                                     -- Read valid (slave providing RDATA)
      RREADY     : IN   std_logic;                                     -- Read ready (master ready to receive RDATA)

      -- Catapult interface assuming sidebyside packing 
      d_from_ccs : IN   std_logic_vector(cwidth-1 downto 0);           -- Data out of Catapult block
      d_from_vld : IN   std_logic                                      -- Data out is valid
--    d_to_ccs   : OUT  std_logic_vector(cwidth-1 downto 0)            -- Data into Catapult bloc
    );
  END COMPONENT;

  COMPONENT ccs_axi4_slave_mem
    GENERIC(
      rscid           : integer                 := 1;    -- Resource ID
      -- Catapult Bus Configuration generics
      depth           : integer                 := 16;   -- Number of addressable elements (up to 20bit address)
      op_width        : integer range 1 to 1024 := 1;    -- dummy parameter for cwidth calculation
      cwidth          : integer range 1 to 1024 := 8;    -- Internal memory data width
      addr_w          : integer range 1 to 64   := 4;    -- Catapult address bus widths
      nopreload       : integer range 0 to 1    := 0;    -- 1= no preload before Catapult can read
      rst_ph          : integer range 0 to 1    := 0;    -- Reset phase.  1= Positive edge. Default is AXI negative edge
      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;   -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;   -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;    -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;    -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;    -- AXI4 Region Map (ignored in this model)
      wBASE_ADDRESS   : integer                 := 0;    -- AXI4 write channel base address alignment based on data bus width
      rBASE_ADDRESS   : integer                 := 0     -- AXI4 read channel base address alignment based on data bus width
     );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                     -- Rising edge clock
      ARESETn    : IN   std_logic;                                     -- Active LOW asynchronous reset

      -- ============== AXI4 Write Address Channel Signals
      AWID       : IN   std_logic_vector(ID_WIDTH-1 downto 0);         -- Write address ID
      AWADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Write address
      AWLEN      : IN   std_logic_vector(7 downto 0);                  -- Write burst length
      AWSIZE     : IN   std_logic_vector(2 downto 0);                  -- Write burst size
      AWBURST    : IN   std_logic_vector(1 downto 0);                  -- Write burst mode
      AWLOCK     : IN   std_logic;                                     -- Lock type
      AWCACHE    : IN   std_logic_vector(3 downto 0);                  -- Memory type
      AWPROT     : IN   std_logic_vector(2 downto 0);                  -- Protection Type
      AWQOS      : IN   std_logic_vector(3 downto 0);                  -- Quality of Service
      AWREGION   : IN   std_logic_vector(3 downto 0);                  -- Region identifier
      AWUSER     : IN   std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
      AWVALID    : IN   std_logic;                                     -- Write address valid
      AWREADY    : OUT  std_logic;                                     -- Write address ready (slave is ready to accept AWADDR)

      -- ============== AXI4 Write Data Channel
      WDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);       -- Write data
      WSTRB      : IN   std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe (bytewise)
      WLAST      : IN   std_logic;                                     -- Write last
      WUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
      WVALID     : IN   std_logic;                                     -- Write data is valid
      WREADY     : OUT  std_logic;                                     -- Write ready (slave is ready to accept WDATA)
      
      -- ============== AXI4 Write Response Channel Signals
      BID        : OUT  std_logic_vector(ID_WIDTH-1 downto 0);         -- Response ID tag
      BRESP      : OUT  std_logic_vector(1 downto 0);                  -- Write response (of slave)
      BUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
      BVALID     : OUT  std_logic;                                     -- Write response valid (slave accepted WDATA)
      BREADY     : IN   std_logic;                                     -- Response ready (master can accept slave's write response)
      
      -- ============== AXI4 Read Address Channel Signals
      ARID       : IN   std_logic_vector(ID_WIDTH-1 downto 0);         -- Read address ID
      ARADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Read address
      ARLEN      : IN   std_logic_vector(7 downto 0);                  -- Read burst length
      ARSIZE     : IN   std_logic_vector(2 downto 0);                  -- Read burst size
      ARBURST    : IN   std_logic_vector(1 downto 0);                  -- Read burst mode
      ARLOCK     : IN   std_logic;                                     -- Lock type
      ARCACHE    : IN   std_logic_vector(3 downto 0);                  -- Memory type
      ARPROT     : IN   std_logic_vector(2 downto 0);                  -- Protection Type
      ARQOS      : IN   std_logic_vector(3 downto 0);                  -- Quality of Service
      ARREGION   : IN   std_logic_vector(3 downto 0);                  -- Region identifier
      ARUSER     : IN   std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
      ARVALID    : IN   std_logic;                                     -- Read address valid
      ARREADY    : OUT  std_logic;                                     -- Read address ready (slave is ready to accept ARADDR)
      
      -- ============== AXI4 Read Data Channel Signals
      RID        : OUT  std_logic_vector(ID_WIDTH-1 downto 0);         -- Read ID tag
      RDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);       -- Read data
      RRESP      : OUT  std_logic_vector(1 downto 0);                  -- Read response (of slave)
      RLAST      : OUT  std_logic;                                     -- Read last
      RUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
      RVALID     : OUT  std_logic;                                     -- Read valid (slave providing RDATA)
      RREADY     : IN   std_logic;                                     -- Read ready (master ready to receive RDATA)
      
      -- Catapult interface
      s_re      : IN   std_logic;                                      -- Catapult attempting read of slave memory
      s_we      : IN   std_logic;                                      -- Catapult attempting write to slave memory
      s_raddr   : IN   std_logic_vector(addr_w-1 downto 0);            -- Catapult addressing into memory (axi_addr = base_addr + s_raddr)
      s_waddr   : IN   std_logic_vector(addr_w-1 downto 0);            -- Catapult addressing into memory (axi_addr = base_addr + s_waddr)
      s_din     : OUT  std_logic_vector(cwidth-1 downto 0);            -- Data into catapult block through this interface
      s_dout    : IN   std_logic_vector(cwidth-1 downto 0);            -- Data out to slave from catapult
      s_rrdy    : OUT  std_logic;                                      -- Read data is valid
      s_wrdy    : OUT  std_logic;                                      -- Slave memory ready for write by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                      -- component is idle - clock can be suppressed
      tr_write_done : IN std_logic;                                    -- transactor resource preload write done
      s_tdone   : IN   std_logic                                       -- Transaction_done in scverify
    );  
  END COMPONENT;

  COMPONENT ccs_axi4_master_read_core
    GENERIC(
      rscid           : integer                 := 1;      -- Resource ID
      -- Catapult Bus Configuration generics
      depth           : integer                 := 16;     -- Number of addressable elements (up to 20bit address)
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 1 to 64   := 4;      -- Catapult address bus width
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default

      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      xburstsize      : integer                 := 0;      -- Burst size for scverify transactor
      xBASE_ADDRESS   : integer                 := 0;      -- Base address for scverify transactor
      xBASE_ADDRESSU  : integer                 := 0       -- Upper word for 64-bit Base address for scverify transactor
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset
      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready
      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- Configuration interface
      cfgBaseAddress : IN  std_logic_vector(ADDR_WIDTH-1 downto 0);  
      cfgBurstSize   : IN  std_logic_vector(31 downto 0);            
      cfgTimeout     : IN  std_logic_vector(31 downto 0);            

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_raddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for read request (axi_addr = base_addr + m_raddr)
      m_rburst  : IN   std_logic_vector(31 downto 0);                   -- Read Burst length (constant rburstsize for now, future enhancement driven by operator)
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic                                        -- The component is idle. The next clk can be suppressed
    );
  END COMPONENT;
  
  COMPONENT ccs_axi4_master_read
    GENERIC(
      rscid           : integer                 := 1;      -- Resource ID
      -- Catapult Bus Configuration generics
      depth           : integer                 := 16;     -- Number of addressable elements (up to 20bit address)
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 1 to 64   := 4;      -- Catapult address bus width
      burstsize       : integer                 := 0;      -- Catapult configuration option for Read burst size
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      timeout         : integer                 := 0;      --  #cycles timeout for burst stall

      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      BASE_ADDRESS    : integer                 := 0;      -- Base address 
      BASE_ADDRESSU   : integer                 := 0       -- Upper word for 64-bit Base address 
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset
      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready
      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_raddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for read request (axi_addr = base_addr + m_raddr)
      m_rburst  : IN   std_logic_vector(31 downto 0);                   -- Read Burst length (constant rburstsize for now, future enhancement driven by operator)
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic                                        -- The component is idle. The next clk can be suppressed
    );
  END COMPONENT;
  
  COMPONENT ccs_axi4_master_write_core
    GENERIC(
      rscid           : integer                 := 1;      -- Resource ID
      -- Catapult Bus Configuration generics
      depth           : integer                 := 16;     -- Number of addressable elements (up to 20bit address)
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 1 to 64   := 4;      -- Catapult address bus width
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default

      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      xburstsize      : integer                 := 0;      -- Burst size for scverify transactor
      xBASE_ADDRESS   : integer                 := 0;      -- Base address for scverify transactor
      xBASE_ADDRESSU  : integer                 := 0       -- Upper word for 64-bit Base address for scverify transactor
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset

      -- ============== AXI4 Write Address Channel Signals
      AWID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Write address ID
      AWADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Write address
      AWLEN      : OUT  std_logic_vector(7 downto 0);                   -- Write burst length
      AWSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Write burst size
      AWBURST    : OUT  std_logic_vector(1 downto 0);                   -- Write burst mode
      AWLOCK     : OUT  std_logic;                                      -- Lock type
      AWCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      AWPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      AWQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      AWREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      AWUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      AWVALID    : OUT  std_logic;                                      -- Write address valid
      AWREADY    : IN   std_logic;                                      -- Write address ready

      -- ============== AXI4 Write Data Channel
      WDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);        -- Write data
      WSTRB      : OUT  std_logic_vector((DATA_WIDTH/8)-1 downto 0);    -- Write strobe (bytewise)
      WLAST      : OUT  std_logic;                                      -- Write last
      WUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      WVALID     : OUT  std_logic;                                      -- Write data is valid
      WREADY     : IN   std_logic;                                      -- Write ready

      -- ============== AXI4 Write Response Channel Signals
      BID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Response ID tag
      BRESP      : IN   std_logic_vector(1 downto 0);                   -- Write response
      BUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      BVALID     : IN   std_logic;                                      -- Write response valid
      BREADY     : OUT  std_logic;                                      -- Response ready

      -- Configuration interface
      cfgBaseAddress : IN  std_logic_vector(ADDR_WIDTH-1 downto 0);  
      cfgBurstSize   : IN  std_logic_vector(31 downto 0);            
      cfgTimeout     : IN  std_logic_vector(31 downto 0);            

      -- Catapult interface
      m_we      : IN   std_logic;                                       -- Catapult attempting write to memory over bus
      m_waddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for write request (axi_addr = base_addr + m_waddr)
      m_wburst  : IN   std_logic_vector(31 downto 0);                   -- Write Burst length (constant wburstsize for now, future enhancement driven by operator)
      m_dout    : IN   std_logic_vector(cwidth-1 downto 0);             -- Data out to bus from catapult (write request)
      m_wrdy    : OUT  std_logic;                                       -- Bus memory ready for write access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      -- Transactor resource interface (for SCVerify simulation only)
      m_wCaughtUp : OUT  std_logic;                                     -- wburst_in == wburst_out
      m_wstate    : OUT  std_logic_vector(2 downto 0)                   -- write_state of master
    );
  END COMPONENT;
  
  COMPONENT ccs_axi4_master_write
    GENERIC(
      rscid           : integer                 := 1;      -- Resource ID
      -- Catapult Bus Configuration generics
      depth           : integer                 := 16;     -- Number of addressable elements (up to 20bit address)
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 1 to 64   := 4;      -- Catapult address bus width
      burstsize       : integer                 := 0;      -- Catapult configuration option for write burst size
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      timeout         : integer                 := 0;      --  #cycles timeout for burst stall

      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      BASE_ADDRESS    : integer                 := 0;      -- Base address
      BASE_ADDRESSU   : integer                 := 0       -- Upper word for 64-bit Base address
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset

      -- ============== AXI4 Write Address Channel Signals
      AWID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Write address ID
      AWADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Write address
      AWLEN      : OUT  std_logic_vector(7 downto 0);                   -- Write burst length
      AWSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Write burst size
      AWBURST    : OUT  std_logic_vector(1 downto 0);                   -- Write burst mode
      AWLOCK     : OUT  std_logic;                                      -- Lock type
      AWCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      AWPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      AWQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      AWREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      AWUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      AWVALID    : OUT  std_logic;                                      -- Write address valid
      AWREADY    : IN   std_logic;                                      -- Write address ready

      -- ============== AXI4 Write Data Channel
      WDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);        -- Write data
      WSTRB      : OUT  std_logic_vector((DATA_WIDTH/8)-1 downto 0);    -- Write strobe (bytewise)
      WLAST      : OUT  std_logic;                                      -- Write last
      WUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      WVALID     : OUT  std_logic;                                      -- Write data is valid
      WREADY     : IN   std_logic;                                      -- Write ready

      -- ============== AXI4 Write Response Channel Signals
      BID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Response ID tag
      BRESP      : IN   std_logic_vector(1 downto 0);                   -- Write response
      BUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      BVALID     : IN   std_logic;                                      -- Write response valid
      BREADY     : OUT  std_logic;                                      -- Response ready

      -- Catapult interface
      m_we      : IN   std_logic;                                       -- Catapult attempting write to memory over bus
      m_waddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for write request (axi_addr = base_addr + m_waddr)
      m_wburst  : IN   std_logic_vector(31 downto 0);                   -- Write Burst length (constant wburstsize for now, future enhancement driven by operator)
      m_dout    : IN   std_logic_vector(cwidth-1 downto 0);             -- Data out to bus from catapult (write request)
      m_wrdy    : OUT  std_logic;                                       -- Bus memory ready for write access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      -- Transactor resource interface (for SCVerify simulation only)
      m_wCaughtUp : OUT  std_logic;                                     -- wburst_in == wburst_out
      m_wstate    : OUT  std_logic_vector(2 downto 0)                   -- write_state of master
    );
  END COMPONENT;
  
  COMPONENT ccs_axi4_master_core
    GENERIC(
      rscid           : integer                 := 1;      -- Resource ID
      -- Catapult Bus Configuration generics
      depth           : integer                 := 16;     -- Number of addressable elements (up to 20bit address)
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 1 to 64   := 4;      -- Catapult address bus width
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      xwburstsize     : integer                 := 0;      -- wBurst size for scverify transactor
      xrburstsize     : integer                 := 0;      -- rBurst size for scverify transactor
      xwBASE_ADDRESS  : integer                 := 0;      -- wBase address for scverify transactor
      xrBASE_ADDRESS  : integer                 := 0;      -- rBase address for scverify transactor
      xwBASE_ADDRESSU : integer                 := 0;      -- Upper word for 64-bit wBase address for scverify transactor
      xrBASE_ADDRESSU : integer                 := 0       -- Upper word for 64-bit rBase address for scverify transactor
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset
      -- ============== AXI4 Write Address Channel Signals
      AWID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Write address ID
      AWADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Write address
      AWLEN      : OUT  std_logic_vector(7 downto 0);                   -- Write burst length
      AWSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Write burst size
      AWBURST    : OUT  std_logic_vector(1 downto 0);                   -- Write burst mode
      AWLOCK     : OUT  std_logic;                                      -- Lock type
      AWCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      AWPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      AWQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      AWREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      AWUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      AWVALID    : OUT  std_logic;                                      -- Write address valid
      AWREADY    : IN   std_logic;                                      -- Write address ready
      -- ============== AXI4 Write Data Channel
      WDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);        -- Write data
      WSTRB      : OUT  std_logic_vector((DATA_WIDTH/8)-1 downto 0);    -- Write strobe (bytewise)
      WLAST      : OUT  std_logic;                                      -- Write last
      WUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      WVALID     : OUT  std_logic;                                      -- Write data is valid
      WREADY     : IN   std_logic;                                      -- Write ready
      -- ============== AXI4 Write Response Channel Signals
      BID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Response ID tag
      BRESP      : IN   std_logic_vector(1 downto 0);                   -- Write response
      BUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      BVALID     : IN   std_logic;                                      -- Write response valid
      BREADY     : OUT  std_logic;                                      -- Response ready
      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready
      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- Configuration interface
      cfgwBaseAddress : IN  std_logic_vector(ADDR_WIDTH-1 downto 0);  
      cfgrBaseAddress : IN  std_logic_vector(ADDR_WIDTH-1 downto 0);  
      cfgwBurstSize  : IN  std_logic_vector(31 downto 0);            
      cfgrBurstSize  : IN  std_logic_vector(31 downto 0);            
      cfgTimeout     : IN  std_logic_vector(31 downto 0);

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_we      : IN   std_logic;                                       -- Catapult attempting write to memory over bus
      m_waddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for write request (axi_addr = base_addr + m_waddr)
      m_raddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for read request (axi_addr = base_addr + m_raddr)
      m_wburst  : IN   std_logic_vector(31 downto 0);                   -- Write Burst length (constant wburstsize for now, future enhancement driven by operator)
      m_rburst  : IN   std_logic_vector(31 downto 0);                   -- Read Burst length (constant rburstsize for now, future enhancement driven by operator)
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_dout    : IN   std_logic_vector(cwidth-1 downto 0);             -- Data out to bus from catapult (write request)
      m_wrdy    : OUT  std_logic;                                       -- Bus memory ready for write access by Catapult (1=ready)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      -- Transactor resource interface (for SCVerify simulation only)
      m_wCaughtUp : OUT  std_logic;                                     -- wburst_in == wburst_out
      m_wstate    : OUT  std_logic_vector(2 downto 0)                   -- write_state of master
    );
  END COMPONENT;

  COMPONENT ccs_axi4_master_cfg
    GENERIC(
      rscid           : integer                 := 1;      -- Resource ID
      -- Catapult Bus Configuration generics
      depth           : integer                 := 16;     -- Number of addressable elements (up to 20bit address)
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 1 to 64   := 4;      -- Catapult address bus width
      cburst_mode     : integer range 0 to 2    := 0;      -- Burst mode (0==use w/rburstsize, 1==configuration port)
      wburstsize      : integer                 := 0;      -- Catapult configuration option for Write burst size
      rburstsize      : integer                 := 0;      -- Catapult configuration option for Read burst size
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      use_go          : integer range 0 to 1    := 0;      -- Use the cfgBus stop/go mechanism.  Default not.

      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      base_addr_mode  : integer range 0 to 2    := 0;      -- Where base address is specified (0=param, 1=cfg, 2=port)
      wBASE_ADDRESS   : integer                 := 0;      -- AXI4 write channel base address
      rBASE_ADDRESS   : integer                 := 0;      -- AXI4 read channel base address
      wBASE_ADDRESSU  : integer                 := 0;      -- Upper word of 64-bit AXI4 write channel base address
      rBASE_ADDRESSU  : integer                 := 0       -- Upper word of 64-bit AXI4 read channel base address
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset
      -- ============== AXI4 Write Address Channel Signals
      AWID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Write address ID
      AWADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Write address
      AWLEN      : OUT  std_logic_vector(7 downto 0);                   -- Write burst length
      AWSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Write burst size
      AWBURST    : OUT  std_logic_vector(1 downto 0);                   -- Write burst mode
      AWLOCK     : OUT  std_logic;                                      -- Lock type
      AWCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      AWPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      AWQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      AWREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      AWUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      AWVALID    : OUT  std_logic;                                      -- Write address valid
      AWREADY    : IN   std_logic;                                      -- Write address ready
      -- ============== AXI4 Write Data Channel
      WDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);        -- Write data
      WSTRB      : OUT  std_logic_vector((DATA_WIDTH/8)-1 downto 0);    -- Write strobe (bytewise)
      WLAST      : OUT  std_logic;                                      -- Write last
      WUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      WVALID     : OUT  std_logic;                                      -- Write data is valid
      WREADY     : IN   std_logic;                                      -- Write ready
      -- ============== AXI4 Write Response Channel Signals
      BID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Response ID tag
      BRESP      : IN   std_logic_vector(1 downto 0);                   -- Write response
      BUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      BVALID     : IN   std_logic;                                      -- Write response valid
      BREADY     : OUT  std_logic;                                      -- Response ready
      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready
      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- AXI-lite slave interface to program base_addr - address 0, 1, 2
      cfgAWADDR  : IN  std_logic_vector(31 downto 0);
      cfgAWVALID : IN  std_logic;
      cfgAWREADY : OUT std_logic;
      cfgWDATA   : IN  std_logic_vector(31 downto 0);
      cfgWSTRB   : IN  std_logic_vector(3 downto 0);
      cfgWVALID  : IN  std_logic;
      cfgWREADY  : OUT std_logic;
      cfgBRESP   : OUT std_logic_vector(1 downto 0);
      cfgBVALID  : OUT std_logic;
      cfgBREADY  : IN  std_logic;
      cfgARADDR  : IN  std_logic_vector(31 downto 0);
      cfgARVALID : IN  std_logic;
      cfgARREADY : OUT std_logic;
      cfgRDATA   : OUT std_logic_vector(31 downto 0);
      cfgRRESP   : OUT std_logic_vector(1 downto 0);
      cfgRVALID  : OUT std_logic;
      cfgRREADY  : IN  std_logic;

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_we      : IN   std_logic;                                       -- Catapult attempting write to memory over bus
      m_waddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for write request (axi_addr = base_addr + m_waddr)
      m_raddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for read request (axi_addr = base_addr + m_raddr)
      m_wburst  : IN   std_logic_vector(31 downto 0);                   -- Write Burst length (constant wburstsize for now, future enhancement driven by operator)
      m_rburst  : IN   std_logic_vector(31 downto 0);                   -- Read Burst length (constant rburstsize for now, future enhancement driven by operator)
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_dout    : IN   std_logic_vector(cwidth-1 downto 0);             -- Data out to bus from catapult (write request)
      m_wrdy    : OUT  std_logic;                                       -- Bus memory ready for write access by Catapult (1=ready)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      -- Transactor resource interface (for SCVerify simulation only)
      m_wCaughtUp : OUT  std_logic;                                     -- wburst_in == wburst_out
      m_wstate    : OUT  std_logic_vector(2 downto 0)                   -- write_state of master
    );
  END COMPONENT;

  COMPONENT ccs_axi4_master
    GENERIC(
      rscid           : integer                 := 1;      -- Resource ID
      -- Catapult Bus Configuration generics
      depth           : integer                 := 16;     -- Number of addressable elements (up to 20bit address)
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 1 to 64   := 4;      -- Catapult address bus width
      wburstsize      : integer                 := 0;      -- Catapult configuration option for Write burst size
      rburstsize      : integer                 := 0;      -- Catapult configuration option for Read burst size
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      timeout         : integer                 := 0;      --  #cycles timeout for burst stall

      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      wBASE_ADDRESS    : integer                := 0;      -- AXI4 write channel base address
      rBASE_ADDRESS    : integer                := 0;      -- AXI4 read channel base address
      wBASE_ADDRESSU   : integer                := 0;      -- Upper word for 64-bit AXI4 write channel base address
      rBASE_ADDRESSU   : integer                := 0       -- Upper word for 64-bit AXI4 read channel base addressable
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset
      -- ============== AXI4 Write Address Channel Signals
      AWID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Write address ID
      AWADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Write address
      AWLEN      : OUT  std_logic_vector(7 downto 0);                   -- Write burst length
      AWSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Write burst size
      AWBURST    : OUT  std_logic_vector(1 downto 0);                   -- Write burst mode
      AWLOCK     : OUT  std_logic;                                      -- Lock type
      AWCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      AWPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      AWQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      AWREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      AWUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      AWVALID    : OUT  std_logic;                                      -- Write address valid
      AWREADY    : IN   std_logic;                                      -- Write address ready
      -- ============== AXI4 Write Data Channel
      WDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);        -- Write data
      WSTRB      : OUT  std_logic_vector((DATA_WIDTH/8)-1 downto 0);    -- Write strobe (bytewise)
      WLAST      : OUT  std_logic;                                      -- Write last
      WUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      WVALID     : OUT  std_logic;                                      -- Write data is valid
      WREADY     : IN   std_logic;                                      -- Write ready
      -- ============== AXI4 Write Response Channel Signals
      BID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Response ID tag
      BRESP      : IN   std_logic_vector(1 downto 0);                   -- Write response
      BUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      BVALID     : IN   std_logic;                                      -- Write response valid
      BREADY     : OUT  std_logic;                                      -- Response ready
      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready
      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_we      : IN   std_logic;                                       -- Catapult attempting write to memory over bus
      m_waddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for write request (axi_addr = base_addr + m_waddr)
      m_raddr   : IN   std_logic_vector(addr_w    -1 downto 0);         -- Address for read request (axi_addr = base_addr + m_raddr)
      m_wburst  : IN   std_logic_vector(31 downto 0);                   -- Write Burst length (constant wburstsize for now, future enhancement driven by operator)
      m_rburst  : IN   std_logic_vector(31 downto 0);                   -- Read Burst length (constant rburstsize for now, future enhancement driven by operator)
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_dout    : IN   std_logic_vector(cwidth-1 downto 0);             -- Data out to bus from catapult (write request)
      m_wrdy    : OUT  std_logic;                                       -- Bus memory ready for write access by Catapult (1=ready)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      -- Transactor resource interface (for SCVerify simulation only)
      m_wCaughtUp : OUT  std_logic;                                     -- wburst_in == wburst_out
      m_wstate    : OUT  std_logic_vector(2 downto 0)                   -- write_state of master
    );
  END COMPONENT;

COMPONENT ccs_axi4_master_instream_core
    GENERIC(
      rscid           : integer                 := 1;     -- Resource ID
      -- Catapult Bus Configuration generics
      frame_size      : integer                 := 16;     -- Number of elements in the frame to be streamed
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 0 to 64   := 4;      -- Catapult address bus width
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      
      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      xburstsize      : integer                 := 0;      -- Burst size for scverify transactor
      xBASE_ADDRESS   : integer                 := 0;      -- Base address for scverify transactor
      xBASE_ADDRESSU  : integer                 := 0       -- Upper word for 64-bit Base address for scverify transactor
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset

      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready

      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- Configuration interface
      cfgBaseAddress : IN  std_logic_vector(ADDR_WIDTH-1 downto 0);  
      cfgBurstSize   : IN  std_logic_vector(31 downto 0);            
      cfgTimeout     : IN  std_logic_vector(31 downto 0);            

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      rdy       : OUT  std_logic                                        -- For transactor
    );

END COMPONENT;

COMPONENT ccs_axi4_master_outstream_core
    GENERIC(
      rscid           : integer;                           -- Resource ID
      -- Catapult Bus Configuration generics
      frame_size      : integer                 := 16;     -- Number of elements in the frame to be streamed
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 0 to 64   := 4;      -- Catapult address bus width
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default

      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16   := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      xburstsize       : integer                := 0;      -- Burst size for scverify transactor
      xBASE_ADDRESS    : integer                := 0;      -- Base addess  for scverify transactor
      xBASE_ADDRESSU   : integer                := 0       -- Upper word for 64-bit Base addess  for scverify transactor
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset

      -- ============== AXI4 Write Address Channel Signals
      AWID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Write address ID
      AWADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Write address
      AWLEN      : OUT  std_logic_vector(7 downto 0);                   -- Write burst length
      AWSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Write burst size
      AWBURST    : OUT  std_logic_vector(1 downto 0);                   -- Write burst mode
      AWLOCK     : OUT  std_logic;                                      -- Lock type
      AWCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      AWPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      AWQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      AWREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      AWUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      AWVALID    : OUT  std_logic;                                      -- Write address valid
      AWREADY    : IN   std_logic;                                      -- Write address ready

      -- ============== AXI4 Write Data Channel
      WDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);        -- Write data
      WSTRB      : OUT  std_logic_vector((DATA_WIDTH/8)-1 downto 0);    -- Write strobe (bytewise)
      WLAST      : OUT  std_logic;                                      -- Write last
      WUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      WVALID     : OUT  std_logic;                                      -- Write data is valid
      WREADY     : IN   std_logic;                                      -- Write ready

      -- ============== AXI4 Write Response Channel Signals
      BID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Response ID tag
      BRESP      : IN   std_logic_vector(1 downto 0);                   -- Write response
      BUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      BVALID     : IN   std_logic;                                      -- Write response valid
      BREADY     : OUT  std_logic;                                      -- Response ready

      -- Catapult interface
      -- Configuration interface
      cfgBaseAddress : IN  std_logic_vector(ADDR_WIDTH-1 downto 0);  
      cfgBurstSize   : IN  std_logic_vector(31 downto 0);            
      cfgTimeout     : IN  std_logic_vector(31 downto 0);            

      m_we      : IN   std_logic;                                       -- Catapult attempting write to memory over bus
      m_dout    : IN   std_logic_vector(cwidth-1 downto 0);             -- Data out to bus from catapult (write request)
      m_wrdy    : OUT  std_logic;                                       -- Bus memory ready for write access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      vld       : OUT  std_logic                                        -- Core produced data.  Written into transactor "row"
    );

END COMPONENT;

COMPONENT ccs_axi4_master_instream
    GENERIC(
      rscid           : integer                 := 1;     -- Resource ID
      -- Catapult Bus Configuration generics
      frame_size      : integer                 := 16;     -- Number of elements in the frame to be streamed
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 0 to 64   := 4;      -- Catapult address bus width
      burstsize       : integer                 := 0;      -- Catapult configuration option for Read burst size
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      timeout         : integer                 := 0;      --  #cycles timeout for burst stall
      
      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      BASE_ADDRESS    : integer                 := 0;      -- Base address 
      BASE_ADDRESSU   : integer                 := 0       -- Upper word for 64-bit Base address 
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset

      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready

      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      rdy       : OUT  std_logic                                        -- For transactor
    );

END COMPONENT;

COMPONENT ccs_axi4_master_outstream
    GENERIC(
      rscid           : integer;                           -- Resource ID
      -- Catapult Bus Configuration generics
      frame_size      : integer                 := 16;     -- Number of elements in the frame to be streamed
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 0 to 64   := 4;      -- Catapult address bus width
      burstsize       : integer                 := 0;      -- Catapult configuration option for Write burst size
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      timeout         : integer                 := 0;      --  #cycles timeout for burst stall

      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16   := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;     -- AXI4 Region Map (ignored in this model)
      BASE_ADDRESS    : integer                := 0;      -- AXI4 write channel base address
      BASE_ADDRESSU   : integer                := 0       -- Upper word for 64-bit AXI4 write channel base address
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset

      -- ============== AXI4 Write Address Channel Signals
      AWID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Write address ID
      AWADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Write address
      AWLEN      : OUT  std_logic_vector(7 downto 0);                   -- Write burst length
      AWSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Write burst size
      AWBURST    : OUT  std_logic_vector(1 downto 0);                   -- Write burst mode
      AWLOCK     : OUT  std_logic;                                      -- Lock type
      AWCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      AWPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      AWQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      AWREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      AWUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      AWVALID    : OUT  std_logic;                                      -- Write address valid
      AWREADY    : IN   std_logic;                                      -- Write address ready

      -- ============== AXI4 Write Data Channel
      WDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);        -- Write data
      WSTRB      : OUT  std_logic_vector((DATA_WIDTH/8)-1 downto 0);    -- Write strobe (bytewise)
      WLAST      : OUT  std_logic;                                      -- Write last
      WUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      WVALID     : OUT  std_logic;                                      -- Write data is valid
      WREADY     : IN   std_logic;                                      -- Write ready

      -- ============== AXI4 Write Response Channel Signals
      BID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Response ID tag
      BRESP      : IN   std_logic_vector(1 downto 0);                   -- Write response
      BUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      BVALID     : IN   std_logic;                                      -- Write response valid
      BREADY     : OUT  std_logic;                                      -- Response ready

      -- Catapult interface
      m_we      : IN   std_logic;                                       -- Catapult attempting write to memory over bus
      m_dout    : IN   std_logic_vector(cwidth-1 downto 0);             -- Data out to bus from catapult (write request)
      m_wrdy    : OUT  std_logic;                                       -- Bus memory ready for write access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      vld       : OUT  std_logic                                        -- Core produced data.  Written into transactor "row"
    );

END COMPONENT;

COMPONENT ccs_axi4_master_fpga_instream_core
    GENERIC(
      rscid           : integer                 := 1;     -- Resource ID
      -- Catapult Bus Configuration generics
      frame_size      : integer                 := 16;     -- Number of elements in the frame to be streamed
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 0 to 64   := 4;      -- Catapult address bus width
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      
      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      xburstsize      : integer                 := 0;      -- Burst size for scverify transactor
      xBASE_ADDRESS   : integer                 := 0;      -- Base address for scverify transactor
      xBASE_ADDRESSU  : integer                 := 0       -- Upper word for 64-bit Base address for scverify transactor
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset

      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready

      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- Configuration interface
      cfgBaseAddress : IN  std_logic_vector(ADDR_WIDTH-1 downto 0);  
      cfgBurstSize   : IN  std_logic_vector(31 downto 0);            
      cfgTimeout     : IN  std_logic_vector(31 downto 0);            

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      rdy       : OUT  std_logic                                        -- For transactor
    );

END COMPONENT;

COMPONENT ccs_axi4_master_fpga_instream
    GENERIC(
      rscid           : integer                 := 1;     -- Resource ID
      -- Catapult Bus Configuration generics
      frame_size      : integer                 := 16;     -- Number of elements in the frame to be streamed
      op_width        : integer range 1 to 1024 := 1;      -- dummy parameter for cwidth calculation
      cwidth          : integer range 8 to 1024 := 32;     -- Catapult data bus width (multiples of 8)
      addr_w          : integer range 0 to 64   := 4;      -- Catapult address bus width
      burstsize       : integer                 := 0;      -- Catapult configuration option for Read burst size
      rst_ph          : integer range 0 to 1    := 0;      -- Reset phase - negative default
      timeout         : integer                 := 0;      --  #cycles timeout for burst stall
      
      -- AXI-4 Bus Configuration generics
      ADDR_WIDTH      : integer range 12 to 64  := 32;     -- AXI4 bus address width
      DATA_WIDTH      : integer range 8 to 1024 := 32;     -- AXI4 read&write data bus width
      ID_WIDTH        : integer range 1 to 16    := 1;      -- AXI4 ID field width (ignored in this model)
      USER_WIDTH      : integer range 1 to 32   := 1;      -- AXI4 User field width (ignored in this model)
      REGION_MAP_SIZE : integer range 1 to 15   := 1;      -- AXI4 Region Map (ignored in this model)
      BASE_ADDRESS    : integer                 := 0;      -- Base address 
      BASE_ADDRESSU   : integer                 := 0       -- Upper word for 64-bit Base address 
    );
    PORT(
      -- AXI-4 Interface
      ACLK       : IN   std_logic;                                      -- Rising edge clock
      ARESETn    : IN   std_logic;                                      -- Active LOW asynchronous reset

      -- ============== AXI4 Read Address Channel Signals
      ARID       : OUT  std_logic_vector(ID_WIDTH-1 downto 0);          -- Read address ID
      ARADDR     : OUT  std_logic_vector(ADDR_WIDTH-1 downto 0);        -- Read address
      ARLEN      : OUT  std_logic_vector(7 downto 0);                   -- Read burst length
      ARSIZE     : OUT  std_logic_vector(2 downto 0);                   -- Read burst size
      ARBURST    : OUT  std_logic_vector(1 downto 0);                   -- Read burst mode
      ARLOCK     : OUT  std_logic;                                      -- Lock type
      ARCACHE    : OUT  std_logic_vector(3 downto 0);                   -- Memory type
      ARPROT     : OUT  std_logic_vector(2 downto 0);                   -- Protection Type
      ARQOS      : OUT  std_logic_vector(3 downto 0);                   -- Quality of Service
      ARREGION   : OUT  std_logic_vector(3 downto 0);                   -- Region identifier
      ARUSER     : OUT  std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      ARVALID    : OUT  std_logic;                                      -- Read address valid
      ARREADY    : IN   std_logic;                                      -- Read address ready

      -- ============== AXI4 Read Data Channel Signals
      RID        : IN   std_logic_vector(ID_WIDTH-1 downto 0);          -- Read ID tag
      RDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);        -- Read data
      RRESP      : IN   std_logic_vector(1 downto 0);                   -- Read response
      RLAST      : IN   std_logic;                                      -- Read last
      RUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);        -- User signal
      RVALID     : IN   std_logic;                                      -- Read valid
      RREADY     : OUT  std_logic;                                      -- Read ready

      -- Catapult interface
      m_re      : IN   std_logic;                                       -- Catapult attempting read of memory over bus
      m_din     : OUT  std_logic_vector(cwidth-1 downto 0);             -- Data into catapult block through this interface (read request)
      m_rrdy    : OUT  std_logic;                                       -- Bus memory ready for read access by Catapult (1=ready)
      is_idle   : OUT  std_logic;                                       -- The component is idle. The next clk can be suppressed
      rdy       : OUT  std_logic                                        -- For transactor
    );

END COMPONENT;

COMPONENT ccs_axi4_lite_slave_outreg
  GENERIC(
    rscid           : integer                 := 1;    -- Resource ID
    -- Catapult Bus Configuration generics
    op_width        : integer range 1 to 1024 := 1;    -- dummy parameter for cwidth calculation
    cwidth          : integer range 1 to 1024 := 8;    -- Internal memory data width
    rst_ph          : integer range 0 to 1    := 0;    -- Reset phase.  1= Positive edge. Default is AXI negative edge
    -- AXI-4 Bus Configuration generics
    ADDR_WIDTH      : integer range 12 to 64  := 32;   -- AXI4 bus address width
    DATA_WIDTH      : integer range 8 to 1024 := 32;   -- AXI4 read&write data bus width
    BASE_ADDRESS   : integer                  := 0     -- AXI4 Address that the register is seen at
    );
  PORT(
    -- AXI-4 Interface
    ACLK       : IN   std_logic;                                     -- Rising edge clock
    ARESETn    : IN   std_logic;                                     -- Active LOW asynchronous reset
    
    -- ============== AXI4 Read Address Channel Signals
    ARADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Read address
    ARVALID    : IN   std_logic;                                     -- Read address valid
    ARREADY    : OUT  std_logic;                                     -- Read address ready (slave is ready to accept ARADDR)
    
    -- ============== AXI4 Read Data Channel Signals
    RDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);       -- Read data
    RRESP      : OUT  std_logic_vector(1 downto 0);                  -- Read response (of slave)
    RVALID     : OUT  std_logic;                                     -- Read valid (slave providing RDATA)
    RREADY     : IN   std_logic;                                     -- Read ready (master ready to receive RDATA)
    
    -- Catapult interface
    ivld      : IN   std_logic;                                      -- Catapult data ready
    idat      : in   std_logic_vector(cwidth-1 downto 0);            -- Data from catapult

    -- External valid flag
    vld       : OUT  std_logic                                       -- Data valid for AXI read
    );

END COMPONENT;

COMPONENT ccs_axi4_lite_slave_inreg 
  GENERIC(
    rscid           : integer                 := 1;    -- Resource ID
    -- Catapult Bus Configuration generics
    op_width        : integer range 1 to 1024 := 1;    -- dummy parameter for cwidth calculation
    cwidth          : integer range 1 to 1024 := 8;    -- Internal memory data width
    rst_ph          : integer range 0 to 1    := 0;    -- Reset phase.  1= Positive edge. Default is AXI negative edge
    disable_vld     : integer range 0 to 1    := 0;    -- Disable use of vld signal to stall I/O
    -- AXI-4 Bus Configuration generics
    ADDR_WIDTH      : integer range 12 to 64  := 32;   -- AXI4 bus address width
    DATA_WIDTH      : integer range 8 to 1024 := 32;   -- AXI4 read&write data bus width
    BASE_ADDRESS    : integer                 := 0     -- AXI4 Address that the register is seen at
    );
  PORT(
    -- AXI-4 Interface
    ACLK       : IN   std_logic;                                     -- Rising edge clock
    ARESETn    : IN   std_logic;                                     -- Active LOW asynchronous reset
    -- ============== AXI4 Write Address Channel Signals
    AWADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Write address
    AWVALID    : IN   std_logic;                                     -- Write address valid
    AWREADY    : OUT  std_logic;                                     -- Write address ready (slave is ready to accept AWADDR)
    -- ============== AXI4 Write Data Channel
    WDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);       -- Write data
    WSTRB      : IN   std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe (bytewise)
    WVALID     : IN   std_logic;                                     -- Write data is valid
    WREADY     : OUT  std_logic;                                     -- Write ready (slave is ready to accept WDATA)
    
    -- ============== AXI4 Write Response Channel Signals
    BRESP      : OUT  std_logic_vector(1 downto 0);                  -- Write response (of slave)
    BVALID     : OUT  std_logic;                                     -- Write response valid (slave accepted WDATA)
    BREADY     : IN   std_logic;                                     -- Response ready (master can accept slave's write response)
    
    -- Catapult interface
    ivld      : OUT   std_logic;                                      -- Data valid.  Duration 1 cycle
    idat      : OUT   std_logic_vector(cwidth-1 downto 0)             -- Data into catapult block through this interface
    );
END COMPONENT;

COMPONENT ccs_axi4_lite_slave_indirect
  GENERIC(
    rscid           : integer                 := 1;    -- Resource ID
    -- Catapult Bus Configuration generics
    op_width        : integer range 1 to 1024 := 1;    -- dummy parameter for cwidth calculation
    cwidth          : integer range 1 to 1024 := 8;    -- Internal memory data width
    rst_ph          : integer range 0 to 1    := 0;    -- Reset phase.  1= Positive edge. Default is AXI negative edge
    -- AXI-4 Bus Configuration generics
    ADDR_WIDTH      : integer range 12 to 64  := 32;   -- AXI4 bus address width
    DATA_WIDTH      : integer range 8 to 1024 := 32;   -- AXI4 read&write data bus width
    BASE_ADDRESS    : integer                 := 0     -- AXI4 Address that the register is seen at
    );
  PORT(
    -- AXI-4 Interface
    ACLK       : IN   std_logic;                                     -- Rising edge clock
    ARESETn    : IN   std_logic;                                     -- Active LOW asynchronous reset
    -- ============== AXI4 Write Address Channel Signals
    AWADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Write address
    AWVALID    : IN   std_logic;                                     -- Write address valid
    AWREADY    : OUT  std_logic;                                     -- Write address ready (slave is ready to accept AWADDR)
    -- ============== AXI4 Write Data Channel
    WDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);       -- Write data
    WSTRB      : IN   std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe (bytewise)
    WVALID     : IN   std_logic;                                     -- Write data is valid
    WREADY     : OUT  std_logic;                                     -- Write ready (slave is ready to accept WDATA)
    
    -- ============== AXI4 Write Response Channel Signals
    BRESP      : OUT  std_logic_vector(1 downto 0);                  -- Write response (of slave)
    BVALID     : OUT  std_logic;                                     -- Write response valid (slave accepted WDATA)
    BREADY     : IN   std_logic;                                     -- Response ready (master can accept slave's write response)
    
    -- ============== AXI4 Read Address Channel Signals
    ARADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Read address
    ARVALID    : IN   std_logic;                                     -- Read address valid
    ARREADY    : OUT  std_logic;                                     -- Read address ready (slave is ready to accept ARADDR)
    
    -- ============== AXI4 Read Data Channel Signals
    RDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);       -- Read data
    RRESP      : OUT  std_logic_vector(1 downto 0);                  -- Read response (of slave)
    RVALID     : OUT  std_logic;                                     -- Read valid (slave providing RDATA)
    RREADY     : IN   std_logic;                                     -- Read ready (master ready to receive RDATA)
    
    -- Catapult interface
    idat      : OUT   std_logic_vector(cwidth-1 downto 0)             -- Data into catapult block through this interface
    );
END COMPONENT;

COMPONENT ccs_axi4_lite_slave_outsync
  GENERIC(
    rscid           : integer                 := 1;    -- Resource ID
    -- Catapult Bus Configuration generics
    rst_ph          : integer range 0 to 1    := 0;    -- Reset phase.  1= Positive edge. Default is AXI negative edge
    -- AXI-4 Bus Configuration generics
    ADDR_WIDTH      : integer range 12 to 32  := 32;   -- AXI4 bus address width
    DATA_WIDTH      : integer range 32 to 64  := 32;   -- AXI4 read&write data bus width
    BASE_ADDRESS   : integer                  := 0     -- AXI4 Address that the register is seen at
    );
  PORT(
    -- AXI-4 Interface
    ACLK       : IN   std_logic;                                     -- Rising edge clock
    ARESETn    : IN   std_logic;                                     -- Active LOW asynchronous reset
    
    -- ============== AXI4 Write Address Channel Signals
    AWADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Write address
    AWVALID    : IN   std_logic;                                     -- Write address valid
    AWREADY    : OUT  std_logic;                                     -- Write address ready (slave is ready to accept AWADDR)

    -- ============== AXI4 Write Data Channel
    WDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);       -- Write data
    WSTRB      : IN   std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe - not used in LITE
    WVALID     : IN   std_logic;                                     -- Write data is valid
    WREADY     : OUT  std_logic;                                     -- Write ready (slave is ready to accept WDATA)
    
    -- ============== AXI4 Write Response Channel Signals
    BRESP      : OUT  std_logic_vector(1 downto 0);                  -- Write response (of slave)
    BVALID     : OUT  std_logic;                                     -- Write response valid (slave accepted WDATA)
    BREADY     : IN   std_logic;                                     -- Response ready (master can accept slave's write response)
    
    -- ============== AXI4 Read Address Channel Signals
    ARADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Read address
    ARVALID    : IN   std_logic;                                     -- Read address valid
    ARREADY    : OUT  std_logic;                                     -- Read address ready (slave is ready to accept ARADDR)
    
    -- ============== AXI4 Read Data Channel Signals
    RDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);       -- Read data
    RRESP      : OUT  std_logic_vector(1 downto 0);                  -- Read response (of slave)
    RVALID     : OUT  std_logic;                                     -- Read valid (slave providing RDATA)
    RREADY     : IN   std_logic;                                     -- Read ready (master ready to receive RDATA)
    
    -- Catapult interface
    irdy      : OUT  std_logic;                                      -- Catapult data ready
    ivld      : IN   std_logic;                                      -- Catapult data ready
    triosy    : OUT  std_logic                                       -- Data from catapult
    );

END COMPONENT;

COMPONENT ccs_axi4_lite_slave_insync
  GENERIC(
    rscid           : integer                 := 1;    -- Resource ID
    -- Catapult Bus Configuration generics
    rst_ph          : integer range 0 to 1    := 0;    -- Reset phase.  1= Positive edge. Default is AXI negative edge
    -- AXI-4 Bus Configuration generics
    ADDR_WIDTH      : integer range 12 to 32  := 32;   -- AXI4 bus address width
    DATA_WIDTH      : integer range 32 to 64  := 32;   -- AXI4 read&write data bus width
    BASE_ADDRESS    : integer                 := 0     -- AXI4 Address that the register is seen at
    );
  PORT(
    -- AXI-4 Interface
    ACLK       : IN   std_logic;                                     -- Rising edge clock
    ARESETn    : IN   std_logic;                                     -- Active LOW asynchronous reset
    -- ============== AXI4 Write Address Channel Signals
    AWADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Write address
    AWVALID    : IN   std_logic;                                     -- Write address valid
    AWREADY    : OUT  std_logic;                                     -- Write address ready (slave is ready to accept AWADDR)
    -- ============== AXI4 Write Data Channel
    WDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);       -- Write data
    WSTRB      : IN   std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe (bytewise)
    WVALID     : IN   std_logic;                                     -- Write data is valid
    WREADY     : OUT  std_logic;                                     -- Write ready (slave is ready to accept WDATA)
    
    -- ============== AXI4 Write Response Channel Signals
    BRESP      : OUT  std_logic_vector(1 downto 0);                  -- Write response (of slave)
    BVALID     : OUT  std_logic;                                     -- Write response valid (slave accepted WDATA)
    BREADY     : IN   std_logic;                                     -- Response ready (master can accept slave's write response)
    
    -- ============== AXI4 Read Address Channel Signals
    ARADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Read address
    ARVALID    : IN   std_logic;                                     -- Read address valid
    ARREADY    : OUT  std_logic;                                     -- Read address ready (slave is ready to accept ARADDR)
    
    -- ============== AXI4 Read Data Channel Signals
    RDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);       -- Read data
    RRESP      : OUT  std_logic_vector(1 downto 0);                  -- Read response (of slave)
    RVALID     : OUT  std_logic;                                     -- Read valid (slave providing RDATA)
    RREADY     : IN   std_logic;                                     -- Read ready (master ready to receive RDATA)

    -- Catapult interface
    irdy      : IN    std_logic;
    ivld      : OUT   std_logic;
    triosy    : OUT   std_logic                                       -- // transactor uses 
    );
END COMPONENT;


  -- ==============================================================
  -- APB Components

  -- Used to define the APB bus definition (direction of signals is from the slave's perspective)
  COMPONENT apb_busdef
    GENERIC(
      width        : INTEGER RANGE 1 TO 32 := 32;           -- Number of bits in an element
      addr_width   : INTEGER RANGE 1 TO 32 := 1             -- Number of address bits to address 'words' elements
    );
    PORT(
      -- APB interface
      PCLK      : IN   std_logic;                           -- Rising edge clock
      PRESETn   : IN   std_logic;                           -- Active LOW synchronous reset
      PADDR     : IN   std_logic_vector(addr_width-1 downto 0);  -- APB Bridge driven address bus (32 bit max)
      PSELx     : IN   std_logic;                           -- APB Bridge driven select for this slave
      PWRITE    : IN   std_logic;                           -- APB Bridge driven read/write signal (0=read)
      PENABLE   : IN   std_logic;                           -- APB Bridge driven enable signal
      PWDATA    : IN   std_logic_vector(width-1 downto 0);  -- APB Bridge driven data to write to slave (32 bit max)
      PRDATA    : OUT  std_logic_vector(width-1 downto 0);  -- Slave driven data back to APB Bridge (32 bit max)
      PREADY    : OUT  std_logic;                           -- Slave driven signal to extend transfer cycles (1=ready)
      PSLVERR   : OUT  std_logic                            -- Slave driven signal indicating transfer failed (1=fail)
    );
  END COMPONENT;

  COMPONENT apb_master
    GENERIC(
      words        : INTEGER RANGE 1 TO 256 := 1;           -- Number of addressable elements
      width        : INTEGER RANGE 1 TO 32 := 32;           -- Number of bits in an element
      addr_width   : INTEGER RANGE 1 TO 32 := 1             -- Number of address bits to address 'words' elements
    );
    PORT(
      -- APB interface
      PCLK      : IN   std_logic;                           -- Rising edge clock
      PRESETn   : IN   std_logic;                           -- Active LOW synchronous reset
      PADDR     : OUT  std_logic_vector(30 downto 0);       -- APB Bridge driven address bus (32 bit max)
      PSELx     : OUT  std_logic;                           -- APB Bridge driven select for this slave
      PWRITE    : OUT  std_logic;                           -- APB Bridge driven read/write signal (0=read)
      PENABLE   : OUT  std_logic;                           -- APB Bridge driven enable signal
      PWDATA    : OUT  std_logic_vector(width-1 downto 0);  -- APB Bridge driven data to write to slave (32 bit max)
      PRDATA    : IN   std_logic_vector(width-1 downto 0);  -- Slave driven data back to APB Bridge (32 bit max)
      PREADY    : IN   std_logic;                           -- Slave driven signal to extend transfer cycles (1=ready)
      PSLVERR   : IN   std_logic;                           -- Slave driven signal indicating transfer failed (1=fail)
      -- Catapult interface
      m_rw      : IN   std_logic;                           -- read/write
      m_strobe  : IN   std_logic;                           -- initiate a bus transfer
      m_adr     : IN   std_logic_vector(addr_width-1 downto 0); -- target address
      m_din     : OUT  std_logic_vector(width-1 downto 0);  -- data in from slave
      m_dout    : IN   std_logic_vector(width-1 downto 0);  -- data out to slave
      m_rdy     : OUT  std_logic                            -- ready for transfer (1=ready)
    );
  END COMPONENT;

  -- APB slave memory
  COMPONENT apb_slave_mem
    GENERIC(
      words          : INTEGER RANGE 1 TO 256 := 1;            -- Number of addressable elements
      width          : INTEGER RANGE 1 TO 32 := 32;           -- Number of bits in an element
      addr_width     : INTEGER RANGE 1 TO 32 := 1;            -- Number of address bits to address 'words' elements
      num_rwports    : INTEGER RANGE 1 TO 100 := 1;           -- Number of register file "ports"
      nopreload      : INTEGER RANGE 0 TO 1 := 0              -- 1=disable required preload before Catapult can read
    );
    PORT(
      -- APB interface
      PCLK      : IN   std_logic;                           -- Rising edge clock
      PRESETn   : IN   std_logic;                           -- Active LOW synchronous reset
      PADDR     : IN   std_logic_vector(30 downto 0);       -- APB Bridge driven address bus (32 bit max)
      PSELx     : IN   std_logic;                           -- APB Bridge driven select for this slave
      PWRITE    : IN   std_logic;                           -- APB Bridge driven read/write signal (0=read)
      PENABLE   : IN   std_logic;                           -- APB Bridge driven enable signal
      PWDATA    : IN   std_logic_vector(width-1 downto 0);  -- APB Bridge driven data to write to slave (32 bit max)
      PRDATA    : OUT  std_logic_vector(width-1 downto 0);  -- Slave driven data back to APB Bridge (32 bit max)
      PREADY    : OUT  std_logic;                           -- Slave driven signal to extend transfer cycles (1=ready)
      PSLVERR   : OUT  std_logic;                           -- Slave driven signal indicating transfer failed (1=fail)
      -- Catapult interface
      s_rw      : IN   std_logic_vector(num_rwports-1 downto 0);            -- read/write
      s_strobe  : IN   std_logic_vector(num_rwports-1 downto 0);            -- Catapult attempting read of slave
      s_adr     : IN   std_logic_vector(num_rwports*addr_width-1 downto 0); -- Catapult addressing into memory
      s_din     : OUT  std_logic_vector(num_rwports*width-1 downto 0);      -- Data into catapult block through this interface
      s_dout    : IN   std_logic_vector(num_rwports*width-1 downto 0);      -- Data out to slave from catapult
      s_rdy     : OUT  std_logic_vector(num_rwports-1 downto 0)             -- Slave memory ready for read (1=ready)
    );
  END COMPONENT;

  -- ==============================================================
  -- Internally referenced components

  COMPONENT amba_generic_reg
    GENERIC (
      width    : INTEGER := 1;
      ph_en    : INTEGER RANGE 0 TO 1 := 1;
      has_en   : INTEGER RANGE 0 TO 1 := 1
    );
    PORT (
      clk     : IN  std_logic;
      en      : IN  std_logic;
      arst    : IN  std_logic;
      srst    : IN  std_logic;
      d       : IN  std_logic_vector(width-1 DOWNTO 0);
      z       : OUT std_logic_vector(width-1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT amba_pipe_ctrl
    GENERIC (
      rscid    : INTEGER := 0;
      width    : INTEGER := 8;
      sz_width : INTEGER := 8;
      fifo_sz  : INTEGER RANGE 0 TO 128 := 8;
      ph_en    : INTEGER RANGE 0 TO 1 := 1
    );
    PORT (
      clk      : IN  std_logic;
      en       : IN  std_logic;
      arst     : IN  std_logic;
      srst     : IN  std_logic;
      din_vld  : IN  std_logic;
      din_rdy  : OUT std_logic;
      din      : IN  std_logic_vector(width-1 DOWNTO 0);
      dout_vld : OUT std_logic;
      dout_rdy : IN  std_logic;
      dout     : OUT std_logic_vector(width-1 DOWNTO 0);
      sd       : OUT std_logic_vector(sz_width-1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT amba_pipe
    GENERIC (
      rscid    : INTEGER := 0;
      width    : INTEGER := 8;
      sz_width : INTEGER := 8;
      fifo_sz  : INTEGER RANGE 0 TO 128 := 8;
      ph_en    : INTEGER RANGE 0 TO 1 := 1
    );
    PORT (
      -- clock
      clk      : IN  std_logic;
      en       : IN  std_logic;
      arst     : IN  std_logic;
      srst     : IN  std_logic;
      -- writer
      din_rdy  : OUT std_logic;
      din_vld  : IN  std_logic;
      din      : IN  std_logic_vector(width-1 DOWNTO 0);
      -- reader
      dout_rdy : IN  std_logic;
      dout_vld : OUT std_logic;
      dout     : OUT std_logic_vector(width-1 DOWNTO 0);
      -- size
      sz       : OUT std_logic_vector(sz_width-1 DOWNTO 0);
      sz_req   : in  std_logic
    );
  END COMPONENT;

  COMPONENT amba_ctrl_in_buf_wait
    GENERIC (
      width    : INTEGER := 8
    );
    PORT (
      clk      : IN  std_logic;
      arst     : IN  std_logic;
      irdy   : IN  std_logic;
      ivld   : OUT std_logic;
      idat   : OUT std_logic_vector(width-1 DOWNTO 0);
      rdy    : OUT std_logic;
      vld    : IN  std_logic;
      dat    : IN  std_logic_vector(width-1 DOWNTO 0);
      is_idle : out std_logic
    );
  END COMPONENT;

  
  -- ==============================================================
  -- AMBA Protocol Constants

  -- AxBURST modes
  CONSTANT AXI4_AxBURST_FIXED    : std_logic_vector(1 downto 0) := "00";
  CONSTANT AXI4_AxBURST_INCR     : std_logic_vector(1 downto 0) := "01";
  CONSTANT AXI4_AxBURST_WRAP     : std_logic_vector(1 downto 0) := "10";
  CONSTANT AXI4_AxBURST_RESERVED : std_logic_vector(1 downto 0) := "11";
  -- AxLOCK modes
  CONSTANT AXI4_AxLOCK_NORMAL    : std_logic                    := '0';
  CONSTANT AXI4_AxLOCK_EXCLUSIVE : std_logic                    := '1';
  -- Memory types W and R mostly the xame
  CONSTANT AXI4_AWCACHE_NB        : std_logic_vector(3 downto 0) := "0000";
  CONSTANT AXI4_AWCACHE_B         : std_logic_vector(3 downto 0) := "0001";
  CONSTANT AXI4_AWCACHE_NORM_NCNB : std_logic_vector(3 downto 0) := "0010"; --
  CONSTANT AXI4_AWCACHE_NORM_NCB  : std_logic_vector(3 downto 0) := "0011" ;
  CONSTANT AXI4_AWCACHE_WTNA      : std_logic_vector(3 downto 0) := "0110";
  CONSTANT AXI4_AWCACHE_WTRA      : std_logic_vector(3 downto 0) := "0110";
  CONSTANT AXI4_AWCACHE_WTWA      : std_logic_vector(3 downto 0) := "1110";
  CONSTANT AXI4_AWCACHE_WTRWA     : std_logic_vector(3 downto 0) := "1110";
  CONSTANT AXI4_AWCACHE_WBNA      : std_logic_vector(3 downto 0) := "0111";
  CONSTANT AXI4_AWCACHE_WBRA      : std_logic_vector(3 downto 0) := "0111";
  CONSTANT AXI4_WACACHE_WBWA      : std_logic_vector(3 downto 0) := "1111";
  CONSTANT AXI4_AWCACHE_WBRWA     : std_logic_vector(3 downto 0) := "1111";
  CONSTANT AXI4_ARCACHE_NB        : std_logic_vector(3 downto 0) := "0000";
  CONSTANT AXI4_ARCACHE_B         : std_logic_vector(3 downto 0) := "0001";
  CONSTANT AXI4_ARCACHE_NORM_NCNB : std_logic_vector(3 downto 0) := "0010"; --
  CONSTANT AXI4_ARCACHE_NORM_NCB  : std_logic_vector(3 downto 0) := "0011" ;
  CONSTANT AXI4_ARCACHE_WTNA      : std_logic_vector(3 downto 0) := "1010";
  CONSTANT AXI4_ARCACHE_WTRA      : std_logic_vector(3 downto 0) := "1110";
  CONSTANT AXI4_ARCACHE_WTWA      : std_logic_vector(3 downto 0) := "1010";
  CONSTANT AXI4_ARCACHE_WTRWA     : std_logic_vector(3 downto 0) := "1110";
  CONSTANT AXI4_ARCACHE_WBNA      : std_logic_vector(3 downto 0) := "1011";
  CONSTANT AXI4_ARCACHE_WBRA      : std_logic_vector(3 downto 0) := "1111";
  CONSTANT AXI4_ARCACHE_WBWA      : std_logic_vector(3 downto 0) := "1011";
  CONSTANT AXI4_ARCACHE_WBRWA     : std_logic_vector(3 downto 0) := "1111";
  -- QOS pre-defines
  CONSTANT AXI4_AxQOS_NONE        : std_logic_vector(3 downto 0) := "0000";
  -- AxSIZE byte sizes
  CONSTANT AXI4_AxSIZE_001_BYTE  : std_logic_vector(2 downto 0) := "000";
  CONSTANT AXI4_AxSIZE_002_BYTE  : std_logic_vector(2 downto 0) := "001";
  CONSTANT AXI4_AxSIZE_004_BYTE  : std_logic_vector(2 downto 0) := "010";
  CONSTANT AXI4_AxSIZE_008_BYTE  : std_logic_vector(2 downto 0) := "011";
  CONSTANT AXI4_AxSIZE_016_BYTE  : std_logic_vector(2 downto 0) := "100";
  CONSTANT AXI4_AxSIZE_032_BYTE  : std_logic_vector(2 downto 0) := "101";
  CONSTANT AXI4_AxSIZE_064_BYTE  : std_logic_vector(2 downto 0) := "110";
  CONSTANT AXI4_AxSIZE_128_BYTE  : std_logic_vector(2 downto 0) := "111";
  -- AxPROT bit fields
  CONSTANT AXI4_AxPROT_b0_UNPRIV   : std_logic := '0';
  CONSTANT AXI4_AxPROT_b0_PRIV     : std_logic := '1';
  CONSTANT AXI4_AxPROT_b1_SECURE   : std_logic := '0';
  CONSTANT AXI4_AxPROT_b1_UNSECURE : std_logic := '1';
  CONSTANT AXI4_AxPROT_b2_DATA     : std_logic := '0';
  CONSTANT AXI4_AxPROT_b2_INSTR    : std_logic := '1';
  -- xRESP response codes
  CONSTANT AXI4_xRESP_OKAY         : std_logic_vector(1 downto 0) := "00";
  CONSTANT AXI4_xRESP_EXOKAY       : std_logic_vector(1 downto 0) := "01";
  CONSTANT AXI4_xRESP_SLVERR       : std_logic_vector(1 downto 0) := "10";
  CONSTANT AXI4_xRESP_DECERR       : std_logic_vector(1 downto 0) := "11";

  -- Utility function(s) to support debug needs
  FUNCTION bits ( size : INTEGER) RETURN INTEGER;
  FUNCTION slv2bin(vec: std_logic_vector) RETURN string;
  FUNCTION slv2hex(vec: std_logic_vector) RETURN string;

END PACKAGE amba_comps;

PACKAGE BODY amba_comps IS

   -- Find the number of bits required to represent an unsigned
   -- number less than size
  FUNCTION bits (size : integer) RETURN INTEGER IS
  BEGIN
    IF (size < 0) THEN RETURN 0;
    ELSIF (size = 0) THEN RETURN 1;
    ELSE
      FOR i IN 1 TO size LOOP
        IF (2**i >= size) THEN
          RETURN i;
        END IF;
      END LOOP;
    END IF;
  END;

   -- Convert an std_logic_vector to a (hex)string for printing
   -- vec needs to be a multiple of 4 in size
  FUNCTION slv2hex(vec: std_logic_vector) RETURN string IS
      variable quad : std_logic_vector(3 downto 0);
      constant ne: integer := vec'length/4;
      variable s: string(1 to ne);
   BEGIN
      if vec'length mod 4 /= 0 then
         assert false
         report "slv2hex called with slv lenght that is not a multiple of 4";
         return s;
      end if;
      for i in 0 to ne-1 loop
         quad := vec(4*i+3 downto 4*i);
         case quad is
            when x"0" => s(ne-i) := '0';
            when x"1" => s(ne-i) := '1';
            when x"2" => s(ne-i) := '2';
            when x"3" => s(ne-i) := '3';
            when x"4" => s(ne-i) := '4';
            when x"5" => s(ne-i) := '5';
            when x"6" => s(ne-i) := '6';
            when x"7" => s(ne-i) := '7';
            when x"8" => s(ne-i) := '8';
            when x"9" => s(ne-i) := '9';
            when x"A" => s(ne-i) := 'A';
            when x"B" => s(ne-i) := 'B';
            when x"C" => s(ne-i) := 'C';
            when x"D" => s(ne-i) := 'D';
            when x"E" => s(ne-i) := 'E';
            when x"F" => s(ne-i) := 'F';
            when others => s(ne-i) := '-';
         end case;
      end loop;
      return s;
   END;

   -- Convert an std_logic_vector to a (binary)string for printing
   FUNCTION slv2bin(vec: std_logic_vector) RETURN string IS
      VARIABLE stmp: string(vec'left+1 downto 1);
   BEGIN
      FOR i in vec'reverse_range LOOP
         IF (vec(i) = 'U') THEN
            stmp(i+1) := 'U';
         ELSIF (vec(i) = 'X') THEN
            stmp(i+1) := 'X';
         ELSIF (vec(i) = '0') THEN
            stmp(i+1) := '0';
         ELSIF (vec(i) = '1') THEN
            stmp(i+1) := '1';
         ELSIF (vec(i) = 'Z') THEN
            stmp(i+1) := 'Z';
         ELSIF (vec(i) = 'W') THEN
            stmp(i+1) := 'W';
         ELSIF (vec(i) = 'L') THEN
            stmp(i+1) := 'L';
         ELSIF (vec(i) = 'H') THEN
            stmp(i+1) := 'H';
         ELSE
            stmp(i+1) := '-';
         END IF;
      END LOOP;
      RETURN stmp;
   END;

END amba_comps;


--------> /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/pkgs/ccs_libs/interfaces/amba/ccs_axi4_slave_mem.vhd 

-- --------------------------------------------------------------------------
-- DESIGN UNIT:        ccs_axi4_slave_mem
--
-- DESCRIPTION:
--   This model implements an AXI-4 Slave memory interface for use in 
--   Interface Synthesis in Catapult. The component details are described in the datasheet.
--
--   AXI/Catapult read/write to the same address in the same cycle is non-determinant
--
-- Notes:
--  1. This model implements a local memory of size {cwidth x depth}.
--     If the Catapult operation requires a memory width cwidth <= AXI bus width
--     this model will zero-pad the high end bits as necessary.
-- CHANGE LOG:
--  01/29/19 - Add reset phase and separate base address for read/write channels
--  11/26/18 - Add burst and other tweaks
--  02/28/18 - Initial implementation
--
-- -------------------------------------------------------------------------------
--  Memory Organization
--   This model is designed to provide storage for only the bits/elements that
--   the Catapult core actually interacts with.
--   The user supplies a base address for the AXI memory store via BASE_ADDRESS
--   parameter.  
-- Example:
--   C++ array declared as "ac_int<7,false>  coeffs[4];"
--   results in a Catapult operator width (op_width) of 7,
--   and cwidth=7 and addr_w=2 (addressing 4 element locations).
--   The library forces DATA_WIDTH to be big enough to hold
--   cwidth bits, rounded up to power-of-2 as needed.
--
--   The AXI address scheme addresses bytes and so increments
--   by number-of-bytes per data transaction, plus the BASE_ADDRESS. 
--   The top and left describe the AXI view of the memory. 
--   The bottom and right describe the Catapult view of the memory.
--
--      AXI-4 SIGNALS
--      ADDR_WIDTH=4        DATA_WIDTH=32
--        AxADDR               xDATA
--                    31                       0
--                    +------------+-----------+
--      BA+0000       |            |           |
--                    +------------+-----------+
--      BA+0000       |            |           |
--                    +------------+===========+
--      BA+1100       |            |  elem3    |    11
--                    +------------+===========+
--      BA+1000       |            |  elem2    |    10
--                    +------------+===========+
--      BA+0100       |            |  elem1    |    01
--                    +------------+===========+
--      BA+0000       |            |  elem0    |    00
--                    +------------+===========+
--                                 6           0
--                                   s_din/out     s_addr
--                                   cwidth=7      addr_w=2
--                                         CATAPULT SIGNALS
--
-- -------------------------------------------------------------------------------

LIBRARY ieee;

  USE ieee.std_logic_1164.all;
  USE ieee.numeric_std.all;       
  USE std.textio.all;
  USE ieee.std_logic_textio.all;
  USE ieee.math_real.all;


USE work.amba_comps.all;

ENTITY ccs_axi4_slave_mem IS
  GENERIC(
    rscid           : integer                 := 1;    -- Resource ID
    -- Catapult Bus Configuration generics
    depth           : integer                 := 16;   -- Number of addressable elements (up to 20bit address)
    op_width        : integer range 1 to 1024 := 1;    -- dummy parameter for cwidth calculation
    cwidth          : integer range 1 to 1024 := 8;    -- Internal memory data width
    addr_w          : integer range 1 to 64   := 4;    -- Catapult address bus widths
    nopreload       : integer range 0 to 1    := 0;    -- 1= no preload before Catapult can read
    rst_ph          : integer range 0 to 1    := 0;    -- Reset phase.  1= Positive edge. Default is AXI negative edge
    -- AXI-4 Bus Configuration generics
    ADDR_WIDTH      : integer range 12 to 64  := 32;   -- AXI4 bus address width
    DATA_WIDTH      : integer range 8 to 1024 := 32;   -- AXI4 read&write data bus width
    ID_WIDTH        : integer range 1 to 4    := 1;    -- AXI4 ID field width (ignored in this model)
    USER_WIDTH      : integer range 1 to 32   := 1;    -- AXI4 User field width (ignored in this model)
    REGION_MAP_SIZE : integer range 1 to 15   := 1;    -- AXI4 Region Map (ignored in this model)
    wBASE_ADDRESS   : integer                 := 0;    -- AXI4 write channel base address alignment based on data bus width
    rBASE_ADDRESS   : integer                 := 0     -- AXI4 read channel base address alignment based on data bus width
    );
  PORT(
    -- AXI-4 Interface
    ACLK       : IN   std_logic;                                     -- Rising edge clock
    ARESETn    : IN   std_logic;                                     -- Active LOW asynchronous reset
    -- ============== AXI4 Write Address Channel Signals
    AWID       : IN   std_logic_vector(ID_WIDTH-1 downto 0);         -- Write address ID
    AWADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Write address
    AWLEN      : IN   std_logic_vector(7 downto 0);                  -- Write burst length
    AWSIZE     : IN   std_logic_vector(2 downto 0);                  -- Write burst size
    AWBURST    : IN   std_logic_vector(1 downto 0);                  -- Write burst mode
    AWLOCK     : IN   std_logic;                                     -- Lock type
    AWCACHE    : IN   std_logic_vector(3 downto 0);                  -- Memory type
    AWPROT     : IN   std_logic_vector(2 downto 0);                  -- Protection Type
    AWQOS      : IN   std_logic_vector(3 downto 0);                  -- Quality of Service
    AWREGION   : IN   std_logic_vector(3 downto 0);                  -- Region identifier
    AWUSER     : IN   std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
    AWVALID    : IN   std_logic;                                     -- Write address valid
    AWREADY    : OUT  std_logic;                                     -- Write address ready (slave is ready to accept AWADDR)
    -- ============== AXI4 Write Data Channel
    WDATA      : IN   std_logic_vector(DATA_WIDTH-1 downto 0);       -- Write data
    WSTRB      : IN   std_logic_vector((DATA_WIDTH/8)-1 downto 0);   -- Write strobe (bytewise)
    WLAST      : IN   std_logic;                                     -- Write last
    WUSER      : IN   std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
    WVALID     : IN   std_logic;                                     -- Write data is valid
    WREADY     : OUT  std_logic;                                     -- Write ready (slave is ready to accept WDATA)
    
    -- ============== AXI4 Write Response Channel Signals
    BID        : OUT  std_logic_vector(ID_WIDTH-1 downto 0);         -- Response ID tag
    BRESP      : OUT  std_logic_vector(1 downto 0);                  -- Write response (of slave)
    BUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
    BVALID     : OUT  std_logic;                                     -- Write response valid (slave accepted WDATA)
    BREADY     : IN   std_logic;                                     -- Response ready (master can accept slave's write response)
    
    -- ============== AXI4 Read Address Channel Signals
    ARID       : IN   std_logic_vector(ID_WIDTH-1 downto 0);         -- Read address ID
    ARADDR     : IN   std_logic_vector(ADDR_WIDTH-1 downto 0);       -- Read address
    ARLEN      : IN   std_logic_vector(7 downto 0);                  -- Read burst length
    ARSIZE     : IN   std_logic_vector(2 downto 0);                  -- Read burst size
    ARBURST    : IN   std_logic_vector(1 downto 0);                  -- Read burst mode
    ARLOCK     : IN   std_logic;                                     -- Lock type
    ARCACHE    : IN   std_logic_vector(3 downto 0);                  -- Memory type
    ARPROT     : IN   std_logic_vector(2 downto 0);                  -- Protection Type
    ARQOS      : IN   std_logic_vector(3 downto 0);                  -- Quality of Service
    ARREGION   : IN   std_logic_vector(3 downto 0);                  -- Region identifier
    ARUSER     : IN   std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
    ARVALID    : IN   std_logic;                                     -- Read address valid
    ARREADY    : OUT  std_logic;                                     -- Read address ready (slave is ready to accept ARADDR)
    
    -- ============== AXI4 Read Data Channel Signals
    RID        : OUT  std_logic_vector(ID_WIDTH-1 downto 0);         -- Read ID tag
    RDATA      : OUT  std_logic_vector(DATA_WIDTH-1 downto 0);       -- Read data
    RRESP      : OUT  std_logic_vector(1 downto 0);                  -- Read response (of slave)
    RLAST      : OUT  std_logic;                                     -- Read last
    RUSER      : OUT  std_logic_vector(USER_WIDTH-1 downto 0);       -- User signal
    RVALID     : OUT  std_logic;                                     -- Read valid (slave providing RDATA)
    RREADY     : IN   std_logic;                                     -- Read ready (master ready to receive RDATA)
    
    -- Catapult interface
    s_re      : IN   std_logic;                                      -- Catapult attempting read of slave memory
    s_we      : IN   std_logic;                                      -- Catapult attempting write to slave memory
    s_raddr   : IN   std_logic_vector(addr_w-1 downto 0);            -- Catapult addressing into memory (axi_addr = base_addr + s_raddr)
    s_waddr   : IN   std_logic_vector(addr_w-1 downto 0);            -- Catapult addressing into memory (axi_addr = base_addr + s_waddr)
    s_din     : OUT  std_logic_vector(cwidth-1 downto 0);            -- Data into catapult block through this interface
    s_dout    : IN   std_logic_vector(cwidth-1 downto 0);            -- Data out to slave from catapult
    s_rrdy    : OUT  std_logic;                                      -- Read data is valid
    s_wrdy    : OUT  std_logic;                                      -- Slave memory ready for write by Catapult (1=ready)
    is_idle   : OUT  std_logic;                                      -- component is idle - clock can be suppressed
    -- Transactor/scverify support
    tr_write_done : IN std_logic;                                    -- transactor resource preload write done
    s_tdone       : IN std_logic                                     -- Transaction_done in scverify
    );
  

    -- Always rule for checking component parameter values
    --  addr_w == bits(depth)
    --    used to ensure that the width of the address bus on the Catapult side
    --    is capable of addressing 'depth' number of elements. 'depth' will be
    --    determined by the array size operator parameter 'size'
    --    (see the PROP_MAP_size attribute)
    --  ADDR_WIDTH >= addr_w
    --    used to ensure that the address width of the Catapult side is
    --    large enough to accommodate the address width of the AXI-4 bus.
    --    (may need some work to align byte addresses)
    --  ADDR_WIDTH >= 32
    --    ensure that the minimum address space is 4k (AXI requirement)
    --  cwidth == 8 + (op_width>8)*8 + (op_width>16)*16 + (op_width>32)*32 + 
    --                (op_width>64)*64 + (op_width>128)*128 + (op_width>256)*256 +
    --                (op_width>512)*512
    --    used to "round up" the operator width 'op_width' to the next power
    --    of two value (8, 16, 32, 64, 128, 256, 512, 1024)
    --    (see the PROP_MAP_width attribute)
    --  DATA_WIDTH >= cwidth
    --    used to ensure that the Catapult data width is large enough to
    --    accommodate the data width of the AXI-4 bus.
    --    - must be power-of-2 bytes.
    --    - #bits must be some positive integer number of bytes.
    --     Note: user can override DATA_WIDTH from the MAP_TO_MODULE
    --     directive during interface synthesis. No checking is done
    --     to ensure that the override value is a power-of-2 bytes.

END ccs_axi4_slave_mem;

ARCHITECTURE rtl of ccs_axi4_slave_mem IS

  -- Signals for current and next state values
  TYPE   read_state_t IS (axi4r_idle, axi4r_read);
  TYPE   write_state_t IS (axi4w_idle, axi4w_write, axi4w_write_done,  axi4w_catwrite, axi4w_catwrite_done);
  SIGNAL read_state       : read_state_t;
  SIGNAL write_state      : write_state_t;

  -- Memory embedded in this slave
  TYPE   mem_type IS ARRAY (depth-1 downto 0) of std_logic_vector(cwidth-1 downto 0);
  SIGNAL mem                : mem_type;


  -- In/out connections and constant outputs  
  SIGNAL AWREADY_reg : std_logic;
  SIGNAL WREADY_reg  : std_logic;
  SIGNAL BRESP_reg   : std_logic_vector(1 downto 0);
  SIGNAL BVALID_reg  : std_logic;
  SIGNAL ARREADY_reg : std_logic;
  SIGNAL RDATA_reg   : std_logic_vector(DATA_WIDTH-1 downto 0);
  SIGNAL RRESP_reg   : std_logic_vector(1 downto 0);
  SIGNAL RLAST_reg   : std_logic;
  SIGNAL RVALID_reg  : std_logic;
  SIGNAL s_din_reg   : std_logic_vector(cwidth-1 downto 0);
  SIGNAL s_rrdy_reg  : std_logic;
  SIGNAL s_wrdy_reg  : std_logic;

  SIGNAL rCatOutOfOrder : std_logic;
  SIGNAL catIsReading   : std_logic;
  SIGNAL next_raddr     : integer;
  
  SIGNAL readBurstCnt: std_logic_vector(7 downto 0);   -- how many are left
  SIGNAL wbase_addr   : std_logic_vector(ADDR_WIDTH-1 downto 0);
  SIGNAL rbase_addr   : std_logic_vector(ADDR_WIDTH-1 downto 0);
  SIGNAL address     : std_logic_vector(ADDR_WIDTH-1 downto 0);
  SIGNAL addrShift : integer;
  SIGNAL readAddr : integer;
  SIGNAL writeAddr : integer;
  SIGNAL int_ARESETn : std_logic;
  
-- catapult address sizes are smaller and cause problems used with axi address sizes
  function extCatAddr(catAddr : std_logic_vector(addr_w -1 downto 0))
    return std_logic_vector is
  
    variable axiAddr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  
  begin
    axiAddr := (others => '0');
    axiAddr(addr_w -1 downto 0) := catAddr;
    return axiAddr;
  end function extCatAddr;

BEGIN
  
  int_ARESETn <= ARESETn when (rst_ph = 0) else (not ARESETn);

  addrShift <= 0 when (DATA_WIDTH/8 <= 1)   else 
               1 when (DATA_WIDTH/8 <= 2)   else
               2 when (DATA_WIDTH/8 <= 4)   else
               3 when (DATA_WIDTH/8 <= 8)   else
               4 when (DATA_WIDTH/8 <= 16)  else
               5 when (DATA_WIDTH/8 <= 32)  else
               6 when (DATA_WIDTH/8 <= 64)  else
               7 when (DATA_WIDTH/8 <= 128) else
               0;

  -- unused outputs
  BID     <= (others => '0');
  BUSER   <= (others => '0');
  RID     <= (others => '0');
  RUSER   <= (others => '0');
  is_idle <= '0';
  
  AWREADY <= AWREADY_reg;
  WREADY  <= WREADY_reg ;
  BRESP   <= BRESP_reg  ;
  BVALID  <= BVALID_reg ;
  ARREADY <= ARREADY_reg;
  RDATA   <= RDATA_reg  ;
  RRESP   <= RRESP_reg  ;
  RLAST   <= RLAST_reg  ;
  RVALID  <= RVALID_reg ;
  s_din   <= s_din_reg  ;
  s_wrdy  <= s_wrdy_reg and (not s_tdone);
  s_rrdy  <= s_rrdy_reg and (not rCatOutOfOrder);

  wbase_addr <= std_logic_vector(to_unsigned(wBASE_ADDRESS, wbase_addr'length));
  rbase_addr <= std_logic_vector(to_unsigned(rBASE_ADDRESS, rbase_addr'length));
  
  -- pragma translate_off
  -- error checks.  Keep consistent with axi4_master.v/vhd
  -- all data widths the same
  errChk: process
    variable nBytes : std_logic_vector(31 downto 0);
    variable nBytes2 : std_logic_vector(31 downto 0);
  begin  -- process errChk
    nBytes := std_logic_vector(to_unsigned(DATA_WIDTH/8, 32));
    if (cwidth > DATA_WIDTH) then
      report  "Catapult(cwidth=" & integer'image(cwidth) & ") cannot be greater than AXI(DATA_BUS="
        & integer'image(DATA_WIDTH) & ")."
        severity error;
    end if;
    if ( (DATA_WIDTH mod 8) /= 0) then
      report  "Data bus width(DATA_WIDTH=" & integer'image(DATA_WIDTH) & ") not a discrete number of bytes."
        severity error;
    end if;
    if (to_integer(unsigned(nBytes)) = 0) then 
      report  "Data bus width(DATA_WIDTH=" & integer'image(DATA_WIDTH) & ") must be at least 1 byte."
        severity error;
    end if;
    nBytes2 := std_logic_vector(to_unsigned((DATA_WIDTH/8) - 1, 32));
    nBytes2 := nBytes  and nBytes2;
    if ( to_integer(unsigned(nBytes2)) /= 0) then
      report  "Data bus width must be power-of-2 number of bytes(DATA_WIDTH/8=" & integer'image(DATA_WIDTH/8) & ")"
        severity error;
    end if;
    if (ADDR_WIDTH < 12) then
      report  "AXI bus address width(ADDR_WIDTH=" & integer'image(ADDR_WIDTH) & ") must be at least 12 to address 4K memory space."
        severity error;
    end if;
    wait;
  end process errChk;
  -- pragma translate_on
  
  -- AXI4 Bus Read processing
  axiRead: process(ACLK, int_ARESETn)
    -- pragma translate_off
    variable buf : line;
    -- pragma translate_on
    variable useAddr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  begin
    if (int_ARESETn = '0') then
      read_state <= axi4r_idle;
      ARREADY_reg <= '1';
      RDATA_reg <= (others => '0');
      RRESP_reg <= AXI4_xRESP_OKAY;
      RLAST_reg <= '0';
      RVALID_reg <= '0';
      readAddr <= 0;
      readBurstCnt <= (others => '0');
    elsif rising_edge(ACLK) then
      if ((read_state = axi4r_idle) and (ARVALID = '1')) then
        useAddr := std_logic_vector(shift_right(unsigned(ARADDR) - unsigned(rbase_addr), addrShift));
        -- Protect from out of range addressing
        if (unsigned(useAddr) < depth) then
          if (cwidth < DATA_WIDTH) then
            RDATA_reg(DATA_WIDTH-1 downto cwidth) <= (others => '0');
            RDATA_reg(cwidth-1 downto 0) <= mem(to_integer(unsigned(useAddr)));
          else
            RDATA_reg <= mem(to_integer(unsigned(useAddr)));
          end if;
          --write(buf, string'("Slave AXI1 read:mem[0x"));
          --write(buf,  slv2hex(useAddr));
          --write(buf, string'("]=0x"));
          --write(buf,  slv2hex(mem(to_integer(unsigned(useAddr)))));
          --write(buf, string'(" at T="));
          --write(buf, now);
          --writeline(output, buf);
        else
          -- pragma translate_off
          write(buf, string'("Error:  Out-of-range AXI memory read access:0x"));
          write(buf,  slv2hex(ARADDR));
          write(buf, string'(" at T="));
          write(buf, now);
          writeline(output, buf);
          -- pragma translate_on
        end if;
        RRESP_reg <= AXI4_xRESP_OKAY;
        readAddr <= to_integer(unsigned(useAddr));
        readBurstCnt <= ARLEN;
        if (unsigned(ARLEN) = 0) then
          ARREADY_reg <= '0';
          RLAST_reg <= '1';
        end if;
        RVALID_reg <= '1';
        read_state <= axi4r_read;
      elsif (read_state = axi4r_read) then
        if (RREADY = '1') then
          if (unsigned(readBurstCnt) = 0) then
            -- we already sent the last data
            ARREADY_reg <= '1';
            RRESP_reg <= AXI4_xRESP_OKAY;
            RLAST_reg <= '0';
            RVALID_reg <= '0';
            read_state <= axi4r_idle;               
          else
            useAddr := std_logic_vector(to_unsigned(readAddr + 1, useAddr'length));
            readAddr <= readAddr + 1;
            -- Protect from out of range addressing
            if (unsigned(useAddr) < depth) then
              if (cwidth < DATA_WIDTH) then
                RDATA_reg(DATA_WIDTH-1 downto cwidth) <= (others => '0');
                RDATA_reg(cwidth-1 downto 0) <=  mem(to_integer(unsigned(useAddr)));
              else
                RDATA_reg <=  mem(to_integer(unsigned(useAddr)));
              end if;
              --write(buf, string'("Slave AXI2 read:mem[0x"));
              --write(buf,  slv2hex(useAddr));
              --write(buf, string'("]=0x"));
              --write(buf,  slv2hex(mem(to_integer(unsigned(useAddr)))));
              --write(buf, string'(" at T="));
              --write(buf, now);
              --writeline(output, buf);
            else
              -- We bursted right off the end of the array
              -- pragma translate_off
              write(buf, string'("Error:  Out-of-range AXI memory read access:0x"));
              write(buf,  slv2hex(ARADDR));
              write(buf, string'(" at T="));
              write(buf, now);
              writeline(output, buf);
              -- pragma translate_on
            end if;
            readBurstCnt <= std_logic_vector(unsigned(readBurstCnt) - 1);
            if ((unsigned(readBurstCnt) - 1) = 0) then
              ARREADY_reg <= '0';        
              RRESP_reg <= AXI4_xRESP_OKAY;
              RLAST_reg <= '1';
            end if;
            RVALID_reg <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;  -- axiRead process

   -- AXI and catapult write processing.
   -- Catapult write is one-cycle long so basically a write can happen
   -- in any axi state.  AXI has precedence in that catapult write is processed
   -- first at each cycle
  axiWrite: process(ACLK, int_ARESETn)
    -- pragma translate_off
    variable buf : line;
    -- pragma translate_on
    variable i : integer;
    variable useAddr : std_logic_vector(ADDR_WIDTH-1 downto 0);
  begin
    if (int_ARESETn = '0') then
      AWREADY_reg <= '1';
      WREADY_reg <= '1';
      BRESP_reg <= AXI4_xRESP_OKAY;
      BVALID_reg <= '0';
      write_state <= axi4w_idle;
      writeAddr <= 0;
      s_wrdy_reg <= '0';
      -- pragma translate_off
      for i in 0 to depth-1 loop 
        mem(i) <= (others => '0');
      end loop;
      -- pragma translate_on
    elsif rising_edge(ACLK) then
      -- When in idle state, catapult and AXI can both initiate writes.
      -- If to the same address, then AXI wins... in this implementation
      if ((s_we = '1') and (write_state = axi4w_idle) and (s_tdone = '0')) then
        mem(to_integer(unsigned(s_waddr))) <= s_dout;
        --write(buf, string'("Slave CAT1 write:mem[0x"));
        --write(buf,  slv2hex(s_waddr));
        --write(buf, string'("]=0x"));
        --write(buf,  slv2hex(s_dout));
        --write(buf, string'(" at T="));
        --write(buf, now);
        --writeline(output, buf);
      end if;
      if ((write_state = axi4w_idle) and (AWVALID = '1')) then
        s_wrdy_reg <= '0';
        AWREADY_reg <= '0';
        useAddr := std_logic_vector(shift_right(unsigned(AWADDR) - unsigned(wbase_addr), addrShift));
        -- $display("AWADDR=%d base_address=%d addrShift=%d useAddr=%d at T=%t",
        -- AWADDR, base_address, addrShift, useAddr, $time);
        if (WVALID = '1') then
          -- allow for address and data to be presented in one cycle
          -- Check for the write to be masked
          if (unsigned(WSTRB) /= 0) then -- all or nothing in our usage
            if (unsigned(useAddr) < depth) then
              if (cwidth < DATA_WIDTH) then
                mem(to_integer(unsigned(useAddr))) <= WDATA(cwidth-1 downto 0);
              else
                mem(to_integer(unsigned(useAddr))) <= WDATA;
              end if;
              --write(buf, string'("Slave AXI1 write:mem[0x"));
              --write(buf,  slv2hex(useAddr));
              --write(buf, string'("]=0x"));
              --write(buf,  slv2hex(WDATA));
              --write(buf, string'(" at T="));
              --write(buf, now);
              --writeline(output, buf);
            else
              -- pragma translate_off
              write(buf, string'("Error:  Out-of-range AXI memory write access:0x"));
              write(buf,  slv2hex(AWADDR));
              write(buf, string'(" at T="));
              write(buf, now);
              writeline(output, buf);
              -- pragma translate_on
            end if;
          end if;
        end if;
        writeAddr <= to_integer(unsigned(useAddr));
        if ((WLAST = '1') and (WVALID = '1')) then
          write_state <= axi4w_write_done;
          WREADY_reg <= '0';
          BRESP_reg <= AXI4_xRESP_OKAY;
          BVALID_reg <= '1';
        else
          write_state <= axi4w_write;
        end if;
      elsif (write_state = axi4w_write) then
        if (WVALID = '1') then
          useAddr := std_logic_vector(to_unsigned(writeAddr+1, useAddr'length));
          if (unsigned(WSTRB) /= 0) then
            if (unsigned(useAddr) < depth) then
              if (cwidth < DATA_WIDTH) then
                mem(to_integer(unsigned(useAddr))) <= WDATA(cwidth-1 downto 0);
              else
                mem(to_integer(unsigned(useAddr))) <= WDATA;
              end if;
              --write(buf, string'("Slave AXI2 write:mem[0x"));
              --write(buf,  slv2hex(useAddr));
              --write(buf, string'("]=0x"));
              --write(buf,  slv2hex(WDATA));
              --write(buf, string'(" at T="));
              --write(buf, now);
              --writeline(output, buf);
            else 
              -- pragma translate_off
              write(buf, string'("Error:  Out-of-range AXI memory write access:0x"));
              write(buf,  slv2hex(AWADDR));
              write(buf, string'(" at T="));
              write(buf, now);
              writeline(output, buf);
              -- pragma translate_on
            end if;
          end if;
          writeAddr <= to_integer(unsigned(useAddr));
          if (WLAST = '1') then
            write_state <= axi4w_write_done;
            WREADY_reg <= '0';
            BRESP_reg <= AXI4_xRESP_OKAY;
            BVALID_reg <= '1';
          end if;
        end if;
      elsif (write_state = axi4w_write_done) then
        if (BREADY = '1') then
          AWREADY_reg <= '1';
          WREADY_reg <= '1';
          BRESP_reg <= AXI4_xRESP_OKAY;
          BVALID_reg <= '0';
          write_state <= axi4w_idle;
          s_wrdy_reg <= '1';
        end if;
      else
        s_wrdy_reg <= '1';
      end if;
    end if;
  end process; -- axiWrite

  rCatOutOfOrder <= '1' when (s_re = '1') and
                             (s_rrdy_reg = '1') and
                             (catIsReading = '1') and
                             (next_raddr /= to_integer(unsigned(extCatAddr(s_raddr)))+1)
                  else '0';
  
  -- Catapult read processing
  catRead : process(ACLK, int_ARESETn)
    -- pragma translate_off
    variable buf : line;
    -- pragma translate_on
  begin
    if (int_ARESETn = '0') then
      s_din_reg <= (others => '0');
      s_rrdy_reg <= '0';
      catIsReading <= '0';
      next_raddr <= 0;
    elsif rising_edge(ACLK) then
      -- Catapult has read access to memory
      if ((tr_write_done = '1') or (nopreload /= 0)) then
        if ( s_re = '1') then
          --$display("Slave CAT read.  Addr=%x Data=%d T=%t", s_raddr, mem[s_raddr], $time);
          --write(buf, string'("Slave CAT read.  Addr=0x"));
          --write(buf,  slv2hex(s_raddr));
          --write(buf, string'(" Data=0x"));
          --write(buf,  slv2hex(mem(to_integer(unsigned(s_raddr)))));
          --write(buf, string'(" T="));
          --write(buf, now);
          --writeline(output, buf);
          if ((catIsReading = '1') and (rCatOutOfOrder /= '1')) then
            -- Make sure next_addr hasnt incremented off the end
            if (next_raddr < depth) then 
              s_din_reg <= mem(next_raddr);
              next_raddr <= next_raddr+1;
            else
              s_rrdy_reg <= '0';
              catIsReading <= '0';
              next_raddr <= 0;                  
            end if;
          else
            s_din_reg <= mem(to_integer(unsigned(s_raddr)));
            s_rrdy_reg <= '1';
            next_raddr <= to_integer(unsigned(extCatAddr(s_raddr)))+1;
            if ((catIsReading = '1') and (rCatOutOfOrder = '1')) then
              catIsReading <= '0';
            else
              catIsReading <= '1';
            end if;
          end if;
        else
          s_rrdy_reg <= '0';
          catIsReading <= '0';
          next_raddr <= 0;
        end if;
      else
        s_rrdy_reg <= '0';
        catIsReading <= '0';
        next_raddr <= 0;
      end if;
    end if;
  end process;    -- catRead 
  
END rtl;

--------> /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/pkgs/siflibs/mgc_io_sync_v2.vhd 
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
PACKAGE mgc_io_sync_pkg_v2 IS

COMPONENT mgc_io_sync_v2
  GENERIC (
    valid    : INTEGER RANGE 0 TO 1
  );
  PORT (
    ld       : IN    std_logic;
    lz       : OUT   std_logic
  );
END COMPONENT;

END mgc_io_sync_pkg_v2;

LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; -- Prevent STARC 2.1.1.2 violation

ENTITY mgc_io_sync_v2 IS
  GENERIC (
    valid    : INTEGER RANGE 0 TO 1
  );
  PORT (
    ld       : IN    std_logic;
    lz       : OUT   std_logic
  );
END mgc_io_sync_v2;

ARCHITECTURE beh OF mgc_io_sync_v2 IS
BEGIN

  lz <= ld;

END beh;


--------> /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/pkgs/siflibs/mgc_in_sync_v2.vhd 
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
PACKAGE mgc_in_sync_pkg_v2 IS

COMPONENT mgc_in_sync_v2
  GENERIC (
    valid    : INTEGER RANGE 0 TO 1
  );
  PORT (
    vd       : OUT   std_logic;
    vz       : IN    std_logic
  );
END COMPONENT;

END mgc_in_sync_pkg_v2;

LIBRARY ieee;

USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; -- Prevent STARC 2.1.1.2 violation

ENTITY mgc_in_sync_v2 IS
  GENERIC (
    valid    : INTEGER RANGE 0 TO 1
  );
  PORT (
    vd       : OUT   std_logic;
    vz       : IN    std_logic
  );
END mgc_in_sync_v2;

ARCHITECTURE beh OF mgc_in_sync_v2 IS
BEGIN

  vd <= vz;

END beh;



--------> /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/pkgs/ccs_xilinx/hdl/BLOCK_1R1W_RBW.vhd 

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
--  HLS Version:    10.4/828904 Production Release
--  HLS Date:       Thu Jul 25 13:12:11 PDT 2019
-- 
--  Generated by:   mdk@mdk-FX504
--  Generated date: Sun Oct 13 12:33:19 2019
-- ----------------------------------------------------------------------

-- 
-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_12_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_12_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_12_gen;

ARCHITECTURE v1 OF histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_12_gen
    IS
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
--  Design Unit:    histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_11_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_11_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_11_gen;

ARCHITECTURE v1 OF histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_11_gen
    IS
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
--  Design Unit:    histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_10_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_10_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_10_gen;

ARCHITECTURE v1 OF histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_10_gen
    IS
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
--  Design Unit:    histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_9_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_9_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_9_gen;

ARCHITECTURE v1 OF histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_9_gen
    IS
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
--  Design Unit:    histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_8_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_8_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_8_gen;

ARCHITECTURE v1 OF histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_8_gen
    IS
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
--  Design Unit:    histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_7_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_7_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_7_gen;

ARCHITECTURE v1 OF histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_7_gen
    IS
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
--  Design Unit:    histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_6_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_6_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_6_gen;

ARCHITECTURE v1 OF histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_6_gen
    IS
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
--  Design Unit:    histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_5_gen
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_5_gen IS
  PORT(
    we : OUT STD_LOGIC;
    d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    re : OUT STD_LOGIC;
    q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    we_d : IN STD_LOGIC;
    re_d : IN STD_LOGIC;
    q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_5_gen;

ARCHITECTURE v1 OF histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_5_gen
    IS
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
--  Design Unit:    histogram_hls_core_core_fsm
--  FSM Module
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_core_fsm IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    fsm_output : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
    hist8_vinit_C_1_tr0 : IN STD_LOGIC;
    hist_loop_C_10_tr0 : IN STD_LOGIC;
    accum_loop_C_2_tr0 : IN STD_LOGIC
  );
END histogram_hls_core_core_fsm;

ARCHITECTURE v1 OF histogram_hls_core_core_fsm IS
  -- Default Constants

  -- FSM State Type Declaration for histogram_hls_core_core_fsm_1
  TYPE histogram_hls_core_core_fsm_1_ST IS (core_rlp_C_0, main_C_0, hist8_vinit_C_0,
      hist8_vinit_C_1, hist_loop_C_0, hist_loop_C_1, hist_loop_C_2, hist_loop_C_3,
      hist_loop_C_4, hist_loop_C_5, hist_loop_C_6, hist_loop_C_7, hist_loop_C_8,
      hist_loop_C_9, hist_loop_C_10, main_C_1, accum_loop_C_0, accum_loop_C_1, accum_loop_C_2,
      main_C_2);

  SIGNAL state_var : histogram_hls_core_core_fsm_1_ST;
  SIGNAL state_var_NS : histogram_hls_core_core_fsm_1_ST;

BEGIN
  histogram_hls_core_core_fsm_1 : PROCESS (hist8_vinit_C_1_tr0, hist_loop_C_10_tr0,
      accum_loop_C_2_tr0, state_var)
  BEGIN
    CASE state_var IS
      WHEN main_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000000010");
        state_var_NS <= hist8_vinit_C_0;
      WHEN hist8_vinit_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000000100");
        state_var_NS <= hist8_vinit_C_1;
      WHEN hist8_vinit_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000001000");
        IF ( hist8_vinit_C_1_tr0 = '1' ) THEN
          state_var_NS <= hist_loop_C_0;
        ELSE
          state_var_NS <= hist8_vinit_C_0;
        END IF;
      WHEN hist_loop_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000010000");
        state_var_NS <= hist_loop_C_1;
      WHEN hist_loop_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000100000");
        state_var_NS <= hist_loop_C_2;
      WHEN hist_loop_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000001000000");
        state_var_NS <= hist_loop_C_3;
      WHEN hist_loop_C_3 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000010000000");
        state_var_NS <= hist_loop_C_4;
      WHEN hist_loop_C_4 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000100000000");
        state_var_NS <= hist_loop_C_5;
      WHEN hist_loop_C_5 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000001000000000");
        state_var_NS <= hist_loop_C_6;
      WHEN hist_loop_C_6 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000010000000000");
        state_var_NS <= hist_loop_C_7;
      WHEN hist_loop_C_7 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000100000000000");
        state_var_NS <= hist_loop_C_8;
      WHEN hist_loop_C_8 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000001000000000000");
        state_var_NS <= hist_loop_C_9;
      WHEN hist_loop_C_9 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000010000000000000");
        state_var_NS <= hist_loop_C_10;
      WHEN hist_loop_C_10 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000100000000000000");
        IF ( hist_loop_C_10_tr0 = '1' ) THEN
          state_var_NS <= main_C_1;
        ELSE
          state_var_NS <= hist_loop_C_0;
        END IF;
      WHEN main_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00001000000000000000");
        state_var_NS <= accum_loop_C_0;
      WHEN accum_loop_C_0 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00010000000000000000");
        state_var_NS <= accum_loop_C_1;
      WHEN accum_loop_C_1 =>
        fsm_output <= STD_LOGIC_VECTOR'( "00100000000000000000");
        state_var_NS <= accum_loop_C_2;
      WHEN accum_loop_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "01000000000000000000");
        IF ( accum_loop_C_2_tr0 = '1' ) THEN
          state_var_NS <= main_C_2;
        ELSE
          state_var_NS <= accum_loop_C_0;
        END IF;
      WHEN main_C_2 =>
        fsm_output <= STD_LOGIC_VECTOR'( "10000000000000000000");
        state_var_NS <= main_C_0;
      -- core_rlp_C_0
      WHEN OTHERS =>
        fsm_output <= STD_LOGIC_VECTOR'( "00000000000000000001");
        state_var_NS <= main_C_0;
    END CASE;
  END PROCESS histogram_hls_core_core_fsm_1;

  histogram_hls_core_core_fsm_1_REG : PROCESS (clk)
  BEGIN
    IF clk'event AND ( clk = '1' ) THEN
      IF ( rst = '1' ) THEN
        state_var <= core_rlp_C_0;
      ELSE
        IF ( core_wen = '1' ) THEN
          state_var <= state_var_NS;
        END IF;
      END IF;
    END IF;
  END PROCESS histogram_hls_core_core_fsm_1_REG;

END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_staller
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_staller IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    core_wen : OUT STD_LOGIC;
    core_wten : OUT STD_LOGIC;
    data_in_rsci_wen_comp : IN STD_LOGIC;
    hist_out_rsci_wen_comp : IN STD_LOGIC;
    hist_out_rsci_wen_comp_1 : IN STD_LOGIC;
    data_in_rsc_req_obj_wen_comp : IN STD_LOGIC;
    hist_out_rsc_req_obj_wen_comp : IN STD_LOGIC
  );
END histogram_hls_core_staller;

ARCHITECTURE v1 OF histogram_hls_core_staller IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL core_wen_drv : STD_LOGIC;

  -- Interconnect Declarations
  SIGNAL core_wten_reg : STD_LOGIC;

BEGIN
  -- Output Reader Assignments
  core_wen <= core_wen_drv;

  core_wen_drv <= data_in_rsci_wen_comp AND hist_out_rsci_wen_comp AND hist_out_rsci_wen_comp_1
      AND data_in_rsc_req_obj_wen_comp AND hist_out_rsc_req_obj_wen_comp;
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
--  Design Unit:    histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist_out_rsc_req_obj_oswt : IN STD_LOGIC;
    hist_out_rsc_req_obj_wen_comp : OUT STD_LOGIC;
    hist_out_rsc_req_obj_biwt : IN STD_LOGIC;
    hist_out_rsc_req_obj_bdwt : IN STD_LOGIC;
    hist_out_rsc_req_obj_bcwt : OUT STD_LOGIC
  );
END histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_dp
    IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist_out_rsc_req_obj_bcwt_drv : STD_LOGIC;

BEGIN
  -- Output Reader Assignments
  hist_out_rsc_req_obj_bcwt <= hist_out_rsc_req_obj_bcwt_drv;

  hist_out_rsc_req_obj_wen_comp <= (NOT hist_out_rsc_req_obj_oswt) OR hist_out_rsc_req_obj_biwt
      OR hist_out_rsc_req_obj_bcwt_drv;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist_out_rsc_req_obj_bcwt_drv <= '0';
      ELSE
        hist_out_rsc_req_obj_bcwt_drv <= NOT((NOT(hist_out_rsc_req_obj_bcwt_drv OR
            hist_out_rsc_req_obj_biwt)) OR hist_out_rsc_req_obj_bdwt);
      END IF;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    hist_out_rsc_req_obj_oswt : IN STD_LOGIC;
    hist_out_rsc_req_obj_vd : IN STD_LOGIC;
    hist_out_rsc_req_obj_biwt : OUT STD_LOGIC;
    hist_out_rsc_req_obj_bdwt : OUT STD_LOGIC;
    hist_out_rsc_req_obj_bcwt : IN STD_LOGIC
  );
END histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl
    IS
  -- Default Constants

BEGIN
  hist_out_rsc_req_obj_bdwt <= hist_out_rsc_req_obj_oswt AND core_wen;
  hist_out_rsc_req_obj_biwt <= hist_out_rsc_req_obj_oswt AND (NOT hist_out_rsc_req_obj_bcwt)
      AND hist_out_rsc_req_obj_vd;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_in_rsc_req_obj_oswt : IN STD_LOGIC;
    data_in_rsc_req_obj_wen_comp : OUT STD_LOGIC;
    data_in_rsc_req_obj_biwt : IN STD_LOGIC;
    data_in_rsc_req_obj_bdwt : IN STD_LOGIC;
    data_in_rsc_req_obj_bcwt : OUT STD_LOGIC
  );
END histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_dp
    IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL data_in_rsc_req_obj_bcwt_drv : STD_LOGIC;

BEGIN
  -- Output Reader Assignments
  data_in_rsc_req_obj_bcwt <= data_in_rsc_req_obj_bcwt_drv;

  data_in_rsc_req_obj_wen_comp <= (NOT data_in_rsc_req_obj_oswt) OR data_in_rsc_req_obj_biwt
      OR data_in_rsc_req_obj_bcwt_drv;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        data_in_rsc_req_obj_bcwt_drv <= '0';
      ELSE
        data_in_rsc_req_obj_bcwt_drv <= NOT((NOT(data_in_rsc_req_obj_bcwt_drv OR
            data_in_rsc_req_obj_biwt)) OR data_in_rsc_req_obj_bdwt);
      END IF;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    data_in_rsc_req_obj_oswt : IN STD_LOGIC;
    data_in_rsc_req_obj_vd : IN STD_LOGIC;
    data_in_rsc_req_obj_biwt : OUT STD_LOGIC;
    data_in_rsc_req_obj_bdwt : OUT STD_LOGIC;
    data_in_rsc_req_obj_bcwt : IN STD_LOGIC
  );
END histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl
    IS
  -- Default Constants

BEGIN
  data_in_rsc_req_obj_bdwt <= data_in_rsc_req_obj_oswt AND core_wen;
  data_in_rsc_req_obj_biwt <= data_in_rsc_req_obj_oswt AND (NOT data_in_rsc_req_obj_bcwt)
      AND data_in_rsc_req_obj_vd;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl IS
  PORT(
    core_wten : IN STD_LOGIC;
    data_in_rsc_rls_obj_iswt0 : IN STD_LOGIC;
    data_in_rsc_rls_obj_ld_core_sct : OUT STD_LOGIC
  );
END histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl
    IS
  -- Default Constants

BEGIN
  data_in_rsc_rls_obj_ld_core_sct <= data_in_rsc_rls_obj_iswt0 AND (NOT core_wten);
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl IS
  PORT(
    core_wten : IN STD_LOGIC;
    hist_out_rsc_rls_obj_iswt0 : IN STD_LOGIC;
    hist_out_rsc_rls_obj_ld_core_sct : OUT STD_LOGIC
  );
END histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl
    IS
  -- Default Constants

BEGIN
  hist_out_rsc_rls_obj_ld_core_sct <= hist_out_rsc_rls_obj_iswt0 AND (NOT core_wten);
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist8_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_biwt : IN STD_LOGIC;
    hist8_rsci_bdwt : IN STD_LOGIC;
    hist8_rsci_radr_d_core_sct : IN STD_LOGIC;
    hist8_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist8_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (31 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL hist8_rsci_bcwt : STD_LOGIC;
  SIGNAL hist8_rsci_q_d_bfwt : STD_LOGIC_VECTOR (31 DOWNTO 0);

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
  hist8_rsci_q_d_mxwt <= hist8_rsci_q_d_mxwt_drv;

  hist8_rsci_q_d_mxwt_drv <= MUX_v_32_2_2(hist8_rsci_q_d, hist8_rsci_q_d_bfwt, hist8_rsci_bcwt);
  hist8_rsci_radr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist8_rsci_radr_d_core,
      hist8_rsci_radr_d_core_sct);
  hist8_rsci_wadr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist8_rsci_wadr_d_core,
      hist8_rsci_wadr_d_core_sct_pff);
  hist8_rsci_d_d <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      hist8_rsci_d_d_core, hist8_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist8_rsci_bcwt <= '0';
      ELSE
        hist8_rsci_bcwt <= NOT((NOT(hist8_rsci_bcwt OR hist8_rsci_biwt)) OR hist8_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      hist8_rsci_q_d_bfwt <= hist8_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist8_rsci_oswt : IN STD_LOGIC;
    hist8_rsci_biwt : OUT STD_LOGIC;
    hist8_rsci_bdwt : OUT STD_LOGIC;
    hist8_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    hist8_rsci_oswt_pff : IN STD_LOGIC;
    hist8_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    hist8_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  hist8_rsci_bdwt <= hist8_rsci_oswt AND core_wen;
  hist8_rsci_biwt <= (NOT core_wten) AND hist8_rsci_oswt;
  hist8_rsci_radr_d_core_sct_pff <= hist8_rsci_oswt_pff AND core_wen;
  hist8_rsci_wadr_d_core_sct_pff <= hist8_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist7_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_biwt : IN STD_LOGIC;
    hist7_rsci_bdwt : IN STD_LOGIC;
    hist7_rsci_radr_d_core_sct : IN STD_LOGIC;
    hist7_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist7_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (31 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL hist7_rsci_bcwt : STD_LOGIC;
  SIGNAL hist7_rsci_q_d_bfwt : STD_LOGIC_VECTOR (31 DOWNTO 0);

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
  hist7_rsci_q_d_mxwt <= hist7_rsci_q_d_mxwt_drv;

  hist7_rsci_q_d_mxwt_drv <= MUX_v_32_2_2(hist7_rsci_q_d, hist7_rsci_q_d_bfwt, hist7_rsci_bcwt);
  hist7_rsci_radr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist7_rsci_radr_d_core,
      hist7_rsci_radr_d_core_sct);
  hist7_rsci_wadr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist7_rsci_wadr_d_core,
      hist7_rsci_wadr_d_core_sct_pff);
  hist7_rsci_d_d <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      hist7_rsci_d_d_core, hist7_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist7_rsci_bcwt <= '0';
      ELSE
        hist7_rsci_bcwt <= NOT((NOT(hist7_rsci_bcwt OR hist7_rsci_biwt)) OR hist7_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      hist7_rsci_q_d_bfwt <= hist7_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist7_rsci_oswt : IN STD_LOGIC;
    hist7_rsci_biwt : OUT STD_LOGIC;
    hist7_rsci_bdwt : OUT STD_LOGIC;
    hist7_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    hist7_rsci_oswt_pff : IN STD_LOGIC;
    hist7_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    hist7_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  hist7_rsci_bdwt <= hist7_rsci_oswt AND core_wen;
  hist7_rsci_biwt <= (NOT core_wten) AND hist7_rsci_oswt;
  hist7_rsci_radr_d_core_sct_pff <= hist7_rsci_oswt_pff AND core_wen;
  hist7_rsci_wadr_d_core_sct_pff <= hist7_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist6_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_biwt : IN STD_LOGIC;
    hist6_rsci_bdwt : IN STD_LOGIC;
    hist6_rsci_radr_d_core_sct : IN STD_LOGIC;
    hist6_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist6_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (31 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL hist6_rsci_bcwt : STD_LOGIC;
  SIGNAL hist6_rsci_q_d_bfwt : STD_LOGIC_VECTOR (31 DOWNTO 0);

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
  hist6_rsci_q_d_mxwt <= hist6_rsci_q_d_mxwt_drv;

  hist6_rsci_q_d_mxwt_drv <= MUX_v_32_2_2(hist6_rsci_q_d, hist6_rsci_q_d_bfwt, hist6_rsci_bcwt);
  hist6_rsci_radr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist6_rsci_radr_d_core,
      hist6_rsci_radr_d_core_sct);
  hist6_rsci_wadr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist6_rsci_wadr_d_core,
      hist6_rsci_wadr_d_core_sct_pff);
  hist6_rsci_d_d <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      hist6_rsci_d_d_core, hist6_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist6_rsci_bcwt <= '0';
      ELSE
        hist6_rsci_bcwt <= NOT((NOT(hist6_rsci_bcwt OR hist6_rsci_biwt)) OR hist6_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      hist6_rsci_q_d_bfwt <= hist6_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist6_rsci_oswt : IN STD_LOGIC;
    hist6_rsci_biwt : OUT STD_LOGIC;
    hist6_rsci_bdwt : OUT STD_LOGIC;
    hist6_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    hist6_rsci_oswt_pff : IN STD_LOGIC;
    hist6_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    hist6_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  hist6_rsci_bdwt <= hist6_rsci_oswt AND core_wen;
  hist6_rsci_biwt <= (NOT core_wten) AND hist6_rsci_oswt;
  hist6_rsci_radr_d_core_sct_pff <= hist6_rsci_oswt_pff AND core_wen;
  hist6_rsci_wadr_d_core_sct_pff <= hist6_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist5_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_biwt : IN STD_LOGIC;
    hist5_rsci_bdwt : IN STD_LOGIC;
    hist5_rsci_radr_d_core_sct : IN STD_LOGIC;
    hist5_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist5_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (31 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL hist5_rsci_bcwt : STD_LOGIC;
  SIGNAL hist5_rsci_q_d_bfwt : STD_LOGIC_VECTOR (31 DOWNTO 0);

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
  hist5_rsci_q_d_mxwt <= hist5_rsci_q_d_mxwt_drv;

  hist5_rsci_q_d_mxwt_drv <= MUX_v_32_2_2(hist5_rsci_q_d, hist5_rsci_q_d_bfwt, hist5_rsci_bcwt);
  hist5_rsci_radr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist5_rsci_radr_d_core,
      hist5_rsci_radr_d_core_sct);
  hist5_rsci_wadr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist5_rsci_wadr_d_core,
      hist5_rsci_wadr_d_core_sct_pff);
  hist5_rsci_d_d <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      hist5_rsci_d_d_core, hist5_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist5_rsci_bcwt <= '0';
      ELSE
        hist5_rsci_bcwt <= NOT((NOT(hist5_rsci_bcwt OR hist5_rsci_biwt)) OR hist5_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      hist5_rsci_q_d_bfwt <= hist5_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist5_rsci_oswt : IN STD_LOGIC;
    hist5_rsci_biwt : OUT STD_LOGIC;
    hist5_rsci_bdwt : OUT STD_LOGIC;
    hist5_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    hist5_rsci_oswt_pff : IN STD_LOGIC;
    hist5_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    hist5_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  hist5_rsci_bdwt <= hist5_rsci_oswt AND core_wen;
  hist5_rsci_biwt <= (NOT core_wten) AND hist5_rsci_oswt;
  hist5_rsci_radr_d_core_sct_pff <= hist5_rsci_oswt_pff AND core_wen;
  hist5_rsci_wadr_d_core_sct_pff <= hist5_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist4_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_biwt : IN STD_LOGIC;
    hist4_rsci_bdwt : IN STD_LOGIC;
    hist4_rsci_radr_d_core_sct : IN STD_LOGIC;
    hist4_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist4_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (31 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL hist4_rsci_bcwt : STD_LOGIC;
  SIGNAL hist4_rsci_q_d_bfwt : STD_LOGIC_VECTOR (31 DOWNTO 0);

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
  hist4_rsci_q_d_mxwt <= hist4_rsci_q_d_mxwt_drv;

  hist4_rsci_q_d_mxwt_drv <= MUX_v_32_2_2(hist4_rsci_q_d, hist4_rsci_q_d_bfwt, hist4_rsci_bcwt);
  hist4_rsci_radr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist4_rsci_radr_d_core,
      hist4_rsci_radr_d_core_sct);
  hist4_rsci_wadr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist4_rsci_wadr_d_core,
      hist4_rsci_wadr_d_core_sct_pff);
  hist4_rsci_d_d <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      hist4_rsci_d_d_core, hist4_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist4_rsci_bcwt <= '0';
      ELSE
        hist4_rsci_bcwt <= NOT((NOT(hist4_rsci_bcwt OR hist4_rsci_biwt)) OR hist4_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      hist4_rsci_q_d_bfwt <= hist4_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist4_rsci_oswt : IN STD_LOGIC;
    hist4_rsci_biwt : OUT STD_LOGIC;
    hist4_rsci_bdwt : OUT STD_LOGIC;
    hist4_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    hist4_rsci_oswt_pff : IN STD_LOGIC;
    hist4_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    hist4_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  hist4_rsci_bdwt <= hist4_rsci_oswt AND core_wen;
  hist4_rsci_biwt <= (NOT core_wten) AND hist4_rsci_oswt;
  hist4_rsci_radr_d_core_sct_pff <= hist4_rsci_oswt_pff AND core_wen;
  hist4_rsci_wadr_d_core_sct_pff <= hist4_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist3_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_biwt : IN STD_LOGIC;
    hist3_rsci_bdwt : IN STD_LOGIC;
    hist3_rsci_radr_d_core_sct : IN STD_LOGIC;
    hist3_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist3_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (31 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL hist3_rsci_bcwt : STD_LOGIC;
  SIGNAL hist3_rsci_q_d_bfwt : STD_LOGIC_VECTOR (31 DOWNTO 0);

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
  hist3_rsci_q_d_mxwt <= hist3_rsci_q_d_mxwt_drv;

  hist3_rsci_q_d_mxwt_drv <= MUX_v_32_2_2(hist3_rsci_q_d, hist3_rsci_q_d_bfwt, hist3_rsci_bcwt);
  hist3_rsci_radr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist3_rsci_radr_d_core,
      hist3_rsci_radr_d_core_sct);
  hist3_rsci_wadr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist3_rsci_wadr_d_core,
      hist3_rsci_wadr_d_core_sct_pff);
  hist3_rsci_d_d <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      hist3_rsci_d_d_core, hist3_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist3_rsci_bcwt <= '0';
      ELSE
        hist3_rsci_bcwt <= NOT((NOT(hist3_rsci_bcwt OR hist3_rsci_biwt)) OR hist3_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      hist3_rsci_q_d_bfwt <= hist3_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist3_rsci_oswt : IN STD_LOGIC;
    hist3_rsci_biwt : OUT STD_LOGIC;
    hist3_rsci_bdwt : OUT STD_LOGIC;
    hist3_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    hist3_rsci_oswt_pff : IN STD_LOGIC;
    hist3_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    hist3_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  hist3_rsci_bdwt <= hist3_rsci_oswt AND core_wen;
  hist3_rsci_biwt <= (NOT core_wten) AND hist3_rsci_oswt;
  hist3_rsci_radr_d_core_sct_pff <= hist3_rsci_oswt_pff AND core_wen;
  hist3_rsci_wadr_d_core_sct_pff <= hist3_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist2_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_biwt : IN STD_LOGIC;
    hist2_rsci_bdwt : IN STD_LOGIC;
    hist2_rsci_radr_d_core_sct : IN STD_LOGIC;
    hist2_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist2_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (31 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL hist2_rsci_bcwt : STD_LOGIC;
  SIGNAL hist2_rsci_q_d_bfwt : STD_LOGIC_VECTOR (31 DOWNTO 0);

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
  hist2_rsci_q_d_mxwt <= hist2_rsci_q_d_mxwt_drv;

  hist2_rsci_q_d_mxwt_drv <= MUX_v_32_2_2(hist2_rsci_q_d, hist2_rsci_q_d_bfwt, hist2_rsci_bcwt);
  hist2_rsci_radr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist2_rsci_radr_d_core,
      hist2_rsci_radr_d_core_sct);
  hist2_rsci_wadr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist2_rsci_wadr_d_core,
      hist2_rsci_wadr_d_core_sct_pff);
  hist2_rsci_d_d <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      hist2_rsci_d_d_core, hist2_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist2_rsci_bcwt <= '0';
      ELSE
        hist2_rsci_bcwt <= NOT((NOT(hist2_rsci_bcwt OR hist2_rsci_biwt)) OR hist2_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      hist2_rsci_q_d_bfwt <= hist2_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist2_rsci_oswt : IN STD_LOGIC;
    hist2_rsci_biwt : OUT STD_LOGIC;
    hist2_rsci_bdwt : OUT STD_LOGIC;
    hist2_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    hist2_rsci_oswt_pff : IN STD_LOGIC;
    hist2_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    hist2_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  hist2_rsci_bdwt <= hist2_rsci_oswt AND core_wen;
  hist2_rsci_biwt <= (NOT core_wten) AND hist2_rsci_oswt;
  hist2_rsci_radr_d_core_sct_pff <= hist2_rsci_oswt_pff AND core_wen;
  hist2_rsci_wadr_d_core_sct_pff <= hist2_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist1_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist1_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist1_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist1_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist1_rsci_biwt : IN STD_LOGIC;
    hist1_rsci_bdwt : IN STD_LOGIC;
    hist1_rsci_radr_d_core_sct : IN STD_LOGIC;
    hist1_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist1_rsci_q_d_mxwt_drv : STD_LOGIC_VECTOR (31 DOWNTO 0);

  -- Interconnect Declarations
  SIGNAL hist1_rsci_bcwt : STD_LOGIC;
  SIGNAL hist1_rsci_q_d_bfwt : STD_LOGIC_VECTOR (31 DOWNTO 0);

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
  hist1_rsci_q_d_mxwt <= hist1_rsci_q_d_mxwt_drv;

  hist1_rsci_q_d_mxwt_drv <= MUX_v_32_2_2(hist1_rsci_q_d, hist1_rsci_q_d_bfwt, hist1_rsci_bcwt);
  hist1_rsci_radr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist1_rsci_radr_d_core,
      hist1_rsci_radr_d_core_sct);
  hist1_rsci_wadr_d <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist1_rsci_wadr_d_core,
      hist1_rsci_wadr_d_core_sct_pff);
  hist1_rsci_d_d <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      hist1_rsci_d_d_core, hist1_rsci_wadr_d_core_sct_pff);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist1_rsci_bcwt <= '0';
      ELSE
        hist1_rsci_bcwt <= NOT((NOT(hist1_rsci_bcwt OR hist1_rsci_biwt)) OR hist1_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      hist1_rsci_q_d_bfwt <= hist1_rsci_q_d_mxwt_drv;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist1_rsci_oswt : IN STD_LOGIC;
    hist1_rsci_biwt : OUT STD_LOGIC;
    hist1_rsci_bdwt : OUT STD_LOGIC;
    hist1_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
    hist1_rsci_oswt_pff : IN STD_LOGIC;
    hist1_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
    hist1_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_ctrl IS
  -- Default Constants

BEGIN
  hist1_rsci_bdwt <= hist1_rsci_oswt AND core_wen;
  hist1_rsci_biwt <= (NOT core_wten) AND hist1_rsci_oswt;
  hist1_rsci_radr_d_core_sct_pff <= hist1_rsci_oswt_pff AND core_wen;
  hist1_rsci_wadr_d_core_sct_pff <= hist1_rsci_iswt0_1_pff AND core_wen;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist_out_rsci_oswt : IN STD_LOGIC;
    hist_out_rsci_wen_comp : OUT STD_LOGIC;
    hist_out_rsci_oswt_1 : IN STD_LOGIC;
    hist_out_rsci_wen_comp_1 : OUT STD_LOGIC;
    hist_out_rsci_s_raddr_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsci_s_din_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsci_s_dout_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsci_biwt : IN STD_LOGIC;
    hist_out_rsci_bdwt : IN STD_LOGIC;
    hist_out_rsci_bcwt : OUT STD_LOGIC;
    hist_out_rsci_biwt_1 : IN STD_LOGIC;
    hist_out_rsci_bdwt_2 : IN STD_LOGIC;
    hist_out_rsci_bcwt_1 : OUT STD_LOGIC;
    hist_out_rsci_s_raddr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsci_s_raddr_core_sct : IN STD_LOGIC;
    hist_out_rsci_s_waddr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsci_s_waddr_core_sct : IN STD_LOGIC;
    hist_out_rsci_s_din : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsci_s_dout : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL hist_out_rsci_s_din_mxwt_drv : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_bcwt_drv : STD_LOGIC;
  SIGNAL hist_out_rsci_bcwt_1_drv : STD_LOGIC;

  -- Interconnect Declarations
  SIGNAL hist_out_rsci_s_din_bfwt : STD_LOGIC_VECTOR (7 DOWNTO 0);

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
  hist_out_rsci_s_din_mxwt <= hist_out_rsci_s_din_mxwt_drv;
  hist_out_rsci_bcwt <= hist_out_rsci_bcwt_drv;
  hist_out_rsci_bcwt_1 <= hist_out_rsci_bcwt_1_drv;

  hist_out_rsci_wen_comp <= (NOT hist_out_rsci_oswt) OR hist_out_rsci_biwt OR hist_out_rsci_bcwt_drv;
  hist_out_rsci_wen_comp_1 <= (NOT hist_out_rsci_oswt_1) OR hist_out_rsci_biwt_1
      OR hist_out_rsci_bcwt_1_drv;
  hist_out_rsci_s_raddr <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist_out_rsci_s_raddr_core,
      hist_out_rsci_s_raddr_core_sct);
  hist_out_rsci_s_waddr <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist_out_rsci_s_raddr_core,
      hist_out_rsci_s_waddr_core_sct);
  hist_out_rsci_s_din_mxwt_drv <= MUX_v_8_2_2(hist_out_rsci_s_din, hist_out_rsci_s_din_bfwt,
      hist_out_rsci_bcwt_drv);
  hist_out_rsci_s_dout <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), hist_out_rsci_s_dout_core,
      hist_out_rsci_s_waddr_core_sct);
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        hist_out_rsci_bcwt_drv <= '0';
        hist_out_rsci_bcwt_1_drv <= '0';
      ELSE
        hist_out_rsci_bcwt_drv <= NOT((NOT(hist_out_rsci_bcwt_drv OR hist_out_rsci_biwt))
            OR hist_out_rsci_bdwt);
        hist_out_rsci_bcwt_1_drv <= NOT((NOT(hist_out_rsci_bcwt_1_drv OR hist_out_rsci_biwt_1))
            OR hist_out_rsci_bdwt_2);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( hist_out_rsci_bcwt_drv = '0' ) THEN
        hist_out_rsci_s_din_bfwt <= hist_out_rsci_s_din_mxwt_drv;
      END IF;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    hist_out_rsci_oswt : IN STD_LOGIC;
    hist_out_rsci_oswt_1 : IN STD_LOGIC;
    hist_out_rsci_biwt : OUT STD_LOGIC;
    hist_out_rsci_bdwt : OUT STD_LOGIC;
    hist_out_rsci_bcwt : IN STD_LOGIC;
    hist_out_rsci_s_re_core_sct : OUT STD_LOGIC;
    hist_out_rsci_biwt_1 : OUT STD_LOGIC;
    hist_out_rsci_bdwt_2 : OUT STD_LOGIC;
    hist_out_rsci_bcwt_1 : IN STD_LOGIC;
    hist_out_rsci_s_we_core_sct : OUT STD_LOGIC;
    hist_out_rsci_s_rrdy : IN STD_LOGIC;
    hist_out_rsci_s_wrdy : IN STD_LOGIC
  );
END histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist_out_rsci_ogwt : STD_LOGIC;
  SIGNAL hist_out_rsci_ogwt_1 : STD_LOGIC;

BEGIN
  hist_out_rsci_bdwt <= hist_out_rsci_oswt AND core_wen;
  hist_out_rsci_biwt <= hist_out_rsci_ogwt AND hist_out_rsci_s_rrdy;
  hist_out_rsci_ogwt <= hist_out_rsci_oswt AND (NOT hist_out_rsci_bcwt);
  hist_out_rsci_s_re_core_sct <= hist_out_rsci_ogwt;
  hist_out_rsci_bdwt_2 <= hist_out_rsci_oswt_1 AND core_wen;
  hist_out_rsci_biwt_1 <= hist_out_rsci_ogwt_1 AND hist_out_rsci_s_wrdy;
  hist_out_rsci_ogwt_1 <= hist_out_rsci_oswt_1 AND (NOT hist_out_rsci_bcwt_1);
  hist_out_rsci_s_we_core_sct <= hist_out_rsci_ogwt_1;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_in_rsci_oswt : IN STD_LOGIC;
    data_in_rsci_wen_comp : OUT STD_LOGIC;
    data_in_rsci_s_raddr_core : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsci_s_din_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsci_biwt : IN STD_LOGIC;
    data_in_rsci_bdwt : IN STD_LOGIC;
    data_in_rsci_bcwt : OUT STD_LOGIC;
    data_in_rsci_s_raddr : OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsci_s_raddr_core_sct : IN STD_LOGIC;
    data_in_rsci_s_din : IN STD_LOGIC_VECTOR (15 DOWNTO 0)
  );
END histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp;

ARCHITECTURE v1 OF histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp IS
  -- Default Constants

  -- Output Reader Declarations
  SIGNAL data_in_rsci_bcwt_drv : STD_LOGIC;

  -- Interconnect Declarations
  SIGNAL data_in_rsci_s_din_bfwt_7_0 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL data_in_rsci_s_din_mxwt_opt_7_0 : STD_LOGIC_VECTOR (7 DOWNTO 0);

  FUNCTION MUX_v_13_2_2(input_0 : STD_LOGIC_VECTOR(12 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(12 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(12 DOWNTO 0);

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
  data_in_rsci_bcwt <= data_in_rsci_bcwt_drv;

  data_in_rsci_wen_comp <= (NOT data_in_rsci_oswt) OR data_in_rsci_biwt OR data_in_rsci_bcwt_drv;
  data_in_rsci_s_raddr <= MUX_v_13_2_2(STD_LOGIC_VECTOR'("0000000000000"), data_in_rsci_s_raddr_core,
      data_in_rsci_s_raddr_core_sct);
  data_in_rsci_s_din_mxwt_opt_7_0 <= MUX_v_8_2_2((data_in_rsci_s_din(7 DOWNTO 0)),
      data_in_rsci_s_din_bfwt_7_0, data_in_rsci_bcwt_drv);
  data_in_rsci_s_din_mxwt <= data_in_rsci_s_din_mxwt_opt_7_0;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        data_in_rsci_bcwt_drv <= '0';
      ELSE
        data_in_rsci_bcwt_drv <= NOT((NOT(data_in_rsci_bcwt_drv OR data_in_rsci_biwt))
            OR data_in_rsci_bdwt);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      data_in_rsci_s_din_bfwt_7_0 <= data_in_rsci_s_din_mxwt_opt_7_0;
    END IF;
  END PROCESS;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl IS
  PORT(
    core_wen : IN STD_LOGIC;
    data_in_rsci_oswt : IN STD_LOGIC;
    data_in_rsci_biwt : OUT STD_LOGIC;
    data_in_rsci_bdwt : OUT STD_LOGIC;
    data_in_rsci_bcwt : IN STD_LOGIC;
    data_in_rsci_s_re_core_sct : OUT STD_LOGIC;
    data_in_rsci_s_rrdy : IN STD_LOGIC
  );
END histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl;

ARCHITECTURE v1 OF histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL data_in_rsci_ogwt : STD_LOGIC;

BEGIN
  data_in_rsci_bdwt <= data_in_rsci_oswt AND core_wen;
  data_in_rsci_biwt <= data_in_rsci_ogwt AND data_in_rsci_s_rrdy;
  data_in_rsci_ogwt <= data_in_rsci_oswt AND (NOT data_in_rsci_bcwt);
  data_in_rsci_s_re_core_sct <= data_in_rsci_ogwt;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist_out_rsc_req_obj
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist_out_rsc_req_obj IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist_out_rsc_req_vz : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    hist_out_rsc_req_obj_oswt : IN STD_LOGIC;
    hist_out_rsc_req_obj_wen_comp : OUT STD_LOGIC
  );
END histogram_hls_core_hist_out_rsc_req_obj;

ARCHITECTURE v1 OF histogram_hls_core_hist_out_rsc_req_obj IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist_out_rsc_req_obj_vd : STD_LOGIC;
  SIGNAL hist_out_rsc_req_obj_biwt : STD_LOGIC;
  SIGNAL hist_out_rsc_req_obj_bdwt : STD_LOGIC;
  SIGNAL hist_out_rsc_req_obj_bcwt : STD_LOGIC;

  COMPONENT histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      hist_out_rsc_req_obj_oswt : IN STD_LOGIC;
      hist_out_rsc_req_obj_vd : IN STD_LOGIC;
      hist_out_rsc_req_obj_biwt : OUT STD_LOGIC;
      hist_out_rsc_req_obj_bdwt : OUT STD_LOGIC;
      hist_out_rsc_req_obj_bcwt : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist_out_rsc_req_obj_oswt : IN STD_LOGIC;
      hist_out_rsc_req_obj_wen_comp : OUT STD_LOGIC;
      hist_out_rsc_req_obj_biwt : IN STD_LOGIC;
      hist_out_rsc_req_obj_bdwt : IN STD_LOGIC;
      hist_out_rsc_req_obj_bcwt : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN
  hist_out_rsc_req_obj : work.mgc_in_sync_pkg_v2.mgc_in_sync_v2
    GENERIC MAP(
      valid => 1
      )
    PORT MAP(
      vd => hist_out_rsc_req_obj_vd,
      vz => hist_out_rsc_req_vz
    );
  histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl_inst : histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      hist_out_rsc_req_obj_oswt => hist_out_rsc_req_obj_oswt,
      hist_out_rsc_req_obj_vd => hist_out_rsc_req_obj_vd,
      hist_out_rsc_req_obj_biwt => hist_out_rsc_req_obj_biwt,
      hist_out_rsc_req_obj_bdwt => hist_out_rsc_req_obj_bdwt,
      hist_out_rsc_req_obj_bcwt => hist_out_rsc_req_obj_bcwt
    );
  histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_dp_inst : histogram_hls_core_hist_out_rsc_req_obj_hist_out_rsc_req_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist_out_rsc_req_obj_oswt => hist_out_rsc_req_obj_oswt,
      hist_out_rsc_req_obj_wen_comp => hist_out_rsc_req_obj_wen_comp,
      hist_out_rsc_req_obj_biwt => hist_out_rsc_req_obj_biwt,
      hist_out_rsc_req_obj_bdwt => hist_out_rsc_req_obj_bdwt,
      hist_out_rsc_req_obj_bcwt => hist_out_rsc_req_obj_bcwt
    );
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_data_in_rsc_req_obj
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_data_in_rsc_req_obj IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_in_rsc_req_vz : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    data_in_rsc_req_obj_oswt : IN STD_LOGIC;
    data_in_rsc_req_obj_wen_comp : OUT STD_LOGIC
  );
END histogram_hls_core_data_in_rsc_req_obj;

ARCHITECTURE v1 OF histogram_hls_core_data_in_rsc_req_obj IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL data_in_rsc_req_obj_vd : STD_LOGIC;
  SIGNAL data_in_rsc_req_obj_biwt : STD_LOGIC;
  SIGNAL data_in_rsc_req_obj_bdwt : STD_LOGIC;
  SIGNAL data_in_rsc_req_obj_bcwt : STD_LOGIC;

  COMPONENT histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      data_in_rsc_req_obj_oswt : IN STD_LOGIC;
      data_in_rsc_req_obj_vd : IN STD_LOGIC;
      data_in_rsc_req_obj_biwt : OUT STD_LOGIC;
      data_in_rsc_req_obj_bdwt : OUT STD_LOGIC;
      data_in_rsc_req_obj_bcwt : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      data_in_rsc_req_obj_oswt : IN STD_LOGIC;
      data_in_rsc_req_obj_wen_comp : OUT STD_LOGIC;
      data_in_rsc_req_obj_biwt : IN STD_LOGIC;
      data_in_rsc_req_obj_bdwt : IN STD_LOGIC;
      data_in_rsc_req_obj_bcwt : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN
  data_in_rsc_req_obj : work.mgc_in_sync_pkg_v2.mgc_in_sync_v2
    GENERIC MAP(
      valid => 1
      )
    PORT MAP(
      vd => data_in_rsc_req_obj_vd,
      vz => data_in_rsc_req_vz
    );
  histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl_inst : histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      data_in_rsc_req_obj_oswt => data_in_rsc_req_obj_oswt,
      data_in_rsc_req_obj_vd => data_in_rsc_req_obj_vd,
      data_in_rsc_req_obj_biwt => data_in_rsc_req_obj_biwt,
      data_in_rsc_req_obj_bdwt => data_in_rsc_req_obj_bdwt,
      data_in_rsc_req_obj_bcwt => data_in_rsc_req_obj_bcwt
    );
  histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_dp_inst : histogram_hls_core_data_in_rsc_req_obj_data_in_rsc_req_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      data_in_rsc_req_obj_oswt => data_in_rsc_req_obj_oswt,
      data_in_rsc_req_obj_wen_comp => data_in_rsc_req_obj_wen_comp,
      data_in_rsc_req_obj_biwt => data_in_rsc_req_obj_biwt,
      data_in_rsc_req_obj_bdwt => data_in_rsc_req_obj_bdwt,
      data_in_rsc_req_obj_bcwt => data_in_rsc_req_obj_bcwt
    );
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_data_in_rsc_rls_obj
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_data_in_rsc_rls_obj IS
  PORT(
    data_in_rsc_rls_lz : OUT STD_LOGIC;
    core_wten : IN STD_LOGIC;
    data_in_rsc_rls_obj_iswt0 : IN STD_LOGIC
  );
END histogram_hls_core_data_in_rsc_rls_obj;

ARCHITECTURE v1 OF histogram_hls_core_data_in_rsc_rls_obj IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL data_in_rsc_rls_obj_ld_core_sct : STD_LOGIC;

  COMPONENT histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl
    PORT(
      core_wten : IN STD_LOGIC;
      data_in_rsc_rls_obj_iswt0 : IN STD_LOGIC;
      data_in_rsc_rls_obj_ld_core_sct : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN
  data_in_rsc_rls_obj : work.mgc_io_sync_pkg_v2.mgc_io_sync_v2
    GENERIC MAP(
      valid => 0
      )
    PORT MAP(
      ld => data_in_rsc_rls_obj_ld_core_sct,
      lz => data_in_rsc_rls_lz
    );
  histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl_inst : histogram_hls_core_data_in_rsc_rls_obj_data_in_rsc_rls_wait_ctrl
    PORT MAP(
      core_wten => core_wten,
      data_in_rsc_rls_obj_iswt0 => data_in_rsc_rls_obj_iswt0,
      data_in_rsc_rls_obj_ld_core_sct => data_in_rsc_rls_obj_ld_core_sct
    );
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist_out_rsc_rls_obj
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist_out_rsc_rls_obj IS
  PORT(
    hist_out_rsc_rls_lz : OUT STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist_out_rsc_rls_obj_iswt0 : IN STD_LOGIC
  );
END histogram_hls_core_hist_out_rsc_rls_obj;

ARCHITECTURE v1 OF histogram_hls_core_hist_out_rsc_rls_obj IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist_out_rsc_rls_obj_ld_core_sct : STD_LOGIC;

  COMPONENT histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl
    PORT(
      core_wten : IN STD_LOGIC;
      hist_out_rsc_rls_obj_iswt0 : IN STD_LOGIC;
      hist_out_rsc_rls_obj_ld_core_sct : OUT STD_LOGIC
    );
  END COMPONENT;
BEGIN
  hist_out_rsc_rls_obj : work.mgc_io_sync_pkg_v2.mgc_io_sync_v2
    GENERIC MAP(
      valid => 0
      )
    PORT MAP(
      ld => hist_out_rsc_rls_obj_ld_core_sct,
      lz => hist_out_rsc_rls_lz
    );
  histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl_inst : histogram_hls_core_hist_out_rsc_rls_obj_hist_out_rsc_rls_wait_ctrl
    PORT MAP(
      core_wten => core_wten,
      hist_out_rsc_rls_obj_iswt0 => hist_out_rsc_rls_obj_iswt0,
      hist_out_rsc_rls_obj_ld_core_sct => hist_out_rsc_rls_obj_ld_core_sct
    );
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist8_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist8_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist8_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_we_d : OUT STD_LOGIC;
    hist8_rsci_re_d : OUT STD_LOGIC;
    hist8_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist8_rsci_oswt : IN STD_LOGIC;
    hist8_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_oswt_pff : IN STD_LOGIC;
    hist8_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist8_rsci_1;

ARCHITECTURE v1 OF histogram_hls_core_hist8_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist8_rsci_biwt : STD_LOGIC;
  SIGNAL hist8_rsci_bdwt : STD_LOGIC;
  SIGNAL hist8_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist8_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist8_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist8_rsci_oswt : IN STD_LOGIC;
      hist8_rsci_biwt : OUT STD_LOGIC;
      hist8_rsci_bdwt : OUT STD_LOGIC;
      hist8_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      hist8_rsci_oswt_pff : IN STD_LOGIC;
      hist8_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      hist8_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist8_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_biwt : IN STD_LOGIC;
      hist8_rsci_bdwt : IN STD_LOGIC;
      hist8_rsci_radr_d_core_sct : IN STD_LOGIC;
      hist8_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_radr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_wadr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_d_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_q_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_radr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_d_d_core
      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_ctrl_inst : histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      hist8_rsci_oswt => hist8_rsci_oswt,
      hist8_rsci_biwt => hist8_rsci_biwt,
      hist8_rsci_bdwt => hist8_rsci_bdwt,
      hist8_rsci_radr_d_core_sct_pff => hist8_rsci_radr_d_core_sct_iff,
      hist8_rsci_oswt_pff => hist8_rsci_oswt_pff,
      hist8_rsci_wadr_d_core_sct_pff => hist8_rsci_wadr_d_core_sct_iff,
      hist8_rsci_iswt0_1_pff => hist8_rsci_iswt0_1_pff
    );
  histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst : histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist8_rsci_radr_d => histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_radr_d,
      hist8_rsci_wadr_d => histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_wadr_d,
      hist8_rsci_d_d => histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_d_d,
      hist8_rsci_q_d => histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_q_d,
      hist8_rsci_radr_d_core => histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_radr_d_core,
      hist8_rsci_wadr_d_core => histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_wadr_d_core,
      hist8_rsci_d_d_core => histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_d_d_core,
      hist8_rsci_q_d_mxwt => histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_q_d_mxwt,
      hist8_rsci_biwt => hist8_rsci_biwt,
      hist8_rsci_bdwt => hist8_rsci_bdwt,
      hist8_rsci_radr_d_core_sct => hist8_rsci_radr_d_core_sct_iff,
      hist8_rsci_wadr_d_core_sct_pff => hist8_rsci_wadr_d_core_sct_iff
    );
  hist8_rsci_radr_d_reg <= histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_radr_d;
  hist8_rsci_wadr_d_reg <= histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_wadr_d;
  hist8_rsci_d_d_reg <= histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_d_d;
  histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_q_d <= hist8_rsci_q_d;
  histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_radr_d_core <=
      hist8_rsci_radr_d_core;
  histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_wadr_d_core <=
      hist8_rsci_wadr_d_core;
  histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_d_d_core <= hist8_rsci_d_d_core;
  hist8_rsci_q_d_mxwt <= histogram_hls_core_hist8_rsci_1_hist8_rsc_wait_dp_inst_hist8_rsci_q_d_mxwt;

  hist8_rsci_radr_d <= hist8_rsci_radr_d_reg;
  hist8_rsci_wadr_d <= hist8_rsci_wadr_d_reg;
  hist8_rsci_d_d <= hist8_rsci_d_d_reg;
  hist8_rsci_we_d <= hist8_rsci_wadr_d_core_sct_iff;
  hist8_rsci_re_d <= hist8_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist7_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist7_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist7_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_we_d : OUT STD_LOGIC;
    hist7_rsci_re_d : OUT STD_LOGIC;
    hist7_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist7_rsci_oswt : IN STD_LOGIC;
    hist7_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_oswt_pff : IN STD_LOGIC;
    hist7_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist7_rsci_1;

ARCHITECTURE v1 OF histogram_hls_core_hist7_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist7_rsci_biwt : STD_LOGIC;
  SIGNAL hist7_rsci_bdwt : STD_LOGIC;
  SIGNAL hist7_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist7_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist7_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist7_rsci_oswt : IN STD_LOGIC;
      hist7_rsci_biwt : OUT STD_LOGIC;
      hist7_rsci_bdwt : OUT STD_LOGIC;
      hist7_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      hist7_rsci_oswt_pff : IN STD_LOGIC;
      hist7_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      hist7_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist7_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_biwt : IN STD_LOGIC;
      hist7_rsci_bdwt : IN STD_LOGIC;
      hist7_rsci_radr_d_core_sct : IN STD_LOGIC;
      hist7_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_radr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_wadr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_d_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_q_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_radr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_d_d_core
      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_ctrl_inst : histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      hist7_rsci_oswt => hist7_rsci_oswt,
      hist7_rsci_biwt => hist7_rsci_biwt,
      hist7_rsci_bdwt => hist7_rsci_bdwt,
      hist7_rsci_radr_d_core_sct_pff => hist7_rsci_radr_d_core_sct_iff,
      hist7_rsci_oswt_pff => hist7_rsci_oswt_pff,
      hist7_rsci_wadr_d_core_sct_pff => hist7_rsci_wadr_d_core_sct_iff,
      hist7_rsci_iswt0_1_pff => hist7_rsci_iswt0_1_pff
    );
  histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst : histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist7_rsci_radr_d => histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_radr_d,
      hist7_rsci_wadr_d => histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_wadr_d,
      hist7_rsci_d_d => histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_d_d,
      hist7_rsci_q_d => histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_q_d,
      hist7_rsci_radr_d_core => histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_radr_d_core,
      hist7_rsci_wadr_d_core => histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_wadr_d_core,
      hist7_rsci_d_d_core => histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_d_d_core,
      hist7_rsci_q_d_mxwt => histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_q_d_mxwt,
      hist7_rsci_biwt => hist7_rsci_biwt,
      hist7_rsci_bdwt => hist7_rsci_bdwt,
      hist7_rsci_radr_d_core_sct => hist7_rsci_radr_d_core_sct_iff,
      hist7_rsci_wadr_d_core_sct_pff => hist7_rsci_wadr_d_core_sct_iff
    );
  hist7_rsci_radr_d_reg <= histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_radr_d;
  hist7_rsci_wadr_d_reg <= histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_wadr_d;
  hist7_rsci_d_d_reg <= histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_d_d;
  histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_q_d <= hist7_rsci_q_d;
  histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_radr_d_core <=
      hist7_rsci_radr_d_core;
  histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_wadr_d_core <=
      hist7_rsci_wadr_d_core;
  histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_d_d_core <= hist7_rsci_d_d_core;
  hist7_rsci_q_d_mxwt <= histogram_hls_core_hist7_rsci_1_hist7_rsc_wait_dp_inst_hist7_rsci_q_d_mxwt;

  hist7_rsci_radr_d <= hist7_rsci_radr_d_reg;
  hist7_rsci_wadr_d <= hist7_rsci_wadr_d_reg;
  hist7_rsci_d_d <= hist7_rsci_d_d_reg;
  hist7_rsci_we_d <= hist7_rsci_wadr_d_core_sct_iff;
  hist7_rsci_re_d <= hist7_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist6_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist6_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist6_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_we_d : OUT STD_LOGIC;
    hist6_rsci_re_d : OUT STD_LOGIC;
    hist6_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist6_rsci_oswt : IN STD_LOGIC;
    hist6_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_oswt_pff : IN STD_LOGIC;
    hist6_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist6_rsci_1;

ARCHITECTURE v1 OF histogram_hls_core_hist6_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist6_rsci_biwt : STD_LOGIC;
  SIGNAL hist6_rsci_bdwt : STD_LOGIC;
  SIGNAL hist6_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist6_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist6_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist6_rsci_oswt : IN STD_LOGIC;
      hist6_rsci_biwt : OUT STD_LOGIC;
      hist6_rsci_bdwt : OUT STD_LOGIC;
      hist6_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      hist6_rsci_oswt_pff : IN STD_LOGIC;
      hist6_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      hist6_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist6_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_biwt : IN STD_LOGIC;
      hist6_rsci_bdwt : IN STD_LOGIC;
      hist6_rsci_radr_d_core_sct : IN STD_LOGIC;
      hist6_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_radr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_wadr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_d_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_q_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_radr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_d_d_core
      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_ctrl_inst : histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      hist6_rsci_oswt => hist6_rsci_oswt,
      hist6_rsci_biwt => hist6_rsci_biwt,
      hist6_rsci_bdwt => hist6_rsci_bdwt,
      hist6_rsci_radr_d_core_sct_pff => hist6_rsci_radr_d_core_sct_iff,
      hist6_rsci_oswt_pff => hist6_rsci_oswt_pff,
      hist6_rsci_wadr_d_core_sct_pff => hist6_rsci_wadr_d_core_sct_iff,
      hist6_rsci_iswt0_1_pff => hist6_rsci_iswt0_1_pff
    );
  histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst : histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist6_rsci_radr_d => histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_radr_d,
      hist6_rsci_wadr_d => histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_wadr_d,
      hist6_rsci_d_d => histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_d_d,
      hist6_rsci_q_d => histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_q_d,
      hist6_rsci_radr_d_core => histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_radr_d_core,
      hist6_rsci_wadr_d_core => histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_wadr_d_core,
      hist6_rsci_d_d_core => histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_d_d_core,
      hist6_rsci_q_d_mxwt => histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_q_d_mxwt,
      hist6_rsci_biwt => hist6_rsci_biwt,
      hist6_rsci_bdwt => hist6_rsci_bdwt,
      hist6_rsci_radr_d_core_sct => hist6_rsci_radr_d_core_sct_iff,
      hist6_rsci_wadr_d_core_sct_pff => hist6_rsci_wadr_d_core_sct_iff
    );
  hist6_rsci_radr_d_reg <= histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_radr_d;
  hist6_rsci_wadr_d_reg <= histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_wadr_d;
  hist6_rsci_d_d_reg <= histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_d_d;
  histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_q_d <= hist6_rsci_q_d;
  histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_radr_d_core <=
      hist6_rsci_radr_d_core;
  histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_wadr_d_core <=
      hist6_rsci_wadr_d_core;
  histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_d_d_core <= hist6_rsci_d_d_core;
  hist6_rsci_q_d_mxwt <= histogram_hls_core_hist6_rsci_1_hist6_rsc_wait_dp_inst_hist6_rsci_q_d_mxwt;

  hist6_rsci_radr_d <= hist6_rsci_radr_d_reg;
  hist6_rsci_wadr_d <= hist6_rsci_wadr_d_reg;
  hist6_rsci_d_d <= hist6_rsci_d_d_reg;
  hist6_rsci_we_d <= hist6_rsci_wadr_d_core_sct_iff;
  hist6_rsci_re_d <= hist6_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist5_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist5_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist5_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_we_d : OUT STD_LOGIC;
    hist5_rsci_re_d : OUT STD_LOGIC;
    hist5_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist5_rsci_oswt : IN STD_LOGIC;
    hist5_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_oswt_pff : IN STD_LOGIC;
    hist5_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist5_rsci_1;

ARCHITECTURE v1 OF histogram_hls_core_hist5_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist5_rsci_biwt : STD_LOGIC;
  SIGNAL hist5_rsci_bdwt : STD_LOGIC;
  SIGNAL hist5_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist5_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist5_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist5_rsci_oswt : IN STD_LOGIC;
      hist5_rsci_biwt : OUT STD_LOGIC;
      hist5_rsci_bdwt : OUT STD_LOGIC;
      hist5_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      hist5_rsci_oswt_pff : IN STD_LOGIC;
      hist5_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      hist5_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist5_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_biwt : IN STD_LOGIC;
      hist5_rsci_bdwt : IN STD_LOGIC;
      hist5_rsci_radr_d_core_sct : IN STD_LOGIC;
      hist5_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_radr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_wadr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_d_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_q_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_radr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_d_d_core
      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_ctrl_inst : histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      hist5_rsci_oswt => hist5_rsci_oswt,
      hist5_rsci_biwt => hist5_rsci_biwt,
      hist5_rsci_bdwt => hist5_rsci_bdwt,
      hist5_rsci_radr_d_core_sct_pff => hist5_rsci_radr_d_core_sct_iff,
      hist5_rsci_oswt_pff => hist5_rsci_oswt_pff,
      hist5_rsci_wadr_d_core_sct_pff => hist5_rsci_wadr_d_core_sct_iff,
      hist5_rsci_iswt0_1_pff => hist5_rsci_iswt0_1_pff
    );
  histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst : histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist5_rsci_radr_d => histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_radr_d,
      hist5_rsci_wadr_d => histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_wadr_d,
      hist5_rsci_d_d => histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_d_d,
      hist5_rsci_q_d => histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_q_d,
      hist5_rsci_radr_d_core => histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_radr_d_core,
      hist5_rsci_wadr_d_core => histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_wadr_d_core,
      hist5_rsci_d_d_core => histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_d_d_core,
      hist5_rsci_q_d_mxwt => histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_q_d_mxwt,
      hist5_rsci_biwt => hist5_rsci_biwt,
      hist5_rsci_bdwt => hist5_rsci_bdwt,
      hist5_rsci_radr_d_core_sct => hist5_rsci_radr_d_core_sct_iff,
      hist5_rsci_wadr_d_core_sct_pff => hist5_rsci_wadr_d_core_sct_iff
    );
  hist5_rsci_radr_d_reg <= histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_radr_d;
  hist5_rsci_wadr_d_reg <= histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_wadr_d;
  hist5_rsci_d_d_reg <= histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_d_d;
  histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_q_d <= hist5_rsci_q_d;
  histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_radr_d_core <=
      hist5_rsci_radr_d_core;
  histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_wadr_d_core <=
      hist5_rsci_wadr_d_core;
  histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_d_d_core <= hist5_rsci_d_d_core;
  hist5_rsci_q_d_mxwt <= histogram_hls_core_hist5_rsci_1_hist5_rsc_wait_dp_inst_hist5_rsci_q_d_mxwt;

  hist5_rsci_radr_d <= hist5_rsci_radr_d_reg;
  hist5_rsci_wadr_d <= hist5_rsci_wadr_d_reg;
  hist5_rsci_d_d <= hist5_rsci_d_d_reg;
  hist5_rsci_we_d <= hist5_rsci_wadr_d_core_sct_iff;
  hist5_rsci_re_d <= hist5_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist4_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist4_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist4_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_we_d : OUT STD_LOGIC;
    hist4_rsci_re_d : OUT STD_LOGIC;
    hist4_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist4_rsci_oswt : IN STD_LOGIC;
    hist4_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_oswt_pff : IN STD_LOGIC;
    hist4_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist4_rsci_1;

ARCHITECTURE v1 OF histogram_hls_core_hist4_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist4_rsci_biwt : STD_LOGIC;
  SIGNAL hist4_rsci_bdwt : STD_LOGIC;
  SIGNAL hist4_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist4_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist4_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist4_rsci_oswt : IN STD_LOGIC;
      hist4_rsci_biwt : OUT STD_LOGIC;
      hist4_rsci_bdwt : OUT STD_LOGIC;
      hist4_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      hist4_rsci_oswt_pff : IN STD_LOGIC;
      hist4_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      hist4_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist4_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_biwt : IN STD_LOGIC;
      hist4_rsci_bdwt : IN STD_LOGIC;
      hist4_rsci_radr_d_core_sct : IN STD_LOGIC;
      hist4_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_radr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_wadr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_d_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_q_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_radr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_d_d_core
      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_ctrl_inst : histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      hist4_rsci_oswt => hist4_rsci_oswt,
      hist4_rsci_biwt => hist4_rsci_biwt,
      hist4_rsci_bdwt => hist4_rsci_bdwt,
      hist4_rsci_radr_d_core_sct_pff => hist4_rsci_radr_d_core_sct_iff,
      hist4_rsci_oswt_pff => hist4_rsci_oswt_pff,
      hist4_rsci_wadr_d_core_sct_pff => hist4_rsci_wadr_d_core_sct_iff,
      hist4_rsci_iswt0_1_pff => hist4_rsci_iswt0_1_pff
    );
  histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst : histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist4_rsci_radr_d => histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_radr_d,
      hist4_rsci_wadr_d => histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_wadr_d,
      hist4_rsci_d_d => histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_d_d,
      hist4_rsci_q_d => histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_q_d,
      hist4_rsci_radr_d_core => histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_radr_d_core,
      hist4_rsci_wadr_d_core => histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_wadr_d_core,
      hist4_rsci_d_d_core => histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_d_d_core,
      hist4_rsci_q_d_mxwt => histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_q_d_mxwt,
      hist4_rsci_biwt => hist4_rsci_biwt,
      hist4_rsci_bdwt => hist4_rsci_bdwt,
      hist4_rsci_radr_d_core_sct => hist4_rsci_radr_d_core_sct_iff,
      hist4_rsci_wadr_d_core_sct_pff => hist4_rsci_wadr_d_core_sct_iff
    );
  hist4_rsci_radr_d_reg <= histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_radr_d;
  hist4_rsci_wadr_d_reg <= histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_wadr_d;
  hist4_rsci_d_d_reg <= histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_d_d;
  histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_q_d <= hist4_rsci_q_d;
  histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_radr_d_core <=
      hist4_rsci_radr_d_core;
  histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_wadr_d_core <=
      hist4_rsci_wadr_d_core;
  histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_d_d_core <= hist4_rsci_d_d_core;
  hist4_rsci_q_d_mxwt <= histogram_hls_core_hist4_rsci_1_hist4_rsc_wait_dp_inst_hist4_rsci_q_d_mxwt;

  hist4_rsci_radr_d <= hist4_rsci_radr_d_reg;
  hist4_rsci_wadr_d <= hist4_rsci_wadr_d_reg;
  hist4_rsci_d_d <= hist4_rsci_d_d_reg;
  hist4_rsci_we_d <= hist4_rsci_wadr_d_core_sct_iff;
  hist4_rsci_re_d <= hist4_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist3_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist3_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist3_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_we_d : OUT STD_LOGIC;
    hist3_rsci_re_d : OUT STD_LOGIC;
    hist3_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist3_rsci_oswt : IN STD_LOGIC;
    hist3_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_oswt_pff : IN STD_LOGIC;
    hist3_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist3_rsci_1;

ARCHITECTURE v1 OF histogram_hls_core_hist3_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist3_rsci_biwt : STD_LOGIC;
  SIGNAL hist3_rsci_bdwt : STD_LOGIC;
  SIGNAL hist3_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist3_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist3_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist3_rsci_oswt : IN STD_LOGIC;
      hist3_rsci_biwt : OUT STD_LOGIC;
      hist3_rsci_bdwt : OUT STD_LOGIC;
      hist3_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      hist3_rsci_oswt_pff : IN STD_LOGIC;
      hist3_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      hist3_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist3_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_biwt : IN STD_LOGIC;
      hist3_rsci_bdwt : IN STD_LOGIC;
      hist3_rsci_radr_d_core_sct : IN STD_LOGIC;
      hist3_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_radr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_wadr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_d_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_q_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_radr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_d_d_core
      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_ctrl_inst : histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      hist3_rsci_oswt => hist3_rsci_oswt,
      hist3_rsci_biwt => hist3_rsci_biwt,
      hist3_rsci_bdwt => hist3_rsci_bdwt,
      hist3_rsci_radr_d_core_sct_pff => hist3_rsci_radr_d_core_sct_iff,
      hist3_rsci_oswt_pff => hist3_rsci_oswt_pff,
      hist3_rsci_wadr_d_core_sct_pff => hist3_rsci_wadr_d_core_sct_iff,
      hist3_rsci_iswt0_1_pff => hist3_rsci_iswt0_1_pff
    );
  histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst : histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist3_rsci_radr_d => histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_radr_d,
      hist3_rsci_wadr_d => histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_wadr_d,
      hist3_rsci_d_d => histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_d_d,
      hist3_rsci_q_d => histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_q_d,
      hist3_rsci_radr_d_core => histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_radr_d_core,
      hist3_rsci_wadr_d_core => histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_wadr_d_core,
      hist3_rsci_d_d_core => histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_d_d_core,
      hist3_rsci_q_d_mxwt => histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_q_d_mxwt,
      hist3_rsci_biwt => hist3_rsci_biwt,
      hist3_rsci_bdwt => hist3_rsci_bdwt,
      hist3_rsci_radr_d_core_sct => hist3_rsci_radr_d_core_sct_iff,
      hist3_rsci_wadr_d_core_sct_pff => hist3_rsci_wadr_d_core_sct_iff
    );
  hist3_rsci_radr_d_reg <= histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_radr_d;
  hist3_rsci_wadr_d_reg <= histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_wadr_d;
  hist3_rsci_d_d_reg <= histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_d_d;
  histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_q_d <= hist3_rsci_q_d;
  histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_radr_d_core <=
      hist3_rsci_radr_d_core;
  histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_wadr_d_core <=
      hist3_rsci_wadr_d_core;
  histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_d_d_core <= hist3_rsci_d_d_core;
  hist3_rsci_q_d_mxwt <= histogram_hls_core_hist3_rsci_1_hist3_rsc_wait_dp_inst_hist3_rsci_q_d_mxwt;

  hist3_rsci_radr_d <= hist3_rsci_radr_d_reg;
  hist3_rsci_wadr_d <= hist3_rsci_wadr_d_reg;
  hist3_rsci_d_d <= hist3_rsci_d_d_reg;
  hist3_rsci_we_d <= hist3_rsci_wadr_d_core_sct_iff;
  hist3_rsci_re_d <= hist3_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist2_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist2_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist2_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_we_d : OUT STD_LOGIC;
    hist2_rsci_re_d : OUT STD_LOGIC;
    hist2_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist2_rsci_oswt : IN STD_LOGIC;
    hist2_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_oswt_pff : IN STD_LOGIC;
    hist2_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist2_rsci_1;

ARCHITECTURE v1 OF histogram_hls_core_hist2_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist2_rsci_biwt : STD_LOGIC;
  SIGNAL hist2_rsci_bdwt : STD_LOGIC;
  SIGNAL hist2_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist2_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist2_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist2_rsci_oswt : IN STD_LOGIC;
      hist2_rsci_biwt : OUT STD_LOGIC;
      hist2_rsci_bdwt : OUT STD_LOGIC;
      hist2_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      hist2_rsci_oswt_pff : IN STD_LOGIC;
      hist2_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      hist2_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist2_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_biwt : IN STD_LOGIC;
      hist2_rsci_bdwt : IN STD_LOGIC;
      hist2_rsci_radr_d_core_sct : IN STD_LOGIC;
      hist2_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_radr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_wadr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_d_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_q_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_radr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_d_d_core
      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_ctrl_inst : histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      hist2_rsci_oswt => hist2_rsci_oswt,
      hist2_rsci_biwt => hist2_rsci_biwt,
      hist2_rsci_bdwt => hist2_rsci_bdwt,
      hist2_rsci_radr_d_core_sct_pff => hist2_rsci_radr_d_core_sct_iff,
      hist2_rsci_oswt_pff => hist2_rsci_oswt_pff,
      hist2_rsci_wadr_d_core_sct_pff => hist2_rsci_wadr_d_core_sct_iff,
      hist2_rsci_iswt0_1_pff => hist2_rsci_iswt0_1_pff
    );
  histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst : histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist2_rsci_radr_d => histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_radr_d,
      hist2_rsci_wadr_d => histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_wadr_d,
      hist2_rsci_d_d => histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_d_d,
      hist2_rsci_q_d => histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_q_d,
      hist2_rsci_radr_d_core => histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_radr_d_core,
      hist2_rsci_wadr_d_core => histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_wadr_d_core,
      hist2_rsci_d_d_core => histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_d_d_core,
      hist2_rsci_q_d_mxwt => histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_q_d_mxwt,
      hist2_rsci_biwt => hist2_rsci_biwt,
      hist2_rsci_bdwt => hist2_rsci_bdwt,
      hist2_rsci_radr_d_core_sct => hist2_rsci_radr_d_core_sct_iff,
      hist2_rsci_wadr_d_core_sct_pff => hist2_rsci_wadr_d_core_sct_iff
    );
  hist2_rsci_radr_d_reg <= histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_radr_d;
  hist2_rsci_wadr_d_reg <= histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_wadr_d;
  hist2_rsci_d_d_reg <= histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_d_d;
  histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_q_d <= hist2_rsci_q_d;
  histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_radr_d_core <=
      hist2_rsci_radr_d_core;
  histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_wadr_d_core <=
      hist2_rsci_wadr_d_core;
  histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_d_d_core <= hist2_rsci_d_d_core;
  hist2_rsci_q_d_mxwt <= histogram_hls_core_hist2_rsci_1_hist2_rsc_wait_dp_inst_hist2_rsci_q_d_mxwt;

  hist2_rsci_radr_d <= hist2_rsci_radr_d_reg;
  hist2_rsci_wadr_d <= hist2_rsci_wadr_d_reg;
  hist2_rsci_d_d <= hist2_rsci_d_d_reg;
  hist2_rsci_we_d <= hist2_rsci_wadr_d_core_sct_iff;
  hist2_rsci_re_d <= hist2_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist1_rsci_1
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist1_rsci_1 IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist1_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist1_rsci_we_d : OUT STD_LOGIC;
    hist1_rsci_re_d : OUT STD_LOGIC;
    hist1_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    core_wen : IN STD_LOGIC;
    core_wten : IN STD_LOGIC;
    hist1_rsci_oswt : IN STD_LOGIC;
    hist1_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist1_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist1_rsci_oswt_pff : IN STD_LOGIC;
    hist1_rsci_iswt0_1_pff : IN STD_LOGIC
  );
END histogram_hls_core_hist1_rsci_1;

ARCHITECTURE v1 OF histogram_hls_core_hist1_rsci_1 IS
  -- Default Constants

  -- Interconnect Declarations
  SIGNAL hist1_rsci_biwt : STD_LOGIC;
  SIGNAL hist1_rsci_bdwt : STD_LOGIC;
  SIGNAL hist1_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_radr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist1_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_wadr_d_core_sct_iff : STD_LOGIC;
  SIGNAL hist1_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist1_rsci_oswt : IN STD_LOGIC;
      hist1_rsci_biwt : OUT STD_LOGIC;
      hist1_rsci_bdwt : OUT STD_LOGIC;
      hist1_rsci_radr_d_core_sct_pff : OUT STD_LOGIC;
      hist1_rsci_oswt_pff : IN STD_LOGIC;
      hist1_rsci_wadr_d_core_sct_pff : OUT STD_LOGIC;
      hist1_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist1_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist1_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist1_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist1_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist1_rsci_biwt : IN STD_LOGIC;
      hist1_rsci_bdwt : IN STD_LOGIC;
      hist1_rsci_radr_d_core_sct : IN STD_LOGIC;
      hist1_rsci_wadr_d_core_sct_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_radr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_wadr_d
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_d_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_q_d :
      STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_radr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_wadr_d_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_d_d_core
      : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_q_d_mxwt
      : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_ctrl_inst : histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      core_wten => core_wten,
      hist1_rsci_oswt => hist1_rsci_oswt,
      hist1_rsci_biwt => hist1_rsci_biwt,
      hist1_rsci_bdwt => hist1_rsci_bdwt,
      hist1_rsci_radr_d_core_sct_pff => hist1_rsci_radr_d_core_sct_iff,
      hist1_rsci_oswt_pff => hist1_rsci_oswt_pff,
      hist1_rsci_wadr_d_core_sct_pff => hist1_rsci_wadr_d_core_sct_iff,
      hist1_rsci_iswt0_1_pff => hist1_rsci_iswt0_1_pff
    );
  histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst : histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist1_rsci_radr_d => histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_radr_d,
      hist1_rsci_wadr_d => histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_wadr_d,
      hist1_rsci_d_d => histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_d_d,
      hist1_rsci_q_d => histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_q_d,
      hist1_rsci_radr_d_core => histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_radr_d_core,
      hist1_rsci_wadr_d_core => histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_wadr_d_core,
      hist1_rsci_d_d_core => histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_d_d_core,
      hist1_rsci_q_d_mxwt => histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_q_d_mxwt,
      hist1_rsci_biwt => hist1_rsci_biwt,
      hist1_rsci_bdwt => hist1_rsci_bdwt,
      hist1_rsci_radr_d_core_sct => hist1_rsci_radr_d_core_sct_iff,
      hist1_rsci_wadr_d_core_sct_pff => hist1_rsci_wadr_d_core_sct_iff
    );
  hist1_rsci_radr_d_reg <= histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_radr_d;
  hist1_rsci_wadr_d_reg <= histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_wadr_d;
  hist1_rsci_d_d_reg <= histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_d_d;
  histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_q_d <= hist1_rsci_q_d;
  histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_radr_d_core <=
      hist1_rsci_radr_d_core;
  histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_wadr_d_core <=
      hist1_rsci_wadr_d_core;
  histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_d_d_core <= hist1_rsci_d_d_core;
  hist1_rsci_q_d_mxwt <= histogram_hls_core_hist1_rsci_1_hist1_rsc_wait_dp_inst_hist1_rsci_q_d_mxwt;

  hist1_rsci_radr_d <= hist1_rsci_radr_d_reg;
  hist1_rsci_wadr_d <= hist1_rsci_wadr_d_reg;
  hist1_rsci_d_d <= hist1_rsci_d_d_reg;
  hist1_rsci_we_d <= hist1_rsci_wadr_d_core_sct_iff;
  hist1_rsci_re_d <= hist1_rsci_radr_d_core_sct_iff;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_hist_out_rsci
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_hist_out_rsci IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    hist_out_rsc_s_tdone : IN STD_LOGIC;
    hist_out_rsc_tr_write_done : IN STD_LOGIC;
    hist_out_rsc_RREADY : IN STD_LOGIC;
    hist_out_rsc_RVALID : OUT STD_LOGIC;
    hist_out_rsc_RUSER : OUT STD_LOGIC;
    hist_out_rsc_RLAST : OUT STD_LOGIC;
    hist_out_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_RDATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_RID : OUT STD_LOGIC;
    hist_out_rsc_ARREADY : OUT STD_LOGIC;
    hist_out_rsc_ARVALID : IN STD_LOGIC;
    hist_out_rsc_ARUSER : IN STD_LOGIC;
    hist_out_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARLOCK : IN STD_LOGIC;
    hist_out_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_ARADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    hist_out_rsc_ARID : IN STD_LOGIC;
    hist_out_rsc_BREADY : IN STD_LOGIC;
    hist_out_rsc_BVALID : OUT STD_LOGIC;
    hist_out_rsc_BUSER : OUT STD_LOGIC;
    hist_out_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_BID : OUT STD_LOGIC;
    hist_out_rsc_WREADY : OUT STD_LOGIC;
    hist_out_rsc_WVALID : IN STD_LOGIC;
    hist_out_rsc_WUSER : IN STD_LOGIC;
    hist_out_rsc_WLAST : IN STD_LOGIC;
    hist_out_rsc_WSTRB : IN STD_LOGIC;
    hist_out_rsc_WDATA : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_AWREADY : OUT STD_LOGIC;
    hist_out_rsc_AWVALID : IN STD_LOGIC;
    hist_out_rsc_AWUSER : IN STD_LOGIC;
    hist_out_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWLOCK : IN STD_LOGIC;
    hist_out_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_AWADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    hist_out_rsc_AWID : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    hist_out_rsci_oswt : IN STD_LOGIC;
    hist_out_rsci_wen_comp : OUT STD_LOGIC;
    hist_out_rsci_oswt_1 : IN STD_LOGIC;
    hist_out_rsci_wen_comp_1 : OUT STD_LOGIC;
    hist_out_rsci_s_raddr_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsci_s_din_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsci_s_dout_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END histogram_hls_core_hist_out_rsci;

ARCHITECTURE v1 OF histogram_hls_core_hist_out_rsci IS
  -- Default Constants
  CONSTANT PWR : STD_LOGIC := '1';

  -- Interconnect Declarations
  SIGNAL hist_out_rsci_biwt : STD_LOGIC;
  SIGNAL hist_out_rsci_bdwt : STD_LOGIC;
  SIGNAL hist_out_rsci_bcwt : STD_LOGIC;
  SIGNAL hist_out_rsci_s_re_core_sct : STD_LOGIC;
  SIGNAL hist_out_rsci_biwt_1 : STD_LOGIC;
  SIGNAL hist_out_rsci_bdwt_2 : STD_LOGIC;
  SIGNAL hist_out_rsci_bcwt_1 : STD_LOGIC;
  SIGNAL hist_out_rsci_s_we_core_sct : STD_LOGIC;
  SIGNAL hist_out_rsci_s_raddr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_s_waddr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_s_din : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_s_dout : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_s_rrdy : STD_LOGIC;
  SIGNAL hist_out_rsci_s_wrdy : STD_LOGIC;
  SIGNAL hist_out_rsc_is_idle_1 : STD_LOGIC;

  SIGNAL hist_out_rsci_AWID : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_AWADDR : STD_LOGIC_VECTOR (11 DOWNTO 0);
  SIGNAL hist_out_rsci_AWLEN : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_AWSIZE : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL hist_out_rsci_AWBURST : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL hist_out_rsci_AWCACHE : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL hist_out_rsci_AWPROT : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL hist_out_rsci_AWQOS : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL hist_out_rsci_AWREGION : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL hist_out_rsci_AWUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_WDATA : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_WSTRB : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_WUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_BID : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_BRESP : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL hist_out_rsci_BUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_ARID : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_ARADDR : STD_LOGIC_VECTOR (11 DOWNTO 0);
  SIGNAL hist_out_rsci_ARLEN : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_ARSIZE : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL hist_out_rsci_ARBURST : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL hist_out_rsci_ARCACHE : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL hist_out_rsci_ARPROT : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL hist_out_rsci_ARQOS : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL hist_out_rsci_ARREGION : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL hist_out_rsci_ARUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_RID : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_RDATA : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_RRESP : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL hist_out_rsci_RUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL hist_out_rsci_s_raddr_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_s_waddr_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_s_din_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_s_dout_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);

  COMPONENT histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      hist_out_rsci_oswt : IN STD_LOGIC;
      hist_out_rsci_oswt_1 : IN STD_LOGIC;
      hist_out_rsci_biwt : OUT STD_LOGIC;
      hist_out_rsci_bdwt : OUT STD_LOGIC;
      hist_out_rsci_bcwt : IN STD_LOGIC;
      hist_out_rsci_s_re_core_sct : OUT STD_LOGIC;
      hist_out_rsci_biwt_1 : OUT STD_LOGIC;
      hist_out_rsci_bdwt_2 : OUT STD_LOGIC;
      hist_out_rsci_bcwt_1 : IN STD_LOGIC;
      hist_out_rsci_s_we_core_sct : OUT STD_LOGIC;
      hist_out_rsci_s_rrdy : IN STD_LOGIC;
      hist_out_rsci_s_wrdy : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist_out_rsci_oswt : IN STD_LOGIC;
      hist_out_rsci_wen_comp : OUT STD_LOGIC;
      hist_out_rsci_oswt_1 : IN STD_LOGIC;
      hist_out_rsci_wen_comp_1 : OUT STD_LOGIC;
      hist_out_rsci_s_raddr_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsci_s_din_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsci_s_dout_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsci_biwt : IN STD_LOGIC;
      hist_out_rsci_bdwt : IN STD_LOGIC;
      hist_out_rsci_bcwt : OUT STD_LOGIC;
      hist_out_rsci_biwt_1 : IN STD_LOGIC;
      hist_out_rsci_bdwt_2 : IN STD_LOGIC;
      hist_out_rsci_bcwt_1 : OUT STD_LOGIC;
      hist_out_rsci_s_raddr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsci_s_raddr_core_sct : IN STD_LOGIC;
      hist_out_rsci_s_waddr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsci_s_waddr_core_sct : IN STD_LOGIC;
      hist_out_rsci_s_din : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsci_s_dout : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_raddr_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_din_mxwt
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_dout_core
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_raddr
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_waddr
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_din
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_dout
      : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN
  hist_out_rsci : work.amba_comps.ccs_axi4_slave_mem
    GENERIC MAP(
      rscid => 0,
      depth => 256,
      op_width => 8,
      cwidth => 8,
      addr_w => 8,
      nopreload => 0,
      rst_ph => 0,
      ADDR_WIDTH => 12,
      DATA_WIDTH => 8,
      ID_WIDTH => 1,
      USER_WIDTH => 1,
      REGION_MAP_SIZE => 1,
      wBASE_ADDRESS => 0,
      rBASE_ADDRESS => 0
      )
    PORT MAP(
      ACLK => clk,
      ARESETn => '1',
      AWID => hist_out_rsci_AWID,
      AWADDR => hist_out_rsci_AWADDR,
      AWLEN => hist_out_rsci_AWLEN,
      AWSIZE => hist_out_rsci_AWSIZE,
      AWBURST => hist_out_rsci_AWBURST,
      AWLOCK => hist_out_rsc_AWLOCK,
      AWCACHE => hist_out_rsci_AWCACHE,
      AWPROT => hist_out_rsci_AWPROT,
      AWQOS => hist_out_rsci_AWQOS,
      AWREGION => hist_out_rsci_AWREGION,
      AWUSER => hist_out_rsci_AWUSER,
      AWVALID => hist_out_rsc_AWVALID,
      AWREADY => hist_out_rsc_AWREADY,
      WDATA => hist_out_rsci_WDATA,
      WSTRB => hist_out_rsci_WSTRB,
      WLAST => hist_out_rsc_WLAST,
      WUSER => hist_out_rsci_WUSER,
      WVALID => hist_out_rsc_WVALID,
      WREADY => hist_out_rsc_WREADY,
      BID => hist_out_rsci_BID,
      BRESP => hist_out_rsci_BRESP,
      BUSER => hist_out_rsci_BUSER,
      BVALID => hist_out_rsc_BVALID,
      BREADY => hist_out_rsc_BREADY,
      ARID => hist_out_rsci_ARID,
      ARADDR => hist_out_rsci_ARADDR,
      ARLEN => hist_out_rsci_ARLEN,
      ARSIZE => hist_out_rsci_ARSIZE,
      ARBURST => hist_out_rsci_ARBURST,
      ARLOCK => hist_out_rsc_ARLOCK,
      ARCACHE => hist_out_rsci_ARCACHE,
      ARPROT => hist_out_rsci_ARPROT,
      ARQOS => hist_out_rsci_ARQOS,
      ARREGION => hist_out_rsci_ARREGION,
      ARUSER => hist_out_rsci_ARUSER,
      ARVALID => hist_out_rsc_ARVALID,
      ARREADY => hist_out_rsc_ARREADY,
      RID => hist_out_rsci_RID,
      RDATA => hist_out_rsci_RDATA,
      RRESP => hist_out_rsci_RRESP,
      RLAST => hist_out_rsc_RLAST,
      RUSER => hist_out_rsci_RUSER,
      RVALID => hist_out_rsc_RVALID,
      RREADY => hist_out_rsc_RREADY,
      s_re => hist_out_rsci_s_re_core_sct,
      s_we => hist_out_rsci_s_we_core_sct,
      s_raddr => hist_out_rsci_s_raddr_1,
      s_waddr => hist_out_rsci_s_waddr_1,
      s_din => hist_out_rsci_s_din_1,
      s_dout => hist_out_rsci_s_dout_1,
      s_rrdy => hist_out_rsci_s_rrdy,
      s_wrdy => hist_out_rsci_s_wrdy,
      is_idle => hist_out_rsc_is_idle_1,
      tr_write_done => hist_out_rsc_tr_write_done,
      s_tdone => hist_out_rsc_s_tdone
    );
  hist_out_rsci_AWID(0) <= hist_out_rsc_AWID;
  hist_out_rsci_AWADDR <= hist_out_rsc_AWADDR;
  hist_out_rsci_AWLEN <= hist_out_rsc_AWLEN;
  hist_out_rsci_AWSIZE <= hist_out_rsc_AWSIZE;
  hist_out_rsci_AWBURST <= hist_out_rsc_AWBURST;
  hist_out_rsci_AWCACHE <= hist_out_rsc_AWCACHE;
  hist_out_rsci_AWPROT <= hist_out_rsc_AWPROT;
  hist_out_rsci_AWQOS <= hist_out_rsc_AWQOS;
  hist_out_rsci_AWREGION <= hist_out_rsc_AWREGION;
  hist_out_rsci_AWUSER(0) <= hist_out_rsc_AWUSER;
  hist_out_rsci_WDATA <= hist_out_rsc_WDATA;
  hist_out_rsci_WSTRB(0) <= hist_out_rsc_WSTRB;
  hist_out_rsci_WUSER(0) <= hist_out_rsc_WUSER;
  hist_out_rsc_BID <= hist_out_rsci_BID(0);
  hist_out_rsc_BRESP <= hist_out_rsci_BRESP;
  hist_out_rsc_BUSER <= hist_out_rsci_BUSER(0);
  hist_out_rsci_ARID(0) <= hist_out_rsc_ARID;
  hist_out_rsci_ARADDR <= hist_out_rsc_ARADDR;
  hist_out_rsci_ARLEN <= hist_out_rsc_ARLEN;
  hist_out_rsci_ARSIZE <= hist_out_rsc_ARSIZE;
  hist_out_rsci_ARBURST <= hist_out_rsc_ARBURST;
  hist_out_rsci_ARCACHE <= hist_out_rsc_ARCACHE;
  hist_out_rsci_ARPROT <= hist_out_rsc_ARPROT;
  hist_out_rsci_ARQOS <= hist_out_rsc_ARQOS;
  hist_out_rsci_ARREGION <= hist_out_rsc_ARREGION;
  hist_out_rsci_ARUSER(0) <= hist_out_rsc_ARUSER;
  hist_out_rsc_RID <= hist_out_rsci_RID(0);
  hist_out_rsc_RDATA <= hist_out_rsci_RDATA;
  hist_out_rsc_RRESP <= hist_out_rsci_RRESP;
  hist_out_rsc_RUSER <= hist_out_rsci_RUSER(0);
  hist_out_rsci_s_raddr_1 <= hist_out_rsci_s_raddr;
  hist_out_rsci_s_waddr_1 <= hist_out_rsci_s_waddr;
  hist_out_rsci_s_din <= hist_out_rsci_s_din_1;
  hist_out_rsci_s_dout_1 <= hist_out_rsci_s_dout;

  histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl_inst : histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      hist_out_rsci_oswt => hist_out_rsci_oswt,
      hist_out_rsci_oswt_1 => hist_out_rsci_oswt_1,
      hist_out_rsci_biwt => hist_out_rsci_biwt,
      hist_out_rsci_bdwt => hist_out_rsci_bdwt,
      hist_out_rsci_bcwt => hist_out_rsci_bcwt,
      hist_out_rsci_s_re_core_sct => hist_out_rsci_s_re_core_sct,
      hist_out_rsci_biwt_1 => hist_out_rsci_biwt_1,
      hist_out_rsci_bdwt_2 => hist_out_rsci_bdwt_2,
      hist_out_rsci_bcwt_1 => hist_out_rsci_bcwt_1,
      hist_out_rsci_s_we_core_sct => hist_out_rsci_s_we_core_sct,
      hist_out_rsci_s_rrdy => hist_out_rsci_s_rrdy,
      hist_out_rsci_s_wrdy => hist_out_rsci_s_wrdy
    );
  histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst : histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      hist_out_rsci_oswt => hist_out_rsci_oswt,
      hist_out_rsci_wen_comp => hist_out_rsci_wen_comp,
      hist_out_rsci_oswt_1 => hist_out_rsci_oswt_1,
      hist_out_rsci_wen_comp_1 => hist_out_rsci_wen_comp_1,
      hist_out_rsci_s_raddr_core => histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_raddr_core,
      hist_out_rsci_s_din_mxwt => histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_din_mxwt,
      hist_out_rsci_s_dout_core => histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_dout_core,
      hist_out_rsci_biwt => hist_out_rsci_biwt,
      hist_out_rsci_bdwt => hist_out_rsci_bdwt,
      hist_out_rsci_bcwt => hist_out_rsci_bcwt,
      hist_out_rsci_biwt_1 => hist_out_rsci_biwt_1,
      hist_out_rsci_bdwt_2 => hist_out_rsci_bdwt_2,
      hist_out_rsci_bcwt_1 => hist_out_rsci_bcwt_1,
      hist_out_rsci_s_raddr => histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_raddr,
      hist_out_rsci_s_raddr_core_sct => hist_out_rsci_s_re_core_sct,
      hist_out_rsci_s_waddr => histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_waddr,
      hist_out_rsci_s_waddr_core_sct => hist_out_rsci_s_we_core_sct,
      hist_out_rsci_s_din => histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_din,
      hist_out_rsci_s_dout => histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_dout
    );
  histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_raddr_core
      <= hist_out_rsci_s_raddr_core;
  hist_out_rsci_s_din_mxwt <= histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_din_mxwt;
  histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_dout_core
      <= hist_out_rsci_s_dout_core;
  hist_out_rsci_s_raddr <= histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_raddr;
  hist_out_rsci_s_waddr <= histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_waddr;
  histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_din
      <= hist_out_rsci_s_din;
  hist_out_rsci_s_dout <= histogram_hls_core_hist_out_rsci_hist_out_rsc_wait_dp_inst_hist_out_rsci_s_dout;

END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core_data_in_rsci
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core_data_in_rsci IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_in_rsc_s_tdone : IN STD_LOGIC;
    data_in_rsc_tr_write_done : IN STD_LOGIC;
    data_in_rsc_RREADY : IN STD_LOGIC;
    data_in_rsc_RVALID : OUT STD_LOGIC;
    data_in_rsc_RUSER : OUT STD_LOGIC;
    data_in_rsc_RLAST : OUT STD_LOGIC;
    data_in_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_RDATA : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
    data_in_rsc_RID : OUT STD_LOGIC;
    data_in_rsc_ARREADY : OUT STD_LOGIC;
    data_in_rsc_ARVALID : IN STD_LOGIC;
    data_in_rsc_ARUSER : IN STD_LOGIC;
    data_in_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARLOCK : IN STD_LOGIC;
    data_in_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsc_ARADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsc_ARID : IN STD_LOGIC;
    data_in_rsc_BREADY : IN STD_LOGIC;
    data_in_rsc_BVALID : OUT STD_LOGIC;
    data_in_rsc_BUSER : OUT STD_LOGIC;
    data_in_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_BID : OUT STD_LOGIC;
    data_in_rsc_WREADY : OUT STD_LOGIC;
    data_in_rsc_WVALID : IN STD_LOGIC;
    data_in_rsc_WUSER : IN STD_LOGIC;
    data_in_rsc_WLAST : IN STD_LOGIC;
    data_in_rsc_WSTRB : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_WDATA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    data_in_rsc_AWREADY : OUT STD_LOGIC;
    data_in_rsc_AWVALID : IN STD_LOGIC;
    data_in_rsc_AWUSER : IN STD_LOGIC;
    data_in_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWLOCK : IN STD_LOGIC;
    data_in_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsc_AWADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsc_AWID : IN STD_LOGIC;
    core_wen : IN STD_LOGIC;
    data_in_rsci_oswt : IN STD_LOGIC;
    data_in_rsci_wen_comp : OUT STD_LOGIC;
    data_in_rsci_s_raddr_core : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsci_s_din_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END histogram_hls_core_data_in_rsci;

ARCHITECTURE v1 OF histogram_hls_core_data_in_rsci IS
  -- Default Constants
  CONSTANT PWR : STD_LOGIC := '1';
  CONSTANT GND : STD_LOGIC := '0';

  -- Interconnect Declarations
  SIGNAL data_in_rsci_biwt : STD_LOGIC;
  SIGNAL data_in_rsci_bdwt : STD_LOGIC;
  SIGNAL data_in_rsci_bcwt : STD_LOGIC;
  SIGNAL data_in_rsci_s_re_core_sct : STD_LOGIC;
  SIGNAL data_in_rsci_s_raddr : STD_LOGIC_VECTOR (12 DOWNTO 0);
  SIGNAL data_in_rsci_s_din : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL data_in_rsci_s_rrdy : STD_LOGIC;
  SIGNAL data_in_rsci_s_wrdy : STD_LOGIC;
  SIGNAL data_in_rsc_is_idle : STD_LOGIC;
  SIGNAL data_in_rsci_s_din_mxwt_pconst : STD_LOGIC_VECTOR (7 DOWNTO 0);

  SIGNAL data_in_rsci_AWID : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_AWADDR : STD_LOGIC_VECTOR (12 DOWNTO 0);
  SIGNAL data_in_rsci_AWLEN : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL data_in_rsci_AWSIZE : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL data_in_rsci_AWBURST : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL data_in_rsci_AWCACHE : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL data_in_rsci_AWPROT : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL data_in_rsci_AWQOS : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL data_in_rsci_AWREGION : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL data_in_rsci_AWUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_WDATA : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL data_in_rsci_WSTRB : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL data_in_rsci_WUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_BID : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_BRESP : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL data_in_rsci_BUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_ARID : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_ARADDR : STD_LOGIC_VECTOR (12 DOWNTO 0);
  SIGNAL data_in_rsci_ARLEN : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL data_in_rsci_ARSIZE : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL data_in_rsci_ARBURST : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL data_in_rsci_ARCACHE : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL data_in_rsci_ARPROT : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL data_in_rsci_ARQOS : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL data_in_rsci_ARREGION : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL data_in_rsci_ARUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_RID : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_RDATA : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL data_in_rsci_RRESP : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL data_in_rsci_RUSER : STD_LOGIC_VECTOR (0 DOWNTO 0);
  SIGNAL data_in_rsci_s_raddr_1 : STD_LOGIC_VECTOR (12 DOWNTO 0);
  SIGNAL data_in_rsci_s_waddr : STD_LOGIC_VECTOR (12 DOWNTO 0);
  SIGNAL data_in_rsci_s_din_1 : STD_LOGIC_VECTOR (15 DOWNTO 0);
  SIGNAL data_in_rsci_s_dout : STD_LOGIC_VECTOR (15 DOWNTO 0);

  COMPONENT histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl
    PORT(
      core_wen : IN STD_LOGIC;
      data_in_rsci_oswt : IN STD_LOGIC;
      data_in_rsci_biwt : OUT STD_LOGIC;
      data_in_rsci_bdwt : OUT STD_LOGIC;
      data_in_rsci_bcwt : IN STD_LOGIC;
      data_in_rsci_s_re_core_sct : OUT STD_LOGIC;
      data_in_rsci_s_rrdy : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      data_in_rsci_oswt : IN STD_LOGIC;
      data_in_rsci_wen_comp : OUT STD_LOGIC;
      data_in_rsci_s_raddr_core : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsci_s_din_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      data_in_rsci_biwt : IN STD_LOGIC;
      data_in_rsci_bdwt : IN STD_LOGIC;
      data_in_rsci_bcwt : OUT STD_LOGIC;
      data_in_rsci_s_raddr : OUT STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsci_s_raddr_core_sct : IN STD_LOGIC;
      data_in_rsci_s_din : IN STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_raddr_core
      : STD_LOGIC_VECTOR (12 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_din_mxwt
      : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_raddr
      : STD_LOGIC_VECTOR (12 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_din
      : STD_LOGIC_VECTOR (15 DOWNTO 0);

BEGIN
  data_in_rsci : work.amba_comps.ccs_axi4_slave_mem
    GENERIC MAP(
      rscid => 0,
      depth => 8192,
      op_width => 16,
      cwidth => 16,
      addr_w => 13,
      nopreload => 0,
      rst_ph => 0,
      ADDR_WIDTH => 13,
      DATA_WIDTH => 16,
      ID_WIDTH => 1,
      USER_WIDTH => 1,
      REGION_MAP_SIZE => 1,
      wBASE_ADDRESS => 0,
      rBASE_ADDRESS => 0
      )
    PORT MAP(
      ACLK => clk,
      ARESETn => '1',
      AWID => data_in_rsci_AWID,
      AWADDR => data_in_rsci_AWADDR,
      AWLEN => data_in_rsci_AWLEN,
      AWSIZE => data_in_rsci_AWSIZE,
      AWBURST => data_in_rsci_AWBURST,
      AWLOCK => data_in_rsc_AWLOCK,
      AWCACHE => data_in_rsci_AWCACHE,
      AWPROT => data_in_rsci_AWPROT,
      AWQOS => data_in_rsci_AWQOS,
      AWREGION => data_in_rsci_AWREGION,
      AWUSER => data_in_rsci_AWUSER,
      AWVALID => data_in_rsc_AWVALID,
      AWREADY => data_in_rsc_AWREADY,
      WDATA => data_in_rsci_WDATA,
      WSTRB => data_in_rsci_WSTRB,
      WLAST => data_in_rsc_WLAST,
      WUSER => data_in_rsci_WUSER,
      WVALID => data_in_rsc_WVALID,
      WREADY => data_in_rsc_WREADY,
      BID => data_in_rsci_BID,
      BRESP => data_in_rsci_BRESP,
      BUSER => data_in_rsci_BUSER,
      BVALID => data_in_rsc_BVALID,
      BREADY => data_in_rsc_BREADY,
      ARID => data_in_rsci_ARID,
      ARADDR => data_in_rsci_ARADDR,
      ARLEN => data_in_rsci_ARLEN,
      ARSIZE => data_in_rsci_ARSIZE,
      ARBURST => data_in_rsci_ARBURST,
      ARLOCK => data_in_rsc_ARLOCK,
      ARCACHE => data_in_rsci_ARCACHE,
      ARPROT => data_in_rsci_ARPROT,
      ARQOS => data_in_rsci_ARQOS,
      ARREGION => data_in_rsci_ARREGION,
      ARUSER => data_in_rsci_ARUSER,
      ARVALID => data_in_rsc_ARVALID,
      ARREADY => data_in_rsc_ARREADY,
      RID => data_in_rsci_RID,
      RDATA => data_in_rsci_RDATA,
      RRESP => data_in_rsci_RRESP,
      RLAST => data_in_rsc_RLAST,
      RUSER => data_in_rsci_RUSER,
      RVALID => data_in_rsc_RVALID,
      RREADY => data_in_rsc_RREADY,
      s_re => data_in_rsci_s_re_core_sct,
      s_we => '0',
      s_raddr => data_in_rsci_s_raddr_1,
      s_waddr => data_in_rsci_s_waddr,
      s_din => data_in_rsci_s_din_1,
      s_dout => data_in_rsci_s_dout,
      s_rrdy => data_in_rsci_s_rrdy,
      s_wrdy => data_in_rsci_s_wrdy,
      is_idle => data_in_rsc_is_idle,
      tr_write_done => data_in_rsc_tr_write_done,
      s_tdone => data_in_rsc_s_tdone
    );
  data_in_rsci_AWID(0) <= data_in_rsc_AWID;
  data_in_rsci_AWADDR <= data_in_rsc_AWADDR;
  data_in_rsci_AWLEN <= data_in_rsc_AWLEN;
  data_in_rsci_AWSIZE <= data_in_rsc_AWSIZE;
  data_in_rsci_AWBURST <= data_in_rsc_AWBURST;
  data_in_rsci_AWCACHE <= data_in_rsc_AWCACHE;
  data_in_rsci_AWPROT <= data_in_rsc_AWPROT;
  data_in_rsci_AWQOS <= data_in_rsc_AWQOS;
  data_in_rsci_AWREGION <= data_in_rsc_AWREGION;
  data_in_rsci_AWUSER(0) <= data_in_rsc_AWUSER;
  data_in_rsci_WDATA <= data_in_rsc_WDATA;
  data_in_rsci_WSTRB <= data_in_rsc_WSTRB;
  data_in_rsci_WUSER(0) <= data_in_rsc_WUSER;
  data_in_rsc_BID <= data_in_rsci_BID(0);
  data_in_rsc_BRESP <= data_in_rsci_BRESP;
  data_in_rsc_BUSER <= data_in_rsci_BUSER(0);
  data_in_rsci_ARID(0) <= data_in_rsc_ARID;
  data_in_rsci_ARADDR <= data_in_rsc_ARADDR;
  data_in_rsci_ARLEN <= data_in_rsc_ARLEN;
  data_in_rsci_ARSIZE <= data_in_rsc_ARSIZE;
  data_in_rsci_ARBURST <= data_in_rsc_ARBURST;
  data_in_rsci_ARCACHE <= data_in_rsc_ARCACHE;
  data_in_rsci_ARPROT <= data_in_rsc_ARPROT;
  data_in_rsci_ARQOS <= data_in_rsc_ARQOS;
  data_in_rsci_ARREGION <= data_in_rsc_ARREGION;
  data_in_rsci_ARUSER(0) <= data_in_rsc_ARUSER;
  data_in_rsc_RID <= data_in_rsci_RID(0);
  data_in_rsc_RDATA <= data_in_rsci_RDATA;
  data_in_rsc_RRESP <= data_in_rsci_RRESP;
  data_in_rsc_RUSER <= data_in_rsci_RUSER(0);
  data_in_rsci_s_raddr_1 <= data_in_rsci_s_raddr;
  data_in_rsci_s_waddr <= STD_LOGIC_VECTOR'( "0000000000000");
  data_in_rsci_s_din <= data_in_rsci_s_din_1;
  data_in_rsci_s_dout <= STD_LOGIC_VECTOR'( "0000000000000000");

  histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl_inst : histogram_hls_core_data_in_rsci_data_in_rsc_wait_ctrl
    PORT MAP(
      core_wen => core_wen,
      data_in_rsci_oswt => data_in_rsci_oswt,
      data_in_rsci_biwt => data_in_rsci_biwt,
      data_in_rsci_bdwt => data_in_rsci_bdwt,
      data_in_rsci_bcwt => data_in_rsci_bcwt,
      data_in_rsci_s_re_core_sct => data_in_rsci_s_re_core_sct,
      data_in_rsci_s_rrdy => data_in_rsci_s_rrdy
    );
  histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst : histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp
    PORT MAP(
      clk => clk,
      rst => rst,
      data_in_rsci_oswt => data_in_rsci_oswt,
      data_in_rsci_wen_comp => data_in_rsci_wen_comp,
      data_in_rsci_s_raddr_core => histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_raddr_core,
      data_in_rsci_s_din_mxwt => histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_din_mxwt,
      data_in_rsci_biwt => data_in_rsci_biwt,
      data_in_rsci_bdwt => data_in_rsci_bdwt,
      data_in_rsci_bcwt => data_in_rsci_bcwt,
      data_in_rsci_s_raddr => histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_raddr,
      data_in_rsci_s_raddr_core_sct => data_in_rsci_s_re_core_sct,
      data_in_rsci_s_din => histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_din
    );
  histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_raddr_core
      <= data_in_rsci_s_raddr_core;
  data_in_rsci_s_din_mxwt_pconst <= histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_din_mxwt;
  data_in_rsci_s_raddr <= histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_raddr;
  histogram_hls_core_data_in_rsci_data_in_rsc_wait_dp_inst_data_in_rsci_s_din <=
      data_in_rsci_s_din;

  data_in_rsci_s_din_mxwt <= data_in_rsci_s_din_mxwt_pconst;
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_core
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_core IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_in_rsc_s_tdone : IN STD_LOGIC;
    data_in_rsc_tr_write_done : IN STD_LOGIC;
    data_in_rsc_RREADY : IN STD_LOGIC;
    data_in_rsc_RVALID : OUT STD_LOGIC;
    data_in_rsc_RUSER : OUT STD_LOGIC;
    data_in_rsc_RLAST : OUT STD_LOGIC;
    data_in_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_RDATA : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
    data_in_rsc_RID : OUT STD_LOGIC;
    data_in_rsc_ARREADY : OUT STD_LOGIC;
    data_in_rsc_ARVALID : IN STD_LOGIC;
    data_in_rsc_ARUSER : IN STD_LOGIC;
    data_in_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARLOCK : IN STD_LOGIC;
    data_in_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsc_ARADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsc_ARID : IN STD_LOGIC;
    data_in_rsc_BREADY : IN STD_LOGIC;
    data_in_rsc_BVALID : OUT STD_LOGIC;
    data_in_rsc_BUSER : OUT STD_LOGIC;
    data_in_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_BID : OUT STD_LOGIC;
    data_in_rsc_WREADY : OUT STD_LOGIC;
    data_in_rsc_WVALID : IN STD_LOGIC;
    data_in_rsc_WUSER : IN STD_LOGIC;
    data_in_rsc_WLAST : IN STD_LOGIC;
    data_in_rsc_WSTRB : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_WDATA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    data_in_rsc_AWREADY : OUT STD_LOGIC;
    data_in_rsc_AWVALID : IN STD_LOGIC;
    data_in_rsc_AWUSER : IN STD_LOGIC;
    data_in_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWLOCK : IN STD_LOGIC;
    data_in_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsc_AWADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsc_AWID : IN STD_LOGIC;
    data_in_rsc_req_vz : IN STD_LOGIC;
    data_in_rsc_rls_lz : OUT STD_LOGIC;
    hist_out_rsc_s_tdone : IN STD_LOGIC;
    hist_out_rsc_tr_write_done : IN STD_LOGIC;
    hist_out_rsc_RREADY : IN STD_LOGIC;
    hist_out_rsc_RVALID : OUT STD_LOGIC;
    hist_out_rsc_RUSER : OUT STD_LOGIC;
    hist_out_rsc_RLAST : OUT STD_LOGIC;
    hist_out_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_RDATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_RID : OUT STD_LOGIC;
    hist_out_rsc_ARREADY : OUT STD_LOGIC;
    hist_out_rsc_ARVALID : IN STD_LOGIC;
    hist_out_rsc_ARUSER : IN STD_LOGIC;
    hist_out_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARLOCK : IN STD_LOGIC;
    hist_out_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_ARADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    hist_out_rsc_ARID : IN STD_LOGIC;
    hist_out_rsc_BREADY : IN STD_LOGIC;
    hist_out_rsc_BVALID : OUT STD_LOGIC;
    hist_out_rsc_BUSER : OUT STD_LOGIC;
    hist_out_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_BID : OUT STD_LOGIC;
    hist_out_rsc_WREADY : OUT STD_LOGIC;
    hist_out_rsc_WVALID : IN STD_LOGIC;
    hist_out_rsc_WUSER : IN STD_LOGIC;
    hist_out_rsc_WLAST : IN STD_LOGIC;
    hist_out_rsc_WSTRB : IN STD_LOGIC;
    hist_out_rsc_WDATA : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_AWREADY : OUT STD_LOGIC;
    hist_out_rsc_AWVALID : IN STD_LOGIC;
    hist_out_rsc_AWUSER : IN STD_LOGIC;
    hist_out_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWLOCK : IN STD_LOGIC;
    hist_out_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_AWADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    hist_out_rsc_AWID : IN STD_LOGIC;
    hist_out_rsc_req_vz : IN STD_LOGIC;
    hist_out_rsc_rls_lz : OUT STD_LOGIC;
    hist1_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist1_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist1_rsci_we_d : OUT STD_LOGIC;
    hist1_rsci_re_d : OUT STD_LOGIC;
    hist1_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist2_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist2_rsci_we_d : OUT STD_LOGIC;
    hist2_rsci_re_d : OUT STD_LOGIC;
    hist2_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist3_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist3_rsci_we_d : OUT STD_LOGIC;
    hist3_rsci_re_d : OUT STD_LOGIC;
    hist3_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist4_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist4_rsci_we_d : OUT STD_LOGIC;
    hist4_rsci_re_d : OUT STD_LOGIC;
    hist4_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist5_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist5_rsci_we_d : OUT STD_LOGIC;
    hist5_rsci_re_d : OUT STD_LOGIC;
    hist5_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist6_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist6_rsci_we_d : OUT STD_LOGIC;
    hist6_rsci_re_d : OUT STD_LOGIC;
    hist6_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist7_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist7_rsci_we_d : OUT STD_LOGIC;
    hist7_rsci_re_d : OUT STD_LOGIC;
    hist7_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist8_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    hist8_rsci_we_d : OUT STD_LOGIC;
    hist8_rsci_re_d : OUT STD_LOGIC;
    hist8_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
  );
END histogram_hls_core;

ARCHITECTURE v1 OF histogram_hls_core IS
  -- Default Constants
  CONSTANT PWR : STD_LOGIC := '1';
  CONSTANT GND : STD_LOGIC := '0';

  -- Interconnect Declarations
  SIGNAL core_wen : STD_LOGIC;
  SIGNAL core_wten : STD_LOGIC;
  SIGNAL data_in_rsci_wen_comp : STD_LOGIC;
  SIGNAL data_in_rsci_s_din_mxwt : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_wen_comp : STD_LOGIC;
  SIGNAL hist_out_rsci_wen_comp_1 : STD_LOGIC;
  SIGNAL hist_out_rsci_s_din_mxwt : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_out_rsci_s_dout_core : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_radr_d_core : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_q_d_mxwt : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsci_q_d_mxwt : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsci_q_d_mxwt : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsci_q_d_mxwt : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsci_q_d_mxwt : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsci_q_d_mxwt : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsci_q_d_mxwt : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsci_q_d_mxwt : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL data_in_rsc_req_obj_wen_comp : STD_LOGIC;
  SIGNAL hist_out_rsc_req_obj_wen_comp : STD_LOGIC;
  SIGNAL data_in_rsci_s_raddr_core_12_3 : STD_LOGIC_VECTOR (9 DOWNTO 0);
  SIGNAL data_in_rsci_s_raddr_core_2_0 : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL fsm_output : STD_LOGIC_VECTOR (19 DOWNTO 0);
  SIGNAL or_tmp_60 : STD_LOGIC;
  SIGNAL INIT_LOOP_HLS_and_itm : STD_LOGIC;
  SIGNAL count_13_3_sva_9_0 : STD_LOGIC_VECTOR (9 DOWNTO 0);
  SIGNAL accum_loop_i_8_0_sva_1 : STD_LOGIC_VECTOR (8 DOWNTO 0);
  SIGNAL count_13_3_sva_1 : STD_LOGIC_VECTOR (10 DOWNTO 0);
  SIGNAL reg_data_in_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist_out_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist_out_rsci_oswt_1_cse : STD_LOGIC;
  SIGNAL reg_hist1_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist2_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist3_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist4_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist5_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist6_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist7_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist8_rsci_oswt_cse : STD_LOGIC;
  SIGNAL reg_hist_out_rsc_rls_obj_iswt0_cse : STD_LOGIC;
  SIGNAL reg_data_in_rsc_rls_obj_iswt0_cse : STD_LOGIC;
  SIGNAL reg_data_in_rsc_req_obj_oswt_cse : STD_LOGIC;
  SIGNAL hist1_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist_loop_mux_rmff : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_44_rmff : STD_LOGIC;
  SIGNAL hist1_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsci_we_d_reg : STD_LOGIC;
  SIGNAL hist1_rsci_re_d_reg : STD_LOGIC;
  SIGNAL hist2_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_49_rmff : STD_LOGIC;
  SIGNAL hist2_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsci_we_d_reg : STD_LOGIC;
  SIGNAL hist2_rsci_re_d_reg : STD_LOGIC;
  SIGNAL hist3_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_54_rmff : STD_LOGIC;
  SIGNAL hist3_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsci_we_d_reg : STD_LOGIC;
  SIGNAL hist3_rsci_re_d_reg : STD_LOGIC;
  SIGNAL hist4_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_59_rmff : STD_LOGIC;
  SIGNAL hist4_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsci_we_d_reg : STD_LOGIC;
  SIGNAL hist4_rsci_re_d_reg : STD_LOGIC;
  SIGNAL hist5_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_64_rmff : STD_LOGIC;
  SIGNAL hist5_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsci_we_d_reg : STD_LOGIC;
  SIGNAL hist5_rsci_re_d_reg : STD_LOGIC;
  SIGNAL hist6_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_69_rmff : STD_LOGIC;
  SIGNAL hist6_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsci_we_d_reg : STD_LOGIC;
  SIGNAL hist6_rsci_re_d_reg : STD_LOGIC;
  SIGNAL hist7_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_74_rmff : STD_LOGIC;
  SIGNAL hist7_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsci_we_d_reg : STD_LOGIC;
  SIGNAL hist7_rsci_re_d_reg : STD_LOGIC;
  SIGNAL hist8_rsci_radr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_79_rmff : STD_LOGIC;
  SIGNAL hist8_rsci_wadr_d_reg : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_d_d_reg : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsci_we_d_reg : STD_LOGIC;
  SIGNAL hist8_rsci_re_d_reg : STD_LOGIC;
  SIGNAL INIT_LOOP_HLS_acc_itm : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_3_itm : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_4_itm : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_5_itm : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_6_itm : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_7_itm : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_8_itm : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL z_out : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL z_out_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL z_out_2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL z_out_3 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL z_out_4 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL or_139_tmp : STD_LOGIC;

  SIGNAL and_nl : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL mux1h_nl : STD_LOGIC_VECTOR (2 DOWNTO 0);
  SIGNAL data_in_or_nl : STD_LOGIC;
  SIGNAL INIT_LOOP_HLS_mux_8_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_mux_9_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_4_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_mux_10_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_mux_11_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_6_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_mux_12_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_mux_13_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_acc_8_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_mux_14_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL count_mux_1_nl : STD_LOGIC_VECTOR (9 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_or_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_and_1_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_mux1h_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL or_89_nl : STD_LOGIC;
  SIGNAL INIT_LOOP_HLS_or_1_nl : STD_LOGIC;
  SIGNAL count_nand_nl : STD_LOGIC;
  SIGNAL accum_loop_mux_8_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL accum_loop_accum_loop_or_4_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL accum_loop_mux_9_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL accum_loop_accum_loop_or_5_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL accum_loop_mux_10_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL accum_loop_accum_loop_or_6_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL accum_loop_mux_11_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL accum_loop_accum_loop_or_7_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_and_3_nl : STD_LOGIC_VECTOR (23 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_mux1h_39_nl : STD_LOGIC_VECTOR (23 DOWNTO 0);
  SIGNAL INIT_LOOP_HLS_nor_1_nl : STD_LOGIC;
  SIGNAL mux1h_2_nl : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL and_241_nl : STD_LOGIC;
  SIGNAL and_242_nl : STD_LOGIC;
  SIGNAL and_243_nl : STD_LOGIC;
  SIGNAL and_244_nl : STD_LOGIC;
  SIGNAL and_245_nl : STD_LOGIC;
  SIGNAL and_246_nl : STD_LOGIC;
  SIGNAL and_247_nl : STD_LOGIC;
  SIGNAL and_248_nl : STD_LOGIC;
  COMPONENT histogram_hls_core_data_in_rsci
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      data_in_rsc_s_tdone : IN STD_LOGIC;
      data_in_rsc_tr_write_done : IN STD_LOGIC;
      data_in_rsc_RREADY : IN STD_LOGIC;
      data_in_rsc_RVALID : OUT STD_LOGIC;
      data_in_rsc_RUSER : OUT STD_LOGIC;
      data_in_rsc_RLAST : OUT STD_LOGIC;
      data_in_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_RDATA : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      data_in_rsc_RID : OUT STD_LOGIC;
      data_in_rsc_ARREADY : OUT STD_LOGIC;
      data_in_rsc_ARVALID : IN STD_LOGIC;
      data_in_rsc_ARUSER : IN STD_LOGIC;
      data_in_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARLOCK : IN STD_LOGIC;
      data_in_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data_in_rsc_ARADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsc_ARID : IN STD_LOGIC;
      data_in_rsc_BREADY : IN STD_LOGIC;
      data_in_rsc_BVALID : OUT STD_LOGIC;
      data_in_rsc_BUSER : OUT STD_LOGIC;
      data_in_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_BID : OUT STD_LOGIC;
      data_in_rsc_WREADY : OUT STD_LOGIC;
      data_in_rsc_WVALID : IN STD_LOGIC;
      data_in_rsc_WUSER : IN STD_LOGIC;
      data_in_rsc_WLAST : IN STD_LOGIC;
      data_in_rsc_WSTRB : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_WDATA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      data_in_rsc_AWREADY : OUT STD_LOGIC;
      data_in_rsc_AWVALID : IN STD_LOGIC;
      data_in_rsc_AWUSER : IN STD_LOGIC;
      data_in_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWLOCK : IN STD_LOGIC;
      data_in_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data_in_rsc_AWADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsc_AWID : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      data_in_rsci_oswt : IN STD_LOGIC;
      data_in_rsci_wen_comp : OUT STD_LOGIC;
      data_in_rsci_s_raddr_core : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsci_s_din_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_RRESP : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_RDATA : STD_LOGIC_VECTOR
      (15 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARREGION : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARQOS : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARPROT : STD_LOGIC_VECTOR
      (2 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARCACHE : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARBURST : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARSIZE : STD_LOGIC_VECTOR
      (2 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARLEN : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARADDR : STD_LOGIC_VECTOR
      (12 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_BRESP : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_WSTRB : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_WDATA : STD_LOGIC_VECTOR
      (15 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWREGION : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWQOS : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWPROT : STD_LOGIC_VECTOR
      (2 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWCACHE : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWBURST : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWSIZE : STD_LOGIC_VECTOR
      (2 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWLEN : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWADDR : STD_LOGIC_VECTOR
      (12 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsci_s_raddr_core : STD_LOGIC_VECTOR
      (12 DOWNTO 0);
  SIGNAL histogram_hls_core_data_in_rsci_inst_data_in_rsci_s_din_mxwt : STD_LOGIC_VECTOR
      (7 DOWNTO 0);

  COMPONENT histogram_hls_core_hist_out_rsci
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist_out_rsc_s_tdone : IN STD_LOGIC;
      hist_out_rsc_tr_write_done : IN STD_LOGIC;
      hist_out_rsc_RREADY : IN STD_LOGIC;
      hist_out_rsc_RVALID : OUT STD_LOGIC;
      hist_out_rsc_RUSER : OUT STD_LOGIC;
      hist_out_rsc_RLAST : OUT STD_LOGIC;
      hist_out_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_RDATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_RID : OUT STD_LOGIC;
      hist_out_rsc_ARREADY : OUT STD_LOGIC;
      hist_out_rsc_ARVALID : IN STD_LOGIC;
      hist_out_rsc_ARUSER : IN STD_LOGIC;
      hist_out_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARLOCK : IN STD_LOGIC;
      hist_out_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_ARADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
      hist_out_rsc_ARID : IN STD_LOGIC;
      hist_out_rsc_BREADY : IN STD_LOGIC;
      hist_out_rsc_BVALID : OUT STD_LOGIC;
      hist_out_rsc_BUSER : OUT STD_LOGIC;
      hist_out_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_BID : OUT STD_LOGIC;
      hist_out_rsc_WREADY : OUT STD_LOGIC;
      hist_out_rsc_WVALID : IN STD_LOGIC;
      hist_out_rsc_WUSER : IN STD_LOGIC;
      hist_out_rsc_WLAST : IN STD_LOGIC;
      hist_out_rsc_WSTRB : IN STD_LOGIC;
      hist_out_rsc_WDATA : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_AWREADY : OUT STD_LOGIC;
      hist_out_rsc_AWVALID : IN STD_LOGIC;
      hist_out_rsc_AWUSER : IN STD_LOGIC;
      hist_out_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWLOCK : IN STD_LOGIC;
      hist_out_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_AWADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
      hist_out_rsc_AWID : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      hist_out_rsci_oswt : IN STD_LOGIC;
      hist_out_rsci_wen_comp : OUT STD_LOGIC;
      hist_out_rsci_oswt_1 : IN STD_LOGIC;
      hist_out_rsci_wen_comp_1 : OUT STD_LOGIC;
      hist_out_rsci_s_raddr_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsci_s_din_mxwt : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsci_s_dout_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_RRESP : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_RDATA : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARREGION : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARQOS : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARPROT : STD_LOGIC_VECTOR
      (2 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARCACHE : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARBURST : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARSIZE : STD_LOGIC_VECTOR
      (2 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARLEN : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARADDR : STD_LOGIC_VECTOR
      (11 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_BRESP : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_WDATA : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWREGION : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWQOS : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWPROT : STD_LOGIC_VECTOR
      (2 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWCACHE : STD_LOGIC_VECTOR
      (3 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWBURST : STD_LOGIC_VECTOR
      (1 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWSIZE : STD_LOGIC_VECTOR
      (2 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWLEN : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWADDR : STD_LOGIC_VECTOR
      (11 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_raddr_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_din_mxwt : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_dout_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);

  COMPONENT histogram_hls_core_hist1_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist1_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist1_rsci_we_d : OUT STD_LOGIC;
      hist1_rsci_re_d : OUT STD_LOGIC;
      hist1_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist1_rsci_oswt : IN STD_LOGIC;
      hist1_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist1_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist1_rsci_oswt_pff : IN STD_LOGIC;
      hist1_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_radr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_wadr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_d_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_q_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_radr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_d_d_core : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT histogram_hls_core_hist2_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist2_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_we_d : OUT STD_LOGIC;
      hist2_rsci_re_d : OUT STD_LOGIC;
      hist2_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist2_rsci_oswt : IN STD_LOGIC;
      hist2_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_oswt_pff : IN STD_LOGIC;
      hist2_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_radr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_wadr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_d_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_q_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_radr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_d_d_core : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT histogram_hls_core_hist3_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist3_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_we_d : OUT STD_LOGIC;
      hist3_rsci_re_d : OUT STD_LOGIC;
      hist3_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist3_rsci_oswt : IN STD_LOGIC;
      hist3_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_oswt_pff : IN STD_LOGIC;
      hist3_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_radr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_wadr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_d_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_q_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_radr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_d_d_core : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT histogram_hls_core_hist4_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist4_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_we_d : OUT STD_LOGIC;
      hist4_rsci_re_d : OUT STD_LOGIC;
      hist4_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist4_rsci_oswt : IN STD_LOGIC;
      hist4_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_oswt_pff : IN STD_LOGIC;
      hist4_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_radr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_wadr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_d_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_q_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_radr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_d_d_core : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT histogram_hls_core_hist5_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist5_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_we_d : OUT STD_LOGIC;
      hist5_rsci_re_d : OUT STD_LOGIC;
      hist5_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist5_rsci_oswt : IN STD_LOGIC;
      hist5_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_oswt_pff : IN STD_LOGIC;
      hist5_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_radr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_wadr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_d_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_q_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_radr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_d_d_core : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT histogram_hls_core_hist6_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist6_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_we_d : OUT STD_LOGIC;
      hist6_rsci_re_d : OUT STD_LOGIC;
      hist6_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist6_rsci_oswt : IN STD_LOGIC;
      hist6_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_oswt_pff : IN STD_LOGIC;
      hist6_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_radr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_wadr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_d_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_q_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_radr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_d_d_core : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT histogram_hls_core_hist7_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist7_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_we_d : OUT STD_LOGIC;
      hist7_rsci_re_d : OUT STD_LOGIC;
      hist7_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist7_rsci_oswt : IN STD_LOGIC;
      hist7_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_oswt_pff : IN STD_LOGIC;
      hist7_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_radr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_wadr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_d_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_q_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_radr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_d_d_core : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT histogram_hls_core_hist8_rsci_1
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist8_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_we_d : OUT STD_LOGIC;
      hist8_rsci_re_d : OUT STD_LOGIC;
      hist8_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      core_wen : IN STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist8_rsci_oswt : IN STD_LOGIC;
      hist8_rsci_radr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_wadr_d_core : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_d_d_core : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_q_d_mxwt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_oswt_pff : IN STD_LOGIC;
      hist8_rsci_iswt0_1_pff : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_radr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_wadr_d : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_d_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_q_d : STD_LOGIC_VECTOR (31
      DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_radr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_wadr_d_core : STD_LOGIC_VECTOR
      (7 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_d_d_core : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_q_d_mxwt : STD_LOGIC_VECTOR
      (31 DOWNTO 0);
  SIGNAL histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_iswt0_1_pff : STD_LOGIC;

  COMPONENT histogram_hls_core_hist_out_rsc_rls_obj
    PORT(
      hist_out_rsc_rls_lz : OUT STD_LOGIC;
      core_wten : IN STD_LOGIC;
      hist_out_rsc_rls_obj_iswt0 : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_data_in_rsc_rls_obj
    PORT(
      data_in_rsc_rls_lz : OUT STD_LOGIC;
      core_wten : IN STD_LOGIC;
      data_in_rsc_rls_obj_iswt0 : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_data_in_rsc_req_obj
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      data_in_rsc_req_vz : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      data_in_rsc_req_obj_oswt : IN STD_LOGIC;
      data_in_rsc_req_obj_wen_comp : OUT STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_hist_out_rsc_req_obj
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      hist_out_rsc_req_vz : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      hist_out_rsc_req_obj_oswt : IN STD_LOGIC;
      hist_out_rsc_req_obj_wen_comp : OUT STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_staller
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      core_wen : OUT STD_LOGIC;
      core_wten : OUT STD_LOGIC;
      data_in_rsci_wen_comp : IN STD_LOGIC;
      hist_out_rsci_wen_comp : IN STD_LOGIC;
      hist_out_rsci_wen_comp_1 : IN STD_LOGIC;
      data_in_rsc_req_obj_wen_comp : IN STD_LOGIC;
      hist_out_rsc_req_obj_wen_comp : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT histogram_hls_core_core_fsm
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      core_wen : IN STD_LOGIC;
      fsm_output : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
      hist8_vinit_C_1_tr0 : IN STD_LOGIC;
      hist_loop_C_10_tr0 : IN STD_LOGIC;
      accum_loop_C_2_tr0 : IN STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_core_fsm_inst_fsm_output : STD_LOGIC_VECTOR (19 DOWNTO
      0);
  SIGNAL histogram_hls_core_core_fsm_inst_hist_loop_C_10_tr0 : STD_LOGIC;
  SIGNAL histogram_hls_core_core_fsm_inst_accum_loop_C_2_tr0 : STD_LOGIC;

  FUNCTION CONV_SL_1_1(input:BOOLEAN)
  RETURN STD_LOGIC IS
  BEGIN
    IF input THEN RETURN '1';ELSE RETURN '0';END IF;
  END;

  FUNCTION MUX1HOT_v_24_9_2(input_8 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_7 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_6 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_5 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_4 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_3 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(23 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(8 DOWNTO 0))
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(23 DOWNTO 0);
    VARIABLE tmp : STD_LOGIC_VECTOR(23 DOWNTO 0);

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
      tmp := (OTHERS=>sel( 8));
      result := result or ( input_8 and tmp);
    RETURN result;
  END;

  FUNCTION MUX1HOT_v_3_6_2(input_5 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  input_4 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  input_3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(5 DOWNTO 0))
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
      tmp := (OTHERS=>sel( 3));
      result := result or ( input_3 and tmp);
      tmp := (OTHERS=>sel( 4));
      result := result or ( input_4 and tmp);
      tmp := (OTHERS=>sel( 5));
      result := result or ( input_5 and tmp);
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

  FUNCTION MUX1HOT_v_8_9_2(input_8 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_6 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_5 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  input_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  sel : STD_LOGIC_VECTOR(8 DOWNTO 0))
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
      tmp := (OTHERS=>sel( 8));
      result := result or ( input_8 and tmp);
    RETURN result;
  END;

  FUNCTION MUX_v_10_2_2(input_0 : STD_LOGIC_VECTOR(9 DOWNTO 0);
  input_1 : STD_LOGIC_VECTOR(9 DOWNTO 0);
  sel : STD_LOGIC)
  RETURN STD_LOGIC_VECTOR IS
    VARIABLE result : STD_LOGIC_VECTOR(9 DOWNTO 0);

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
  histogram_hls_core_data_in_rsci_inst : histogram_hls_core_data_in_rsci
    PORT MAP(
      clk => clk,
      rst => rst,
      data_in_rsc_s_tdone => data_in_rsc_s_tdone,
      data_in_rsc_tr_write_done => data_in_rsc_tr_write_done,
      data_in_rsc_RREADY => data_in_rsc_RREADY,
      data_in_rsc_RVALID => data_in_rsc_RVALID,
      data_in_rsc_RUSER => data_in_rsc_RUSER,
      data_in_rsc_RLAST => data_in_rsc_RLAST,
      data_in_rsc_RRESP => histogram_hls_core_data_in_rsci_inst_data_in_rsc_RRESP,
      data_in_rsc_RDATA => histogram_hls_core_data_in_rsci_inst_data_in_rsc_RDATA,
      data_in_rsc_RID => data_in_rsc_RID,
      data_in_rsc_ARREADY => data_in_rsc_ARREADY,
      data_in_rsc_ARVALID => data_in_rsc_ARVALID,
      data_in_rsc_ARUSER => data_in_rsc_ARUSER,
      data_in_rsc_ARREGION => histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARREGION,
      data_in_rsc_ARQOS => histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARQOS,
      data_in_rsc_ARPROT => histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARPROT,
      data_in_rsc_ARCACHE => histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARCACHE,
      data_in_rsc_ARLOCK => data_in_rsc_ARLOCK,
      data_in_rsc_ARBURST => histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARBURST,
      data_in_rsc_ARSIZE => histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARSIZE,
      data_in_rsc_ARLEN => histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARLEN,
      data_in_rsc_ARADDR => histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARADDR,
      data_in_rsc_ARID => data_in_rsc_ARID,
      data_in_rsc_BREADY => data_in_rsc_BREADY,
      data_in_rsc_BVALID => data_in_rsc_BVALID,
      data_in_rsc_BUSER => data_in_rsc_BUSER,
      data_in_rsc_BRESP => histogram_hls_core_data_in_rsci_inst_data_in_rsc_BRESP,
      data_in_rsc_BID => data_in_rsc_BID,
      data_in_rsc_WREADY => data_in_rsc_WREADY,
      data_in_rsc_WVALID => data_in_rsc_WVALID,
      data_in_rsc_WUSER => data_in_rsc_WUSER,
      data_in_rsc_WLAST => data_in_rsc_WLAST,
      data_in_rsc_WSTRB => histogram_hls_core_data_in_rsci_inst_data_in_rsc_WSTRB,
      data_in_rsc_WDATA => histogram_hls_core_data_in_rsci_inst_data_in_rsc_WDATA,
      data_in_rsc_AWREADY => data_in_rsc_AWREADY,
      data_in_rsc_AWVALID => data_in_rsc_AWVALID,
      data_in_rsc_AWUSER => data_in_rsc_AWUSER,
      data_in_rsc_AWREGION => histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWREGION,
      data_in_rsc_AWQOS => histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWQOS,
      data_in_rsc_AWPROT => histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWPROT,
      data_in_rsc_AWCACHE => histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWCACHE,
      data_in_rsc_AWLOCK => data_in_rsc_AWLOCK,
      data_in_rsc_AWBURST => histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWBURST,
      data_in_rsc_AWSIZE => histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWSIZE,
      data_in_rsc_AWLEN => histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWLEN,
      data_in_rsc_AWADDR => histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWADDR,
      data_in_rsc_AWID => data_in_rsc_AWID,
      core_wen => core_wen,
      data_in_rsci_oswt => reg_data_in_rsci_oswt_cse,
      data_in_rsci_wen_comp => data_in_rsci_wen_comp,
      data_in_rsci_s_raddr_core => histogram_hls_core_data_in_rsci_inst_data_in_rsci_s_raddr_core,
      data_in_rsci_s_din_mxwt => histogram_hls_core_data_in_rsci_inst_data_in_rsci_s_din_mxwt
    );
  data_in_rsc_RRESP <= histogram_hls_core_data_in_rsci_inst_data_in_rsc_RRESP;
  data_in_rsc_RDATA <= histogram_hls_core_data_in_rsci_inst_data_in_rsc_RDATA;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARREGION <= data_in_rsc_ARREGION;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARQOS <= data_in_rsc_ARQOS;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARPROT <= data_in_rsc_ARPROT;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARCACHE <= data_in_rsc_ARCACHE;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARBURST <= data_in_rsc_ARBURST;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARSIZE <= data_in_rsc_ARSIZE;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARLEN <= data_in_rsc_ARLEN;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_ARADDR <= data_in_rsc_ARADDR;
  data_in_rsc_BRESP <= histogram_hls_core_data_in_rsci_inst_data_in_rsc_BRESP;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_WSTRB <= data_in_rsc_WSTRB;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_WDATA <= data_in_rsc_WDATA;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWREGION <= data_in_rsc_AWREGION;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWQOS <= data_in_rsc_AWQOS;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWPROT <= data_in_rsc_AWPROT;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWCACHE <= data_in_rsc_AWCACHE;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWBURST <= data_in_rsc_AWBURST;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWSIZE <= data_in_rsc_AWSIZE;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWLEN <= data_in_rsc_AWLEN;
  histogram_hls_core_data_in_rsci_inst_data_in_rsc_AWADDR <= data_in_rsc_AWADDR;
  histogram_hls_core_data_in_rsci_inst_data_in_rsci_s_raddr_core <= data_in_rsci_s_raddr_core_12_3
      & data_in_rsci_s_raddr_core_2_0;
  data_in_rsci_s_din_mxwt <= histogram_hls_core_data_in_rsci_inst_data_in_rsci_s_din_mxwt;

  histogram_hls_core_hist_out_rsci_inst : histogram_hls_core_hist_out_rsci
    PORT MAP(
      clk => clk,
      rst => rst,
      hist_out_rsc_s_tdone => hist_out_rsc_s_tdone,
      hist_out_rsc_tr_write_done => hist_out_rsc_tr_write_done,
      hist_out_rsc_RREADY => hist_out_rsc_RREADY,
      hist_out_rsc_RVALID => hist_out_rsc_RVALID,
      hist_out_rsc_RUSER => hist_out_rsc_RUSER,
      hist_out_rsc_RLAST => hist_out_rsc_RLAST,
      hist_out_rsc_RRESP => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_RRESP,
      hist_out_rsc_RDATA => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_RDATA,
      hist_out_rsc_RID => hist_out_rsc_RID,
      hist_out_rsc_ARREADY => hist_out_rsc_ARREADY,
      hist_out_rsc_ARVALID => hist_out_rsc_ARVALID,
      hist_out_rsc_ARUSER => hist_out_rsc_ARUSER,
      hist_out_rsc_ARREGION => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARREGION,
      hist_out_rsc_ARQOS => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARQOS,
      hist_out_rsc_ARPROT => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARPROT,
      hist_out_rsc_ARCACHE => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARCACHE,
      hist_out_rsc_ARLOCK => hist_out_rsc_ARLOCK,
      hist_out_rsc_ARBURST => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARBURST,
      hist_out_rsc_ARSIZE => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARSIZE,
      hist_out_rsc_ARLEN => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARLEN,
      hist_out_rsc_ARADDR => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARADDR,
      hist_out_rsc_ARID => hist_out_rsc_ARID,
      hist_out_rsc_BREADY => hist_out_rsc_BREADY,
      hist_out_rsc_BVALID => hist_out_rsc_BVALID,
      hist_out_rsc_BUSER => hist_out_rsc_BUSER,
      hist_out_rsc_BRESP => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_BRESP,
      hist_out_rsc_BID => hist_out_rsc_BID,
      hist_out_rsc_WREADY => hist_out_rsc_WREADY,
      hist_out_rsc_WVALID => hist_out_rsc_WVALID,
      hist_out_rsc_WUSER => hist_out_rsc_WUSER,
      hist_out_rsc_WLAST => hist_out_rsc_WLAST,
      hist_out_rsc_WSTRB => hist_out_rsc_WSTRB,
      hist_out_rsc_WDATA => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_WDATA,
      hist_out_rsc_AWREADY => hist_out_rsc_AWREADY,
      hist_out_rsc_AWVALID => hist_out_rsc_AWVALID,
      hist_out_rsc_AWUSER => hist_out_rsc_AWUSER,
      hist_out_rsc_AWREGION => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWREGION,
      hist_out_rsc_AWQOS => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWQOS,
      hist_out_rsc_AWPROT => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWPROT,
      hist_out_rsc_AWCACHE => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWCACHE,
      hist_out_rsc_AWLOCK => hist_out_rsc_AWLOCK,
      hist_out_rsc_AWBURST => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWBURST,
      hist_out_rsc_AWSIZE => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWSIZE,
      hist_out_rsc_AWLEN => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWLEN,
      hist_out_rsc_AWADDR => histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWADDR,
      hist_out_rsc_AWID => hist_out_rsc_AWID,
      core_wen => core_wen,
      hist_out_rsci_oswt => reg_hist_out_rsci_oswt_cse,
      hist_out_rsci_wen_comp => hist_out_rsci_wen_comp,
      hist_out_rsci_oswt_1 => reg_hist_out_rsci_oswt_1_cse,
      hist_out_rsci_wen_comp_1 => hist_out_rsci_wen_comp_1,
      hist_out_rsci_s_raddr_core => histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_raddr_core,
      hist_out_rsci_s_din_mxwt => histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_din_mxwt,
      hist_out_rsci_s_dout_core => histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_dout_core
    );
  hist_out_rsc_RRESP <= histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_RRESP;
  hist_out_rsc_RDATA <= histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_RDATA;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARREGION <= hist_out_rsc_ARREGION;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARQOS <= hist_out_rsc_ARQOS;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARPROT <= hist_out_rsc_ARPROT;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARCACHE <= hist_out_rsc_ARCACHE;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARBURST <= hist_out_rsc_ARBURST;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARSIZE <= hist_out_rsc_ARSIZE;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARLEN <= hist_out_rsc_ARLEN;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_ARADDR <= hist_out_rsc_ARADDR;
  hist_out_rsc_BRESP <= histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_BRESP;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_WDATA <= hist_out_rsc_WDATA;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWREGION <= hist_out_rsc_AWREGION;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWQOS <= hist_out_rsc_AWQOS;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWPROT <= hist_out_rsc_AWPROT;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWCACHE <= hist_out_rsc_AWCACHE;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWBURST <= hist_out_rsc_AWBURST;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWSIZE <= hist_out_rsc_AWSIZE;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWLEN <= hist_out_rsc_AWLEN;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsc_AWADDR <= hist_out_rsc_AWADDR;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_raddr_core <= data_in_rsci_s_raddr_core_12_3(7
      DOWNTO 0);
  hist_out_rsci_s_din_mxwt <= histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_din_mxwt;
  histogram_hls_core_hist_out_rsci_inst_hist_out_rsci_s_dout_core <= hist_out_rsci_s_dout_core;

  histogram_hls_core_hist1_rsci_1_inst : histogram_hls_core_hist1_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      hist1_rsci_radr_d => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_radr_d,
      hist1_rsci_wadr_d => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_wadr_d,
      hist1_rsci_d_d => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_d_d,
      hist1_rsci_we_d => hist1_rsci_we_d_reg,
      hist1_rsci_re_d => hist1_rsci_re_d_reg,
      hist1_rsci_q_d => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      hist1_rsci_oswt => reg_hist1_rsci_oswt_cse,
      hist1_rsci_radr_d_core => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_radr_d_core,
      hist1_rsci_wadr_d_core => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_wadr_d_core,
      hist1_rsci_d_d_core => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_d_d_core,
      hist1_rsci_q_d_mxwt => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_q_d_mxwt,
      hist1_rsci_oswt_pff => or_44_rmff,
      hist1_rsci_iswt0_1_pff => histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_iswt0_1_pff
    );
  hist1_rsci_radr_d_reg <= histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_radr_d;
  hist1_rsci_wadr_d_reg <= histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_wadr_d;
  hist1_rsci_d_d_reg <= histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_d_d;
  histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_q_d <= hist1_rsci_q_d;
  histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_radr_d_core <= hist_loop_mux_rmff;
  histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_wadr_d_core <= MUX_v_8_2_2(INIT_LOOP_HLS_acc_itm,
      hist1_rsci_radr_d_core, fsm_output(13));
  histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_d_d_core <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      z_out_4, (fsm_output(13)));
  hist1_rsci_q_d_mxwt <= histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_q_d_mxwt;
  histogram_hls_core_hist1_rsci_1_inst_hist1_rsci_iswt0_1_pff <= (fsm_output(13))
      OR (fsm_output(2));

  histogram_hls_core_hist2_rsci_1_inst : histogram_hls_core_hist2_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      hist2_rsci_radr_d => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_radr_d,
      hist2_rsci_wadr_d => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_wadr_d,
      hist2_rsci_d_d => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_d_d,
      hist2_rsci_we_d => hist2_rsci_we_d_reg,
      hist2_rsci_re_d => hist2_rsci_re_d_reg,
      hist2_rsci_q_d => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      hist2_rsci_oswt => reg_hist2_rsci_oswt_cse,
      hist2_rsci_radr_d_core => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_radr_d_core,
      hist2_rsci_wadr_d_core => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_wadr_d_core,
      hist2_rsci_d_d_core => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_d_d_core,
      hist2_rsci_q_d_mxwt => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_q_d_mxwt,
      hist2_rsci_oswt_pff => or_49_rmff,
      hist2_rsci_iswt0_1_pff => histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_iswt0_1_pff
    );
  hist2_rsci_radr_d_reg <= histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_radr_d;
  hist2_rsci_wadr_d_reg <= histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_wadr_d;
  hist2_rsci_d_d_reg <= histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_d_d;
  histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_q_d <= hist2_rsci_q_d;
  histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_radr_d_core <= hist_loop_mux_rmff;
  histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_wadr_d_core <= MUX_v_8_2_2((count_13_3_sva_9_0(7
      DOWNTO 0)), hist1_rsci_radr_d_core, fsm_output(12));
  histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_d_d_core <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      z_out_4, (fsm_output(12)));
  hist2_rsci_q_d_mxwt <= histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_q_d_mxwt;
  histogram_hls_core_hist2_rsci_1_inst_hist2_rsci_iswt0_1_pff <= (fsm_output(12))
      OR (fsm_output(2));

  histogram_hls_core_hist3_rsci_1_inst : histogram_hls_core_hist3_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      hist3_rsci_radr_d => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_radr_d,
      hist3_rsci_wadr_d => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_wadr_d,
      hist3_rsci_d_d => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_d_d,
      hist3_rsci_we_d => hist3_rsci_we_d_reg,
      hist3_rsci_re_d => hist3_rsci_re_d_reg,
      hist3_rsci_q_d => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      hist3_rsci_oswt => reg_hist3_rsci_oswt_cse,
      hist3_rsci_radr_d_core => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_radr_d_core,
      hist3_rsci_wadr_d_core => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_wadr_d_core,
      hist3_rsci_d_d_core => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_d_d_core,
      hist3_rsci_q_d_mxwt => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_q_d_mxwt,
      hist3_rsci_oswt_pff => or_54_rmff,
      hist3_rsci_iswt0_1_pff => histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_iswt0_1_pff
    );
  hist3_rsci_radr_d_reg <= histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_radr_d;
  hist3_rsci_wadr_d_reg <= histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_wadr_d;
  hist3_rsci_d_d_reg <= histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_d_d;
  histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_q_d <= hist3_rsci_q_d;
  histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_radr_d_core <= hist_loop_mux_rmff;
  histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_wadr_d_core <= MUX_v_8_2_2(INIT_LOOP_HLS_acc_3_itm,
      hist1_rsci_radr_d_core, fsm_output(11));
  histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_d_d_core <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      z_out_4, (fsm_output(11)));
  hist3_rsci_q_d_mxwt <= histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_q_d_mxwt;
  histogram_hls_core_hist3_rsci_1_inst_hist3_rsci_iswt0_1_pff <= (fsm_output(11))
      OR (fsm_output(2));

  histogram_hls_core_hist4_rsci_1_inst : histogram_hls_core_hist4_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      hist4_rsci_radr_d => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_radr_d,
      hist4_rsci_wadr_d => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_wadr_d,
      hist4_rsci_d_d => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_d_d,
      hist4_rsci_we_d => hist4_rsci_we_d_reg,
      hist4_rsci_re_d => hist4_rsci_re_d_reg,
      hist4_rsci_q_d => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      hist4_rsci_oswt => reg_hist4_rsci_oswt_cse,
      hist4_rsci_radr_d_core => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_radr_d_core,
      hist4_rsci_wadr_d_core => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_wadr_d_core,
      hist4_rsci_d_d_core => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_d_d_core,
      hist4_rsci_q_d_mxwt => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_q_d_mxwt,
      hist4_rsci_oswt_pff => or_59_rmff,
      hist4_rsci_iswt0_1_pff => histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_iswt0_1_pff
    );
  hist4_rsci_radr_d_reg <= histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_radr_d;
  hist4_rsci_wadr_d_reg <= histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_wadr_d;
  hist4_rsci_d_d_reg <= histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_d_d;
  histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_q_d <= hist4_rsci_q_d;
  histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_radr_d_core <= hist_loop_mux_rmff;
  histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_wadr_d_core <= MUX_v_8_2_2(INIT_LOOP_HLS_acc_4_itm,
      hist1_rsci_radr_d_core, fsm_output(10));
  histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_d_d_core <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      z_out_4, (fsm_output(10)));
  hist4_rsci_q_d_mxwt <= histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_q_d_mxwt;
  histogram_hls_core_hist4_rsci_1_inst_hist4_rsci_iswt0_1_pff <= (fsm_output(10))
      OR (fsm_output(2));

  histogram_hls_core_hist5_rsci_1_inst : histogram_hls_core_hist5_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      hist5_rsci_radr_d => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_radr_d,
      hist5_rsci_wadr_d => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_wadr_d,
      hist5_rsci_d_d => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_d_d,
      hist5_rsci_we_d => hist5_rsci_we_d_reg,
      hist5_rsci_re_d => hist5_rsci_re_d_reg,
      hist5_rsci_q_d => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      hist5_rsci_oswt => reg_hist5_rsci_oswt_cse,
      hist5_rsci_radr_d_core => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_radr_d_core,
      hist5_rsci_wadr_d_core => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_wadr_d_core,
      hist5_rsci_d_d_core => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_d_d_core,
      hist5_rsci_q_d_mxwt => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_q_d_mxwt,
      hist5_rsci_oswt_pff => or_64_rmff,
      hist5_rsci_iswt0_1_pff => histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_iswt0_1_pff
    );
  hist5_rsci_radr_d_reg <= histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_radr_d;
  hist5_rsci_wadr_d_reg <= histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_wadr_d;
  hist5_rsci_d_d_reg <= histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_d_d;
  histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_q_d <= hist5_rsci_q_d;
  histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_radr_d_core <= hist_loop_mux_rmff;
  histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_wadr_d_core <= MUX_v_8_2_2(INIT_LOOP_HLS_acc_5_itm,
      hist1_rsci_radr_d_core, fsm_output(9));
  histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_d_d_core <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      z_out_4, (fsm_output(9)));
  hist5_rsci_q_d_mxwt <= histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_q_d_mxwt;
  histogram_hls_core_hist5_rsci_1_inst_hist5_rsci_iswt0_1_pff <= (fsm_output(9))
      OR (fsm_output(2));

  histogram_hls_core_hist6_rsci_1_inst : histogram_hls_core_hist6_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      hist6_rsci_radr_d => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_radr_d,
      hist6_rsci_wadr_d => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_wadr_d,
      hist6_rsci_d_d => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_d_d,
      hist6_rsci_we_d => hist6_rsci_we_d_reg,
      hist6_rsci_re_d => hist6_rsci_re_d_reg,
      hist6_rsci_q_d => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      hist6_rsci_oswt => reg_hist6_rsci_oswt_cse,
      hist6_rsci_radr_d_core => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_radr_d_core,
      hist6_rsci_wadr_d_core => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_wadr_d_core,
      hist6_rsci_d_d_core => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_d_d_core,
      hist6_rsci_q_d_mxwt => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_q_d_mxwt,
      hist6_rsci_oswt_pff => or_69_rmff,
      hist6_rsci_iswt0_1_pff => histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_iswt0_1_pff
    );
  hist6_rsci_radr_d_reg <= histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_radr_d;
  hist6_rsci_wadr_d_reg <= histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_wadr_d;
  hist6_rsci_d_d_reg <= histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_d_d;
  histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_q_d <= hist6_rsci_q_d;
  histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_radr_d_core <= hist_loop_mux_rmff;
  histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_wadr_d_core <= MUX_v_8_2_2(INIT_LOOP_HLS_acc_6_itm,
      hist1_rsci_radr_d_core, fsm_output(8));
  histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_d_d_core <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      z_out_4, (fsm_output(8)));
  hist6_rsci_q_d_mxwt <= histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_q_d_mxwt;
  histogram_hls_core_hist6_rsci_1_inst_hist6_rsci_iswt0_1_pff <= (fsm_output(8))
      OR (fsm_output(2));

  histogram_hls_core_hist7_rsci_1_inst : histogram_hls_core_hist7_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      hist7_rsci_radr_d => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_radr_d,
      hist7_rsci_wadr_d => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_wadr_d,
      hist7_rsci_d_d => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_d_d,
      hist7_rsci_we_d => hist7_rsci_we_d_reg,
      hist7_rsci_re_d => hist7_rsci_re_d_reg,
      hist7_rsci_q_d => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      hist7_rsci_oswt => reg_hist7_rsci_oswt_cse,
      hist7_rsci_radr_d_core => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_radr_d_core,
      hist7_rsci_wadr_d_core => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_wadr_d_core,
      hist7_rsci_d_d_core => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_d_d_core,
      hist7_rsci_q_d_mxwt => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_q_d_mxwt,
      hist7_rsci_oswt_pff => or_74_rmff,
      hist7_rsci_iswt0_1_pff => histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_iswt0_1_pff
    );
  hist7_rsci_radr_d_reg <= histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_radr_d;
  hist7_rsci_wadr_d_reg <= histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_wadr_d;
  hist7_rsci_d_d_reg <= histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_d_d;
  histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_q_d <= hist7_rsci_q_d;
  histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_radr_d_core <= hist_loop_mux_rmff;
  histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_wadr_d_core <= MUX_v_8_2_2(INIT_LOOP_HLS_acc_7_itm,
      hist1_rsci_radr_d_core, fsm_output(7));
  histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_d_d_core <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      z_out_4, (fsm_output(7)));
  hist7_rsci_q_d_mxwt <= histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_q_d_mxwt;
  histogram_hls_core_hist7_rsci_1_inst_hist7_rsci_iswt0_1_pff <= (fsm_output(7))
      OR (fsm_output(2));

  histogram_hls_core_hist8_rsci_1_inst : histogram_hls_core_hist8_rsci_1
    PORT MAP(
      clk => clk,
      rst => rst,
      hist8_rsci_radr_d => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_radr_d,
      hist8_rsci_wadr_d => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_wadr_d,
      hist8_rsci_d_d => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_d_d,
      hist8_rsci_we_d => hist8_rsci_we_d_reg,
      hist8_rsci_re_d => hist8_rsci_re_d_reg,
      hist8_rsci_q_d => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_q_d,
      core_wen => core_wen,
      core_wten => core_wten,
      hist8_rsci_oswt => reg_hist8_rsci_oswt_cse,
      hist8_rsci_radr_d_core => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_radr_d_core,
      hist8_rsci_wadr_d_core => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_wadr_d_core,
      hist8_rsci_d_d_core => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_d_d_core,
      hist8_rsci_q_d_mxwt => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_q_d_mxwt,
      hist8_rsci_oswt_pff => or_79_rmff,
      hist8_rsci_iswt0_1_pff => histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_iswt0_1_pff
    );
  hist8_rsci_radr_d_reg <= histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_radr_d;
  hist8_rsci_wadr_d_reg <= histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_wadr_d;
  hist8_rsci_d_d_reg <= histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_d_d;
  histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_q_d <= hist8_rsci_q_d;
  histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_radr_d_core <= hist_loop_mux_rmff;
  histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_wadr_d_core <= MUX_v_8_2_2(INIT_LOOP_HLS_acc_8_itm,
      hist1_rsci_radr_d_core, fsm_output(6));
  histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_d_d_core <= MUX_v_32_2_2(STD_LOGIC_VECTOR'("00000000000000000000000000000000"),
      z_out_4, (fsm_output(6)));
  hist8_rsci_q_d_mxwt <= histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_q_d_mxwt;
  histogram_hls_core_hist8_rsci_1_inst_hist8_rsci_iswt0_1_pff <= (fsm_output(6))
      OR (fsm_output(2));

  histogram_hls_core_hist_out_rsc_rls_obj_inst : histogram_hls_core_hist_out_rsc_rls_obj
    PORT MAP(
      hist_out_rsc_rls_lz => hist_out_rsc_rls_lz,
      core_wten => core_wten,
      hist_out_rsc_rls_obj_iswt0 => reg_hist_out_rsc_rls_obj_iswt0_cse
    );
  histogram_hls_core_data_in_rsc_rls_obj_inst : histogram_hls_core_data_in_rsc_rls_obj
    PORT MAP(
      data_in_rsc_rls_lz => data_in_rsc_rls_lz,
      core_wten => core_wten,
      data_in_rsc_rls_obj_iswt0 => reg_data_in_rsc_rls_obj_iswt0_cse
    );
  histogram_hls_core_data_in_rsc_req_obj_inst : histogram_hls_core_data_in_rsc_req_obj
    PORT MAP(
      clk => clk,
      rst => rst,
      data_in_rsc_req_vz => data_in_rsc_req_vz,
      core_wen => core_wen,
      data_in_rsc_req_obj_oswt => reg_data_in_rsc_req_obj_oswt_cse,
      data_in_rsc_req_obj_wen_comp => data_in_rsc_req_obj_wen_comp
    );
  histogram_hls_core_hist_out_rsc_req_obj_inst : histogram_hls_core_hist_out_rsc_req_obj
    PORT MAP(
      clk => clk,
      rst => rst,
      hist_out_rsc_req_vz => hist_out_rsc_req_vz,
      core_wen => core_wen,
      hist_out_rsc_req_obj_oswt => reg_data_in_rsc_req_obj_oswt_cse,
      hist_out_rsc_req_obj_wen_comp => hist_out_rsc_req_obj_wen_comp
    );
  histogram_hls_core_staller_inst : histogram_hls_core_staller
    PORT MAP(
      clk => clk,
      rst => rst,
      core_wen => core_wen,
      core_wten => core_wten,
      data_in_rsci_wen_comp => data_in_rsci_wen_comp,
      hist_out_rsci_wen_comp => hist_out_rsci_wen_comp,
      hist_out_rsci_wen_comp_1 => hist_out_rsci_wen_comp_1,
      data_in_rsc_req_obj_wen_comp => data_in_rsc_req_obj_wen_comp,
      hist_out_rsc_req_obj_wen_comp => hist_out_rsc_req_obj_wen_comp
    );
  histogram_hls_core_core_fsm_inst : histogram_hls_core_core_fsm
    PORT MAP(
      clk => clk,
      rst => rst,
      core_wen => core_wen,
      fsm_output => histogram_hls_core_core_fsm_inst_fsm_output,
      hist8_vinit_C_1_tr0 => INIT_LOOP_HLS_and_itm,
      hist_loop_C_10_tr0 => histogram_hls_core_core_fsm_inst_hist_loop_C_10_tr0,
      accum_loop_C_2_tr0 => histogram_hls_core_core_fsm_inst_accum_loop_C_2_tr0
    );
  fsm_output <= histogram_hls_core_core_fsm_inst_fsm_output;
  histogram_hls_core_core_fsm_inst_hist_loop_C_10_tr0 <= count_13_3_sva_1(10);
  histogram_hls_core_core_fsm_inst_accum_loop_C_2_tr0 <= accum_loop_i_8_0_sva_1(8);

  or_44_rmff <= (fsm_output(12)) OR (fsm_output(16));
  hist_loop_mux_rmff <= MUX_v_8_2_2(data_in_rsci_s_din_mxwt, (count_13_3_sva_9_0(7
      DOWNTO 0)), fsm_output(16));
  or_49_rmff <= (fsm_output(11)) OR (fsm_output(16));
  or_54_rmff <= (fsm_output(10)) OR (fsm_output(16));
  or_59_rmff <= (fsm_output(9)) OR (fsm_output(16));
  or_64_rmff <= (fsm_output(8)) OR (fsm_output(16));
  or_69_rmff <= (fsm_output(7)) OR (fsm_output(16));
  or_74_rmff <= (fsm_output(6)) OR (fsm_output(16));
  or_79_rmff <= (fsm_output(5)) OR (fsm_output(16));
  or_tmp_60 <= NOT(CONV_SL_1_1(fsm_output(3 DOWNTO 2)/=STD_LOGIC_VECTOR'("00")));
  hist1_rsci_radr_d <= hist1_rsci_radr_d_reg;
  hist1_rsci_wadr_d <= hist1_rsci_wadr_d_reg;
  hist1_rsci_d_d <= hist1_rsci_d_d_reg;
  hist1_rsci_we_d <= hist1_rsci_we_d_reg;
  hist1_rsci_re_d <= hist1_rsci_re_d_reg;
  hist2_rsci_radr_d <= hist2_rsci_radr_d_reg;
  hist2_rsci_wadr_d <= hist2_rsci_wadr_d_reg;
  hist2_rsci_d_d <= hist2_rsci_d_d_reg;
  hist2_rsci_we_d <= hist2_rsci_we_d_reg;
  hist2_rsci_re_d <= hist2_rsci_re_d_reg;
  hist3_rsci_radr_d <= hist3_rsci_radr_d_reg;
  hist3_rsci_wadr_d <= hist3_rsci_wadr_d_reg;
  hist3_rsci_d_d <= hist3_rsci_d_d_reg;
  hist3_rsci_we_d <= hist3_rsci_we_d_reg;
  hist3_rsci_re_d <= hist3_rsci_re_d_reg;
  hist4_rsci_radr_d <= hist4_rsci_radr_d_reg;
  hist4_rsci_wadr_d <= hist4_rsci_wadr_d_reg;
  hist4_rsci_d_d <= hist4_rsci_d_d_reg;
  hist4_rsci_we_d <= hist4_rsci_we_d_reg;
  hist4_rsci_re_d <= hist4_rsci_re_d_reg;
  hist5_rsci_radr_d <= hist5_rsci_radr_d_reg;
  hist5_rsci_wadr_d <= hist5_rsci_wadr_d_reg;
  hist5_rsci_d_d <= hist5_rsci_d_d_reg;
  hist5_rsci_we_d <= hist5_rsci_we_d_reg;
  hist5_rsci_re_d <= hist5_rsci_re_d_reg;
  hist6_rsci_radr_d <= hist6_rsci_radr_d_reg;
  hist6_rsci_wadr_d <= hist6_rsci_wadr_d_reg;
  hist6_rsci_d_d <= hist6_rsci_d_d_reg;
  hist6_rsci_we_d <= hist6_rsci_we_d_reg;
  hist6_rsci_re_d <= hist6_rsci_re_d_reg;
  hist7_rsci_radr_d <= hist7_rsci_radr_d_reg;
  hist7_rsci_wadr_d <= hist7_rsci_wadr_d_reg;
  hist7_rsci_d_d <= hist7_rsci_d_d_reg;
  hist7_rsci_we_d <= hist7_rsci_we_d_reg;
  hist7_rsci_re_d <= hist7_rsci_re_d_reg;
  hist8_rsci_radr_d <= hist8_rsci_radr_d_reg;
  hist8_rsci_wadr_d <= hist8_rsci_wadr_d_reg;
  hist8_rsci_d_d <= hist8_rsci_d_d_reg;
  hist8_rsci_we_d <= hist8_rsci_we_d_reg;
  hist8_rsci_re_d <= hist8_rsci_re_d_reg;
  or_139_tmp <= (fsm_output(2)) OR (fsm_output(4)) OR (fsm_output(16));
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( core_wen = '1' ) THEN
        data_in_rsci_s_raddr_core_2_0 <= MUX_v_3_2_2(and_nl, STD_LOGIC_VECTOR'("111"),
            (fsm_output(4)));
        data_in_rsci_s_raddr_core_12_3 <= count_13_3_sva_9_0;
        hist_out_rsci_s_dout_core <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(z_out_1)
            + UNSIGNED(z_out_2) + UNSIGNED(z_out_3) + UNSIGNED(z_out) + UNSIGNED(hist_out_rsci_s_din_mxwt),
            8));
        hist1_rsci_radr_d_core <= hist_loop_mux_rmff;
        INIT_LOOP_HLS_acc_3_itm <= MUX_v_8_2_2(INIT_LOOP_HLS_mux_8_nl, STD_LOGIC_VECTOR'("11111111"),
            or_tmp_60);
        INIT_LOOP_HLS_acc_4_itm <= MUX_v_8_2_2(INIT_LOOP_HLS_mux_9_nl, STD_LOGIC_VECTOR'("11111111"),
            or_tmp_60);
        INIT_LOOP_HLS_acc_5_itm <= MUX_v_8_2_2(INIT_LOOP_HLS_mux_10_nl, STD_LOGIC_VECTOR'("11111111"),
            or_tmp_60);
        INIT_LOOP_HLS_acc_6_itm <= MUX_v_8_2_2(INIT_LOOP_HLS_mux_11_nl, STD_LOGIC_VECTOR'("11111111"),
            or_tmp_60);
        INIT_LOOP_HLS_acc_7_itm <= MUX_v_8_2_2(INIT_LOOP_HLS_mux_12_nl, STD_LOGIC_VECTOR'("11111111"),
            or_tmp_60);
        INIT_LOOP_HLS_acc_8_itm <= MUX_v_8_2_2(INIT_LOOP_HLS_mux_13_nl, STD_LOGIC_VECTOR'("11111111"),
            or_tmp_60);
        INIT_LOOP_HLS_acc_itm <= MUX_v_8_2_2(INIT_LOOP_HLS_mux_14_nl, STD_LOGIC_VECTOR'("11111111"),
            or_tmp_60);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        reg_data_in_rsci_oswt_cse <= '0';
        reg_hist_out_rsci_oswt_cse <= '0';
        reg_hist_out_rsci_oswt_1_cse <= '0';
        reg_hist1_rsci_oswt_cse <= '0';
        reg_hist2_rsci_oswt_cse <= '0';
        reg_hist3_rsci_oswt_cse <= '0';
        reg_hist4_rsci_oswt_cse <= '0';
        reg_hist5_rsci_oswt_cse <= '0';
        reg_hist6_rsci_oswt_cse <= '0';
        reg_hist7_rsci_oswt_cse <= '0';
        reg_hist8_rsci_oswt_cse <= '0';
        reg_hist_out_rsc_rls_obj_iswt0_cse <= '0';
        reg_data_in_rsc_rls_obj_iswt0_cse <= '0';
        reg_data_in_rsc_req_obj_oswt_cse <= '0';
        INIT_LOOP_HLS_and_itm <= '0';
      ELSIF ( core_wen = '1' ) THEN
        reg_data_in_rsci_oswt_cse <= CONV_SL_1_1(fsm_output(11 DOWNTO 4)/=STD_LOGIC_VECTOR'("00000000"));
        reg_hist_out_rsci_oswt_cse <= fsm_output(16);
        reg_hist_out_rsci_oswt_1_cse <= fsm_output(17);
        reg_hist1_rsci_oswt_cse <= or_44_rmff;
        reg_hist2_rsci_oswt_cse <= or_49_rmff;
        reg_hist3_rsci_oswt_cse <= or_54_rmff;
        reg_hist4_rsci_oswt_cse <= or_59_rmff;
        reg_hist5_rsci_oswt_cse <= or_64_rmff;
        reg_hist6_rsci_oswt_cse <= or_69_rmff;
        reg_hist7_rsci_oswt_cse <= or_74_rmff;
        reg_hist8_rsci_oswt_cse <= or_79_rmff;
        reg_hist_out_rsc_rls_obj_iswt0_cse <= (accum_loop_i_8_0_sva_1(8)) AND (fsm_output(18));
        reg_data_in_rsc_rls_obj_iswt0_cse <= (count_13_3_sva_1(10)) AND (fsm_output(14));
        reg_data_in_rsc_req_obj_oswt_cse <= (fsm_output(19)) OR (fsm_output(0));
        INIT_LOOP_HLS_and_itm <= CONV_SL_1_1(INIT_LOOP_HLS_acc_8_itm=STD_LOGIC_VECTOR'("00000000"))
            AND CONV_SL_1_1(INIT_LOOP_HLS_acc_7_itm=STD_LOGIC_VECTOR'("00000000"))
            AND CONV_SL_1_1(INIT_LOOP_HLS_acc_6_itm=STD_LOGIC_VECTOR'("00000000"))
            AND CONV_SL_1_1(INIT_LOOP_HLS_acc_5_itm=STD_LOGIC_VECTOR'("00000000"))
            AND CONV_SL_1_1(INIT_LOOP_HLS_acc_4_itm=STD_LOGIC_VECTOR'("00000000"))
            AND CONV_SL_1_1(INIT_LOOP_HLS_acc_3_itm=STD_LOGIC_VECTOR'("00000000"))
            AND CONV_SL_1_1(count_13_3_sva_9_0(7 DOWNTO 0)=STD_LOGIC_VECTOR'("00000000"))
            AND CONV_SL_1_1(INIT_LOOP_HLS_acc_itm=STD_LOGIC_VECTOR'("00000000"));
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF ( (core_wen AND ((fsm_output(3)) OR (fsm_output(14)) OR (fsm_output(15))
          OR (fsm_output(1)) OR (fsm_output(18)) OR (fsm_output(16)) OR (fsm_output(2))))
          = '1' ) THEN
        count_13_3_sva_9_0 <= MUX_v_10_2_2(STD_LOGIC_VECTOR'("0000000000"), count_mux_1_nl,
            count_nand_nl);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        count_13_3_sva_1 <= STD_LOGIC_VECTOR'( "00000000000");
      ELSIF ( (core_wen AND (fsm_output(4))) = '1' ) THEN
        count_13_3_sva_1 <= z_out_4(10 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS;
  PROCESS (clk)
  BEGIN
    IF clk'EVENT AND ( clk = '1' ) THEN
      IF (rst = '1') THEN
        accum_loop_i_8_0_sva_1 <= STD_LOGIC_VECTOR'( "000000000");
      ELSIF ( (core_wen AND (fsm_output(16))) = '1' ) THEN
        accum_loop_i_8_0_sva_1 <= z_out_4(8 DOWNTO 0);
      END IF;
    END IF;
  END PROCESS;
  mux1h_nl <= MUX1HOT_v_3_6_2(STD_LOGIC_VECTOR'( "110"), STD_LOGIC_VECTOR'( "101"),
      STD_LOGIC_VECTOR'( "100"), STD_LOGIC_VECTOR'( "011"), STD_LOGIC_VECTOR'( "010"),
      STD_LOGIC_VECTOR'( "001"), STD_LOGIC_VECTOR'( (fsm_output(5)) & (fsm_output(6))
      & (fsm_output(7)) & (fsm_output(8)) & (fsm_output(9)) & (fsm_output(10))));
  data_in_or_nl <= CONV_SL_1_1(fsm_output(10 DOWNTO 4)/=STD_LOGIC_VECTOR'("0000000"));
  and_nl <= MUX_v_3_2_2(STD_LOGIC_VECTOR'("000"), mux1h_nl, data_in_or_nl);
  INIT_LOOP_HLS_mux_8_nl <= MUX_v_8_2_2(z_out_2, INIT_LOOP_HLS_acc_3_itm, fsm_output(3));
  INIT_LOOP_HLS_acc_4_nl <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(INIT_LOOP_HLS_acc_4_itm)
      + UNSIGNED'( "11111111"), 8));
  INIT_LOOP_HLS_mux_9_nl <= MUX_v_8_2_2(STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(INIT_LOOP_HLS_acc_4_nl),
      8)), INIT_LOOP_HLS_acc_4_itm, fsm_output(3));
  INIT_LOOP_HLS_mux_10_nl <= MUX_v_8_2_2(z_out_3, INIT_LOOP_HLS_acc_5_itm, fsm_output(3));
  INIT_LOOP_HLS_acc_6_nl <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(INIT_LOOP_HLS_acc_6_itm)
      + UNSIGNED'( "11111111"), 8));
  INIT_LOOP_HLS_mux_11_nl <= MUX_v_8_2_2(STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(INIT_LOOP_HLS_acc_6_nl),
      8)), INIT_LOOP_HLS_acc_6_itm, fsm_output(3));
  INIT_LOOP_HLS_mux_12_nl <= MUX_v_8_2_2(z_out, INIT_LOOP_HLS_acc_7_itm, fsm_output(3));
  INIT_LOOP_HLS_acc_8_nl <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(INIT_LOOP_HLS_acc_8_itm)
      + UNSIGNED'( "11111111"), 8));
  INIT_LOOP_HLS_mux_13_nl <= MUX_v_8_2_2(STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(INIT_LOOP_HLS_acc_8_nl),
      8)), INIT_LOOP_HLS_acc_8_itm, fsm_output(3));
  INIT_LOOP_HLS_mux_14_nl <= MUX_v_8_2_2(z_out_1, INIT_LOOP_HLS_acc_itm, fsm_output(3));
  or_89_nl <= (fsm_output(3)) OR (fsm_output(16));
  INIT_LOOP_HLS_mux1h_nl <= MUX1HOT_v_8_3_2((z_out_4(7 DOWNTO 0)), (count_13_3_sva_9_0(7
      DOWNTO 0)), (accum_loop_i_8_0_sva_1(7 DOWNTO 0)), STD_LOGIC_VECTOR'( (fsm_output(2))
      & or_89_nl & (fsm_output(18))));
  INIT_LOOP_HLS_or_1_nl <= (fsm_output(1)) OR (fsm_output(3)) OR (fsm_output(18))
      OR (fsm_output(16)) OR (fsm_output(2));
  INIT_LOOP_HLS_and_1_nl <= MUX_v_8_2_2(STD_LOGIC_VECTOR'("00000000"), INIT_LOOP_HLS_mux1h_nl,
      INIT_LOOP_HLS_or_1_nl);
  INIT_LOOP_HLS_or_nl <= MUX_v_8_2_2(INIT_LOOP_HLS_and_1_nl, STD_LOGIC_VECTOR'("11111111"),
      (fsm_output(1)));
  count_mux_1_nl <= MUX_v_10_2_2((STD_LOGIC_VECTOR'( "00") & INIT_LOOP_HLS_or_nl),
      (count_13_3_sva_1(9 DOWNTO 0)), fsm_output(14));
  count_nand_nl <= NOT(INIT_LOOP_HLS_and_itm AND (fsm_output(3)));
  accum_loop_mux_8_nl <= MUX_v_8_2_2((hist7_rsci_q_d_mxwt(7 DOWNTO 0)), INIT_LOOP_HLS_acc_7_itm,
      fsm_output(2));
  accum_loop_accum_loop_or_4_nl <= MUX_v_8_2_2((hist8_rsci_q_d_mxwt(7 DOWNTO 0)),
      STD_LOGIC_VECTOR'("11111111"), (fsm_output(2)));
  z_out <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(accum_loop_mux_8_nl) + UNSIGNED(accum_loop_accum_loop_or_4_nl),
      8));
  accum_loop_mux_9_nl <= MUX_v_8_2_2((hist1_rsci_q_d_mxwt(7 DOWNTO 0)), INIT_LOOP_HLS_acc_itm,
      fsm_output(2));
  accum_loop_accum_loop_or_5_nl <= MUX_v_8_2_2((hist2_rsci_q_d_mxwt(7 DOWNTO 0)),
      STD_LOGIC_VECTOR'("11111111"), (fsm_output(2)));
  z_out_1 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(accum_loop_mux_9_nl) + UNSIGNED(accum_loop_accum_loop_or_5_nl),
      8));
  accum_loop_mux_10_nl <= MUX_v_8_2_2((hist3_rsci_q_d_mxwt(7 DOWNTO 0)), INIT_LOOP_HLS_acc_3_itm,
      fsm_output(2));
  accum_loop_accum_loop_or_6_nl <= MUX_v_8_2_2((hist4_rsci_q_d_mxwt(7 DOWNTO 0)),
      STD_LOGIC_VECTOR'("11111111"), (fsm_output(2)));
  z_out_2 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(accum_loop_mux_10_nl) + UNSIGNED(accum_loop_accum_loop_or_6_nl),
      8));
  accum_loop_mux_11_nl <= MUX_v_8_2_2((hist5_rsci_q_d_mxwt(7 DOWNTO 0)), INIT_LOOP_HLS_acc_5_itm,
      fsm_output(2));
  accum_loop_accum_loop_or_7_nl <= MUX_v_8_2_2((hist6_rsci_q_d_mxwt(7 DOWNTO 0)),
      STD_LOGIC_VECTOR'("11111111"), (fsm_output(2)));
  z_out_3 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(accum_loop_mux_11_nl) + UNSIGNED(accum_loop_accum_loop_or_7_nl),
      8));
  INIT_LOOP_HLS_mux1h_39_nl <= MUX1HOT_v_24_9_2((STD_LOGIC_VECTOR'( "0000000000000000000000")
      & (count_13_3_sva_9_0(9 DOWNTO 8))), (hist1_rsci_q_d_mxwt(31 DOWNTO 8)), (hist2_rsci_q_d_mxwt(31
      DOWNTO 8)), (hist3_rsci_q_d_mxwt(31 DOWNTO 8)), (hist4_rsci_q_d_mxwt(31 DOWNTO
      8)), (hist5_rsci_q_d_mxwt(31 DOWNTO 8)), (hist6_rsci_q_d_mxwt(31 DOWNTO 8)),
      (hist7_rsci_q_d_mxwt(31 DOWNTO 8)), (hist8_rsci_q_d_mxwt(31 DOWNTO 8)), STD_LOGIC_VECTOR'(
      (fsm_output(4)) & (fsm_output(13)) & (fsm_output(12)) & (fsm_output(11)) &
      (fsm_output(10)) & (fsm_output(9)) & (fsm_output(8)) & (fsm_output(7)) & (fsm_output(6))));
  INIT_LOOP_HLS_nor_1_nl <= NOT((fsm_output(2)) OR (fsm_output(16)));
  INIT_LOOP_HLS_and_3_nl <= MUX_v_24_2_2(STD_LOGIC_VECTOR'("000000000000000000000000"),
      INIT_LOOP_HLS_mux1h_39_nl, INIT_LOOP_HLS_nor_1_nl);
  and_241_nl <= (fsm_output(13)) AND (NOT or_139_tmp);
  and_242_nl <= (fsm_output(12)) AND (NOT or_139_tmp);
  and_243_nl <= (fsm_output(11)) AND (NOT or_139_tmp);
  and_244_nl <= (fsm_output(10)) AND (NOT or_139_tmp);
  and_245_nl <= (fsm_output(9)) AND (NOT or_139_tmp);
  and_246_nl <= (fsm_output(8)) AND (NOT or_139_tmp);
  and_247_nl <= (fsm_output(7)) AND (NOT or_139_tmp);
  and_248_nl <= (fsm_output(6)) AND (NOT or_139_tmp);
  mux1h_2_nl <= MUX1HOT_v_8_9_2((hist1_rsci_q_d_mxwt(7 DOWNTO 0)), (hist2_rsci_q_d_mxwt(7
      DOWNTO 0)), (hist3_rsci_q_d_mxwt(7 DOWNTO 0)), (hist4_rsci_q_d_mxwt(7 DOWNTO
      0)), (hist5_rsci_q_d_mxwt(7 DOWNTO 0)), (hist6_rsci_q_d_mxwt(7 DOWNTO 0)),
      (hist7_rsci_q_d_mxwt(7 DOWNTO 0)), (hist8_rsci_q_d_mxwt(7 DOWNTO 0)), (count_13_3_sva_9_0(7
      DOWNTO 0)), STD_LOGIC_VECTOR'( and_241_nl & and_242_nl & and_243_nl & and_244_nl
      & and_245_nl & and_246_nl & and_247_nl & and_248_nl & or_139_tmp));
  z_out_4 <= STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(INIT_LOOP_HLS_and_3_nl & mux1h_2_nl)
      + CONV_UNSIGNED(CONV_SIGNED(SIGNED'( (fsm_output(2)) & '1'), 2), 32), 32));
END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls_struct
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls_struct IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_in_rsc_s_tdone : IN STD_LOGIC;
    data_in_rsc_tr_write_done : IN STD_LOGIC;
    data_in_rsc_RREADY : IN STD_LOGIC;
    data_in_rsc_RVALID : OUT STD_LOGIC;
    data_in_rsc_RUSER : OUT STD_LOGIC;
    data_in_rsc_RLAST : OUT STD_LOGIC;
    data_in_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_RDATA : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
    data_in_rsc_RID : OUT STD_LOGIC;
    data_in_rsc_ARREADY : OUT STD_LOGIC;
    data_in_rsc_ARVALID : IN STD_LOGIC;
    data_in_rsc_ARUSER : IN STD_LOGIC;
    data_in_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARLOCK : IN STD_LOGIC;
    data_in_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsc_ARADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsc_ARID : IN STD_LOGIC;
    data_in_rsc_BREADY : IN STD_LOGIC;
    data_in_rsc_BVALID : OUT STD_LOGIC;
    data_in_rsc_BUSER : OUT STD_LOGIC;
    data_in_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_BID : OUT STD_LOGIC;
    data_in_rsc_WREADY : OUT STD_LOGIC;
    data_in_rsc_WVALID : IN STD_LOGIC;
    data_in_rsc_WUSER : IN STD_LOGIC;
    data_in_rsc_WLAST : IN STD_LOGIC;
    data_in_rsc_WSTRB : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_WDATA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    data_in_rsc_AWREADY : OUT STD_LOGIC;
    data_in_rsc_AWVALID : IN STD_LOGIC;
    data_in_rsc_AWUSER : IN STD_LOGIC;
    data_in_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWLOCK : IN STD_LOGIC;
    data_in_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsc_AWADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsc_AWID : IN STD_LOGIC;
    data_in_rsc_req_vz : IN STD_LOGIC;
    data_in_rsc_rls_lz : OUT STD_LOGIC;
    hist_out_rsc_s_tdone : IN STD_LOGIC;
    hist_out_rsc_tr_write_done : IN STD_LOGIC;
    hist_out_rsc_RREADY : IN STD_LOGIC;
    hist_out_rsc_RVALID : OUT STD_LOGIC;
    hist_out_rsc_RUSER : OUT STD_LOGIC;
    hist_out_rsc_RLAST : OUT STD_LOGIC;
    hist_out_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_RDATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_RID : OUT STD_LOGIC;
    hist_out_rsc_ARREADY : OUT STD_LOGIC;
    hist_out_rsc_ARVALID : IN STD_LOGIC;
    hist_out_rsc_ARUSER : IN STD_LOGIC;
    hist_out_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARLOCK : IN STD_LOGIC;
    hist_out_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_ARADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    hist_out_rsc_ARID : IN STD_LOGIC;
    hist_out_rsc_BREADY : IN STD_LOGIC;
    hist_out_rsc_BVALID : OUT STD_LOGIC;
    hist_out_rsc_BUSER : OUT STD_LOGIC;
    hist_out_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_BID : OUT STD_LOGIC;
    hist_out_rsc_WREADY : OUT STD_LOGIC;
    hist_out_rsc_WVALID : IN STD_LOGIC;
    hist_out_rsc_WUSER : IN STD_LOGIC;
    hist_out_rsc_WLAST : IN STD_LOGIC;
    hist_out_rsc_WSTRB : IN STD_LOGIC;
    hist_out_rsc_WDATA : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_AWREADY : OUT STD_LOGIC;
    hist_out_rsc_AWVALID : IN STD_LOGIC;
    hist_out_rsc_AWUSER : IN STD_LOGIC;
    hist_out_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWLOCK : IN STD_LOGIC;
    hist_out_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_AWADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    hist_out_rsc_AWID : IN STD_LOGIC;
    hist_out_rsc_req_vz : IN STD_LOGIC;
    hist_out_rsc_rls_lz : OUT STD_LOGIC
  );
END histogram_hls_struct;

ARCHITECTURE v1 OF histogram_hls_struct IS
  -- Default Constants
  CONSTANT PWR : STD_LOGIC := '1';
  CONSTANT GND : STD_LOGIC := '0';

  -- Interconnect Declarations
  SIGNAL hist1_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsci_we_d : STD_LOGIC;
  SIGNAL hist1_rsci_re_d : STD_LOGIC;
  SIGNAL hist1_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsci_we_d : STD_LOGIC;
  SIGNAL hist2_rsci_re_d : STD_LOGIC;
  SIGNAL hist2_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsci_we_d : STD_LOGIC;
  SIGNAL hist3_rsci_re_d : STD_LOGIC;
  SIGNAL hist3_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsci_we_d : STD_LOGIC;
  SIGNAL hist4_rsci_re_d : STD_LOGIC;
  SIGNAL hist4_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsci_we_d : STD_LOGIC;
  SIGNAL hist5_rsci_re_d : STD_LOGIC;
  SIGNAL hist5_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsci_we_d : STD_LOGIC;
  SIGNAL hist6_rsci_re_d : STD_LOGIC;
  SIGNAL hist6_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsci_we_d : STD_LOGIC;
  SIGNAL hist7_rsci_re_d : STD_LOGIC;
  SIGNAL hist7_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsci_we_d : STD_LOGIC;
  SIGNAL hist8_rsci_re_d : STD_LOGIC;
  SIGNAL hist8_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsc_we : STD_LOGIC;
  SIGNAL hist1_rsc_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsc_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsc_re : STD_LOGIC;
  SIGNAL hist1_rsc_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsc_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsc_we : STD_LOGIC;
  SIGNAL hist2_rsc_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsc_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsc_re : STD_LOGIC;
  SIGNAL hist2_rsc_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsc_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsc_we : STD_LOGIC;
  SIGNAL hist3_rsc_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsc_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsc_re : STD_LOGIC;
  SIGNAL hist3_rsc_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsc_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsc_we : STD_LOGIC;
  SIGNAL hist4_rsc_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsc_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsc_re : STD_LOGIC;
  SIGNAL hist4_rsc_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsc_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsc_we : STD_LOGIC;
  SIGNAL hist5_rsc_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsc_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsc_re : STD_LOGIC;
  SIGNAL hist5_rsc_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsc_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsc_we : STD_LOGIC;
  SIGNAL hist6_rsc_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsc_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsc_re : STD_LOGIC;
  SIGNAL hist6_rsc_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsc_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsc_we : STD_LOGIC;
  SIGNAL hist7_rsc_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsc_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsc_re : STD_LOGIC;
  SIGNAL hist7_rsc_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsc_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsc_we : STD_LOGIC;
  SIGNAL hist8_rsc_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsc_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsc_re : STD_LOGIC;
  SIGNAL hist8_rsc_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsc_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);

  SIGNAL hist1_rsc_comp_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsc_comp_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsc_comp_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsc_comp_q : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL hist2_rsc_comp_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsc_comp_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsc_comp_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsc_comp_q : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL hist3_rsc_comp_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsc_comp_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsc_comp_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsc_comp_q : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL hist4_rsc_comp_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsc_comp_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsc_comp_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsc_comp_q : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL hist5_rsc_comp_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsc_comp_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsc_comp_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsc_comp_q : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL hist6_rsc_comp_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsc_comp_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsc_comp_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsc_comp_q : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL hist7_rsc_comp_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsc_comp_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsc_comp_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsc_comp_q : STD_LOGIC_VECTOR (31 DOWNTO 0);

  SIGNAL hist8_rsc_comp_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsc_comp_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsc_comp_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsc_comp_q : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_5_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL hist1_rsci_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsci_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsci_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_radr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_wadr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist1_rsci_d_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist1_rsci_q_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_6_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL hist2_rsci_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsci_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsci_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_radr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_wadr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist2_rsci_d_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist2_rsci_q_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_7_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL hist3_rsci_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsci_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsci_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_radr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_wadr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist3_rsci_d_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist3_rsci_q_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_8_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL hist4_rsci_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsci_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsci_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_radr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_wadr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist4_rsci_d_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist4_rsci_q_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_9_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL hist5_rsci_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsci_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsci_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_radr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_wadr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist5_rsci_d_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist5_rsci_q_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_10_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL hist6_rsci_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsci_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsci_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_radr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_wadr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist6_rsci_d_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist6_rsci_q_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_11_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL hist7_rsci_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsci_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsci_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_radr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_wadr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist7_rsci_d_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist7_rsci_q_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_12_gen
    PORT(
      we : OUT STD_LOGIC;
      d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      wadr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      re : OUT STD_LOGIC;
      q : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      radr : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      radr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      wadr_d : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      d_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      we_d : IN STD_LOGIC;
      re_d : IN STD_LOGIC;
      q_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL hist8_rsci_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsci_wadr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_q : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsci_radr : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_radr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_wadr_d_1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL hist8_rsci_d_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL hist8_rsci_q_d_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);

  COMPONENT histogram_hls_core
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      data_in_rsc_s_tdone : IN STD_LOGIC;
      data_in_rsc_tr_write_done : IN STD_LOGIC;
      data_in_rsc_RREADY : IN STD_LOGIC;
      data_in_rsc_RVALID : OUT STD_LOGIC;
      data_in_rsc_RUSER : OUT STD_LOGIC;
      data_in_rsc_RLAST : OUT STD_LOGIC;
      data_in_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_RDATA : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      data_in_rsc_RID : OUT STD_LOGIC;
      data_in_rsc_ARREADY : OUT STD_LOGIC;
      data_in_rsc_ARVALID : IN STD_LOGIC;
      data_in_rsc_ARUSER : IN STD_LOGIC;
      data_in_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARLOCK : IN STD_LOGIC;
      data_in_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data_in_rsc_ARADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsc_ARID : IN STD_LOGIC;
      data_in_rsc_BREADY : IN STD_LOGIC;
      data_in_rsc_BVALID : OUT STD_LOGIC;
      data_in_rsc_BUSER : OUT STD_LOGIC;
      data_in_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_BID : OUT STD_LOGIC;
      data_in_rsc_WREADY : OUT STD_LOGIC;
      data_in_rsc_WVALID : IN STD_LOGIC;
      data_in_rsc_WUSER : IN STD_LOGIC;
      data_in_rsc_WLAST : IN STD_LOGIC;
      data_in_rsc_WSTRB : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_WDATA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      data_in_rsc_AWREADY : OUT STD_LOGIC;
      data_in_rsc_AWVALID : IN STD_LOGIC;
      data_in_rsc_AWUSER : IN STD_LOGIC;
      data_in_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWLOCK : IN STD_LOGIC;
      data_in_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data_in_rsc_AWADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsc_AWID : IN STD_LOGIC;
      data_in_rsc_req_vz : IN STD_LOGIC;
      data_in_rsc_rls_lz : OUT STD_LOGIC;
      hist_out_rsc_s_tdone : IN STD_LOGIC;
      hist_out_rsc_tr_write_done : IN STD_LOGIC;
      hist_out_rsc_RREADY : IN STD_LOGIC;
      hist_out_rsc_RVALID : OUT STD_LOGIC;
      hist_out_rsc_RUSER : OUT STD_LOGIC;
      hist_out_rsc_RLAST : OUT STD_LOGIC;
      hist_out_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_RDATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_RID : OUT STD_LOGIC;
      hist_out_rsc_ARREADY : OUT STD_LOGIC;
      hist_out_rsc_ARVALID : IN STD_LOGIC;
      hist_out_rsc_ARUSER : IN STD_LOGIC;
      hist_out_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARLOCK : IN STD_LOGIC;
      hist_out_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_ARADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
      hist_out_rsc_ARID : IN STD_LOGIC;
      hist_out_rsc_BREADY : IN STD_LOGIC;
      hist_out_rsc_BVALID : OUT STD_LOGIC;
      hist_out_rsc_BUSER : OUT STD_LOGIC;
      hist_out_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_BID : OUT STD_LOGIC;
      hist_out_rsc_WREADY : OUT STD_LOGIC;
      hist_out_rsc_WVALID : IN STD_LOGIC;
      hist_out_rsc_WUSER : IN STD_LOGIC;
      hist_out_rsc_WLAST : IN STD_LOGIC;
      hist_out_rsc_WSTRB : IN STD_LOGIC;
      hist_out_rsc_WDATA : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_AWREADY : OUT STD_LOGIC;
      hist_out_rsc_AWVALID : IN STD_LOGIC;
      hist_out_rsc_AWUSER : IN STD_LOGIC;
      hist_out_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWLOCK : IN STD_LOGIC;
      hist_out_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_AWADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
      hist_out_rsc_AWID : IN STD_LOGIC;
      hist_out_rsc_req_vz : IN STD_LOGIC;
      hist_out_rsc_rls_lz : OUT STD_LOGIC;
      hist1_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist1_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist1_rsci_we_d : OUT STD_LOGIC;
      hist1_rsci_re_d : OUT STD_LOGIC;
      hist1_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist2_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist2_rsci_we_d : OUT STD_LOGIC;
      hist2_rsci_re_d : OUT STD_LOGIC;
      hist2_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist3_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist3_rsci_we_d : OUT STD_LOGIC;
      hist3_rsci_re_d : OUT STD_LOGIC;
      hist3_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist4_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist4_rsci_we_d : OUT STD_LOGIC;
      hist4_rsci_re_d : OUT STD_LOGIC;
      hist4_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist5_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist5_rsci_we_d : OUT STD_LOGIC;
      hist5_rsci_re_d : OUT STD_LOGIC;
      hist5_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist6_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist6_rsci_we_d : OUT STD_LOGIC;
      hist6_rsci_re_d : OUT STD_LOGIC;
      hist6_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist7_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist7_rsci_we_d : OUT STD_LOGIC;
      hist7_rsci_re_d : OUT STD_LOGIC;
      hist7_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_radr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_wadr_d : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist8_rsci_d_d : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      hist8_rsci_we_d : OUT STD_LOGIC;
      hist8_rsci_re_d : OUT STD_LOGIC;
      hist8_rsci_q_d : IN STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL histogram_hls_core_inst_data_in_rsc_RRESP : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_RDATA : STD_LOGIC_VECTOR (15 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_ARREGION : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_ARQOS : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_ARPROT : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_ARCACHE : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_ARBURST : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_ARSIZE : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_ARLEN : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_ARADDR : STD_LOGIC_VECTOR (12 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_BRESP : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_WSTRB : STD_LOGIC_VECTOR (1 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_WDATA : STD_LOGIC_VECTOR (15 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_AWREGION : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_AWQOS : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_AWPROT : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_AWCACHE : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_AWBURST : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_AWSIZE : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_AWLEN : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_data_in_rsc_AWADDR : STD_LOGIC_VECTOR (12 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_RRESP : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_RDATA : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_ARREGION : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_ARQOS : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_ARPROT : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_ARCACHE : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_ARBURST : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_ARSIZE : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_ARLEN : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_ARADDR : STD_LOGIC_VECTOR (11 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_BRESP : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_WDATA : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_AWREGION : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_AWQOS : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_AWPROT : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_AWCACHE : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_AWBURST : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_AWSIZE : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_AWLEN : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist_out_rsc_AWADDR : STD_LOGIC_VECTOR (11 DOWNTO
      0);
  SIGNAL histogram_hls_core_inst_hist1_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist1_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist1_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist1_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist2_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist2_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist2_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist2_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist3_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist3_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist3_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist3_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist4_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist4_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist4_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist4_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist5_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist5_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist5_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist5_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist6_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist6_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist6_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist6_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist7_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist7_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist7_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist7_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist8_rsci_radr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist8_rsci_wadr_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist8_rsci_d_d : STD_LOGIC_VECTOR (31 DOWNTO 0);
  SIGNAL histogram_hls_core_inst_hist8_rsci_q_d : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
  hist1_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 32,
      addr_width => 8,
      depth => 256
      )
    PORT MAP(
      radr => hist1_rsc_comp_radr,
      wadr => hist1_rsc_comp_wadr,
      d => hist1_rsc_comp_d,
      we => hist1_rsc_we,
      re => hist1_rsc_re,
      clk => clk,
      q => hist1_rsc_comp_q
    );
  hist1_rsc_comp_radr <= hist1_rsc_radr;
  hist1_rsc_comp_wadr <= hist1_rsc_wadr;
  hist1_rsc_comp_d <= hist1_rsc_d;
  hist1_rsc_q <= hist1_rsc_comp_q;

  hist2_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 32,
      addr_width => 8,
      depth => 256
      )
    PORT MAP(
      radr => hist2_rsc_comp_radr,
      wadr => hist2_rsc_comp_wadr,
      d => hist2_rsc_comp_d,
      we => hist2_rsc_we,
      re => hist2_rsc_re,
      clk => clk,
      q => hist2_rsc_comp_q
    );
  hist2_rsc_comp_radr <= hist2_rsc_radr;
  hist2_rsc_comp_wadr <= hist2_rsc_wadr;
  hist2_rsc_comp_d <= hist2_rsc_d;
  hist2_rsc_q <= hist2_rsc_comp_q;

  hist3_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 32,
      addr_width => 8,
      depth => 256
      )
    PORT MAP(
      radr => hist3_rsc_comp_radr,
      wadr => hist3_rsc_comp_wadr,
      d => hist3_rsc_comp_d,
      we => hist3_rsc_we,
      re => hist3_rsc_re,
      clk => clk,
      q => hist3_rsc_comp_q
    );
  hist3_rsc_comp_radr <= hist3_rsc_radr;
  hist3_rsc_comp_wadr <= hist3_rsc_wadr;
  hist3_rsc_comp_d <= hist3_rsc_d;
  hist3_rsc_q <= hist3_rsc_comp_q;

  hist4_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 32,
      addr_width => 8,
      depth => 256
      )
    PORT MAP(
      radr => hist4_rsc_comp_radr,
      wadr => hist4_rsc_comp_wadr,
      d => hist4_rsc_comp_d,
      we => hist4_rsc_we,
      re => hist4_rsc_re,
      clk => clk,
      q => hist4_rsc_comp_q
    );
  hist4_rsc_comp_radr <= hist4_rsc_radr;
  hist4_rsc_comp_wadr <= hist4_rsc_wadr;
  hist4_rsc_comp_d <= hist4_rsc_d;
  hist4_rsc_q <= hist4_rsc_comp_q;

  hist5_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 32,
      addr_width => 8,
      depth => 256
      )
    PORT MAP(
      radr => hist5_rsc_comp_radr,
      wadr => hist5_rsc_comp_wadr,
      d => hist5_rsc_comp_d,
      we => hist5_rsc_we,
      re => hist5_rsc_re,
      clk => clk,
      q => hist5_rsc_comp_q
    );
  hist5_rsc_comp_radr <= hist5_rsc_radr;
  hist5_rsc_comp_wadr <= hist5_rsc_wadr;
  hist5_rsc_comp_d <= hist5_rsc_d;
  hist5_rsc_q <= hist5_rsc_comp_q;

  hist6_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 32,
      addr_width => 8,
      depth => 256
      )
    PORT MAP(
      radr => hist6_rsc_comp_radr,
      wadr => hist6_rsc_comp_wadr,
      d => hist6_rsc_comp_d,
      we => hist6_rsc_we,
      re => hist6_rsc_re,
      clk => clk,
      q => hist6_rsc_comp_q
    );
  hist6_rsc_comp_radr <= hist6_rsc_radr;
  hist6_rsc_comp_wadr <= hist6_rsc_wadr;
  hist6_rsc_comp_d <= hist6_rsc_d;
  hist6_rsc_q <= hist6_rsc_comp_q;

  hist7_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 32,
      addr_width => 8,
      depth => 256
      )
    PORT MAP(
      radr => hist7_rsc_comp_radr,
      wadr => hist7_rsc_comp_wadr,
      d => hist7_rsc_comp_d,
      we => hist7_rsc_we,
      re => hist7_rsc_re,
      clk => clk,
      q => hist7_rsc_comp_q
    );
  hist7_rsc_comp_radr <= hist7_rsc_radr;
  hist7_rsc_comp_wadr <= hist7_rsc_wadr;
  hist7_rsc_comp_d <= hist7_rsc_d;
  hist7_rsc_q <= hist7_rsc_comp_q;

  hist8_rsc_comp : work.block_1r1w_rbw_pkg.BLOCK_1R1W_RBW
    GENERIC MAP(
      data_width => 32,
      addr_width => 8,
      depth => 256
      )
    PORT MAP(
      radr => hist8_rsc_comp_radr,
      wadr => hist8_rsc_comp_wadr,
      d => hist8_rsc_comp_d,
      we => hist8_rsc_we,
      re => hist8_rsc_re,
      clk => clk,
      q => hist8_rsc_comp_q
    );
  hist8_rsc_comp_radr <= hist8_rsc_radr;
  hist8_rsc_comp_wadr <= hist8_rsc_wadr;
  hist8_rsc_comp_d <= hist8_rsc_d;
  hist8_rsc_q <= hist8_rsc_comp_q;

  hist1_rsci : histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_5_gen
    PORT MAP(
      we => hist1_rsc_we,
      d => hist1_rsci_d,
      wadr => hist1_rsci_wadr,
      re => hist1_rsc_re,
      q => hist1_rsci_q,
      radr => hist1_rsci_radr,
      radr_d => hist1_rsci_radr_d_1,
      wadr_d => hist1_rsci_wadr_d_1,
      d_d => hist1_rsci_d_d_1,
      we_d => hist1_rsci_we_d,
      re_d => hist1_rsci_re_d,
      q_d => hist1_rsci_q_d_1
    );
  hist1_rsc_d <= hist1_rsci_d;
  hist1_rsc_wadr <= hist1_rsci_wadr;
  hist1_rsci_q <= hist1_rsc_q;
  hist1_rsc_radr <= hist1_rsci_radr;
  hist1_rsci_radr_d_1 <= hist1_rsci_radr_d;
  hist1_rsci_wadr_d_1 <= hist1_rsci_wadr_d;
  hist1_rsci_d_d_1 <= hist1_rsci_d_d;
  hist1_rsci_q_d <= hist1_rsci_q_d_1;

  hist2_rsci : histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_6_gen
    PORT MAP(
      we => hist2_rsc_we,
      d => hist2_rsci_d,
      wadr => hist2_rsci_wadr,
      re => hist2_rsc_re,
      q => hist2_rsci_q,
      radr => hist2_rsci_radr,
      radr_d => hist2_rsci_radr_d_1,
      wadr_d => hist2_rsci_wadr_d_1,
      d_d => hist2_rsci_d_d_1,
      we_d => hist2_rsci_we_d,
      re_d => hist2_rsci_re_d,
      q_d => hist2_rsci_q_d_1
    );
  hist2_rsc_d <= hist2_rsci_d;
  hist2_rsc_wadr <= hist2_rsci_wadr;
  hist2_rsci_q <= hist2_rsc_q;
  hist2_rsc_radr <= hist2_rsci_radr;
  hist2_rsci_radr_d_1 <= hist2_rsci_radr_d;
  hist2_rsci_wadr_d_1 <= hist2_rsci_wadr_d;
  hist2_rsci_d_d_1 <= hist2_rsci_d_d;
  hist2_rsci_q_d <= hist2_rsci_q_d_1;

  hist3_rsci : histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_7_gen
    PORT MAP(
      we => hist3_rsc_we,
      d => hist3_rsci_d,
      wadr => hist3_rsci_wadr,
      re => hist3_rsc_re,
      q => hist3_rsci_q,
      radr => hist3_rsci_radr,
      radr_d => hist3_rsci_radr_d_1,
      wadr_d => hist3_rsci_wadr_d_1,
      d_d => hist3_rsci_d_d_1,
      we_d => hist3_rsci_we_d,
      re_d => hist3_rsci_re_d,
      q_d => hist3_rsci_q_d_1
    );
  hist3_rsc_d <= hist3_rsci_d;
  hist3_rsc_wadr <= hist3_rsci_wadr;
  hist3_rsci_q <= hist3_rsc_q;
  hist3_rsc_radr <= hist3_rsci_radr;
  hist3_rsci_radr_d_1 <= hist3_rsci_radr_d;
  hist3_rsci_wadr_d_1 <= hist3_rsci_wadr_d;
  hist3_rsci_d_d_1 <= hist3_rsci_d_d;
  hist3_rsci_q_d <= hist3_rsci_q_d_1;

  hist4_rsci : histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_8_gen
    PORT MAP(
      we => hist4_rsc_we,
      d => hist4_rsci_d,
      wadr => hist4_rsci_wadr,
      re => hist4_rsc_re,
      q => hist4_rsci_q,
      radr => hist4_rsci_radr,
      radr_d => hist4_rsci_radr_d_1,
      wadr_d => hist4_rsci_wadr_d_1,
      d_d => hist4_rsci_d_d_1,
      we_d => hist4_rsci_we_d,
      re_d => hist4_rsci_re_d,
      q_d => hist4_rsci_q_d_1
    );
  hist4_rsc_d <= hist4_rsci_d;
  hist4_rsc_wadr <= hist4_rsci_wadr;
  hist4_rsci_q <= hist4_rsc_q;
  hist4_rsc_radr <= hist4_rsci_radr;
  hist4_rsci_radr_d_1 <= hist4_rsci_radr_d;
  hist4_rsci_wadr_d_1 <= hist4_rsci_wadr_d;
  hist4_rsci_d_d_1 <= hist4_rsci_d_d;
  hist4_rsci_q_d <= hist4_rsci_q_d_1;

  hist5_rsci : histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_9_gen
    PORT MAP(
      we => hist5_rsc_we,
      d => hist5_rsci_d,
      wadr => hist5_rsci_wadr,
      re => hist5_rsc_re,
      q => hist5_rsci_q,
      radr => hist5_rsci_radr,
      radr_d => hist5_rsci_radr_d_1,
      wadr_d => hist5_rsci_wadr_d_1,
      d_d => hist5_rsci_d_d_1,
      we_d => hist5_rsci_we_d,
      re_d => hist5_rsci_re_d,
      q_d => hist5_rsci_q_d_1
    );
  hist5_rsc_d <= hist5_rsci_d;
  hist5_rsc_wadr <= hist5_rsci_wadr;
  hist5_rsci_q <= hist5_rsc_q;
  hist5_rsc_radr <= hist5_rsci_radr;
  hist5_rsci_radr_d_1 <= hist5_rsci_radr_d;
  hist5_rsci_wadr_d_1 <= hist5_rsci_wadr_d;
  hist5_rsci_d_d_1 <= hist5_rsci_d_d;
  hist5_rsci_q_d <= hist5_rsci_q_d_1;

  hist6_rsci : histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_10_gen
    PORT MAP(
      we => hist6_rsc_we,
      d => hist6_rsci_d,
      wadr => hist6_rsci_wadr,
      re => hist6_rsc_re,
      q => hist6_rsci_q,
      radr => hist6_rsci_radr,
      radr_d => hist6_rsci_radr_d_1,
      wadr_d => hist6_rsci_wadr_d_1,
      d_d => hist6_rsci_d_d_1,
      we_d => hist6_rsci_we_d,
      re_d => hist6_rsci_re_d,
      q_d => hist6_rsci_q_d_1
    );
  hist6_rsc_d <= hist6_rsci_d;
  hist6_rsc_wadr <= hist6_rsci_wadr;
  hist6_rsci_q <= hist6_rsc_q;
  hist6_rsc_radr <= hist6_rsci_radr;
  hist6_rsci_radr_d_1 <= hist6_rsci_radr_d;
  hist6_rsci_wadr_d_1 <= hist6_rsci_wadr_d;
  hist6_rsci_d_d_1 <= hist6_rsci_d_d;
  hist6_rsci_q_d <= hist6_rsci_q_d_1;

  hist7_rsci : histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_11_gen
    PORT MAP(
      we => hist7_rsc_we,
      d => hist7_rsci_d,
      wadr => hist7_rsci_wadr,
      re => hist7_rsc_re,
      q => hist7_rsci_q,
      radr => hist7_rsci_radr,
      radr_d => hist7_rsci_radr_d_1,
      wadr_d => hist7_rsci_wadr_d_1,
      d_d => hist7_rsci_d_d_1,
      we_d => hist7_rsci_we_d,
      re_d => hist7_rsci_re_d,
      q_d => hist7_rsci_q_d_1
    );
  hist7_rsc_d <= hist7_rsci_d;
  hist7_rsc_wadr <= hist7_rsci_wadr;
  hist7_rsci_q <= hist7_rsc_q;
  hist7_rsc_radr <= hist7_rsci_radr;
  hist7_rsci_radr_d_1 <= hist7_rsci_radr_d;
  hist7_rsci_wadr_d_1 <= hist7_rsci_wadr_d;
  hist7_rsci_d_d_1 <= hist7_rsci_d_d;
  hist7_rsci_q_d <= hist7_rsci_q_d_1;

  hist8_rsci : histogram_hls_Xilinx_RAMS_BLOCK_1R1W_RBW_rwport_32_8_256_12_gen
    PORT MAP(
      we => hist8_rsc_we,
      d => hist8_rsci_d,
      wadr => hist8_rsci_wadr,
      re => hist8_rsc_re,
      q => hist8_rsci_q,
      radr => hist8_rsci_radr,
      radr_d => hist8_rsci_radr_d_1,
      wadr_d => hist8_rsci_wadr_d_1,
      d_d => hist8_rsci_d_d_1,
      we_d => hist8_rsci_we_d,
      re_d => hist8_rsci_re_d,
      q_d => hist8_rsci_q_d_1
    );
  hist8_rsc_d <= hist8_rsci_d;
  hist8_rsc_wadr <= hist8_rsci_wadr;
  hist8_rsci_q <= hist8_rsc_q;
  hist8_rsc_radr <= hist8_rsci_radr;
  hist8_rsci_radr_d_1 <= hist8_rsci_radr_d;
  hist8_rsci_wadr_d_1 <= hist8_rsci_wadr_d;
  hist8_rsci_d_d_1 <= hist8_rsci_d_d;
  hist8_rsci_q_d <= hist8_rsci_q_d_1;

  histogram_hls_core_inst : histogram_hls_core
    PORT MAP(
      clk => clk,
      rst => rst,
      data_in_rsc_s_tdone => data_in_rsc_s_tdone,
      data_in_rsc_tr_write_done => data_in_rsc_tr_write_done,
      data_in_rsc_RREADY => data_in_rsc_RREADY,
      data_in_rsc_RVALID => data_in_rsc_RVALID,
      data_in_rsc_RUSER => data_in_rsc_RUSER,
      data_in_rsc_RLAST => data_in_rsc_RLAST,
      data_in_rsc_RRESP => histogram_hls_core_inst_data_in_rsc_RRESP,
      data_in_rsc_RDATA => histogram_hls_core_inst_data_in_rsc_RDATA,
      data_in_rsc_RID => data_in_rsc_RID,
      data_in_rsc_ARREADY => data_in_rsc_ARREADY,
      data_in_rsc_ARVALID => data_in_rsc_ARVALID,
      data_in_rsc_ARUSER => data_in_rsc_ARUSER,
      data_in_rsc_ARREGION => histogram_hls_core_inst_data_in_rsc_ARREGION,
      data_in_rsc_ARQOS => histogram_hls_core_inst_data_in_rsc_ARQOS,
      data_in_rsc_ARPROT => histogram_hls_core_inst_data_in_rsc_ARPROT,
      data_in_rsc_ARCACHE => histogram_hls_core_inst_data_in_rsc_ARCACHE,
      data_in_rsc_ARLOCK => data_in_rsc_ARLOCK,
      data_in_rsc_ARBURST => histogram_hls_core_inst_data_in_rsc_ARBURST,
      data_in_rsc_ARSIZE => histogram_hls_core_inst_data_in_rsc_ARSIZE,
      data_in_rsc_ARLEN => histogram_hls_core_inst_data_in_rsc_ARLEN,
      data_in_rsc_ARADDR => histogram_hls_core_inst_data_in_rsc_ARADDR,
      data_in_rsc_ARID => data_in_rsc_ARID,
      data_in_rsc_BREADY => data_in_rsc_BREADY,
      data_in_rsc_BVALID => data_in_rsc_BVALID,
      data_in_rsc_BUSER => data_in_rsc_BUSER,
      data_in_rsc_BRESP => histogram_hls_core_inst_data_in_rsc_BRESP,
      data_in_rsc_BID => data_in_rsc_BID,
      data_in_rsc_WREADY => data_in_rsc_WREADY,
      data_in_rsc_WVALID => data_in_rsc_WVALID,
      data_in_rsc_WUSER => data_in_rsc_WUSER,
      data_in_rsc_WLAST => data_in_rsc_WLAST,
      data_in_rsc_WSTRB => histogram_hls_core_inst_data_in_rsc_WSTRB,
      data_in_rsc_WDATA => histogram_hls_core_inst_data_in_rsc_WDATA,
      data_in_rsc_AWREADY => data_in_rsc_AWREADY,
      data_in_rsc_AWVALID => data_in_rsc_AWVALID,
      data_in_rsc_AWUSER => data_in_rsc_AWUSER,
      data_in_rsc_AWREGION => histogram_hls_core_inst_data_in_rsc_AWREGION,
      data_in_rsc_AWQOS => histogram_hls_core_inst_data_in_rsc_AWQOS,
      data_in_rsc_AWPROT => histogram_hls_core_inst_data_in_rsc_AWPROT,
      data_in_rsc_AWCACHE => histogram_hls_core_inst_data_in_rsc_AWCACHE,
      data_in_rsc_AWLOCK => data_in_rsc_AWLOCK,
      data_in_rsc_AWBURST => histogram_hls_core_inst_data_in_rsc_AWBURST,
      data_in_rsc_AWSIZE => histogram_hls_core_inst_data_in_rsc_AWSIZE,
      data_in_rsc_AWLEN => histogram_hls_core_inst_data_in_rsc_AWLEN,
      data_in_rsc_AWADDR => histogram_hls_core_inst_data_in_rsc_AWADDR,
      data_in_rsc_AWID => data_in_rsc_AWID,
      data_in_rsc_req_vz => data_in_rsc_req_vz,
      data_in_rsc_rls_lz => data_in_rsc_rls_lz,
      hist_out_rsc_s_tdone => hist_out_rsc_s_tdone,
      hist_out_rsc_tr_write_done => hist_out_rsc_tr_write_done,
      hist_out_rsc_RREADY => hist_out_rsc_RREADY,
      hist_out_rsc_RVALID => hist_out_rsc_RVALID,
      hist_out_rsc_RUSER => hist_out_rsc_RUSER,
      hist_out_rsc_RLAST => hist_out_rsc_RLAST,
      hist_out_rsc_RRESP => histogram_hls_core_inst_hist_out_rsc_RRESP,
      hist_out_rsc_RDATA => histogram_hls_core_inst_hist_out_rsc_RDATA,
      hist_out_rsc_RID => hist_out_rsc_RID,
      hist_out_rsc_ARREADY => hist_out_rsc_ARREADY,
      hist_out_rsc_ARVALID => hist_out_rsc_ARVALID,
      hist_out_rsc_ARUSER => hist_out_rsc_ARUSER,
      hist_out_rsc_ARREGION => histogram_hls_core_inst_hist_out_rsc_ARREGION,
      hist_out_rsc_ARQOS => histogram_hls_core_inst_hist_out_rsc_ARQOS,
      hist_out_rsc_ARPROT => histogram_hls_core_inst_hist_out_rsc_ARPROT,
      hist_out_rsc_ARCACHE => histogram_hls_core_inst_hist_out_rsc_ARCACHE,
      hist_out_rsc_ARLOCK => hist_out_rsc_ARLOCK,
      hist_out_rsc_ARBURST => histogram_hls_core_inst_hist_out_rsc_ARBURST,
      hist_out_rsc_ARSIZE => histogram_hls_core_inst_hist_out_rsc_ARSIZE,
      hist_out_rsc_ARLEN => histogram_hls_core_inst_hist_out_rsc_ARLEN,
      hist_out_rsc_ARADDR => histogram_hls_core_inst_hist_out_rsc_ARADDR,
      hist_out_rsc_ARID => hist_out_rsc_ARID,
      hist_out_rsc_BREADY => hist_out_rsc_BREADY,
      hist_out_rsc_BVALID => hist_out_rsc_BVALID,
      hist_out_rsc_BUSER => hist_out_rsc_BUSER,
      hist_out_rsc_BRESP => histogram_hls_core_inst_hist_out_rsc_BRESP,
      hist_out_rsc_BID => hist_out_rsc_BID,
      hist_out_rsc_WREADY => hist_out_rsc_WREADY,
      hist_out_rsc_WVALID => hist_out_rsc_WVALID,
      hist_out_rsc_WUSER => hist_out_rsc_WUSER,
      hist_out_rsc_WLAST => hist_out_rsc_WLAST,
      hist_out_rsc_WSTRB => hist_out_rsc_WSTRB,
      hist_out_rsc_WDATA => histogram_hls_core_inst_hist_out_rsc_WDATA,
      hist_out_rsc_AWREADY => hist_out_rsc_AWREADY,
      hist_out_rsc_AWVALID => hist_out_rsc_AWVALID,
      hist_out_rsc_AWUSER => hist_out_rsc_AWUSER,
      hist_out_rsc_AWREGION => histogram_hls_core_inst_hist_out_rsc_AWREGION,
      hist_out_rsc_AWQOS => histogram_hls_core_inst_hist_out_rsc_AWQOS,
      hist_out_rsc_AWPROT => histogram_hls_core_inst_hist_out_rsc_AWPROT,
      hist_out_rsc_AWCACHE => histogram_hls_core_inst_hist_out_rsc_AWCACHE,
      hist_out_rsc_AWLOCK => hist_out_rsc_AWLOCK,
      hist_out_rsc_AWBURST => histogram_hls_core_inst_hist_out_rsc_AWBURST,
      hist_out_rsc_AWSIZE => histogram_hls_core_inst_hist_out_rsc_AWSIZE,
      hist_out_rsc_AWLEN => histogram_hls_core_inst_hist_out_rsc_AWLEN,
      hist_out_rsc_AWADDR => histogram_hls_core_inst_hist_out_rsc_AWADDR,
      hist_out_rsc_AWID => hist_out_rsc_AWID,
      hist_out_rsc_req_vz => hist_out_rsc_req_vz,
      hist_out_rsc_rls_lz => hist_out_rsc_rls_lz,
      hist1_rsci_radr_d => histogram_hls_core_inst_hist1_rsci_radr_d,
      hist1_rsci_wadr_d => histogram_hls_core_inst_hist1_rsci_wadr_d,
      hist1_rsci_d_d => histogram_hls_core_inst_hist1_rsci_d_d,
      hist1_rsci_we_d => hist1_rsci_we_d,
      hist1_rsci_re_d => hist1_rsci_re_d,
      hist1_rsci_q_d => histogram_hls_core_inst_hist1_rsci_q_d,
      hist2_rsci_radr_d => histogram_hls_core_inst_hist2_rsci_radr_d,
      hist2_rsci_wadr_d => histogram_hls_core_inst_hist2_rsci_wadr_d,
      hist2_rsci_d_d => histogram_hls_core_inst_hist2_rsci_d_d,
      hist2_rsci_we_d => hist2_rsci_we_d,
      hist2_rsci_re_d => hist2_rsci_re_d,
      hist2_rsci_q_d => histogram_hls_core_inst_hist2_rsci_q_d,
      hist3_rsci_radr_d => histogram_hls_core_inst_hist3_rsci_radr_d,
      hist3_rsci_wadr_d => histogram_hls_core_inst_hist3_rsci_wadr_d,
      hist3_rsci_d_d => histogram_hls_core_inst_hist3_rsci_d_d,
      hist3_rsci_we_d => hist3_rsci_we_d,
      hist3_rsci_re_d => hist3_rsci_re_d,
      hist3_rsci_q_d => histogram_hls_core_inst_hist3_rsci_q_d,
      hist4_rsci_radr_d => histogram_hls_core_inst_hist4_rsci_radr_d,
      hist4_rsci_wadr_d => histogram_hls_core_inst_hist4_rsci_wadr_d,
      hist4_rsci_d_d => histogram_hls_core_inst_hist4_rsci_d_d,
      hist4_rsci_we_d => hist4_rsci_we_d,
      hist4_rsci_re_d => hist4_rsci_re_d,
      hist4_rsci_q_d => histogram_hls_core_inst_hist4_rsci_q_d,
      hist5_rsci_radr_d => histogram_hls_core_inst_hist5_rsci_radr_d,
      hist5_rsci_wadr_d => histogram_hls_core_inst_hist5_rsci_wadr_d,
      hist5_rsci_d_d => histogram_hls_core_inst_hist5_rsci_d_d,
      hist5_rsci_we_d => hist5_rsci_we_d,
      hist5_rsci_re_d => hist5_rsci_re_d,
      hist5_rsci_q_d => histogram_hls_core_inst_hist5_rsci_q_d,
      hist6_rsci_radr_d => histogram_hls_core_inst_hist6_rsci_radr_d,
      hist6_rsci_wadr_d => histogram_hls_core_inst_hist6_rsci_wadr_d,
      hist6_rsci_d_d => histogram_hls_core_inst_hist6_rsci_d_d,
      hist6_rsci_we_d => hist6_rsci_we_d,
      hist6_rsci_re_d => hist6_rsci_re_d,
      hist6_rsci_q_d => histogram_hls_core_inst_hist6_rsci_q_d,
      hist7_rsci_radr_d => histogram_hls_core_inst_hist7_rsci_radr_d,
      hist7_rsci_wadr_d => histogram_hls_core_inst_hist7_rsci_wadr_d,
      hist7_rsci_d_d => histogram_hls_core_inst_hist7_rsci_d_d,
      hist7_rsci_we_d => hist7_rsci_we_d,
      hist7_rsci_re_d => hist7_rsci_re_d,
      hist7_rsci_q_d => histogram_hls_core_inst_hist7_rsci_q_d,
      hist8_rsci_radr_d => histogram_hls_core_inst_hist8_rsci_radr_d,
      hist8_rsci_wadr_d => histogram_hls_core_inst_hist8_rsci_wadr_d,
      hist8_rsci_d_d => histogram_hls_core_inst_hist8_rsci_d_d,
      hist8_rsci_we_d => hist8_rsci_we_d,
      hist8_rsci_re_d => hist8_rsci_re_d,
      hist8_rsci_q_d => histogram_hls_core_inst_hist8_rsci_q_d
    );
  data_in_rsc_RRESP <= histogram_hls_core_inst_data_in_rsc_RRESP;
  data_in_rsc_RDATA <= histogram_hls_core_inst_data_in_rsc_RDATA;
  histogram_hls_core_inst_data_in_rsc_ARREGION <= data_in_rsc_ARREGION;
  histogram_hls_core_inst_data_in_rsc_ARQOS <= data_in_rsc_ARQOS;
  histogram_hls_core_inst_data_in_rsc_ARPROT <= data_in_rsc_ARPROT;
  histogram_hls_core_inst_data_in_rsc_ARCACHE <= data_in_rsc_ARCACHE;
  histogram_hls_core_inst_data_in_rsc_ARBURST <= data_in_rsc_ARBURST;
  histogram_hls_core_inst_data_in_rsc_ARSIZE <= data_in_rsc_ARSIZE;
  histogram_hls_core_inst_data_in_rsc_ARLEN <= data_in_rsc_ARLEN;
  histogram_hls_core_inst_data_in_rsc_ARADDR <= data_in_rsc_ARADDR;
  data_in_rsc_BRESP <= histogram_hls_core_inst_data_in_rsc_BRESP;
  histogram_hls_core_inst_data_in_rsc_WSTRB <= data_in_rsc_WSTRB;
  histogram_hls_core_inst_data_in_rsc_WDATA <= data_in_rsc_WDATA;
  histogram_hls_core_inst_data_in_rsc_AWREGION <= data_in_rsc_AWREGION;
  histogram_hls_core_inst_data_in_rsc_AWQOS <= data_in_rsc_AWQOS;
  histogram_hls_core_inst_data_in_rsc_AWPROT <= data_in_rsc_AWPROT;
  histogram_hls_core_inst_data_in_rsc_AWCACHE <= data_in_rsc_AWCACHE;
  histogram_hls_core_inst_data_in_rsc_AWBURST <= data_in_rsc_AWBURST;
  histogram_hls_core_inst_data_in_rsc_AWSIZE <= data_in_rsc_AWSIZE;
  histogram_hls_core_inst_data_in_rsc_AWLEN <= data_in_rsc_AWLEN;
  histogram_hls_core_inst_data_in_rsc_AWADDR <= data_in_rsc_AWADDR;
  hist_out_rsc_RRESP <= histogram_hls_core_inst_hist_out_rsc_RRESP;
  hist_out_rsc_RDATA <= histogram_hls_core_inst_hist_out_rsc_RDATA;
  histogram_hls_core_inst_hist_out_rsc_ARREGION <= hist_out_rsc_ARREGION;
  histogram_hls_core_inst_hist_out_rsc_ARQOS <= hist_out_rsc_ARQOS;
  histogram_hls_core_inst_hist_out_rsc_ARPROT <= hist_out_rsc_ARPROT;
  histogram_hls_core_inst_hist_out_rsc_ARCACHE <= hist_out_rsc_ARCACHE;
  histogram_hls_core_inst_hist_out_rsc_ARBURST <= hist_out_rsc_ARBURST;
  histogram_hls_core_inst_hist_out_rsc_ARSIZE <= hist_out_rsc_ARSIZE;
  histogram_hls_core_inst_hist_out_rsc_ARLEN <= hist_out_rsc_ARLEN;
  histogram_hls_core_inst_hist_out_rsc_ARADDR <= hist_out_rsc_ARADDR;
  hist_out_rsc_BRESP <= histogram_hls_core_inst_hist_out_rsc_BRESP;
  histogram_hls_core_inst_hist_out_rsc_WDATA <= hist_out_rsc_WDATA;
  histogram_hls_core_inst_hist_out_rsc_AWREGION <= hist_out_rsc_AWREGION;
  histogram_hls_core_inst_hist_out_rsc_AWQOS <= hist_out_rsc_AWQOS;
  histogram_hls_core_inst_hist_out_rsc_AWPROT <= hist_out_rsc_AWPROT;
  histogram_hls_core_inst_hist_out_rsc_AWCACHE <= hist_out_rsc_AWCACHE;
  histogram_hls_core_inst_hist_out_rsc_AWBURST <= hist_out_rsc_AWBURST;
  histogram_hls_core_inst_hist_out_rsc_AWSIZE <= hist_out_rsc_AWSIZE;
  histogram_hls_core_inst_hist_out_rsc_AWLEN <= hist_out_rsc_AWLEN;
  histogram_hls_core_inst_hist_out_rsc_AWADDR <= hist_out_rsc_AWADDR;
  hist1_rsci_radr_d <= histogram_hls_core_inst_hist1_rsci_radr_d;
  hist1_rsci_wadr_d <= histogram_hls_core_inst_hist1_rsci_wadr_d;
  hist1_rsci_d_d <= histogram_hls_core_inst_hist1_rsci_d_d;
  histogram_hls_core_inst_hist1_rsci_q_d <= hist1_rsci_q_d;
  hist2_rsci_radr_d <= histogram_hls_core_inst_hist2_rsci_radr_d;
  hist2_rsci_wadr_d <= histogram_hls_core_inst_hist2_rsci_wadr_d;
  hist2_rsci_d_d <= histogram_hls_core_inst_hist2_rsci_d_d;
  histogram_hls_core_inst_hist2_rsci_q_d <= hist2_rsci_q_d;
  hist3_rsci_radr_d <= histogram_hls_core_inst_hist3_rsci_radr_d;
  hist3_rsci_wadr_d <= histogram_hls_core_inst_hist3_rsci_wadr_d;
  hist3_rsci_d_d <= histogram_hls_core_inst_hist3_rsci_d_d;
  histogram_hls_core_inst_hist3_rsci_q_d <= hist3_rsci_q_d;
  hist4_rsci_radr_d <= histogram_hls_core_inst_hist4_rsci_radr_d;
  hist4_rsci_wadr_d <= histogram_hls_core_inst_hist4_rsci_wadr_d;
  hist4_rsci_d_d <= histogram_hls_core_inst_hist4_rsci_d_d;
  histogram_hls_core_inst_hist4_rsci_q_d <= hist4_rsci_q_d;
  hist5_rsci_radr_d <= histogram_hls_core_inst_hist5_rsci_radr_d;
  hist5_rsci_wadr_d <= histogram_hls_core_inst_hist5_rsci_wadr_d;
  hist5_rsci_d_d <= histogram_hls_core_inst_hist5_rsci_d_d;
  histogram_hls_core_inst_hist5_rsci_q_d <= hist5_rsci_q_d;
  hist6_rsci_radr_d <= histogram_hls_core_inst_hist6_rsci_radr_d;
  hist6_rsci_wadr_d <= histogram_hls_core_inst_hist6_rsci_wadr_d;
  hist6_rsci_d_d <= histogram_hls_core_inst_hist6_rsci_d_d;
  histogram_hls_core_inst_hist6_rsci_q_d <= hist6_rsci_q_d;
  hist7_rsci_radr_d <= histogram_hls_core_inst_hist7_rsci_radr_d;
  hist7_rsci_wadr_d <= histogram_hls_core_inst_hist7_rsci_wadr_d;
  hist7_rsci_d_d <= histogram_hls_core_inst_hist7_rsci_d_d;
  histogram_hls_core_inst_hist7_rsci_q_d <= hist7_rsci_q_d;
  hist8_rsci_radr_d <= histogram_hls_core_inst_hist8_rsci_radr_d;
  hist8_rsci_wadr_d <= histogram_hls_core_inst_hist8_rsci_wadr_d;
  hist8_rsci_d_d <= histogram_hls_core_inst_hist8_rsci_d_d;
  histogram_hls_core_inst_hist8_rsci_q_d <= hist8_rsci_q_d;

END v1;

-- ------------------------------------------------------------------
--  Design Unit:    histogram_hls
-- ------------------------------------------------------------------

LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.amba_comps.ALL;

USE work.mgc_io_sync_pkg_v2.ALL;
USE work.mgc_in_sync_pkg_v2.ALL;
USE work.BLOCK_1R1W_RBW_pkg.ALL;


ENTITY histogram_hls IS
  PORT(
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    data_in_rsc_s_tdone : IN STD_LOGIC;
    data_in_rsc_tr_write_done : IN STD_LOGIC;
    data_in_rsc_RREADY : IN STD_LOGIC;
    data_in_rsc_RVALID : OUT STD_LOGIC;
    data_in_rsc_RUSER : OUT STD_LOGIC;
    data_in_rsc_RLAST : OUT STD_LOGIC;
    data_in_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_RDATA : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
    data_in_rsc_RID : OUT STD_LOGIC;
    data_in_rsc_ARREADY : OUT STD_LOGIC;
    data_in_rsc_ARVALID : IN STD_LOGIC;
    data_in_rsc_ARUSER : IN STD_LOGIC;
    data_in_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_ARLOCK : IN STD_LOGIC;
    data_in_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsc_ARADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsc_ARID : IN STD_LOGIC;
    data_in_rsc_BREADY : IN STD_LOGIC;
    data_in_rsc_BVALID : OUT STD_LOGIC;
    data_in_rsc_BUSER : OUT STD_LOGIC;
    data_in_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_BID : OUT STD_LOGIC;
    data_in_rsc_WREADY : OUT STD_LOGIC;
    data_in_rsc_WVALID : IN STD_LOGIC;
    data_in_rsc_WUSER : IN STD_LOGIC;
    data_in_rsc_WLAST : IN STD_LOGIC;
    data_in_rsc_WSTRB : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_WDATA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
    data_in_rsc_AWREADY : OUT STD_LOGIC;
    data_in_rsc_AWVALID : IN STD_LOGIC;
    data_in_rsc_AWUSER : IN STD_LOGIC;
    data_in_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    data_in_rsc_AWLOCK : IN STD_LOGIC;
    data_in_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    data_in_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    data_in_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    data_in_rsc_AWADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
    data_in_rsc_AWID : IN STD_LOGIC;
    data_in_rsc_req_vz : IN STD_LOGIC;
    data_in_rsc_rls_lz : OUT STD_LOGIC;
    hist_out_rsc_s_tdone : IN STD_LOGIC;
    hist_out_rsc_tr_write_done : IN STD_LOGIC;
    hist_out_rsc_RREADY : IN STD_LOGIC;
    hist_out_rsc_RVALID : OUT STD_LOGIC;
    hist_out_rsc_RUSER : OUT STD_LOGIC;
    hist_out_rsc_RLAST : OUT STD_LOGIC;
    hist_out_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_RDATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_RID : OUT STD_LOGIC;
    hist_out_rsc_ARREADY : OUT STD_LOGIC;
    hist_out_rsc_ARVALID : IN STD_LOGIC;
    hist_out_rsc_ARUSER : IN STD_LOGIC;
    hist_out_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_ARLOCK : IN STD_LOGIC;
    hist_out_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_ARADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    hist_out_rsc_ARID : IN STD_LOGIC;
    hist_out_rsc_BREADY : IN STD_LOGIC;
    hist_out_rsc_BVALID : OUT STD_LOGIC;
    hist_out_rsc_BUSER : OUT STD_LOGIC;
    hist_out_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_BID : OUT STD_LOGIC;
    hist_out_rsc_WREADY : OUT STD_LOGIC;
    hist_out_rsc_WVALID : IN STD_LOGIC;
    hist_out_rsc_WUSER : IN STD_LOGIC;
    hist_out_rsc_WLAST : IN STD_LOGIC;
    hist_out_rsc_WSTRB : IN STD_LOGIC;
    hist_out_rsc_WDATA : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_AWREADY : OUT STD_LOGIC;
    hist_out_rsc_AWVALID : IN STD_LOGIC;
    hist_out_rsc_AWUSER : IN STD_LOGIC;
    hist_out_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    hist_out_rsc_AWLOCK : IN STD_LOGIC;
    hist_out_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
    hist_out_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    hist_out_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    hist_out_rsc_AWADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    hist_out_rsc_AWID : IN STD_LOGIC;
    hist_out_rsc_req_vz : IN STD_LOGIC;
    hist_out_rsc_rls_lz : OUT STD_LOGIC
  );
END histogram_hls;

ARCHITECTURE v1 OF histogram_hls IS
  -- Default Constants
  CONSTANT PWR : STD_LOGIC := '1';
  CONSTANT GND : STD_LOGIC := '0';

  COMPONENT histogram_hls_struct
    PORT(
      clk : IN STD_LOGIC;
      rst : IN STD_LOGIC;
      data_in_rsc_s_tdone : IN STD_LOGIC;
      data_in_rsc_tr_write_done : IN STD_LOGIC;
      data_in_rsc_RREADY : IN STD_LOGIC;
      data_in_rsc_RVALID : OUT STD_LOGIC;
      data_in_rsc_RUSER : OUT STD_LOGIC;
      data_in_rsc_RLAST : OUT STD_LOGIC;
      data_in_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_RDATA : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
      data_in_rsc_RID : OUT STD_LOGIC;
      data_in_rsc_ARREADY : OUT STD_LOGIC;
      data_in_rsc_ARVALID : IN STD_LOGIC;
      data_in_rsc_ARUSER : IN STD_LOGIC;
      data_in_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_ARLOCK : IN STD_LOGIC;
      data_in_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data_in_rsc_ARADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsc_ARID : IN STD_LOGIC;
      data_in_rsc_BREADY : IN STD_LOGIC;
      data_in_rsc_BVALID : OUT STD_LOGIC;
      data_in_rsc_BUSER : OUT STD_LOGIC;
      data_in_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_BID : OUT STD_LOGIC;
      data_in_rsc_WREADY : OUT STD_LOGIC;
      data_in_rsc_WVALID : IN STD_LOGIC;
      data_in_rsc_WUSER : IN STD_LOGIC;
      data_in_rsc_WLAST : IN STD_LOGIC;
      data_in_rsc_WSTRB : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_WDATA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
      data_in_rsc_AWREADY : OUT STD_LOGIC;
      data_in_rsc_AWVALID : IN STD_LOGIC;
      data_in_rsc_AWUSER : IN STD_LOGIC;
      data_in_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      data_in_rsc_AWLOCK : IN STD_LOGIC;
      data_in_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      data_in_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      data_in_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      data_in_rsc_AWADDR : IN STD_LOGIC_VECTOR (12 DOWNTO 0);
      data_in_rsc_AWID : IN STD_LOGIC;
      data_in_rsc_req_vz : IN STD_LOGIC;
      data_in_rsc_rls_lz : OUT STD_LOGIC;
      hist_out_rsc_s_tdone : IN STD_LOGIC;
      hist_out_rsc_tr_write_done : IN STD_LOGIC;
      hist_out_rsc_RREADY : IN STD_LOGIC;
      hist_out_rsc_RVALID : OUT STD_LOGIC;
      hist_out_rsc_RUSER : OUT STD_LOGIC;
      hist_out_rsc_RLAST : OUT STD_LOGIC;
      hist_out_rsc_RRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_RDATA : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_RID : OUT STD_LOGIC;
      hist_out_rsc_ARREADY : OUT STD_LOGIC;
      hist_out_rsc_ARVALID : IN STD_LOGIC;
      hist_out_rsc_ARUSER : IN STD_LOGIC;
      hist_out_rsc_ARREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_ARCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_ARLOCK : IN STD_LOGIC;
      hist_out_rsc_ARBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_ARSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_ARLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_ARADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
      hist_out_rsc_ARID : IN STD_LOGIC;
      hist_out_rsc_BREADY : IN STD_LOGIC;
      hist_out_rsc_BVALID : OUT STD_LOGIC;
      hist_out_rsc_BUSER : OUT STD_LOGIC;
      hist_out_rsc_BRESP : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_BID : OUT STD_LOGIC;
      hist_out_rsc_WREADY : OUT STD_LOGIC;
      hist_out_rsc_WVALID : IN STD_LOGIC;
      hist_out_rsc_WUSER : IN STD_LOGIC;
      hist_out_rsc_WLAST : IN STD_LOGIC;
      hist_out_rsc_WSTRB : IN STD_LOGIC;
      hist_out_rsc_WDATA : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_AWREADY : OUT STD_LOGIC;
      hist_out_rsc_AWVALID : IN STD_LOGIC;
      hist_out_rsc_AWUSER : IN STD_LOGIC;
      hist_out_rsc_AWREGION : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWQOS : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWPROT : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_AWCACHE : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      hist_out_rsc_AWLOCK : IN STD_LOGIC;
      hist_out_rsc_AWBURST : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      hist_out_rsc_AWSIZE : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
      hist_out_rsc_AWLEN : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
      hist_out_rsc_AWADDR : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
      hist_out_rsc_AWID : IN STD_LOGIC;
      hist_out_rsc_req_vz : IN STD_LOGIC;
      hist_out_rsc_rls_lz : OUT STD_LOGIC
    );
  END COMPONENT;
  SIGNAL histogram_hls_struct_inst_data_in_rsc_RRESP : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_RDATA : STD_LOGIC_VECTOR (15 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_ARREGION : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_ARQOS : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_ARPROT : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_ARCACHE : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_ARBURST : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_ARSIZE : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_ARLEN : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_ARADDR : STD_LOGIC_VECTOR (12 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_BRESP : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_WSTRB : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_WDATA : STD_LOGIC_VECTOR (15 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_AWREGION : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_AWQOS : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_AWPROT : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_AWCACHE : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_AWBURST : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_AWSIZE : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_AWLEN : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_data_in_rsc_AWADDR : STD_LOGIC_VECTOR (12 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_RRESP : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_RDATA : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_ARREGION : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_ARQOS : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_ARPROT : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_ARCACHE : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_ARBURST : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_ARSIZE : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_ARLEN : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_ARADDR : STD_LOGIC_VECTOR (11 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_BRESP : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_WDATA : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_AWREGION : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_AWQOS : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_AWPROT : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_AWCACHE : STD_LOGIC_VECTOR (3 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_AWBURST : STD_LOGIC_VECTOR (1 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_AWSIZE : STD_LOGIC_VECTOR (2 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_AWLEN : STD_LOGIC_VECTOR (7 DOWNTO
      0);
  SIGNAL histogram_hls_struct_inst_hist_out_rsc_AWADDR : STD_LOGIC_VECTOR (11 DOWNTO
      0);

BEGIN
  histogram_hls_struct_inst : histogram_hls_struct
    PORT MAP(
      clk => clk,
      rst => rst,
      data_in_rsc_s_tdone => data_in_rsc_s_tdone,
      data_in_rsc_tr_write_done => data_in_rsc_tr_write_done,
      data_in_rsc_RREADY => data_in_rsc_RREADY,
      data_in_rsc_RVALID => data_in_rsc_RVALID,
      data_in_rsc_RUSER => data_in_rsc_RUSER,
      data_in_rsc_RLAST => data_in_rsc_RLAST,
      data_in_rsc_RRESP => histogram_hls_struct_inst_data_in_rsc_RRESP,
      data_in_rsc_RDATA => histogram_hls_struct_inst_data_in_rsc_RDATA,
      data_in_rsc_RID => data_in_rsc_RID,
      data_in_rsc_ARREADY => data_in_rsc_ARREADY,
      data_in_rsc_ARVALID => data_in_rsc_ARVALID,
      data_in_rsc_ARUSER => data_in_rsc_ARUSER,
      data_in_rsc_ARREGION => histogram_hls_struct_inst_data_in_rsc_ARREGION,
      data_in_rsc_ARQOS => histogram_hls_struct_inst_data_in_rsc_ARQOS,
      data_in_rsc_ARPROT => histogram_hls_struct_inst_data_in_rsc_ARPROT,
      data_in_rsc_ARCACHE => histogram_hls_struct_inst_data_in_rsc_ARCACHE,
      data_in_rsc_ARLOCK => data_in_rsc_ARLOCK,
      data_in_rsc_ARBURST => histogram_hls_struct_inst_data_in_rsc_ARBURST,
      data_in_rsc_ARSIZE => histogram_hls_struct_inst_data_in_rsc_ARSIZE,
      data_in_rsc_ARLEN => histogram_hls_struct_inst_data_in_rsc_ARLEN,
      data_in_rsc_ARADDR => histogram_hls_struct_inst_data_in_rsc_ARADDR,
      data_in_rsc_ARID => data_in_rsc_ARID,
      data_in_rsc_BREADY => data_in_rsc_BREADY,
      data_in_rsc_BVALID => data_in_rsc_BVALID,
      data_in_rsc_BUSER => data_in_rsc_BUSER,
      data_in_rsc_BRESP => histogram_hls_struct_inst_data_in_rsc_BRESP,
      data_in_rsc_BID => data_in_rsc_BID,
      data_in_rsc_WREADY => data_in_rsc_WREADY,
      data_in_rsc_WVALID => data_in_rsc_WVALID,
      data_in_rsc_WUSER => data_in_rsc_WUSER,
      data_in_rsc_WLAST => data_in_rsc_WLAST,
      data_in_rsc_WSTRB => histogram_hls_struct_inst_data_in_rsc_WSTRB,
      data_in_rsc_WDATA => histogram_hls_struct_inst_data_in_rsc_WDATA,
      data_in_rsc_AWREADY => data_in_rsc_AWREADY,
      data_in_rsc_AWVALID => data_in_rsc_AWVALID,
      data_in_rsc_AWUSER => data_in_rsc_AWUSER,
      data_in_rsc_AWREGION => histogram_hls_struct_inst_data_in_rsc_AWREGION,
      data_in_rsc_AWQOS => histogram_hls_struct_inst_data_in_rsc_AWQOS,
      data_in_rsc_AWPROT => histogram_hls_struct_inst_data_in_rsc_AWPROT,
      data_in_rsc_AWCACHE => histogram_hls_struct_inst_data_in_rsc_AWCACHE,
      data_in_rsc_AWLOCK => data_in_rsc_AWLOCK,
      data_in_rsc_AWBURST => histogram_hls_struct_inst_data_in_rsc_AWBURST,
      data_in_rsc_AWSIZE => histogram_hls_struct_inst_data_in_rsc_AWSIZE,
      data_in_rsc_AWLEN => histogram_hls_struct_inst_data_in_rsc_AWLEN,
      data_in_rsc_AWADDR => histogram_hls_struct_inst_data_in_rsc_AWADDR,
      data_in_rsc_AWID => data_in_rsc_AWID,
      data_in_rsc_req_vz => data_in_rsc_req_vz,
      data_in_rsc_rls_lz => data_in_rsc_rls_lz,
      hist_out_rsc_s_tdone => hist_out_rsc_s_tdone,
      hist_out_rsc_tr_write_done => hist_out_rsc_tr_write_done,
      hist_out_rsc_RREADY => hist_out_rsc_RREADY,
      hist_out_rsc_RVALID => hist_out_rsc_RVALID,
      hist_out_rsc_RUSER => hist_out_rsc_RUSER,
      hist_out_rsc_RLAST => hist_out_rsc_RLAST,
      hist_out_rsc_RRESP => histogram_hls_struct_inst_hist_out_rsc_RRESP,
      hist_out_rsc_RDATA => histogram_hls_struct_inst_hist_out_rsc_RDATA,
      hist_out_rsc_RID => hist_out_rsc_RID,
      hist_out_rsc_ARREADY => hist_out_rsc_ARREADY,
      hist_out_rsc_ARVALID => hist_out_rsc_ARVALID,
      hist_out_rsc_ARUSER => hist_out_rsc_ARUSER,
      hist_out_rsc_ARREGION => histogram_hls_struct_inst_hist_out_rsc_ARREGION,
      hist_out_rsc_ARQOS => histogram_hls_struct_inst_hist_out_rsc_ARQOS,
      hist_out_rsc_ARPROT => histogram_hls_struct_inst_hist_out_rsc_ARPROT,
      hist_out_rsc_ARCACHE => histogram_hls_struct_inst_hist_out_rsc_ARCACHE,
      hist_out_rsc_ARLOCK => hist_out_rsc_ARLOCK,
      hist_out_rsc_ARBURST => histogram_hls_struct_inst_hist_out_rsc_ARBURST,
      hist_out_rsc_ARSIZE => histogram_hls_struct_inst_hist_out_rsc_ARSIZE,
      hist_out_rsc_ARLEN => histogram_hls_struct_inst_hist_out_rsc_ARLEN,
      hist_out_rsc_ARADDR => histogram_hls_struct_inst_hist_out_rsc_ARADDR,
      hist_out_rsc_ARID => hist_out_rsc_ARID,
      hist_out_rsc_BREADY => hist_out_rsc_BREADY,
      hist_out_rsc_BVALID => hist_out_rsc_BVALID,
      hist_out_rsc_BUSER => hist_out_rsc_BUSER,
      hist_out_rsc_BRESP => histogram_hls_struct_inst_hist_out_rsc_BRESP,
      hist_out_rsc_BID => hist_out_rsc_BID,
      hist_out_rsc_WREADY => hist_out_rsc_WREADY,
      hist_out_rsc_WVALID => hist_out_rsc_WVALID,
      hist_out_rsc_WUSER => hist_out_rsc_WUSER,
      hist_out_rsc_WLAST => hist_out_rsc_WLAST,
      hist_out_rsc_WSTRB => hist_out_rsc_WSTRB,
      hist_out_rsc_WDATA => histogram_hls_struct_inst_hist_out_rsc_WDATA,
      hist_out_rsc_AWREADY => hist_out_rsc_AWREADY,
      hist_out_rsc_AWVALID => hist_out_rsc_AWVALID,
      hist_out_rsc_AWUSER => hist_out_rsc_AWUSER,
      hist_out_rsc_AWREGION => histogram_hls_struct_inst_hist_out_rsc_AWREGION,
      hist_out_rsc_AWQOS => histogram_hls_struct_inst_hist_out_rsc_AWQOS,
      hist_out_rsc_AWPROT => histogram_hls_struct_inst_hist_out_rsc_AWPROT,
      hist_out_rsc_AWCACHE => histogram_hls_struct_inst_hist_out_rsc_AWCACHE,
      hist_out_rsc_AWLOCK => hist_out_rsc_AWLOCK,
      hist_out_rsc_AWBURST => histogram_hls_struct_inst_hist_out_rsc_AWBURST,
      hist_out_rsc_AWSIZE => histogram_hls_struct_inst_hist_out_rsc_AWSIZE,
      hist_out_rsc_AWLEN => histogram_hls_struct_inst_hist_out_rsc_AWLEN,
      hist_out_rsc_AWADDR => histogram_hls_struct_inst_hist_out_rsc_AWADDR,
      hist_out_rsc_AWID => hist_out_rsc_AWID,
      hist_out_rsc_req_vz => hist_out_rsc_req_vz,
      hist_out_rsc_rls_lz => hist_out_rsc_rls_lz
    );
  data_in_rsc_RRESP <= histogram_hls_struct_inst_data_in_rsc_RRESP;
  data_in_rsc_RDATA <= histogram_hls_struct_inst_data_in_rsc_RDATA;
  histogram_hls_struct_inst_data_in_rsc_ARREGION <= data_in_rsc_ARREGION;
  histogram_hls_struct_inst_data_in_rsc_ARQOS <= data_in_rsc_ARQOS;
  histogram_hls_struct_inst_data_in_rsc_ARPROT <= data_in_rsc_ARPROT;
  histogram_hls_struct_inst_data_in_rsc_ARCACHE <= data_in_rsc_ARCACHE;
  histogram_hls_struct_inst_data_in_rsc_ARBURST <= data_in_rsc_ARBURST;
  histogram_hls_struct_inst_data_in_rsc_ARSIZE <= data_in_rsc_ARSIZE;
  histogram_hls_struct_inst_data_in_rsc_ARLEN <= data_in_rsc_ARLEN;
  histogram_hls_struct_inst_data_in_rsc_ARADDR <= data_in_rsc_ARADDR;
  data_in_rsc_BRESP <= histogram_hls_struct_inst_data_in_rsc_BRESP;
  histogram_hls_struct_inst_data_in_rsc_WSTRB <= data_in_rsc_WSTRB;
  histogram_hls_struct_inst_data_in_rsc_WDATA <= data_in_rsc_WDATA;
  histogram_hls_struct_inst_data_in_rsc_AWREGION <= data_in_rsc_AWREGION;
  histogram_hls_struct_inst_data_in_rsc_AWQOS <= data_in_rsc_AWQOS;
  histogram_hls_struct_inst_data_in_rsc_AWPROT <= data_in_rsc_AWPROT;
  histogram_hls_struct_inst_data_in_rsc_AWCACHE <= data_in_rsc_AWCACHE;
  histogram_hls_struct_inst_data_in_rsc_AWBURST <= data_in_rsc_AWBURST;
  histogram_hls_struct_inst_data_in_rsc_AWSIZE <= data_in_rsc_AWSIZE;
  histogram_hls_struct_inst_data_in_rsc_AWLEN <= data_in_rsc_AWLEN;
  histogram_hls_struct_inst_data_in_rsc_AWADDR <= data_in_rsc_AWADDR;
  hist_out_rsc_RRESP <= histogram_hls_struct_inst_hist_out_rsc_RRESP;
  hist_out_rsc_RDATA <= histogram_hls_struct_inst_hist_out_rsc_RDATA;
  histogram_hls_struct_inst_hist_out_rsc_ARREGION <= hist_out_rsc_ARREGION;
  histogram_hls_struct_inst_hist_out_rsc_ARQOS <= hist_out_rsc_ARQOS;
  histogram_hls_struct_inst_hist_out_rsc_ARPROT <= hist_out_rsc_ARPROT;
  histogram_hls_struct_inst_hist_out_rsc_ARCACHE <= hist_out_rsc_ARCACHE;
  histogram_hls_struct_inst_hist_out_rsc_ARBURST <= hist_out_rsc_ARBURST;
  histogram_hls_struct_inst_hist_out_rsc_ARSIZE <= hist_out_rsc_ARSIZE;
  histogram_hls_struct_inst_hist_out_rsc_ARLEN <= hist_out_rsc_ARLEN;
  histogram_hls_struct_inst_hist_out_rsc_ARADDR <= hist_out_rsc_ARADDR;
  hist_out_rsc_BRESP <= histogram_hls_struct_inst_hist_out_rsc_BRESP;
  histogram_hls_struct_inst_hist_out_rsc_WDATA <= hist_out_rsc_WDATA;
  histogram_hls_struct_inst_hist_out_rsc_AWREGION <= hist_out_rsc_AWREGION;
  histogram_hls_struct_inst_hist_out_rsc_AWQOS <= hist_out_rsc_AWQOS;
  histogram_hls_struct_inst_hist_out_rsc_AWPROT <= hist_out_rsc_AWPROT;
  histogram_hls_struct_inst_hist_out_rsc_AWCACHE <= hist_out_rsc_AWCACHE;
  histogram_hls_struct_inst_hist_out_rsc_AWBURST <= hist_out_rsc_AWBURST;
  histogram_hls_struct_inst_hist_out_rsc_AWSIZE <= hist_out_rsc_AWSIZE;
  histogram_hls_struct_inst_hist_out_rsc_AWLEN <= hist_out_rsc_AWLEN;
  histogram_hls_struct_inst_hist_out_rsc_AWADDR <= hist_out_rsc_AWADDR;

END v1;



