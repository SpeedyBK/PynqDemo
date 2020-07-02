----------------------------------------------------------------------------------
-- Company: Uni Kassel 
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 12.05.2020 16:49:30
-- Design Name: Pynq Demo ClockEnable Manager
-- Module Name: ClockEnableManager - Behavioral
-- Project Name: Pynq Demo Design
-- Target Devices: Pynq Board (Zynq 7 SoC)
-- Tool Versions: 
-- Description: This Module instantiates multiple ClkDividers to generate several
-- Clock Enable signals. 
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

entity ClockEnableManager is
    Generic (SysClock : integer := 125000000;
             MovEn : integer := 10;
             DigitEn : integer := 1000);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           digitEn_o : out STD_LOGIC;
           movEn_o : out STD_LOGIC);
end ClockEnableManager;

architecture Behavioral of ClockEnableManager is

component ClkDivider is
    Generic (F_in : integer; -- System Clock in Hz
             F_out: integer); -- Target Frequency in Hz.
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_o : out STD_LOGIC);
end component;

begin

MovingText: ClkDivider
generic map (F_in => SysClock, F_out => MovEn)
port map ( clk_i => clk_i,
           rst_i => rst_i,
           enable_o => movEn_o);

Digits: ClkDivider
generic map (F_in => SysClock, F_out => DigitEn)
port map ( clk_i => clk_i,
           rst_i => rst_i,
           enable_o => digitEn_o);

end Behavioral;
