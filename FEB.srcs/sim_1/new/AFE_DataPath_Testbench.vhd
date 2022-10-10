library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

use work.Proj_Def.all;

entity AFE_DataPath_testbench is
end AFE_DataPath_testbench;


architecture AFE_DataPath_testbench_arch of AFE_DataPath_testbench is

component AFE5807 -- simple model of one AFE chip
generic(clkadc_period: time := 12.5ns);
port(
    clkadc_p, clkadc_n: in std_logic;
    afe_p: out std_logic_vector(8 downto 0); -- FCLK is bit 8
    afe_n: out std_logic_vector(8 downto 0)
  );
end component;


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
port (
	Clk_80MHz			: in std_logic; 
	SysClk				: in std_logic; -- 160 MHz
-- Data output from the deserializer for AFE0 and AFE1 synchronized to 80 MHz clock
	din_AFE0			: in Array_8x14; 
	din_AFE1			: in Array_8x14;
-- Microcontroller strobes
	CpldRst				: in std_logic;
	CpldCS				: in std_logic;
	uCRd				: in std_logic;
	uCWr 				: in std_logic;		
-- Microcontroller data and address buses	
	uCA 				: in std_logic_vector(11 downto 0);
	uCD 				: inout std_logic_vector(15 downto 0);
-- Geographic address pins
	GA 					: in std_logic_vector(1 downto 0)	
	);
end component;	

constant sclk_period:   time := 5.0ns;   -- 200 MHz
constant sysclk_period: time := 6.25ns;  -- 160 MHz
constant aclk_period:   time := 12.5ns;  -- 80 MHz
constant aclk7x_period: time := 1.786ns; -- 80 MHz * 7 = 560MHz

signal reset: std_logic := '1';
signal sclk, sysclk, aclk, aclk7x: std_logic := '0';

signal afe0_clk_p, afe0_clk_n : std_logic;
signal afe1_clk_p, afe1_clk_n : std_logic;
signal afe0_p, afe0_n		  : std_logic_vector(8 downto 0);
signal afe1_p, afe1_n		  : std_logic_vector(8 downto 0); 
signal dout_AFE0		      : Array_8x14; 
signal dout_AFE1		      : Array_8x14; 

signal AFEDCLK_P, AFEDCLK_N   : std_logic_vector(1 downto 0); 
signal AFEPDn 				  : std_logic_vector(1 downto 0);
signal AFECS 				  : std_logic_vector(1 downto 0);
signal AFERst 				  : std_logic;
signal AFESClk, AFESDI  	  : std_logic;
signal AFESDO 				  : std_logic;

signal CpldRst				  : std_logic;	
signal CpldCS 				  : std_logic;	
signal uCRd	  				  : std_logic;
signal uCWr 				  : std_logic;		
signal uCA 	  				  : std_logic_vector(11 downto 0);
signal uCD 	  				  : std_logic_vector(15 downto 0);
signal GA 					  : std_logic_vector(1 downto 0);


begin

reset <= '1', '0' after 96ns;

-- make tha clocks

sclk <= not sclk after sclk_period/2;
sysclk <= not sysclk after sysclk_period/2;
aclk <= not aclk after aclk_period/2; 

fastclk_proc: process
begin
    wait until rising_edge(aclk);
    for i in 5 downto 0 loop
        aclk7x <= '1';
        wait for aclk7x_period/2;
        aclk7x <= '0';
        wait for aclk7x_period/2;
    end loop;
        aclk7x <= '1';
        wait for aclk7x_period/2;
        aclk7x <= '0';
end process;

-- make 2 AFE chips....

afe0_inst: AFE5807
generic map(clkadc_period => aclk_period)
port map(
        clkadc_p => afe0_clk_p,
        clkadc_n => afe0_clk_n,
        afe_p    => afe0_p,
        afe_n    => afe0_n
);

afe1_inst: AFE5807
generic map(clkadc_period => aclk_period)
port map(
        clkadc_p => afe1_clk_p,
        clkadc_n => afe1_clk_n,
        afe_p    => afe1_p,
        afe_n    => afe1_n
);

AFE_Interface_inst: AFE_Interface
port map(
    AFE0Clk_P 	=> afe0_clk_p,
    AFE0Clk_N 	=> afe0_clk_n,
	AFE0Dat_P 	=> afe0_p(7 downto 0),
	AFE0Dat_N 	=> afe0_n(7 downto 0),
	AFE0FCLK_P  => afe0_p(8),
	AFE0FCLK_N  => afe0_n(8),
    	
    AFE1Clk_P   => afe1_clk_p,
    AFE1Clk_N   => afe1_clk_n,
	AFE1Dat_P   => afe1_p(7 downto 0),
	AFE1Dat_N   => afe1_n(7 downto 0),
	AFE1FCLK_P  => afe1_p(8),
	AFE1FCLK_N  => afe1_n(8),	
	
	AFEDCLK_P   => AFEDCLK_P,   
	AFEDCLK_N   => AFEDCLK_N, 

	AFEPDn 		=> AFEPDn, 				
	AFECS 		=> AFECS, 				
	AFERst 		=> AFERst, 				
	AFESClk     => AFESClk,     
	AFESDI  	=> AFESDI,	
	AFESDO 		=> AFESDO,   

    Clk_80MHz   => aclk,
    Clk_560MHz  => aclk7x,
    Clk_200MHz  => sclk,
    reset       => reset,
	dout_afe0	=> dout_AFE0,				  
	dout_afe1	=> dout_AFE1
  );
  
  
AFE_DataPath_inst: AFE_DataPath
port map(
	Clk_80MHz			=> aclk,
	SysClk				=> sysclk, -- 160 MHz

	din_AFE0			=> dout_AFE0, 
	din_AFE1			=> dout_AFE1,
	CpldRst				=> CpldRst,	
	CpldCS				=> CpldCS,	
	uCRd				=> uCRd,	
	uCWr 				=> uCWr, 	
	uCA 				=> uCA, 	
	uCD 				=> uCD, 	
	GA 					=> GA 		
  );

end AFE_DataPath_testbench_arch;

