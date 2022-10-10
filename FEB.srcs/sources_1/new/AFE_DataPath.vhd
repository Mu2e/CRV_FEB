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
    din_AFE1			: in Array_8x14  
	);
end AFE_DataPath;

architecture Behavioral of AFE_DataPath is

signal BufferIn_AFE0	: Array_8x16;
signal BufferIn_AFE1	: Array_8x16;
signal BufferOut_AFE0	: Array_8x16;
signal BufferOut_AFE1	: Array_8x16;
signal wea				: std_logic_vector(0 downto 0);
signal addra, addrb		: std_logic_vector(9 downto 0);

signal Input_Seqs : In_Seq_Array_2x8;
Type In_Seq_Array_2x8 is Array(0 to 1) of In_Seq_Array;
Type In_Seq_Array is Array(0 to 7) of Input_Seq_FSM;
Type Input_Seq_FSM is (Idle,Increment,WrtChanNo,WrtTimeStamp,WrtHits,
						WrtHitWdCnt,LdNxtWrtAd);
signal In_Seq_Stat : Array_2x8;

-- Input buffer (aka AFE buffer) memory control signals
signal Buff_Rd_Ptr,NextEvAddr,Buff_Wrt_Ptr,WrtCrrntWdCntAd,WrtNxtWdCntAd,InWdCnt : Array_2x8x10;
signal NoHIts : Array_2x8;
-- Synchronous edge detectors of uC read and write strobes
signal GateReq : std_logic_vector (1 downto 0);


begin




Gen_AFEBuffer : for i in 0 to 7 generate

BufferIn_AFE0(i) <= "00" & din_AFE0(i);
BufferIn_AFE1(i) <= "00" & din_AFE1(i);

AFE0Buff : DPRAM_1Kx16
  PORT MAP ( 
	clka  => Clk_80MHz, 
	wea   => wea, 
	addra => addra,	
    dina  => BufferIn_AFE0(i),	
	
	clkb  => SysClk, -- 160 MHz
	addrb => addrb,
	doutb => BufferOut_AFE0(i)
);

AFE1Buff : DPRAM_1Kx16
  PORT MAP ( 
	clka  => Clk_80MHz, 
	wea   => wea, 
	addra => addra,	
    dina  => BufferIn_AFE1(i),	
	
	clkb  => SysClk, -- 160 MHz
	addrb => addrb,
	doutb => BufferOut_AFE1(i)
);

end generate;

Gen_Two_AFEs : for i in 0 to 1 generate
Gen_Eight_Chans : for k in 0 to 7 generate
Eight_Chans : process (Clk_80MHz, CpldRst)
begin


if CpldRst = '0' then 



	Input_Seqs(i)(k) <= Idle;
	In_Seq_Stat(i)(k) <= '0';
	
	GateReq(i) <= '0';
	WrtCrrntWdCntAd(i)(k) <= (others => '0'); 
	
	
	
elsif rising_edge (Clk_80MHz) then

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



end generate;
end generate;

end Behavioral;
