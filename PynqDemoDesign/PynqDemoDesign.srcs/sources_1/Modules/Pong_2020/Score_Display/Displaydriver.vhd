----------------------------------------------------------------------------------
-- Company: Uni Kassel
-- Engineer: Benjamin Kessler
-- 
-- Create Date: 17.03.2016 10:09:37
-- Design Name: Displaydriver
-- Module Name: Displaydriver - Behavioral
-- Project Name: Pong-Projekt VHDL-Kurs
-- Target Devices: Propox Spartan 3 Board
-- Tool Versions: 
-- Description: Der Displaydriver verarbeitet die vom Spielstandszaehler kommenden
-- Signale. Und verteilt diese auf die einzelnen Stellen der Anzeige unter der Ver-
-- wendung zweier Multiplexer. 
-- Zuerst wird aus dem LED_enable Takt mit einem Zaehler ein Signal generiert, was 
-- zur Ansteuerung der Multiplexer nutzbar ist. Der erste Multiplexer bestimmt, welches
-- Signal in an die Binary-to-BCD Komponente zur Konvertierung gegeben wird. Und der
-- zweite Multiplexer gibt die enstsprechenden BCD Zahlen dann zur Konvertierung in 
-- "7-Segment-Code" weiter, der dann Ausgegeben wird. 
--
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

entity Displaydriver is
    Port ( led_enable_i : in STD_LOGIC;
           reset_i : in STD_LOGIC; 
           game_count_1_i : in STD_LOGIC_VECTOR (6 downto 0);
           game_count_2_i : in STD_LOGIC_VECTOR (6 downto 0);
           seven_seg_leds_o : out STD_LOGIC_VECTOR (6 downto 0);
           seven_seg_sel_o : out STD_LOGIC_VECTOR (5 downto 0));
end Displaydriver;

architecture Behavioral of Displaydriver is

-- Signals:
signal LED_Enable       : std_logic_vector (2 downto 0);
signal binary           : std_logic_vector (6 downto 0);
signal ones             : std_logic_vector (3 downto 0);
signal tens             : std_logic_vector (3 downto 0);
signal convert_to_7seg  : std_logic_vector (3 downto 0);

-- Binary to BCD converter:
component Binary_to_BCD is
    Port ( binary_i   : in STD_LOGIC_VECTOR (6 downto 0);
           BCD_ones_o : out STD_LOGIC_VECTOR (3 downto 0);
           BCD_tens_o : out STD_LOGIC_VECTOR (3 downto 0));
end component;

begin

-- Counter to create the controllsignal for multiplexing the displays:
LED_Enable_counter: process (led_enable_i, reset_i)
    begin
        if rising_edge (led_enable_i) then 
            if (reset_i = '1') then
                LED_Enable <= "000";
            else 
                if (LED_Enable <= "101") then 
                    LED_Enable <= std_logic_vector(unsigned(LED_Enable) + "001");
                else
                    LED_Enable <= "000";
                end if;
            end if;
        end if;
end process;

-- Selection of the active Display:
with LED_Enable select
    seven_seg_sel_o <= "100000" when "000",
                       "010000" when "001",
                       "001000" when "010",
                       "000100" when "011",
                       "000010" when "100",
                       "000001" when "101",
                       "000000" when others;

-- Selecting the Inputs to convert to BCD:
with LED_Enable select
    binary           <= game_count_1_i when "000",
                        game_count_1_i when "001",
                        "0000000" when "010",
                        "0000000" when "011",
                        game_count_2_i when "100",
                        game_count_2_i when "101",
                        "0000000" when others;

-- Converting Binary to BCD:
BCD_Conversion: Binary_to_BCD
port map (binary_i => binary, BCD_ones_o => ones, BCD_tens_o => tens);

-- Selecting BCD-Signals depending on the active display.                       
with LED_Enable select
    convert_to_7seg   <= tens when "000",
                         ones when "001",
                         "1111" when "010",
                         "1111" when "011",
                         tens when "100",
                         ones when "101",
                         "1111" when others;
  
-- Converting BCD-Code to "7-Segment-Code":                      
with convert_to_7seg select
    seven_seg_leds_o <= "0000001" when "0000",
                        "1001111" when "0001",
                        "0010010" when "0010",
                        "0000110" when "0011",
                        "1001100" when "0100",
                        "0100100" when "0101",
                        "0100000" when "0110",
                        "0001111" when "0111",
                        "0000000" when "1000",
                        "0000100" when "1001",
                        "1111111" when others;

end Behavioral;
