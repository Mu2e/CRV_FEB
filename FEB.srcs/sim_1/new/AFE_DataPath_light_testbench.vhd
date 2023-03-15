library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Proj_Def.all;

entity AFE_DataPath_light_testbench is
end AFE_DataPath_light_testbench;


architecture AFE_DataPath_light_testbench_arch of AFE_DataPath_light_testbench is

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
-- Pipeline signals
	PipelineSet 		: in std_logic_vector (7 downto 0);	
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

constant Clk200MHz_period: time := 5.0ns;   -- 200 MHz
constant Clk160MHz_period: time := 6.25ns;  -- 160 MHz
constant Clk80MHz_period:  time := 12.5ns;  -- 80 MHz
constant Clk560MHz_period: time := 1.786ns; -- 80 MHz * 7 = 560MHz

signal reset	: std_logic := '1';
signal ResetHi	: std_logic := '1';
signal CpldRst	: std_logic := '1';
signal Clk200MHz, Clk160MHz, Clk80MHz, Clk560MHz: std_logic := '0';


signal dout_AFE0		      : Array_8x14; 
signal dout_AFE1		      : Array_8x14; 
signal done					  : std_logic_vector(1 downto 0);


signal CpldCS 				  : std_logic;	
signal uCRd	  				  : std_logic;
signal uCWr 				  : std_logic;		
signal uCA 	  				  : std_logic_vector(11 downto 0);
signal uCD 	  				  : std_logic_vector(15 downto 0);
signal GA 					  : std_logic_vector(1 downto 0);
signal uWRDL 				  : std_logic_vector(1 downto 0);
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
uCWR	<= '0';
CpldCS	<= '0';


-- make the clocks
Clk80MHz  <= not Clk80MHz  after Clk80MHz_period/2;
Clk160MHz <= not Clk160MHz after Clk160MHz_period/2;
Clk200MHz <= not Clk200MHz after Clk200MHz_period/2;
Clk560MHz <= not Clk560MHz after Clk560MHz_period/2;

done <= "00", "11" after 50ns;

GA <= "00";

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
	TrigReq			=> TrigReq,
	BeamOn			=> BeamOn,
	MaskReg			=> MaskReg,					
	BufferRdAdd		=> BufferRdAdd,				
	BufferOut 		=> BufferOut, 
	ControllerNo 	=> ControllerNo, 
	PortNo 		    => PortNo, 		
	BeamOnLength    => BeamOnLength, 
	BeamOffLength   => BeamOffLength,
	ADCSmplCntReg	=> ADCSmplCntReg,
    din_AFE0		=> dout_AFE0,
    din_AFE1		=> dout_AFE1,
	done 			=> done,
	PipelineSet		=> PipelineSet,

	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
	uCA				=> uCA,
	uCD             => uCD,
	GA              => GA 
 			    
	);

trigger_request: process
begin
	wait until rising_edge(Clk160MHz);
	TrigReq	 		<= '1';
	BeamOn			<= '0';
	MaskReg(0)		<= X"FF";
	MaskReg(1)		<= X"FF";
	ControllerNo	<= "11111";
    PortNo			<= "11111";		
	BeamOnLength 	<= X"050";
	BeamOffLength   <= X"700";
	ADCSmplCntReg 	<= X"8";
end process;

end AFE_DataPath_light_testbench_arch;

