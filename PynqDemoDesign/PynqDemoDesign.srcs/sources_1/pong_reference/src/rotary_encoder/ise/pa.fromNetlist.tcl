
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

hdi::project new -name rotary_encoder -dir "Z:/Lehrveranstaltungen/VHDL-Kurs/ss_10/Uebungen/06_project/rotary_encoder/ise/planAhead_run_1" -netlist "Z:/Lehrveranstaltungen/VHDL-Kurs/ss_10/Uebungen/06_project/rotary_encoder/ise/controller_interface_top.ngc" -search_path { {Z:/Lehrveranstaltungen/VHDL-Kurs/ss_10/Uebungen/06_project/rotary_encoder/ise} }
hdi::project setArch -name rotary_encoder -arch spartan3
hdi::param set -name project.pinAheadLayout -bvalue yes
hdi::param set -name project.paUcfFile -svalue "controller_interface_top.ucf"
hdi::floorplan new -name floorplan_1 -part xc3s200vq100-5 -project rotary_encoder
hdi::pconst import -project rotary_encoder -floorplan floorplan_1 -file "controller_interface_top.ucf"
