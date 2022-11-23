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
	-- AFE serial control lines
	AFEPDn 				    : buffer std_logic_vector(1 downto 0);
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
	
	uWRDL 					: inout std_logic_vector(1 downto 0);
	uRDDL 					: inout std_logic_vector(1 downto 0);
	TrgSrc					: inout std_logic;
	ADCSmplCntReg 			: inout std_logic_vector (3 downto 0);
	ControllerNo 			: inout std_logic_vector (4 downto 0);
	PortNo 		 			: inout std_logic_vector (4 downto 0);
	FMTxBuff_wreq			: out std_logic;
	PipelineSet				: inout std_logic_vector (7 downto 0)
  );
end uControllerRegister;

architecture behavioural of uControllerRegister is


-- uC data bus
--signal iCD,CDStage,ICAP_O : std_logic_vector(15 downto 0);
--signal AddrReg : std_logic_vector(11 downto 0);
--signal TrigType : std_logic_vector(11 downto 0);

-- Signals used by the current sense multiplexer
signal MuxSelReg : std_logic_vector(2 downto 0);
signal MuxadReg : std_logic_vector(1 downto 0);

-- Timing interval counters
signal Counter1us  : std_logic_vector (7 downto 0);
signal Counter10us : std_logic_vector (10 downto 0);
signal Counter1ms  : std_logic_vector (17 downto 0); 
signal Count100ms  : std_logic_vector (6 downto 0);
signal Counter1s   : std_logic_vector (27 downto 0);


signal TestCount : std_logic_vector (31 downto 0);
signal UpTimeCount : std_logic_vector (31 downto 0);
signal UpTimeStage : std_logic_vector (31 downto 0);


begin


main : process (Clk100MHz, CpldRst)
begin 
if CpldRst = '0' then

	uWRDL 	<= "00"; 
	uRDDL 	<= "00";
	
-- Control bits written by the uC
	--DACCS <= "111"; 
	--RampGate <= "00";
	--BiasTarget <= (others => X"000"); 
	--BiasActual <= (others => X"000"); 
	--DACLd <= '1'; 
	--DACClk <= '1'; 
	--DACDat <= '0'; 
	--Dev_Sel <= '0'; 
	--DACShift <= (others => '0'); 
	--Octal_Shift <= Idle; 
	--ClkDiv <= (others => '0');
	--BitCount <= "00000"; 
	--ODFifoWrReq <= '0'; 
	--ODFifoRdReq <= '0'; 
	--ODFifoData <= (others => '0'); 
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
	--AFECS <= "11"; 
	--AFESDI <= '0'; 
	--StatReg <= X"0";
	--AFESClk <= '0'; 
	--SClkDL <= "000"; 
	--AFERdReg <= (others => '0');
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
	RstReq <= "00";
	SlipCntReg <= ("000","000"); 
	uSecCounter <= (others => '0'); 
	FR_OK <= "00";
	
elsif rising_edge (Clk100MHz) then 

-- Synchronous edge detectors for read and write strobes
uRDDL(0) <= not uCRD and not CpldCS;
uRDDL(1) <= uRDDL(0);

uWRDL(0) <= not uCWR and not CpldCS;
uWRDL(1) <= uWRDL(0);

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
if uWRDL = 1 and uCD(3) = '1' and ResetCount = 0 
 and ((uCA(11 downto 10) = GA and uCA(9 downto 0) = CSRRegAddr)
    or uCA(9 downto 0) = CSRBroadCastAd)
then ResetCount <= X"F";
elsif ResetCount /= 0 then ResetCount <= ResetCount - 1;
end if;

-- MIG Reset
if ResetCount /= 0 then DDR_Reset <= '1';
else DDR_Reset <= '0';
end if;

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










end if; -- CpldRst
end process main;

end behavioural;