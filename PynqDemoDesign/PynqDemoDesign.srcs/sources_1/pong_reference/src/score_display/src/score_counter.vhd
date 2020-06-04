library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity score_counter is
  generic(
    score_max : integer range 0 to 99 := 15
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
end score_counter;

architecture score_counter_arch of score_counter is

  signal score_player1 : integer range 0 to score_max;
  signal score_player2 : integer range 0 to score_max;

  signal game_over : std_logic;
  
begin

	led_output_p: process (clk_i,rst_i)
	begin
		if rst_i='1' then	
		  score_player1 <= 0;
		  score_player2 <= 0;
        game_over <= '0';
		  game_over_o <= '0';
		elsif clk_i'event and clk_i = '1' then
			game_over_o <= '0';
			if game_over = '0' then
			  case hit_wall_i is 
			  when "101" =>
				 if score_player1 = score_max-1 then
					game_over <= '1';
					game_over_o <= '1';
				 end if;
				score_player1 <= score_player1 + 1;
			  when "110" =>
				 if score_player2 = score_max-1 then
					game_over <= '1';
					game_over_o <= '1';
				 end if;
				score_player2 <= score_player2 + 1;
			  when others =>			  end case;
		  else
		    if score_reset_i = '1' then
  		      score_player1 <= 0;
  		      score_player2 <= 0;
            game_over <= '0';
		    end if;
		  end if;  
		end if;
	end process led_output_p;
	
	score_player1_o <= std_logic_vector(to_unsigned(score_player1,7));
	score_player2_o <= std_logic_vector(to_unsigned(score_player2,7));
   
	
end score_counter_arch;