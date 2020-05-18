----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.05.2020 08:23:38
-- Design Name: 
-- Module Name: Pong - Behavioral
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

entity Pong is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           pointer_i : in std_logic_vector(7 downto 0);
           strlen_o : out std_logic_vector(7 downto 0);
           ascii_o : out std_logic_vector(7 downto 0));
end Pong;

architecture Behavioral of Pong is

constant spaces : string := "        ";
constant name : string := "Pong!";
constant str : string := spaces & name;
signal c : integer range 0 to 255;

begin

strlen_o <= std_logic_vector(to_unsigned(name'length, strlen_o'length));
ascii_o <= std_logic_vector(to_unsigned(character'pos(name(to_integer(unsigned(pointer_i)))), 8));

end Behavioral;