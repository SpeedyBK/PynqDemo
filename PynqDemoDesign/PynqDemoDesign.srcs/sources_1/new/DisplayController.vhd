----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 13.05.2020 19:39:22
-- Design Name: Pynq Demo Display Controler
-- Module Name: DisplayController - Behavioral
-- Project Name: Pynq Demo Design
-- Target Devices: Pynq Board (Zynq 7 SoC)
-- Tool Versions: 
-- Description: This module basicly has two parts. The first part is the function toSevenSeg()
-- which converts ASCII-Letters to 7-Segment-Code if it is possible. 
-- The second part is a process, which generates the enable-signals for each digit, as well as 
-- a pointer, which points to the data that should be displayed. This data is stored in the 
-- application modules.  
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
use work.ascii_p.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DisplayController is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_i : in STD_LOGIC;
           name_dat_i : in STD_LOGIC_VECTOR (7 downto 0);
           pointer_o : out std_logic_vector (3 downto 0);
           digit_o : out std_logic_vector (7 downto 0);
           segments_o : out std_logic_vector (7 downto 0));
end DisplayController;

architecture Behavioral of DisplayController is

-- This function uses a ROM-Module to look-up the seven segment code of an ASCII-Letter, 
-- if it exists, else it blanks out the digit. The ROM is discriped in ascii_p.vhd.
function toSevenSeg (data : in std_logic_vector (7 downto 0)) return std_logic_vector is
    variable SevenSeg : std_logic_vector(7 downto 0);

    begin

        -- the negation is needed if low-activ displays are used.
        SevenSeg := not ascii_c(to_integer(unsigned(data)- 48));
        -- Output of the ROM is "?abcdefg", for the display used on the Pynq Board
        -- we need "abcdefg(dp)" so we have to rotate the signal to the left by 1 bit. 
        SevenSeg := std_logic_vector(rotate_left(unsigned(SevenSeg), 1));

    return std_logic_vector(SevenSeg);
end toSevenSeg;

begin

process(clk_i, rst_i, enable_i, name_dat_i)
variable i : integer range 0 to 7;
begin
    if (rst_i = '0') then 
        i := 0;
        segments_o <= (others => '0');
        digit_o <= (others => '0');
    elsif rising_edge(clk_i) then
        segments_o <= toSevenSeg(name_dat_i); 
        if (enable_i = '1') then 
            if (i < 7) then 
                i := i + 1;
            else 
                i := 0;
            end if;    
            case i is
                when 0 =>
                    digit_o <= "01111111";
                    pointer_o <= std_logic_vector(to_unsigned(i+1, pointer_o'length)); -- i+1 is needed because strings are indexed from 1 to n      
                when 1 =>
                    digit_o <= "10111111";
                    pointer_o <= std_logic_vector(to_unsigned(i+1, pointer_o'length)); -- i+1 is needed because strings are indexed from 1 to n 
                when 2 =>
                    digit_o <= "11011111";
                    pointer_o <= std_logic_vector(to_unsigned(i+1, pointer_o'length)); -- i+1 is needed because strings are indexed from 1 to n       
                when 3 =>
                    digit_o <= "11101111";
                    pointer_o <= std_logic_vector(to_unsigned(i+1, pointer_o'length)); -- i+1 is needed because strings are indexed from 1 to n      
                when 4 =>
                    digit_o <= "11110111";
                    pointer_o <= std_logic_vector(to_unsigned(i+1, pointer_o'length)); -- i+1 is needed because strings are indexed from 1 to n       
                when 5 => 
                    digit_o <= "11111011";
                    pointer_o <= std_logic_vector(to_unsigned(i+1, pointer_o'length)); -- i+1 is needed because strings are indexed from 1 to n  
                when 6 =>
                    digit_o <= "11111101";
                    pointer_o <= std_logic_vector(to_unsigned(i+1, pointer_o'length)); -- i+1 is needed because strings are indexed from 1 to n       
                when others =>
                    digit_o <= "11111110";
                    pointer_o <= std_logic_vector(to_unsigned(i+1, pointer_o'length)); -- i+1 is needed because strings are indexed from 1 to n  
            end case;
        end if;
    end if;
end process;

end Behavioral;
