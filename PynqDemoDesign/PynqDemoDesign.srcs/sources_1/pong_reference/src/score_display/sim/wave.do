onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /score_display_top_tb/score_display_top_inst/clk_i
add wave -noupdate -format Logic /score_display_top_tb/score_display_top_inst/clk
add wave -noupdate -format Logic /score_display_top_tb/score_display_top_inst/rst
add wave -noupdate -format Logic /score_display_top_tb/score_display_top_inst/nsw5_i
add wave -noupdate -format Logic /score_display_top_tb/score_display_top_inst/nsw6_i
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/hit_wall
add wave -noupdate -format Logic /score_display_top_tb/score_display_top_inst/led_enable
add wave -noupdate -format Logic /score_display_top_tb/score_display_top_inst/trigger1
add wave -noupdate -format Logic /score_display_top_tb/score_display_top_inst/trigger2
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/cnt
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/seven_seg_leds
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/seven_seg_sel
add wave -noupdate -divider <NULL>
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/score_display_inst/score_counter_inst/score_player1
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/score_display_inst/score_counter_inst/score_player2
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/score_display_inst/score_player1_bcd0
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/score_display_inst/score_player1_bcd1
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/score_display_inst/score_player2_bcd0
add wave -noupdate -format Literal /score_display_top_tb/score_display_top_inst/score_display_inst/score_player2_bcd1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3103130000 ps} 0}
configure wave -namecolwidth 548
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {2010 us} {6210 us}
