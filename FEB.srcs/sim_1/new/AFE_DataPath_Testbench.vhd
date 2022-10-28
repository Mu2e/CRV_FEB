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
signal done					  : std_logic_vector(1 downto 0);

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
signal TrigReq				  : std_logic;
signal PipelineSet 			  : std_logic_vector (7 downto 0) := X"04";
signal ResetHi         		  : std_logic;
signal BeamOn				  : std_logic;
signal MaskReg				  : Array_2x8;
signal BufferRdAdd			  : Array_2x8x10;
signal BufferOut 			  : Array_2x8x16;
signal ControllerNo 		  : std_logic_vector (4 downto 0);
signal PortNo 				  : std_logic_vector (4 downto 0);
signal BeamOnLength 		  : std_logic_vector (11 downto 0);
signal BeamOffLength 		  : std_logic_vector (11 downto 0);
signal ADCSmplCntReg 		  : std_logic_vector (3 downto 0);

begin

--make the reset
reset <= '1', '0' after 50ns;
CpldRst <= '1', '0' after 5ns, '1' after 50ns;

-- make the clocks
sclk <= not sclk after sclk_period/2;
sysclk <= not sysclk after sysclk_period/2;
aclk <= not aclk after aclk_period/2; 

GA <= "00";

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
	done        => done,
	dout_afe0	=> dout_AFE0,				  
	dout_afe1	=> dout_AFE1
  );
  

AFE_DataPath_inst : AFE_DataPath
port map (
	Clk_80MHz	    => aclk,		
	SysClk			=> sysclk,
	ResetHi			=> ResetHi,
	TrigReq			=> TrigReq,
	BeamOn			=> BeamOn,
	MaskReg			=> MaskReg,					
	BufferRdAdd		=> BufferRdAdd,				
	BufferOut 		=> BufferOut, 
	ControllerNo 	=> ControllerNo, 
	PortNo 		    => PortNo, 		
	BeamOnLength    => BeamOnLength, 
	BeamOffLength   => BeamOffLength,
	ADCSmplCntReg	=> ADCSmplCntReg,
    din_AFE0		=> dout_AFE0,
    din_AFE1		=> dout_AFE1,
	done 			=> done,
	PipelineSet		=> PipelineSet,

	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
	uCA				=> uCA,
	uCD             => uCD,
	GA              => GA 
 			    
	);
end AFE_DataPath_testbench_arch;

