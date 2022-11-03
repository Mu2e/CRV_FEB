library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Proj_Def.all;

entity DDR_Interface_testbench is
end DDR_Interface_testbench;


architecture DDR_Interface_testbench_arch of DDR_Interface_testbench is

component DDR_Interface is
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
end component;

component EventBuilder is
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
-- Signals with DDR	
	EvBuffRd			: in std_logic;
	EvBuffOut			: out std_logic_vector(15 downto 0);
	EvBuffEmpty			: out std_logic;
	EvBuffWdsUsed		: out std_logic_vector(10 downto 0);
	asp					: in std_logic
	);
end component;

signal asp	: std_logic := '0';

constant Clk200MHz_period: time := 5.0ns;   -- 200 MHz
constant Clk160MHz_period: time := 6.25ns;  -- 160 MHz
constant Clk80MHz_period:  time := 12.5ns;  -- 80 MHz
constant Clk560MHz_period: time := 1.786ns; -- 80 MHz * 7 = 560MHz

signal reset	: std_logic := '1';
signal ResetHi	: std_logic := '1';
signal CpldRst	: std_logic := '1';
signal givetime	: std_logic := '1';
signal Clk200MHz, Clk160MHz, Clk80MHz, Clk560MHz: std_logic := '0';
signal VXO_P    : std_logic := '0';
signal VXO_N    : std_logic := '1';		

signal CpldCS	: std_logic := '0';
signal uCRd		: std_logic := '0';
signal uCWr 	: std_logic := '0';
signal uCA 		: std_logic_vector(11 downto 0):=(others => '0');
signal uCD 		: std_logic_vector(15 downto 0):=(others => '0');
signal GA 		: std_logic_vector(1 downto 0):=(others => '0');
-- Synchronous edge detectors of uC read and write strobes
signal WRDL 	: std_logic_vector(1 downto 0):=(others => '0');

signal dout_AFE0		      : Array_8x14; 
signal dout_AFE1		      : Array_8x14; 
signal done					  : std_logic_vector(1 downto 0);

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
signal ADCSmplCntReg 		  : std_logic_vector (3 downto 0) := X"8";
signal PipelineSet 			  : std_logic_vector (7 downto 0) := X"04";

signal TrigReq				  : std_logic;
signal SlfTrgEn 			  : std_logic;
signal uBunch   			  : std_logic_vector(31 downto 0);
signal uBunchWrt			  : std_logic;

signal EvBuffRd				  : std_logic;
signal EvBuffOut			  : std_logic_vector(15 downto 0);
signal EvBuffEmpty			  : std_logic;
signal EvBuffWdsUsed		  : std_logic_vector(10 downto 0);

Signal wea 					  : std_logic_vector(0 downto 0);
signal addra				  : std_logic_vector(9 downto 0):=(others => '0');
--signal addrb				  : std_logic_vector(9 downto 0):=(others => '0');
signal dina					  : std_logic_vector(15 downto 0):=(others => '0');


-- DDR3L pins
signal DDR_DATA 			  : std_logic_vector(15 downto 0);
signal DDR_ADDR 			  : std_logic_vector(14 downto 0);
signal BA 					  : std_logic_vector(2 downto 0);
signal DDR_CKE	 			  : std_logic_vector(0 downto 0);
signal ODT 					  : std_logic_vector(0 downto 0);
signal CS 					  : std_logic_vector(0 downto 0);
signal DM 					  : std_logic_vector(1 downto 0);
signal RAS,CAS				  : std_logic; 
signal DDR_WE 				  : std_logic;
signal DDR_CLKP,DDR_CLKN 	  : std_logic_vector(0 downto 0);
signal LDQS_P, LDQS_N 		  : std_logic;
signal UDQS_P, UDQS_N 		  : std_logic;
signal SDRzq 				  : std_logic;

-- signal d0_vec: std_logic_vector(13 downto 0) := "00100000000001"; -- 0x801
-- signal d1_vec: std_logic_vector(13 downto 0) := "00110000000011"; -- 0x803
-- signal d2_vec: std_logic_vector(13 downto 0) := "00101010101010"; -- 0xAAA
-- signal d3_vec: std_logic_vector(13 downto 0) := "00010101010101"; -- 0x555
-- signal d4_vec: std_logic_vector(13 downto 0) := "00111111111111"; -- 0xFFF
-- signal d5_vec: std_logic_vector(13 downto 0) := "00000001010101"; -- 0x055 
-- signal d6_vec: std_logic_vector(13 downto 0) := "00101010111100"; -- 0x0ABC
-- signal d7_vec: std_logic_vector(13 downto 0) := "00000000000000"; -- count up
-- signal d8_vec: std_logic_vector(13 downto 0) := "11111110000000"; -- aka FCLK should be 0x3F80

signal d0_vec: std_logic_vector(13 downto 0) := "00" & X"AAA"; -- 0x0AA
signal d1_vec: std_logic_vector(13 downto 0) := "00" & X"BBB"; -- 0x803
signal d2_vec: std_logic_vector(13 downto 0) := "00" & X"CCC"; -- 0xAAA
signal d3_vec: std_logic_vector(13 downto 0) := "00" & X"DDD"; -- 0x555
signal d4_vec: std_logic_vector(13 downto 0) := "00" & X"EEE"; -- 0xFFF
signal d5_vec: std_logic_vector(13 downto 0) := "00" & X"FFF"; -- 0x055 
signal d6_vec: std_logic_vector(13 downto 0) := "00" & X"ABC"; -- 0x0ABC
signal d7_vec: std_logic_vector(13 downto 0) := "00" & X"000"; -- count up
signal d8_vec: std_logic_vector(13 downto 0) := "11111110000000"; -- aka FCLK should be 0x3F80

begin

--make the reset
reset 	<= '1', '0' after 13ns;
CpldRst <= '1', '0' after 12.5ns, '1' after 25ns;
ResetHi <= not CpldRst;
givetime <= '1', '0' after 500ns, '1' after 550ns;
-- make the clocks
Clk80MHz  <= not Clk80MHz  after Clk80MHz_period/2;
Clk160MHz <= not Clk160MHz after Clk160MHz_period/2;
Clk200MHz <= not Clk200MHz after Clk200MHz_period/2;
Clk560MHz <= not Clk560MHz after Clk560MHz_period/2;
VXO_N <= not VXO_P;
VXO_N <= not VXO_P after Clk160MHz_period/2;

done <= "00", "11" after 50ns;
asp  <= '1' after 2us;

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
	--d6_vec <= std_logic_vector(unsigned(d6_vec)+1);
	--d5_vec <= std_logic_vector(unsigned(d5_vec)+1);
	--d4_vec <= std_logic_vector(unsigned(d4_vec)+1);
	--d3_vec <= std_logic_vector(unsigned(d3_vec)+1);
	--d2_vec <= std_logic_vector(unsigned(d2_vec)+1);
	--d1_vec <= std_logic_vector(unsigned(d1_vec)+1);
	--d0_vec <= std_logic_vector(unsigned(d0_vec)+1);	
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




EventBuilder_logic :  EventBuilder
port map(
	SysClk			=> Clk160MHz,	 -- 160 MHz
	CpldRst			=> CpldRst,
	ResetHi			=> ResetHi,
-- Signals from/to AFE Buffer
	MaskReg			=> MaskReg,
	BufferRdAdd		=> BufferRdAdd,	
	BufferOut 		=> BufferOut, 	
-- Signals from Trigger Logic
	SlfTrgEn		=> SlfTrgEn,
	uBunchWrt		=> uBunchWrt,
	uBunch   		=> uBunch,
-- Signals with DDR	
	EvBuffRd		=> EvBuffRd,		
	EvBuffOut		=> EvBuffOut,			
	EvBuffEmpty		=> EvBuffEmpty,			
	EvBuffWdsUsed	=> EvBuffWdsUsed,
	asp				=> asp	
	);
	
uBunch_gen : process
begin 
	uBunch <= (others => '0');
	wait until rising_edge(Clk160MHz);
	for i in 0 to 256 loop
	uBunchWrt <= '1';
	uBunch <= std_logic_vector(unsigned(uBunch)+1);
	wait for Clk80MHz_period;
	end loop;
	
end process;	
	
trigger_request: process
begin
	wait until rising_edge(Clk160MHz);
	TrigReq	 		<= '1';
	BeamOn			<= '1';
	MaskReg(0)		<= X"FF";
	MaskReg(1)		<= X"FF";
	ControllerNo	<= "11111";
    PortNo			<= "11111";		
--	BeamOnLength 	<= X"050"; REAL
	BeamOnLength 	<= X"030"; --Simulation
	BeamOffLength   <= X"700";
	SlfTrgEn		<= '1';
end process;


DDR_Interface_inst : DDR_Interface
port map(
	VXO_P			=> VXO_P,	
	VXO_N 			=> VXO_N, 	
	SysClk			=> Clk160MHz,	
	ResetHi			=> ResetHi,
-- DDR3L pins
	DDR_DATA		=> DDR_DATA,	
	DDR_ADDR		=> DDR_ADDR,	
	BA 				=> BA, 			
	DDR_CKE	 		=> DDR_CKE,		
	ODT 			=> ODT, 		
	CS 				=> CS, 			
	DM 				=> DM, 			
	RAS				=> RAS,
	CAS				=> CAS,		
	DDR_WE 			=> DDR_WE, 		
	DDR_CLKP        => DDR_CLKP,
	DDR_CLKN 	    => DDR_CLKN,
	LDQS_P          => LDQS_P,
	LDQS_N 		    => LDQS_N, 	
	UDQS_P          => UDQS_P,
	UDQS_N 		    => UDQS_N, 	
	SDRzq 			=> SDRzq, 		
-- Signals for the DDR	
	EvBuffRd		=> EvBuffRd,	
	EvBuffOut		=> EvBuffOut,	
	EvBuffEmpty		=> EvBuffEmpty,	
	EvBuffWdsUsed	=> EvBuffWdsUsed,
-- Signals from Trigger Logic
	SlfTrgEn 		=> SlfTrgEn, 	
	uBunchWrt		=> uBunchWrt,	
	uBunch			=> uBunch,		
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
-- Synchronous edge detectors of uC read and write strobes
	--uWRDL 				: in std_logic_vector(1 downto 0);
	WRDL 			=> WRDL
);














end DDR_Interface_testbench_arch;

