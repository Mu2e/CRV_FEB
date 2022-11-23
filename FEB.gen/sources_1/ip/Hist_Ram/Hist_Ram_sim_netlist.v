// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Wed Nov 23 15:20:35 2022
// Host        : CD-135239 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/Hist_Ram/Hist_Ram_sim_netlist.v
// Design      : Hist_Ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50fgga484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Hist_Ram,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module Hist_Ram
   (clka,
    rsta,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    web,
    addrb,
    dinb,
    doutb,
    rsta_busy,
    rstb_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) input rsta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) input rstb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [10:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [15:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [15:0]doutb;
  output rsta_busy;
  output rstb_busy;

  wire [9:0]addra;
  wire [10:0]addrb;
  wire clka;
  wire [31:0]dina;
  wire [15:0]dinb;
  wire [31:0]douta;
  wire [15:0]doutb;
  wire rsta;
  wire rsta_busy;
  wire rstb;
  wire rstb_busy;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
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
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.2102 mW" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "1" *) 
  (* C_HAS_RSTB = "1" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "Hist_Ram.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "16" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "SR" *) 
  (* C_RST_PRIORITY_B = "SR" *) 
  (* C_SIM_COLLISION_CHECK = "NONE" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  Hist_Ram_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(rsta),
        .rsta_busy(rsta_busy),
        .rstb(rstb),
        .rstb_busy(rstb_busy),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[15:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 32720)
`pragma protect data_block
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
yJs=
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
