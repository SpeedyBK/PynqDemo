--------------------------------------------------------------------------------
-- Title          : Pong Toplevel
-- Filename       : toplevel_pong.vhd
-- Project        : 6. �bungsblatt VHDL-Kurs (Pong-Spiel)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universit�t Kassel, FG Digitaltechnik
-- Date           : 21.06.2010
-- Language       : VHDL93
-- Synthesis      : No
-- Target Family  : ALL
-- Test Status    : !!! not released !!!
--------------------------------------------------------------------------------
-- Applicable Documents:
-- 
--
--------------------------------------------------------------------------------
-- Revision History:
-- Date        Version  Author   Description
-- 21.06.2010  1.0      MK       Created
-- 27.08.2013  1.1		MK		 MMCodec01 & Eliminating Component Declaration
-- 20.05.2019  1.2      MH       Convert to PYNQ-Board useage
--------------------------------------------------------------------------------
-- Description:
--
-- Dieses Modul stellt die Toplevel-Dom�ne f�r das Pong-Spiel dar, welches
-- von den Studierenden des VHDL-Kurses entwickelt werden soll. 
--
-- Es verbindet das Visualisierungsmodul mit dem Modul zur Ballbewegung und
-- Kollisionserkennung. Die fehlenden Eingaben der Module zur Schl�gerbewegung
-- werden hier exemplarisch (testweise) gesetzt.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.all;
 
ENTITY pong_top IS
	generic(
		game_enable_clocks: integer := 2100000); -- Propox version 840000
	port( 
		clock 									: in  std_logic;
		reset 									: in  std_logic;
		
		-- Play Modus Selector
		slide_sw_i							: in std_logic_vector(1 downto 0);
				
		pmod_c  : in std_logic_vector(7 downto 0);
		blue_led : out std_logic_vector(7 downto 0);
		-- Controller Interface
		--rot_enc1_i 							: in  std_logic_vector(1 downto 0);
		--push_button1_i 					    : in  std_logic;
		
		--rot_enc2_i 							: in  std_logic_vector(1 downto 0);
		--push_button2_i 					    : in  std_logic;
		  
		-- Sound Interface
		
		aud_pwm : out std_logic;
		aud_sd  : out std_logic;
		
		--lrcout_o 								: out std_logic;
		--bclk_o 									: out std_logic;
		--sclk_o 									: out std_logic;
		--din_i 									: in 	std_logic;
		--dout_o 									: out std_logic;
		--sdout_o 								: out std_logic;
		--ncs_o 									: out std_logic;
		--mck_o 									: out std_logic;
		--mode_o 									: out std_logic;

		-- Seven Segment Display
		ssd_data 			    : out std_logic_vector(7 downto 0);
		ssd_enable 				: out std_logic_vector(7 downto 0);

		-- VGA Controller
		VGA_HS, VGA_VS 			: out  std_logic;
		VGA_R, VGA_G, VGA_B	    : out  std_logic_vector (3 downto 0);

		-- leds
		--;nled_o         		 	: out  std_logic_vector (7 downto 0)
		led : out std_logic_vector(3 downto 0)
		);

END pong_top;
 
ARCHITECTURE behavior OF pong_top IS 
   
	signal racket_y_pos1, racket_y_pos1_player : std_logic_vector(9 downto 0);
	signal racket_y_pos2, racket_y_pos2_player : std_logic_vector(9 downto 0);
	signal ball_x : std_logic_vector(9 downto 0);
	signal ball_y : std_logic_vector(9 downto 0);
	signal hit_wall : std_logic_vector(2 downto 0);
	signal hit_racket_l : std_logic_vector(1 downto 0);
	signal hit_racket_r : std_logic_vector(1 downto 0);
	signal game_over	: std_logic;
	signal push_but_deb1, push_but_deb2 : std_logic;
	signal Npush_but_deb1, Npush_but_deb2 : std_logic;
	signal seven_seg_leds : std_logic_vector(6 downto 0);
	signal seven_seg_sel : std_logic_vector(5 downto 0);

	signal nreset : std_logic;
	signal game_enable : std_logic;
	signal vga_enable : std_logic;
	signal note_enable : std_logic;
	signal dds_enable : std_logic;
	signal led_enable : std_logic;
	signal nslide_sw : std_logic_vector(1 downto 0);

	signal leds : std_logic_vector (7 downto 0);
	
	signal nseven_seg_leds_o : std_logic_vector(6 downto 0);
	signal nseven_seg_sel_o  : std_logic_vector(5 downto 0);
	
	signal h_sync_o : std_logic;
	signal v_sync_o : std_logic;
    signal red_o : std_logic_vector   (2 downto 0);
    signal green_o : std_logic_vector (2 downto 0);
    signal blue_o : std_logic_vector  (2 downto 0);
    
    signal lrcout_o :  std_logic;
    signal bclk_o   :  std_logic;
    signal sclk_o   :  std_logic;
    signal din_i    :  std_logic;
    signal dout_o   :  std_logic;
    signal sdout_o  :  std_logic;
    signal ncs_o    :  std_logic;
    signal mck_o    :  std_logic;
    signal mode_o   :  std_logic;
    
    signal rot_enc1_i     : std_logic_vector(1 downto 0);
    signal push_button1_i : std_logic;
    
    signal rot_enc2_i     : std_logic_vector(1 downto 0);
    signal push_button2_i : std_logic;
    
    signal audio_debug     : std_logic_vector(19 downto 0);
        

BEGIN

ssd_data(7 downto 1)   <= nseven_seg_leds_o;
ssd_data(0)            <= '1';
ssd_enable(6 downto 1) <= nseven_seg_sel_o;
ssd_enable(7)          <= '1';
ssd_enable(0)          <= '1';

VGA_HS <= h_sync_o;
VGA_VS <= v_sync_o;

--blue_led <= not pmod_c;
blue_led <= not audio_debug(7 downto 0);


rot_enc1_i <= pmod_c(7 downto 6);
push_button1_i <= not pmod_c(5);

rot_enc2_i <= pmod_c(3 downto 2);
push_button2_i <= not pmod_c(1);



led(0) <= push_button1_i;
led(1) <= push_button2_i;
led(2) <= '0'; 
led(3) <= '0';




	clk_enable: entity work.clock_enable 
		generic map(
			game_enable_clocks => game_enable_clocks)
		port map (
			clock 				=> clock,
			reset 				=> reset,
			vga_enable_o 	=> vga_enable,
			game_enable_o	=> game_enable,
			led_enable_o	=> led_enable,
			note_enable_o	=> note_enable,
			dds_enable_o	=> dds_enable
			);
	
	controller_interface1 : entity work.controller_interface
		generic map(
			clk_frequency_in_Hz => 125E6, -- Propox version 50E6
			debounce_time_in_us => 2000,
			racket_height 			 => 60,
			racket_steps 			 => 10,
			screen_height			 => 480)
		port map(
			clock_i				 => clock,	
			reset_i				 => reset,
			rot_enc_i			 => rot_enc1_i,
			push_but_i		     => push_button1_i,
			push_but_deb_o => push_but_deb1,
			racket_y_pos_o => racket_y_pos1_player
			);
	
	controller_interface2 : entity work.controller_interface
		generic map(
			clk_frequency_in_Hz => 125E6,
			debounce_time_in_us => 2000,
			racket_height 			 => 60,
			racket_steps				 => 10,
			screen_height			 => 480)
		port map(
			clock_i				 => clock,	
			reset_i				 => reset,
			rot_enc_i 		 => rot_enc2_i,
			push_but_i 		 => push_button2_i,
			push_but_deb_o => push_but_deb2,
			racket_y_pos_o => racket_y_pos2_player
			);

--racket_y_pos2_player <= ball_y;
--push_but_deb1 <= '0';
--racket_y_pos1 <= (others => '0');
--push_but_deb2 <= '0';
--racket_y_pos2 <= (others => '0');


	collision: entity work.collision_detection
		generic map(
			ball_length					=> 6,
			racket_length				=> 10,
			racket_height				=> 60,
			racket_left_space		=> 20,
			racket_right_space 	=> 610,
			screen_height 			=> 480)
		port map(
			clock_i 				=> clock,
			reset_i 				=> reset,
			racket_y_pos1_i => racket_y_pos1,
			racket_y_pos2_i => racket_y_pos2,
			ball_x_i 		 	 	=> ball_x,
			ball_y_i 			 	=> ball_y,
			hit_wall_o 		 	=> hit_wall,
			hit_racket_l_o 	=> hit_racket_l,
			hit_racket_r_o 	=> hit_racket_r
			);


	motion: entity work.ball_motion
		generic map(
			ball_length					=> 6,
			racket_length				=> 10,
			racket_height				=> 60,
			racket_left_space		=> 20,
			racket_right_space 	=> 610,
			screen_height 			=> 480,
			speedup_racket			=> 2)
		port map(
			clock_i 				=> clock,
			reset_i 				=> reset,
			game_enable_i		=> game_enable,
			push_but1_deb_i	=>	Npush_but_deb1,
			push_but2_deb_i =>	Npush_but_deb2,
			game_over_i			=>	game_over,
			hit_wall_i 		 	=> hit_wall,
			hit_racket_l_i 	=> hit_racket_l,
			hit_racket_r_i 	=> hit_racket_r,
			ball_x_o 			 	=> ball_x,
			ball_y_o 			 	=> ball_y
			);
	
		--ball_x <= "0000100000";
		--ball_y <= "0000100000";
 
	visualization: entity work.vga_controller
		generic map(
			ball_length				=>  6,
			racket_length			=>  10,
			racket_height			=>  60,
			racket_left_space	    =>  20,
			racket_right_space      =>  610,
			H_max					=>  799,
			V_max					=>  524)
		port map(
			clock_i 				=> clock,
			reset_i 				=> reset,
			vga_enable_i 		    => vga_enable,
			racket_y_pos1_i         => racket_y_pos1,
			racket_y_pos2_i         => racket_y_pos2,
			ball_x_i 				=> ball_x,
			ball_y_i 				=> ball_y,
			h_sync_o 				=> h_sync_o,
			v_sync_o 				=> v_sync_o,
			red_o 					=> VGA_R,
			green_o 				=> VGA_G,
			blue_o 					=> VGA_B
			);
		  
	--sound: entity work.sound_interface 
--		port map(
--			clock_i 		 => clock,
--			reset_i 		 => reset,
--			note_enable_i	 => note_enable,
--			dds_enable_i	 => dds_enable,
--			hit_wall_i 		 => hit_wall,
--			hit_racket_l_i   => hit_racket_l,
--			hit_racket_r_i   => hit_racket_r,
--			game_over_i		 => game_over,
			
--			debug_output     => audio_debug,
			
--			PWM_o            => aud_pwm,
--            aud_en_o         => aud_sd
			
--			lrcout_o 			 => lrcout_o,
--			bclk_o 				 => bclk_o,
--			sclk_o				 => sclk_o,
--			din_i					 => din_i,
--			dout_o				 =>  dout_o,
--			sdout_o				 => sdout_o,
--			ncs_o					 => ncs_o,
--			mck_o					 => mck_o,
--			mode_o				 => mode_o
--			);

	score_display_inst : entity work.score_display
		generic map(
			score_max => 15)
		port map(
			clock_i					 => clock,
			reset_i					 => reset,
			hit_wall_i 			 => hit_wall,
			led_enable_i 		 => led_enable,
			push_but1_deb_i  => Npush_but_deb1,
			push_but2_deb_i  => Npush_but_deb2,
			seven_seg_leds_o => seven_seg_leds,
			seven_seg_sel_o  => seven_seg_sel,
			game_over_o 		 => game_over
			);
	
	--game_over <= '0';
	
	--nled_o(7) <= not game_over;
	--nled_o(6 downto 0) <=  not leds(6 downto 0);
	
	nseven_seg_leds_o <= not seven_seg_leds;
	nseven_seg_sel_o <= not seven_seg_sel;
	nslide_sw <= not slide_sw_i;


--	bar_y_pos1 <= CONV_STD_LOGIC_VECTOR(20,10);
--   bar_y_pos2 <= CONV_STD_LOGIC_VECTOR(300,10);

with nslide_sw(1) select
	racket_y_pos1 <= 	ball_y-14 when '1',	
	                    racket_y_pos1_player when others;

with nslide_sw(0) select
	racket_y_pos2 <= 	ball_y-14 when '1', 
	                    racket_y_pos2_player when others;
							
						  
	
	
	--racket_y_pos1 <= ball_y-14;
   --racket_y_pos2 <= ball_y-14;
--	game_over <= '0';
--	push_but_deb1 <= not nSw(0);
--	push_but_deb2 <= not nSw(1);

	
	nreset <= reset; -- Propox version : nreset <= not reset;
	Npush_but_deb1 <= not push_but_deb1;
	Npush_but_deb2 <= not push_but_deb2;
--	Npush_but_deb1 <= push_but_deb1;
--	Npush_but_deb2 <= push_but_deb2;

--   ball_x 	 <= CONV_STD_LOGIC_VECTOR(640,10);
--   ball_y 	 <= CONV_STD_LOGIC_VECTOR(480,10);

END;
