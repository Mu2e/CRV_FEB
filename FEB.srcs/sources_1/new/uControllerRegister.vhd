----------------------------------------------------------------------------------
-- Company: FNAL
-- Engineer: Micol Rigatti <mrigatti@fnal.gov>
-- 
-- Create Date: 11/23/2022 09:05:03 AM
-- Design Name: 
-- Module Name: 
-- Project Name: CRV FEB
-- Target Devices: xc7s50fgga484-2
-- Tool Versions: 2021.2
-- Description: 

----------------------------------------------------------------------------------

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

use work.Proj_Def.all;

entity uControllerRegister is
port(
	Clk_100MHz	 			: in std_logic;	
	ResetHi	 				: in std_logic;
	-- AFE serial control lines
	AFEPDn 				    : buffer std_logic_vector(1 downto 0);
	AFECS 				    : buffer std_logic_vector(1 downto 0);
	AFESClk, AFESDI  	    : buffer std_logic;
	AFESDO 				    : in std_logic;
	-- Microcontroller strobes
	CpldRst					: in std_logic;
	CpldCS					: in std_logic;
	uCRd					: in std_logic;
	uCWr 					: in std_logic;
	-- Microcontroller data and address buses
	uCA 					: in std_logic_vector(11 downto 0);
	uCD 					: inout std_logic_vector(15 downto 0);
	-- Geographic address pins
	GA 						: in std_logic_vector(1 downto 0);
	-- Analog Mux address lines
	MuxEn 					: buffer std_logic_vector(3 downto 0);
	Muxad 					: buffer std_logic_vector(1 downto 0);	
	-- Serial DAC control lines
	DACCS 					: buffer std_logic_vector(2 downto 0);
	DACClk 					: buffer std_logic;
	DACDat 					: buffer std_logic;
	DACLd 					: buffer std_logic;
	
	uAddrReg 				: inout std_logic_vector(11 downto 0);	
	uWRDL 					: inout std_logic_vector(1 downto 0);
	uRDDL 					: inout std_logic_vector(1 downto 0);

	done		            : in std_logic_vector(1 downto 0); 
	
	TrgSrc					: inout std_logic;
	ADCSmplCntReg 			: inout std_logic_vector (3 downto 0);
	ControllerNo 			: inout std_logic_vector (4 downto 0);
	PortNo 		 			: inout std_logic_vector (4 downto 0);
	FMTxBuff_wreq			: out std_logic;
	PipelineSet				: inout std_logic_vector (7 downto 0);
	
	iCD				  		: inout std_logic_vector(15 downto 0)
  );
end uControllerRegister;

architecture behavioural of uControllerRegister is


-- Signals used by the current sense multiplexer
signal MuxSelReg : std_logic_vector(2 downto 0);
signal MuxadReg : std_logic_vector(1 downto 0);

-- Timing interval counters
signal Counter1us  : std_logic_vector (7 downto 0);
signal Counter10us : std_logic_vector (10 downto 0);
signal Counter1ms  : std_logic_vector (17 downto 0); 
signal Count100ms  : std_logic_vector (6 downto 0);
signal Counter1s   : std_logic_vector (27 downto 0);


signal TestCount   : std_logic_vector (31 downto 0);
signal UpTimeCount : std_logic_vector (31 downto 0);
signal UpTimeStage : std_logic_vector (31 downto 0);

-- Dac control signals
signal BiasActual : Array_2x12;
signal BiasTarget : Array_2x12;
signal RampGate   : std_logic_vector (1 downto 0);
signal ClkDiv 	  : std_logic_vector (2 downto 0);
signal BitCount   : std_logic_vector (4 downto 0);
signal DACShift   : std_logic_vector (23 downto 0);
signal AFERdReg   : std_logic_vector (15 downto 0);
Type  Serializer_FSM is (Idle,Shift,ClearSync,SetLoad);
Signal Octal_Shift : Serializer_FSM;


-- Signals for aligning RxOutClks
Type AlignSeq_Type is (Idle,SendPDn,SendPEn,SendRst,WaitFR,CheckFR,RstCntr);
signal AlignSeq : AlignSeq_Type;

signal uSecCounter : std_logic_vector (8 downto 0);
--signal AFESel 	  : std_logic_vector (1 downto 0);
signal AlignReq    : std_logic_vector (1 downto 0);
signal SlipCntReg  : Array_2x3;

-- Octal DAC buffer FIFO control signals
signal ODFifoEmpty : std_logic;
signal ODFifoWrReq : std_logic;
signal ODFifoRdReq : std_logic;
-- Octal DAC shadow RAM signals
signal ShadowWrt   : std_logic_vector (0 downto 0);
signal ShadowOut   : std_logic_vector (15 downto 0);
signal SClkDL 	   : std_logic_vector (2 downto 0); 
signal ODFifoData  : std_logic_vector (27 downto 0);
signal ODFifoOut   : std_logic_vector (27 downto 0);

-- Octal DAC buffer FIFO control signals
--signal ODFifoRdReq,ODFifoWrReq,ODFifoEmpty,Dev_Sel : std_logic;
signal Dev_Sel	   : std_logic;

Type OD_WriteState is (Idle, SetAFESel0, WrtAFE0, SetAFESel1, WrtAFE1); 
signal OD_Write : OD_WriteState;

begin

-- FIFO for queueing serial data destined for AFEs and DACs
CmdFifo : Cmd_FIFO
  port map (
	clk 	=> Clk_100MHz, 
	rst 	=> ResetHi,
    wr_en 	=> ODFifoWrReq,
	rd_en 	=> ODFifoRdReq,
    din 	=> ODFifoData,
    dout 	=> ODFifoOut,
    empty 	=> ODFifoEmpty
);
	
-- Ram for storing DAC values for readback
ShadowRam : DAC_Ram
port map (
	clka 	=> Clk_100MHz,
    wea 	=> ShadowWrt,
    addra 	=> uCA(7 downto 0),
    dina 	=> uCD,
    douta 	=> ShadowOut
);

	
main : process (Clk_100MHz, CpldRst)
begin 
if CpldRst = '0' then
-- Control bits written by the uC
	--DACCS <= "111"; 
	RampGate <= "00";
	BiasTarget <= (others => X"000"); 
	BiasActual <= (others => X"000"); 
	DACLd <= '1'; 
	DACClk <= '1'; 
	DACDat <= '0'; 
	Dev_Sel <= '0'; 
	DACShift <= (others => '0'); 
	Octal_Shift <= Idle;
	ClkDiv <= (others => '0');
	BitCount <= "00000"; 
	ODFifoWrReq <= '0'; 
	ODFifoRdReq <= '0'; 
	ODFifoData <= (others => '0'); 
	TrgSrc <= '0'; 
	PipelineSet <= X"04";  
	--WidthReg <= X"10";
	--
	--TrigType <= X"000";	
	FMTxBuff_wreq <= '0'; 
	--Hist_wenb <= (others => "0"); 
	--HistAddrb <= (others => (others => '0')); 
	--Hist_Datb <= (others => (others => '0'));  
	--Hist_Offset_Reg <= (X"FF6");
	--Count100ms <= (others => '0'); 
	ADCSmplCntReg <= X"8"; 
	ControllerNo <= "00000"; 
	PortNo <= "00000"; 
	--
	MuxEn <= X"0"; 
	Muxad <= "00"; 
	MuxSelReg <= "000"; 
	MuxadReg <= "00";
	
	UpTimeStage <= (others => '0'); 
	UpTimeCount <= (others => '0');
	Counter1us <= X"00"; -- 1us time base 
	Counter10us <= (others => '0');
	Counter1ms <= (others => '0');
	Counter1s <= (others => '0');	
	TestCount <= (others => '0'); 

	--ResetCount <= (others => '0'); 
	--DDR_Reset <= '0'; 
	AFEPDn <= "11"; 
	AFECS <= "11"; 
	AFESDI <= '0'; 
	--StatReg <= X"0";
	AFESClk <= '0'; 
	SClkDL <= "000"; 
	AFERdReg <= (others => '0');
	--GPOSel <= '0'; 
	--HistEnReq <= "00"; 
	--uAddrReg <= (others => '0');
	--HistInterval <= X"0800"; 
	--HistMode <= '0'; 
	--HistChan <= "000"; 
	--HistEn <= "00"; 
	--HistGateCnt0 <= (others => '0');	
	--HistGateCnt1 <= (others => '0'); 
	
-- Signals for aligning RxOutClks
	AlignReq <= "00"; 
	AlignSeq <= Idle;
	SlipCntReg <= ("000","000"); 
	uSecCounter <= (others => '0'); 

	
elsif rising_edge (Clk_100MHz) then 

------------------ Various prameter storage registers ---------------------

-- Specifiy the number of ADC samples per hit
if uWRDL = 1 and uCA(9 downto 0) = ADCSmplCntrAd 
 then ADCSmplCntReg <= uCD(3 downto 0);
 else ADCSmplCntReg <= ADCSmplCntReg;
end if;

-- Strobe to write data to L:VDS FM return link
if uWRDL = 1 and uCA(11 downto 10) = GA and uCA(9 downto 0) = LVDSTxFIFOAd 
 then FMTxBuff_wreq <= '1';
 else FMTxBuff_wreq <= '0';
end if;

-- Register for defining the geographical address of the FEB
if uWRDL = 1 and uCA(9 downto 0) =  FEBAddresRegAd then 
	ControllerNo <= uCD(12 downto 8); 
	PortNo 		 <= uCD(4 downto 0);
else
	ControllerNo <= ControllerNo;
	PortNo 		 <= PortNo;
end if;


-- Pipeline delay setting 
if uWRDL = 1 and uCA(9 downto 0) = PipeLineAddr 
then PipelineSet <= uCD(7 downto 0);
else PipelineSet <= PipelineSet;
end if;
-- =======================================================
-- ====================  CHECK ===========================
-- =======================================================

-- Timer to set width of DDR MIG reset
--if uWRDL = 1 and uCD(3) = '1' and ResetCount = 0 
-- and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = CSRRegAddr)
--    or uCA(9 downto 0) = CSRBroadCastAd)
--then ResetCount <= X"F";
--elsif ResetCount /= 0 then ResetCount <= ResetCount - 1;
--end if;
--
---- MIG Reset
--if ResetCount /= 0 then DDR_Reset <= '1';
--else DDR_Reset <= '0';
--end if;

-- AFE power down control bits
if uWRDL = 1 and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = CSRRegAddr)
						or uCA(9 downto 0) = CSRBroadCastAd)
then AFEPDn <= uCD(1 downto 0);
else AFEPDn <= AFEPDn;
end if;

-- Select between LEMO and LVDS inputs for the triggers 
if uWRDL = 1 and uCA(9 downto 0) = TrigCtrlAddr 
then TrgSrc <= uCD(1);
else TrgSrc <= TrgSrc;
end if;

-- Analog multiplexer control lines
if uWRDL = 1 and  uCA(11 downto 10) = GA and uCA(9 downto 0) = MuxCtrlAd then 
	Case uCD(4 downto 2) is
		When "100" => MuxEn <= "0001";
		When "101" => MuxEn <= "0010";
		When "110" => MuxEn <= "0100";
		When "111" => MuxEn <= "1000";
		When others => MuxEn <= "0000";
	end case;
-- Remap select lines since layout channel ordering is not monotonic
		Case uCD(1 downto 0) is
		When "00" => MuxAd <= "11";
		When "01" => MuxAd <= "00";
		When "10" => MuxAd <= "10";
		When "11" => MuxAd <= "01";
		When others => MuxAd <= "00";
	end case;
	MuxadReg <= uCD(1 downto 0);
	MuxSelReg <= uCD(4 downto 2);
 else 
	MuxEn <= MuxEn;
	Muxad <= Muxad;
	MuxadReg <= MuxadReg;
	MuxSelReg <= MuxSelReg;
end if;

-- 10us time base
if Counter10us /= Count10us then Counter10us <= Counter10us + 1;
else Counter10us <= (others => '0');
end if;

-- 1ms time base
if Counter1ms = Count1ms then Counter1ms <= (others => '0');
else Counter1ms <= Counter1ms + 1;
end if;

-- 1us time base
if Counter1us = Count1us 
then Counter1us <= X"00";
else Counter1us <= Counter1us + 1;
end if;

-- 1 second time base
if	Counter1s /= Count1s then Counter1s <= Counter1s + 1;
else Counter1s <= (others => '0');
end if;

-- Uptime in seconds since th last FPGA configure
if	Counter1s = Count1s 
then UpTimeCount <= UpTimeCount + 1;
else UpTimeCount <= UpTimeCount;
end if;
-- Register for staging uptime count
if CpldCS = '1' 
then UpTimeStage <= UpTimeCount;
else UpTimeStage <= UpTimeStage;
end if;

-- Testcounter counter is writeable. For each read of the lower half, the entire
-- 32 bit counter increments
if uWRDL = 1 and  uCA(11 downto 10) = GA and uCA(9 downto 0) = TestCounterHiAd 
	 then TestCount <= uCD & TestCount(15 downto 0);
		elsif uWRDL = 1 and  uCA(11 downto 10) = GA and uCA(9 downto 0) = TestCounterLoAd 
    then TestCount <= TestCount(31 downto 16) & uCD;
      elsif uRDDL = 2 and uAddrReg(11 downto 10) = GA and uAddrReg(9 downto 0) = TestCounterLoAd 
    then TestCount <= TestCount + 1;
      else TestCount <= TestCount;
end if;

-------------- Serializer for Bias Trim, Bias Bus, VGain DACs, AFE setup registers -------------

-- Clock runs at 159 MHz, serial data bit period is SysClk div 8
ClkDiv <= ClkDiv + 1;

-- Bias voltage ramping logic
-- Write the bias target registers
if uWRDL = 1 and uCA(11 downto 10) = GA and uCA(9 downto 0) = ("00" & X"44")
 then BiasTarget(0) <= uCD(11 downto 0);
 else BiasTarget(0) <= BiasTarget(0);
end if;

if uWRDL = 1 and uCA(11 downto 10) = GA and uCA(9 downto 0) = ("00" & X"45")
 then BiasTarget(1) <= uCD(11 downto 0);
 else BiasTarget(1) <= BiasTarget(1);
end if;

-- If the present bias value and the target bias value differ, bring the
-- present bias value closer to the target by one count every millisecond.
-- Uee the rampgate signal to force one write when the actual = the target.

for i in 0 to 1 loop

if BiasTarget(i) /= BiasActual(i) then RampGate(i) <= '1';
elsif BiasTarget(i) = BiasActual(i) and ODFifoWrReq = '1'
then RampGate(i) <= '0';
else RampGate(i) <= RampGate(i);
end if;

if BiasTarget(i) /= BiasActual(i) and Counter1ms = 4
	then
	     if BiasTarget(i) < BiasActual(i) then BiasActual(i) <= BiasActual(i) - 1;
	  elsif BiasTarget(i) > BiasActual(i) then BiasActual(i) <= BiasActual(i) + 1;
		end if;
 end if;
 
end loop;


-- (Idle,SendPDn,SendPEn,SendRst,WaitFR,CheckFR,ChkSlipCnt,SendSlipReq);
case AlignSeq is
	when Idle => 
	 if AlignReq /= 0 and Counter1us = Count1us
		then AlignSeq <= SendPDn;
	 else AlignSeq <= Idle;
	 end if;
	when SendPDn => 
	  if Counter1us = Count1us and uSecCounter = 335
		 then AlignSeq <= SendPEn;
	  elsif AlignReq = 0 then
	    AlignSeq <= Idle;
	   else AlignSeq <= SendPDn;
	  end if;
	when SendPEn => 
	  if Counter1us = Count1us and uSecCounter = 335
		 then AlignSeq <= SendRst;
	  elsif AlignReq = 0 then
	    AlignSeq <= Idle;
	   else AlignSeq <= SendPEn;
	  end if;
	when SendRst =>
		if Counter1us = Count1us and uSecCounter = 335
		  then AlignSeq <= WaitFR;
	  elsif AlignReq = 0 then
	    AlignSeq <= Idle;
		else AlignSeq <= SendRst;
		end if;
	when WaitFR => 
     if Counter1us = Count1us and uSecCounter = 300 then	  
	    AlignSeq <= CheckFR;       
	   elsif AlignReq = 0 then
	    AlignSeq <= Idle;
	  else AlignSeq <= WaitFR;
	 end if;
	when CheckFR => 
	   if Counter1us = Count1us and uSecCounter = 300
		  then
			  if (AlignReq(0) = '1' and done(0) = '1') 
		     or (AlignReq(1) = '1' and done(1) = '1')
			  or AlignReq = 0 then 
			   AlignSeq <= Idle; 
			  else 
			   AlignSeq <= RstCntr;
			 end if;
		 end if;
	 when RstCntr => --Debug(3 downto 1) <= "110";
			 if Counter1us = Count1us then
			  AlignSeq <= SendPDn;
	      else 
			  AlignSeq <= RstCntr;
		  end if;
	when others => --Debug(3 downto 1) <= "111"; AlignSeq <= Idle; 
 end Case;

-- Only 0,2 and 4 are allowed slip count values
if uWRDL = 1 and uCA(11 downto 10) = GA and uCA(9 downto 0) = SlipCntRegAd
then 
	SlipCntReg(0) <= uCD(2)  & (not uCD(2)  and uCD(1)) & '0';
	SlipCntReg(1) <= uCD(10) & (not uCD(10) and uCD(9)) & '0';
   else
	SlipCntReg(0) <= SlipCntReg(0);
	SlipCntReg(1) <= SlipCntReg(1);
end if;


-- Writing a 1 enables alignment
if uWRDL = 1 and uCD(0) = '1' and AFEPDn(0) = '0'
	and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = SlipCtrlAd)
											or uCA(9 downto 0) = BrdCstAlgnReqAd)
 then AlignReq(0) <= '1'; 
-- Writing a 0 disables the alignment -> force quit alignment
-- Two conditions for stopping alignment: it successfully aligned, or it was told to stop
	elsif (AlignReq(0) = '1' and AlignSeq = CheckFR and done(0) = '1')
	  or (uWRDL = 1 and uCD(0) = '0' and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = SlipCtrlAd)
													or uCA(9 downto 0) = BrdCstAlgnReqAd))
 then AlignReq(0) <= '0'; 
 else AlignReq(0) <= AlignReq(0);
end if;

if uWRDL = 1 and uCD(1) = '1' and AFEPDn(1) = '0'
	and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = SlipCtrlAd)
												or uCA(9 downto 0) = BrdCstAlgnReqAd)
 then AlignReq(1) <= '1'; 
 elsif (AlignReq(1) = '1' and AlignSeq = CheckFR and done(1) = '1')
   or (uWRDL = 1 and uCD(1) = '0' and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = SlipCtrlAd)
												or uCA(9 downto 0) = BrdCstAlgnReqAd))
 then AlignReq(1) <= '0'; 
 else AlignReq(1) <= AlignReq(1);
end if;
	

-- Time base for alignment sequence
if AlignSeq /= Idle and AlignSeq /= RstCntr
	and Counter1us = Count1us and uSecCounter /= 335
 then uSecCounter <= uSecCounter + 1;
elsif AlignSeq = Idle or AlignSeq = RstCntr
   or (Counter1us = Count1us and uSecCounter = 335)
 then uSecCounter <= (others => '0');
else uSecCounter <= uSecCounter;
end if;
	
-- This state machine controls the order of AFE writes to the command FIFO
-- Timer requirement enables the OD write strobe for one clock cycle
--(Idle, SetAFESel0, WrtAFE0, SetAFESel1, WrtAFE1);
case OD_Write is
	when Idle =>
		if (AlignSeq = SendPdn or AlignSeq = SendPEn)
			and Counter1us = 1 and uSecCounter = 0 then
			if AlignReq(0) = '1' then
				OD_Write <= SetAFESel0; --Debug(4) <= '1';
			elsif AlignReq = 2 then
				OD_Write <= SetAFESel1; --Debug(4) <= '1';
			end if;
		else
			OD_Write <= Idle; --Debug(4) <= '0';
		end if;
	when SetAFESel0 => OD_Write <= WrtAFE0; --Debug(4) <= '1';
	when WrtAFE0 =>
		if AlignReq(1) = '1' then
			OD_Write <= SetAFESel1; --Debug(4) <= '1';
		else OD_Write <= Idle; --Debug(4) <= '0';
		end if;
	when SetAFESel1 => OD_Write <= WrtAFE1; --Debug(4) <= '1';
	when WrtAFE1 => OD_Write <= Idle; --Debug(4) <= '0';
end case;

-- Write the updated actual value to the bias DAC
if RampGate(0) = '1' and Counter1ms = Count1ms
	then ODFifoData <= X"0440" & BiasActual(0);
elsif RampGate(1) = '1' and Counter1ms = 1
	then ODFifoData <= X"0450" & BiasActual(1);
else ODFifoData <= ("00" & uCA(9 downto 0) & uCD);
end if;

if RampGate(0) = '1' and Counter1ms = Count1ms 
	then ODFifoData <= X"0440" & BiasActual(0); --Debug(7) <= '0';
elsif RampGate(1) = '1' and Counter1ms = 1
	then ODFifoData <= X"0450" & BiasActual(1); --Debug(7) <= '0';
-- Clock adjustment, enabling and disabling LVDS output for each ultrasound
elsif AlignSeq = SendPDn and (OD_Write = SetAFESel0 or OD_Write = WrtAFE0) then
	ODFifoData <= X"101" & X"0002"; --Debug(7) <= '1';
elsif AlignSeq = SendPDn and (OD_Write = SetAFESel1 or OD_Write = WrtAFE1) then
	ODFifoData <= X"201" & X"0002"; --Debug(7) <= '1';
elsif AlignSeq = SendPEn and (OD_Write = SetAFESel0 or OD_Write = WrtAFE0) then
	ODFifoData <= X"101" & X"0000"; --Debug(7) <= '0';
elsif AlignSeq = SendPEn and (OD_Write = SetAFESel1 or OD_Write = WrtAFE1) then
	ODFifoData <= X"201" & X"0000"; --Debug(7) <= '0';
else ODFifoData <= ("00" & uCA(9 downto 0) & uCD); --Debug(7) <= '0';
end if;

if (RampGate(0) = '1' and Counter1ms = Count1ms)
or (RampGate(1) = '1' and Counter1ms = 1)
or ((AlignSeq = SendPDn or AlignSeq = SendPEn) and 
     (OD_Write = SetAFESel0 or OD_Write = WrtAFE0 or OD_Write = SetAFESel1 or OD_Write = WrtAFE1))
or	(uWRDL = 1 and uCA(11 downto 10) = GA
           and ((uCA(9 downto 0) >= DatArray0Min and uCA(9 downto 0) <= CtrlArray2Max
				 and uCA(9 downto 0) /= ("00" & X"44") and uCA(9 downto 0) /= ("00" & X"45"))
				 or (uCA(9 downto 0) >= AFE0ArrayMin and uCA(9 downto 0) <= AFE0ArrayMax)
				 or (uCA(9 downto 0) >= AFE1ArrayMin and uCA(9 downto 0) <= AFE1ArrayMax)))
then ODFifoWrReq <= '1';
else ODFifoWrReq <= '0';
end if;


-- If data is going to the DACs, shadow it in ram
if uWRDL = 1 and uCA(11 downto 10) = GA 
  and uCA(9 downto 0) >= DatArray0Min and uCA(9 downto 0) <= CtrlArray2Max
then ShadowWrt <= "1";
else ShadowWrt <= "0";
end if;

-- Distinguish between DACs and AFEs
if ODFifoEmpty = '0' and ClkDiv = 0 and DacLd = '1' and Octal_Shift = Idle 
           and ODFifoOut(27 downto 16) >= DatArray0Min and ODFifoOut(27 downto 16) <= CtrlArray2Max
then Dev_Sel <= '1';
elsif ODFifoEmpty = '0' and ClkDiv = 0 and DacLd = '1' and Octal_Shift = Idle 
           and ((ODFifoOut(27 downto 16) >= AFE0ArrayMin and ODFifoOut(27 downto 16) <=AFE0ArrayMax)
				 or (ODFifoOut(27 downto 16) >= AFE1ArrayMin and ODFifoOut(27 downto 16) <=AFE1ArrayMax))
then Dev_Sel <= '0';
end if;

--(Idle,Shift,ClearSync,SetLoad);
Case Octal_Shift is
	   When Idle => 	
				if ODFifoEmpty = '0' and ClkDiv = 0 and DacLd = '1' 
				then Octal_Shift <= Shift;
				else Octal_Shift <= Idle;
				end if;
		When Shift => if BitCount = 1 and ClkDiv = 0 
				then Octal_Shift <= ClearSync;
				else Octal_Shift <= Shift;
				end if;
	   When ClearSync => if DacCS = 7 and Dev_Sel = '1' and ClkDiv = 0 and Dev_Sel = '1' 
				then Octal_Shift <= SetLoad;
				elsif Dev_Sel = '0' and ClkDiv = 0 
				then Octal_Shift <= Idle;
				else Octal_Shift <= ClearSync;
				end if;
		When SetLoad => if DacLd = '0' and ClkDiv = 0
				then Octal_Shift <= Idle;
				else Octal_Shift <= SetLoad;
				end if;
		When others => Octal_Shift <= Idle;
end case;

-- DAC output shift registter
if ODFifoRdReq = '1' and Dev_Sel = '1' and ODFifoOut(27 downto 16) < DatArray2Min
	then DACShift <= X"00" & '0' & ODFifoOut(18 downto 16) & ODFifoOut(11 downto 0);
elsif ODFifoRdReq = '1' and Dev_Sel = '1' and ODFifoOut(27 downto 16) >= DatArray2Min 
	and ODFifoOut(27 downto 16) < CtrlArray0Min
	then 
-- Remap the LED intensity channels
	Case ODFifoOut(18 downto 16) is 
	 when "000" =>	DACShift <= X"001" & ODFifoOut(11 downto 0);
	 when "001" =>	DACShift <= X"003" & ODFifoOut(11 downto 0);
	 when "010" =>	DACShift <= X"000" & ODFifoOut(11 downto 0);
	 when "011" =>	DACShift <= X"002" & ODFifoOut(11 downto 0);
	 when others => DACShift <= X"00" & '0' & ODFifoOut(18 downto 16) & ODFifoOut(11 downto 0);
	end Case;
elsif ODFifoRdReq = '1' and Dev_Sel = '1' and ODFifoOut(27 downto 16) >= CtrlArray0Min
	then DACShift <= X"00" & '1' & ODFifoOut(14 downto 0);
elsif ODFifoRdReq = '1' and Dev_Sel = '0'
	then DACShift <= ODFifoOut(23 downto 0);
elsif BitCount /= 0 and ClkDiv = 0 and Octal_Shift = Shift then DACShift <= (DACShift(22 downto 0) & '0');
end if;

if Dev_Sel = '1' and Octal_Shift = Shift 
then DacDat <= DACShift(15);
else DacDat <= '0';
end if;

---- When one word has been serialized, read the buffer for the next word
if ODFifoEmpty = '0' and ClkDiv = 0 and DacLd = '1' and Octal_Shift = Idle
then ODFifoRdReq <= '1';
else ODFifoRdReq <= '0';
end if;

---- Serial bit counter
-- if destination is DAC, counter is 24
if ODFifoRdReq = '1' and BitCount = 0 and Dev_Sel = '0' 
then BitCount <= "11000";
-- if destination is AFE, counter is 16
elsif ODFifoRdReq = '1' and BitCount = 0 and Dev_Sel = '1' 
then BitCount <= "10000";
elsif BitCount /= 0 and Octal_Shift = Shift and ClkDiv = 0 
then BitCount <= BitCount - 1;
end if;

---- DAC clock
if Dev_Sel = '1' and BitCount /= 0 and Octal_Shift = Shift 
then DacClk <= ClkDiv(2); 
else DacClk <= '0';
end if;

---- DAC load 
if Octal_Shift = SetLoad and ClkDiv = 0 and Dev_Sel = '1' 
then DacLd <= '0';
elsif Octal_Shift = Idle and ClkDiv = 0 
then DacLd <= '1';
else DacLd <= DacLd;
end if;

---- Assert appropriate DAC chip select based on bits 22..19 of the FIFO output
if ODFifoRdReq = '1' and BitCount = 0 and Dev_Sel = '1'  
then 
 Case ODFifoOut(22 downto 19) is
	When X"6" => DacCS <= "110";
	When X"7" => DacCS <= "101";
	When X"8" => DacCS <= "011";
	When X"9" => DacCS <= "110";
	When X"A" => DacCS <= "101";
	When X"B" => DacCS <= "011";
	When others => DacCS <= "111";
 end case;
elsif ClkDiv = 0 and Octal_Shift = ClearSync 
then DacCS <= "111";
end if;

-- Assert appropriate AFE chip select based on bits 25, 24 of the FIFO output
if ODFifoRdReq = '1' and BitCount = 0 and Dev_Sel = '0'  
then 
 Case ODFifoOut(25 downto 24) is
	When "01" => AFECS <= "10";
	When "10" => AFECS <= "01";
	When others => AFECS <= "11";
 end case;
elsif ClkDiv = 0 and Octal_Shift = ClearSync 
then AFECS <= "11";
end if;

---- AFE serial clock
if Dev_Sel = '0' and BitCount /= 0 and Octal_Shift = Shift 
then AFESClk <= ClkDiv(2); 
else AFESClk <= '0';
end if;

---- AFE serial data
if Dev_Sel = '0' and Octal_Shift = Shift 
then AFESDI <= DACShift(23); 
else AFESDI <= '0';
end if;

-- Delayed copy of the serial clock for strobing in readback data
SClkDL(0) <= AFESClk;
SClkDL(1) <= SClkDL(0);
SClkDL(2) <= SClkDL(1);

-- Clock in any readback data
if Dev_Sel = '0' and SClkDL = 6 
then AFERdReg <= AFERdReg(14 downto 0) & AFESDO;
end if;

end if; -- CpldRst
end process main;


end behavioural;