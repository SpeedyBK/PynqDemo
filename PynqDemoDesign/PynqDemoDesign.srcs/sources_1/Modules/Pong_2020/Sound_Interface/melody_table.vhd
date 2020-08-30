--------------------------------------------------------------------------------
-- Title          : Pong Melodietabelle
-- Filename       : melody_table.vhd
-- Project        : 6. �bungsblatt VHDL-Kurs (Pong-Spiel)
--------------------------------------------------------------------------------
-- Author         : Michael Kunz
-- Company        : Universit�t Kassel, FG Digitaltechnik
-- Date           : 23.06.2010
-- Language       : VHDL93
-- Synthesis      : No
-- Target Family  : sound_interface.vhd
-- Test Status    : !!! not released !!!
--------------------------------------------------------------------------------
-- Applicable Documents:
-- 
--
--------------------------------------------------------------------------------
-- Revision History:
-- Date        Version  Author   Description
-- 23.06.2010   1.0     MK       Created
-- 18.08.2014	2.0		MK		 Generic Song
-- 22.07.2020   3.0     BLK      Included Sound Package
--------------------------------------------------------------------------------
-- Description:
--
-- Dieses Modul stellt eine Tabelle mit der Melodie zur Soudausgabe des 
-- Pong-Spiels bereit, welches von den Studierenden des VHDL-Kurses entwickelt 
-- werden soll. Das Modul bekommt als Eingang eine Adresse vom Adressgenerator
-- und liest dann die Daten, die im Sound_p Package in den Songarrays unter der
-- Adresse hinterlegt sind. Zudem wird am Ende eines Songs ein Clear-Signal 
-- erzeugt. 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.sound_p.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity melody_table is
   GENERIC( song	: song_type);
   PORT( address_i : in   STD_LOGIC_VECTOR (7 downto 0);
		 clear_o : out  std_logic;
         note_o  : out  STD_LOGIC_VECTOR (5 downto 0);
		 vol_o : out  STD_LOGIC_VECTOR (VOL_WIDTH-1 downto 0);
         wave_type_o : out std_logic_vector(TYPE_WIDTH-1 downto 0);
         duration_o : out  STD_LOGIC_VECTOR (1 downto 0));
end melody_table;

architecture Behavioral of melody_table is

	signal ton : note_type;
	signal ton2 : note_type;

begin

-- CONCURRENT -----------------------------------------------------------------

	ton <= song(to_integer(unsigned(address_i)));
	ton2 <= song(to_integer(unsigned(address_i)-1));
	
	note_o <= ton2.hoehe;
	vol_o  <= ton2.vol;
	duration_o <= ton.wert;
	wave_type_o <= ton2.typ;
	
	clear_o <= '1' when (ton2.hoehe = "000000" and ton2.vol = "000" and ton.wert = "00") else '0';

end Behavioral;

