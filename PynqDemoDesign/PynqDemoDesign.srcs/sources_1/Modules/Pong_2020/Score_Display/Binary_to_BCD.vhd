----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Benjamin Kessler
-- 
-- Create Date: 18.03.2016 14:49:57
-- Design Name: Binary to BCD Converter
-- Module Name: Binary_to_BCD - Behavioral
-- Project Name: Pong SS 16
-- Target Devices: Propox Spartan 3 Board
-- Tool Versions: 
-- Description: In diesem Modul werden die Ausgaenge des Zaehlers von einer Binaerzahl 
-- in BCD Zahlen aufgeteilt. Dazu wird der "Double Dabble"-Algorithmus
-- verwendet. https://en.wikipedia.org/wiki/Double_dabble
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

entity Binary_to_BCD is
    Port ( binary_i : in STD_LOGIC_VECTOR (6 downto 0);
           BCD_ones_o : out STD_LOGIC_VECTOR (3 downto 0);
           BCD_tens_o : out STD_LOGIC_VECTOR (3 downto 0));
end Binary_to_BCD;

architecture Behavioral of Binary_to_BCD is

begin

-- Double Dabble algorithm: https://en.wikipedia.org/wiki/Double_dabble
-- to convert binary- to BCD numbers. 

BCD_Convertion : process(binary_i)

    variable temp   : std_logic_vector (7 downto 0);
    variable BCD    : unsigned (7 downto 0);
    
    begin
        bcd := "00000000";
        temp := '0' & binary_i;
        
        for i in 0 to 7 loop
            if BCD(3 downto 0) > 4 then 
                BCD(3 downto 0) := BCD(3 downto 0) + 3;
            end if;
            
            if BCD(7 downto 4) > 4 then 
                BCD(7 downto 4) := BCD(7 downto 4) + 3;
            end if;
            
            BCD := BCD (6 downto 0) & temp(7);
            temp := temp(6 downto 0) & '0';
        end loop;
        
    BCD_ones_o <= std_logic_vector(BCD (3 downto 0));
    BCD_tens_o <= std_logic_vector(BCD (7 downto 4));
end process;

end Behavioral;
