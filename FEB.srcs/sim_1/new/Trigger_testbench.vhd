library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

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
	BeamOn 				: buffer std_logic;
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
	uWRDL 				: in std_logic_vector(1 downto 0);
-- LED/Flash Gate select line
	PulseSel 			: buffer std_logic;
-- LED pulser/Flash Gate
	Pulse 				: out std_logic;
	
	GPI0 				: in std_logic
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

constant Clk200MHz_period:   time := 5.0ns;   -- 200 MHz
constant Clk160MHz_period: time := 6.25ns;  -- 160 MHz
constant Clk80MHz_period:   time := 12.5ns;  -- 80 MHz
constant Clk560MHz_period: time := 1.786ns; -- 80 MHz * 7 = 560MHz

signal reset: std_logic := '1';
signal ResetHi: std_logic := '1';
signal CpldRst: std_logic := '1';
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
reset <= '1', '0' after 13ns;
CpldRst <= '1', '0' after 12.5ns, '1' after 25ns;
ResetHi <= '1', '0' after 12.5ns, '1' after 25ns;

-- make the clocks
Clk80MHz <= not Clk80MHz after Clk80MHz_period/2;
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

Trigger_logic: Trigger 
port map(
  	SysClk			=> Clk160MHz, -- 160 MHz
	ResetHi  		=> ResetHi,
	TrigReq			=> TrigReq,
	BeamOn			=> BeamOn,
	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
	uCA 			=> uCA,
	uCD 			=> uCD,
	GA 				=> GA, 
	uWRDL 			=> uWRDL,
	PulseSel 		=> PulseSel,
	Pulse 			=> Pulse, 
	
	GPI0 			=> GPI0 
);

end Trigger_testbench_arch;

