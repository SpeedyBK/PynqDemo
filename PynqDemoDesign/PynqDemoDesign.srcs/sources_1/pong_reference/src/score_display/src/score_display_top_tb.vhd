library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity score_display_top_tb is
end score_display_top_tb;

architecture score_display_top_tb_arch of score_display_top_tb is

component score_display_top
	generic(
		debounce_clks : integer;
		clk_frequency_in_hz : integer;
		led_refresh_rate_in_hz : integer
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
end component;

  signal clk : std_logic := '0';
  signal ntrigger1,ntrigger2 : std_logic := '1';
  
begin

  clk <= not clk after 10 ns;
--  ntrigger1 <= '1', not ntrigger1 after 1000 us, not ntrigger1 after 1001 us;
--  ntrigger2 <= '1', '0' after 2000 us, '1' after 2001 us, '0' after 4000 us, '1' after 4001 us;

  process
  begin
  loop
    ntrigger1 <= '1';
    wait for 100 us;
    ntrigger1 <= '0';
    wait for 100 ns;
    ntrigger1 <= '1';
    wait for 100 us;
    ntrigger2 <= '0';
    wait for 100 ns;
    ntrigger2 <= '1';
  end loop;
  end process;
    
score_display_top_inst : score_display_top
	generic map(
		clk_frequency_in_hz => 50E6,
		debounce_clks => 2, --100000, --2ms @ 50 MHz
		led_refresh_rate_in_hz => 10E6
	)
	port map( 
		clk_i => clk,
		nseven_seg_leds_o => open,
		nseven_seg_sel_o  => open,
		npush_button1_i  => '1',
		npush_button2_i => '1',
		led_o  => open,
		nSW5_i  => ntrigger1,
		nSW6_i  => ntrigger2
	);

end score_display_top_tb_arch;