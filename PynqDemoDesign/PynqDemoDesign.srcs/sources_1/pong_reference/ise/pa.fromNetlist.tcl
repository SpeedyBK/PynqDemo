
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

hdi::project new -name pong -dir "Z:/vhdlect1/pong/ise/planAhead_run_2" -netlist "Z:/vhdlect1/pong/ise/pong_top.ngc" -search_path { {Z:/vhdlect1/pong/ise} }
hdi::project setArch -name pong -arch spartan3
hdi::param set -name project.paUcfFile -svalue "Z:/vhdlect1/pong/ucf/pong.ucf"
hdi::floorplan new -name floorplan_1 -part xc3s200vq100-5 -project pong
hdi::pconst import -project pong -floorplan floorplan_1 -file "Z:/vhdlect1/pong/ucf/pong.ucf"
