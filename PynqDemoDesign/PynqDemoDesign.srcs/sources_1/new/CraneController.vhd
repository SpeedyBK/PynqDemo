----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2020 18:40:33
-- Design Name: 
-- Module Name: CraneController - Behavioral
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

entity CraneController is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           start_i : in STD_LOGIC;
           motor_signals_o : out STD_LOGIC_VECTOR (3 downto 0);
           blue_leds_o : out std_logic_vector(6 downto 0);
           magnet_o : out std_logic);
end CraneController;

architecture Behavioral of CraneController is

component MotorController is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_i : in STD_LOGIC;
           direction_cw_i : in STD_LOGIC;
           half_step_mode_i : in STD_LOGIC;
           motor_signals_o : out STD_LOGIC_VECTOR (3 downto 0));
end component;

type state_t is (waiting, magnetOn, moving, magnetOff);
signal kstate : state_t := waiting; 

signal direction : std_logic := '1';
signal half_step : std_logic := '1';
signal step_enable : std_logic := '0';
signal count : integer;

begin

CraneControll: process(clk_i, rst_i)
variable speed: integer range 0 to 255 := 40;
variable delay: integer range 0 to 250000000 := 0;
variable f : integer range 0 to 125000000 := 0;
variable step_count : integer range 0 to 255; 
begin
    if (rst_i = '1') then 
        kstate <= waiting;
        speed := 0; 
        delay := 0;
        direction <= '1';
    elsif rising_edge (clk_i) then 
        case kstate is 
            when waiting =>
                blue_leds_o <= not "0000001";
                speed := 0;
                delay := 0;
                magnet_o <= '0';
                if (start_i = '1') then 
                    kstate <= magnetOn;
                else 
                    kstate <= waiting;
                end if;
            when magnetOn =>
                blue_leds_o <= not "0000010";
                speed := 0;
                step_count := 0;
                magnet_o <= '1';
                direction <= '1';
                if (delay < 250000000) then 
                    delay := delay + 1;
                    kstate <= magnetOn;
                else 
                    delay := 0;
                    kstate <= moving;
                    speed := 40;
                end if;
            when moving =>
                blue_leds_o <= not "0000100";
                if (step_count < 30 and step_enable = '1') then
                    -- Speed Up
                    speed := speed + 2;
                elsif (step_count < 170 and step_enable = '1') then
                    -- Constant Speed
                    speed := 100;
                elsif (step_count < 200 and step_enable = '1') then
                    -- Speed Down
                    speed := speed - 2;
                elsif (step_count = 200 and step_enable = '1') then
                    -- End Position
                    if (direction = '1') then 
                        kstate <= magnetOff;
                    else 
                        kstate <= waiting;
                    end if;
                end if;
                if (f < 125000000) then 
                    f := f + speed;
                    step_enable <= '0';
                else 
                    f := 0;
                    step_enable <= '1';
                    step_count := step_count + 1; 
                end if;
                count <= step_count;
            when others =>
                blue_leds_o <= not "0001000";
                speed := 0;
                f := 0;
                step_count := 0;
                direction <= '0';
                magnet_o <= '1';
                if (delay < 250000000) then 
                    delay := delay + 1;
                elsif (delay = 125000000) then 
                    delay := delay + 1;
                    magnet_o <= '0';
                else
                    delay := 0;
                    speed := 40;
                    kstate <= moving;
                end if;
        end case;
   end if;
end process;        

MController : MotorController
port map ( clk_i => clk_i,
           rst_i => rst_i,
           enable_i => step_enable,
           direction_cw_i => direction,
           half_step_mode_i => half_step,
           motor_signals_o => motor_signals_o);


end Behavioral;
