----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 15:35:31
-- Design Name: 
-- Module Name: TextMover - Behavioral
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

entity TextMover is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_i : in STD_LOGIC;
           name_len_i : in STD_LOGIC_VECTOR (7 downto 0);
           pointer_i : in STD_LOGIC_VECTOR (3 downto 0);
           name_ptr_o : out STD_LOGIC_VECTOR (7 downto 0));
end TextMover;

architecture Behavioral of TextMover is

signal i : integer range 0 to 255;
signal j : integer range 0 to 255;

begin

Mover: process(clk_i, rst_i, enable_i)
begin
    if (rst_i <= '0') then 
        i <= 8;
    elsif rising_edge(clk_i) then 
        if (enable_i = '1')  then
            if (unsigned(name_len_i) > 8) then  
                if (i <= to_integer(unsigned(name_len_i) + 8)) then 
                    i <= i + 1;
                else 
                    i <= 0;
                end if;
            else 
                i <= 8;
            end if;
        end if;
    end if;
end process; 

name_ptr_o <= std_logic_vector (to_unsigned(i - 8 + to_integer(unsigned(pointer_i)), name_ptr_o'length));

end Behavioral;
