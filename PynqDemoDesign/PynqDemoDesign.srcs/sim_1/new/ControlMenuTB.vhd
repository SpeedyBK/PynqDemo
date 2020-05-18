----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2020 13:55:15
-- Design Name: 
-- Module Name: ControlMenuTB - Behavioral
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

entity ControlMenuTB is
--  Port ( );
end ControlMenuTB;

architecture Behavioral of ControlMenuTB is

component ControlMenu is
    Generic (SysClock : integer := 125000000;
             MovEn : integer := 2;
             DigitEn : integer := 10000000);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           --slen_i : in STD_LOGIC_VECTOR (7 downto 0);
           --ascii_i : in STD_LOGIC_VECTOR (7 downto 0);
           --pos_o : out STD_LOGIC_VECTOR (7 downto 0);
           segments_o : out std_logic_vector (7 downto 0);
           digit : out std_logic_vector(7 downto 0);
           digit_o : out std_logic_vector(7 downto 0));
end component;

signal clk : std_logic := '0';
signal rst : std_logic := '1';
signal digits : std_logic_vector(7 downto 0);
signal segments : std_logic_vector(7 downto 0);
signal dig : std_logic_vector( 7 downto 0);

begin

process 
begin 
    wait for 10 ns;
    clk <= not clk;
end process;

DUT: ControlMenu
port map ( clk_i => clk,
           rst_i => rst,
           --slen_i : in STD_LOGIC_VECTOR (7 downto 0);
           --ascii_i : in STD_LOGIC_VECTOR (7 downto 0);
           --pos_o : out STD_LOGIC_VECTOR (7 downto 0);
           segments_o => segments,
           digit => dig,
           digit_o => digits);

end Behavioral;
