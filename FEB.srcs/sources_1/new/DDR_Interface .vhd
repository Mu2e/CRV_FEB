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
port (
	VXO_P,VXO_N 		: in std_logic; 
	SysClk				: in std_logic; -- 160 MHz
	ResetHi				: in std_logic;
-- DDR3L pins
	DDR_DATA			: inout std_logic_vector(15 downto 0);
	DDR_ADDR			: out std_logic_vector(14 downto 0);
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
	SDRzq 				: inout std_logic;
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
	uCD 				: inout std_logic_vector(15 downto 0);
-- Geographic address pins
	GA 					: in std_logic_vector(1 downto 0);
-- Synchronous edge detectors of uC read and write strobes
	--uWRDL 				: in std_logic_vector(1 downto 0);
	WRDL 				: in std_logic_vector(1 downto 0)
	);
end DDR_Interface;

architecture Behavioral of DDR_Interface is

-- Signals for the DDR3 Controller 
signal RESET_N			  : std_logic;
signal clk				  : std_logic;
signal Buff_Rst		  	  : std_logic;
signal reset			  : std_logic;

--signal Even_Odd		  	  : std_logic;
--signal WrtHi_LoSel	  	  : std_logic;
--signal DDR3_addr_staged   : std_logic_vector(28 downto 0); 

-- uC data bus
--signal CDStage			  : std_logic_vector(15 downto 0);


signal DDR3_addr          : std_logic_vector(28 downto 0); 
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

-- Signals for DDR READ FSM
Type Write_Seq_FSM is (Idle, SetWrt, WrtData1, WrtData2, WrtData3, WrtData4);
signal DDR_Write_Seq 	  : Write_Seq_FSM;
signal DDRWrtSeqStat 	  : std_logic_vector(2 downto 0);
signal DDRWrtCount 		  : std_logic_vector(10 downto 0);

-- Signals for DDR READ FSM
Type Read_Seq_FSM is (Idle,CheckEmpty,FirstCmd,CheckRdBuff0,
						RdWdCount,CheckRdBuff1,RdDataHi,RdDataLo);
signal DDR_Read_Seq 	  : Read_Seq_FSM;


begin

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
    sys_clk_p         => VXO_P,
    sys_clk_n         => VXO_N,
    -- Reference Clock Ports
    clk_ref_p         => clk_ref_p,   
    clk_ref_n         => clk_ref_n,   
    device_temp       => device_temp, 
    sys_rst           => RESET_N     
);

main : process(SysClk, CpldRst)
begin 
if CpldRst = '0' then

	RESET_N			<= '1';		  

	DDR3_addr		<= (others => '0');         
	DDR3_cmd    	<= (others => '0');       
	DDR3_en     	<= '0';	       
	DDR3_wrt_data   <= (others => '0');   
	DDR3_wrt_end    <= '0';   
	DDR3_wrt_en     <= '0';      
	clk_ref_p       <= '0';        
	clk_ref_n       <= '0';  
	
	Buff_Rst 		<= '0';
	--Even_Odd 		<= '0';
	--WrtHi_LoSel 	<= '0';
	--DDR3_addr_staged<= (others => '0');

	DDR_Write_Seq	<= Idle;
	DDRWrtSeqStat 	<= "000";
	DDRWrtCount 	<= (others => '0');
	EvBuffRd 		<= '0';
	DDR_Read_Seq 	<= Idle; 
	DDRAddrRd 		<= '0';
    -- Upper DRAM word staging register
	--CDStage 		<= (others => '0');    

elsif rising_edge (SysClk) then

-- Global reset term
if WRDL = 1 and uCD(5) = '1' and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = CSRRegAddr)
	or uCA(9 downto 0) = CSRBroadCastAd)
then Buff_Rst <= '1';
else Buff_Rst <= '0';
end if;



--=============================  DDR READ FSM  ================================
Case DDR_Write_Seq is
When Idle => 
	DDRWrtSeqStat <= "000"; 
	-- If in the Event Buffer FIFO are saved more words than how many AFE data are
	-- in one window (gate width), the Event Buffer FIFO is storing at least one 
	-- event that can be written in the DDR 
	if SlfTrgEn = '1' and EvBuffWdsUsed >= EvBuffOut(10 downto 0) 
	 and EvBuffEmpty = '0' and DDR3_rdy ='1' and DDR3_wrt_rdy ='1'
	then DDR_Write_Seq <= SetWrt;
	else DDR_Write_Seq <= Idle;
	end if;
	
	When SetWrt =>  
	DDRWrtSeqStat <= "101";
	if DDR3_wrt_rdy = '1'
	then DDR_Write_Seq <= WrtData1;
	else DDR_Write_Seq <= SetWrt;
	end if;
	
	When WrtData1 =>
	 DDRWrtSeqStat <= "001";
	 if DDRWrtCount <= 1 then DDR_Write_Seq <= Idle;
	 else DDR_Write_Seq <= WrtData2;
	 end if;
	When WrtData2 =>
	 DDRWrtSeqStat <= "010";
	 if DDRWrtCount <= 1 then DDR_Write_Seq <= Idle;
	 else DDR_Write_Seq <= WrtData3;	 
	 end if;
	When WrtData3 =>
	 DDRWrtSeqStat <= "011";
	 if DDRWrtCount <= 1 then DDR_Write_Seq <= Idle;
	 else DDR_Write_Seq <= WrtData4;	
	 end if;	 
	When WrtData4 =>
	 DDRWrtSeqStat <= "100";
	 if DDRWrtCount <= 1 then DDR_Write_Seq <= Idle;
	 else DDR_Write_Seq <= WrtData1;	 
	 end if;
-- At the end of each event flush the last data words from the write FIFO into the DDR
--	When WritePad => 
--	DDRWrtSeqStat <= "111";  		
--	if DDR3_addr(4 downto 0) = "11100" 
--	then DDR_Write_Seq <= WaitWrtDn;
--	else DDR_Write_Seq <= WritePad;
--	end if;
--	When WaitWrtDn =>
--	if SDwr_empty = '1' then DDR_Write_Seq <= Idle;
--	else DDR_Write_Seq <= WaitWrtDn;
--	end if;
	When others => DDR_Write_Seq <= Idle;
end case;

	 
if DDR_Write_Seq = Idle 
then 
	EvBuffRd 				<= '0';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount;
	DDR3_addr 				<= DDR3_addr;
	DDR3_cmd 				<= "000";
    DDR3_en 				<= '0';
	DDR3_wrt_en 			<= '0';
	DDR3_wrt_end 			<= '0';
elsif DDR_Write_Seq = SetWrt 
then 
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '1';
	DDRWrtCount 			<= EvBuffOut(10 downto 0);
	DDR3_addr(9 downto 0)   <= (others => '0');
	DDR3_addr(28 downto 10) <= DDRAddrOut(18 downto 0); -- Set the page = uBunch number
	DDR3_cmd 				<= "010";
    DDR3_en 				<= '1';
	DDR3_wrt_en 			<= '0';
	DDR3_wrt_end 			<= '0';
elsif DDR_Write_Seq = WrtData1
then 
	DDR3_wrt_data(63 downto 48) <= EvBuffOut;
	DDR3_wrt_en 			<= '0';
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount - 1;
	DDR3_wrt_end 			<= '0';
	if DDRWrtSeqStat = "101"
	then DDR3_addr(9 downto 0)  <= (others => '0');	
	else DDR3_addr 				<= DDR3_addr + 4;
	end if;
	if DDRWrtCount <= 1
	then EvBuffRd  <= '0';
		 DDR3_wrt_data(47 downto 0) <= (others => '0');
		 DDR3_wrt_en 		<= '1';
		 DDR3_wrt_end 		<= '1';
	end if;
elsif DDR_Write_Seq = WrtData2
then 
	DDR3_wrt_data(47 downto 32) <= EvBuffOut;
	DDR3_wrt_en 			<= '0';
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount - 1;
	DDR3_addr 				<= DDR3_addr;
	DDR3_wrt_end 			<= '0';
	if DDRWrtCount <= 1
	then EvBuffRd  <= '0';
		 DDR3_wrt_data(31 downto 0) <= (others => '0');
		 DDR3_wrt_en 		<= '1';
		 DDR3_wrt_end 		<= '1';
	end if;
elsif DDR_Write_Seq = WrtData3
then 
	DDR3_wrt_data(31 downto 16) <= EvBuffOut;
	DDR3_wrt_en 			<= '0';
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount - 1;
	DDR3_addr 				<= DDR3_addr;
	DDR3_wrt_end 			<= '0';
	if DDRWrtCount <= 1
	then EvBuffRd  <= '0';
		 DDR3_wrt_data(15 downto 0) <= (others => '0');
		 DDR3_wrt_en 		<= '1';
		 DDR3_wrt_end 		<= '1';
	end if;
elsif DDR_Write_Seq = WrtData4
then 
	DDR3_wrt_data(15 downto 0) <= EvBuffOut;
	DDR3_wrt_en 			<= '1';
	DDR3_wrt_end 			<= '1';
	EvBuffRd 				<= '1';
	DDRAddrRd 				<= '0';
	DDRWrtCount 			<= DDRWrtCount - 1;
	DDR3_addr 				<= DDR3_addr;
	if DDRWrtCount <= 1
	then EvBuffRd  <= '0';
	end if;
end if;










--=============================  DDR READ FSM  ================================
-- Clear out any stale data from the read FIFO before starting a new block read
-- Read_Seq_FSM is (Idle,CheckEmpty,FirstCmd,CheckRdBuff0,RdWdCount,
-- 						CheckRdBuff1,RdDataHi,RdDataLo);
--case DDR_Read_Seq is
--When Idle => 
-- if WRDL = 1 and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = SDRamRdPtrLoAd)
--		 	 or uCA(9 downto 0) = BrdCstRdPtrLoAd or uCA(9 downto 0) = uBunchRdPtrLoAd)
--		then DDR_Read_Seq <= CheckEmpty;
--		else DDR_Read_Seq <= Idle;
--		end if;
--	When CheckEmpty => 
--		if SDrd_empty = '1' then DDR_Read_Seq <= FirstCmd;
--		else DDR_Read_Seq <= CheckEmpty;
--		end if;
--	When FirstCmd => 
--		if PageRdReq = '1'
--		then DDR_Read_Seq <= CheckRdBuff0;
--		else DDR_Read_Seq <= Idle;
--		end if;
--	When CheckRdBuff0 =>  
--			if SDrd_empty = '0' then DDR_Read_Seq <= RdWdCount; 
--			else DDR_Read_Seq <= CheckRdBuff0;
--			end if;
--	When RdWdCount => 
--				  if RdHi_LoSel = '0'
--				 then DDR_Read_Seq <= RdDataHi;
--			    else DDR_Read_Seq <= RdDataLo;
--				end if;
--	When CheckRdBuff1 => 
--		if SDrd_empty = '0' then DDR_Read_Seq <= RdDataHi;
--		else DDR_Read_Seq <= CheckRdBuff1;
--		end if;
--	When RdDataHi => 
--		if PageWdCount = 0 then DDR_Read_Seq <= Idle;
--		else DDR_Read_Seq <= RdDataLo;
--		end if;
--	When RdDataLo => 
-- 		   if PageWdCount /= 0 and SDrd_en = '1' then DDR_Read_Seq <= CheckRdBuff1;
--		elsif PageWdCount = 0 then DDR_Read_Seq <= Idle;
--		else DDR_Read_Seq <= RdDataLo;
--		end if;
--	When others => DDR_Read_Seq <= Idle;
--end case;










end if;
end process;

end Behavioral;