----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.06.2020 23:26:56
-- Design Name: 
-- Module Name: Licht - Behavioral
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

entity Licht is
  generic (f_in, f_out :integer);
  Port ( clk_i : in std_logic;
         rst_i : in std_logic;
         enable_i : in std_logic; 
         blue_leds_o : out std_logic_vector (7 downto 0));
end Licht;

architecture Behavioral of Licht is

signal moving_light : std_logic_vector (7 downto 0) := "11110111";
signal left : std_logic := '1';
signal clk_ena : std_logic;
signal enable : std_logic := '0';
signal edge : std_logic_vector(1 downto 0);

begin


process (clk_i, rst_i)
variable count : integer range 0 to f_in + f_out;
begin
    if (rst_i = '1') then 
        count := 0;
    elsif rising_edge(clk_i) then 
        if (count < f_in) then 
            count := count + f_out;
            clk_ena <= '0';
        else 
            count := 0;
            clk_ena <= '1';
        end if;
    end if;
end process;


process(clk_i, enable_i, rst_i)
begin
    if (rst_i = '1') then 
        enable <= '0';
    elsif rising_edge(clk_i) then 
        edge <= edge(0) & enable_i;
        if (edge = "01") then 
            enable <= not enable;
        end if;
    end if;
end process;


Movinglight:process(clk_i, rst_i, enable_i)
begin
    if (rst_i = '1') then 
        moving_light <= "11110111";
    elsif rising_edge(clk_i) then 
        if (enable = '1' and clk_ena = '1') then  
            moving_light <= std_logic_vector(unsigned(moving_light) rol 1);
        end if;
    end if;
end process; 

blue_leds_o <= moving_light;

end Behavioral;
