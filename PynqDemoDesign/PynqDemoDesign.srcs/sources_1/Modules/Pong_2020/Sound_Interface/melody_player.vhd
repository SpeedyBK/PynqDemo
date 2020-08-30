----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik 
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 22.07.2020 13:47:13
-- Design Name: Melody-Player
-- Module Name: melody_player - Behavioral
-- Project Name: Pong-Sound interface.
-- Target Devices: Pynq Board
-- Tool Versions: 
-- Description: Instantiation
-- 
-- Dependencies: 
-- 
-- Revision:
-- 08/2020 Revision 1.0 - Initial Version
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

entity melody_player is
    generic ( song : song_type := background_melody );
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           note_ena_i : in STD_LOGIC;
           dds_ena_i : in std_logic;
           clear_o : out std_logic;
           audio_o : out std_logic_vector(AMPL_WIDTH-1 downto 0));
end melody_player;

architecture Behavioral of melody_player is

signal address : std_logic_vector (ADDR_WIDTH-1 downto 0);
signal clear : std_logic;
signal duration : std_logic_vector (DURA_WIDTH-1 downto 0);
signal vol : std_logic_vector (VOL_WIDTH-1 downto 0);
signal note : std_logic_vector (NOTE_WIDTH-1 downto 0);
signal wave_type : std_logic_vector(TYPE_WIDTH-1 downto 0);

begin

-- Der von den Studierenden zu entwickelnde Adressengenerator wird eingebunden.
ADDRESSGENERATOR : entity work.address_generator
port map ( clk_i => clk_i,
           rst_i => rst_i,
           note_ena_i => note_ena_i,
           clear_i => clear,
           duration_i => duration,
           address_o => address );
           
-- Dieses Modul liest die unter der Adresse im sound_p package hinterlegten Daten und 
-- teil den im sound_p hinterlegten Record Datentyp auf einzelne std_logic_vector auf.          
MELODIE : entity work.melody_table
generic map ( song => song )
port map ( address_i => address,
		   clear_o => clear,
           note_o => note,
		   vol_o => vol,
		   wave_type_o => wave_type,
           duration_o => duration );
           
-- Dieses Modul beinhaltet den Synthesizer
DigitalDirectSynthesizer: entity work.Synthesizer
port map ( clk_i => clk_i,
           dds_ena_i => dds_ena_i, 
           reset_i => rst_i,
           note_i => note,
           vol_i => vol,
           wave_type_i => wave_type,
           ampl_o => audio_o);

clear_o <= clear;

end Behavioral;
