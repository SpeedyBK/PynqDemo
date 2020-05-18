----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2020 09:59:02
-- Design Name: 
-- Module Name: ascii_p - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package ascii_p is 
    
    type ascii_t is array (0 to 74) of std_logic_vector (7 downto 0);
    
    constant ascii_c : ascii_t := ( 
--  0      1      2      3      4      5      6      7      8      9      :      ;    
    x"7E", x"30", x"6D", x"79", x"33", x"5B", x"5F", x"70", x"7F", x"7B", x"00", x"00",
--  <      =      >      ?      @      A      B      C      D      E      F      G         
    x"00", x"00", x"00", x"00", x"00", x"77", x"00", x"4E", x"00", x"4F", x"47", x"5E", 
--  H      I      J      K      L      M      N      O      P      Q      R      S
    x"37", x"06", x"3C", x"00", x"0E", x"00", x"00", x"7E", x"67", x"00", x"00", x"5B", 
--  T      U      V      W      X      Y      Z      [      \      ]      ^      _        
    x"00", x"3E", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", x"00", 
--  `      a      b      c      d      e      f      g      h      i      j      k
    x"00", x"7D", x"1F", x"0D", x"3D", x"00", x"00", x"00", x"17", x"00", x"00", x"00", 
--  l      m      n      o      p      q      r      s      t      u      v      w    
    x"00", x"00", x"15", x"1D", x"00", x"73", x"05", x"00", x"0F", x"1C", x"00", x"00", 
--  x      y      z    
    x"00", x"3B", x"00");
    
end package ascii_p;
