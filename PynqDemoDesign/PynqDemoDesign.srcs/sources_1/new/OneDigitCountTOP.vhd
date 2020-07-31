----------------------------------------------------------------------------------
-- Company: Uni Kassel  
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 31.07.2020 16:56:56
-- Design Name: Schnöder Mod-10 Up Down Counter
-- Module Name: OneDigitCountTOP - Behavioral
-- Project Name: VHDL-Kurs
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity OneDigitCountTOP is
    Generic (f_in, f_out : integer);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_i : in STD_LOGIC;
           up_ndown_i : in STD_LOGIC;
           n_SSD_o : out STD_LOGIC_VECTOR (7 downto 0));
end OneDigitCountTOP;

architecture Behavioral of OneDigitCountTOP is

signal clk_ena : std_logic;
signal count : integer range 0 to 10;

begin

ClockDivider:process(clk_i, rst_i)
variable count : integer range 0 to f_in + f_out;
begin
    if (rst_i = '1') then 
        clk_ena <= '1';
        count := 0;
    elsif rising_edge(clk_i) then 
        if (count < f_in) then 
            count := count + f_out;
            clk_ena <= '0';
        else
            count := 0;
            clk_ena <= '1';
        end if;
    end if;
end process;

UpnDownCounter: process (clk_i, clk_ena, rst_i, enable_i, up_ndown_i)
begin
    if (rst_i = '1') then 
        count <= 0;
    elsif (rising_edge(clk_i) and clk_ena = '1' and enable_i = '1') then 
        if (up_ndown_i = '1') then 
            if (count < 9) then 
                count <= count + 1;
            else 
                count <= 0;
            end if;
        else 
            if (count > 0) then 
                count <= count - 1;
            else 
                count <= 9;
            end if;
        end if;
    end if;
end process;

SevenSegmentDecoder: with count select -- (Low Active)
n_SSD_o <= "00000011" when 0,
           "10011111" when 1,
           "00100101" when 2,
           "00001101" when 3,
           "10011001" when 4,
           "01001001" when 5,
           "01000001" when 6,
           "00011111" when 7,
           "00000001" when 8,
           "00001001" when 9,
           "11111111" when others;
                       
end Behavioral;
