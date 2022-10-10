----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/09/2022 09:17:56 AM
-- Design Name: 
-- Module Name: Proj_Def - Behavioral
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

package Proj_Def is


    constant afe_data_bit_width_idelay_taps: integer := 12;

	-- Define Arrays in terms of their size
	
	-- Use this to deal with (0 downto 0)
	Type Array_2x1 is Array(0 to 1) of std_logic_vector (0 downto 0);
	
	Type Array_2x2 is Array(0 to 1) of std_logic_vector(1 downto 0);
	Type Array_2x3 is Array(0 to 1) of std_logic_vector (2 downto 0);
	Type Array_2x4 is Array(0 to 1) of std_logic_vector(3 downto 0);
	Type Array_2x5 is Array(0 to 1) of std_logic_vector(4 downto 0);
	Type Array_2x6 is Array(0 to 1) of std_logic_vector(5 downto 0);
	Type Array_2x8 is Array(0 to 1) of std_logic_vector(7 downto 0);
	Type Array_2x9 is Array(0 to 1) of std_logic_vector(8 downto 0);
	Type Array_2x10 is Array(0 to 1) of std_logic_vector(9 downto 0); 
	Type Array_2x11 is Array(0 to 1) of std_logic_vector(10 downto 0); 
	Type Array_2x12 is Array(0 to 1) of std_logic_vector(11 downto 0);
	Type Array_2x16 is Array(0 to 1) of std_logic_vector(15 downto 0); 
	Type Array_2x32 is Array(0 to 1) of std_logic_vector(31 downto 0); 
	
	Type Array_5x9 is Array (0 to 4) of std_logic_vector(8 downto 0);
	
	Type Array_8x2 is Array(0 to 7) of std_logic_vector(1 downto 0); 
	Type Array_8x4 is Array(0 to 7) of std_logic_vector(3 downto 0);
	Type Array_8x6 is Array(0 to 7) of std_logic_vector(5 downto 0);
	Type Array_8x8 is Array(0 to 7) of std_logic_vector(7 downto 0);
	Type Array_8x10 is Array(0 to 7) of std_logic_vector(9 downto 0);
	Type Array_8x12 is Array(0 to 7) of std_logic_vector(11 downto 0);
	Type Array_8x14 is Array(0 to 7) of std_logic_vector(13 downto 0);
	Type Array_8x16 is Array(0 to 7) of std_logic_vector(15 downto 0);
	
	Type Array_2x8x2 is Array(0 to 1) of Array_8x2;
	Type Array_2x8x4 is Array(0 to 1) of Array_8x4;
	Type Array_2x8x8 is Array(0 to 1) of Array_8x8;
	Type Array_2x8x10 is Array(0 to 1) of Array_8x10;
	Type Array_2x8x12 is Array(0 to 1) of Array_8x12;
	Type Array_2x8x16 is Array(0 to 1) of Array_8x16;
	
	-- Signed arrays
	Type Arrays_3x12 is Array(0 to 2) of signed(11 downto 0);
	Type Arrays_8x12 is Array(0 to 7) of signed(11 downto 0);
	Type Arrays_8x16 is Array(0 to 7) of signed(15 downto 0);
	Type Arrays_2x3x12 is Array(0 to 1) of Arrays_3x12;
	Type Arrays_8x2x12 is Array(0 to 1) of Arrays_8x12;
	Type Arrays_8x2x16 is Array(0 to 1) of Arrays_8x16;


	component AFE_Interface
	port(
		-- AFE Input clocks
		AFE0Clk_P, AFE0Clk_N    : out std_logic; -- Copy of 80MHz master clock sent to AFE chips
		AFE1Clk_P, AFE1Clk_N    : out std_logic;
		-- AFE Data lines
		AFE0Dat_P, AFE0Dat_N    : in std_logic_vector(7 downto 0); -- LVDS pairs from an AFE chip (8 channels)
		AFE1Dat_P, AFE1Dat_N    : in std_logic_vector(7 downto 0);
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
								
		-- FPGA interface       
		Clk_80MHz			    : in  std_logic; 	-- Master clock 80MHz
		Clk_560MHz			    : in  std_logic; 	-- 7 x Master clock = 560MHz
		Clk_200MHz			    : in  std_logic; 	-- 200 MHz refclk for the IDELAY2
		reset				    : in  std_logic;
		done				    : out std_logic_vector(1 downto 0); -- status of automatic alignment FSM
		warn				    : out std_logic_vector(1 downto 0); -- pulse to indicate an error was seen in the FCLK pattern
		dout_afe0				: out Array_8x14; -- data synchronized to clock
		dout_afe1				: out Array_8x14  -- data synchronized to clock  
	);
	end component;

component AFE_DataPath is
  Port (
	Clk_80MHz			: in std_logic; 
	SysClk				: in std_logic; -- 160 MHz
  -- Data output from the deserializer for AFE0 and AFE1 synchronized to 80 MHz clock
    din_AFE0			: in Array_8x14; 
    din_AFE1			: in Array_8x14  
	);
end component;	
	
	
-----------------------------------------------------------------------
------------------------ Xilinx IP Components -------------------------
-----------------------------------------------------------------------	

	component DPRAM_1Kx16 is
	port (
    clka 					  : in std_logic;
    wea   					  : in std_logic_vector(0 downto 0);
    addra 					  : in std_logic_vector(9 downto 0);
    dina  					  : in std_logic_vector(15 downto 0);
    clkb  					  : in std_logic;
    addrb 					  : in std_logic_vector(9 downto 0);
    doutb 					  : out std_logic_vector(15 downto 0)
	);
	end component;
	
end package;