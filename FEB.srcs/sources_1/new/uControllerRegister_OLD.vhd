LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

use work.Proj_Def.all;

entity uControllerRegister is
  Port (
	BeamOnLength 		: out std_logic_vector (11 downto 0);
    BeamOffLength       : out std_logic_vector (11 downto 0);
	);
end uControllerRegister;  
  

architecture Behavioral of uControllerRegister is
begin

main : process(SysClk, CpldRst)
begin 
-- asynchronous reset/preset
if CpldRst = '0' then

	BeamOnLength <= X"050"; 
	BeamOffLength <= X"700";


elsif rising_edge (SysClk) then

WRDL(0) <= not uCWR and not CpldCS;
WRDL(1) <= WRDL(0);


-- Register for determining the live gate lengths
   if WRDL = 1 and uCA(9 downto 0) = BeamOnLengthAd
then BeamOnLength <= uCD(11 downto 0);
else BeamOnLength <= BeamOnLength;
end if;

   if WRDL = 1 and uCA(9 downto 0) = BeamOffLengthAd
then BeamOffLength <= uCD(11 downto 0);
else BeamOffLength <= BeamOffLength;
end if;


end if;
end process;

end Behavioral;