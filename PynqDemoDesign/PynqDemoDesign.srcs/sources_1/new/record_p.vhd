library ieee;
use ieee.std_logic_1164.all;
 
package records_p is

-- Constants used in the project

    constant CHAR_WIDTH : integer := 8;
    constant PMOD_WIDTH : integer := 8;
    constant JUMPER_WIDTH : integer := 2;

-------------------
-- Input Signals --
-------------------
-- This record type combines all signals from the board Inputs to a project.

    type input_t is record
        btn : std_logic_vector (3 downto 0);
        n_sw_shield : std_logic_vector(7 downto 0);
        pmodA : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodB : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodC : std_logic_vector(PMOD_WIDTH-1 downto 0);
        m_data : std_logic;
        ps2_1_data : std_logic;
        ps2_1_clk : std_logic;
        ps2_2_data : std_logic;
        ps2_2_clk : std_logic;
        jumper : std_logic_vector(JUMPER_WIDTH-1 downto 0);
    end record input_t;

--------------------
-- Output Signals --
--------------------
-- This record type combines all signals from a project to the board outputs.
-- As well as the direction information for bidirectinal ports. 

    type output_t is record 
        rgb_ld4 : std_logic_vector(2 downto 0);
        rgb_ld5 : std_logic_vector(2 downto 0);
        leds : std_logic_vector(3 downto 0);
        n_shield_leds : std_logic_vector(7 downto 0); -- Shield Low Active: n_shield_led
        n_SSD : std_logic_vector(7 downto 0);
        n_SSD_en : std_logic_vector(7 downto 0);
        aud_pwm : std_logic;
        aud_sd : std_logic;
        mic_clk : std_logic;
        pmodA_dir : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodA : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodB_dir : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodB : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodC_dir : std_logic_vector(PMOD_WIDTH-1 downto 0);
        pmodC : std_logic_vector(PMOD_WIDTH-1 downto 0);
        ps2_1_dir : std_logic_vector(1 downto 0);
        ps2_1_data : std_logic;
        ps2_1_clk : std_logic;
        ps2_2_dir : std_logic_vector(1 downto 0);
        ps2_2_data : std_logic;
        ps2_2_clk : std_logic;
        jumper_dir : std_logic_vector (JUMPER_WIDTH-1 downto 0);
        jumper : std_logic_vector(JUMPER_WIDTH-1 downto 0);
    end record output_t;    

------------------
-- Name Signals --
------------------
-- This record type contains the signals necessary for displaying the Project 
-- names on the SSD.
    
    type name_t is record 
        name_ptr : std_logic_vector(CHAR_WIDTH-1 downto 0);
        name_len : std_logic_vector(CHAR_WIDTH-1 downto 0);
        name_dat : std_logic_vector(CHAR_WIDTH-1 downto 0);
    end record name_t;

end records_p;