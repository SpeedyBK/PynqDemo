----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.05.2020 17:21:13
-- Design Name: 
-- Module Name: PongTB - Behavioral
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

entity PongTB is
--  Port ( );
end PongTB;

architecture Behavioral of PongTB is

component Pong is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           bums : out std_logic_vector(7 downto 0));
end component;

signal clk : std_logic := '0';
signal rst : std_logic := '1';
signal test : std_logic_vector(7 downto 0);

begin

process
begin 
    wait for 10 ns;
    clk <= not clk;
end process;

rst <= '0', '1' after 20ns;

DUT : Pong
port map (clk_i => clk,
          rst_i => rst,
          bums => test);

end Behavioral;
