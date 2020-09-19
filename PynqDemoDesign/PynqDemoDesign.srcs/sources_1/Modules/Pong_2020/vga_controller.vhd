----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:
-- Design Name: 
-- Module Name:    vga - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_controller is
        generic ( ball_length : integer := 6;
                  racket_length : integer := 10;
                  racket_height : integer := 30;
                  racket_left_space : integer := 20;
                  racket_right_space : integer := 610;
                  H_max : integer := 799;
                  V_max : integer := 524);
		port (clock_i         : in std_logic;
		      reset_i         : in std_logic;
		      vga_enable_i    : in std_logic;
		      racket_y_pos1_i : in std_logic_vector (9 downto 0);
		      racket_y_pos2_i : in std_logic_vector (9 downto 0);
		      ball_x_i        : in std_logic_vector (9 downto 0);
		      ball_y_i        : in std_logic_vector (9 downto 0);
		      count_1_i       : in std_logic_vector (6 downto 0);
		      count_2_i       : in std_logic_vector (6 downto 0);
		      h_sync_o        : out std_logic;
		      v_sync_o        : out std_logic;
		      red_o           : out std_logic_vector (3 downto 0);
		      green_o         : out std_logic_vector (3 downto 0);
		      blue_o          : out std_logic_vector (3 downto 0));
end vga_controller;

architecture Behavioral of vga_controller is

-----------------------------------------------------------------------------------------
-- Signals:
-----------------------------------------------------------------------------------------
-- Counters:
signal hcs : std_logic_vector(9 downto 0); 
signal vcs : std_logic_vector(9 downto 0);

-- Printing Gameelements:
signal video_out         : std_logic_vector(5 downto 0);

-- Scoredisplay:
signal number_on : std_logic;
signal rom_address : std_logic_vector(9 downto 0);
signal binary : std_logic_vector (6 downto 0);
signal comp_bcd_number : std_logic_vector (7 downto 0);
signal bcd_number : std_logic_vector (3 downto 0);
signal sprite_pix : std_logic_vector (15 downto 0);
signal var : integer range 0 to 800;

-- Collision Detection Test:
--signal test_colli : std_logic_vector(4 downto 0);

-----------------------------------------------------------------------------------------
-- ROM containing the numbers:
-----------------------------------------------------------------------------------------
component VGA_Numbers_prom is
    Port ( rom_address_i : in STD_LOGIC_VECTOR (3 downto 0);
           select_i : in std_logic_vector (3 downto 0);
           Out_o : out STD_LOGIC_VECTOR (15 downto 0));
end component;

begin

---------------------------------------------------------------------------------
-- VGA Counters / Syncpuls
---------------------------------------------------------------------------------
counters: process(clock_i,reset_i)
    begin

        if (reset_i = '1') then
           hcs <= "0000000000";
	       vcs <= "0000000000";
	       h_sync_o <= '0';
	       v_sync_o <= '0';

        elsif rising_edge(clock_i) then

	      if (vga_enable_i = '1') then

		-- Horizontal Counter
		  if (hcs >= H_max) then
			   hcs <= "0000000000";
		  else
			   hcs <= hcs + "0000000001";
		  end if;
	
		  if (hcs <= 755) and (hcs >= 659) then
		      h_sync_o <= '0';
		  else
			  h_sync_o <= '1';
		  end if;
		
		-- Vertical Counter
		  if (vcs >= V_max) and (hcs >= 699) then
			 vcs <= "0000000000";
		  else 
			 if (hcs = 699) then
				vcs <= vcs + "0000000001";
			 end if;
		  end if;
		
		if (vcs <= 494) and (vcs >= 493) then
			v_sync_o <= '0';
		else
			v_sync_o <= '1';
		end if;	
	  end if;
    end if;
end process;
----------------------------------------------------------------------------------
-- Printing Gameelements
----------------------------------------------------------------------------------
video_out <= "111111" when (((hcs >= ball_x_i) and (hcs < ball_x_i + ball_length)) and
						   ((vcs >= ball_y_i) and (vcs < ball_y_i  + ball_length))) or
						   (((hcs >= racket_left_space-1) and (hcs < racket_left_space + racket_length-1)) and
						   ((vcs >= racket_y_pos1_i) and (vcs < racket_y_pos1_i  + racket_height))) or
						   (((hcs >= racket_right_space-1) and (hcs < racket_right_space + racket_length-1)) and
						   ((vcs >= racket_y_pos2_i) and (vcs < racket_y_pos2_i  + racket_height)))
						   else "000000";

----------------------------------------------------------------------------------
-- Spielstandsanzeige
----------------------------------------------------------------------------------
Numbers: VGA_Numbers_prom
port map (rom_address_i => rom_address(3 downto 0),
          select_i      => bcd_number,
          Out_o         => sprite_pix);

binary <= count_1_i when (hcs <= 320) else count_2_i; -- Choosing the right player score, left side of the screen the left player,
                                                      -- right side of the screen the right player.         
-- Binary to BCD:
with binary select
comp_bcd_number <= "00000000" when "0000000",         
                   "00000001" when "0000001",         
                   "00000010" when "0000010",         
                   "00000011" when "0000011",
                   "00000100" when "0000100",
                   "00000101" when "0000101",
                   "00000110" when "0000110",
                   "00000111" when "0000111",
                   "00001000" when "0001000",
                   "00001001" when "0001001",
                   "00010000" when "0001010",
                   "00010001" when "0001011",
                   "00010010" when "0001100",
                   "00010011" when "0001101",
                   "00010100" when "0001110",
                   "00010101" when "0001111",
                   "00000000" when others;

-- Taking the right digits to display: 
bcd_number <= comp_bcd_number(3 downto 0) when (((hcs >= 400) and (hcs < 416)) or ((hcs >= 260) and (hcs < 276))) else
              comp_bcd_number(7 downto 4) when (((hcs >= 382) and (hcs < 398)) or ((hcs >= 242) and (hcs < 258))) else "0000";

-- Printing the score 10 pixels down from the topside of the screen.
rom_address <= (vcs - 10) when ((vcs >= 10) and (vcs < 26)) else "0000000000";

-- Var is counting from 15 downto 0. 
var <= to_integer(unsigned(15 - (hcs - 400))) when ((hcs >= 400) and (hcs < 416)) else
       to_integer(unsigned(15 - (hcs - 382))) when ((hcs >= 382) and (hcs < 398)) else
       to_integer(unsigned(15 - (hcs - 260))) when ((hcs >= 260) and (hcs < 276)) else
       to_integer(unsigned(15 - (hcs - 242))) when ((hcs >= 242) and (hcs < 258)) else 0;  

number_on <= sprite_pix(var) when (((hcs >= 400) and (hcs < 416)) or ((hcs >= 382) and (hcs < 398)) or ((hcs >= 260) and (hcs < 276)) or ((hcs >= 242) and (hcs < 258))) else '0';

----------------------------------------------------------------------------------
-- Ausgabe
----------------------------------------------------------------------------------

red_o   <= video_out(3 downto 0);
green_o	<= "1111" when (number_on = '1') else video_out(3 downto 0);
blue_o	<= video_out(3 downto 0);

end Behavioral;