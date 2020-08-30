----------------------------------------------------------------------------------
-- Company: Uni Kassel
-- Engineer: Benjamin Kessler
-- 
-- Create Date: 16.03.2016 20:42:31
-- Design Name: Game Counter v1.0
-- Module Name: Game Counter - Behavioral
-- Project Name: Pong-Projekt VHDL-Kurs
-- Target Devices: Propox Spartan 3 Board
-- Tool Versions: 
-- Description: Der Spielstandszaehler zaehlt die Punkte der beiden Spieler. Dabei wird
-- das Signal "hit_wall" ausgewertet. Bei "101" bekommt Spieler 1 einen Punkt, bei "110"
-- bekommt Spieler 2 einen Punkt. Die Zaehler geben dann ihre Staende ueber die Ausgaenge 
-- an einen Decoder weiter, der diese fuer die Verwendung einer 7-Segment Anzeige weiter-
-- verarbeitet. 
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

entity game_counter is
    generic (N : integer);
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           hit_wall_i : in STD_LOGIC_VECTOR (2 downto 0);
           game_count_1 : out STD_LOGIC_VECTOR (6 downto 0);
           game_count_2 : out STD_LOGIC_VECTOR (6 downto 0);
           game_over_o : out STD_lOGIC);
end game_counter;

architecture Behavioral of game_counter is

begin
           
game_counter_1 : process (clock_i, hit_wall_i, reset_i)
    variable points_1: integer range 0 to N+1;
    variable points_2: integer range 0 to N+1;
    begin
        if (reset_i = '1') then 
            points_1 := 0;
            points_2 := 0;
            game_over_o <= '0';
        elsif rising_edge (clock_i) then 
            if ((points_1 = N) or ( points_2 = N)) then 
                points_1 := points_1;
                points_2 := points_2;
                game_over_o <= '1';
            else 
                game_over_o <= '0';
                if (hit_wall_i = "101") then
                    points_1 := points_1 + 1;
                    points_2 := points_2;
                elsif (hit_wall_i = "110") then 
                    points_2 := points_2 + 1;
                    points_1 := points_1;
                else
                    points_1 := points_1;
                    points_2 := points_2;
                end if;
            end if;
        end if;   
    game_count_1 <= std_logic_vector(to_unsigned(points_1, game_count_1'length)); 
    game_count_2 <= std_logic_vector(to_unsigned(points_2, game_count_2'length));  
end process;

end Behavioral;
