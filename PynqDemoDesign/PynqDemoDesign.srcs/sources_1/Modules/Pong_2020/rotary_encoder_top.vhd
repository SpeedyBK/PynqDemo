library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.debounce_pkg.all;
use work.reset_gen_pkg.all;


entity rotary_encoder_top is
	generic(
		debounce_clks : integer := 100000 --2ms @ 50 MHz
	);
	port( 
		clk_i : in  std_logic;
		rot_enc_i : in  std_logic_vector(1 downto 0);
		rot_enc_push_button_i : in std_logic;
		led_o : out  std_logic_vector(7 downto 0);
		test_o : out  std_logic_vector(1 downto 0)
	);
end rotary_encoder_top;

architecture rotary_encoder_top_arch of rotary_encoder_top is

	signal rot_enc_deb : std_logic_vector(1 downto 0);
	signal clk,rst : std_logic;

	signal rot_enc_turning : std_logic;
	signal rot_enc_cw : std_logic;
	signal rot_enc_push_button : std_logic;
	
	signal cnt : integer;
	
	component rot_enc_decoder
		port(
			rst_i	:	in std_logic;
			clk_i	:	in std_logic;	
			encoder_i : in  std_logic_vector(1 downto 0);
			turning_o : out  std_logic;
			cw_o : out  std_logic
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
  
	deb_rot_enc0 : debounce
		generic map(
			debounce_clks => debounce_clks
		)
		port map(
				rst_i	=> rst,
				clk_i	=> clk,
				x_i	=> rot_enc_i(0),
				x_o 	=> rot_enc_deb(0)
		);

	deb_rot_enc1 : debounce
		generic map(
			debounce_clks => debounce_clks
		)
		port map(
				rst_i	=> rst,
				clk_i	=> clk,
				x_i	=> rot_enc_i(1),
				x_o 	=> rot_enc_deb(1)
		);
	
	rot_enc_decoder_inst : rot_enc_decoder
		port map(
			rst_i => rst,
			clk_i	=> clk,
			encoder_i => rot_enc_deb,
			turning_o => rot_enc_turning,
			cw_o => rot_enc_cw
		);	
	
	test_o(0) <= rot_enc_turning;
	test_o(1) <= rot_enc_cw;
	
	rot_enc_push_button <= not rot_enc_push_button_i;
	
	count_p: process (clk,rst)
	begin
		if rst='1' then	
		  cnt <= 15;
		elsif clk_i'event and clk_i = '1' then	
			if rot_enc_push_button = '1' then
				cnt <= 0;
			elsif rot_enc_turning = '1' then
				if rot_enc_cw = '1' then
					cnt <= cnt + 1;
				else
					cnt <= cnt - 1;
				end if;
			end if;
		end if;
	end process count_p;
	
	led_o <= not std_logic_vector(to_unsigned(cnt,8));
	
end rotary_encoder_top_arch;