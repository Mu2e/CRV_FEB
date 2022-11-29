-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
-- Date        : Tue Nov 29 12:28:24 2022
-- Host        : CD-135239 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top CMD_Fifo -prefix
--               CMD_Fifo_ ClkB_P_stub.vhdl
-- Design      : ClkB_P
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7s50fgga484-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CMD_Fifo is
  Port ( 
    clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 27 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 27 downto 0 );
    full : out STD_LOGIC;
    empty : out STD_LOGIC;
    wr_rst_busy : out STD_LOGIC;
    rd_rst_busy : out STD_LOGIC
  );

end CMD_Fifo;

architecture stub of CMD_Fifo is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,rst,din[27:0],wr_en,rd_en,dout[27:0],full,empty,wr_rst_busy,rd_rst_busy";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_6,Vivado 2021.2";
begin
end;
