LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

use work.Proj_Def.all;



entity LVDS_TX is
port (
	Clk_100MHz				: in std_logic;
	ResetHi					: in std_logic; 
	-- Microcontroller data and address buses
	uCA 					: in std_logic_vector(11 downto 0);
	uCD 					: inout std_logic_vector(15 downto 0);
	-- Microcontroller strobes
	CpldRst					: in std_logic;
	CpldCS					: in std_logic;
	uCRd					: in std_logic;
	uCWr 					: in std_logic;
	-- Geographic address pins
	GA 						: in std_logic_vector(1 downto 0);
	-- Chip dipendent I/O functions 
	LVDSTX 					: buffer std_logic;
	-- Other Logic 
	FMTxBuff_wreq			: in std_logic
	
);
end LVDS_TX;

architecture Behavioral of LVDS_TX is

signal uWRDL 	: std_logic_vector(1 downto 0);
signal TxPDat	: std_logic_vector(15 downto 0);
signal TxEn		: std_logic;
signal FMTxBuff_empty : std_logic;
signal FMTxBuff_full  : std_logic;
signal TxOuts 	: TxOutRec;

begin
-- Transmits an FM serial stream at 1/4 the clock rate.
FMTx : FM_Tx 
generic map (Pwidth => 16)
port map (
	clock 	=> Clk_100MHz,
	reset 	=> ResetHi,
	Enable 	=> TxEn,
	Data 	=> TxPDat,
	Tx_Out 	=> TxOuts
);


LVDSTX <= TxOuts.FM;
TxEn <= not FMTxBuff_empty and not TxOuts.Done;

-- Buffer data written from the uC to the LVDS Tx port
FMTx_Buff : LVDSTxBuff
port map(
	clk 	=> Clk_100MHz,
    rst 	=> ResetHi, 
    din 	=> uCD,
    wr_en 	=> FMTxBuff_wreq,
    rd_en 	=> TxOuts.Done,
    dout 	=> TxPDat,
    full 	=> FMTxBuff_full,
    empty 	=> FMTxBuff_empty
);

Clk100 : process(Clk_100MHz, CpldRst)
begin 

if CpldRst = '0' then

	uWRDL <= "00";
	FMTxBuff_wreq <= '0';

elsif rising_edge (Clk_100MHz) then 

uWRDL(0) <= not uCWR and not CpldCS;
uWRDL(1) <= uWRDL(0);


-- Strobe to write data to LVDS FM return link
if uWRDL = 1 and uCA(11 downto 10) = GA and uCA(9 downto 0) = LVDSTxFIFOAd 
then FMTxBuff_wreq <= '1';
else FMTxBuff_wreq <= '0';
end if;

end if;
end process;

end Behavioral;