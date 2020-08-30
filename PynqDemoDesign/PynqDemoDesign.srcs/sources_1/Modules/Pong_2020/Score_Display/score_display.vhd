----------------------------------------------------------------------------------
-- Company: Uni Kassel
-- Engineer: Benjamin Kessler
-- 
-- Create Date: 17.03.2016 10:09:37
-- Design Name: Score_Display
-- Module Name: Score_Display - Behavioral
-- Project Name: Pong-Projekt
-- Target Devices:
-- Tool Versions: 
-- Description: Das Scoredisplay dient zur Ausgabe des Spielstands mittels 7-Segment
-- Anzeigen des Propox Boards. Es besteht aus 2 Komponenten. Zum Einen aus dem Zaehler,
-- der die Punkte mitzaehlt und zum Anderen aus dem Anzeigetreiber, der die Ausgaben
-- des Zaehlers so aufbereitet, dass sie von der 7-Segment-Anzeige des Boards nutzbar
-- sind.  
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity score_display is
    Generic(SCORE_MAX : integer := 10);
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           led_enable_i : in STD_LOGIC;
           push_but1_deb_i : in STD_LOGIC;
           push_but2_deb_i : in STD_LOGIC;
           hit_wall_i : in STD_LOGIC_VECTOR (2 downto 0);
           seven_seg_leds_o : out STD_LOGIC_VECTOR (6 downto 0);
           seven_seg_sel_o : out STD_LOGIC_VECTOR (5 downto 0);
           count_1_o : out std_logic_vector (6 downto 0);
           count_2_o : out std_logic_vector (6 downto 0);
           game_over_o : out STD_LOGIC);
end score_display;

architecture Behavioral of score_display is

signal game_count_1 : std_logic_vector (6 downto 0);
signal game_count_2 : std_logic_vector (6 downto 0);
signal seven_seg_leds : STD_LOGIC_VECTOR (6 downto 0);
signal reset        : std_logic;
signal controller_r : std_logic;
signal game_over    : std_logic;

component game_counter is               -- Counts the Score of both players.
    generic (N : integer);
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           hit_wall_i : in STD_LOGIC_VECTOR (2 downto 0);
           game_count_1 : out STD_LOGIC_VECTOR (6 downto 0);
           game_count_2 : out STD_LOGIC_VECTOR (6 downto 0);
           game_over_o : out STD_lOGIC);
end component;

component Displaydriver is              -- Converting binary numbers to BCD-numbers and does the multiplexing 
    Port ( led_enable_i : in STD_LOGIC; -- for the 7-Segment Displays
           reset_i : in STD_LOGIC; 
           game_count_1_i : in STD_LOGIC_VECTOR (6 downto 0);
           game_count_2_i : in STD_LOGIC_VECTOR (6 downto 0);
           seven_seg_leds_o : out STD_LOGIC_VECTOR (6 downto 0);
           seven_seg_sel_o : out STD_LOGIC_VECTOR (5 downto 0));
end component;

begin

with game_over select
controller_r <= push_but1_deb_i or push_but2_deb_i when '1', -- The players can only reset the score with their controllers,
                '0' when others;                             -- when the game_over signal is set. 

reset <= reset_i or controller_r;

Spielstandcounter: game_counter
    generic map (N => SCORE_MAX)
    port map (clock_i       => clock_i, 
              reset_i       => reset, 
              hit_wall_i    => hit_wall_i,
              game_count_1  => game_count_1,
              game_count_2  => game_count_2,
              game_over_o   => game_over);

Anzeigetreiber: Displaydriver
    port map (led_enable_i      => led_enable_i, 
              reset_i           => reset,
              game_count_1_i    => game_count_1,
              game_count_2_i    => game_count_2,
              seven_seg_leds_o  => seven_seg_leds,
              seven_seg_sel_o   => seven_seg_sel_o);

game_over_o <= game_over;
count_1_o <= game_count_1;
count_2_o <= game_count_2;

seven_seg_leds_o <= not seven_seg_leds;

end Behavioral;
