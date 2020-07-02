# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
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
set_param xicom.use_bs_reader 1
set_param chipscope.maxJobs 2
create_project -in_memory -part xc7z020clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.cache/wt [current_project]
set_property parent.project_path /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part www.digilentinc.com:pynq-z1:part0:1.0 [current_project]
set_property ip_output_repo /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files -quiet /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/ise/pong_reference/pong_reference.runs/impl_1/pong_top_routed.dcp
set_property used_in_implementation false [get_files /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/ise/pong_reference/pong_reference.runs/impl_1/pong_top_routed.dcp]
read_vhdl -library xil_defaultlib {
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/record_p.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/BasicTest.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/BasicTestEnt.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ClkDivider.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ClockEnableManager.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ControlMenu.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Crane.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/CraneController.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Debouncer.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ascii_p.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/DisplayController.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Lauflicht.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Licht.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ModuleSelector.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/MotorController.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Pong.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/TextMover.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/ball_motion/src/ball_motion.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/score_display/src/bin_to_bcd_dec.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/clock_enable.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/clock_enable/src/clock_enable.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/collision_detection/src/collision_detection.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/rotary_encoder/ise/debounce.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/rotary_encoder/src/debounce.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/score_display/src/debounce.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/rotary_encoder/src/controller_interface.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/vga_controller/src/vga_controller.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/score_display/src/score_display.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/pong_toplevel.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/rotary_encoder/src/rot_enc_decoder.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/score_display/src/score_counter.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/pong_reference/src/score_display/src/seven_seg_dec.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/PynqDemoTop.vhd
}
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/constrs_1/imports/Downloads/Pynq_constraint_file.xdc
set_property used_in_implementation false [get_files /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/constrs_1/imports/Downloads/Pynq_constraint_file.xdc]

set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top PynqDemoTop -part xc7z020clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef PynqDemoTop.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file PynqDemoTop_utilization_synth.rpt -pb PynqDemoTop_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
