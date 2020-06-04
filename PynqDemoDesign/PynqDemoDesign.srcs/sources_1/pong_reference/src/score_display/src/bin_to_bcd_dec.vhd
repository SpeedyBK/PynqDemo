library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_to_bcd_dec is
  generic(
    score_max : integer range 0 to 99 := 15
  );
	port(
		rst_i	:	in std_logic;
		clk_i	:	in std_logic;	
		start_decoding_i : in std_logic;
		binary_i : in std_logic_vector(6 downto 0);
		bcd0_o : out std_logic_vector(3 downto 0);
		bcd1_o : out std_logic_vector(3 downto 0)
	);
end bin_to_bcd_dec;

architecture bin_to_bcd_dec_arch of bin_to_bcd_dec is

  signal bcd1 : integer range 0 to 9;

  signal binary : integer range 0 to score_max;

	type state_t is(wait_for_data, computing);
	signal state : state_t;
	
begin

	bin_to_bcd_dec_p: process (clk_i,rst_i)
	begin
		if rst_i='1' then
		  bcd0_o <= (others => '0');	
		  bcd1_o <= (others => '0');
		  binary <= 0;
		  bcd1 <= 0;
		elsif clk_i'event and clk_i = '1' then	
			case state is
				when wait_for_data =>
				  if start_decoding_i = '1' then
            binary <= to_integer(unsigned(binary_i));
         		 bcd1 <= 0;
            state <= computing;
          end if;
				when computing =>
    			if binary >= 10 then
  				  binary <= binary - 10;
  				  bcd1 <= bcd1 + 1;
  				else
          	bcd0_o <= std_logic_vector(to_unsigned(binary,4));
          	bcd1_o <= std_logic_vector(to_unsigned(bcd1,4));
           state <= wait_for_data;
    			end if;
			end case;
		end if;
	end process bin_to_bcd_dec_p;


end bin_to_bcd_dec_arch;