LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

use work.Proj_Def.all;

entity Pipeline_testbench is
end Pipeline_testbench;


architecture Pipeline_testbench_arch of Pipeline_testbench is

component OLD_AFE_DP_Pipeline
  port (
    clka,clkb : in std_logic;
	 wea : in std_logic_vector(0 downto 0);
    addra,addrb : in std_logic_vector(7 downto 0);
    dina : in std_logic_vector(95 downto 0);
    doutb : out std_logic_vector(95 downto 0)
    );
end component;

constant Clk200MHz_period:   time := 5.0ns;   -- 200 MHz
constant Clk160MHz_period: time := 6.25ns;  -- 160 MHz
constant Clk80MHz_period:   time := 12.5ns;  -- 80 MHz
constant Clk560MHz_period: time := 1.786ns; -- 80 MHz * 7 = 560MHz

signal reset: std_logic := '1';
signal CpldRst: std_logic := '1';
signal Clk200MHz, Clk160MHz, Clk80MHz, Clk560MHz: std_logic := '0';


-- Input pipeline delay signals
Type Array_2x8 is Array(0 to 1) of std_logic_vector(7 downto 0);
signal DPWrtAd,DPRdAd : Array_2x8;
signal PipeWrt, RstReq : std_logic_vector(1 downto 0);
Type Array_8x12 is Array(0 to 7) of std_logic_vector(11 downto 0);
Type Array_2x8x12 is Array(0 to 1) of Array_8x12;
Type Array_2x6 is Array(0 to 1) of std_logic_vector(5 downto 0);
Signal Ins,Outs : Array_2x8x12;
signal FrDat : Array_2x6;
signal PipelineSet : std_logic_vector (7 downto 0);
signal enb : std_logic;

signal d0_vec: std_logic_vector(11 downto 0) := "100000000001"; -- 0x801
signal d1_vec: std_logic_vector(11 downto 0) := "110000000011"; -- 0x803
signal d2_vec: std_logic_vector(11 downto 0) := "101010101010"; -- 0xAAA
signal d3_vec: std_logic_vector(11 downto 0) := "010101010101"; -- 0x555
signal d4_vec: std_logic_vector(11 downto 0) := "111111111111"; -- 0xFFF
signal d5_vec: std_logic_vector(11 downto 0) := "000000000000"; -- 0x000 
signal d6_vec: std_logic_vector(11 downto 0) := "101010111100"; -- 0x0ABC
signal d7_vec: std_logic_vector(11 downto 0) := "000000000000"; -- count up
signal d8_vec: std_logic_vector(11 downto 0) := "111111000000"; -- aka FCLK should be 0x3F80



begin

--make the reset
reset <= '1', '0' after 13ns;
CpldRst <= '0', '1' after 13ns;

-- make the clocks
Clk80MHz <= not Clk80MHz after Clk80MHz_period/2;
Clk160MHz <= not Clk160MHz after Clk160MHz_period/2;
Clk200MHz <= not Clk200MHz after Clk200MHz_period/2;
Clk560MHz <= not Clk560MHz after Clk560MHz_period/2;


GenOnePerAFE : for i in 0 to 1 generate
sender: process
begin
    wait until rising_edge(Clk80MHz);
	Ins(i)(7)(11 downto 6) <= d7_vec(11 downto 6);
	Ins(i)(6)(11 downto 6) <= d6_vec(11 downto 6);
	Ins(i)(5)(11 downto 6) <= d5_vec(11 downto 6);
	Ins(i)(4)(11 downto 6) <= d4_vec(11 downto 6);
	Ins(i)(3)(11 downto 6) <= d3_vec(11 downto 6);
	Ins(i)(2)(11 downto 6) <= d2_vec(11 downto 6);
	Ins(i)(1)(11 downto 6) <= d1_vec(11 downto 6);
	Ins(i)(0)(11 downto 6) <= d0_vec(11 downto 6);
	FrDat(i) <= d8_vec(11 downto 6);
    wait until falling_edge(Clk80MHz);
	Ins(i)(7)(5 downto 0) <= d7_vec(5 downto 0);
	Ins(i)(6)(5 downto 0) <= d6_vec(5 downto 0);
	Ins(i)(5)(5 downto 0) <= d5_vec(5 downto 0);
	Ins(i)(4)(5 downto 0) <= d4_vec(5 downto 0);
	Ins(i)(3)(5 downto 0) <= d3_vec(5 downto 0);
	Ins(i)(2)(5 downto 0) <= d2_vec(5 downto 0);
	Ins(i)(1)(5 downto 0) <= d1_vec(5 downto 0);
	Ins(i)(0)(5 downto 0) <= d0_vec(5 downto 0);
	FrDat(i) <= d8_vec(5 downto 0);
    d7_vec <= std_logic_vector(unsigned(d7_vec)+1);
	d6_vec <= std_logic_vector(unsigned(d6_vec)+1);
	d5_vec <= std_logic_vector(unsigned(d5_vec)+1);
	d4_vec <= std_logic_vector(unsigned(d4_vec)+1);
	d3_vec <= std_logic_vector(unsigned(d3_vec)+1);
	d2_vec <= std_logic_vector(unsigned(d2_vec)+1);
	d1_vec <= std_logic_vector(unsigned(d1_vec)+1);
	d0_vec <= std_logic_vector(unsigned(d0_vec)+1);	
end process sender;


-- pipeline is 96 bits wide which does eight channels of ADC data
Pipeline : OLD_AFE_DP_Pipeline
  PORT MAP (
    clka => Clk80MHz,
    wea => PipeWrt(i downto i),
    addra => DPWrtAd(i),
    addrb => DPRdAd(i),
    dina(95 downto 84) => Ins(i)(7), dina(83 downto 72) => Ins(i)(6),
    dina(71 downto 60) => Ins(i)(5), dina(59 downto 48) => Ins(i)(4),
    dina(47 downto 36) => Ins(i)(3), dina(35 downto 24) => Ins(i)(2),
    dina(23 downto 12) => Ins(i)(1), dina(11 downto 0) => Ins(i)(0),
    clkb => Clk80MHz,
    doutb(95 downto 84) => Outs(i)(7), doutb(83 downto 72) => Outs(i)(6),
    doutb(71 downto 60) => Outs(i)(5), doutb(59 downto 48) => Outs(i)(4),
    doutb(47 downto 36) => Outs(i)(3), doutb(35 downto 24) => Outs(i)(2),
    doutb(23 downto 12) => Outs(i)(1), doutb(11 downto 0) => Outs(i)(0)
   );
   
PipeWrt(i) <= Clk160MHz;

Gen_Eight_Chans : for k in 0 to 7 generate
Eight_Chans : process (Clk80MHz, CpldRst)
begin

if CpldRst = '0' then 
--	Ins(i)(k)(5 downto 0) <= (others => '0');
--	PipeWrt(i) <= '0';
	DPWrtAd(i) <= X"08";
	DPRdAd(i) <= (others => '0');
	PipelineSet <= X"04";

elsif rising_edge (Clk80MHz) then
		
-- Copy six bit shift result to six bit register to form a 12 bit result
--Ins(i)(k)(5 downto 0) <= Ins(i)(k)(11 downto 6);
	
-- Read and write addresses for the pipeline delay
if PipeWrt(i) = '1' and DPRdAd(i) = X"FF" then 
	DPRdAd(i) <= (others => '0');
	DPWrtAd(i) <= PipelineSet;
  elsif PipeWrt(i) = '1' and DPRdAd(i) /= X"FF" then 
		  DPWrtAd(i) <= DPWrtAd(i) + 1;
		  DPRdAd(i)  <= DPRdAd(i) + 1;
	else DPWrtAd(i) <= DPWrtAd(i);
		  DPRdAd(i) <= DPRdAd(i);
 end if;

-- Increment the pipeline every other clock tick
--	if FRDat(i) = 63 then PipeWrt(i) <= '1';
--	else PipeWrt(i) <= '0';
--	end if;



end if;

end process;

end generate;


end generate;



end Pipeline_testbench_arch;

