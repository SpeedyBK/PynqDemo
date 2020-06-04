`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date:    Wed Sep 28 12:01:23 2011
// Design Name: 
// Module Name:    netlist_1_EMPTY
//////////////////////////////////////////////////////////////////////////////////
module netlist_1_EMPTY(rot_enc1_i, rot_enc2_i, dac_o, nseven_seg_leds_o, nseven_seg_sel_o, red_o, green_o, blue_o, clock, reset, push_button1_i, push_button2_i, h_sync_o, v_sync_o);
  input [1:0] rot_enc1_i;
  input [1:0] rot_enc2_i;
  output [7:0] dac_o;
  output [6:0] nseven_seg_leds_o;
  output [5:0] nseven_seg_sel_o;
  output [2:0] red_o;
  output [2:0] green_o;
  output [2:0] blue_o;
  input clock;
  input reset;
  input push_button1_i;
  input push_button2_i;
  output h_sync_o;
  output v_sync_o;


endmodule
