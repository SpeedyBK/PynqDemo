----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2016 19:47:17
-- Design Name: 
-- Module Name: Collision_detection - Behavioral
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

entity Collision_detection is
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
           hit_wall_o : out STD_LOGIC_VECTOR (2 downto 0);
           hit_racket_l_o : out STD_LOGIC_VECTOR (1 downto 0);
           hit_racket_r_o : out STD_LOGIC_VECTOR (1 downto 0));
end Collision_detection;

architecture Behavioral of Collision_detection is

component Check_Wall is
    generic (ball_length   : integer := 6;
             screen_height : integer := 480;
             racket_left_space : integer := 20;
             racket_right_space : integer := 610;
             racket_length : integer := 10);
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           ball_x_i : in STD_LOGIC_VECTOR (9 downto 0);
           ball_y_i : in STD_LOGIC_VECTOR (9 downto 0);
           hit_wall_o : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component racket_check is
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
end component;

type Zustand is (zero, counting);	
signal state : Zustand;
signal count : integer range 0 to 10000000;

signal hit_racket_l : STD_LOGIC_VECTOR (1 downto 0);
signal hit_racket_r : STD_LOGIC_VECTOR (1 downto 0);
signal hit_wall : STD_LOGIC_VECTOR (2 downto 0);

begin

Umrandung: Check_Wall
port map (clock_i => clock_i,
          reset_i => reset_i,
          ball_x_i => ball_x_i,
          ball_y_i => ball_y_i,
          hit_wall_o => hit_wall);
          
Schlaeger: racket_check
port map (clock_i => clock_i,
          reset_i => reset_i,
          racket_y_pos1_i => racket_y_pos1_i,
          racket_y_pos2_i => racket_y_pos2_i,
          ball_x_i => ball_x_i,
          ball_y_i => ball_y_i,
          hit_racket_l_o => hit_racket_l,
          hit_racket_r_o => hit_racket_r);
          
-- Because of the slow 60Hz enable-signal which the Ball Motion is using, it can happen, 
-- that the ball hits the racket and out. The following process surpresses the "out of field"
-- signal for 0.2 seconds after a collision with a racket is detected. But should not effect
-- the "hit-wall" signal. 

Hit_Racket_over_Hit_Wall:process (hit_racket_l, hit_racket_r, hit_wall, clock_i, reset_i)
begin
    if (reset_i = '1') then 
        count <= 0; 
    elsif rising_edge (clock_i) then
        case state is
            when zero =>
                if ((hit_racket_l /= "00") or (hit_racket_r /= "00"))then  
                    count <= count + 1;
                    if (hit_wall = "101" or hit_wall = "110") then
                        if (hit_wall = "001" or hit_wall = "010") then
                            hit_wall_o <= hit_wall;
                        else
                            hit_wall_o <= "000";
                        end if;
                    else 
                        hit_wall_o <= hit_wall;
                    end if;
                    state <= counting;
                else
                    count <= 0;
                    hit_wall_o <= hit_wall;
                    state <= zero;
                end if;
            when counting =>
                if (count < 10000000) then
                    count <= count + 1;
                    if (hit_wall = "101" or hit_wall = "110") then
                        if (hit_wall = "001" or hit_wall = "010") then
                            hit_wall_o <= hit_wall;
                        else
                            hit_wall_o <= "000";
                        end if;
                    else 
                        hit_wall_o <= hit_wall;
                    end if;
                    state <= counting;
                else
                    count <= 0;
                    hit_wall_o <= hit_wall;
                    state <= zero;
                end if;
        end case;
    end if;
end process;

hit_racket_l_o <= hit_racket_l;
hit_racket_r_o <= hit_racket_r;         

end Behavioral;