----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2020 19:29:24
-- Design Name: 
-- Module Name: DeBouncerTB - Behavioral
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

entity DeBouncerTB is
--  Port ( );
end DeBouncerTB;

architecture Behavioral of DeBouncerTB is

component Debouncer is
    Generic (prescaler : integer := 10000);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           signal_i : in STD_LOGIC;
           signal_o : out STD_LOGIC;
           risingedge_o : out std_logic;
           fallingedge_o : out std_logic);
end component;

signal input : std_logic_vector(63 downto 0) := "0001010011111111111111110101000000001010101011111111111111100000";
signal si  : std_logic;
signal clk : std_logic := '0';
signal clkSlow : std_logic := '0';
signal rst : std_logic := '0';
signal deb : std_logic;
signal rise: std_logic;
signal fall: std_logic;

begin

-- CLK
process 
begin
    wait for 5 ns;
    clk <= not clk;
end process;


-- Input

process 
begin
    wait for 100 ns;
    clkSlow <= not clkSlow;
end process;

process (clkSlow)
variable i : integer := 0;
begin
    if (rising_edge(clkSlow)) then
        if (i < 8) then 
            rst <= '0';
            i := i + 1;
            si <= input(i);
        elsif (i < 63 + 8) then 
            rst <= '1';
            i := i + 1;
            si <= input(i - 8);
        else 
            i := 0;
        end if;
    end if;
end process;

DUT:Debouncer
generic map (prescaler => 10)
port map ( clk_i => clk,
           rst_i => rst,
           signal_i => si,
           signal_o => deb,
           risingedge_o => rise,
           fallingedge_o => fall);

end Behavioral;
