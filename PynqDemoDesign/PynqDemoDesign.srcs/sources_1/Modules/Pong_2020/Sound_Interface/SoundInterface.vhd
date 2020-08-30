----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 02.08.2020 20:36:33
-- Design Name: Soundinterface
-- Module Name: SoundInterface - Behavioral
-- Project Name: Pong
-- Target Devices: Pynq Board 
-- Tool Versions: 
-- Description: Top Level Component of the Sound Interface for our Pong Game.
-- Benoetigte Packages:
-- sound_p.vhd: Dieses Package nimmt eine zentrale rolle ein und definiert Wortbreiten und Signale
--              Zudem sind die Melodien in diesem Package gespeichert.  
-- sine_lut_8x8.vhd: Dieses Package beinhaltet die im Digital Direct Synthesizer verwendete Look-up
--                   eines Quadranten eines "8-Bit Sinus-Signals".
-- triangle_lut_8x8.vhd: Dieses Package beinhaltet die im Digital Direct Synthesizer verwendete Look-up
--                   eines Quadranten eines "8-Bit Dreieck-Signales".
-- square_lut_8x8.vhd: Dieses Package beinhaltet die im Digital Direct Synthesizer verwendete Look-up
--                   eines Quadranten eines "8-Bit Rechteck Signals". -- Funktioniert noch nicht.
--
-- Dependencies: 
-- 
-- Revision:
-- 08/2020: Revision 1.0 - Initial Version BLK
-- Additional Comments: 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sound_p.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SoundInterface is
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           -- Inputs 
           hit_wall_i : in std_logic_vector(2 downto 0);
           hit_racket_l_i : in std_logic_vector(1 downto 0);
           hit_racket_r_i : in std_logic_vector(1 downto 0);
           game_over_i : in std_logic;
           push_but1_deb_i : in std_logic;
           push_but2_deb_i : in std_logic;
           -- Debug:
           debug_o : out std_logic_vector (3 downto 0);
           deb_clr_o : out std_logic_vector (5 downto 0);
           -- Outputs
           audio_pwm_o : out STD_LOGIC;
           audio_sd_o : out STD_LOGIC);
end SoundInterface;

architecture Behavioral of SoundInterface is

-- Clock Enable Generator
component EnableGenerator is
    generic (f_in : integer := 125000000;    -- Pynq Board Clock Freq.
             DDS_divider : integer := 92000; -- DDS Clock: 92 kHz --> From old Design, to keep the old FTW table.
             Note_divider: integer := 16);   -- Note Clock: 16 Hz
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           note_ena_o : out STD_LOGIC;
           dds_ena_o : out STD_LOGIC);
end component;

-- Controll FSM:
component SoundActivator is
Port (clk_i : in std_logic;
      reset_i : in std_logic;
      -- Collision Signals
      hit_wall_i : in std_logic_vector(2 downto 0);
      hit_racket_l_i : in std_logic_vector(1 downto 0);
      hit_racket_r_i : in std_logic_vector(1 downto 0);
      -- Game Over Signal
      game_over_i : in std_logic;
      -- Signals to restart game
      push_but1_deb_i : in std_logic;
      push_but2_deb_i : in std_logic;
      -- Clear Signals from Melodie Players:
      bg_clr : in std_logic;
      bg_bass_clr : in std_logic;
      looser_clr : in std_logic;
      wall_clr : in std_logic;
      racket_clr : in std_logic;
      out_clr : in std_logic;
      -- Reset Signals to stop individual Melodie Players.
      bg_rst_o : out std_logic; 
      bg_bass_rst_o : out std_logic;
      looser_rst_o : out std_logic;
      wall_rst_o : out std_logic;
      racket_rst_o : out std_logic;
      out_rst_o : out std_logic; 
      -- Debug
      debug_o :out std_logic_vector (3 downto 0));
end component;

-- DAC
component PWM_Modulator is
    Port ( clk_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           ampl_i : in STD_LOGIC_VECTOR (10 downto 0);
           PWM_o : out STD_LOGIC;
           aud_en_o : out STD_LOGIC);
end component;

-- Melodie Player
component melody_player is
    generic ( song : song_type := background_melody );
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           note_ena_i : in STD_LOGIC;
           dds_ena_i : in std_logic;
           clear_o : out std_logic;
           audio_o : out std_logic_vector(AMPL_WIDTH-1 downto 0));
end component;

-- Signal Type, that combines all signals between the Controll_FSM
-- and the Melodie Players (Defined in sound_p.vhd):
signal audio : audio_t;

-- Enable Signals
signal note_ena, dds_ena : std_logic;

-- Sum of outputs from the Melodie-Players (Can be MAX: 6*127 or MIM: 6*-128, so 11 Bit needed.)
signal audio_ges : std_logic_vector (10 downto 0);

begin

Enable : EnableGenerator
generic map (f_in => 125000000,
             DDS_divider => 92000,   -- DDS Clock: 92 kHz --> From old Design, to keep the old FTW table.  
             Note_divider => 16)
Port map ( clk_i => clock_i,
           rst_i => reset_i,
           note_ena_o => note_ena,
           dds_ena_o => dds_ena);

Activator: SoundActivator
port map (clk_i => clock_i,
          reset_i => reset_i,
          -- Collision Signals
          hit_wall_i => hit_wall_i,
          hit_racket_l_i => hit_racket_l_i,
          hit_racket_r_i => hit_racket_r_i,
          -- Game Over Signal
          game_over_i => game_over_i,
          push_but1_deb_i => push_but1_deb_i,
          push_but2_deb_i => push_but2_deb_i, 
          -- Clear Signals from Melodie Players
          bg_clr => audio.bg_clr,
          bg_bass_clr => audio.bg_bass_clr,
          looser_clr => audio.looser_clr,
          wall_clr => audio.hit_wall_clr,
          racket_clr => audio.hit_racket_clr,
          out_clr => audio.hit_out_clr,
          -- Reset Signals to stop individual Melodie Players
          bg_rst_o => audio.bg_rst,
          bg_bass_rst_o => audio.bg_bass_rst,
          looser_rst_o => audio.looser_rst,
          wall_rst_o => audio.hit_wall_rst,
          racket_rst_o => audio.hit_racket_rst,
          out_rst_o => audio.hit_out_rst,
          -- Debug
          debug_o => debug_o);

Melody : melody_player
generic map ( song => popcorn)
port map ( clk_i => clock_i,
           rst_i => audio.bg_rst,
           note_ena_i => note_ena,
           dds_ena_i => dds_ena,
           clear_o => audio.bg_clr,
           audio_o => audio.bg);

Melody_bass : melody_player
generic map ( song => popcorn_bass)
port map ( clk_i => clock_i,
           rst_i => audio.bg_bass_rst,
           note_ena_i => note_ena,
           dds_ena_i => dds_ena,
           clear_o => audio.bg_bass_clr,
           audio_o => audio.bg_bass);
           
Melody_out : melody_player
generic map (song => hit_out)
port map ( clk_i => clock_i,
           rst_i => audio.hit_out_rst,
           note_ena_i => note_ena,
           dds_ena_i => dds_ena,
           clear_o => audio.hit_out_clr,
           audio_o => audio.hit_out);    
           
Melody_racket : melody_player
generic map (song => hit_racket)
port map ( clk_i => clock_i,
           rst_i => audio.hit_racket_rst,
           note_ena_i => note_ena,
           dds_ena_i => dds_ena,
           clear_o => audio.hit_racket_clr,
           audio_o => audio.hit_racket);    
           
Melody_wall : melody_player
generic map (song => hit_wall)
port map ( clk_i => clock_i,
           rst_i => audio.hit_wall_rst,
           note_ena_i => note_ena,
           dds_ena_i => dds_ena,
           clear_o => audio.hit_wall_clr,
           audio_o => audio.hit_wall);    

Melody_looser : melody_player
generic map (song => looser)
port map ( clk_i => clock_i,
           rst_i => audio.looser_rst,
           note_ena_i => note_ena,
           dds_ena_i => dds_ena,
           clear_o => audio.looser_clr,
           audio_o => audio.looser);    

-- Adding up all audio signals.        
audio_ges <= std_logic_vector(resize(signed(audio.bg), audio_ges'length) + 
                              resize(signed(audio.bg_bass), audio_ges'length) + 
                              resize(signed(audio.hit_out), audio_ges'length) +
                              resize(signed(audio.hit_wall), audio_ges'length) + 
                              resize(signed(audio.hit_racket), audio_ges'length) + 
                              resize(signed(audio.looser), audio_ges'length));

DAC : PWM_Modulator
port map ( clk_i => clock_i,
           reset_i => reset_i,
           ampl_i => audio_ges,
           PWM_o => audio_pwm_o,
           aud_en_o => audio_sd_o);
           
-- Debugging:           
deb_clr_o(5) <= not audio.bg_clr;
deb_clr_o(4) <= not audio.bg_bass_clr;
deb_clr_o(3) <= not audio.hit_out_clr;
deb_clr_o(2) <= not audio.hit_racket_clr;
deb_clr_o(1) <= not audio.hit_wall_clr;
deb_clr_o(0) <= not audio.looser_clr;

end Behavioral;
