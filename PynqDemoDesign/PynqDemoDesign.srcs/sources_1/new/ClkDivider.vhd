----------------------------------------------------------------------------------
-- Company: Uni Kassel  
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 12.05.2020 16:31:43
-- Design Name: Pynq Demo
-- Module Name: ClkDivider - Behavioral
-- Project Name: Pynq Demo Design
-- Target Devices: Pynq Board (Zynq 7 SoC)
-- Tool Versions: 
-- Description: This Module generates enable signals. The frequency of those enable signals 
-- are determined by two generic values. F_in is the fequency of the systemclock and F_out is
-- the desired target-frequency. The generated enable signal is only high for 1 clockcycle of 
-- the system clock.  
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

entity ClkDivider is
    Generic (F_in : integer := 125000000; -- System Clock in Hz
             F_out: integer := 2); -- Target Frequency in Hz.
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_o : out STD_LOGIC);
end ClkDivider;

architecture Behavioral of ClkDivider is

begin

Divider:process(rst_i, clk_i)
variable i : integer range 0 to F_in;
begin 
    if (rst_i = '0') then 
        i := 0;
        enable_o <= '0';
    elsif rising_edge(clk_i) then 
        if (i < F_in) then  
            i := i + F_out;
            enable_o <= '0';
        else
            i := 0;
            enable_o <= '1';
        end if;
    end if;
end process;
            
end Behavioral;
