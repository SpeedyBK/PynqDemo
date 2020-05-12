----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2020 20:02:52
-- Design Name: 
-- Module Name: ClkDivTB - Behavioral
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

entity ClkDivTB is
--  Port ( );
end ClkDivTB;

architecture Behavioral of ClkDivTB is

component ClkDivider is
    Generic (F_in : integer := 125000000; -- System Clock in Hz
             F_out: integer := 2); -- Target Frequency in Hz.
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_o : out STD_LOGIC);
end component;

signal clk : std_logic := '0';
signal rst : std_logic := '0';
signal enable : std_logic;

begin

--clk
process
    begin 
    wait for 5 ns;
    clk <= not clk;
end process;

rst <= '0', '1' after 200 ns;

DUT : ClkDivider
generic map (F_in => 10, F_out => 1)
port map (clk_i => clk, rst_i => rst, enable_o => enable);

end Behavioral;
