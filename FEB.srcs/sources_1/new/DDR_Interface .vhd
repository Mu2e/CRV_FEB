----------------------------------------------------------------------------------
-- Company: FNAL
-- Engineer: Micol Rigatti <mrigatti@fnal.gov> 
-- 
-- Create Date: 10/27/2022 12:12:09 PM
-- Design Name: 
-- Module Name: DDR Interface - Behavioral
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


entity DDR_Interface is
port (
	SysClk				: in std_logic; -- 160 MHz
	CpldRst				: in std_logic;
	ResetHi				: in std_logic;
-- Signals for the DDR	
	EvBuffRd			: out std_logic;
	EvBufffOut			: in std_logic_vector(15 downto 0);
	EvBuffEmpty			: in std_logic;
	EvBuffWdsUsed		: in std_logic_vector(10 downto 0)
	);
end DDR_Interface;

architecture Behavioral of DDR_Interface is


begin


main : process(SysClk, CpldRst)
begin 
if CpldRst = '0' then

elsif rising_edge (SysClk) then

end if;
end process;

end Behavioral;