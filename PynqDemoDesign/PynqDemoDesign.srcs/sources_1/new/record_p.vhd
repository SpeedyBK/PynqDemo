library ieee;
use ieee.std_logic_1164.all;
 
package records_p is
 
---------------------------------
-- Transmission of Modulenames --
---------------------------------

--  |--------| <--name_ptr--- |-----| <--name_ptr--- |-------------|
--  | Module | ---name_len--> | MUX | ---name_len--> | Ctrl.Module |
--  |--------| ---name_dat--> |-----| ---name_dat--> |-------------|  
    constant CHAR_WIDTH : integer := 8;
    type name_t is record
        name_ptr : std_logic_vector(CHAR_WIDTH-1 downto 0); -- Pointer to a position in the name-string of a module            
        name_len : std_logic_vector(CHAR_WIDTH-1 downto 0); -- Length of the name-string, max. 255 characters
        name_dat : std_logic_vector(CHAR_WIDTH-1 downto 0); -- Data which the pointer points to, ascii encoded.
    end record name_t;  

----------------
-- IO-Signals --
----------------
--LEDs:
--  |--------| --- rgb_ld4    ---> |-----| --- ld4_o       ---> |----|
--  | Module | --- rgb_ld5    ---> | Mux | --- ld5_o       ---> | IO |
--  |        | --- board_leds ---> |     | --- b_leds_o    ---> |    |   
--  |--------| --- blue_leds  ---> |-----| --- blue_leds_o ---> |----|
    
    type leds_t is record
        rgb_ld4 : std_logic_vector(2 downto 0);
        rgb_ld5 : std_logic_vector(2 downto 0);
        board_leds : std_logic_vector(3 downto 0);
        blue_leds : std_logic_vector(7 downto 0); -- Shield Low Active: n_shield_led
    end record leds_t;


-- Seven Segment Displays:
--  |--------| --- segments  ---> |-----| --- segments_o ---> |----|
--  | Module | --- digit_en  ---> | Mux | --- digit_en_o ---> | IO |   
--  |--------|                    |-----|                     |----|
    
    type ssds_t is record 
        segments : std_logic_vector(7 downto 0);
        digit_en : std_logic_vector(7 downto 0);
    end record ssds_t;


-- Audio Out (Onboard)
--  |--------| --- aud_pwm  ---> |-----| --- aud_pwm_o ---> |----|
--  | Module | --- aud_sd   ---> | Mux | --- aud_sd_o  ---> | IO |   
--  |--------|                   |-----|                    |----|
    type audio_t is record
        aud_pwm : std_logic;
        aud_sd : std_logic;
    end record audio_t;
    
    
-- Pmod
--  |--------| --- PmodA  ---> |-----| --- PmodA_o ---> |----|
--  | Module | --- PmodB  ---> | Mux | --- PmodB_o ---> | IO |   
--  |--------| --- PmodC  ---> |-----| --- PmodC_o ---> |----|
    constant PMOD_WIDTH : integer := 8;
    type pmod_t is record
        pmodA_dir : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodA_o : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodA_i : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodB_dir : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodB_o : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodB_i : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodC_dir : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodC_o : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodC_i : std_logic_vector(PMOD_WIDTH-1 downto 0);
    end record pmod_t;
    

-- PS2
--  |--------| --- ps2_1_data  ---> |-----| --- ps2_1_data ---> |----|
--  | Module | --- ps2_1_clk   ---> | Mux | --- ps2_1_clk  ---> | IO |   
--  |        | --- ps2_2_data  ---> |     | --- ps2_1_data ---> |    |
--  |--------| --- ps2_2_clk   ---> |-----| --- ps2_1_clk  ---> |----|
    type ps2_t is record
        ps2_1_dir : std_logic_vector(1 downto 0);
        ps2_1_data_i : std_logic;
        ps2_1_clk_i : std_logic;
        ps2_1_data_o : std_logic;
        ps2_1_clk_o : std_logic;
        ps2_2_dir : std_logic_vector(1 downto 0);
        ps2_2_data_i : std_logic;
        ps2_2_clk_i : std_logic;
        ps2_2_data_o : std_logic;
        ps2_2_clk_o : std_logic;
    end record ps2_t;
    
    constant JUMPER_WIDTH : integer := 2;
    type jumper_t is record
        jumper_dir : std_logic_vector (JUMPER_WIDTH-1 downto 0);
        jumper_i : std_logic_vector(JUMPER_WIDTH-1 downto 0);
        jumper_o : std_logic_vector(JUMPER_WIDTH-1 downto 0);
    end record jumper_t;

end records_p;