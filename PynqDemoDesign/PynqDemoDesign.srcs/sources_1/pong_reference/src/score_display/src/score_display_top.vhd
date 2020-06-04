library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.debounce_pkg.all;
use work.reset_gen_pkg.all;


entity score_display_top is
	generic(
		debounce_clks : integer := 100000; --2ms @ 50 MHz
		clk_frequency_in_hz : integer := 50E6;
		led_refresh_rate_in_hz : integer := 1000
	);
	port( 
		clk_i : in  std_logic;
		nseven_seg_leds_o : out std_logic_vector(6 downto 0);
		nseven_seg_sel_o : out std_logic_vector(5 downto 0);
		npush_button1_i : in std_logic;
		npush_button2_i : in std_logic;
		led_o : out std_logic_vector(7 downto 0);
		nSW5_i : in std_logic;
		nSW6_i : in std_logic
	);
end score_display_top;

architecture score_display_top_arch of score_display_top is

  signal clk,rst : std_logic;

  component score_display
  generic(
    score_max : integer range 0 to 99
  );
	port(
		rst_i	:	in std_logic;
		clk_i	:	in std_logic;	
		hit_wall_i : in std_logic_vector(2 downto 0);
		led_enable_i : in std_logic;
		push_but1_i : in std_logic;
		push_but2_i : in std_logic;
		seven_seg_leds_o : out std_logic_vector(6 downto 0);
		seven_seg_sel_o : out std_logic_vector(5 downto 0);
		game_over_o : out std_logic
	);
  end component;

  signal hit_wall : std_logic_vector(2 downto 0);
  signal led_enable : std_logic;
  signal game_over : std_logic;

  constant cnt_max : integer := clk_frequency_in_hz/led_refresh_rate_in_hz-1;
  signal cnt : integer range 0 to cnt_max;

  signal trigger1,trigger2,ntrigger1,ntrigger2,trigger1_last,trigger2_last : std_logic;

  signal seven_seg_leds : std_logic_vector(6 downto 0);
  signal seven_seg_sel : std_logic_vector(5 downto 0);

  signal push_but1,push_but2 : std_logic;
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
  
  push_but1 <= not npush_button1_i;
  push_but2 <= not npush_button2_i;
  
  score_display_inst : score_display
  generic map(
    score_max => 15
  )
  port map(
		rst_i	=> rst,
		clk_i	=> clk,
		hit_wall_i => hit_wall,
		led_enable_i => led_enable,
		push_but1_i => push_but1,
		push_but2_i => push_but2,
		seven_seg_leds_o => seven_seg_leds,
		seven_seg_sel_o => seven_seg_sel,
		game_over_o => game_over
	);
	
	nseven_seg_leds_o <= not seven_seg_leds;
	nseven_seg_sel_o <= not seven_seg_sel;
	
	led_o(0) <= not game_over;
	led_o(1) <= not led_enable;
	led_o(4 downto 2) <= not hit_wall;
	led_o(5) <= not trigger1;
	led_o(6) <= not trigger2;
	led_o(7) <= not '0';

	deb_trigger1 : debounce
		generic map(
			debounce_clks => debounce_clks
		)
		port map(
				rst_i	=> rst,
				clk_i	=> clk,
				x_i	=> nSW5_i,
				x_o => ntrigger1
		);

	deb_trigger2 : debounce
		generic map(
			debounce_clks => debounce_clks
		)
		port map(
				rst_i	=> rst,
				clk_i	=> clk,
				x_i	=> nSW6_i,
				x_o => ntrigger2
		);

	enable_p : process(rst,clk)
	begin
	  if rst='1' then	
	    cnt <= 0;
       led_enable <= '0';
	  elsif clk'event and clk = '1' then	
       if cnt = cnt_max then
         led_enable <= '1';
         cnt <= 0;
	    else
         led_enable <= '0';
         cnt <= cnt + 1;
	    end if;
	  end if;
	end process;
	
	trigger1 <= not ntrigger1;
	trigger2 <= not ntrigger2;

	hit_wall_p : process(rst,clk)
	begin
	  if rst='1' then	
		 hit_wall <= "000";
	  elsif clk'event and clk = '1' then
		 --detect the positive edge:
		 if (trigger1_last = '0') and (trigger1 = '1') then 
			hit_wall <= "110"; --rechtes Aus, Punkt für Spieler 2 (rechts)
		 elsif (trigger2_last = '0') and (trigger2 = '1') then
			hit_wall <= "101"; --rechtes Aus, Punkt für Spieler 1 (links)
		 else
			hit_wall <= "000";
		 end if;
		 trigger1_last <= trigger1;
		 trigger2_last <= trigger2;
	  end if;
	end process;


	
end score_display_top_arch;