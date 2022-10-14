----------------------------------------------------------------------------------
-- Company: FNAL
-- Engineer: Micol Rigatti <mrigatti@fnal.gov>
-- 
-- Create Date: 09/09/2022 09:05:03 AM
-- Design Name: FEB.vhd
-- Module Name: FEB - Behavioral
-- Project Name: CRV FEB
-- Target Devices: xc7s50fgga484-2
-- Tool Versions: 2021.2
-- Description: 
-- AFE_Interface is based on the project of Jamieson Olsen <jamieson@fnal.gov> 
 
----------------------------------------------------------------------------------

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

use work.Proj_Def.all;


entity FEB is
port(
    -- Clocks
	Clk_80MHz			    : in  std_logic;
	Clk_560MHz			    : in  std_logic;	
	Clk_200MHz			    : in  std_logic;
	SysClk				    : in std_logic;   -- 160 Mhz
	-- AFE Data lines
	AFE0Dat_P, AFE0Dat_N    : in std_logic_vector(7 downto 0); -- LVDS pairs from an AFE chip (8 channels)
	AFE1Dat_P, AFE1Dat_N    : in std_logic_vector(7 downto 0);
	-- AFE Input clocks
	AFE0Clk_P, AFE0Clk_N    : out std_logic; -- Copy of 80MHz master clock sent to AFE chips
	AFE1Clk_P, AFE1Clk_N    : out std_logic;
	-- AFE clock, framing lines
	AFEDCLK_P, AFEDCLK_N    : in std_logic_vector(1 downto 0); -- Unused in this design 
	AFE0FCLK_P, AFE0FCLK_N  : in std_logic; -- LVDS pairs of the Frame Clock
	AFE1FCLK_P, AFE1FCLK_N  : in std_logic; -- LVDS pairs of the Frame Clock
	-- AFE serial control lines
	AFEPDn 				    : buffer std_logic_vector(1 downto 0);
	AFECS 				    : buffer std_logic_vector(1 downto 0);
	AFERst 				    : buffer std_logic;
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
	-- Chip dependent I/O functions
	A7,LVDSTX 				: buffer std_logic;
	GPI0_N,GPI0_P,GPI1  	: in std_logic
  );
end FEB;

architecture behavioural of FEB is

signal reset		          : std_logic;
signal done		              : std_logic_vector(1 downto 0); 
signal warn		              : std_logic_vector(1 downto 0); 
signal dout_AFE0		      : Array_8x14; 
signal dout_AFE1		      : Array_8x14;  


signal TrigReq		          : std_logic;

begin

AFE_Interface_inst : AFE_Interface
port map(
	AFE0Dat_P		=> AFE0Dat_P,
	AFE0Dat_N       => AFE0Dat_N,
	AFE1Dat_P       => AFE1Dat_P,
	AFE1Dat_N       => AFE1Dat_N,
	AFE0Clk_P       => AFE0Clk_P,
	AFE0Clk_N       => AFE0Clk_N,
	AFE1Clk_P       => AFE1Clk_P,
	AFE1Clk_N       => AFE1Clk_N,
	
	AFEDCLK_P       => AFEDCLK_P, -- unused
	AFEDCLK_N       => AFEDCLK_N, -- unused
	
	AFE0FCLK_P      => AFE0FCLK_P,
	AFE0FCLK_N      => AFE0FCLK_N,
	AFE1FCLK_P      => AFE1FCLK_P,
	AFE1FCLK_N      => AFE1FCLK_N,
	
	AFEPDn 		    => AFEPDn,
	AFECS 		    => AFECS,
	AFERst 		    => AFERst,
	AFESClk         => AFESClk,
	AFESDI  	    => AFESDI,
	AFESDO 		    => AFESDO,
	-- FPGA interface
	Clk_80MHz		=> Clk_80MHz,			  
	Clk_560MHz		=> Clk_560MHz,			  
	Clk_200MHz		=> Clk_200MHz,			  
	reset			=> reset,				  
	done			=> done,				  
	warn			=> warn,				  
	dout_AFE0		=> dout_AFE0,				  
	dout_AFE1		=> dout_AFE1				  
);

AFE_Buffer : AFE_DataPath
port map (
	Clk_80MHz	    => Clk_80MHz,		
	SysClk			=> SysClk,
	TrigReq			=> TrigReq,
    din_AFE0		=> dout_AFE0,
    din_AFE1		=> dout_AFE1,
	done 			=> done,

	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
	uCA				=> uCA,
	uCD             => uCD,
	GA              => GA 
 			    
	);



end behavioural;
