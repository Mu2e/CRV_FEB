----------------------------------------------------------------------------------
-- Company: FNAL
-- Engineer: Micol Rigatti <mrigatti@fnal.gov> 
-- 
-- Create Date: 09/12/2022 12:12:09 PM
-- Design Name: 
-- Module Name: AFE_DataPath - Behavioral
-- Project Name: CRV FEB
-- Target Devices: xc7s50fgga484-2
-- Tool Versions: 2021.2
-- Description: 
-- 
----------------------------------------------------------------------------------

--============ DATA FORMAT ===================
-- -------------------------------------------
-- | Channel (16 bit)                        | 
-- -------------------------------------------
-- | N sample (4 bit) timestamp (12 bit)     |
-- -------------------------------------------
-- | ADC sample [N_sample times: 16-bits of  |
-- | ADC sample, the highest 4 bits are zero |
-- | b0000 + 12-bit-ADC-value]               |
-- -------------------------------------------
 

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

use work.Proj_Def.all;

entity AFE_DataPath is
  Port (
	Clk_80MHz			: in std_logic; 
	SysClk				: in std_logic; -- 160 MHz
	TrigReq				: in std_logic;
-- Data output from the deserializer for AFE0 and AFE1 synchronized to 80 MHz clock
    din_AFE0			: in Array_8x14; 
    din_AFE1			: in Array_8x14;
    done				: in std_logic_vector(1 downto 0); -- status of automatic alignment FSM
-- Microcontroller strobes
	CpldRst				: in std_logic;
	CpldCS				: in std_logic;
	uCRd				: in std_logic;
	uCWr 				: in std_logic;
-- Microcontroller data and address buses	
	uCA 				: in std_logic_vector(11 downto 0);
	uCD 				: inout std_logic_vector(15 downto 0);
-- Geographic address pins
	GA 					: in std_logic_vector(1 downto 0)
	);
end AFE_DataPath;

architecture Behavioral of AFE_DataPath is

signal Clk100MHz		: std_logic;
signal ADCSmplCntr 		: Array_2x8x4;

signal din_AFE			: Array_2x8x14;   -- 2 AFE x 8 channels x 14 bits
signal BufferIn 		: Array_2x8x16;   -- 2 AFE x 8 channels x 16 bits
signal BufferOut		: Array_2x8x16;   -- 2 AFE x 8 channels x 16 bits
signal BufferWE			: Array_2x8;	  -- 2 AFE x 8 channels
signal BufferWrtAdd		: Array_2x8x10;   -- 2 AFE x 8 channels: address 10 bits for 1024 depth of RAM
signal BufferRdAdd		: Array_2x8x10;   -- 2 AFE x 8 channels: address 10 bits for 1024 depth of RAM
signal WrtPtrRst		: std_logic_vector (1 downto 0);

Type Input_Seq_FSM is (Idle,Increment,WrtChanNo,WrtTimeStamp,WrtHits,
						WrtHitWdCnt,LdNxtWrtAd);
Type In_Seq_Array is Array(0 to 7) of Input_Seq_FSM;						
Type In_Seq_Array_2x8 is Array(0 to 1) of In_Seq_Array;
signal Input_Seqs : In_Seq_Array_2x8;						
signal In_Seq_Stat : Array_2x8;


signal ADCSmplCntReg 	: std_logic_vector (3 downto 0);
signal ControllerNo 	: std_logic_vector (4 downto 0);
signal PortNo 			: std_logic_vector (4 downto 0);
signal InWdCnt 			: Array_2x8x10;
signal uBunchOffset 	: Array_2x12;
signal GateWidth	    : Array_2x12;
signal GateReq 			: std_logic_vector (1 downto 0);
signal BeamOn  			: std_logic;

signal BeamOnLength 	: std_logic_vector (11 downto 0);
signal BeamOffLength 	: std_logic_vector (11 downto 0);

-- Synchronous edge detectors of uC read and write strobes
signal RDDL, uRDDL, WRDL, uWRDL : std_logic_vector(1 downto 0);
signal MaskReg			: Array_2x8;
signal iWrtDL 			: Array_2x2;

-- Input buffer (aka AFE buffer) memory control signals
signal WrtCrrntWdCntAd 	: Array_2x8x10;
signal WrtNxtWdCntAd 	: Array_2x8x10;
signal Buff_Rd_Ptr,NextEvAddr,Buff_Wrt_Ptr : Array_2x8x10;
signal NoHIts : Array_2x8;


begin

din_AFE(0)	<= din_AFE0;
din_AFE(1)  <= din_AFE1;


-- Clk100 : process(Clk100MHz, CpldRst)
-- begin 
-- -- asynchronous reset/preset
-- if CpldRst = '0' then
-- 
-- 	uWRDL <= "00"; 
-- 	uRDDL <= "00";
-- 	
-- elsif rising_edge (Clk100MHz) then 
-- 
-- -- Synchronous edge detectors for read and write strobes
-- uRDDL(0) <= not uCRD and not CpldCS;
-- uRDDL(1) <= uRDDL(0);
-- 
-- uWRDL(0) <= not uCWR and not CpldCS;
-- uWRDL(1) <= uWRDL(0);
-- 
-- -- Extraction of ControllerNo (5 bits) and Port Number (5 bits)
-- -- from the microcontroller register
-- if uWRDL = 1 and uCA(9 downto 0) =  FEBAddresRegAd then 
-- 	ControllerNo <= uCD(12 downto 8); 
-- 	PortNo <= uCD(4 downto 0);
-- else
--     ControllerNo <= ControllerNo;
-- 	PortNo <= PortNo;
-- end if;
-- 
-- -- Specifiy the number of ADC samples per hit
-- if uWRDL = 1 and uCA(9 downto 0) = ADCSmplCntrAd then 
-- 	ADCSmplCntReg <= uCD(3 downto 0);
-- else 
-- 	ADCSmplCntReg <= ADCSmplCntReg;
-- end if;
-- 
-- end process Clk100;



Gen_Two_AFEs : for i in 0 to 1 generate
Gen_Eight_Chans : for k in 0 to 7 generate


AFEBuff : DPRAM_1Kx16
  PORT MAP ( 
	clka  => Clk_80MHz, 
	wea   => BufferWE(i)(k downto k), 
	addra => BufferWrtAdd(i)(k),	
    dina  => BufferIn(i)(k),	
	
	clkb  => SysClk, -- 160 MHz
	addrb => BufferRdAdd(i)(k),
	doutb => BufferOut(i)(k)
);



Eight_Chans : process (Clk_80MHz, CpldRst)
begin


if CpldRst = '0' then 

	BufferWE(i)(k)		  <= '0'; 
	BufferWrtAdd(i)(k)	  <= (others => '0'); 
	BufferRdAdd(i)(k)	  <= (others => '0'); 
	WrtPtrRst(i) 		  <= '0';
	WrtCrrntWdCntAd(i)(k) <= (others => '0');
	WrtNxtWdCntAd(i)(k)   <= (others => '0'); 
	
	Input_Seqs(i)(k) 	  <= Idle;
	In_Seq_Stat(i)(k) 	  <= '0';
	
	MaskReg(i) 			  <= X"FF";
	iWrtDL(i) 			  <= "00";
	InWdCnt(i)(k) 		  <= (others => '0');
	uBunchOffset(i) 	  <= (others => '0');
	ADCSmplCntr(i)(k) 	  <= "0000";
	ADCSmplCntReg 		  <= X"8";

	GateReq(i) 			  <= '0';
	GateWidth(i) 		  <= (others => '0'); 
	BeamOn 				  <= '0'; 
	BeamOnLength 		  <= X"050"; 
	BeamOffLength 		  <= X"700";	
	
	
-- Simulation 	
	ControllerNo		  <= "11010";
	PortNo                <= "11011";
 
	
elsif rising_edge (Clk_80MHz) then

-- Use this counter to append time since microbunch start to the ADC data
--if TrigReq = '1' and GateWidth(i) = 0 
--	then uBunchOffset(i) <= (others => '0');
--elsif GateWidth(i) /= 0 and FRDat(i) = 0 
--	then uBunchOffset(i) <= uBunchOffset(i) + 1;
--else 
--	uBunchOffset(i) <= uBunchOffset(i);
--end if;

-- Synchronous edge detector for uC write strobe w.r.t. deserializer output clock
iWrtDL(i)(0) <= not CpldCS and not uCWR;
iWrtDL(i)(1) <= iWrtDL(i)(0);

-- Hold Gate request high until the next complete ADC sample is available
if GateReq(i) = '0' and GateWidth(i) = 0 and TrigReq = '1'
then 
	GateReq(i) <= '1'; 
elsif GateReq(i) = '1' and GateWidth(i) /= 0
then GateReq(i) <= '0';
else GateReq(i) <= GateReq(i);
end if;

if GateWidth(i) = 0 and GateReq(i) = '1' and BeamOn = '1'
then 
	GateWidth(i) <= BeamOnLength;
elsif GateWidth(i) = 0 and GateReq(i) = '1' and BeamOn = '0'
then 
	GateWidth(i) <= BeamOffLength;
elsif GateWidth(i) /= 0
then 
	GateWidth(i) <= GateWidth(i) - 1;
else 
	GateWidth(i) <= GateWidth(i);
end if;


-- =========================================================================
-- ================================== FSM ==================================
-- =========================================================================
-- FSM to build the Data Packet 
-- Input Sequencer (i: 0->1, k: 0->7)
-- (Idle,Increment,WrtChanNo,WrtTimeStamp,WrtHits,WrtHitWdCnt,LdNxtWrtAd);
case Input_Seqs(i)(k) is
	When Idle =>
	 if (GateReq(i) = '1' and done(i) = '1')
	  then Input_Seqs(i)(k) <= Increment;
	 else  Input_Seqs(i)(k) <= Idle;
	  end if;
	When Increment => 
	Input_Seqs(i)(k) <= WrtChanNo;
	When WrtChanNo =>
	 if GateWidth(i) = 0
	  then Input_Seqs(i)(k) <= WrtHitWdCnt;
	 else  Input_Seqs(i)(k) <= WrtTimeStamp;
	 end if;
	When WrtTimeStamp => 
	Input_Seqs(i)(k) <= WrtHits;
	When WrtHits =>
	 if ADCSmplCntr(i)(k) = 1 
	  then Input_Seqs(i)(k) <= WrtChanNo;
	 elsif GateWidth(i) = 0 
	  then Input_Seqs(i)(k) <= WrtHitWdCnt;
	 else  Input_Seqs(i)(k) <= WrtHits;
	 end if;
	When WrtHitWdCnt => 
	Input_Seqs(i)(k) <= LdNxtWrtAd;
	When LdNxtWrtAd => 
	Input_Seqs(i)(k) <= Idle;
end case;


-- Set BufferWE 
if (Input_Seqs(i)(k) = WrtHits or 
    Input_Seqs(i)(k) = WrtChanNo or
    Input_Seqs(i)(k) = WrtTimeStamp or
    Input_Seqs(i)(k) = WrtHitWdCnt)
    and MaskReg(i)(k) = '1' then 
		BufferWE(i)(k) <= '1';
else 
		BufferWE(i)(k) <= '0';
end if;
-- Channel mask register.
if iWrtDL(i) = 1 and uCA(11 downto 10) = GA and uCA(9 downto 0) = InputMaskAddr
then MaskReg(i) <= uCD(8*i+7 downto 8*i); 
else MaskReg(i) <= MaskReg(i);
end if;

--============ DATA FORMAT ===================
-- -------------------------------------------
-- | Channel (16 bit)                        | 
-- -------------------------------------------
-- | N sample (4 bit) timestamp (12 bit)     |
-- -------------------------------------------
-- | ADC sample [N_sample times: 16-bits of  |
-- | ADC sample, the highest 4 bits are zero |
-- | b0000 + 12-bit-ADC-value]               |
-- -------------------------------------------

-- Channel (16 bits) = ControllerNo (5 bits) + Port Number (5 bits) +
-- geo address (2 bits of which FPGA on a FEB) + channel (4 bits)

if Input_Seqs(i)(k) <= Idle 
then 
	In_Seq_Stat(i)(k) <= '0';
	InWdCnt(i)(k) <= (others => '0');
	BufferIn(i)(k) <= "00" & din_AFE(i)(k);
elsif Input_Seqs(i)(k) = Increment 
then 
	WrtCrrntWdCntAd(i)(k) <= BufferWrtAdd(i)(k); -- Store present write pointer so a leading word count can be stored at the end of the microbunch
	In_Seq_Stat(i)(k) <= '1';
	BufferIn(i)(k) <= "00" & din_AFE(i)(k);
elsif Input_Seqs(i)(k) = WrtChanNo 
then 		
	BufferWrtAdd(i)(k) <= BufferWrtAdd(i)(k) + 1; -- Increment Writing Address
	ADCSmplCntr(i)(k) <= ADCSmplCntReg;
	InWdCnt(i)(k) <= InWdCnt(i)(k) + 1;			  -- Increment Event word counter
	BufferIn(i)(k) <= ControllerNo & PortNo & GA & ChanArray(8*i+k);
	WrtCrrntWdCntAd(i)(k) <= WrtCrrntWdCntAd(i)(k);
elsif Input_Seqs(i)(k) = WrtTimeStamp 
then 		
	BufferWrtAdd(i)(k) <= BufferWrtAdd(i)(k) + 1; -- Increment Writing Address
	InWdCnt(i)(k) <= InWdCnt(i)(k) + 1;			  -- Increment Event word counter
	BufferIn(i)(k) <= ADCSmplCntReg & uBunchOffset(i);
elsif Input_Seqs(i)(k) = WrtHitWdCnt 
then 		
	WrtNxtWdCntAd(i)(k) <= BufferWrtAdd(i)(k) + 1; -- After writing the leading word count the pointer needs to go to the end of the event
	BufferWrtAdd(i)(k) <= WrtCrrntWdCntAd(i)(k);
	BufferIn(i)(k) <= X"0" & "00" & InWdCnt(i)(k);
elsif Input_Seqs(i)(k) = WrtHits 
then 		
	BufferWrtAdd(i)(k) <= BufferWrtAdd(i)(k) + 1; -- Increment Writing Address
	ADCSmplCntr(i)(k) <= ADCSmplCntr(i)(k) - 1;	  -- Decrement ADC Sample Counter
	InWdCnt(i)(k) <= InWdCnt(i)(k) + 1;			  -- Increment Event word counter
	BufferIn(i)(k) <= "00" & din_AFE(i)(k);
elsif Input_Seqs(i)(k) = LdNxtWrtAd 
then 
	BufferWrtAdd(i)(k) <= WrtNxtWdCntAd(i)(k);
else 
	BufferIn(i)(k) <= "00" & din_AFE(i)(k);
	WrtCrrntWdCntAd(i)(k) <= WrtCrrntWdCntAd(i)(k);
	In_Seq_Stat(i)(k) <= '1';
end if;


-- =========================================================================
-- =========================== END OF FSM ==================================
-- =========================================================================



end if;
 
end process;

end generate;
end generate;

end Behavioral;
