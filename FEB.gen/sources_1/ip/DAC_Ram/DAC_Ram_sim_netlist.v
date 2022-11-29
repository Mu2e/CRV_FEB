// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Tue Nov 29 12:29:09 2022
// Host        : CD-135239 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/DAC_Ram/DAC_Ram_sim_netlist.v
// Design      : DAC_Ram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50fgga484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DAC_Ram,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module DAC_Ram
   (clka,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [15:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [15:0]douta;

  wire [7:0]addra;
  wire clka;
  wire [15:0]dina;
  wire [15:0]douta;
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
  wire [15:0]NLW_U0_doutb_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
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
  (* C_INIT_FILE = "DAC_Ram.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "16" *) 
  (* C_READ_WIDTH_B = "16" *) 
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
  (* C_WRITE_WIDTH_A = "16" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  DAC_Ram_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[15:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20176)
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
