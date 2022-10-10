// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Mon Oct 10 10:49:57 2022
// Host        : CD-135239 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ DPRAM_1Kx16_sim_netlist.v
// Design      : DPRAM_1Kx16
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50fgga484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DPRAM_1Kx16,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_5 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19328)
`pragma protect data_block
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
BnvGKi0=
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
