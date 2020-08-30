----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik 
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 22.07.2020 19:37:20
-- Design Name: Sound_p
-- Module Name: sound_p - Behavioral
-- Project Name: Pong Sound-Interface
-- Target Devices: Pynq Board
-- Tool Versions: 
-- Description: Dieses Package stellt die Datentypen, Konstanten und Wortbreiten, die im 
-- Sound-Interface verwendet werden zur Verfügung. 
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

package sound_p is

-----------------
-- Wortbreiten --
-----------------
constant AMPL_WIDTH  : integer := 8;
constant VOL_WIDTH   : integer := 3;
constant ADDR_WIDTH  : integer := 8;
constant NOTE_WIDTH  : integer := 6;
constant DURA_WIDTH  : integer := 2;
constant PHASE_WIDTH : integer := 8;
constant FTW_WIDTH : integer := 32;
constant TYPE_WIDTH : integer := 2;

---------------------------
-- Datentypen definieren --
---------------------------
--Als Datentyp für eine Note wird "Record" gewählt. "Record" ist eine Art Container, der aus 
--mehreren beliebigen Datentypen zusammen gesetzt werden kann. Eine Note besteht somit aus 3 Elementen
--vom Typ std_logic_vector. Der Tonhöhe, der Tondauer und der Tonlautstärke.
type note_type is record
    hoehe : std_logic_vector(5 downto 0);
	wert  : std_logic_vector(1 downto 0);
	vol	  : std_logic_vector(VOL_WIDTH-1 downto 0);
	typ   : std_logic_vector(TYPE_WIDTH-1 downto 0);
end record;

--In einem Song können bis zu 255 Noten zu einem Array zusammengefasst werden.
type song_type is array(0 to 255) of note_type;

-- Zusammenfassung der im Top Level benoetigten Signale
type audio_t is record
    bg : std_logic_vector (7 downto 0);
    bg_bass : std_logic_vector (7 downto 0);
    looser : std_logic_vector (7 downto 0);
    hit_out : std_logic_vector (7 downto 0);
    hit_racket : std_logic_vector (7 downto 0);
    hit_wall : std_logic_vector (7 downto 0);
    
    bg_clr : std_logic;
    bg_bass_clr : std_logic;
    looser_clr : std_logic;
    hit_out_clr : std_logic;
    hit_racket_clr : std_logic;
    hit_wall_clr : std_logic;
    
    bg_rst : std_logic;
    bg_bass_rst : std_logic;
    looser_rst : std_logic;
    hit_out_rst : std_logic;
    hit_racket_rst : std_logic;
    hit_wall_rst : std_logic;
end record;

-----------
-- Noten --
-----------
--Im folgenden werden die Notenelemente definiert und benannt.

--Notennamen:

	constant a_2	: std_logic_vector := "000000";
	constant ais_2	: std_logic_vector := "000001"; alias b_2		: std_logic_vector(5 downto 0) is ais_2;
	constant h_2	: std_logic_vector := "000010";
	constant c_1	: std_logic_vector := "000011";
	constant cis_1	: std_logic_vector := "000100"; alias des_1	: std_logic_vector(5 downto 0) is cis_1;
	constant d_1	: std_logic_vector := "000101";
	constant dis_1	: std_logic_vector := "000110"; alias es_1	: std_logic_vector(5 downto 0) is dis_1;
	constant e_1	: std_logic_vector := "000111";
	constant f_1	: std_logic_vector := "001000";
	constant fis_1	: std_logic_vector := "001001"; alias ges_1	: std_logic_vector(5 downto 0) is fis_1;
	constant g_1	: std_logic_vector := "001010";
	constant gis_1	: std_logic_vector := "001011"; alias as_1	: std_logic_vector(5 downto 0) is gis_1;
	constant a_1	: std_logic_vector := "001100";
	constant ais_1	: std_logic_vector := "001101"; alias b_1		: std_logic_vector(5 downto 0) is ais_1; 
	constant h_1	: std_logic_vector := "001110";
	constant c0		: std_logic_vector := "001111";                                         
	constant cis0	: std_logic_vector := "010000"; alias des0		: std_logic_vector(5 downto 0) is cis0;
	constant d0		: std_logic_vector := "010001";                                         
	constant dis0	: std_logic_vector := "010010"; alias es0		: std_logic_vector(5 downto 0) is dis0;
	constant e0		: std_logic_vector := "010011";                                         
	constant f0		: std_logic_vector := "010100";                                         
	constant fis0	: std_logic_vector := "010101"; alias ges0		: std_logic_vector(5 downto 0) is fis0;
	constant g0		: std_logic_vector := "010110";                                         
	constant gis0	: std_logic_vector := "010111"; alias as0		: std_logic_vector(5 downto 0) is gis0;
	constant a0		: std_logic_vector := "011000";                                         
	constant ais0	: std_logic_vector := "011001"; alias b0		: std_logic_vector(5 downto 0) is ais0;
	constant h0		: std_logic_vector := "011010";                                         
	constant c1		: std_logic_vector := "011011";                                         
	constant cis1	: std_logic_vector := "011100"; alias des1	: std_logic_vector(5 downto 0) is cis1;
	constant d1		: std_logic_vector := "011101";                                         
	constant dis1	: std_logic_vector := "011110"; alias es1		: std_logic_vector(5 downto 0) is dis1;
	constant e1		: std_logic_vector := "011111";                                         
	constant f1		: std_logic_vector := "100000";                                         
	constant fis1	: std_logic_vector := "100001"; alias ges1	: std_logic_vector(5 downto 0) is fis1;
	constant g1		: std_logic_vector := "100010";                                         
	constant gis1	: std_logic_vector := "100011"; alias as1		: std_logic_vector(5 downto 0) is gis1;
	constant a1		: std_logic_vector := "100100";                                         
	constant ais1	: std_logic_vector := "100101"; alias b1		: std_logic_vector(5 downto 0) is ais1;
	constant h1		: std_logic_vector := "100110";                                         
	constant c2		: std_logic_vector := "100111";                                         
	constant cis2	: std_logic_vector := "101000"; alias des2	: std_logic_vector(5 downto 0) is cis2;
	constant d2		: std_logic_vector := "101001";                                         
	constant dis2	: std_logic_vector := "101010"; alias es2		: std_logic_vector(5 downto 0) is dis2;
	constant e2		: std_logic_vector := "101011";                                         
	constant f2		: std_logic_vector := "101100";                                         
	constant fis2	: std_logic_vector := "101101"; alias ges2	: std_logic_vector(5 downto 0) is fis2;
	constant g2		: std_logic_vector := "101110";                                         
	constant gis2	: std_logic_vector := "101111"; alias as2		: std_logic_vector(5 downto 0) is gis2;
	constant a2		: std_logic_vector := "110000";                                         
	constant ais2	: std_logic_vector := "110001"; alias b2		: std_logic_vector(5 downto 0) is ais2;
	constant h2		: std_logic_vector := "110010";                                         
	constant c3		: std_logic_vector := "110011";                                         
	constant cis3	: std_logic_vector := "110100"; alias des3	: std_logic_vector(5 downto 0) is cis3;
	constant d3		: std_logic_vector := "110101";                                         
	constant dis3	: std_logic_vector := "110110"; alias es3		: std_logic_vector(5 downto 0) is dis3;
	constant e3		: std_logic_vector := "110111";                                         
	constant f3		: std_logic_vector := "111000";                                         
	constant fis3	: std_logic_vector := "111001"; alias ges3	: std_logic_vector(5 downto 0) is fis3;
	constant g3		: std_logic_vector := "111010";                                         
	constant gis3	: std_logic_vector := "111011"; alias as3		: std_logic_vector(5 downto 0) is gis3;
	constant a3		: std_logic_vector := "111100";                                         
	constant ais3	: std_logic_vector := "111101"; alias b3		: std_logic_vector(5 downto 0) is ais3;
	constant h3		: std_logic_vector := "111110";                                         
	constant pause	: std_logic_vector := "111111";
	
	constant res	: std_logic_vector := "000000"; 

--Notenwerte
	constant v		: std_logic_vector := "11";		-- viertel
	constant a		: std_logic_vector := "10";		-- achtel
	constant s		: std_logic_vector := "01";		-- sechzentel
	constant z		: std_logic_vector := "00";		-- zweiunddreissigstel

--Dynamik
	constant o		: std_logic_vector := "000";		-- off
	constant p		: std_logic_vector := "001";		-- von piano (leise)
	constant mp		: std_logic_vector := "010";		-- 
	constant mmp	: std_logic_vector := "011";		-- 
	constant m		: std_logic_vector := "100";		-- bis
	constant mmf	: std_logic_vector := "101";		-- 
	constant mf		: std_logic_vector := "110";		-- 
	constant f		: std_logic_vector := "111";	    -- forte (laut).

--Wave Type
    constant sin : std_logic_vector := "00"; -- Note wird als Sinus-Schwingung wiedergegeben.
    constant sqr : std_logic_vector := "01"; -- Funktioniert noch nicht.
    constant tri : std_logic_vector := "10"; -- Note wird als Dreieck-Schwingung wiedergegeben.
    constant platzhalter: std_logic_vector := "11";

--------------------------------
-- Noten zu Songs kombinieren --
--------------------------------
--Die vorher beschrieben Song-Arrays werden mit Noten gefüllt, in dem die oben beschriebenen 
--Konstanten zugewiesen werden. (Tonhöhe, Tondauer, Tonlautstärke, Wellenform).
	constant hit_racket : song_type := (
		(a1, z, f, sin),
		(res, z, o, sin),
		others => (res, z, o, sin)
		);

	constant hit_wall : song_type := (
		(f2, z, f, sin),
		(res, z, o, sin),
		others => (res, z, o, sin)
		);

	constant hit_out : song_type := (
		(f1, a, f, sin),
		(a_2, a, f, sin),
		(a_2, a, f, sin),
		(res, z, o, sin),
		others => (res, z, o, sin)
		);

	constant looser : song_type := (
		(a0, a, f, sin),
		(d0, v, f, sin),
		(d0, v, f, sin),
		(pause, a, f, sin),
		--(d0, v, f),
		--(pause, z, f),
		(d0, z, f, sin),
		(e0, v, f, sin),
		(d0, v, f, sin),
		(d0, v, f, sin),
		(fis0, v, f, sin),
		(g0, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(pause, v, f, sin),
		(res, z, o, sin),
		others => (res, z, o, sin)
		);
	
	-- So eine art Tetris Cover.	
	constant background_melody : song_type := (
		-- erster Takt
		(e2,v,f, sin),
		(h1,a,f, sin),
		(c2,a,f, sin),
		(d2,a,f, sin),
		(e2,s,f, sin),
		(d2,s,f, sin),
		(c2,a,f, sin),
		(h1,a,f, sin),

		-- zweiter Takt
		(a1,v,f, sin),
		(a1,a,f, sin),
		(c2,a,f, sin),
		(e2,v,f, sin),
		(d2,a,f, sin),
		(c2,a,f, sin),

		-- dritter Takt
		(h1,a,f, sin),
		(e1,a,f, sin),
		(gis1,a,f, sin),
		(c2,a,f, sin),
		(d2,v,f, sin),
		(e2,v,f, sin),

		-- vierter Takt
		(c2,v,f, sin),
		(a1,v,f, sin),
		(a1,v,f, sin),
		(h_1,a,m, sin),-- Bass-Toene
		(c0,a,m, sin), -- Bass-Toene


		-- fuenfter Takt
		(d0,a,m, sin), -- Bass-Toene
		(d2,v,f, sin),
		(f2,a,f, sin),
		(a2,v,f, sin),
		(g2,a,f, sin),
		(f2,a,f, sin),

		-- sechster Takt
		(e2,v,f, sin),
		(e2,a,f, sin),
		(c2,a,f, sin),
		(e2,v,f, sin),
		(d2,a,f, sin),
		(c2,a,f, sin),

		-- siebter Takt
		(h1,v,f, sin),
		(h1,a,f, sin),
		(c2,a,f, sin),
		(d2,v,f, sin),
		(e2,v,f, sin),

		-- achter Takt
		(c2,v,f, sin),
		(a1,v,f, sin),
		(a1,v,f, sin),
		(pause,v,f, sin),


		-- Wiederholung der ersten acht Takte

		-- erster Takt
		(e2,v,f, sin),
		(h1,a,f, sin),
		(c2,a,f, sin),
		(d2,a,f, sin),
		(e2,s,f, sin),
		(d2,s,f, sin),
		(c2,a,f, sin),
		(h1,a,f, sin),

		-- zweiter Takt
		(a1,v,f, sin),
		(a1,a,f, sin),
		(c2,a,f, sin),
		(e2,v,f, sin),
		(d2,a,f, sin),
		(c2,a,f, sin),

		-- dritter Takt
		(h1,a,f, sin),
		(e1,a,f, sin),
		(gis1,a,f, sin),
		(c2,a,f, sin),
		(d2,v,f, sin),
		(e2,v,f, sin),

		-- vierter Takt
		(c2,v,f, sin),
		(a1,v,f, sin),
		(a1,v,f, sin),
		(h_1,a,m, sin),-- Bass-Toene
		(c0,a,m, sin), -- Bass-Toene

		-- fuenfter Takt
		(d0,a,m, sin), -- Bass-Toene
		(d2,v,f, sin),
		(f2,a,f, sin),
		(a2,v,f, sin),
		(g2,a,f, sin),
		(f2,a,f, sin),

		-- sechster Takt
		(e2,v,f, sin),
		(e2,a,f, sin),
		(c2,a,f, sin),
		(e2,v,f, sin),
		(d2,a,f, sin),
		(c2,a,f, sin),

		-- siebter Takt
		(h1,v,f, sin),
		(h1,a,f, sin),
		(c2,a,f, sin),
		(d2,v,f, sin),
		(e2,v,f, sin),

		-- achter Takt
		(c2,v,f, sin),
		(a1,v,f, sin),
		(a1,v,f, sin),
		(pause,v,f, sin),


		-- zweiter Teil

		-- neunter Takt
		(e1,v,m, sin),
		(e1,v,m, sin),
		(c1,v,m, sin),
		(c1,v,m, sin),

		-- zehnter Takt
		(d1,v,m, sin),
		(d1,v,m, sin),
		(h0,v,m, sin),
		(h0,v,m, sin),

		-- elfter Takt
		(c1,v,m, sin),
		(c1,v,m, sin),
		(a0,v,m, sin),
		(a0,v,m, sin),

		-- zwoelfter Takt
		(gis0,v,m, sin),
		(gis0,v,m, sin),
		(h0,v,m, sin),
		(h0,v,m, sin),

		-- dreizehnter Takt
		(e1,v,m, sin),
		(e1,v,m, sin),
		(c1,v,m, sin),
		(c1,v,m, sin),

		-- vierzehnter Takt
		(d1,v,m, sin),
		(d1,v,m, sin),
		(h0,v,m, sin),
		(h0,v,m, sin),

		-- fuenfzehnter Takt
		(c1,v,m, sin),
		(e1,v,m, sin),
		(a1,v,m, sin),
		(a1,v,m, sin),

		-- sechzehnter Takt
		(gis1,v,m, sin),
		(gis1,v,m, sin),
		(gis1,v,m, sin),
		(gis1,v,m, sin),

		-- Reset
		(res,z,o, sin),
		others => (res, z, o, sin)
		);
	
	-- https://www.youtube.com/watch?v=YK3ZP6frAMc
	-- Zweistimmig: Melodie Stimme:	
	constant popcorn : song_type := (
		-- erster Takt
		(pause, v, o, tri), --1
		(pause, v, o, tri), --2
		(pause, v, o, tri), --3
		(h1, a, f, tri), -- 4
		(a1, a, f, tri), --5
		-- zweiter Takt
		(h1, a, f, tri), --6
		(fis1, a, f, tri), --7
		(d1, a, f, tri), --8
		(fis1, a, f, tri), --9
		(h0, v, f, tri), --10
		(h1, a, f, tri), -- 11
		(a1, a, f, tri), --12
		-- dritter Takt
	    (h1, a, f, tri),
		(fis1, a, f, tri),
		(d1, a, f, tri),
		(fis1, a, f, tri),
		(h0, v, f, tri),
		(h1, a, f, tri),
		(cis2, a, f, tri),
		-- vierter Takt
		(d2, a, f, tri),
		(cis2, a, f, tri),
		(d2, a, f, tri),
		(h1, a, f, tri),
		(cis2, a, f, tri),
		(h1, a, f, tri),
		(cis2, a, f, tri),
		(a1, a, f, tri),
		-- fünfter takt
		(h1, a, f, tri),
		(a1, a, f, tri),
		(h1, a, f, tri),
		(g1, a, f, tri),
		(h1, v, f, tri),
		(h1, a, f, tri),
		(a1, a, f, tri),
		-- sechster Takt
	    (h1, a, f, tri),
		(fis1, a, f, tri),
		(d1, a, f, tri),
		(fis1, a, f, tri),
		(h0, v, f, tri),
		(h1, a, f, tri),
		(a1, a, f, tri),
		-- 7 Takt
	    (h1, a, f, tri),
		(fis1, a, f, tri),
		(d1, a, f, tri),
		(fis1, a, f, tri),
		(h0, v, f, tri),
		(h1, a, f, tri),
		(cis2, a, f, tri),
		-- 8 Takt
		(d2, a, f, tri),
		(cis2, a, f, tri),
		(d2, a, f, tri),
		(h1, a, f, tri),
		(cis2, a, f, tri),
		(h1, a, f, tri),
		(cis2, a, f, tri),
		(a1, a, f, tri),
		-- 9 takt
		(h1, a, f, tri),
		(a1, a, f, tri),
		(h1, a, f, tri),
		(g1, a, f, tri),
		(h1, v, f, tri),
		(h1, a, f, tri),
		(a1, a, f, tri),
		

		-- Reset
		(res,z,o, sin),
		others => (res, z, o, sin)
		);
		
    -- Bass Stimme.
constant popcorn_bass : song_type := (
		(pause, z, o, sin),
		-- erster Takt
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),
		--
	    (h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),
        --
        (h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),
        --
        (h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),
        (a_2, a, mf, sin),
        (a_1, s, mf, sin),
        (e_1, s, mf, sin),
        (a_2, s, mf, sin),
        (cis_1, s, mf, sin),
        (e_1, s, mf, sin),
        (a_2, s, mf, sin),
        --
        (g_1, a, mf, sin),
        (g_1, s, mf, sin),
        (d_1, s, mf, sin),
        (g_1, s, mf, sin),
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (g_1, s, mf, sin),
        (h_2, a, mf, sin),
        (h_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),
        --
        (h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),
        --
        (h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),
        --
        (h_2, a, mf, sin), --1
		(h_1, s, mf, sin), --2
		(f_1, s, mf, sin), --3
		(h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),
        (a_2, a, mf, sin),
        (a_1, s, mf, sin),
        (e_1, s, mf, sin),
        (a_2, s, mf, sin),
        (cis_1, s, mf, sin),
        (e_1, s, mf, sin),
        (a_2, s, mf, sin),
        --
        (g_1, a, mf, sin),
        (g_1, s, mf, sin),
        (d_1, s, mf, sin),
        (g_1, s, mf, sin),
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (g_1, s, mf, sin),
        (h_2, a, mf, sin),
        (h_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_2, s, mf, sin),
        (d_1, s, mf, sin),
        (f_1, s, mf, sin),
        (h_1, s, mf, sin),

		-- Reset
		(res,z,o, sin),
		others => (res, z, o, sin)
		);

end sound_p;
