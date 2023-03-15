LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

use work.Proj_Def.all;

entity Trigger_testbench is
end Trigger_testbench;


architecture Trigger_testbench_arch of Trigger_testbench is

component Trigger is
  Port (
  	SysClk				: in std_logic; -- 160 MHz
	ResetHi  			: in std_logic;
-- Signals for other logic
	TrigReq				: buffer std_logic;
	SlfTrgEn 			: buffer std_logic;
	BeamOn 				: buffer std_logic;
	uBunch   			: buffer std_logic_vector(31 downto 0);
	uBunchWrt			: out std_logic;
	GPO			 		: inout std_logic;
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
	uWRDL 				: in std_logic_vector(1 downto 0);
	WRDL 				: in std_logic_vector(1 downto 0);
-- LED/Flash Gate select line
	PulseSel 			: buffer std_logic;
-- LED pulser/Flash Gate
	Pulse 				: out std_logic;
	LEDSrc				: buffer std_logic;
	GPI0 				: in std_logic;
	iCD				  	: inout std_logic_vector(15 downto 0)
	);
end component;


component AFE_DataPath is
  Port (
	Clk_80MHz			: in std_logic; 
	SysClk				: in std_logic; -- 160 MHz
	ResetHi				: in std_logic;
-- Signals from Trigger Logic
	TrigReq				: in std_logic;
	BeamOn				: in std_logic;
-- Signals for EventBuilder
	MaskReg				: buffer Array_2x8;
	BufferRdAdd			: in Array_2x8x10;
	BufferOut 			: out Array_2x8x16;
-- Signals from uC
	ControllerNo 		: in std_logic_vector (4 downto 0);
	PortNo 				: in std_logic_vector (4 downto 0);
	BeamOnLength 		: in std_logic_vector (11 downto 0);
	BeamOffLength 		: in std_logic_vector (11 downto 0);
	ADCSmplCntReg 		: in std_logic_vector (3 downto 0);
-- Data output from the deserializer for AFE0 and AFE1 synchronized to 80 MHz clock
    din_AFE0			: in Array_8x14; 
    din_AFE1			: in Array_8x14;
    done				: in std_logic_vector(1 downto 0); -- status of automatic alignment FSM
	SerdesRst			: out std_logic_vector(1 downto 0);
-- Pipeline signals
	PipelineSet 		: in std_logic_vector (7 downto 0);	
-- Histogram signals
	Diff_Reg			: inout Arrays_8x2x14;
	GateWidth	    	: inout Array_2x12;
	GateReq 			: inout std_logic_vector (1 downto 0);
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
end component;

constant Clk100MHz_period: time := 10.0ns;  -- 100 MHz
constant Clk200MHz_period: time := 5.0ns;   -- 200 MHz
constant Clk160MHz_period: time := 6.25ns;  -- 160 MHz
constant Clk80MHz_period:  time := 12.5ns;  -- 80 MHz
constant Clk560MHz_period: time := 1.786ns; -- 80 MHz * 7 = 560MHz
constant Clk10MHz_period: time := 100ns;
constant Clk12MHz_period: time := 83ns;
constant Clk15MHz_period: time := 67ns;

signal reset	: std_logic := '1';
signal ResetHi	: std_logic := '1';
signal CpldRst	: std_logic := '1';
signal Clk100MHz, Clk200MHz, Clk160MHz, Clk80MHz, Clk560MHz: std_logic := '0';

-- Synchronous edge detectors of uC read and write strobes
signal WRDL 	: std_logic_vector(1 downto 0):=(others => '0');
signal RDDL 				  : std_logic_vector(1 downto 0):=(others => '0');
signal uWRDL 				  : std_logic_vector(1 downto 0):=(others => '0');
signal uRDDL 				  : std_logic_vector(1 downto 0):=(others => '0');
signal AddrReg				  : std_logic_vector(11 downto 0):=(others => '0');
signal uAddrReg				  : std_logic_vector(11 downto 0):=(others => '0');
	
signal dout_AFE0		      : Array_8x14; 
signal dout_AFE1		      : Array_8x14; 
signal done					  : std_logic_vector(1 downto 0);

signal CpldCS 				  : std_logic := '0';
signal uCRd	  				  : std_logic := '0';
signal uCWr 				  : std_logic := '0';
signal uCA 	  				  : std_logic_vector(11 downto 0);
signal uCD 	  				  : std_logic_vector(15 downto 0);
signal GA 					  : std_logic_vector(1 downto 0);
signal GPO					  : std_logic;
signal TrigReq				  : std_logic;
signal PipelineSet 			  : std_logic_vector (7 downto 0) := X"04";
signal BeamOn				  : std_logic;
signal PulseSel				  : std_logic;
signal Pulse				  : std_logic;
signal GPI0 				  : std_logic;
signal LEDSrc		          : std_logic;
signal MaskReg				  : Array_2x8;
signal BufferRdAdd			  : Array_2x8x10;
signal BufferOut 			  : Array_2x8x16;
signal ControllerNo 		  : std_logic_vector (4 downto 0);
signal PortNo 				  : std_logic_vector (4 downto 0);
signal BeamOnLength 		  : std_logic_vector (11 downto 0);
signal BeamOffLength 		  : std_logic_vector (11 downto 0);
signal ADCSmplCntReg 		  : std_logic_vector (3 downto 0);
signal SlfTrgEn 			  : std_logic;
signal uBunch   			  : std_logic_vector(31 downto 0);
signal uBunchWrt			  : std_logic;
-- Histogram signals from AFE_DataPath
signal Diff_Reg				  : Arrays_8x2x14;
signal GateWidth	    	  : Array_2x12;
signal GateReq 				  : std_logic_vector (1 downto 0);



signal d0_vec: std_logic_vector(13 downto 0) := "00100000000001"; -- 0x801
signal d1_vec: std_logic_vector(13 downto 0) := "00110000000011"; -- 0x803
signal d2_vec: std_logic_vector(13 downto 0) := "00101010101010"; -- 0xAAA
signal d3_vec: std_logic_vector(13 downto 0) := "00010101010101"; -- 0x555
signal d4_vec: std_logic_vector(13 downto 0) := "00111111111111"; -- 0xFFF
signal d5_vec: std_logic_vector(13 downto 0) := "00000000000000"; -- 0x000 
signal d6_vec: std_logic_vector(13 downto 0) := "00101010111100"; -- 0x0ABC
signal d7_vec: std_logic_vector(13 downto 0) := "00000000000000"; -- count up
signal d8_vec: std_logic_vector(13 downto 0) := "11111110000000"; -- aka FCLK should be 0x3F80

begin

--make the reset
reset 	<= '1', '0' after 13ns;
CpldRst <= '1', '0' after 12.5ns, '1' after 25ns;
ResetHi <= not CpldRst;


-- make the clocks
Clk100MHz  <= not Clk100MHz  after Clk100MHz_period/2;
Clk80MHz  <= not Clk80MHz  after Clk80MHz_period/2;
Clk160MHz <= not Clk160MHz after Clk160MHz_period/2;
Clk200MHz <= not Clk200MHz after Clk200MHz_period/2;
Clk560MHz <= not Clk560MHz after Clk560MHz_period/2;
	
--uCRd	<= not uCRd	after Clk10MHz_period/2;
--uCWr	<= not uCWr	after Clk12MHz_period/2;
--CpldCS	<= not CpldCS after Clk15MHz_period/2;
--done <= "00", "11" after 50ns;
--GA <= "00";

global_signals_160MHz : process(Clk160MHz, CpldRst)
	begin 
	if CpldRst = '0' then
	WRDL 	<= "00";
	RDDL 	<= "00";
	AddrReg <= (others => '0'); 
	elsif rising_edge (Clk160MHz) then
	-- Synchronous edge detectors for read and write strobes
	WRDL(0) <= not uCWR and not CpldCS;
	WRDL(1) <= WRDL(0);
	RDDL(0) <= not uCRD and not CpldCS;
	RDDL(1) <= RDDL(0);
		if RDDL = 1 or WRDL = 1 
		then AddrReg <= uCA;
		else AddrReg <= AddrReg;
		end if;
	end if;
end process;
	
global_signals_100MHz : process(Clk100MHz, CpldRst)
	begin 
	if CpldRst = '0' then
	uWRDL 	<= "00"; 
	uRDDL 	<= "00";
	uAddrReg <= (others => '0');
	elsif rising_edge (Clk100MHz) then
	-- Synchronous edge detectors for read and write strobes
	uWRDL(0) <= not uCWR and not CpldCS;
	uWRDL(1) <= uWRDL(0);	
	uRDDL(0) <= not uCRD and not CpldCS;
	uRDDL(1) <= uRDDL(0);
		if uRDDL = 1 or uWRDL = 1 
		then uAddrReg <= uCA;
		else uAddrReg <= uAddrReg;
		end if;
	end if;
end process;

sender: process
begin
    wait until rising_edge(Clk80MHz);
	dout_AFE0(7) <= d7_vec;
	dout_AFE0(6) <= d6_vec;
	dout_AFE0(5) <= d5_vec;
	dout_AFE0(4) <= d4_vec;
	dout_AFE0(3) <= d3_vec;
	dout_AFE0(2) <= d2_vec;
	dout_AFE0(1) <= d1_vec;
	dout_AFE0(0) <= d0_vec;
	
	dout_AFE1(7) <= d7_vec;
	dout_AFE1(6) <= d6_vec;
	dout_AFE1(5) <= d5_vec;
	dout_AFE1(4) <= d4_vec;
	dout_AFE1(3) <= d3_vec;
	dout_AFE1(2) <= d2_vec;
	dout_AFE1(1) <= d1_vec;
	dout_AFE1(0) <= d0_vec;

    d7_vec <= std_logic_vector(unsigned(d7_vec)+1);
	d6_vec <= std_logic_vector(unsigned(d6_vec)+1);
	d5_vec <= std_logic_vector(unsigned(d5_vec)+1);
	d4_vec <= std_logic_vector(unsigned(d4_vec)+1);
	d3_vec <= std_logic_vector(unsigned(d3_vec)+1);
	d2_vec <= std_logic_vector(unsigned(d2_vec)+1);
	d1_vec <= std_logic_vector(unsigned(d1_vec)+1);
	d0_vec <= std_logic_vector(unsigned(d0_vec)+1);	
end process sender;


AFE_DataPath_inst : AFE_DataPath
port map (
	Clk_80MHz	    => Clk80MHz,		
	SysClk			=> Clk160MHz,
	ResetHi			=> ResetHi,
-- Signals from Trigger Logic
	TrigReq			=> TrigReq,
	BeamOn			=> BeamOn,
-- Signals for EventBuilder
	MaskReg			=> MaskReg,			
	BufferRdAdd		=> BufferRdAdd,		
	BufferOut 		=> BufferOut, 		
-- Signals from uC
	ControllerNo 	=> ControllerNo, 
	PortNo 			=> PortNo,	
	BeamOnLength    => BeamOnLength,
	BeamOffLength   => BeamOffLength, 
	ADCSmplCntReg   => ADCSmplCntReg,
-- Data output from the deserializer for AFE0 and AFE1 synchronized to 80 MHz clock
    din_AFE0		=> dout_AFE0,
    din_AFE1		=> dout_AFE1,
	done 			=> done,
-- Pipeline signals 	
	PipelineSet		=> PipelineSet,
-- Histogram signals
	Diff_Reg		=> Diff_Reg,	
	GateWidth	    => GateWidth,
	GateReq 		=> GateReq, 	
-- Microcontroller strobes
	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
-- Microcontroller data and address buses	
	uCA				=> uCA,
	uCD             => uCD,
-- Geographic address pins
	GA              => GA 
);

Trigger_logic: Trigger 
port map(
  	SysClk			=> Clk160MHz, -- 160 MHz
	ResetHi  		=> ResetHi,
--Signals to AFE_DataPath
	TrigReq			=> TrigReq,
	BeamOn			=> BeamOn,
-- Signals to EVB and DDR
	uBunch   		=> uBunch,   
	uBunchWrt		=> uBunchWrt,
	SlfTrgEn		=> SlfTrgEn,
-- Signal to Phase_Detector
	GPO				=> GPO,		
-- Microcontroller strobes
	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,	
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
-- Microcontroller data and address buses	
	uCA 			=> uCA,
	uCD 			=> uCD,
-- Geographic address pins
	GA 				=> GA,
-- Global signals
	uWRDL 			=> uWRDL,
	WRDL 			=> WRDL,
-- Chip out
	PulseSel 		=> PulseSel, 
	Pulse 			=> Pulse, 
	GPI0 			=> GPI0,
-- uC register 
	LEDSrc 			=> LEDSrc

);

CpldCS <= '0';
uWRDL 	<= "00";
uCA(11 downto 10) <= "00";
uCA(9 downto 0) <= FlashCtrlAddr;
uCD <= X"ABCD";   
--uCD <= (others => 'Z'); 
  
end Trigger_testbench_arch;

