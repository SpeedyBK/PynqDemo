----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.03.2016 11:29:01
-- Design Name: 
-- Module Name: Check_Wall - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Check_Wall is
    generic (ball_length   : integer := 6;
             screen_height : integer := 480);
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           ball_x_i : in STD_LOGIC_VECTOR (9 downto 0);
           ball_y_i : in STD_LOGIC_VECTOR (9 downto 0);
           hit_wall_o : out STD_LOGIC_VECTOR (2 downto 0));
end Check_Wall;

architecture Behavioral of Check_Wall is

type Zustand is (no_collision, wall_up, wall_down, out_left, out_right);	
	signal next_state		: Zustand;
	signal current_state	: Zustand;
	
	signal ball_x_int : integer range -50 to 700;
	signal ball_y_int : integer range -50 to 700;

begin

ball_x_int <= to_integer(unsigned(ball_x_i) + 10);
ball_y_int <= to_integer(unsigned(ball_y_i) + 10);

Speicher_P:process (reset_i, clock_i)
    begin
        if (reset_i = '1') then 
            current_state <= no_collision;
            --hit_wall_o <= "000";
        elsif rising_edge(clock_i) then
            current_state <= next_state;
        end if;
end process;

Zustands_P:process (current_state, ball_x_int, ball_y_int)
    begin
        case current_state is
            when no_collision =>
                if ((ball_y_int <= 10) and ((ball_x_int > 10) and (ball_x_int < 644))) then 
                    next_state <= wall_up;
                elsif ((ball_y_int >= 484) and ((ball_x_int > 0) and (ball_x_int < 644))) then
                    next_state <= wall_down;
                elsif (ball_x_int <= 30) then
                    next_state <= out_left;
                elsif (ball_x_int >= 626) then 
                    next_state <= out_right;
                else 
                    next_state <= no_collision;
                end if;
            when wall_up =>
                if (ball_y_int > 10) then 
                    next_state <= no_collision;
                else 
                    next_state <= wall_up;
                end if;
            when wall_down =>
                if (ball_y_int >= 484) then 
                    next_state <= wall_down;
                else 
                    next_state <= no_collision;
                end if;
            when out_left => 
                if (ball_x_int > 30) then 
                    next_state <= no_collision;
                else 
                    next_state <= out_left;
                end if;
            when others =>
                if (ball_x_int >= 626) then 
                    next_state <= out_right;
                else 
                    next_state <= no_collision;
                end if;
       end case;
end process;

Ausgang:process (current_state, ball_x_int, ball_y_int)
    begin
        case current_state is
            when no_collision =>
                if ((ball_y_int <= 10) and ((ball_x_int > 30) and (ball_x_int < 644))) then
                    hit_wall_o <= "010";
                elsif ((ball_y_int >= 484) and ((ball_x_int > 30) and (ball_x_int < 644))) then
                    hit_wall_o <= "001";
                elsif (ball_x_int <= 30) then
                    hit_wall_o <= "110";
                elsif (ball_x_int >= 626) then
                    hit_wall_o <= "101";
                else 
                    hit_wall_o <= "000";
                end if;
            when others =>
                hit_wall_o <= "000";
        end case;
end process; 
                

end Behavioral;
