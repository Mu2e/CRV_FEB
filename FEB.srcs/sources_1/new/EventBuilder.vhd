----------------------------------------------------------------------------------
-- Company: FNAL
-- Engineer: Micol Rigatti <mrigatti@fnal.gov> 
-- 
-- Create Date: 10/25/2022 12:12:09 PM
-- Design Name: 
-- Module Name: EventBuilder - Behavioral
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


entity EventBuilder is
port (
	SysClk				: in std_logic; -- 160 MHz
	CpldRst				: in std_logic;
	ResetHi				: in std_logic;
-- Signals from/to AFE Buffer
	MaskReg				: in Array_2x8;
	BufferRdAdd			: buffer Array_2x8x10;
	BufferOut 			: in Array_2x8x16;
-- Signals from Trigger Logic
	SlfTrgEn 			: in std_logic;
	uBunchWrt			: in std_logic;
	uBunch				: in std_logic_vector(31 downto 0);
-- Signals for the DDR	
	EvBuffRd			: in std_logic;
	EvBuffOut			: out std_logic_vector(15 downto 0);
	EvBuffEmpty			: out std_logic;
	EvBuffWdsUsed		: out std_logic_vector(10 downto 0);
	asp					: in std_logic;
	
	iCD				  	: inout std_logic_vector(15 downto 0)
	);
end EventBuilder;

architecture Behavioral of EventBuilder is

Type Event_Builder_FSM is (Idle,Check_Ovf,Add_Wd_Count,Incr_Chan0,
							Check_Mask0,WdCountWrt,WrtuBunchHi,WrtuBunchLo,
							Incr_Chan1,Check_Mask1,Wait1,Wait2,WrtData);
signal Event_Builder : Event_Builder_FSM;
signal Read_Seq_Stat : std_logic_vector(3 downto 0);

-- uBunch FIFO signals
signal uBunchRd				: std_logic;
signal uBunchBuffOut		: std_logic_vector(31 downto 0);
signal uBunchBuffEmpty		: std_logic;
signal uBunchBuffFull		: std_logic;

-- Event Buffer FIFO signals
signal EvBuffDat			: std_logic_vector(15 downto 0);
signal EvBuffWrt			: std_logic;
signal EvBuffFull			: std_logic;


signal RdDone				: std_logic;
signal EvOvf 				: Array_2x8;
signal AFE_Num  			: integer range 0 to 2; 
signal Chan_Num 			: integer range 0 to 7;
signal NoHIts 				: Array_2x8;
signal NextEvAddr			: Array_2x8x10;

-- Event word count
signal EventWdCnt			: std_logic_vector (15 downto 0);
signal NxtWdCount 			: std_logic_vector (15 downto 0);
-- Signals for DDR write sequencer
signal BuffRdCount 			: std_logic_vector(8 downto 0);
signal SampleCount			: std_logic_vector(8 downto 0);

begin

-- FIFO for buffering micro bunch numbers
uBunchBuffer : SCFIFO_32x256
port map (
	rst 		=> ResetHi,
	clk 		=> SysClk,
	wr_en 		=> uBunchWrt,
	rd_en 		=> uBunchRd,
	din 		=> uBunch,
    dout 		=> uBunchBuffOut, 
    empty 		=> uBunchBuffEmpty,
	full 		=> uBunchBuffFull
);

-- FIFO for buffering one event
EventBuff : SCFIFO_1Kx16
port map (
	rst 		=> ResetHi,
	clk 		=> SysClk,
	wr_en 		=> EvBuffWrt,
	rd_en 		=> EvBuffRd,
	din 		=> EvBuffDat,
    dout		=> EvBuffOut, 
    empty 		=> EvBuffEmpty,
	full 		=> EvBuffFull,
	data_count  => EvBuffWdsUsed
);

main : process(SysClk, CpldRst)
begin 
if CpldRst = '0' then
	BufferRdAdd(0) <= (others => (others => '0'));
	BufferRdAdd(1) <= (others => (others => '0'));
	NextEvAddr(0)  <= (others => (others => '0'));
	NextEvAddr(1)  <= (others => (others => '0'));
	
	uBunchRd	  <= '0';	
	
	EvBuffWrt     <= '0';
	EvBuffDat 	  <= (others => '0');	
	
	Event_Builder <= Idle;
	
	RdDone        <= '0';
	EvOvf 		  <=(others => X"FF");
	AFE_Num 	  <= 0; 
	Chan_Num 	  <= 0;
	NoHIts 		  <= (others => X"00");
	
	EventWdCnt 	  <= (others => '0');
	NxtWdCount 	  <= (others => '0');

	BuffRdCount   <= (others => '0');
	SampleCount   <= (others => '0');
	



elsif rising_edge (SysClk) then
-- =========================================================================
-- ========================= Event Builder FSM =============================
-- =========================================================================
Case Event_Builder is
   When Idle => Read_Seq_Stat <= X"0";
	 	if SlfTrgEn = '1' and RdDone = '0' and asp = '1'
		then Event_Builder <= Check_Mask0;
		else Event_Builder <= Idle;
		end if;
	When Check_Mask0 => Read_Seq_Stat <= X"1"; 
		if MaskReg(AFE_Num)(Chan_Num) = '1' 
		  then Event_Builder <= Check_Ovf;
		 else Event_Builder <= Incr_Chan0;
		end if;
	When Check_Ovf => Read_Seq_Stat <= X"3"; 
			if EvOvf(AFE_Num)(Chan_Num) = '0' 
				then Event_Builder <= Add_Wd_Count;
			else Event_Builder <= Incr_Chan0;
			end if;
	When Incr_Chan0 => Read_Seq_Stat <= X"2"; 
			if AFE_Num = 1 and Chan_Num = 7 
				then Event_Builder <= WdCountWrt;
			else Event_Builder <= Check_Mask0;
			end if;
	When Add_Wd_Count => Event_Builder <= Incr_Chan0; Read_Seq_Stat <= X"4"; 
	When WdCountWrt => Event_Builder <= WrtuBunchHi; Read_Seq_Stat <= X"5"; 
	When WrtuBunchHi => Event_Builder <= WrtuBunchLo; Read_Seq_Stat <= X"6"; 
	When WrtuBunchLo => Event_Builder <= Check_Mask1; Read_Seq_Stat <= X"7";  
	When Check_Mask1 =>  Read_Seq_Stat <= X"8";
		if MaskReg(AFE_Num)(Chan_Num) = '1' and EvOvf(AFE_Num)(Chan_Num) = '0'
		  then Event_Builder <= Wait1;
		 else Event_Builder <= Incr_Chan1;
		end if;
	When Incr_Chan1 => Read_Seq_Stat <= X"9";
		 if AFE_Num = 1 and Chan_Num = 7
		  then Event_Builder <= Idle;
			else Event_Builder <= Check_Mask1;
			end if;
	When Wait1 =>  Read_Seq_Stat <= X"A"; 
			if NoHIts(AFE_Num)(Chan_Num) = '0' 
			 then Event_Builder <= Wait2;
			else Event_Builder <= Incr_Chan1;
		   end if;
	When Wait2 => Read_Seq_Stat <= X"B"; 
		  Event_Builder <= WrtData;
	When WrtData =>
		 if SampleCount <= 1 then Event_Builder <= Incr_Chan1;
		else Event_Builder <= WrtData;
		end if;
End Case;

for i in 0 to 1 loop
for j in 0 to 7 loop
if	BufferOut(i)(j) = 0 then NoHIts(i)(j) <= '1';
else NoHIts(i)(j) <= '0';
end if;
end loop;
end loop;


if Event_Builder = WdCountWrt
	then EvBuffDat <= EventWdCnt;
elsif Event_Builder = WrtuBunchHi
	then EvBuffDat <= uBunchBuffOut(31 downto 16);
elsif Event_Builder = WrtuBunchLo
	then EvBuffDat <= uBunchBuffOut(15 downto 0);
else EvBuffDat <= BufferOut(AFE_Num)(Chan_Num);
end if;

if Event_Builder = WdCountWrt or Event_Builder = WrtData or Event_Builder = WrtuBunchHi
	or Event_Builder = WrtuBunchLo or Event_Builder = WrtData
 then EvBuffWrt <= '1'; 
 else EvBuffWrt <= '0'; 
 end if;

-- Increment AFE number after eight channels have been read out
if Event_Builder = Incr_Chan0 or Event_Builder = Incr_Chan1 
	then 
	 if Chan_Num /= 7 then Chan_Num <= Chan_Num + 1;
		else Chan_Num <= 0; 
	  end if;
	 if Chan_Num = 7 and AFE_Num = 0 then AFE_Num <= AFE_Num + 1;
	 elsif Chan_Num = 7 and AFE_Num = 1 then AFE_Num <= 0;
	 else AFE_Num <= AFE_Num;
    end if;
 end if;

NextEvAddr(AFE_Num)(Chan_Num) <= BufferRdAdd(AFE_Num)(Chan_Num) 
									    + BufferOut(AFE_Num)(Chan_Num)(9 downto 0) + 1;

-- Assert reads when the read sequencer is requesting data
-- specify which FIFO to read with the channel number
 if SlfTrgEn = '0'
   then 	BufferRdAdd(0) <= (others => (others => '0'));
			BufferRdAdd(1) <= (others => (others => '0'));
-- If the channel has an overflow, skip ahead to the next channel
-- and advance the pointer on this channel to the next event
 elsif Event_Builder = Incr_Chan0 and MaskReg(AFE_Num)(Chan_Num) = '1' and EvOvf(AFE_Num)(Chan_Num) = '1'
		then BufferRdAdd(AFE_Num)(Chan_Num) <= NextEvAddr(AFE_Num)(Chan_Num);
  elsif BuffRdCount /= 0 
    or (Event_Builder = Check_Mask1 and MaskReg(AFE_Num)(Chan_Num) = '1' 
	 and EvOvf(AFE_Num)(Chan_Num) = '0')
	then BufferRdAdd(AFE_Num)(Chan_Num) <= BufferRdAdd(AFE_Num)(Chan_Num) + 1;
	else BufferRdAdd(AFE_Num)(Chan_Num) <= BufferRdAdd(AFE_Num)(Chan_Num);
	end if;

if Event_Builder = Idle 
	then EventWdCnt <= X"0003";
elsif Event_Builder = Incr_Chan0 and MaskReg(AFE_Num)(Chan_Num) = '1' and EvOvf(AFE_Num)(Chan_Num) = '0'
	then EventWdCnt <= EventWdCnt + BufferOut(AFE_Num)(Chan_Num); -- BuffOut_Mux; 
	else EventWdCnt <= EventWdCnt;
end if;

NxtWdCount <= EventWdCnt + BufferOut(AFE_Num)(Chan_Num);

if Event_Builder = Idle 
	then EvOvf <= (others => X"00");
elsif Event_Builder = Check_Ovf and MaskReg(AFE_Num)(Chan_Num) = '1' 
then 
	if NxtWdCount >= PageSize
	then EvOvf(AFE_Num)(Chan_Num) <= '1';
	else EvOvf <= EvOvf;
	end if;
else EvOvf <= EvOvf;
end if;

-- Count down the words stored in the uBunch event for this channel
if Event_Builder = Check_Mask1 and MaskReg(AFE_Num)(Chan_Num) = '1' and EvOvf(AFE_Num)(Chan_Num) = '0' 
	then SampleCount <= BufferOut(AFE_Num)(Chan_Num)(8 downto 0);
elsif Event_Builder = WrtData and SampleCount /= 0
then SampleCount <= SampleCount - 1;
else SampleCount <= SampleCount;
end if;
-- The same as above but with slightly different conditions
if Event_Builder = Check_Mask1 and MaskReg(AFE_Num)(Chan_Num) = '1' and EvOvf(AFE_Num)(Chan_Num) = '0' 
	then BuffRdCount <= BufferOut(AFE_Num)(Chan_Num)(8 downto 0); 
elsif (Event_Builder = WrtData or Event_Builder = Wait1 or Event_Builder = Wait2) and BuffRdCount /= 0
then BuffRdCount <= BuffRdCount - 1;
else BuffRdCount <= BuffRdCount;
end if;

-- Read the uBunch number after calculating and writing the event word count.
if Event_Builder = WrtuBunchLo or (SlfTrgEn = '0' and uBunchBuffEmpty = '0') 
	then uBunchRd <= '1';
else uBunchRd <= '0';
end if;

-- flag used to signal end of read out across clock domains
if Event_Builder = Incr_Chan1 and AFE_Num = 1 and Chan_Num = 7 
	then RdDone <= '1';
else RdDone <= '0';
end if;


end if;
end process;


end Behavioral;