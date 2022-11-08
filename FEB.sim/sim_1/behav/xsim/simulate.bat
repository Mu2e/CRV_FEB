@echo off
REM ****************************************************************************
REM Vivado (TM) v2021.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Fri Nov 04 09:43:52 -0500 2022
REM SW Build 3367213 on Tue Oct 19 02:48:09 MDT 2021
REM
REM IP Build 3369179 on Thu Oct 21 08:25:16 MDT 2021
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim DDR_Interface_testbench_behav -key {Behavioral:sim_1:Functional:DDR_Interface_testbench} -tclbatch DDR_Interface_testbench.tcl -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/AFE_DataPath_testbench_behav.wcfg -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/Pipeline_testbench_behav.wcfg -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/Trigger_testbench_behav.wcfg -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/AFE_DataPath_light_testbench_behav.wcfg -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/EventBuilder_testbench_behav.wcfg -log simulate.log"
call xsim  DDR_Interface_testbench_behav -key {Behavioral:sim_1:Functional:DDR_Interface_testbench} -tclbatch DDR_Interface_testbench.tcl -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/AFE_DataPath_testbench_behav.wcfg -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/Pipeline_testbench_behav.wcfg -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/Trigger_testbench_behav.wcfg -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/AFE_DataPath_light_testbench_behav.wcfg -view C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/EventBuilder_testbench_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
