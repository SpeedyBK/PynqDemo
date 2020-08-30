----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik 
-- Engineer: Benjamin Lagershausen Kessler
-- 
-- Create Date: 22.08.2020 13:56:15
-- Design Name: Sound Sample Activator
-- Module Name: SoundActivator - Behavioral
-- Project Name: Pong
-- Target Devices: Pynq Board
-- Tool Versions: 
-- Description: State Machine, that controlles the Sound_Interface.
-- 
-- Dependencies: 
-- 
-- Revision:
-- 08/2020 Revision 1.0 - Initial Version BLK
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

entity SoundActivator is
Port (clk_i : in std_logic;
      reset_i : in std_logic;
      hit_wall_i : in std_logic_vector(2 downto 0);
      hit_racket_l_i : in std_logic_vector(1 downto 0);
      hit_racket_r_i : in std_logic_vector(1 downto 0);
      game_over_i : in std_logic;
      push_but1_deb_i : in std_logic;
      push_but2_deb_i : in std_logic;
      bg_clr : in std_logic;
      bg_bass_clr : in std_logic;
      looser_clr : in std_logic;
      wall_clr : in std_logic;
      racket_clr : in std_logic;
      out_clr : in std_logic;
      bg_rst_o : out std_logic; 
      bg_bass_rst_o : out std_logic;
      looser_rst_o : out std_logic;
      wall_rst_o : out std_logic;
      racket_rst_o : out std_logic;
      out_rst_o : out std_logic;
      debug_o :out std_logic_vector (3 downto 0));
end SoundActivator;

architecture Behavioral of SoundActivator is

signal hit_racket : std_logic;
signal hit_wall : std_logic;
signal hit_out : std_logic; 

type state_t is (NoEvent, GameOver, HitWall, HitRacket, HitOut);
signal state : state_t := NoEvent;

signal bg_ena : std_logic;
signal bg_bass_ena : std_logic;
signal looser_ena : std_logic;
signal wall_ena : std_logic;
signal racket_ena : std_logic;
signal out_ena : std_logic;
signal restart : std_logic;

begin

-----------------------------
-- Simplifiying the Inputs --
-----------------------------
hit_racket <= or (hit_racket_l_i & hit_racket_r_i);
hit_out <= hit_wall_i(2) and (hit_wall_i(0) xor hit_wall_i(1));
hit_wall <= not hit_wall_i(2) and (hit_wall_i(0) xor hit_wall_i(1));
restart <=  push_but1_deb_i or push_but2_deb_i;

--------------------
-- Controller FSM --
--------------------
-- Statediagramm in the SRC-Files Folder
ControlFSM:process (clk_i, 
                    reset_i, 
                    game_over_i,
                    hit_out, 
                    hit_wall,
                    hit_racket,
                    bg_clr,
                    bg_bass_clr,
                    looser_clr,
                    wall_clr,
                    racket_clr,
                    out_clr)
begin
    if (reset_i = '1') then
        bg_ena <= '0';
        bg_bass_ena <= '0';
        looser_ena <= '0';
        wall_ena <= '0';
        racket_ena <= '0';
        out_ena <= '0';
        state <= NoEvent;
    elsif rising_edge(clk_i) then 
        case state is 
            when NoEvent => 
                debug_o <= "0001";
                bg_ena <= '1';
                bg_bass_ena <= '1';
                looser_ena <= '0';
                wall_ena <= '0';
                racket_ena <= '0';
                out_ena <= '0';
                if (bg_clr = '1') then 
                    bg_ena <= '0';
                    bg_bass_ena <= '0';
                end if;
                if (game_over_i = '1') then 
                    state <= GameOver; 
                elsif (hit_out = '1') then 
                    state <= HitOut;
                elsif (hit_racket = '1') then 
                    state <= HitRacket;
                elsif (hit_wall = '1') then 
                    state <= HitWall;
                end if;
            when GameOver => 
                debug_o <= "0010";
                bg_ena <= '0';
                bg_bass_ena <= '0';
                wall_ena <= '0';
                racket_ena <= '0';
                out_ena <= '0';
                looser_ena <= '1';
                if (restart = '1') then 
                    state <= NoEvent;
                end if;
            when HitOut =>
                debug_o <= "0100";
                bg_ena <= '1';
                bg_bass_ena <= '1';
                wall_ena <= '0';
                racket_ena <= '0';
                out_ena <= '1';
                looser_ena <= '0';
                if (bg_clr = '1') then 
                    bg_ena <= '0';
                    bg_bass_ena <= '0';
                end if;
                if (out_clr = '1') then 
                    state <= NoEvent;
                end if;
            when HitRacket =>
                debug_o <= "1000";
                bg_ena <= '1';
                bg_bass_ena <= '1';
                wall_ena <= '0';
                racket_ena <= '1';
                out_ena <= '0';
                looser_ena <= '0';
                if (bg_clr = '1') then 
                    bg_ena <= '0';
                    bg_bass_ena <= '0';
                end if;
                if (racket_clr = '1') then 
                    state <= NoEvent;
                end if;
            when HitWall => 
                debug_o <= "1111";
                bg_ena <= '1';
                bg_bass_ena <= '1';
                wall_ena <= '1';
                racket_ena <= '0';
                out_ena <= '0';
                looser_ena <= '0';
                if (bg_clr = '1') then 
                    bg_ena <= '0';
                    bg_bass_ena <= '0';
                end if;
                if (wall_clr = '1') then 
                    state <= NoEvent;
                end if;
            when others =>
                state <= NoEvent;
        end case;            
    end if;
end process;

-- We are abusing the reset-signals for the Melody-Player as enable-signals,
-- we have to invert the outputs of our ControllFSM. 
bg_rst_o <= not bg_ena;
bg_bass_rst_o <= not bg_bass_ena;
looser_rst_o <= not looser_ena;
wall_rst_o <= not wall_ena;
racket_rst_o <= not racket_ena;
out_rst_o <= not out_ena;

end Behavioral;
