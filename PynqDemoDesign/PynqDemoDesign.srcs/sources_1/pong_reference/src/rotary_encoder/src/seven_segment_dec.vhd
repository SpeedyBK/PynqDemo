-------------------------------------------------------------------------------
--
-- M. Kumm
-- 
-- seven segment dec logic with hexadecimal chars
--
-------------------------------------------------------------------------------

-- Package Definition

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_unsigned.all;

package seven_segment_dec_pkg is
  component seven_segment_dec
  	port(
		bcd_i			:	in std_logic_vector(3 downto 0);
		seven_seg_o :	out std_logic_vector(6 downto 0)
  	);
  end component;
end seven_segment_dec_pkg;

package body seven_segment_dec_pkg is
end seven_segment_dec_pkg;

-- Entity Definition

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity seven_segment_dec is
  	port(
		bcd_i			:	in std_logic_vector(3 downto 0);
		seven_seg_o :	out std_logic_vector(6 downto 0)
  	);
end seven_segment_dec;

architecture seven_segment_dec_arch of seven_segment_dec is
begin

	process(bcd_i)
	begin
		case bcd_i is
			when "0000" => seven_seg_o <= "0111111";
			when "0001" => seven_seg_o <= "0000110";
			when "0010" => seven_seg_o <= "1011011";
			when "0011" => seven_seg_o <= "1001111";
			when "0100" => seven_seg_o <= "1100110";
			when "0101" => seven_seg_o <= "1101101";
			when "0110" => seven_seg_o <= "1111101";
			when "0111" => seven_seg_o <= "0000111";
			when "1000" => seven_seg_o <= "1111111";
			when "1001" => seven_seg_o <= "1101111";
			when "1010" => seven_seg_o <= "1110111";
			when "1011" => seven_seg_o <= "1111100";
			when "1100" => seven_seg_o <= "1011000";
			when "1101" => seven_seg_o <= "1011110";
			when "1110" => seven_seg_o <= "1111001";
			when "1111" => seven_seg_o <= "1110001";
			when others => seven_seg_o <= "XXXXXXX";
		end case;
	end process;

end seven_segment_dec_arch;