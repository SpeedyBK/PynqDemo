library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity seven_seg_dec is
  port(
    bcd_i       : in  std_logic_vector (3 downto 0);
    seven_seg_o : out std_logic_vector (6 downto 0)
  );
end seven_seg_dec;

architecture seven_seg_dec_arch of seven_seg_dec is

begin

with bcd_i select
  seven_seg_o <= "1111110" when "0000",
                 "0110000" when "0001", 
                 "1101101" when "0010", 
                 "1111001" when "0011", 
                 "0110011" when "0100", 
                 "1011011" when "0101", 
                 "1011111" when "0110", 
                 "1110000" when "0111", 
                 "1111111" when "1000", 
                 "1111011" when "1001", 
                 "0000000" when others;

end seven_seg_dec_arch;