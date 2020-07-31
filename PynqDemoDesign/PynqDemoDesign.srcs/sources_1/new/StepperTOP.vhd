----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.07.2020 20:43:31
-- Design Name: 
-- Module Name: StepperTOP - Behavioral
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

entity StepperTOP is
  generic (f_in : integer);
  Port ( clk_i : in std_logic;
         rst_i : in std_logic;
         direction_cw_i : in std_logic;
         half_step_i : in std_logic;
         step_frequency_i : in std_logic_vector(7 downto 0);
         stepper_o : out std_logic_vector(3 downto 0));
end StepperTOP;

architecture Behavioral of StepperTOP is

type state_t is (one, two, three, four, five, six, seven, eight);
signal state : state_t := one;

signal step_enable : std_logic;

begin

SpeedControl:process(clk_i, rst_i, step_frequency_i)
variable count : integer range 0 to f_in + 255;
begin
    if (rst_i = '1') then 
        count := 0;
        step_enable <= '0';
    elsif rising_edge(clk_i) then 
        if (count < f_in) then 
            count := count + to_integer(unsigned(not step_frequency_i));
            step_enable <= '0';
        else
            count := 0;
            step_enable <= '1';
        end if;
    end if;
end process;


StepperFSM:process(clk_i, rst_i, step_enable, direction_cw_i, half_step_i)
begin
    if (rst_i = '1') then 
        state <= one;
        stepper_o <= ( others => '0' );
    elsif (rising_edge(clk_i) and step_enable = '1') then 
        case state is 
            when one =>
                stepper_o <= "0101";
                if (half_step_i = '0' and direction_cw_i = '0') then 
                    state <= seven;
                elsif (half_step_i = '0' and direction_cw_i = '1') then      
                    state <= three;
                elsif (half_step_i = '1' and direction_cw_i = '0') then      
                    state <= eight;
                else 
                    state <= two;
                end if;
            when two =>
                stepper_o <= "0001";
                if ( direction_cw_i = '0' ) then 
                    state <= one;
                else 
                    state <= three;
                end if;
            when three =>
                stepper_o <= "1001";
                if (half_step_i = '0' and direction_cw_i = '0') then 
                    state <= one;
                elsif (half_step_i = '0' and direction_cw_i = '1') then      
                    state <= five;
                elsif (half_step_i = '1' and direction_cw_i = '0') then      
                    state <= two;
                else 
                    state <= four;
                end if;
            when four =>
                stepper_o <= "1000";
                if ( direction_cw_i = '0' ) then 
                    state <= three;
                else 
                    state <= five;
                end if;
            when five =>
                stepper_o <= "1010";
                if (half_step_i = '0' and direction_cw_i = '0') then 
                    state <= three;
                elsif (half_step_i = '0' and direction_cw_i = '1') then      
                    state <= seven;
                elsif (half_step_i = '1' and direction_cw_i = '0') then      
                    state <= four;
                else 
                    state <= six;
                end if;
            when six =>
                stepper_o <= "0010";
                if ( direction_cw_i = '0' ) then 
                    state <= five;
                else 
                    state <= seven;
                end if;
            when seven =>
                stepper_o <= "0110";
                if (half_step_i = '0' and direction_cw_i = '0') then 
                    state <= five;
                elsif (half_step_i = '0' and direction_cw_i = '1') then      
                    state <= one;
                elsif (half_step_i = '1' and direction_cw_i = '0') then      
                    state <= six;
                else 
                    state <= eight;
                end if;
            when eight =>
                stepper_o <= "0100";
                if ( direction_cw_i = '0' ) then 
                    state <= seven;
                else 
                    state <= one;
                end if;
            when others =>
                stepper_o <= "0000";
        end case;
    end if;              
end process;               
             
end Behavioral;
