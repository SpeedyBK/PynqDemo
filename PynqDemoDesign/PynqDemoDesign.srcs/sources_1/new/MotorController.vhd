----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2020 13:58:38
-- Design Name: 
-- Module Name: MotorController - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MotorController is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_i : in STD_LOGIC;
           direction_cw_i : in STD_LOGIC;
           half_step_mode_i : in STD_LOGIC;
           motor_signals_o : out STD_LOGIC_VECTOR (3 downto 0));
end MotorController;

architecture Behavioral of MotorController is

type state_t is (zero, one, two, three, four, five, six, seven);
signal m_state : state_t := zero;

begin

Motor_Controller:process (clk_i, enable_i, rst_i)
begin
    if (rst_i = '1') then
        m_state <= zero;
        motor_signals_o <= "0000";
    elsif rising_edge (clk_i) then 
        if (enable_i = '1') then 
            case m_state is 
                when zero =>
                    motor_signals_o <= "0101";
                    if (direction_cw_i = '1' and half_step_mode_i = '1') then 
                        m_state <= one;
                    elsif (direction_cw_i = '1' and half_step_mode_i = '0') then 
                        m_state <= two;
                    elsif (direction_cw_i = '0' and half_step_mode_i = '1') then 
                        m_state <= seven;
                    else 
                        m_state <= six;
                    end if;
                when one =>
                    motor_signals_o <= "0001";
                    if (direction_cw_i = '1') then 
                        m_state <= two;
                    else 
                        m_state <= zero;
                    end if;
                when two =>
                    motor_signals_o <= "1001";
                    if (direction_cw_i = '1' and half_step_mode_i = '1') then 
                        m_state <= three;
                    elsif (direction_cw_i = '1' and half_step_mode_i = '0') then 
                        m_state <= four;
                    elsif (direction_cw_i = '0' and half_step_mode_i = '1') then 
                        m_state <= one;
                    else 
                        m_state <= zero;
                    end if;
                when three =>
                    motor_signals_o <= "1000";
                    if (direction_cw_i = '1') then 
                        m_state <= four;
                    else 
                        m_state <= two;
                    end if;         
                when four =>
                    motor_signals_o <= "1010";
                    if (direction_cw_i = '1' and half_step_mode_i = '1') then 
                        m_state <= five;
                    elsif (direction_cw_i = '1' and half_step_mode_i = '0') then 
                        m_state <= six;
                    elsif (direction_cw_i = '0' and half_step_mode_i = '1') then 
                        m_state <= three;
                    else 
                        m_state <= two;
                    end if;
                when five =>
                    motor_signals_o <= "0010";
                    if (direction_cw_i = '1') then 
                        m_state <= six;
                    else 
                        m_state <= four;
                    end if;   
                when six =>
                    motor_signals_o <= "0110";
                    if (direction_cw_i = '1' and half_step_mode_i = '1') then 
                        m_state <= seven;
                    elsif (direction_cw_i = '1' and half_step_mode_i = '0') then 
                        m_state <= zero;
                    elsif (direction_cw_i = '0' and half_step_mode_i = '1') then 
                        m_state <= five;
                    else 
                        m_state <= four;
                    end if;
                when others =>
                    motor_signals_o <= "0100";
                    if (direction_cw_i = '1') then 
                        m_state <= zero;
                    else 
                        m_state <= six;
                    end if;
            end case;
        end if; -- enable
    end if;  -- clk
end process;

end Behavioral;
