-- This file is automatically generated by a matlab script 
--
-- Do not modify directly!
--

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_signed.all;
use work.sound_p.all;

package square_lut_pkg is

type lut_type is array(0 to 2**(PHASE_WIDTH-2)-1) of std_logic_vector(AMPL_WIDTH-1 downto 0);

	constant square_lut : lut_type := (
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH),
    conv_std_logic_vector(63,AMPL_WIDTH)
	);

end square_lut_pkg;

package body square_lut_pkg is
end square_lut_pkg;