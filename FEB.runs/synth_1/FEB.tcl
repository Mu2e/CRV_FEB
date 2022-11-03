# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
namespace eval ::optrace {
  variable script "C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.runs/synth_1/FEB.tcl"
  variable category "vivado_synth"
}

# Try to connect to running dispatch if we haven't done so already.
# This code assumes that the Tcl interpreter is not using threads,
# since the ::dispatch::connected variable isn't mutex protected.
if {![info exists ::dispatch::connected]} {
  namespace eval ::dispatch {
    variable connected false
    if {[llength [array get env XILINX_CD_CONNECT_ID]] > 0} {
      set result "true"
      if {[catch {
        if {[lsearch -exact [package names] DispatchTcl] < 0} {
          set result [load librdi_cd_clienttcl[info sharedlibextension]] 
        }
        if {$result eq "false"} {
          puts "WARNING: Could not load dispatch client library"
        }
        set connect_id [ ::dispatch::init_client -mode EXISTING_SERVER ]
        if { $connect_id eq "" } {
          puts "WARNING: Could not initialize dispatch client"
        } else {
          puts "INFO: Dispatch client connection id - $connect_id"
          set connected true
        }
      } catch_res]} {
        puts "WARNING: failed to connect to dispatch server - $catch_res"
      }
    }
  }
}
if {$::dispatch::connected} {
  # Remove the dummy proc if it exists.
  if { [expr {[llength [info procs ::OPTRACE]] > 0}] } {
    rename ::OPTRACE ""
  }
  proc ::OPTRACE { task action {tags {} } } {
    ::vitis_log::op_trace "$task" $action -tags $tags -script $::optrace::script -category $::optrace::category
  }
  # dispatch is generic. We specifically want to attach logging.
  ::vitis_log::connect_client
} else {
  # Add dummy proc if it doesn't exist.
  if { [expr {[llength [info procs ::OPTRACE]] == 0}] } {
    proc ::OPTRACE {{arg1 \"\" } {arg2 \"\"} {arg3 \"\" } {arg4 \"\"} {arg5 \"\" } {arg6 \"\"}} {
        # Do nothing
    }
  }
}

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
OPTRACE "synth_1" START { ROLLUP_AUTO }
set_param simulator.modelsimInstallPath C:/intelFPGA/20.1/modelsim_ae/win32aloem
OPTRACE "Creating in-memory project" START { }
create_project -in_memory -part xc7s50fgga484-2

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.cache/wt [current_project]
set_property parent.project_path C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
OPTRACE "Creating in-memory project" END { }
OPTRACE "Adding files" START { }
add_files -quiet c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/OLD_AFE_DP_Pipeline/OLD_AFE_DP_Pipeline.dcp
set_property used_in_implementation false [get_files c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/OLD_AFE_DP_Pipeline/OLD_AFE_DP_Pipeline.dcp]
read_vhdl -library work {
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/Proj_Def.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/AFE_DataPath.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/AFE_Interface.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/Auto_AFE.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/Phase_Detector.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/auto_FSM.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/febit.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/FEB.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/AFE_Pipeline.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/Trigger.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/FM_Serializer.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/FM_Deserializer.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/EventBuilder.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/One_Wire.vhd
  C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/LVDS_TX.vhd
  {C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/new/DDR_Interface .vhd}
}
read_ip -quiet C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/ip/DPRAM_1Kx16_1/DPRAM_1Kx16.xci
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/DPRAM_1Kx16/DPRAM_1Kx16_ooc.xdc]

read_ip -quiet C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/ip/AFE_DP_Pipeline/AFE_DP_Pipeline.xci
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/AFE_DP_Pipeline/AFE_DP_Pipeline_ooc.xdc]

read_ip -quiet C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/ip/SCFIFO_32x256/SCFIFO_32x256.xci
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/SCFIFO_32x256/SCFIFO_32x256.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/SCFIFO_32x256/SCFIFO_32x256_ooc.xdc]

read_ip -quiet C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/ip/SCFIFO_1Kx16/SCFIFO_1Kx16.xci
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/SCFIFO_1Kx16/SCFIFO_1Kx16.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/SCFIFO_1Kx16/SCFIFO_1Kx16_ooc.xdc]

read_ip -quiet C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/ip/LVDSTxBuff/LVDSTxBuff.xci
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/LVDSTxBuff/LVDSTxBuff.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/LVDSTxBuff/LVDSTxBuff_ooc.xdc]

read_ip -quiet C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/sources_1/ip/DDR3LController/DDR3LController.xci
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/DDR3LController/DDR3LController/user_design/constraints/DDR3LController.xdc]
set_property used_in_implementation false [get_files -all c:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.gen/sources_1/ip/DDR3LController/DDR3LController/user_design/constraints/DDR3LController_ooc.xdc]

OPTRACE "Adding files" END { }
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/constrs_1/new/FEB_contraints.xdc
set_property used_in_implementation false [get_files C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/constrs_1/new/FEB_contraints.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1

read_checkpoint -auto_incremental -incremental C:/Users/mrigatti/Desktop/CRV/2.Firmware/FEB/FEB.srcs/utils_1/imports/synth_1/FEB.dcp
close [open __synthesis_is_running__ w]

OPTRACE "synth_design" START { }
synth_design -top FEB -part xc7s50fgga484-2
OPTRACE "synth_design" END { }
if { [get_msg_config -count -severity {CRITICAL WARNING}] > 0 } {
 send_msg_id runtcl-6 info "Synthesis results are not added to the cache due to CRITICAL_WARNING"
}


OPTRACE "write_checkpoint" START { CHECKPOINT }
# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef FEB.dcp
OPTRACE "write_checkpoint" END { }
OPTRACE "synth reports" START { REPORT }
create_report "synth_1_synth_report_utilization_0" "report_utilization -file FEB_utilization_synth.rpt -pb FEB_utilization_synth.pb"
OPTRACE "synth reports" END { }
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
OPTRACE "synth_1" END { }
