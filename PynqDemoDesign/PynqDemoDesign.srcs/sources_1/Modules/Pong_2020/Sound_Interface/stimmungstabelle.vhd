----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:53 12/17/2009 
-- Design Name: 
-- Module Name:    tuning_table - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.sound_p.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tuning_table is
    Port ( note0_i : in   STD_LOGIC;
           note1_i : in   STD_LOGIC;
           note2_i : in   STD_LOGIC;
           note3_i : in   STD_LOGIC;
		   note4_i : in   STD_LOGIC;
		   note5_i : in   STD_LOGIC;
           ftw_o	 : out  STD_LOGIC_VECTOR (FTW_WIDTH-1 downto 0));
end tuning_table;

architecture Behavioral of tuning_table is

signal note : std_logic_vector (5 downto 0);

begin

	note(0) <= note0_i;
	note(1) <= note1_i;
	note(2) <= note2_i;
	note(3) <= note3_i;
	note(4) <= note4_i;
	note(5) <= note5_i;

with note select
ftw_o <= std_logic_vector(to_unsigned(5140217, ftw_o'length)) when "000000",
         std_logic_vector(to_unsigned(5445870, ftw_o'length)) when "000001",
         std_logic_vector(to_unsigned(5769698, ftw_o'length)) when "000010",
         std_logic_vector(to_unsigned(6112782, ftw_o'length)) when "000011",
         std_logic_vector(to_unsigned(6476267, ftw_o'length)) when "000100",
         std_logic_vector(to_unsigned(6861366, ftw_o'length)) when "000101",
         std_logic_vector(to_unsigned(7269364, ftw_o'length)) when "000110",
         std_logic_vector(to_unsigned(7701623, ftw_o'length)) when "000111",
         std_logic_vector(to_unsigned(8159586, ftw_o'length)) when "001000",
         std_logic_vector(to_unsigned(8644780, ftw_o'length)) when "001001",
         std_logic_vector(to_unsigned(9158825, ftw_o'length)) when "001010",
         std_logic_vector(to_unsigned(9703437, ftw_o'length)) when "001011",
         std_logic_vector(to_unsigned(10280434, ftw_o'length)) when "001100",
         std_logic_vector(to_unsigned(10891740, ftw_o'length)) when "001101",
         std_logic_vector(to_unsigned(11539397, ftw_o'length)) when "001110",
         std_logic_vector(to_unsigned(12225565, ftw_o'length)) when "001111",
         std_logic_vector(to_unsigned(12952535, ftw_o'length)) when "010000",
         std_logic_vector(to_unsigned(13722733, ftw_o'length)) when "010001",
         std_logic_vector(to_unsigned(14538729, ftw_o'length)) when "010010",
         std_logic_vector(to_unsigned(15403247, ftw_o'length)) when "010011",
         std_logic_vector(to_unsigned(16319171, ftw_o'length)) when "010100",
         std_logic_vector(to_unsigned(17289569, ftw_o'length)) when "010101",
         std_logic_vector(to_unsigned(18317650, ftw_o'length)) when "010110",
         std_logic_vector(to_unsigned(19406875, ftw_o'length)) when "010111",
         std_logic_vector(to_unsigned(20560867, ftw_o'length)) when "011000",
         std_logic_vector(to_unsigned(21783480, ftw_o'length)) when "011001",
         std_logic_vector(to_unsigned(23078793, ftw_o'length)) when "011010",
         std_logic_vector(to_unsigned(24451130, ftw_o'length)) when "011011",
         std_logic_vector(to_unsigned(25905070, ftw_o'length)) when "011100",
         std_logic_vector(to_unsigned(27445465, ftw_o'length)) when "011101",
         std_logic_vector(to_unsigned(29077458, ftw_o'length)) when "011110",
         std_logic_vector(to_unsigned(30806493, ftw_o'length)) when "011111",
         std_logic_vector(to_unsigned(32638343, ftw_o'length)) when "100000",
         std_logic_vector(to_unsigned(34579119, ftw_o'length)) when "100001",
         std_logic_vector(to_unsigned(36635301, ftw_o'length)) when "100010",
         std_logic_vector(to_unsigned(38813749, ftw_o'length)) when "100011",
         std_logic_vector(to_unsigned(41121735, ftw_o'length)) when "100100",
         std_logic_vector(to_unsigned(43566960, ftw_o'length)) when "100101",
         std_logic_vector(to_unsigned(46157587, ftw_o'length)) when "100110",
         std_logic_vector(to_unsigned(48902260, ftw_o'length)) when "100111",
         std_logic_vector(to_unsigned(51810139, ftw_o'length)) when "101000",
         std_logic_vector(to_unsigned(54890931, ftw_o'length)) when "101001",
         std_logic_vector(to_unsigned(58154915, ftw_o'length)) when "101010",
         std_logic_vector(to_unsigned(61612986, ftw_o'length)) when "101011",
         std_logic_vector(to_unsigned(65276685, ftw_o'length)) when "101100",
         std_logic_vector(to_unsigned(69158239, ftw_o'length)) when "101101",
         std_logic_vector(to_unsigned(73270602, ftw_o'length)) when "101110",
         std_logic_vector(to_unsigned(77627498, ftw_o'length)) when "101111",
         std_logic_vector(to_unsigned(82243470, ftw_o'length)) when "110000",
         std_logic_vector(to_unsigned(87133921, ftw_o'length)) when "110001",
         std_logic_vector(to_unsigned(92315174, ftw_o'length)) when "110010",
         std_logic_vector(to_unsigned(97804519, ftw_o'length)) when "110011",
         std_logic_vector(to_unsigned(103620279, ftw_o'length)) when "110100",
         std_logic_vector(to_unsigned(109781861, ftw_o'length)) when "110101",
         std_logic_vector(to_unsigned(116309830, ftw_o'length)) when "110110",
         std_logic_vector(to_unsigned(123225973, ftw_o'length)) when "110111",
         std_logic_vector(to_unsigned(130553370, ftw_o'length)) when "111000",
         std_logic_vector(to_unsigned(138316478, ftw_o'length)) when "111001",
         std_logic_vector(to_unsigned(146541204, ftw_o'length)) when "111010",
         std_logic_vector(to_unsigned(155254997, ftw_o'length)) when "111011",
         std_logic_vector(to_unsigned(164486940, ftw_o'length)) when "111100",
         std_logic_vector(to_unsigned(174267842, ftw_o'length)) when "111101",
         std_logic_vector(to_unsigned(184630347, ftw_o'length)) when "111110",
         std_logic_vector(to_unsigned(195609039, ftw_o'length)) when others;


end Behavioral;