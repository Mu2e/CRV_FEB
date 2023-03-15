----------------------------------------------------------------------------------
-- Company: FNAL
-- Engineer: Micol Rigatti <mrigatti@fnal.gov> 
-- 
-- Create Date: 10/27/2022 12:12:09 PM
-- Design Name: 
-- Module Name: DDR Interface - Behavioral
-- Project Name: CRV FEB
-- Target Devices: xc7s50fgga484-2
-- Tool Versions: 2021.2
-- Description: 
-- 
----------------------------------------------------------------------------------


LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

use work.Proj_Def.all;


entity DDR_Interface is
generic(
	-- DDR3L parameters
	DATA_WIDTH			: integer := 16;  -- 16 Both ARTY and FEB
	DDR3L_ADDR			: integer := 15;  -- 14: ARTY 15: FEB
	APP_ADDR			: integer := 29  -- 28: ARTY 29: FEB
);
port (
	ClkB_P,ClkB_N  		: in std_logic; 
	SysClk				: in std_logic; -- 160 MHz
	ResetHi				: in std_logic;
	Clk_80MHz			: in std_logic;
	Clk_200MHz			: in std_logic;
-- DDR3L pins
	DDR_DATA			: inout std_logic_vector(DATA_WIDTH-1 downto 0);
	DDR_ADDR			: out std_logic_vector(DDR3L_ADDR-1 downto 0);
	BA 					: out std_logic_vector(2 downto 0);
	DDR_CKE	 			: out std_logic_vector(0 downto 0);
	ODT 				: out std_logic_vector(0 downto 0);
	CS 					: out std_logic_vector(0 downto 0);
	DM 					: out std_logic_vector(1 downto 0);
	RAS,CAS				: out std_logic; 
	DDR_WE 				: out std_logic;
	DDR_CLKP,DDR_CLKN 	: out  std_logic_vector(0 downto 0);
	LDQS_P, LDQS_N 		: inout std_logic;
	UDQS_P, UDQS_N 		: inout std_logic;
	RESET_N				: out std_logic;
-- Signals for the DDR	
	EvBuffRd			: buffer std_logic;
	EvBuffOut			: in std_logic_vector(15 downto 0);
	EvBuffEmpty			: in std_logic;
	EvBuffWdsUsed		: in std_logic_vector(10 downto 0);
-- Signals from Trigger Logic
	SlfTrgEn 			: in std_logic;
	uBunchWrt			: in std_logic;
	uBunch				: in std_logic_vector(31 downto 0);
-- Microcontroller strobes
	CpldRst				: in std_logic;
	CpldCS				: in std_logic;
	uCRd				: in std_logic;
	uCWr 				: in std_logic;
-- Microcontroller data and address buses	
	uCA 				: in std_logic_vector(11 downto 0);
	uCD 				: in std_logic_vector(15 downto 0);
-- Geographic address pins
	GA 					: in std_logic_vector(1 downto 0);
-- Synchronous edge detectors of uC read and write strobes
	AddrReg			  	: in std_logic_vector(11 downto 0);
	WRDL 				: in std_logic_vector(1 downto 0);
	RDDL				: in std_logic_vector(1 downto 0)
	);
end DDR_Interface;

architecture Behavioral of DDR_Interface is

-- Signals for the DDR3 Controller 
signal Buff_Rst		  	  : std_logic;
signal clk 				  : std_logic;
signal reset 			  : std_logic;
signal DDR3_addr          : std_logic_vector(APP_ADDR-1 downto 0); 
signal DDR3_cmd           : std_logic_vector(2 downto 0);
signal DDR3_en            : std_logic;

signal DDR3_wrt_data      : std_logic_vector(63 downto 0); 
signal DDR3_wrt_end       : std_logic;
signal DDR3_wrt_en        : std_logic;

signal DDR3_rd_data       : std_logic_vector(63 downto 0);
signal DDR3_rd_data_end   : std_logic;
signal DDR3_rd_data_valid : std_logic;

signal DDR3_rdy           : std_logic;
signal DDR3_wrt_rdy       : std_logic;

signal app_sr_req         : std_logic;
signal app_ref_req        : std_logic;
signal app_zq_req         : std_logic;
signal app_sr_active      : std_logic;
signal app_ref_ack        : std_logic;
signal app_zq_ack         : std_logic;
signal ui_clk             : std_logic;
signal ui_clk_sync_rst    : std_logic;
signal init_calib_complete: std_logic;
-- System Clock Ports
signal sys_clk_p          : std_logic;
signal sys_clk_n          : std_logic;
-- Reference Clock Ports
signal clk_ref_p          : std_logic;
signal clk_ref_n          : std_logic;
signal device_temp        : std_logic_vector(11 downto 0);


-- Signals for Address buffer
signal DDRAddrRd		  : std_logic;
signal DDRAddrEmpty		  : std_logic;
signal DDRAddrFull		  : std_logic;
signal DDRAddrOut 		  : std_logic_vector(31 downto 0);

-- Signals for DDR Read Buffer
signal DRAMRdBuffWrt	  : std_logic;
signal DRAMRdBuffRd		  : std_logic;
signal DRAMRdBuffFull	  : std_logic;
signal DRAMRdBuffEmpty	  : std_logic;
signal rstDRAMBuffHi 	  : std_logic;
signal rstDDRRdBuff		  : std_logic;
signal DRAMRdBuffDat 	  : std_logic_vector(15 downto 0);
signal DRAMRdBuffOut 	  : std_logic_vector(15 downto 0);
signal DRAMRdBuffWdsUsed  : std_logic_vector(10 downto 0);

-- Signals for DDR FSM
Type DDR_FSM is (Idle, SetWrt, WrtData1, WrtData2, WrtData3, WrtData4, 
					SetRd, RdWdCount, RdData1, RdData2, RdData3, RdData4);
signal DDR_Seq 	  : DDR_FSM;
signal DDRSeqStat 	 	  : std_logic_vector(3 downto 0);
signal DDRWrtCount 		  : std_logic_vector(10 downto 0);
signal PageRdReq		  : std_logic;
signal PageWdCount 		  : std_logic_vector(10 downto 0);
signal DDRRdPtr  		  : std_logic_vector(28 downto 0);
signal DDR3_rd_addr       : std_logic_vector(28 downto 0);


signal DDRRd_Mux 		  : std_logic_vector(15 downto 0);


begin

-- FIFO storing the uBunch to address the pages of the DDR3
DDRAddrBuff : SCFIFO_32x256
port map (
	rst 	=> ResetHi,
	clk 	=> SysClk,
	wr_en 	=> uBunchWrt,
	rd_en 	=> DDRAddrRd,
	din 	=> uBunch,
    dout 	=> DDRAddrOut, 
    empty 	=> DDRAddrEmpty,
	full 	=> DDRAddrFull
);

-- FIFO storing the read data from the DDR
DDRRdBuff : SCFIFO_1Kx16
port map (
	rst 	=> rstDDRRdBuff,
	clk		=> SysClk,
	wr_en	=> DRAMRdBuffWrt,
	rd_en 	=> DRAMRdBuffRd,
	din 	=> DRAMRdBuffDat,
    dout 	=> DRAMRdBuffOut, 
    empty 	=> DRAMRdBuffEmpty,
	full 	=> DRAMRdBuffFull,
	data_count => DRAMRdBuffWdsUsed
);


--====================================================================================================
--   COL_WIDTH             : integer := 10; -- # of memory Column Address bits.
--   CS_WIDTH              : integer := 1; -- # of unique CS outputs to memory.
--   DM_WIDTH              : integer := 2; -- # of DM (data mask)
--   DQ_WIDTH              : integer := 16;-- # of DQ (data)
--   DQS_CNT_WIDTH         : integer := 1;-- = ceil(log2(DQS_WIDTH))
--   DRAM_WIDTH            : integer := 8;-- # of DQ per DQS
--   ECC_TEST              : string  := "OFF";
--   RANKS                 : integer := 1; -- # of Ranks.
--   ROW_WIDTH             : integer := 15; -- # of memory Row Address bits.
--   ADDR_WIDTH            : integer := 29; -- # = RANK_WIDTH + BANK_WIDTH + ROW_WIDTH + COL_WIDTH;
--====================================================================================================

DDR_Controller : DDR3LController
port map(
    ddr3_dq       	  => DDR_DATA,
    ddr3_dqs_p(0)     => LDQS_P,
    ddr3_dqs_p(1)     => LDQS_N,
	ddr3_dqs_n(0)     => UDQS_P,
    ddr3_dqs_n(1)     => UDQS_N,
	ddr3_addr     	  => DDR_ADDR,
    ddr3_ba       	  => BA,
    ddr3_ras_n    	  => RAS,
    ddr3_cas_n    	  => CAS,
    ddr3_we_n     	  => DDR_WE,
    ddr3_reset_n  	  => RESET_N,
    ddr3_ck_p     	  => DDR_CLKP,
    ddr3_ck_n     	  => DDR_CLKN,
    ddr3_cke      	  => DDR_CKE,
    ddr3_cs_n     	  => CS,
    ddr3_dm       	  => DM,
    ddr3_odt      	  => ODT,
	
	
    app_addr          => DDR3_addr,   -- This input indicates the address for the current request.                      
    app_cmd           => DDR3_cmd,   -- This input selects the command for the current request.                      
    app_en            => DDR3_en,   -- This is the active-High strobe for the app_addr[], app_cmd[2:0], app_sz, and app_hi_pri inputs.           
    
	app_wdf_data      => DDR3_wrt_data,  -- This provides the data for write commands.           
    app_wdf_end       => DDR3_wrt_end, -- This active-High input indicates that the current clock cycle is the last cycle of input data on app_wdf_data[].            
    app_wdf_mask      => "00000000",   -- This provides the mask for app_wdf_data[].         
    app_wdf_wren      => DDR3_wrt_en, -- This is the active-High strobe for app_wdf_data[].
	
    app_rd_data       => DDR3_rd_data, -- This provides the output data from read commands.             
    app_rd_data_end   => DDR3_rd_data_end, --  This active-High output indicates that the current clock cycle is the last cycle of output data on app_rd_data[]. This is valid only when app_rd_data_valid is active-High.     
    app_rd_data_valid => DDR3_rd_data_valid, -- This active-High output indicates that app_rd_data[] is valid.     
	
    app_rdy           => DDR3_rdy, -- This output indicates that the UI is ready to accept commands. If the signal is deasserted when app_en is enabled, the current app_cmd and app_addr must be retried until app_rdy is asserted.                  
    app_wdf_rdy       => DDR3_wrt_rdy,  -- This output indicates that the write data FIFO is ready to receive data. Write data is accepted when app_wdf_rdy = 1'b1 and app_wdf_wren = 1'b1.                 
    app_sr_req        => '0',   -- This input is reserved and should be tied to 0.              
    app_ref_req       => '0',   -- This active-High input requests that a refresh command be issued to the DRAM.               
    app_zq_req        => '0',   -- This active-High input requests that a ZQ calibration command be issued to the DRAM.               
    app_sr_active     => app_sr_active, -- This output is reserved.     
    app_ref_ack       => app_ref_ack, -- This active-High output indicates that the Memory Controller has sent the requested refresh command to the PHY interface.               
    app_zq_ack        => app_zq_ack,  -- This active-High output indicates that the Memory Controller has sent the requested ZQ calibration command to the PHY interface.              
    ui_clk            => clk,  -- This UI clock must be a half or quarter of the DRAM clock.      
    ui_clk_sync_rst   => reset,  -- This is the active-High UI reset.         
    init_calib_complete => init_calib_complete,  -- PHY asserts init_calib_complete when calibration is finished.
    -- System Clock Ports
    sys_clk_i         => SysClk,
    -- Reference Clock Ports
    clk_ref_i         => Clk_200MHz,      
    device_temp       => device_temp, 
    sys_rst           => ResetHi     
);

main : process(SysClk, CpldRst)
begin 
if CpldRst = '0' then

	--RESET_N			<= '0';		  
	
	DDR3_addr		<= (others => '0');         
	DDR3_cmd    	<= (others => '0');       
	DDR3_en     	<= '0';	       
	DDR3_wrt_data   <= (others => '0');   
	DDR3_wrt_end    <= '0';   
	DDR3_wrt_en     <= '0';      
	clk_ref_p       <= '0';        
	clk_ref_n       <= '0';  
	
--	Buff_Rst 		<= '0';

	
	-- Write DDR Signals
	DDR_Seq			<= Idle;
	DDRSeqStat 		<= "0000";
	DDRWrtCount 	<= (others => '0');
	EvBuffRd 		<= '0';
	DDR_Seq 		<= Idle; 
	DDRAddrRd 		<= '0';

	-- Read DDR Signals
	PageRdReq 		<= '0';
	PageWdCount 	<= (others => '0');
	DRAMRdBuffWrt	<= '0';
	DRAMRdBuffRd 	<= '0';
	DRAMRdBuffDat 	<= (others => '0');
	DDRRdPtr 		<= (others => '0');
	DDR3_rd_addr	<= (others => '0');
	
elsif rising_edge (SysClk) then

	--RESET_N			<= '1';	
-- Global reset term
--if WRDL = 1 and uCD(5) = '1' and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = CSRRegAddr)
--	or uCA(9 downto 0) = CSRBroadCastAd)
--then Buff_Rst <= '1';
--else Buff_Rst <= '0';
--end if;




-- Reset DRAM Read FIFO
if (WRDL = 1 and uCA(9 downto 0) = PageStatAddr and uCD(8) = '1') or
   (WRDL = 1 and uCA(11 downto 10) = GA and uCA(9 downto 0) = PageRstAddr and uCD(8) = '1')
then rstDRAMBuffHi <= '1';
else rstDRAMBuffHi <= '0';
end if;

rstDDRRdBuff <= ResetHi or rstDRAMBuffHi;


-- ========================================================
-- ============== ACTUNG: TO BE FIXED =====================
-- ========================================================

-- DDR Read address register
-- Microcontroller access upper
if WRDL = 1 and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = SDRamRdPtrHiAd)
				or uCA(9 downto 0) = BrdCstRdPtrHiAd)
-- ORIGINAL then DDR3_addr <= uCD(13 downto 0) & DDR3_addr(15 downto 0);
then DDR3_rd_addr <= uCD(12 downto 0) & DDR3_rd_addr(15 downto 0);
-- Microcontroller access lower
elsif WRDL = 1 and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = SDRamRdPtrLoAd)
				or uCA(9 downto 0) = BrdCstRdPtrLoAd)
-- ORIGINAL then DDR3_addr <= DDR3_addr(29 downto 16) & uCD;
then DDR3_rd_addr <= DDR3_rd_addr(28 downto 16) & uCD;
-- Convert the microcontroller data to a page number
elsif WRDL = 1 and uCA(9 downto 0) = uBunchRdPtrHiAd
-- ORIGINAL  then DDR3_addr <= uCD(3 downto 0) & DDR3_addr(25 downto 0);
then DDR3_rd_addr <= uCD(2 downto 0) & DDR3_rd_addr(25 downto 0);
elsif WRDL = 1 and uCA(9 downto 0) = uBunchRdPtrLoAd
-- ORIGINAL  then DDR3_addr <= DDR3_addr(29 downto 26) & uCD & "00" & X"00";
then DDR3_rd_addr <= DDR3_rd_addr(28 downto 26) & uCD & "00" & X"00";
end if;




--=============================  DDR FSM  ================================
Case DDR_Seq is
When Idle => 
	DDRSeqStat <= "0000"; 
	-- If in the Event Buffer FIFO are saved more words than how many AFE data are
	-- in one window (gate width), the Event Buffer FIFO is storing at least one 
	-- event that can be written in the DDR 
	if SlfTrgEn = '1' and EvBuffWdsUsed >= EvBuffOut(10 downto 0) 
	   and EvBuffEmpty = '0' and DDR3_rdy ='1' and DDR3_wrt_rdy ='1'
	then DDR_Seq <= SetWrt;
	elsif WRDL = 1 and DDR3_rdy ='1' and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = SDRamRdPtrLoAd)
		  or uCA(9 downto 0) = BrdCstRdPtrLoAd or uCA(9 downto 0) = uBunchRdPtrLoAd)
	then DDR_Seq <= SetRd;
	else DDR_Seq <= Idle;
	end if;
	
	When SetWrt =>  
	DDRSeqStat <= "1101";
	if DDR3_wrt_rdy = '1'
	then DDR_Seq <= WrtData1;
	else DDR_Seq <= SetWrt;
	end if;
	
	When WrtData1 =>
	 DDRSeqStat <= "0001";
	 if DDRWrtCount <= 1 then DDR_Seq <= Idle;
	 else DDR_Seq <= WrtData2;
	 end if;
	When WrtData2 =>
	 DDRSeqStat <= "0010";
	 if DDRWrtCount <= 1 then DDR_Seq <= Idle;
	 else DDR_Seq <= WrtData3;	 
	 end if;
	When WrtData3 =>
	 DDRSeqStat <= "0011";
	 if DDRWrtCount <= 1 then DDR_Seq <= Idle;
	 else DDR_Seq <= WrtData4;	
	 end if;	 
	When WrtData4 =>
	 DDRSeqStat <= "0100";
	 if DDRWrtCount <= 1 then DDR_Seq <= Idle;
	 else DDR_Seq <= WrtData1;	 
	 end if;

	When SetRd => 
	 DDRSeqStat <= "1110";
	 if PageRdReq = '1'
	 then DDR_Seq <= RdWdCount;
	 else DDR_Seq <= Idle;
	 end if;
	When RdWdCount => 
	 DDRSeqStat <= "1111";
	 DDR_Seq <= RdData1;

	When RdData1 =>
	 DDRSeqStat <= "1001";
	 if PageWdCount = 0 then DDR_Seq <= Idle;
	 else DDR_Seq <= RdData2;
	 end if;
	When RdData2 =>
	 DDRSeqStat <= "1010";
	 if PageWdCount = 0 then DDR_Seq <= Idle;
	 else DDR_Seq <= RdData3;	 
	 end if;
	When RdData3 =>
	 DDRSeqStat <= "1011";
	 if PageWdCount = 0 then DDR_Seq <= Idle;
	 else DDR_Seq <= RdData4;	
	 end if;	 
	When RdData4 =>
	 DDRSeqStat <= "1100";
	 if PageWdCount = 0 then DDR_Seq <= Idle;
	 else DDR_Seq <= RdData1;	 
	 end if;

	When others => DDR_Seq <= Idle;
end case;

if WRDL = 1 and uCA(9 downto 0) = uBunchRdPtrLoAd
	then PageRdReq <= '1'; 
elsif DDR_Seq = RdWdCount
	then PageRdReq <= '0';
else PageRdReq <= PageRdReq;
end if;
	 
if DDR_Seq = Idle 
then 
	EvBuffRd 				<= '0';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount;
	DDR3_addr 				<= DDR3_addr;
	DDR3_cmd 				<= "000";
    DDR3_en 				<= '0';
	DDR3_wrt_en 			<= '0';
	DDR3_wrt_end 			<= '0';
	PageWdCount 			<= (others => '0');
	DRAMRdBuffWrt			<= '0';
elsif DDR_Seq = SetWrt 
then 
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '1';
	DDRWrtCount 			<= EvBuffOut(10 downto 0);
	DDR3_addr(9 downto 0)   <= (others => '0');
	DDR3_addr(28 downto 10) <= DDRAddrOut(18 downto 0); -- Set the page = uBunch number
	DDR3_cmd 				<= "000";
    DDR3_en 				<= '1';
	DDR3_wrt_en 			<= '0';
	DDR3_wrt_end 			<= '0';
elsif DDR_Seq = WrtData1
then
	if WRDL = 1 and  uCA(11 downto 10) = GA and uCA(9 downto 0) = SDRamPortAd
		then DDR3_wrt_data(63 downto 48) <= uCD;
		else DDR3_wrt_data(63 downto 48) <= EvBuffOut;
	end if;
	DDR3_wrt_en 			<= '0';
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount - 1;
	DDR3_wrt_end 			<= '0';
	DDR3_en 				<= '1';
	if DDRSeqStat = "0101"
	then DDR3_addr(9 downto 0)  <= (others => '0');	
	else DDR3_addr 				<= DDR3_addr + 4;
	end if;
	if DDRWrtCount <= 1
	then EvBuffRd  <= '0';
		 DDR3_wrt_data(47 downto 0) <= (others => '0');
		 DDR3_wrt_en 		<= '1';
		 DDR3_wrt_end 		<= '1';
	end if;
elsif DDR_Seq = WrtData2
then
	if WRDL = 1 and  uCA(11 downto 10) = GA and uCA(9 downto 0) = SDRamPortAd
		then DDR3_wrt_data(47 downto 32) <= uCD;
		else DDR3_wrt_data(47 downto 32) <= EvBuffOut;
	end if; 
	DDR3_wrt_en 			<= '0';
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount - 1;
	DDR3_addr 				<= DDR3_addr;
	DDR3_wrt_end 			<= '0';
	DDR3_en 				<= '1';
	if DDRWrtCount <= 1
	then EvBuffRd  <= '0';
		 DDR3_wrt_data(31 downto 0) <= (others => '0');
		 DDR3_wrt_en 		<= '1';
		 DDR3_wrt_end 		<= '1';
	end if;
elsif DDR_Seq = WrtData3
then
	if WRDL = 1 and  uCA(11 downto 10) = GA and uCA(9 downto 0) = SDRamPortAd
		then DDR3_wrt_data(31 downto 16) <= uCD;
		else DDR3_wrt_data(31 downto 16) <= EvBuffOut;
	end if;
	DDR3_wrt_en 			<= '0';
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount - 1;
	DDR3_addr 				<= DDR3_addr;
	DDR3_wrt_end 			<= '0';
    DDR3_en 				<= '1';
	if DDRWrtCount <= 1
	then EvBuffRd  <= '0';
		 DDR3_wrt_data(15 downto 0) <= (others => '0');
		 DDR3_wrt_en 		<= '1';
		 DDR3_wrt_end 		<= '1';
	end if;
elsif DDR_Seq = WrtData4
then
	if WRDL = 1 and  uCA(11 downto 10) = GA and uCA(9 downto 0) = SDRamPortAd
		then DDR3_wrt_data(15 downto 0) <= uCD;
		else DDR3_wrt_data(15 downto 0) <= EvBuffOut;
	end if; 
	DDR3_wrt_en 			<= '1';
	DDR3_wrt_end 			<= '1';
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '0';
    DDR3_en 				<= '1';
	DDRWrtCount 			<= DDRWrtCount - 1;
	DDR3_addr 				<= DDR3_addr;
	if DDRWrtCount <= 1
	then EvBuffRd  <= '0';
	end if;

elsif DDR_Seq = SetRd 
then
	if uCA(9 downto 0) = SDRamRdPtrLoAd	or uCA(9 downto 0) = BrdCstRdPtrLoAd or uCA(9 downto 0) = uBunchRdPtrLoAd
	then DDR3_addr <= DDR3_rd_addr;
	-- Increment by 8 long words for each burst read command
	else DDR3_addr <= DDR3_addr + 32;
	end if;
	DDR3_cmd 				<= "001";
    DDR3_en 				<= '1';
	DRAMRdBuffWrt			<= '0';
elsif DDR_Seq = RdWdCount
then
	PageWdCount  			<= DDR3_rd_data(10 downto 0);
	DRAMRdBuffWrt			<= '0';
elsif DDR_Seq = RdData1
then 
	DRAMRdBuffDat 			<= DDR3_rd_data(63 downto 48);
	DRAMRdBuffWrt			<= '1';
	if PageWdCount /= 0 then PageWdCount <= PageWdCount - 1;
	else PageWdCount <= PageWdCount;
	end if;
elsif DDR_Seq = RdData2
then 
	DRAMRdBuffDat 			<= DDR3_rd_data(47 downto 32);
	DRAMRdBuffWrt			<= '1';
	if PageWdCount /= 0 then PageWdCount <= PageWdCount - 1;
	else PageWdCount <= PageWdCount;
	end if;
elsif DDR_Seq = RdData3
then 
	DRAMRdBuffDat 			<= DDR3_rd_data(31 downto 16);
	DRAMRdBuffWrt			<= '1';
	if PageWdCount /= 0 then PageWdCount <= PageWdCount - 1;
	else PageWdCount <= PageWdCount;
	end if;
elsif DDR_Seq = RdData4
then 
	DRAMRdBuffDat 			<= DDR3_rd_data(15 downto 0);
	DRAMRdBuffWrt			<= '1';
	if PageWdCount /= 0 then PageWdCount <= PageWdCount - 1;
	else PageWdCount <= PageWdCount;
	end if;

end if;



if RDDL = 2 and AddrReg(11 downto 10) = GA and AddrReg(9 downto 0) = PageFIFOAddr
  then DRAMRdBuffRd <= '1'; 
  else DRAMRdBuffRd <= '0';
 end if;


end if;
end process;

end Behavioral;