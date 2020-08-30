----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik
-- Engineer: Benjamin Lagershausen-Kessler
-- 
-- Create Date: 21.07.2020 23:15:40
-- Design Name: Noteduration FSM
-- Module Name: note_duration_fsm - Behavioral
-- Project Name: Pong
-- Target Devices: Pynq-Board
-- Tool Versions: 
-- Description: To implement the Noteduration FSM, we'll use a backwardscounter with variable 
-- starting-points. The starting points will be determinated with the duration_i signal.
-- A State-Diagram of this can be found in Musterlösung V6 of the Embedded-Systems-Praktikum.  
-- "00" enable_o will be '1' all the time. So we stay in the zero state. 
-- "01" enable_o will be '1' in every 2nd note-clk-cycle. So we have to count backwards from state one.
-- "10" enable_o will be '1' in every 4th note-clk-cycle. So we have to count backwards from state three.
-- "11" enable_o will be '1' in every 8nd note-clk-cycle. So we have to count backwards from state seven.
--
-- Dependencies: 
-- 
-- Revision:
-- 08/2020 Revision 1.0 - Initial Version BLK.
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

entity note_duration_fsm is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           note_ena_i : in STD_LOGIC;
           duration_i : in STD_LOGIC_VECTOR (1 downto 0);
           enable_o : out STD_LOGIC);
end note_duration_fsm;

architecture Behavioral of note_duration_fsm is

type state_t is (zero, one, two, three, four, five, six, seven);
signal state : state_t := zero;

begin

note_duration: process (clk_i, rst_i, note_ena_i, duration_i)
begin
    if (rst_i = '1') then 
        state <= zero;
        enable_o <= '0';
    elsif rising_edge(clk_i) and note_ena_i='1' then 
        case state is 
            when zero =>
                if (duration_i = "00" ) then 
                    state <= zero;
                    enable_o <= '1';
                elsif (duration_i = "01") then  
                    state <= one;
                    enable_o <= '0';
                elsif (duration_i = "10") then
                    state <= three;
                    enable_o <= '0';
                elsif (duration_i = "11") then 
                    state <= seven;
                    enable_o <= '0';
                end if; 
            when one =>
                enable_o <= '1';
                state <= zero;
            when two =>
                enable_o <= '0';
                state <= one;                    
            when three =>
                enable_o <= '0';
                state <= two;  
            when four =>
                enable_o <= '0';
                state <= three;       
            when five =>
                enable_o <= '0';
                state <= four;
            when six =>
                enable_o <= '0';
                state <= five;    
            when seven =>
                enable_o <= '0';
                state <= six;  
            when others =>
                state <= zero;
        end case;
    end if;
end process;

end Behavioral;
