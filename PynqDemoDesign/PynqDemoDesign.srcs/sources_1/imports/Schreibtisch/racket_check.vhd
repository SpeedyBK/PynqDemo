----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2016 16:47:42
-- Design Name: 
-- Module Name: racket_check - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity racket_check is
    generic (ball_length : integer := 6;
            racket_length : integer := 10;
            racket_height : integer := 30;
            racket_left_space : integer := 20;
            racket_right_space : integer := 610;
            screen_height : integer := 480);    
   Port ( clock_i : in STD_LOGIC;
          reset_i : in STD_LOGIC;
          racket_y_pos1_i : in STD_LOGIC_VECTOR (9 downto 0);
          racket_y_pos2_i : in STD_LOGIC_VECTOR (9 downto 0);
          ball_x_i : in STD_LOGIC_VECTOR (9 downto 0);
          ball_y_i : in STD_LOGIC_VECTOR (9 downto 0);
          hit_racket_l_o : out STD_LOGIC_VECTOR (1 downto 0);
          hit_racket_r_o : out STD_LOGIC_VECTOR (1 downto 0));
end racket_check;

architecture Behavioral of racket_check is

type Zustand is (no_collision, collision);	
	signal next_state		: Zustand;
	signal current_state	: Zustand;
	
	signal ball_x_int       : integer range 0 to 700;
	signal ball_y_int       : integer range 0 to 700;
	signal racket_y_pos1_int: integer range 0 to 700;
	signal racket_y_pos2_int: integer range 0 to 700;

begin

ball_x_int <= to_integer(unsigned(ball_x_i));
ball_y_int <= to_integer(unsigned(ball_y_i));
racket_y_pos1_int <= to_integer(unsigned(racket_y_pos1_i));
racket_y_pos2_int <= to_integer(unsigned(racket_y_pos2_i));

-- Pretty straight forward state machine which checks if there is a collision with the Rackets.
-- 2 process description.

--Memory_P: process (reset_i, clock_i)
--    begin
--        if (reset_i = '1') then 
--            current_state <= no_collision;
--        elsif rising_edge(clock_i) then
--            current_state <= next_state;
--        end if;
--end process;

Combinatory_P: process (current_state, ball_x_int, ball_y_int,
                         racket_y_pos1_int, racket_y_pos2_int,
                         clock_i) 
    begin
    if rising_edge (clock_i) then
        case current_state is
            when no_collision =>
                if ((((ball_x_int <= racket_left_space + racket_length) and (ball_x_int+ ball_length >= racket_left_space)) and ((ball_y_int >= racket_y_pos1_int) and (ball_y_int <= racket_y_pos1_int + racket_height)))
                    or (((ball_x_int + ball_length >= racket_right_space) and (ball_x_int <= racket_right_space + racket_length)) and ((ball_y_int >= racket_y_pos2_int) and (ball_y_int <= racket_y_pos2_int + racket_height-1))))then
                    if (ball_x_int < 320) then 
                        if ((ball_y_int >= racket_y_pos1_int) and (ball_y_int < (racket_y_pos1_int + (racket_height/5)))) then -- ISE maybe doesn't synthesise the division by 5.
                            current_state <= collision;                                                                           -- so if it doesn't work we have to put the racket-Segments
                            hit_racket_l_o <= "01";                                                                            -- here manually. 
                            hit_racket_r_o <= "00";
                        elsif ((ball_y_int >= (racket_y_pos1_int + (racket_height/5)) and (ball_y_int < (racket_y_pos1_int + 2*(racket_height/5))))) then
                            current_state <= collision;
                            hit_racket_l_o <= "10";
                            hit_racket_r_o <= "00";
                        elsif ((ball_y_int >= (racket_y_pos1_int +2*(racket_height/5))) and (ball_y_int < (racket_y_pos1_int + 3*(racket_height/5)))) then
                            current_state <= collision;
                            hit_racket_l_o <= "11";
                            hit_racket_r_o <= "00";
                        elsif ((ball_y_int >= (racket_y_pos1_int +3*(racket_height/5))) and (ball_y_int < (racket_y_pos1_int + 4*(racket_height/5)))) then
                            current_state <= collision;
                            hit_racket_l_o <= "10";
                            hit_racket_r_o <= "00";
                        elsif ((ball_y_int >= (racket_y_pos1_int +4*(racket_height/5))) and (ball_y_int < (racket_y_pos1_int + racket_height))) then
                            current_state <= collision;
                            hit_racket_l_o <= "01";
                            hit_racket_r_o <= "00";
                        else
                            current_state <= no_collision;
                            hit_racket_l_o <= "00";
                            hit_racket_r_o <= "00";
                        end if;     
                   else
                        if ((ball_y_int >= racket_y_pos2_int) and (ball_y_int < (racket_y_pos2_int + (racket_height/5)))) then 
                            current_state <= collision;
                            hit_racket_l_o <= "00";
                            hit_racket_r_o <= "01";
                        elsif ((ball_y_int >= (racket_y_pos2_int +(racket_height/5))) and (ball_y_int < (racket_y_pos2_int + 2*(racket_height/5)))) then
                            current_state <= collision;
                            hit_racket_l_o <= "00";
                            hit_racket_r_o <= "10";
                        elsif ((ball_y_int >= (racket_y_pos2_int +2*(racket_height/5))) and (ball_y_int < (racket_y_pos2_int + 3*(racket_height/5)))) then
                            current_state <= collision;
                            hit_racket_l_o <= "00";
                            hit_racket_r_o <= "11";
                        elsif ((ball_y_int >= (racket_y_pos2_int +3*(racket_height/5))) and (ball_y_int < (racket_y_pos2_int + 4*(racket_height/5)))) then
                            current_state <= collision;
                            hit_racket_l_o <= "00";
                            hit_racket_r_o <= "10";
                        elsif ((ball_y_int >= (racket_y_pos2_int +4*(racket_height/5))) and (ball_y_int < (racket_y_pos2_int + racket_height))) then
                            current_state <= collision;
                            hit_racket_l_o <= "00";
                            hit_racket_r_o <= "01";
                        else
                            current_state <= no_collision;
                            hit_racket_l_o <= "00";
                            hit_racket_r_o <= "00";
                        end if;
                    end if;
                else 
                    current_state <= no_collision;
                    hit_racket_l_o <= "00";
                    hit_racket_r_o <= "00";
                end if;    
            when others =>
		        if ((((ball_x_int <= racket_left_space + racket_length) and (ball_x_int+ ball_length >= racket_left_space)) and ((ball_y_int >= racket_y_pos1_int) and (ball_y_int <= racket_y_pos1_int + racket_height)))
                    or (((ball_x_int + ball_length >= racket_right_space) and (ball_x_int <= racket_right_space + racket_length)) and ((ball_y_int >= racket_y_pos2_int) and (ball_y_int <= racket_y_pos2_int + racket_height-1))))then
                    current_state <= collision;
                    hit_racket_l_o <= "00";
                    hit_racket_r_o <= "00";
                else 
                    current_state <= no_collision;
                    hit_racket_l_o <= "00";
                    hit_racket_r_o <= "00";
                end if;           
        end case;
    end if;
end process;

end Behavioral;