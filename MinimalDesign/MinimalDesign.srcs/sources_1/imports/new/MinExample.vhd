library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY bidir IS
    PORT(
        bidir   : INOUT STD_LOGIC; -- Bidirectional Pin (Pmod A Pin 0)
        ps, clk : IN STD_LOGIC;    -- PinMode Select (SW 0) and Clock 
        inp     : IN STD_LOGIC;    -- Inputswitch (SW 1)
        outp    : OUT STD_LOGIC);  -- Feedback LED (LD0)
END bidir;

ARCHITECTURE test OF bidir IS

                       -- If the following process is not commented out:
signal a : STD_LOGIC;  -- D-FlipFlop that stores value from input.
signal b : STD_LOGIC;  -- D-FlipFlop that stores feedback value. 
                       -- else just wires.
begin

--------------------------------------------------------------------------
-- Uncomment to generate Flip Flops at in- and outputs.                                       
--    process(clk)     -- Creates the flipflops
--    begin
--    if rising_edge(clk) then 
        a <= inp;                    
        outp <= b;                  
--        END IF;
--    end process;

--------------------------------------------------------------------------
-- Example with sequential code.        
--    process (ps, bidir, a) -- Behavioral representation of tri-states.
--        begin                    
--        if( ps = '0') then -- Bidirectional pin configured as input.
--            bidir <= 'Z';  
--            b <= bidir;    -- Feedback LED
--        else               -- Bidirectional pin configured as ouput.
--            bidir <= a; 
--            b <= bidir;    -- Feedback LED
--        end if;
--    end process;

--------------------------------------------------------------------------
-- Example with non-sequential code:     
with ps select
bidir <= 'Z' when '0', -- Bidirectional pin configured as input.
          a when '1';  -- Bidirectional pin configured as ouput.

b <= bidir;            -- Feedback LED
    
end test;