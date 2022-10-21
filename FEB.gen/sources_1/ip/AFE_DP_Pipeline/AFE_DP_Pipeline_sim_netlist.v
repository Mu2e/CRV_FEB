// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Thu Oct 20 17:27:37 2022
// Host        : CD-135239 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/AFE_DP_Pipeline/AFE_DP_Pipeline_sim_netlist.v
// Design      : AFE_DP_Pipeline
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s50fgga484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "AFE_DP_Pipeline,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module AFE_DP_Pipeline
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [111:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [111:0]doutb;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire clkb;
  wire [111:0]dina;
  wire [111:0]doutb;
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
  wire [111:0]NLW_U0_douta_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [111:0]NLW_U0_s_axi_rdata_UNCONNECTED;
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
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     13.369 mW" *) 
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
  (* C_READ_WIDTH_A = "112" *) 
  (* C_READ_WIDTH_B = "112" *) 
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
  (* C_WRITE_MODE_A = "NO_CHANGE" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "112" *) 
  (* C_WRITE_WIDTH_B = "112" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  AFE_DP_Pipeline_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[111:0]),
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
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[111:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 54576)
`pragma protect data_block
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
fWKmborPgWiNL5FWgwKLGUPJ+4qWJIv9i+Qf
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
