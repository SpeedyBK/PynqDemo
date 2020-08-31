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
create_project -in_memory -part xc7z020clg400-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.cache/wt [current_project]
set_property parent.project_path /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property board_part www.digilentinc.com:pynq-z1:part0:1.0 [current_project]
set_property ip_output_repo /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/AddressCounter.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/record_p.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/BasicTest.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/BasicTestEnt.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Score_Display/Binary_to_BCD.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ClkDivider.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ClockEnableManager.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ControlMenu.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Crane.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/CraneController.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Debouncer.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ascii_p.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/DisplayController.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Score_Display/Displaydriver.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/EnableGenerator.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Lauflicht.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Licht.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/ModuleSelector.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/MotorController.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/OneDigitCountTOP.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/OneDigitCounter.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/bd/PS/hdl/PS_wrapper.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/PWM.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Pong.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/Stepper.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/StepperArduino.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/sound_p.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/SoundInterface.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Score_Display/Spielstandszahler.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/StepperArduinoTOP.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/StepperTOP.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/TextMover.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/note_duration_fsm.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/address_generator.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/ball_motion.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/clock_enable.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/collision_detection.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/debounce.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/controller_interface.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/sine_lut_8_x_8.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/triangle_lut_8_x_8.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/square_lut_8_x_8.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/dds_synthesizer.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/stimmungstabelle.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/dds.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/melody_table.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/melody_player.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/vga_controller.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Score_Display/score_display.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/pong_toplevel.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/rot_enc_decoder.vhd
  /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/new/PynqDemoTop.vhd
}
read_vhdl -vhdl2008 -library xil_defaultlib /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/Modules/Pong_2020/Sound_Interface/SoundActivator.vhd
add_files /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/bd/PS/PS.bd
set_property used_in_implementation false [get_files -all /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/bd/PS/ip/PS_processing_system7_0_0/PS_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all /home/benjamin/Repositories/PynqDemo/PynqDemoDesign/PynqDemoDesign.srcs/sources_1/bd/PS/PS_ooc.xdc]

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

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top PynqDemoTop -part xc7z020clg400-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef PynqDemoTop.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file PynqDemoTop_utilization_synth.rpt -pb PynqDemoTop_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
