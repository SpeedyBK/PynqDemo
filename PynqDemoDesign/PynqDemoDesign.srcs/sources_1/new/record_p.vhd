library ieee;
use ieee.std_logic_1164.all;
 
package records_p is
 
-------------------------------------
-- Transmission of the Modulenames --
-------------------------------------

--  |--------| <--name_ptr--- |-------------|
--  | Module | ---name_len--> | Ctrl.Module |
--  |--------| ---name_dat--> |-------------|  

    type name_t is record
        name_ptr : std_logic_vector(7 downto 0); -- Pointer to a position in the name-string of a module            
        name_len : std_logic_vector(7 downto 0); -- Length of the name-string, max. 255 characters
        name_dat : std_logic_vector(7 downto 0); -- Data which the pointer points to, ascii encoded.
    end record name_t;  

end records_p;