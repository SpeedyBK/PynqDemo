
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

hdi::project new -name pong -dir "Z:/vhdlect1/pong/ise/planAhead_run_1"
hdi::project setArch -name pong -arch spartan3
hdi::design setOptions -project pong -top pong_top  
hdi::param set -name project.paUcfFile -svalue "Z:/vhdlect1/pong/ucf/pong.ucf"
hdi::floorplan new -name floorplan_1 -part xc3s200vq100-5 -project pong
hdi::port import -project pong \
    -vhdl {../src/score_display/display_select.vhd work} \
    -vhdl {../src/score_display/counter.vhd work} \
    -vhdl {../src/score_display/7_segment.vhd work} \
    -vhdl {../src/controllerinterface/rotator.vhd work} \
    -vhdl {../src/controllerinterface/direction_detector.vhd work} \
    -vhdl {../src/controllerinterface/debouncer.vhd work} \
    -vhdl {../src/ball_motion_juergen/ConstantsHit.vhdl work} \
    -vhdl {../src/VGAController.vhd work} \
    -vhdl {../src/score_display/score_display.vhd work} \
    -vhdl {../src/controllerinterface/controller_interface.vhd work} \
    -vhdl {../src/CollisionDetection.vhd work} \
    -vhdl {../src/clock_enable.vhd work} \
    -vhdl {../src/ball_motion_juergen/BallMotion.vhdl work} \
    -vhdl {../src/pong_toplevel.vhd work}
hdi::port export -project pong -file pong_pa_ports.v -format verilog
hdi::pconst import -project pong -floorplan floorplan_1 -file "Z:/vhdlect1/pong/ucf/pong.ucf"
