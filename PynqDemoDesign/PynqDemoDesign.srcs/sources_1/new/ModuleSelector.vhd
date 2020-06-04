----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.05.2020 15:10:02
-- Design Name: 
-- Module Name: ModuleSelector - Behavioral
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

entity ModuleSelector is
    generic (NUM_OF_MODULES : integer := 4);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           btnUp_Edge_i : in STD_LOGIC;
           btnDown_Edge_i : in STD_LOGIC;
           number_o : out STD_LOGIC_VECTOR (7 downto 0));
end ModuleSelector;

architecture Behavioral of ModuleSelector is

signal count : integer range 0 to 255 := 0;

begin

selector:process(clk_i, rst_i, btnUp_Edge_i, btnDown_Edge_i)
begin
    if (rst_i = '0') then 
        count <= 1;
    elsif rising_edge(clk_i) then 
        if ( btnUp_Edge_i = '1') then
            if (count = NUM_OF_MODULES - 1) then
                count <= count; 
            else 
                count <= count + 1;
            end if;     
        elsif (btnDown_Edge_i = '1') then 
            if (count = 0) then 
                count <= count;
            else 
                count <= count - 1;
            end if;
        end if;
    end if;
end process;

number_o <= std_logic_vector(to_unsigned(count, number_o'length));

end Behavioral;
