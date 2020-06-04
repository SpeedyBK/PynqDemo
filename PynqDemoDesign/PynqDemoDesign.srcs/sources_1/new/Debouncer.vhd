----------------------------------------------------------------------------------
-- Company: Uni Kassel
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 12.05.2020 13:02:58
-- Design Name: Pynq Demo Debouncer
-- Module Name: Debouncer - Behavioral
-- Project Name: Pynq Demo Design
-- Target Devices: Pynq Board (Zynq 7 SoC)
-- Tool Versions: 
-- Description: This Module is used to Debounce Signals from manual inputs like buttons or switches.
-- Therefor a shift register and a counter is used. The counter counts up to a preselected value. 
-- When it reaches this value, a sample from the inputsignal is saved into a shift register and the 
-- counter is set back to 0 and starts counting again.
-- When the shift register contains only '1's or only '0's signal_o is set to '1' or to '0' accordingly.
-- When the shift register contains "01111111" risingedge_o will be '1' for one clock cycle.
-- When the shift register contains "10000000" fallingedge_o will be '1' for one clock cycle. 
-- This is a pretty simple method to debounce signals and perfom an edge detection. 
-- 
-- Dependencies: None 
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

entity Debouncer is
    Generic (prescaler : integer := 10000);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           signal_i : in STD_LOGIC;
           signal_o : out STD_LOGIC;
           risingedge_o : out std_logic;
           fallingedge_o : out std_logic);
end Debouncer;

architecture Behavioral of Debouncer is

signal s_reg : std_logic_vector (7 downto 0); -- The Shift Register is used to debounce a signal. 
signal s_temp : std_logic;
signal delay : integer range 0 to 10000;

begin

Debounce: process (clk_i, rst_i)
begin
    if (rst_i = '0') then 
        delay <= 0;
        s_reg <= "00000000";
        s_temp <= '0';
        risingedge_o <= '0';
        fallingedge_o <= '0';
    elsif rising_edge(clk_i) then 
        if (delay < prescaler) then 
            delay <= delay + 1;
            risingedge_o <= '0';
            fallingedge_o <= '0';
        else
            delay <= 0; 
            s_reg <= s_reg (6 downto 0) & signal_i;
            if (s_reg = "00000000") then s_temp <= '0'; end if;
            if (s_reg = "11111111") then s_temp <= '1'; end if;
            risingedge_o <= '0';
            if (s_reg = "01111111") then risingedge_o <= '1'; end if;
            fallingedge_o <= '0';
            if (s_reg = "10000000") then fallingedge_o <= '1'; end if;
        end if;
    end if;
end process;

signal_o <= s_temp;

end Behavioral;
