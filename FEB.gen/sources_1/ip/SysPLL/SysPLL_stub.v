// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Tue Nov 29 12:06:18 2022
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
