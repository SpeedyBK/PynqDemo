----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik 
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 22.07.2020 13:22:44
-- Design Name: Note Address Generator
-- Module Name: address_generator - Behavioral
-- Project Name: Pong Sound Interface
-- Target Devices: Pynq Board
-- Tool Versions: 
-- Description: Instantiation of Duration FSM and Address counter. 
-- 
-- Dependencies: 
-- 
-- Revision:
-- 08/2020 Revision 1.0 - Initial Version BLK
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

entity address_generator is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           note_ena_i : in STD_LOGIC;
           clear_i : in std_logic;
           duration_i : in std_logic_vector(1 downto 0);
           address_o : out STD_LOGIC_VECTOR (7 downto 0));
end address_generator;

architecture Behavioral of address_generator is

signal addr_ena : std_logic;

begin

DURATION_FSM: entity work.note_duration_fsm
Port map ( clk_i => clk_i,
           rst_i => rst_i,
           note_ena_i => note_ena_i,
           duration_i => duration_i,
           enable_o => addr_ena );
           
ADDRESS_COUNTER: entity work.AddressCounter
port map ( clk_i => clk_i,
           rst_i => rst_i,
           note_ena_i => note_ena_i,
           enable_i => addr_ena,
           address_o => address_o);

end Behavioral;
