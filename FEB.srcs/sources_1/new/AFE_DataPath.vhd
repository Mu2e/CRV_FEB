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
  -- Data output from the deserializer for AFE0 and AFE1 synchronized to 80 MHz clock
    din_AFE0			: in Array_8x14; 
    din_AFE1			: in Array_8x14;
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
signal FrDat 			: Array_2x6;
signal SlfTrgEdge 		: Array_2x8x2;
signal ADCSmplCntr 		: Array_2x8x4;

signal din_AFE			: Array_2x8x14;   -- 2 AFE x 8 channels x 14 bits
signal BufferIn 		: Array_2x8x16;   -- 2 AFE x 8 channels x 16 bits
signal BufferOut		: Array_2x8x16;   -- 2 AFE x 8 channels x 16 bits
signal BufferWE			: Array_2x8;	  -- 2 AFE x 8 channels
signal BufferWrtAdd		: Array_2x8x10;   -- 2 AFE x 8 channels: address 10 bits for 1024 depth of RAM
signal BufferRdAdd		: Array_2x8x10;   -- 2 AFE x 8 channels: address 10 bits for 1024 depth of RAM


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
signal TrigReq			: std_logic;

-- Synchronous edge detectors of uC read and write strobes
signal RDDL, uRDDL, WRDL, uWRDL : std_logic_vector(1 downto 0);


-- Input buffer (aka AFE buffer) memory control signals
signal Buff_Rd_Ptr,NextEvAddr,Buff_Wrt_Ptr,WrtCrrntWdCntAd,WrtNxtWdCntAd : Array_2x8x10;
signal NoHIts : Array_2x8;
-- Synchronous edge detectors of uC read and write strobes
signal GateReq : std_logic_vector (1 downto 0);


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

	Input_Seqs(i)(k) 	  <= Idle;
	In_Seq_Stat(i)(k) 	  <= '0';
	
	
	InWdCnt(i)(k) 		  <= (others => '0');
	uBunchOffset(i) 	  <= (others => '0');

	GateReq(i) <= '0';
	WrtCrrntWdCntAd(i)(k) <= (others => '0'); 

	
	
elsif rising_edge (Clk_80MHz) then

-- Use this counter to append time since microbunch start to the ADC data
--if TrigReq = '1' and GateWidth(i) = 0 
--	then uBunchOffset(i) <= (others => '0');
--elsif GateWidth(i) /= 0 and FRDat(i) = 0 
--	then uBunchOffset(i) <= uBunchOffset(i) + 1;
--else 
--	uBunchOffset(i) <= uBunchOffset(i);
--end if;





-- FSM to build the Data Packet 
-- Input Sequencer (i: 0->1, k: 0->7)
-- (Idle,Increment,WrtChanNo,WrtTimeStamp,WrtHits,WrtHitWdCnt,LdNxtWrtAd);
case Input_Seqs(i)(k) is
	When Idle =>
	 if GateReq(i) = '1'
	  then Input_Seqs(i)(k) <= Increment;
	 else  Input_Seqs(i)(k) <= Idle;
	  end if;
	When Increment => 
	Input_Seqs(i)(k) <= WrtChanNo;
	When WrtChanNo =>
	 if FRDat(i) = 0 and SlfTrgEdge(i)(k) = 1 
	  then Input_Seqs(i)(k) <= WrtTimeStamp;
	 elsif GateWidth(i) = 0
	  then Input_Seqs(i)(k) <= WrtHitWdCnt;
	 else  Input_Seqs(i)(k) <= WrtChanNo;
	 end if;
	When WrtTimeStamp => 
	Input_Seqs(i)(k) <= WrtHits;
	When WrtHits =>
	 if ADCSmplCntr(i)(k) = 0 
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

If Input_Seqs(i)(k) <= Idle 
then In_Seq_Stat(i)(k) <= '0';
else In_Seq_Stat(i)(k) <= '1';
end if;

-- Store present write pointer so a leading word count can be stored at the end of the microbunch
if Input_Seqs(i)(k) = Increment 
then WrtCrrntWdCntAd(i)(k) <= Buff_Wrt_Ptr(i)(k);
else WrtCrrntWdCntAd(i)(k) <= WrtCrrntWdCntAd(i)(k);
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

if Input_Seqs(i)(k) = WrtChanNo
	then BufferIn(i)(k) <= ControllerNo & PortNo & GA & ChanArray(8*i+k);
elsif Input_Seqs(i)(k) = WrtTimeStamp 
	then BufferIn(i)(k) <= ADCSmplCntReg & uBunchOffset(i);
  elsif Input_Seqs(i)(k) = WrtHitWdCnt 
	then BufferIn(i)(k) <= X"0" & "00" & InWdCnt(i)(k);
  else
	 BufferIn(i)(k) <= "00" & din_AFE(i)(k);
 end if;


-- Event word counter
if Input_Seqs(i)(k) = Idle 
	then InWdCnt(i)(k) <= (others => '0');
elsif Input_Seqs(i)(k) = WrtTimeStamp or Input_Seqs(i)(k) = WrtChanNo or Input_Seqs(i)(k) = WrtHits
	then InWdCnt(i)(k) <= InWdCnt(i)(k) + 1;
end if;


end if;
 
end process;

end generate;
end generate;

end Behavioral;
