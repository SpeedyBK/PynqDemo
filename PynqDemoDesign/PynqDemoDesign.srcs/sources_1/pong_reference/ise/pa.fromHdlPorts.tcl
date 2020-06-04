
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

hdi::project new -name pong -dir "Z:/vhdlect1/pong/ise/planAhead_run_1"
hdi::project setArch -name pong -arch spartan3
hdi::design setOptions -project pong -top netlist_1_EMPTY
hdi::param set -name project.paUcfFile -svalue "Z:/vhdlect1/pong/ucf/pong.ucf"
hdi::floorplan new -name floorplan_1 -part xc3s200vq100-5 -project pong
hdi::port import -project pong -verilog {pong_pa_ports.v work}
hdi::pconst import -project pong -floorplan floorplan_1 -file "Z:/vhdlect1/pong/ucf/pong.ucf"
