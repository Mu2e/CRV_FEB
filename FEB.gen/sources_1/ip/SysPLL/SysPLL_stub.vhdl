-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
-- Date        : Mon Mar 13 19:11:32 2023
-- Host        : CD-135239 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/SysPLL/SysPLL_stub.vhdl
-- Design      : SysPLL
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7s50fgga484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SysPLL is
  Port ( 
    Clk_80MHz : out STD_LOGIC;
    Clk_100MHz : out STD_LOGIC;
    SysClk : out STD_LOGIC;
    Clk_200MHz : out STD_LOGIC;
    resetn : in STD_LOGIC;
    clk_in1_p : in STD_LOGIC;
    clk_in1_n : in STD_LOGIC
  );

end SysPLL;

architecture stub of SysPLL is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "Clk_80MHz,Clk_100MHz,SysClk,Clk_200MHz,resetn,clk_in1_p,clk_in1_n";
begin
end;
