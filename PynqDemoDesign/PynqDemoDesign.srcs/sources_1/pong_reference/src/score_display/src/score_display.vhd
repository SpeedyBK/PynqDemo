library ieee;
use ieee.std_logic_1164.all;

entity score_display is
  generic(
    score_max : integer range 0 to 99 := 15
  );
	port(
		reset_i	:	in std_logic;
		clock_i	:	in std_logic;	
		hit_wall_i : in std_logic_vector(2 downto 0);
		led_enable_i : in std_logic;
		push_but1_deb_i : in std_logic;
		push_but2_deb_i : in std_logic;
		seven_seg_leds_o : out std_logic_vector(6 downto 0);
		seven_seg_sel_o : out std_logic_vector(5 downto 0);
		game_over_o : out std_logic
	);
end score_display;

architecture score_display_arch of score_display is

  component score_counter
    generic(
      score_max : integer range 0 to 99
    );
  	port(
  		rst_i	:	in std_logic;
  		clk_i	:	in std_logic;	
  		hit_wall_i : in std_logic_vector(2 downto 0);
  		score_reset_i : in std_logic;
  		score_player1_o : out std_logic_vector(6 downto 0);
  		score_player2_o : out std_logic_vector(6 downto 0);
  		game_over_o : out std_logic
  	);
  end component;
  
  component bin_to_bcd_dec 
    generic(
      score_max : integer range 0 to 99
    );
  	port(
  		rst_i	:	in std_logic;
  		clk_i	:	in std_logic;	
  		start_decoding_i : in std_logic;
  		binary_i : in std_logic_vector(6 downto 0);
  		bcd0_o : out std_logic_vector(3 downto 0);
  		bcd1_o : out std_logic_vector(3 downto 0)
  	);
  end component;

  component seven_seg_dec 
    port(
      bcd_i       : in  std_logic_vector (3 downto 0);
      seven_seg_o : out std_logic_vector (6 downto 0)
    );
  end component;

  signal score_reset : std_logic;
  signal score_player1 : std_logic_vector(6 downto 0);
  signal score_player2 : std_logic_vector(6 downto 0);

  signal score_player1_bcd0 : std_logic_vector(3 downto 0);
  signal score_player1_bcd1 : std_logic_vector(3 downto 0);
  signal score_player2_bcd0 : std_logic_vector(3 downto 0);
  signal score_player2_bcd1 : std_logic_vector(3 downto 0);

  signal mux_bcd : std_logic_vector(3 downto 0);
  signal mux_cnt : integer range 0 to 3;
  
begin

  score_reset <= push_but1_deb_i or push_but2_deb_i;

  score_counter_inst : score_counter
  generic map(
    score_max => score_max
  )
	port map(
		rst_i	=> reset_i,
		clk_i	=> clock_i,
		hit_wall_i => hit_wall_i,
		score_reset_i => score_reset,
		score_player1_o => score_player1,
		score_player2_o => score_player2,
		game_over_o => game_over_o
	);

  player1_bin_to_bcd_dec : bin_to_bcd_dec 
  generic map(
    score_max => score_max
  )
	port map(
  	rst_i	=> reset_i,
  	clk_i	=> clock_i,
  	start_decoding_i => led_enable_i,
		binary_i => score_player1,
		bcd0_o => score_player1_bcd0,
		bcd1_o => score_player1_bcd1
	);

  player2_bin_to_bcd_dec : bin_to_bcd_dec 
  generic map(
    score_max => score_max
  )
	port map(
  	rst_i	=> reset_i,
  	clk_i	=> clock_i,
  	start_decoding_i => led_enable_i,
		binary_i => score_player2,
		bcd0_o => score_player2_bcd0,
		bcd1_o => score_player2_bcd1
	);


	mus_p: process (clock_i,reset_i)
	begin
		if reset_i='1' then	
		  mux_cnt <= 0;
		  seven_seg_sel_o <= (others => '0');
		elsif clock_i'event and clock_i = '1' then	
			if led_enable_i  = '1' then
        case mux_cnt is
          when 0 =>
            mux_bcd <= score_player1_bcd0;
            seven_seg_sel_o <= "000001";
          when 1 =>
            mux_bcd <= score_player1_bcd1;
            seven_seg_sel_o <= "000010";
          when 2 =>
            mux_bcd <= score_player2_bcd0;
            seven_seg_sel_o <= "010000";
          when 3 =>
            mux_bcd <= score_player2_bcd1;
            seven_seg_sel_o <= "100000";
        end case;
        if mux_cnt = 3 then
          mux_cnt <= 0;
        else
          mux_cnt <= mux_cnt + 1;
        end if;
			end if;
		end if;
	end process;

  seven_seg_dec_inst : seven_seg_dec
  port map(
    bcd_i       => mux_bcd,
    seven_seg_o => seven_seg_leds_o
  );

end score_display_arch;