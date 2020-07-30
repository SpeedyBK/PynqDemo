library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY bidir IS
    PORT(
        bidir   : INOUT STD_LOGIC;    -- Bidirectional Pin (Pmod A Pin 0)
        ps, clk, A_in : IN STD_LOGIC; -- PinMode Select (SW 0), Clock and Inputswitch (SW1)
        outp    : OUT STD_LOGIC);     -- Feedback LED (LD0)
END bidir;

ARCHITECTURE test OF bidir IS

signal a : STD_LOGIC;  
signal b : STD_LOGIC;  
                      
begin                                 
    process(clk)    
    begin
    if rising_edge(clk) then 
        a <= A_in;                    
        outp <= b;                  
        END IF;
    end process;
    
    with ps select
    bidir <= 'Z' when '0',
              a when '1'; 
    b <= bidir;              
end test;

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