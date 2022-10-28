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
	-- 160 MHz VXO clock
	VXO_P,VXO_N 			: in std_logic;
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
	-- DDR3L pins
	DDR_DATA 				: inout std_logic_vector(15 downto 0);
	DDR_ADDR 				: out std_logic_vector(14 downto 0);
	BA 						: out std_logic_vector(2 downto 0);
	DDR_CKE	 				: out std_logic_vector(0 downto 0);
	ODT 					: out std_logic_vector(0 downto 0);
	CS 						: out std_logic_vector(0 downto 0);
	DM 						: out std_logic_vector(1 downto 0);
	RAS,CAS					: out std_logic; 
	DDR_WE 					: out std_logic;
	DDR_CLKP,DDR_CLKN 		: out  std_logic_vector(0 downto 0);
	LDQS_P, LDQS_N 			: inout std_logic;
	UDQS_P, UDQS_N 			: inout std_logic;
	SDRzq 					: inout std_logic;
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
	GPI0_N,GPI0_P,GPI1  	: in std_logic;
	-- LED/Flash Gate select line
	PulseSel 				: buffer std_logic;
	-- LED pulser/Flash Gate
	Pulse 					: out std_logic;
	-- Temperature sensor lines
	Temp : inout std_logic_vector(3 downto 0)
  );
end FEB;

architecture behavioural of FEB is

    -- Clocks
signal Clk_80MHz			  : std_logic;
signal Clk_100MHz			  : std_logic;	
signal Clk_200MHz			  : std_logic;
signal Clk_560MHz			  : std_logic;
signal SysClk				  : std_logic;   -- 160 Mhz

signal reset		          : std_logic;
signal done		              : std_logic_vector(1 downto 0); 
signal warn		              : std_logic_vector(1 downto 0); 
signal dout_AFE0		      : Array_8x14; 
signal dout_AFE1		      : Array_8x14;  
signal PipelineSet 			  : std_logic_vector (7 downto 0) := X"04";
signal ResetHi         		  : std_logic;
signal BeamOn				  : std_logic;
signal uWRDL				  : std_logic_vector(1 downto 0);
signal uBunch   			  : std_logic_vector(31 downto 0);
signal uBunchWrt			  : std_logic;
signal ControllerNo 		  : std_logic_vector (4 downto 0):= "00000";
signal PortNo 				  : std_logic_vector (4 downto 0):= "00000";
signal BeamOnLength 		  : std_logic_vector (11 downto 0) := X"050";
signal BeamOffLength 		  : std_logic_vector (11 downto 0) := X"700";
signal ADCSmplCntReg 		  : std_logic_vector (3 downto 0) := X"8";
signal MaskReg				  : Array_2x8;
signal BufferRdAdd			  : Array_2x8x10;
signal BufferOut 			  : Array_2x8x16;

signal TrigReq		          : std_logic;
signal SlfTrgEn				  : std_logic;
signal TrgSrc		          : std_logic;
signal GPO		          	  : std_logic;
signal GPI0		          	  : std_logic;
signal LEDSrc		          : std_logic;

signal EvBuffRd				  : std_logic;
signal EvBufffOut	          : std_logic_vector(15 downto 0);
signal EvBuffEmpty	          : std_logic;
signal EvBuffWdsUsed          : std_logic_vector(10 downto 0);

signal TempEn 				  : std_logic;
signal TempCtrl 			  : std_logic_vector(3 downto 0);
signal One_Wire_Out 		  : std_logic_vector(15 downto 0);

-- Synchronous edge detectors of uC read and write strobes
signal WRDL 	: std_logic_vector(1 downto 0);

begin

ResetHi <= not CpldRst;
global_signals : process(SysClk, CpldRst)
begin 
if CpldRst = '0' then
elsif rising_edge (SysClk) then

	WRDL(0) <= not uCWR and not CpldCS;
	WRDL(1) <= WRDL(0);

end if;
end process;

-- IBUFDS: Differential Input Buffer
GPI0DiffIn : IBUFDS
generic map (
	DIFF_TERM 	 => TRUE, -- Differential Termination
	IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
	IOSTANDARD   => "DEFAULT")
port map (
	I  => GPI0_P, -- Diff_p buffer input (connect directly to top-level port)
	IB => GPI0_N, -- Diff_n buffer input (connect directly to top-level port)
	O  => GPI0);	  -- Buffer output


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

AFE_DataPath_inst : AFE_DataPath
port map (
	Clk_80MHz	    => Clk_80MHz,		
	SysClk			=> SysClk,
	ResetHi			=> ResetHi,
-- Signals from Trigger Logic
	TrigReq			=> TrigReq,
	BeamOn			=> BeamOn,
-- Signals for EventBuilder
	MaskReg			=> MaskReg,			
	BufferRdAdd		=> BufferRdAdd,		
	BufferOut 		=> BufferOut, 		
-- Signals from uC
	ControllerNo 	=> ControllerNo, 
	PortNo 			=> PortNo,	
	BeamOnLength    => BeamOnLength,
	BeamOffLength   => BeamOffLength, 
	ADCSmplCntReg   => ADCSmplCntReg,
-- Data output from the deserializer for AFE0 and AFE1 synchronized to 80 MHz clock
    din_AFE0		=> dout_AFE0,
    din_AFE1		=> dout_AFE1,
	done 			=> done,
-- Pipeline signals 	
	PipelineSet		=> PipelineSet,

	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
	uCA				=> uCA,
	uCD             => uCD,
	GA              => GA 
 			    
	);

Phase_Detector_inst: Phase_Detector
port map(
	SysClk 			=> SysClk,	-- 160 MHz			    
	CpldRst			=> CpldRst,				
	GA 				=> GA,				
	A7		 		=> A7,			
	GPI0_N			=> GPI0_N,
	GPI0_P			=> GPI0_P,
	TrgSrc			=> TrgSrc, 					
	GPO				=> GPO
);


Trigger_logic: Trigger 
port map(
  	SysClk			=> SysClk, -- 160 MHz
	ResetHi  		=> ResetHi,
	
	TrigReq			=> TrigReq,
	SlfTrgEn		=> SlfTrgEn,
	BeamOn			=> BeamOn,
	uBunch   		=> uBunch,   
	uBunchWrt		=> uBunchWrt,
	
	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
	uCA 			=> uCA,
	uCD 			=> uCD,
	GA 				=> GA, 
	uWRDL 			=> uWRDL,
	WRDL 			=> WRDL,	
	PulseSel 		=> PulseSel,
	Pulse 			=> Pulse, 
	LEDSrc 			=> LEDSrc,
	GPI0 			=> GPI0 
);

EventBuilder_logic :  EventBuilder
port map(
	SysClk			=> SysClk,	 -- 160 MHz
	CpldRst			=> CpldRst,
	ResetHi			=> ResetHi,
-- Signals from/to AFE Buffer
	MaskReg			=> MaskReg,
	BufferRdAdd		=> BufferRdAdd,	
	BufferOut 		=> BufferOut, 	
-- Signals from Trigger Logic
	SlfTrgEn		=> SlfTrgEn,
	uBunchWrt		=> uBunchWrt,
	uBunch   		=> uBunch,
-- Signals for the DDR
	EvBuffRd		=> EvBuffRd,		
	EvBufffOut		=> EvBufffOut,			
	EvBuffEmpty		=> EvBuffEmpty,			
	EvBuffWdsUsed	=> EvBuffWdsUsed		
	);


DDR_Interface_inst : DDR_Interface
port map(
	VXO_P			=> VXO_P,	
	VXO_N 			=> VXO_N, 	
	SysClk			=> SysClk,	
	ResetHi			=> ResetHi,
-- DDR3L pins
	DDR_DATA		=> DDR_DATA,	
	DDR_ADDR		=> DDR_ADDR,	
	BA 				=> BA, 			
	DDR_CKE	 		=> DDR_CKE,		
	ODT 			=> ODT, 		
	CS 				=> CS, 			
	DM 				=> DM, 			
	RAS				=> RAS,
	CAS				=> CAS,		
	DDR_WE 			=> DDR_WE, 		
	DDR_CLKP        => DDR_CLKP,
	DDR_CLKN 	    => DDR_CLKN,
	LDQS_P          => LDQS_P,
	LDQS_N 		    => LDQS_N, 	
	UDQS_P          => UDQS_P,
	UDQS_N 		    => UDQS_N, 	
	SDRzq 			=> SDRzq, 		
-- Signals for the DDR	
	EvBuffRd		=> EvBuffRd,	
	EvBuffOut		=> EvBufffOut,	
	EvBuffEmpty		=> EvBuffEmpty,	
	EvBuffWdsUsed	=> EvBuffWdsUsed,
-- Signals from Trigger Logic
	SlfTrgEn 		=> SlfTrgEn, 	
	uBunchWrt		=> uBunchWrt,	
	uBunch			=> uBunch,		
-- Microcontroller strobes
	CpldRst			=> CpldRst,	
	CpldCS			=> CpldCS,	
	uCRd			=> uCRd,
	uCWr 			=> uCWr, 	
-- Microcontroller data and address buses	
	uCA 			=> uCA,
	uCD 			=> uCD,
-- Geographic address pins
	GA 				=> GA,
-- Synchronous edge detectors of uC read and write strobes
	--uWRDL 				: in std_logic_vector(1 downto 0);
	WRDL 			=> WRDL
);

-- Read the temperature/ID chip on the four connectoed CMBs
OneWire : One_Wire 
port map(
	reset 			=> CpldRst, 
	clock 			=> Clk_100MHz,
	CpldCS 			=> CpldCS, 
	uCWr 		  	=> uCWr, 
	GA 				=> GA, 
	uCA 			=> uCA, 
	uCD 			=> uCD,
	Temp 			=> Temp, 
	TempEn 			=> TempEn, 
	TempCtrl		=> TempCtrl, 
	One_Wire_Out 	=> One_Wire_Out
);

Temp(0) <= '0' when TempEn = '1' and TempCtrl = "0001" else 'Z';
Temp(1) <= '0' when TempEn = '1' and TempCtrl = "0010" else 'Z';
Temp(2) <= '0' when TempEn = '1' and TempCtrl = "0100" else 'Z';
Temp(3) <= '0' when TempEn = '1' and TempCtrl = "1000" else 'Z';


-- Data written from the uC to the LVDS Tx port
uC_to_LVDSTX : LVDS_TX
port map(
	Clk_100MHz		=> Clk_100MHz,
	ResetHi			=> ResetHi,
	-- Microcontroller data and address buses
	uCA 			=> uCA,
	uCD 			=> uCD,
	-- Microcontroller strobes
	CpldRst			=> CpldRst,		
	CpldCS			=> CpldCS,	
	uCRd			=> uCRd,	
	uCWr 			=> uCWr, 		
	-- Geographic address pins
	GA 				=> GA,
	-- Chip dipendent I/O functions 
	LVDSTX 			=> LVDSTX	
);



end behavioural;
