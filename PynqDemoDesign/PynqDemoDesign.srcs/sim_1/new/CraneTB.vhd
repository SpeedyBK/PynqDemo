----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.05.2020 21:56:47
-- Design Name: 
-- Module Name: CraneTB - Behavioral
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

entity CraneTB is
--  Port ( );
end CraneTB;

architecture Behavioral of CraneTB is

component CraneController is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           start_i : in STD_LOGIC;
           motor_signals_o : out STD_LOGIC_VECTOR (3 downto 0);
           magnet_o : out std_logic);
end component;

signal clk, rst, start, magnet : std_logic := '0';
signal motor : std_logic_vector (3 downto 0);

begin

process
begin 
    wait for 1 ns;
    clk <= not clk;
end process;

rst <= '1', '0' after 20 ns;
start <= '0', '1' after 30 ns, '0' after 50 ns;

DUT: CraneController
port map ( clk_i => clk,
           rst_i => rst,
           start_i => start,
           motor_signals_o => motor,
           magnet_o => magnet);

end Behavioral;
