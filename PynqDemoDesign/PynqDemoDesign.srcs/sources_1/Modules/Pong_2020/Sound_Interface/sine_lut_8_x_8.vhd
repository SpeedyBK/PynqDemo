-- This file is automatically generated by a matlab script 
--
-- Do not modify directly!
--

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_signed.all;
use work.sound_p.all;

package sine_lut_pkg is

type lut_type is array(0 to 2**(PHASE_WIDTH-2)-1) of std_logic_vector(AMPL_WIDTH-1 downto 0);

	constant sine_lut : lut_type := (
    conv_std_logic_vector(0,AMPL_WIDTH),
    conv_std_logic_vector(3,AMPL_WIDTH),
    conv_std_logic_vector(6,AMPL_WIDTH),
    conv_std_logic_vector(9,AMPL_WIDTH),
    conv_std_logic_vector(12,AMPL_WIDTH),
    conv_std_logic_vector(16,AMPL_WIDTH),
    conv_std_logic_vector(19,AMPL_WIDTH),
    conv_std_logic_vector(22,AMPL_WIDTH),
    conv_std_logic_vector(25,AMPL_WIDTH),
    conv_std_logic_vector(28,AMPL_WIDTH),
    conv_std_logic_vector(31,AMPL_WIDTH),
    conv_std_logic_vector(34,AMPL_WIDTH),
    conv_std_logic_vector(37,AMPL_WIDTH),
    conv_std_logic_vector(40,AMPL_WIDTH),
    conv_std_logic_vector(43,AMPL_WIDTH),
    conv_std_logic_vector(46,AMPL_WIDTH),
    conv_std_logic_vector(49,AMPL_WIDTH),
    conv_std_logic_vector(51,AMPL_WIDTH),
    conv_std_logic_vector(54,AMPL_WIDTH),
    conv_std_logic_vector(57,AMPL_WIDTH),
    conv_std_logic_vector(60,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(65,AMPL_WIDTH),
    conv_std_logic_vector(68,AMPL_WIDTH),
    conv_std_logic_vector(71,AMPL_WIDTH),
    conv_std_logic_vector(73,AMPL_WIDTH),
    conv_std_logic_vector(76,AMPL_WIDTH),
    conv_std_logic_vector(78,AMPL_WIDTH),
    conv_std_logic_vector(81,AMPL_WIDTH),
    conv_std_logic_vector(83,AMPL_WIDTH),
    conv_std_logic_vector(85,AMPL_WIDTH),
    conv_std_logic_vector(88,AMPL_WIDTH),
    conv_std_logic_vector(90,AMPL_WIDTH),
    conv_std_logic_vector(92,AMPL_WIDTH),
    conv_std_logic_vector(94,AMPL_WIDTH),
    conv_std_logic_vector(96,AMPL_WIDTH),
    conv_std_logic_vector(98,AMPL_WIDTH),
    conv_std_logic_vector(100,AMPL_WIDTH),
    conv_std_logic_vector(102,AMPL_WIDTH),
    conv_std_logic_vector(104,AMPL_WIDTH),
    conv_std_logic_vector(106,AMPL_WIDTH),
    conv_std_logic_vector(107,AMPL_WIDTH),
    conv_std_logic_vector(109,AMPL_WIDTH),
    conv_std_logic_vector(111,AMPL_WIDTH),
    conv_std_logic_vector(112,AMPL_WIDTH),
    conv_std_logic_vector(113,AMPL_WIDTH),
    conv_std_logic_vector(115,AMPL_WIDTH),
    conv_std_logic_vector(116,AMPL_WIDTH),
    conv_std_logic_vector(117,AMPL_WIDTH),
    conv_std_logic_vector(118,AMPL_WIDTH),
    conv_std_logic_vector(120,AMPL_WIDTH),
    conv_std_logic_vector(121,AMPL_WIDTH),
    conv_std_logic_vector(122,AMPL_WIDTH),
    conv_std_logic_vector(122,AMPL_WIDTH),
    conv_std_logic_vector(123,AMPL_WIDTH),
    conv_std_logic_vector(124,AMPL_WIDTH),
    conv_std_logic_vector(125,AMPL_WIDTH),
    conv_std_logic_vector(125,AMPL_WIDTH),
    conv_std_logic_vector(126,AMPL_WIDTH),
    conv_std_logic_vector(126,AMPL_WIDTH),
    conv_std_logic_vector(126,AMPL_WIDTH),
    conv_std_logic_vector(127,AMPL_WIDTH),
    conv_std_logic_vector(127,AMPL_WIDTH),
    conv_std_logic_vector(127,AMPL_WIDTH)
	);

end sine_lut_pkg;

package body sine_lut_pkg is
end sine_lut_pkg;