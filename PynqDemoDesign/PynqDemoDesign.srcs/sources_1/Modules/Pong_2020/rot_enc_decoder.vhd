library ieee;
use ieee.std_logic_1164.all;

entity rot_enc_decoder is
	port(
		rst_i	:	in std_logic;
		clk_i	:	in std_logic;	
		encoder_i : in  std_logic_vector(1 downto 0);
		turning_o : out  std_logic;
		cw_o : out  std_logic
	);
end rot_enc_decoder;

architecture rot_enc_decoder_arch of rot_enc_decoder is

	type state_t is(idle, turning1, turning2, turning3);
	signal state : state_t;
	
begin

	decode_fsm : process(rst_i,clk_i)
	begin
		if rst_i='1' then	
		  turning_o <= '0';
		  cw_o <= '0';
		  state <= idle;
		elsif clk_i'event and clk_i = '1' then	
			turning_o <= '0';
			cw_o <= '0';
			case state is
				when idle =>
					case encoder_i is
						when "01" =>
							state <= turning1; --turning clockwise
						when "10" =>
							state <= turning3; --turning counter clockwise
						when others =>
							state <= idle; --stay idle or wrong input
					end case;
				when turning1 =>
					case encoder_i is
						when "00" =>
							state <= turning2; --turning clockwise
						when "01" =>
							state <= turning1; --stay in turning1
						when others =>
							state <= idle; --turning counter clockwise or wrong input
					end case;
				when turning2 =>
					case encoder_i is
						when "10" =>
							state <= turning3; --turning clockwise
							turning_o <= '1';
							cw_o <= '1';
						when "01" =>
							state <= turning1; --turning counter clockwise
							turning_o <= '1';
							cw_o <= '0';
						when "00" =>
							state <= turning2; --stay in turning2
						when others =>
							state <= idle; --wrong input
					end case;
				when turning3 =>
					case encoder_i is
						when "11" =>
							state <= idle; --turning clockwise
						when "00" =>
							state <= turning2; --turning counter clockwise
						when "10" =>
							state <= turning3; --stay in turning3
						when others =>
							state <= idle; --wrong input
					end case;
			end case;
		end if;
	end process decode_fsm;
	
end rot_enc_decoder_arch;

