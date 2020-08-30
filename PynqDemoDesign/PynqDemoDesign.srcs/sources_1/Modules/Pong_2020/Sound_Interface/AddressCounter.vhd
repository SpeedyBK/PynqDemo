----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 22.07.2020 09:43:17
-- Design Name: Address Counter 
-- Module Name: AddressCounter - Behavioral
-- Project Name: Pong-Soundinterface
-- Target Devices: Pynq Board
-- Tool Versions: 
-- Description: Just a simple counter, which reacts to the output of the duration 
--              FSM, and counts up the Node Addresses. 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 08/2020 1.0 - Initial Version BLK
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

entity AddressCounter is
  Port (clk_i : in std_logic;
        rst_i : in std_logic;
        note_ena_i : in std_logic;
        enable_i : in std_logic;
        address_o : out std_logic_vector(7 downto 0));
end AddressCounter;

architecture Behavioral of AddressCounter is

constant MAXCOUNT : integer := 255;

signal enable : std_logic;
signal reset : std_logic;

begin

enable <= enable_i and note_ena_i;
reset <= rst_i;

counter : process (clk_i, reset, enable)
variable count : integer range 0 to 255 := 1;
begin 
    if (reset = '1') then
        count := 1;
        address_o <= std_logic_vector(to_unsigned(1, address_o'length));
    elsif (rising_edge(clk_i) and enable = '1') then 
        if (count < MAXCOUNT) then 
            address_o <= std_logic_vector(to_unsigned(count, address_o'length));
            count := count + 1;
        else 
            address_o <= std_logic_vector(to_unsigned(count, address_o'length));
            count := 1;
        end if;
    end if;
end process;

end Behavioral;
