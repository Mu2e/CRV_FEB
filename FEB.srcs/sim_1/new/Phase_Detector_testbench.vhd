----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/14/2022 09:13:06 AM
-- Design Name: 
-- Module Name: Phase_Detector_testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Proj_Def.all;


entity Phase_Detector_testbench is

end Phase_Detector_testbench;

architecture Behavioral of Phase_Detector_testbench is

component Phase_Detector is
port (
	SysClk				    : in std_logic;   -- 160 Mhz
	-- Microcontroller strobes
	CpldRst					: in std_logic; 
	-- Geographic address pins
	GA 						: in std_logic_vector(1 downto 0);
	-- Chip dependent I/O functions
	A7		 				: buffer std_logic;
	GPI0_N,GPI0_P			: in std_logic;
	-- Trigger Logic
	TrgSrc					: in std_logic;
	GPO						: in std_logic
);
end component;

constant sysclk_period  	: time := 6.25ns;  -- 160 MHz
constant RefIn_period		: time := 50ns;    -- 20 MHz
constant phase				: time := 1ns;
signal sysclk				: std_logic := '0';
signal RefIn				: std_logic := '0';
signal CpldRst				: std_logic;
signal GA 					: std_logic_vector(1 downto 0);
signal A7		 			: std_logic;
signal GPI0_P		        : std_logic := '0';
signal GPI0_N		        : std_logic := '1';
signal TrgSrc				: std_logic;
signal GPO					: std_logic;

begin

sysclk  <= not sysclk after sysclk_period/2;
RefIn   <= not RefIn after RefIn_period/2;
CpldRst <= '0', '1' after 96ns;


--GPI0_P 	<= not GPI0_P after RefIn_period/2;
GPI0_N  <= not GPI0_P;
TrgSrc  <= '0', '1' after 500 ns;
GPO    	<= '0';
GA    	<= "00";


Phase_Detector_inst: Phase_Detector
port map(
	SysClk 		=> SysClk,				    
	CpldRst		=> CpldRst,				
	GA 			=> GA,				
	A7		 	=> A7,			
	GPI0_N		=> GPI0_N,
	GPI0_P		=> GPI0_P,
	TrgSrc		=> TrgSrc, 					
	GPO			=> GPO
);

-- Generate a 20 MHz clock phase shifted 
-- to be compared with the 160Mhz/8=20 MHz
-- to test if the phase detector is working
phaseShift: process 
begin
wait until rising_edge(RefIn);
wait for phase;
	GPI0_P 	<= not GPI0_P;
wait until falling_edge(RefIn);
wait for phase;
	GPI0_P 	<= not GPI0_P;
end process;



end Behavioral;
