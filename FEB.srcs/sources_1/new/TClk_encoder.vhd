
---------------------- TClk encoder section ----------------------------
-- Transmits a TClk serial stream at 1/10 the clock rate. 
-- A 100MHz clock encodes 10MHz FM serial data

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.Proj_Defs.all;

entity TClk_Tx is
		 port(clock,reset : in std_logic;
				TCTx_In : in TClkTxInRec;
				TCTx_Out : buffer TClkTxOutRec);
end TClk_Tx;

architecture behavioural_TTx of TClk_Tx is

-- Serializer state machine
Type TClkTx_State is (TxIdle,TxStrt,ShftTx,ParityTx);
signal TCTx_State : TClkTx_State;

-- Shift register, bit width counter
signal TxShft : std_logic_vector (7 downto 0);
-- Frame bit counter, bit width timer
signal TCTxBtCnt : std_logic_vector (2 downto 0);
signal TCTxWidth : std_logic_vector (3 downto 0);
-- Transmitted TClk data, running parity bit
signal Parity,Tx_Req : std_logic;
signal EnDL : std_logic_vector (1 downto 0);

begin

TClk_Encode : process(clock, reset)

begin

 if reset = '1' then 

	TCTx_State <= TxIdle; TCTx_Out.FM <= '0';
	TCTx_Out.Done <= '0'; Parity <= '0';
	TxShft <= X"00"; Tx_Req <= '0'; EnDL <= "00";
	TCTxWidth <= "0000"; TCTxBtCnt <= "000";

elsif rising_edge(clock) then

	EnDL(0) <= TCTx_In.En;
	EnDL(1) <= EnDL(0);

	if Tx_Req = '0' and EnDL = 1 and TCTx_State = TxIdle then Tx_Req <= '1';
	elsif  Tx_Req = '1' and TCTx_State = TxStrt then Tx_Req <= '0';
	else Tx_Req <= Tx_Req;
	end if;

if TCTxWidth < 9 then TCTxWidth <= TCTxWidth + 1;
else TCTxWidth <= "0000";
end if;

-- TxIdle,TxStrt,ShftTx,ParityTx
Case TCTx_State is
-- Send data on uC write
        When TxIdle => 
	 	 if Tx_Req = '1' and TCTxWidth = 9
		  then TCTx_State <= TxStrt;
			else TCTx_State <= TxIdle;
			end if;
 		When TxStrt =>
		 if TCTxWidth = 9 then TCTx_State <= ShftTx;
		  else TCTx_State <= TxStrt;
		 end if;
          When ShftTx =>
         if TCTxWidth = 9 and TCTxBtCnt = 0 then TCTx_State <= ParityTx;
         else TCTx_State <= ShftTx;
         end if;
           When ParityTx =>
         if TCTxWidth = 9 then TCTx_State <= TxIdle;
         else TCTx_State <= ParityTx;
         end if;
end case;

-- default state is a string of 1's
-- Two transitions per bit period is a 1, one transition a 0
if TCTxWidth = 9 or (TCTxWidth = 4 
					and (TCTx_State = TxIdle or (TxShft(7) = '1' and TCTx_State = ShftTx) 
					 or (Parity = '1' and TCTx_State = ParityTx)))
	then TCTx_Out.FM <= not TCTx_Out.FM;
else TCTx_Out.FM <= TCTx_Out.FM;
end if;
 
-- data frames are 8 bits long 
if TCTx_State = TxStrt and TCTxWidth = 9
  then TCTxBtCnt <= "111";
elsif TCTx_State = TxIdle then TCTxBtCnt <= "000";
elsif TCTx_State = ShftTx and TCTxWidth = 9 and TCTxBtCnt > 0 
	then TCTxBtCnt <= TCTxBtCnt - 1;
else TCTxBtCnt <= TCTxBtCnt;
end if;

-- Load shift register with data byte at the beginning of the transmit sequence
-- load condition
if TCTx_State = TxIdle and Tx_Req = '1' and TCTxWidth = 9
  then TxShft <= TCTx_In.Data;
-- Shift one bit left (MSB first) during data portion of frame
-- shift condition
elsif TCTx_State = ShftTx and TCTxWidth = 9 
	then TxShft <= (TxShft(6 downto 0) & '0');
else TxShft <= TxShft;
end if;

if (Parity = '1' and TCTx_State = TxIdle) -- reset parity at start
  or (TCTx_State = ShftTx and TCTxWidth = 3 and TxShft(7) = '1')
-- Toggle parity bit with each shifted out "0"
then Parity <= not  Parity;
else Parity <= Parity;
end if;

-- Indicate when a frame has been shifted out
if TCTxWidth = 9 and TCTx_State = ParityTx then TCTx_Out.Done <= '1';
else TCTx_Out.Done <= '0';
end if;

end if; -- reset

end process TClk_Encode;

end behavioural_TTx; -- of TClk_Tx
