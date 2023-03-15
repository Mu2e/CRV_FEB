
------------------------------ TClk decoder section ------------------------------
-- Receives a TClk serial stream at 1/10 the clock rate. 
-- A 100 (or 106.2) MHz clock decodes 10MHz FM serial data

LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE work.Proj_Defs.all;

entity TClk_Rx is
	port( clock,reset : in std_logic;
			TCRx_In : in TClkRxInRec;
	      TCRx_Out : buffer TClkRxOutRec);
end TClk_Rx;

architecture behavioural_TRx of Tclk_Rx is

Type TclkFMRx is (RxIdle,RxStrt,RxShift,ParityRx);
Signal Rx_State : TClkFMRx;
-- Registers for FM decoder
-- Shift register, bit width counter
signal TCRxWidth,TCRxBtCnt : std_logic_vector (3 downto 0);
-- Edge detector for incoming FM data
signal RxDl : std_logic_vector (1 downto 0);
-- Transmitted FM data, running parity bit
signal RxParity,Rx_NRZ : std_logic;

begin

Tclk_Decode : process(clock, reset)

begin

 if reset = '1' then 

	Rx_State <= RxIdle; RxDl <= "00"; 
	TCRx_Out.Done <= '0'; RxParity <= '0'; TCRx_Out.Parity_Err <= '0';
	TCRx_Out.data <= (others => '0'); TCRxBtCnt <= "0000"; 
	Rx_NRZ <= '0'; TCRxWidth <= "0000";

elsif rising_edge(clock) then

-- Synchronous edge detector of FM input transitions
RxDl(0) <= TCRx_In.FM;
RxDl(1) <= RxDl(0);

-- Reset sampling counter with every Clock transition while decoder is in Idle,
-- otherwise reset only once per bit period
if (RxDl(1) = '1' xor RxDl(0) = '1') and (TCRxWidth > 6 or Rx_State = RxIdle)
  then TCRxWidth <= "0000";
elsif TCRxWidth /= 15 and 
	not((RxDl(1) = '1' xor RxDl(0) = '1') and (TCRxWidth > 6 or Rx_State = RxIdle))
  then TCRxWidth <= TCRxWidth + 1;
else TCRxWidth <= TCRxWidth;
end if;

-- TClk decoder state machine (RxIdle,RxStrt,RxShift,ParityRx)
Case Rx_State is
        When RxIdle =>
         if TCRxWidth > 6 then Rx_State <= RxStrt;
         else Rx_State <= RxIdle;
         end if;
         When RxStrt =>
         if RxDl(1) = '1' xor RxDl(0) = '1' then Rx_State <= RxShift;
         else Rx_State <= RxStrt;
         end if;
        When RxShift =>
         if TCRxBtCnt = 7 and (RxDl(1) = '1' xor RxDl(0) = '1') and TCRxWidth > 6
                  then Rx_State <= ParityRx;
         else Rx_State <= RxShift;
         end if;
        When ParityRx =>
         if (RxDl(1) = '1' xor RxDl(0) = '1') and TCRxWidth > 6 then Rx_State <= RxIdle;
         else Rx_State <= ParityRx;
         end if;
end case;

-- Serial TData is 1 if transition is in the middle of the bit period,
-- 0 if it is at the end
if  Rx_NRZ = '1' and (RxDl(1) = '1' xor RxDl(0) = '1') and TCRxWidth > 6 
   then Rx_NRZ <= '0';
elsif Rx_NRZ = '0' and (RxDl(1) = '1' xor RxDl(0) = '1') and TCRxWidth <= 6
   then Rx_NRZ <= '1';
else Rx_NRZ <= Rx_NRZ;
end if;

-- TClk events are 8 bits long 
if Rx_State = RxShift and (RxDl(1) = '1' xor RxDl(0) = '1') and TCRxWidth > 6 
then TCRxBtCnt <= TCRxBtCnt + 1;
elsif Rx_State = RxStrt then TCRxBtCnt <= "0000";
else TCRxBtCnt <= TCRxBtCnt;
end if;

-- Data input shift register
if Rx_State = RxShift and TCRxWidth = 7 then TCRx_Out.data <= (TCRx_Out.data(6 downto 0) & Rx_NRZ);
else TCRx_Out.data <= TCRx_Out.data;
end if;

-- Parity bit. Toggle if serial data is a "1"
 if RxParity = '1' and Rx_State = RxStrt
  then RxParity <= '0';
 elsif Rx_State = RxShift and TCRxWidth = 7 and Rx_NRZ = '1'
  then  RxParity <= not  RxParity;
 else  RxParity <= RxParity;
 end if;

-- If transmitted parity doesn't match the running parity, parity error 
if (TCRx_Out.Parity_Err = '1' and TCRx_In.Clr_Err = '1')
or (TCRx_Out.Parity_Err = '0' and (Rx_NRZ = '1' xor RxParity = '1') and Rx_State = ParityRx
                 and (RxDl(1) = '1' xor RxDl(0) = '1') and TCRxWidth > 6)
then TCRx_Out.Parity_Err <= not TCRx_Out.Parity_Err;
else TCRx_Out.Parity_Err <= TCRx_Out.Parity_Err;
end if;

-- Hold Rx done high for one clock period.
if Rx_State = ParityRx and TCRxWidth = 6 then TCRx_Out.Done <= '1';
else TCRx_Out.Done <= '0';
end if;

end if; -- reset

end process TClk_Decode;

end behavioural_TRx; -- of TClk_Rx
