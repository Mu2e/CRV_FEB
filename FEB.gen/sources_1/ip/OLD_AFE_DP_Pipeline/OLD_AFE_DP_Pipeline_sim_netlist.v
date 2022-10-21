// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Thu Oct 20 16:06:47 2022
// Host        : CD-135239 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top OLD_AFE_DP_Pipeline -prefix
//               OLD_AFE_DP_Pipeline_ AFE_DP_Pipeline_sim_netlist.v
// Design      : AFE_DP_Pipeline
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50fgga484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "AFE_DP_Pipeline,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module OLD_AFE_DP_Pipeline
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [95:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [95:0]doutb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire clkb;
  wire [95:0]dina;
  wire [95:0]doutb;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [95:0]NLW_U0_douta_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [95:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     10.67465 mW" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "AFE_DP_Pipeline.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "96" *) 
  (* C_READ_WIDTH_B = "96" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "96" *) 
  (* C_WRITE_WIDTH_B = "96" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  OLD_AFE_DP_Pipeline_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[95:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[95:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oESHD2Q5NORrmTVTCApB+YFZJwjA1ezq7U6VZh96by+ofPCvSFp06AIoCLvB4BhPvxfob6kIkBpR
xVCOLM7HsDk7nO1JVWiYIJ6okoWTA8hAlPj3sdGuMwRlZNSBKn/c6F+CW5Jl37TEGotkhycSB3Bg
B/uu1THUZwIG87RPahE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
RovEhaqHrFqzjckk+DIWG8LQeqg2Y/nACQDyXKKtSav7YHlgpKmgHZnsxwwNpqrqVRGyjTecSQ+e
6Mr/Pi9au3AgJVPL6VOgwNVE0yj2LpA4LPyWzxLN3+DiSDmsaCBNCBlVQi2MRKUabou8nLaXldbL
+7pv4pYhQdcyjDzuC2dx3HmzADqstdEiyXeU3ktJ29CDLDmGwDWdmsrl90s4YQSfBV2nj4/Vut3L
p/8dzphf1htPaNMujMxxgp3z4JzUEDJJokDL+gNutEEHiaWpI3URIA5v22vJu+NPD+eEraSioHfL
DPKAajZTwK5FHnonu4O2D0co8GWqWW5cUqZz9A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jBQ6Th9yy7jtKQD1h235YLT6qO6XiBaBKGJrV1Z8H9M9ePJ9R/fA8E1okt4LyBvoWjR7tmCbIg7A
0/vuKOogkLtDE/BtTlp4z1iurO8rQrAcdZy/e+7GATawyJxFY7kZhnXASu9zB8TiOBELSlapkpxe
WuAzXLde9FBMBkq4RSc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eucSNV2Zbm4zYc2tIGRlGmlVM8+WHY1NHe9drZdgDhGPOHz8PTqHapfnZ1kWuTLtPBLSMvcXNScn
UTvpULofBV6qD7WHLPg7UJcjpZVDL69lk88chgqrlc/RqaJXKNVv+Ubku53ZLU20uZK71bNymjSM
855RVWw5lvTHTCNC2MYIS94Fmrzuq8i0+tFh5qBKkHK2BC+fD7xVyyfuh4mZR2yr/hRs/emoI79E
IKoJnLiglVp6RXTsXFzZW4pIthbjWSuZlOQvoYkS2RMj8a0r9lyariphRQunoudc0bLO4Phk578c
40gusaaS/MI7idMT7k1Di96kvu5mHi23loRcZQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
E/syLaRG2Ss/xTTkuAkOKXzm53+rCptYO2DkVukWhvlLmEB2daHCPrXt4gKeuG+0hIGWedSwCiLJ
7KNtEAiTumJ/j+3p7s3oXN9ftCSRolXoACsCclEAmwYjVM0ubCXUx6JNFOGt0yDl2Jsd5+W10mSJ
bYEKvRKi7koXM/eYJqbhTrtsrHDwRJEY0JVUPh8EOkLLqaIKbnjb6ENEY6qZOamp5PaWsSS30gJM
N6fB8D1AmGKnFbfY+d5TexS55Z92aYcAHNX2XwHsKnm45az1vHeZ0rTEU/oONIaSZfikRni1iDBg
x2GOue6sLiwxTEHaVkTJsOVR4mx0VsfFxavwRg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dSHHpkQiOEzzKs4D71WVyDXLpkKuR9h9h3pBLtnCq2bXiwE/eQHmk5HeQb+qREg0Yv193OukqaQz
RZyuF5GQcqOpqFHMxO62HQ2pdjdpMT5CC7gHvmgiw9qBkJJrXpihIHER4X7OF2iNUfeqxJ8eiSz3
C0V20NlIwKG7Mxg8MVj++xmb32KMUqL7ptikkym20vVdhecVMNvpPoXp8uvaGT7991enWP9HGKUC
9kLY2DEYwRGE71UJJLGWo4n49R50ExFRj91xWnYfvp7uJsMNwnBp5l3GTZiMELX2RkRVSPOHr7l1
n2p5Vq7Uee2drny1IxZ/4c0hYY6y3QWSEqpESw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HUtfqZ9dh5oZTOAt9a0ebo+wQbzg3izFQ0kVqZN81S4cBjQEF53WUiVlTKBDVjvLNUby4Se9WZjj
j86TQzuGJxLPDTohmbytErsg5JrlXHbHGwR4zGNGTbBs12X7PkxtS8wVCp+7b1rX6pOGOPqm6FoG
g6rZY/bTzVfGYF2CAOhjJUqUOXEAKnZRehspRyiBI28/ZZPSAUD/abKprW8PWCxMx2zPWztZz4No
R96jgvHezNzB1Ta8W7uRBFTMp+XVSToxTp2jzSXJZ0V5xJl+gdVjAMmf6+te2vqrK2wDWdMxk3Sf
iyLI4d0s25vCybcY2fZWacq5iO9pSlSaOQWgCA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
vYYu2Kvhv3RZi0pFbjRTQ/BBwfilCrGpkMls+Dz6HBGTZvSaC/anWgymoDS0XnoSENGG3Pz3EBF0
19OqLbyna95IHFe2bA7f8RgU9SEUffZ8eXGigfOjAWpZCN07Q77RkhGUKal7okWe3Q6xHtZy83l2
kW8ma3kOYL7GzQjtpbP3lINHLMqpGEo0dzbOHiJ5r6W5U6DsILGsoLQOXcw+MwrevvNRB0KkSklj
QnL8K2AK8PIsJGM6F8dj5KwRYhSBYNb1opuVpiJWlbHgADoeM+dhiRxBLmnaDE8PWs1ReY6uMzzH
SvvO6UEyxQtvS/Smm/uogr1eUFedUaBHPMEXnYlTAv/SKrh942GeknsqfrjGkZxWTN2NEnvpRUwT
fS0pyd/Err0s94b0srmcTYyxZfJGRUct2T8MCphZFaScAlhn655pxW9RaHMfcvDJUHpW8Qa+KhRt
9CWYScPIH6YNDByLQbhKL5BTpAYMNYPF2W7vM2ZzDob2NB7m6GGeKRr3

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QSNmIeTT4pBji+CTjknWXN6sH9Wff8+t8KF+AC3fIoIw08jtLtShcB9ZGeEKG02RGCO4lNIUf5YB
2TVYk6EJ5XyCav12qDhc60n56UVrnpfo7drorY0NmOypuxECgO43h6SDWp9W7px3r4CJnQ4+X2Mj
943GdP30WfL5kbWHZJC1Dz9cBIqRa1EbNXvvAqBvRPS2+aXBXAPOC4rNVZGeIUspn/33IW3yJLSp
Jm5GIct87ZuSoz8+DXhUvsTj4hq8lgirVhfz1qhHm8SfODcE91FGUPw3vbpGWXsBX73t2zxFC1Hz
/6m4YqQJVxd+H5iGE4kbHxHyHnH7FIerqc8Phw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UhfxKxECbuHK/o9ZExa2zP/MIPmFXuDNZwgpiawuBmPeRI1nJsYB7vzbBGMPKny4yIHLT8mHrQRc
fs05atkjIAbLea4+WNoCdCeg7/0PzuodM1ol3it6BHQ6Yzq4mnZbzlk8Xtwmk8ACAbzOr2SYxYWX
ueuUlimUSRusIe4+NiPvzbfHMAOVPjdmSY7zaSyeJuhdAR+fUGeHy5B23Xe2X6cDPeJ75IqcBeul
ox3dTXi3L8r/s1bTKX3FhxRyPZuh/xCWuEajsF2fEYdwWHKtLX6IQniLBJ5ZnVSS8D7IYPsvV4t0
9rWJqto5O1n3rAM44OvKvc9pOYXJupuv7g3gWg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fmo66vhS7nigYtLDMjdj7hgUnDG/fnO+cIaY/3qHrcwT7u/paj5enLuWHovegu9O9WRq3pPNnjuN
6vZRpuCgz5p4VAV7dVg9fuzg99BAjThp1Q/+HIPfdQ2LM14ZpTh4FXxthHGkTyS5PJArvZ3/UMpW
zwfdYd5+k2/emJ4/nuqoJHQG8k+O5EjSprLTvNZ/wrE1cT/fW/Lu2pxI4msHqVVYAXz7sJ13cQ+C
7tKxCV8vTyf0rpStdE+kZXg+jrc7vFKuPJO0U9axMsC0nXyeYx2jzfAHptGWKvfQaPg/Eo9mgLyN
qSJfFS6aIycuxNmg7L82WK401aWhnUn7GNrudg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 42576)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
