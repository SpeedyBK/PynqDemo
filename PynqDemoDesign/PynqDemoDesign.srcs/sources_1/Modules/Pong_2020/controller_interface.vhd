library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.debounce_pkg.all;

entity controller_interface is
  generic(
    clk_frequency_in_Hz : integer := 125E6;
    racket_steps : integer := 1;
    debounce_time_in_us : integer := 2000;
    racket_height : integer := 30;
    screen_height : integer := 480
  );
	port(
		reset_i	:	in std_logic;
		clock_i	:	in std_logic;	
		rot_enc_i : in  std_logic_vector(1 downto 0);
		push_but_i : in std_logic;
		push_but_deb_o : out  std_logic;
		racket_y_pos_o : out  std_logic_vector(9 downto 0)
	);
end controller_interface;

architecture controller_interface_arch of controller_interface is

	component rot_enc_decoder
		port(
			rst_i	:	in std_logic;
			clk_i	:	in std_logic;	
			encoder_i : in  std_logic_vector(1 downto 0);
			turning_o : out  std_logic;
			cw_o : out  std_logic
		);
	end component;

	constant debounce_clks : integer := (clk_frequency_in_Hz/1E6) * debounce_time_in_us;
	constant cnt_max : integer := screen_height-racket_height-1;

	signal rot_enc_deb : std_logic_vector(1 downto 0);
	signal rot_enc_turning : std_logic;
	signal rot_enc_cw : std_logic;
	
	signal cnt : integer range 0 to cnt_max;
		
begin

	deb_rot_enc0 : debounce
		generic map(
			debounce_clks => debounce_clks
		)
		port map(
				rst_i	=> reset_i,
				clk_i	=> clock_i,
				x_i	=> rot_enc_i(0),
				x_o => rot_enc_deb(0)
		);

	deb_rot_enc1 : debounce
		generic map(
			debounce_clks => debounce_clks
		)
		port map(
				rst_i	=> reset_i,
				clk_i	=> clock_i,
				x_i	=> rot_enc_i(1),
				x_o => rot_enc_deb(1)
		);

	deb_push_but : debounce
		generic map(
			debounce_clks => debounce_clks
		)
		port map(
				rst_i	=> reset_i,
				clk_i	=> clock_i,
				x_i	=> push_but_i,
				x_o => push_but_deb_o
		);
	
	rot_enc_decoder_inst : rot_enc_decoder
		port map(
			rst_i => reset_i,
			clk_i	=> clock_i,
			encoder_i => rot_enc_deb,
			turning_o => rot_enc_turning,
			cw_o => rot_enc_cw
		);	

	count_p: process (clock_i,reset_i)
	begin
		if reset_i='1' then	
		  cnt <= (screen_height-racket_height)/2; --set racket to the center of the screen
		elsif clock_i'event and clock_i = '1' then	
			if rot_enc_turning = '1' then
				if rot_enc_cw = '1' then
				  if cnt < cnt_max-racket_steps then
				    cnt <= cnt + racket_steps;
				  else
				    cnt <= cnt_max;
				  end if;  
				else
				  if cnt > racket_steps then
            cnt <= cnt - racket_steps;
          else
            cnt <= 0;
          end if;
				end if;
			end if;
		end if;
	end process count_p;
	
	racket_y_pos_o <= std_logic_vector(to_unsigned(cnt,10));

end controller_interface_arch;