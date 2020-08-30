library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.debounce_pkg.all;
use work.reset_gen_pkg.all;


entity controller_interface_top is
	generic(
		debounce_clks : integer := 100000 --2ms @ 50 MHz
	);
	port( 
		clk_i : in  std_logic;
		rot_enc1_i : in  std_logic_vector(1 downto 0);
		push_button1_i : in std_logic;
		rot_enc2_i : in  std_logic_vector(1 downto 0);
		push_button2_i : in std_logic;
		led_o : out  std_logic_vector(7 downto 0);
		test_o : out  std_logic_vector(1 downto 0)
	);
end controller_interface_top;

architecture controller_interface_top_arch of controller_interface_top is

  signal racket_y_pos1 : std_logic_vector(9 downto 0);
  signal racket_y_pos2 : std_logic_vector(9 downto 0);
  signal clk,rst : std_logic;

	
  component controller_interface
  generic(
    clk_frequency_in_Hz : integer;
    racket_steps : integer;
    debounce_time_in_us : integer;
    racket_height : integer;
    screen_height : integer
  );
	port(
		rst_i	:	in std_logic;
		clk_i	:	in std_logic;	
		rot_enc_i : in  std_logic_vector(1 downto 0);
		push_but_i : in std_logic;
		push_but_deb_o : out  std_logic;
		racket_y_pos_o : out  std_logic_vector(9 downto 0)
	);
	end component;

begin

	clk <= clk_i;
	
	rst_gen_inst: reset_gen
	generic map(
		reset_clks => 10
	)
	port map(
		clk_i => clk,
		rst_o => rst
	);
  
  controller_interface1 : controller_interface
  generic map(
    clk_frequency_in_Hz => 50E6,
    racket_steps => 10,
    debounce_time_in_us => 2000,
    racket_height => 30,
    screen_height => 480
  )
	port map(
		rst_i	=> rst,
		clk_i	=> clk,	
		rot_enc_i => rot_enc1_i,
		push_but_i => push_button1_i,
		push_but_deb_o => test_o(0),
		racket_y_pos_o => racket_y_pos1
	);
	
  controller_interface2 : controller_interface
  generic map(
    clk_frequency_in_Hz => 50E6,
    racket_steps => 10,
    debounce_time_in_us => 2000,
    racket_height => 30,
    screen_height => 480
  )
	port map(
		rst_i	=> rst,
		clk_i	=> clk,	
		rot_enc_i => rot_enc2_i,
		push_but_i => push_button2_i,
		push_but_deb_o => test_o(1),
		racket_y_pos_o => racket_y_pos2
	);
	
	led_o <= not racket_y_pos1(7 downto 0);
	
end controller_interface_top_arch;