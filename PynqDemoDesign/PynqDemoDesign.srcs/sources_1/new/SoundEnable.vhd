----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.09.2020 18:53:00
-- Design Name: 
-- Module Name: SoundEnable - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SoundEnable is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           clear_i : in STD_LOGIC;
           play_i : in STD_LOGIC;
           enable_o : out STD_LOGIC);
end SoundEnable;

architecture Behavioral of SoundEnable is

begin


end Behavioral;
