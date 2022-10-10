// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Mon Oct 10 10:49:57 2022
// Host        : CD-135239 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/DPRAM_1Kx16/DPRAM_1Kx16_sim_netlist.v
// Design      : DPRAM_1Kx16
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50fgga484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DPRAM_1Kx16,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module DPRAM_1Kx16
   (clka,
    wea,
    addra,
    dina,
    clkb,
    addrb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [15:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [9:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [15:0]doutb;

  wire [9:0]addra;
  wire [9:0]addrb;
  wire clka;
  wire clkb;
  wire [15:0]dina;
  wire [15:0]doutb;
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
  wire [15:0]NLW_U0_douta_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.87285 mW" *) 
  (* C_FAMILY = "spartan7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
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
  (* C_INIT_FILE = "DPRAM_1Kx16.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "16" *) 
  (* C_READ_WIDTH_B = "16" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
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
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "16" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  DPRAM_1Kx16_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[15:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[15:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19280)
`pragma protect data_block
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
j+KMkd4iQfi7ht3i8N8=
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
