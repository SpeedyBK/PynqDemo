----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik 
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 02.08.2020 21:08:29
-- Design Name: Enable-Signal Generator
-- Module Name: EnableGenerator - Behavioral
-- Project Name: Pong - Sound Interface
-- Target Devices: Pynq Board
-- Tool Versions: 
-- Description: This Module takes the systemclock of our Pong-Game and generates
--              enable signals for the devices used in the Sound interface. 
--              - The first signal (DDS_ena) controlles the DDS-Device. This has to be 92kHz,
--                in order to keep the right frequency for each note that is synthesized
--                changing this frequency would change the frequency of each note. For example
--                an 'a' would be played at 450Hz instead of 440Hz if this frequency is increased. 
--              - The Note_ena signal controlles the Note-Address Counter. If the frequency is
--              - increased, the song will be played faster. 
-- 
-- Dependencies: None
-- 
-- Revision: 
-- 07/2020: Revision 1.0 - Initial Version BLK
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

entity EnableGenerator is
    generic (f_in : integer := 125000000;      -- Pynq Board Clock Freq.
             DDS_divider : integer := 92000;   -- DDS Clock: 92 kHz --> From old Design, to keep the old FTW table.  
             Note_divider: integer := 4);      -- Note Clock: As you like, something between 4 and 10 hz, should be a 
    Port ( clk_i : in STD_LOGIC;               -- starting point to play arround with this clock a bit and figue out the 
           rst_i : in STD_LOGIC;               -- effects.
           note_ena_o : out STD_LOGIC;
           dds_ena_o : out STD_LOGIC);
end EnableGenerator;

architecture Behavioral of EnableGenerator is

begin

DDS : process (clk_i, rst_i)
variable count : integer := 0;
begin 
    if (rst_i = '1') then 
        count := 0; 
    elsif rising_edge(clk_i) then 
        if (count < f_in) then 
            count := count + DDS_divider;
            dds_ena_o <= '0';
        else 
            count := 0;
            dds_ena_o <= '1';
        end if;
    end if;
end process;

Note : process (clk_i, rst_i)
variable count : integer := 0;
begin 
    if (rst_i = '1') then 
        count := 0; 
    elsif rising_edge(clk_i) then 
        if (count < f_in) then 
            count := count + Note_divider;
            note_ena_o <= '0';
        else 
            count := 0;
            note_ena_o <= '1';
        end if;
    end if;
end process;

end Behavioral;
