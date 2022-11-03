library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Proj_Def.all;

entity EventBuilder_testbench is
end EventBuilder_testbench;


architecture EventBuilder_testbench_arch of EventBuilder_testbench is

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
	EvBufffOut			: out std_logic_vector(15 downto 0);
	EvBuffEmpty			: out std_logic;
	EvBuffWdsUsed		: out std_logic_vector(10 downto 0)
	);
end component;

constant Clk200MHz_period: time := 5.0ns;   -- 200 MHz
constant Clk160MHz_period: time := 6.25ns;  -- 160 MHz
constant Clk80MHz_period:  time := 12.5ns;  -- 80 MHz
constant Clk560MHz_period: time := 1.786ns; -- 80 MHz * 7 = 560MHz

signal reset	: std_logic := '1';
signal ResetHi	: std_logic := '1';
signal CpldRst	: std_logic := '1';
signal givetime	: std_logic := '1';
signal Clk200MHz, Clk160MHz, Clk80MHz, Clk560MHz: std_logic := '0';

		

signal TrigReq				  : std_logic;

signal MaskReg				  : Array_2x8;
signal BufferRdAdd			  : Array_2x8x10;
signal BufferOut 			  : Array_2x8x16;

signal SlfTrgEn 			  : std_logic;
signal uBunch   			  : std_logic_vector(31 downto 0);
signal uBunchWrt			  : std_logic;

signal EvBuffRd				  : std_logic;
signal EvBufffOut			  : std_logic_vector(15 downto 0);
signal EvBuffEmpty			  : std_logic;
signal EvBuffWdsUsed		  : std_logic_vector(10 downto 0);

Signal wea 					  : std_logic_vector(0 downto 0);
signal addra				  : std_logic_vector(9 downto 0):=(others => '0');
--signal addrb				  : std_logic_vector(9 downto 0):=(others => '0');
signal dina					  : std_logic_vector(15 downto 0):=(others => '0');

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
	EvBufffOut		=> EvBufffOut,			
	EvBuffEmpty		=> EvBuffEmpty,			
	EvBuffWdsUsed	=> EvBuffWdsUsed		
	);
	
	
Gen_Two_AFEs : for i in 0 to 1 generate
Gen_Eight_Chans : for k in 0 to 7 generate
AFEBuff : DPRAM_1Kx16
  PORT MAP ( 
	clka  => Clk80MHz, 
	wea   => wea, 
	addra => addra,	
    dina  => dina,	
	
	clkb  => Clk160MHz, -- 160 MHz
	addrb => BufferRdAdd(i)(k),
	doutb => BufferOut(i)(k)
);
end generate;
end generate;

Fill_RAM : process
begin 

	wait until rising_edge(CpldRst);
	for i in 0 to 1024 loop
	wea <= "1";
	addra <= std_logic_vector(unsigned(addra)+1);
	dina  <= std_logic_vector(unsigned(dina)+1);
	wait for Clk80MHz_period;
	end loop;

end process;	
--Read_RAM : process
--begin 
--
--	wait until rising_edge(givetime);
--	for i in 0 to 256 loop
--	addrb <= std_logic_vector(unsigned(addrb)+1);
--	wait for Clk80MHz_period;
--	end loop;
--
--end process;

uBunch_gen : process
begin 
	uBunch <= (others => '0');
	wait until rising_edge(Clk160MHz);
	for i in 0 to 1024 loop
	uBunchWrt <= '1';
	uBunch <= std_logic_vector(unsigned(uBunch)+1);
	wait for Clk80MHz_period;
	end loop;
	
end process;	
	
trigger_request: process
begin
	wait until rising_edge(Clk160MHz);
	SlfTrgEn	 	<= '1';

	MaskReg(0)		<= X"FF";
	MaskReg(1)		<= X"FF";

end process;

end EventBuilder_testbench_arch;

