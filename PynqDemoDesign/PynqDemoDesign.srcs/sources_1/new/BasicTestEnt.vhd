----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.06.2020 12:11:08
-- Design Name: 
-- Module Name: BasicTestEnt - Behavioral
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

entity BasicTestEnt is
  Port ( clk_i, rst_i : in std_logic;
         btn_i : in std_logic_vector(3 downto 0);
         leds_o : out std_logic_vector(3 downto 0);
         n_sw_shield_i : in std_logic_vector (7 downto 0);
         n_leds_shield_o : out std_logic_vector (7 downto 0);
         rgb1_o : out std_logic_vector(2 downto 0);
         rgb2_o : out std_logic_vector(2 downto 0);
         digit_ena_o : out std_logic_vector(7 downto 0);
         segments_o : out std_logic_vector(7 downto 0));
end BasicTestEnt;

architecture Behavioral of BasicTestEnt is

signal clk_ena : std_logic;
signal dig_ena : std_logic;
signal color : std_logic_vector(2 downto 0):= "001";
signal dig_count : std_logic_vector(2 downto 0); 
signal count : integer range 0 to 7;
signal ssd_dat : std_logic_vector (2 downto 0);
signal dat : std_logic_vector (2 downto 0);

begin

leds_o <= btn_i;
n_leds_shield_o <= n_sw_shield_i;

ClockEnable:process(clk_i, rst_i) 
variable counterA : integer range 0 to 62500000;
variable counterB : integer range 0 to 62500;
begin
    if (rst_i = '1') then 
        counterA := 0;
        counterB := 0;
        clk_ena <= '0';
        dig_ena <= '0';
    elsif rising_edge(clk_i) then 
        if (counterA < 62500000) then
            counterA := counterA + 1;
            clk_ena <= '0';
        else 
            counterA := 0;
            clk_ena <= '1';
        end if;
        if (counterB < 62500) then 
            counterB := counterB + 1;
            dig_ena <= '0';
        else 
            counterB := 0;
            dig_ena <= '1';
        end if;
    end if;
end process; 

RGBColor:process(clk_i, rst_i, clk_ena)
begin
    if (rst_i = '1') then 
        color <= "001";
    elsif rising_edge(clk_i) then 
        if (clk_ena = '1') then 
            color <= std_logic_vector(unsigned(color) rol 1);   
        end if;
    end if;
end process;     

rgb1_o <= color;
rgb2_o <= color;

DisplayMUX:process(clk_i, rst_i, dig_ena)
variable counter : integer range 0 to 7;
begin
    if (rst_i = '1') then 
        counter := 0;
        dig_count <= std_logic_vector(to_unsigned(counter, 3));
    elsif rising_edge(clk_I) then 
        if (dig_ena = '1') then
            if (counter < 7) then
                counter := counter + 1;
                dig_count <= std_logic_vector(to_unsigned(counter, 3));
            else 
                counter := 0;
                dig_count <= std_logic_vector(to_unsigned(counter, 3));
            end if;
        end if;    
    end if;
end process;

BCDCounter: process (clk_i, rst_i, clk_ena)
begin
    if (rst_i = '1') then 
        count <= 0;
    elsif rising_edge(clk_i) then 
        if (clk_ena = '1') then
            if (count < 7) then  
                count <= count + 1;
            else 
                count <= 0;
            end if;
        end if;
    end if;
end process; 

with dig_count select
digit_ena_o <= "11111110" when "000",   
               "11111101" when "001",  
               "11111011" when "010",  
               "11110111" when "011",  
               "11101111" when "100",  
               "11011111" when "101",  
               "10111111" when "110",
               "01111111" when others;



ssd_dat <= std_logic_vector(to_unsigned(count, 3) + unsigned(dig_count));               

with ssd_dat select 
    segments_o <= "0000001" & ssd_dat(0) when "000",
                  "1001111" & ssd_dat(0) when "001",
                  "0010010" & ssd_dat(0) when "010",
                  "0000110" & ssd_dat(0) when "011",
                  "1001100" & ssd_dat(0) when "100",
                  "0100100" & ssd_dat(0) when "101",
                  "0100000" & ssd_dat(0) when "110",
                  "0001111" & ssd_dat(0) when others;
                   
end Behavioral;
