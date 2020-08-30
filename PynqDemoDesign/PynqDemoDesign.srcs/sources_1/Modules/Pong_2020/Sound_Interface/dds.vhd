----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik 
-- Engineer: ??
-- 
-- Create Date:    15:02:32 12/21/2009 
-- Design Name: Synthesizer
-- Module Name: dds - Behavioral 
-- Project Name: Pong-Soundinterface. 
-- Target Devices: Pynq Board
-- Tool versions: 
-- Description: This DDS-Based Synthesiser used to translate the notes to a Pulse-Code-Modulated 
--              Waveform which can be passed to the Digital-to-Analog-Converter. 
--              The synthesize-process is devided in 3 parts. 
--              - 1. Tuning Table:
--              The tuning table takes a note and looks up the corresonding FTW (Frequency Tuning Word)
--              in a big look-up table.
--              - 2. Direct Digital Synthesis (DDS)
--              The DDS takes samples from a look-up tables. These look-up tables contain serveral Wave-
--              forms (for now just Sine- and Triangular- Waveforms are implemented). 
--              - 3. Volume Controller
--              The samples from the from the DDS are passed into the volume controller. If we have to decrease
--              the volume we can shift the PCM-Signal to the right by 1, 2, 3, 4, 5 or 6 bits to the right.  
--              This right-shifts are divisions by 2, 4, 8, 16, 32 or 64. Example 16 >> 2 = 16/4 = 4;
--              Keep in mind, the PCM-Signal can be negative as well. 
--
-- Dependencies: 
--
-- Revision: 
-- 12/2009 Revision 1.0 - Initial Version MK
-- 08/2020 Revision 2.0 - Moved the Volume Controller inside the Synthesizer and 
--                        increased the number of dynamik steps to 8.
--                      - Added triangular wave to get more Sound Options.
--                      - Combined several packages in the Sound_p - Package.
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.dds_synthesizer_pkg.all;
use work.sine_lut_pkg.all;
use work.triangle_lut_pkg.all;
use work.sound_p.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Synthesizer is
    Port ( clk_i : in STD_LOGIC;
           dds_ena_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
           note_i : in  STD_LOGIC_VECTOR (NOTE_WIDTH-1 downto 0);
           vol_i : in std_logic_vector(VOL_WIDTH-1 downto 0);
           wave_type_i : in std_logic_vector (1 downto 0);
           ampl_o : out  STD_LOGIC_VECTOR (AMPL_WIDTH-1 downto 0));
end Synthesizer;

architecture arch of Synthesizer is

  signal ampl_tmp, ampl_tmp_pause  : std_logic_vector(AMPL_WIDTH-1 downto 0);
  signal ftw : std_logic_vector (FTW_WIDTH-1 downto 0);

begin

------------------
-- Tuning Table --
------------------

tuning_table : entity work.tuning_table
port map (note0_i => note_i(0),
          note1_i => note_i(1),
          note2_i => note_i(2),
          note3_i => note_i(3),
		  note4_i => note_i(4),
		  note5_i => note_i(5),
          ftw_o	 => ftw);

---------
-- DDS --
---------

dds_synth: dds_synthesizer
  generic map(
		ftw_width   => 32
  )
  port map(
		clk_i => clk_i,
		dds_ena_i => dds_ena_i,
		rst_i => reset_i,
		ftw_i    => ftw,
		phase_i  => (others => '0'),
		wave_type_i => wave_type_i,
		phase_o  => open,
		ampl_o => ampl_tmp
  );
  
--------------------
-- Volume Control --
-------------------- 
with vol_i select 
ampl_tmp_pause <= ampl_tmp when "111",
          std_logic_vector(shift_right(signed(ampl_tmp), 1)) when "110",
          std_logic_vector(shift_right(signed(ampl_tmp), 2)) when "101",
          std_logic_vector(shift_right(signed(ampl_tmp), 3)) when "100",
          std_logic_vector(shift_right(signed(ampl_tmp), 4)) when "011",
          std_logic_vector(shift_right(signed(ampl_tmp), 5)) when "010",
          std_logic_vector(shift_right(signed(ampl_tmp), 6)) when "001",
          (others => '0') when others;

-- Mute when there is a pause.
with note_i select 
ampl_o <= "10000000" when "111111",
           ampl_tmp_pause when others;

  
end arch;

