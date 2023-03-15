// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Mon Mar 13 19:11:32 2023
// Host        : CD-135239 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/SysPLL/SysPLL_stub.v
// Design      : SysPLL
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s50fgga484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module SysPLL(Clk_80MHz, Clk_100MHz, SysClk, Clk_200MHz, 
  resetn, clk_in1_p, clk_in1_n)
/* synthesis syn_black_box black_box_pad_pin="Clk_80MHz,Clk_100MHz,SysClk,Clk_200MHz,resetn,clk_in1_p,clk_in1_n" */;
  output Clk_80MHz;
  output Clk_100MHz;
  output SysClk;
  output Clk_200MHz;
  input resetn;
  input clk_in1_p;
  input clk_in1_n;
endmodule
