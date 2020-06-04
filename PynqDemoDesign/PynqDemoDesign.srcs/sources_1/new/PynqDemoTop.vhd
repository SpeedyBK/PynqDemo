----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.05.2020 13:59:51
-- Design Name: 
-- Module Name: PynqDemoTop - Behavioral
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
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.records_p.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PynqDemoTop is
    Port ( -----------------------------
           -- Signals to and from IOs --
           -----------------------------
           -- Clock
           clk_i : in STD_LOGIC;
           
           -- Switches 
           sw_i : in std_logic_vector(1 downto 0); -- (SW1,SW0)

           -- RGB LEDs
           ld4_o : out std_logic_vector(2 downto 0); -- (Red, Green, Blue)
           ld5_o : out std_logic_vector(2 downto 0); -- (Red, Green, Blue)

           -- Board LEDs
           leds_o : out std_logic_vector(3 downto 0); -- (LD3, LD2, LD1, LD0)

           -- Board Buttons
           btn_i : in std_logic_vector (3 downto 0); -- (BTN3, BTN2, BTN1, BTN0)

           -- PMODs:
--         -------------------------
--         |vcc|gnd| 3 | 2 | 1 | 0 |
--         -------------------------
--         |vcc|gnd| 7 | 6 | 5 | 4 |
--         -------------------------
           pmodA : inout std_logic_vector (PMOD_WIDTH-1 downto 0);
           pmodB : inout std_logic_vector (PMOD_WIDTH-1 downto 0);
           
           -- When pmodC is used as pmod, only bits 7 downto 0 are used, set bits 10, 9 and 8 to '0';
           -- When pmodC is used as Audio Port:
           -- (  10  ,  9  ,   8  ,   7   ,   6   ,    5    ,   4   ,    3    ,   2   ,    1   ,   0  )
           -- (A_MODE, A_CS, A_MCK, A_DOUT, A_SCLK, A_LRCOUT, A_SDIN, A_CLKOUT, A_BCLK, A_LRCIN, A_DIN) 
           pmodC : inout std_logic_vector (PMOD_WIDTH+2 downto 0);

           -- Audio Out:
           aud_pwm_o : out std_logic;
           aud_sd_o  : out std_logic;

           -- Mic Input
           m_clk_o : out std_logic;
           m_data_i : in std_logic;

--           -- HDMI Rx
--           hdmi_rx_cec : inout std_logic;
--           hdmi_rx_clk_n : in std_logic;
--           hdmi_rx_clk_p : in std_logic;
--           hdmi_rx_d_n : in std_logic_vector(2 downto 0);
--           hdmi_rx_d_p : in std_logic_vector(2 downto 0);
--           hdmi_rx_hpd : out std_logic;
--           hdmi_rx_scl : inout std_logic;
--           hdmi_rx_sda : inout std_logic;

--           -- HDMI Tx
--           hdmi_tx_cec : inout std_logic;
--           hdmi_tx_clk_n : out std_logic;
--           hdmi_tx_clk_p : out std_logic;
--           hdmi_tx_d_n : out std_logic_vector(2 downto 0);
--           hdmi_tx_d_p : out std_logic_vector(2 downto 0);
--           hdmi_tx_hpd : in std_logic;
--           hdmi_tx_scl : inout std_logic;
--           hdmi_tx_sda : inout std_logic;

           -----------------
           -- Pynq-Shield --
           -----------------
           
           -- Jumper J15
           jumper : inout std_logic_vector (1 downto 0); --(IO_2, IO_1)

           -- Blue LEDS
           n_leds_shield_o : out std_logic_vector(7 downto 0); --(left downto right)

            -- Switches on the shield
           n_sw_shield_i : in std_logic_vector(7 downto 0); --(left downto right)

            -- Seven Segmend Displays 
           n_digit_en_o : out std_logic_vector(7 downto 0); --(left downto right)
           n_segments_o : out std_logic_vector(7 downto 0); --(a,b,c,d,e,f,g,dp)

            -- PS2 Interface
           ps2_1_data : inout std_logic;
           ps2_1_clk  : inout std_logic;
           
           ps2_2_data : inout std_logic;
           ps2_2_clk  : inout std_logic 

            -- Chip-Kit Ports: 
            -- (Use only when the shield is not connected. Note, that you have 
            -- to change connections in the TopLevel design, and you have to comment out the 
            -- corresponding ports above. Make sure, you know what you are doing when using these
            -- connections. 
           --ck_an_n : inout std_logic_vector (5 downto 0);
           --ck_an_p : inout std_logic_vector (5 downto 0);
           --ck_io : inout std_logic_vector (42 downto 0);

            -- ChipKit SPI
            --ck_miso_i : in std_logic;
            --ck_mosi_o : out std_logic;
            --ck_sck_o : out std_logic;
            --ck_ss : out std_logic;
            
            -- ChipKit I2C
            --ck_scl : out std_logic;
            --ck_sda : inout std_logic;
            
            -- Crypto SDA 
            --crypto_sda : out std_logic;
           );
end PynqDemoTop;

architecture Behavioral of PynqDemoTop is

-- Number of Modules
constant NUM_OF_MODULES : integer := 4;

-- Module IDs:
constant Menu_ID : integer := 0;
constant Pong_ID : integer := 1;
constant Crane_ID : integer := 2;
constant Input_ID : integer := 3;

-- Select Signal for MUX
signal mux_sel : std_logic_vector(CHAR_WIDTH-1 downto 0);
signal mux_sel_temp : std_logic_vector(CHAR_WIDTH-1 downto 0);
signal mux_en : std_logic;

-- Signal Arrays:
type name_arr_t is array (0 to NUM_OF_MODULES-1) of name_t;
signal name_arr : name_arr_t;

type leds_arr_t is array (0 to NUM_OF_MODULES-1) of leds_t;
signal leds_arr : leds_arr_t;

type ssds_arr_t is array (0 to NUM_OF_MODULES-1) of ssds_t;
signal ssds_arr : ssds_arr_t;

type audio_arr_t is array (0 to NUM_OF_MODULES-1) of audio_t;
signal audio_arr : audio_arr_t;

type pmod_arr_t is array (0 to NUM_OF_MODULES-1) of pmod_t;
signal pmod_arr : pmod_arr_t;

type ps2_arr_t is array (0 to NUM_OF_MODULES-1) of ps2_t;
signal ps2_arr : ps2_arr_t;

type jumper_arr_t is array (0 to NUM_OF_MODULES-1) of jumper_t;
signal jumper_arr : jumper_arr_t; 

signal mic_arr : std_logic_vector(0 to NUM_OF_MODULES-1);

type btn_arr_t is array (0 to NUM_OF_MODULES) of std_logic_vector(3 downto 0);
signal btn_arr : btn_arr_t;

begin

Pong: entity work.Pong
port map    ( -- Ports to transmit the Modulename
           name_ptr_i => name_arr(Pong_ID).name_ptr,
           name_len_o => name_arr(Pong_ID).name_len,
           name_dat_o => name_arr(Pong_ID).name_dat,
           -- Clock
           clk_i => clk_i,
           -- Switches 
           sw_i => sw_i,
           -- RGB LEDs
           ld4_o => leds_arr(Pong_ID).rgb_ld4,
           ld5_o => leds_arr(Pong_ID).rgb_ld5,
           -- Board LEDs
           leds_o => leds_arr(Pong_ID).board_leds,
           -- Board Buttons
           btn_i => btn_arr(Pong_ID),
           -- PMODs:
           pmodA_dir_o => pmod_arr(Pong_ID).pmodA_dir,
           pmodA_i => pmod_arr(Pong_ID).pmodA_i,
           pmodA_o => pmod_arr(Pong_ID).pmodA_o,
           
           pmodB_dir_o => pmod_arr(Pong_ID).pmodB_dir,
           pmodB_i => pmod_arr(Pong_ID).pmodB_i,
           pmodB_o => pmod_arr(Pong_ID).pmodB_o,
           
           pmodC_dir_o => pmod_arr(Pong_ID).pmodC_dir,
           pmodC_i => pmod_arr(Pong_ID).pmodC_i, -- Bei 8 Signalen lassen
           pmodC_o => pmod_arr(Pong_ID).pmodC_o,
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
           -- Audio Out:
           aud_pwm_o => audio_arr(Pong_ID).aud_pwm,
           aud_sd_o => audio_arr(Pong_ID).aud_sd,

           -- Mic Input
           m_clk_o => mic_arr(Pong_ID),
           m_data_i => m_data_i,

           
--           -- HDMI Rx
--           hdmi_rx_cec : inout std_logic;
--           hdmi_rx_clk_n : in std_logic;
--           hdmi_rx_clk_p : in std_logic;
--           hdmi_rx_d_n : in std_logic_vector(2 downto 0);
--           hdmi_rx_d_p : in std_logic_vector(2 downto 0);
--           hdmi_rx_hpd : out std_logic;
--           hdmi_rx_scl : inout std_logic;
--           hdmi_rx_sda : inout std_logic;

--           -- HDMI Tx
--           hdmi_tx_cec : inout std_logic;
--           hdmi_tx_clk_n : out std_logic;
--           hdmi_tx_clk_p : out std_logic;
--           hdmi_tx_d_n : out std_logic_vector(2 downto 0);
--           hdmi_tx_d_p : out std_logic_vector(2 downto 0);
--           hdmi_tx_hpd : in std_logic;
--           hdmi_tx_scl : inout std_logic;
--           hdmi_tx_sda : inout std_logic;

           -- Pynq-Shield
           
           -- Jumper J15
           jumper_dir_o => jumper_arr(Pong_ID).jumper_dir,
           jumper_i => jumper_arr(Pong_ID).jumper_i,
           jumper_o => jumper_arr(Pong_ID).jumper_o,

           -- Blue LEDS
           n_leds_shield_o => leds_arr(Pong_ID).blue_leds,

            -- Switches on the shield
           n_sw_shield_i => n_sw_shield_i,

            -- Seven Segmend Displays 
           n_digit_en_o => ssds_arr(Pong_ID).digit_en,
           n_segments_o => ssds_arr(Pong_ID).segments,

            -- PS2 Interface
           ps2_1_dir_o => ps2_arr(Pong_ID).ps2_1_dir,
           ps2_1_data_i => ps2_arr(Pong_ID).ps2_1_data_i,
           ps2_1_data_o => ps2_arr(Pong_ID).ps2_1_data_o,
           ps2_1_clk_i => ps2_arr(Pong_ID).ps2_1_clk_i,
           ps2_1_clk_o => ps2_arr(Pong_ID).ps2_1_clk_o,
           
           ps2_2_dir_o => ps2_arr(Pong_ID).ps2_2_dir,
           ps2_2_data_i => ps2_arr(Pong_ID).ps2_2_data_i,
           ps2_2_data_o => ps2_arr(Pong_ID).ps2_2_data_o,
           ps2_2_clk_i => ps2_arr(Pong_ID).ps2_2_clk_i,
           ps2_2_clk_o => ps2_arr(Pong_ID).ps2_2_clk_o

            -- Chip-Kit Ports: 
            -- (Use only when the shield is not connected. Note, that you have 
            -- to change connections in the TopLevel design, and you have to comment out the 
            -- corresponding ports above. Make sure, you know what you are doing when using these
            -- connections. 
           --ck_an_n : inout std_logic_vector (5 downto 0);
           --ck_an_p : inout std_logic_vector (5 downto 0);
           --ck_io : inout std_logic_vector (42 downto 0);

            -- ChipKit SPI
            --ck_miso_i : in std_logic;
            --ck_mosi_o : out std_logic;
            --ck_sck_o : out std_logic;
            --ck_ss : out std_logic;
            
            -- ChipKit I2C
            --ck_scl : out std_logic;
            --ck_sda : inout std_logic;
            
            -- Crypto SDA 
            --crypto_sda : out std_logic;
           );
           
Kran: entity work.Crane
port map    ( -- Ports to transmit the Modulename
           name_ptr_i => name_arr(Crane_ID).name_ptr,
           name_len_o => name_arr(Crane_ID).name_len,
           name_dat_o => name_arr(Crane_ID).name_dat,
           -- Clock
           clk_i => clk_i,
           -- Switches 
           sw_i => sw_i,
           -- RGB LEDs
           ld4_o => leds_arr(Crane_ID).rgb_ld4,
           ld5_o => leds_arr(Crane_ID).rgb_ld5,
           -- Board LEDs
           leds_o => leds_arr(Crane_ID).board_leds,
           -- Board Buttons
           btn_i => btn_arr(Crane_ID),
           -- PMODs:
           pmodA_dir_o => pmod_arr(Crane_ID).pmodA_dir,
           pmodA_i => pmod_arr(Crane_ID).pmodA_i,
           pmodA_o => pmod_arr(Crane_ID).pmodA_o,
           
           pmodB_dir_o => pmod_arr(Crane_ID).pmodB_dir,
           pmodB_i => pmod_arr(Crane_ID).pmodB_i,
           pmodB_o => pmod_arr(Crane_ID).pmodB_o,
           
           pmodC_dir_o => pmod_arr(Crane_ID).pmodC_dir,
           pmodC_i => pmod_arr(Crane_ID).pmodC_i, -- Bei 8 Signalen lassen
           pmodC_o => pmod_arr(Crane_ID).pmodC_o,
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
           -- Audio Out:
           aud_pwm_o => audio_arr(Crane_ID).aud_pwm,
           aud_sd_o => audio_arr(Crane_ID).aud_sd,

           -- Mic Input
           m_clk_o => mic_arr(Crane_ID),
           m_data_i => m_data_i,

           
--           -- HDMI Rx
--           hdmi_rx_cec : inout std_logic;
--           hdmi_rx_clk_n : in std_logic;
--           hdmi_rx_clk_p : in std_logic;
--           hdmi_rx_d_n : in std_logic_vector(2 downto 0);
--           hdmi_rx_d_p : in std_logic_vector(2 downto 0);
--           hdmi_rx_hpd : out std_logic;
--           hdmi_rx_scl : inout std_logic;
--           hdmi_rx_sda : inout std_logic;

--           -- HDMI Tx
--           hdmi_tx_cec : inout std_logic;
--           hdmi_tx_clk_n : out std_logic;
--           hdmi_tx_clk_p : out std_logic;
--           hdmi_tx_d_n : out std_logic_vector(2 downto 0);
--           hdmi_tx_d_p : out std_logic_vector(2 downto 0);
--           hdmi_tx_hpd : in std_logic;
--           hdmi_tx_scl : inout std_logic;
--           hdmi_tx_sda : inout std_logic;

           -- Pynq-Shield
           
           -- Jumper J15
           jumper_dir_o => jumper_arr(Crane_ID).jumper_dir,
           jumper_i => jumper_arr(Crane_ID).jumper_i,
           jumper_o => jumper_arr(Crane_ID).jumper_o,

           -- Blue LEDS
           n_leds_shield_o => leds_arr(Crane_ID).blue_leds,

            -- Switches on the shield
           n_sw_shield_i => n_sw_shield_i,

            -- Seven Segmend Displays 
           n_digit_en_o => ssds_arr(Crane_ID).digit_en,
           n_segments_o => ssds_arr(Crane_ID).segments,

            -- PS2 Interface
           ps2_1_dir_o => ps2_arr(Crane_ID).ps2_1_dir,
           ps2_1_data_i => ps2_arr(Crane_ID).ps2_1_data_i,
           ps2_1_data_o => ps2_arr(Crane_ID).ps2_1_data_o,
           ps2_1_clk_i => ps2_arr(Crane_ID).ps2_1_clk_i,
           ps2_1_clk_o => ps2_arr(Crane_ID).ps2_1_clk_o,
           
           ps2_2_dir_o => ps2_arr(Crane_ID).ps2_2_dir,
           ps2_2_data_i => ps2_arr(Crane_ID).ps2_2_data_i,
           ps2_2_data_o => ps2_arr(Crane_ID).ps2_2_data_o,
           ps2_2_clk_i => ps2_arr(Crane_ID).ps2_2_clk_i,
           ps2_2_clk_o => ps2_arr(Crane_ID).ps2_2_clk_o

            -- Chip-Kit Ports: 
            -- (Use only when the shield is not connected. Note, that you have 
            -- to change connections in the TopLevel design, and you have to comment out the 
            -- corresponding ports above. Make sure, you know what you are doing when using these
            -- connections. 
           --ck_an_n : inout std_logic_vector (5 downto 0);
           --ck_an_p : inout std_logic_vector (5 downto 0);
           --ck_io : inout std_logic_vector (42 downto 0);

            -- ChipKit SPI
            --ck_miso_i : in std_logic;
            --ck_mosi_o : out std_logic;
            --ck_sck_o : out std_logic;
            --ck_ss : out std_logic;
            
            -- ChipKit I2C
            --ck_scl : out std_logic;
            --ck_sda : inout std_logic;
            
            -- Crypto SDA 
            --crypto_sda : out std_logic;
           );

Menu: entity work.ControlMenu
generic map (SysClock => 125000000,
             MovEn => 2,
             DigitEn => 1000,
             CHAR_WIDTH => CHAR_WIDTH,
             num_of_modules => NUM_OF_MODULES)
port map ( clk_i => clk_i,
           rst_i => btn_i(3),
           demo_i => sw_i(1),
           start_i => btn_arr(Menu_ID)(2),
           btnUP_i => btn_arr(Menu_ID)(0),
           btnDown_i => btn_arr(Menu_ID)(1),
           mux_en_o => mux_en,
           mux_sel_o => mux_sel,
           name_ptr_o => name_arr(Menu_ID).name_ptr,
           name_ptr_i => name_arr(Menu_ID).name_ptr,
           name_len_i => name_arr(Menu_ID).name_len,
           name_dat_i => name_arr(Menu_ID).name_dat,
           segments_o => ssds_arr(Menu_ID).segments,
           digit_o => ssds_arr(Menu_ID).digit_en);

InputT: entity work.InputTest
port map    ( -- Ports to transmit the Modulename
           name_ptr_i => name_arr(Input_ID).name_ptr,
           name_len_o => name_arr(Input_ID).name_len,
           name_dat_o => name_arr(Input_ID).name_dat,
           -- Clock
           clk_i => clk_i,
           -- Switches 
           sw_i => sw_i,
           -- RGB LEDs
           ld4_o => leds_arr(Input_ID).rgb_ld4,
           ld5_o => leds_arr(Input_ID).rgb_ld5,
           -- Board LEDs
           leds_o => leds_arr(Input_ID).board_leds,
           -- Board Buttons
           btn_i => btn_i,
           -- PMODs:
           pmodA_dir_o => pmod_arr(Input_ID).pmodA_dir,
           pmodA_i => pmod_arr(Input_ID).pmodA_i,
           pmodA_o => pmod_arr(Input_ID).pmodA_o,
           
           pmodB_dir_o => pmod_arr(Input_ID).pmodB_dir,
           pmodB_i => pmod_arr(Input_ID).pmodB_i,
           pmodB_o => pmod_arr(Input_ID).pmodB_o,
           
           pmodC_dir_o => pmod_arr(Input_ID).pmodC_dir,
           pmodC_i => pmod_arr(Input_ID).pmodC_i, -- Bei 8 Signalen lassen
           pmodC_o => pmod_arr(Input_ID).pmodC_o,
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
           -- Audio Out:
           aud_pwm_o => audio_arr(Input_ID).aud_pwm,
           aud_sd_o => audio_arr(Input_ID).aud_sd,

           -- Mic Input
           m_clk_o => mic_arr(Input_ID),
           m_data_i => m_data_i,

           
--           -- HDMI Rx
--           hdmi_rx_cec : inout std_logic;
--           hdmi_rx_clk_n : in std_logic;
--           hdmi_rx_clk_p : in std_logic;
--           hdmi_rx_d_n : in std_logic_vector(2 downto 0);
--           hdmi_rx_d_p : in std_logic_vector(2 downto 0);
--           hdmi_rx_hpd : out std_logic;
--           hdmi_rx_scl : inout std_logic;
--           hdmi_rx_sda : inout std_logic;

--           -- HDMI Tx
--           hdmi_tx_cec : inout std_logic;
--           hdmi_tx_clk_n : out std_logic;
--           hdmi_tx_clk_p : out std_logic;
--           hdmi_tx_d_n : out std_logic_vector(2 downto 0);
--           hdmi_tx_d_p : out std_logic_vector(2 downto 0);
--           hdmi_tx_hpd : in std_logic;
--           hdmi_tx_scl : inout std_logic;
--           hdmi_tx_sda : inout std_logic;

           -- Pynq-Shield
           
           -- Jumper J15
           jumper_dir_o => jumper_arr(Input_ID).jumper_dir,
           jumper_i => jumper_arr(Input_ID).jumper_i,
           jumper_o => jumper_arr(Input_ID).jumper_o,

           -- Blue LEDS
           n_leds_shield_o => leds_arr(Input_ID).blue_leds,

            -- Switches on the shield
           n_sw_shield_i => n_sw_shield_i,

            -- Seven Segmend Displays 
           n_digit_en_o => ssds_arr(Input_ID).digit_en,
           n_segments_o => ssds_arr(Input_ID).segments,

            -- PS2 Interface
           ps2_1_dir_o => ps2_arr(Input_ID).ps2_1_dir,
           ps2_1_data_i => ps2_arr(Input_ID).ps2_1_data_i,
           ps2_1_data_o => ps2_arr(Input_ID).ps2_1_data_o,
           ps2_1_clk_i => ps2_arr(Input_ID).ps2_1_clk_i,
           ps2_1_clk_o => ps2_arr(Input_ID).ps2_1_clk_o,
           
           ps2_2_dir_o => ps2_arr(Input_ID).ps2_2_dir,
           ps2_2_data_i => ps2_arr(Input_ID).ps2_2_data_i,
           ps2_2_data_o => ps2_arr(Input_ID).ps2_2_data_o,
           ps2_2_clk_i => ps2_arr(Input_ID).ps2_2_clk_i,
           ps2_2_clk_o => ps2_arr(Input_ID).ps2_2_clk_o

            -- Chip-Kit Ports: 
            -- (Use only when the shield is not connected. Note, that you have 
            -- to change connections in the TopLevel design, and you have to comment out the 
            -- corresponding ports above. Make sure, you know what you are doing when using these
            -- connections. 
           --ck_an_n : inout std_logic_vector (5 downto 0);
           --ck_an_p : inout std_logic_vector (5 downto 0);
           --ck_io : inout std_logic_vector (42 downto 0);

            -- ChipKit SPI
            --ck_miso_i : in std_logic;
            --ck_mosi_o : out std_logic;
            --ck_sck_o : out std_logic;
            --ck_ss : out std_logic;
            
            -- ChipKit I2C
            --ck_scl : out std_logic;
            --ck_sda : inout std_logic;
            
            -- Crypto SDA 
            --crypto_sda : out std_logic;
           );

--------------------------------------
-- De-Multiplexers and Multiplexers --
--------------------------------------

-- De-Multiplexer and Multiplexer for names
name_arr(to_integer(unsigned(mux_sel))).name_ptr <= name_arr(Menu_ID).name_ptr;
name_arr(Menu_ID).name_len <= name_arr(to_integer(unsigned(mux_sel))).name_len;
name_arr(Menu_ID).name_dat <= name_arr(to_integer(unsigned(mux_sel))).name_dat;

-- Multiplexer for LED-Signals
ld4_o <= leds_arr(to_integer(unsigned(mux_sel))).rgb_ld4;
ld5_o <= leds_arr(to_integer(unsigned(mux_sel))).rgb_ld5;
leds_o <= leds_arr(to_integer(unsigned(mux_sel))).board_leds;
n_leds_shield_o <= leds_arr(to_integer(unsigned(mux_sel))).blue_leds;

-- Disabling Mux for SSD when no Application is selected.
with mux_en select
mux_sel_temp <= "00000000" when '0',
                mux_sel when others;
-- Multiplexer for Seven Segment Signals
n_segments_o <= ssds_arr(to_integer(unsigned(mux_sel_temp))).segments; -- ToDo: Fix this Shit!!! Hopefully Fixed!
n_digit_en_o <= ssds_arr(to_integer(unsigned(mux_sel_temp))).digit_en; -- ToDo: Fix this Shit!!! Hopefully Fixed!

-- De-Multiplexer for Buttons
btn_arr(to_integer(unsigned(mux_sel_temp))) <= btn_i;

-- Microphone Clk
m_clk_o <= mic_arr(to_integer(unsigned(mux_sel)));

-- Onboard Audio
aud_pwm_o <= audio_arr(to_integer(unsigned(mux_sel))).aud_pwm;
aud_sd_o <= audio_arr(to_integer(unsigned(mux_sel))).aud_sd;

-- Pmod
A:for i in 0 to PMOD_WIDTH-1 generate
    with pmod_arr(to_integer(unsigned(mux_sel))).pmodA_dir(i) select
        pmodA(i) <= 'Z' when '0', 
                    pmod_arr(to_integer(unsigned(mux_sel))).pmodA_o(i) when others;
                        
    with pmod_arr(to_integer(unsigned(mux_sel))).pmodA_dir(i) select
        pmod_arr(to_integer(unsigned(mux_sel))).pmodA_i(i) <= pmodA(i) when '0',
                                                              '0' when others;
end generate;             

B:for i in 0 to PMOD_WIDTH-1 generate
    with pmod_arr(to_integer(unsigned(mux_sel))).pmodB_dir(i) select
        pmodB(i) <= 'Z' when '0', 
                    pmod_arr(to_integer(unsigned(mux_sel))).pmodB_o(i) when others;
                        
    with pmod_arr(to_integer(unsigned(mux_sel))).pmodB_dir(i) select
        pmod_arr(to_integer(unsigned(mux_sel))).pmodB_i(i) <= pmodB(i) when '0',
                                                              '0' when others;
end generate;      

C:for i in 0 to PMOD_WIDTH-1 generate
    with pmod_arr(to_integer(unsigned(mux_sel))).pmodC_dir(i) select
        pmodC(i) <= 'Z' when '0', 
                    pmod_arr(to_integer(unsigned(mux_sel))).pmodC_o(i) when others;
                        
    with pmod_arr(to_integer(unsigned(mux_sel))).pmodC_dir(i) select
        pmod_arr(to_integer(unsigned(mux_sel))).pmodC_i(i) <= pmodC(i) when '0',
                                                              '0' when others;
end generate;      


-- PS2
-- Port 1
with ps2_arr(to_integer(unsigned(mux_sel))).ps2_1_dir(0) select
    ps2_1_clk <= ps2_arr(to_integer(unsigned(mux_sel))).ps2_1_clk_o when '1', 'Z' when others;
with ps2_arr(to_integer(unsigned(mux_sel))).ps2_1_dir(0) select
    ps2_arr(to_integer(unsigned(mux_sel))).ps2_1_clk_i <= ps2_1_clk when '0', '0' when others;
with ps2_arr(to_integer(unsigned(mux_sel))).ps2_1_dir(1) select
    ps2_1_data <= ps2_arr(to_integer(unsigned(mux_sel))).ps2_1_data_o when '1', 'Z' when others;
with ps2_arr(to_integer(unsigned(mux_sel))).ps2_1_dir(1) select
    ps2_arr(to_integer(unsigned(mux_sel))).ps2_1_data_i <= ps2_1_data when '0', '0' when others;                                                          

-- Port 2
with ps2_arr(to_integer(unsigned(mux_sel))).ps2_2_dir(0) select
    ps2_2_clk <= ps2_arr(to_integer(unsigned(mux_sel))).ps2_2_clk_o when '1', 'Z' when others;
with ps2_arr(to_integer(unsigned(mux_sel))).ps2_2_dir(0) select
    ps2_arr(to_integer(unsigned(mux_sel))).ps2_2_clk_i <= ps2_2_clk when '0', '0' when others;
with ps2_arr(to_integer(unsigned(mux_sel))).ps2_2_dir(1) select
    ps2_2_data <= ps2_arr(to_integer(unsigned(mux_sel))).ps2_2_data_o when '1', 'Z' when others;
with ps2_arr(to_integer(unsigned(mux_sel))).ps2_2_dir(1) select
    ps2_arr(to_integer(unsigned(mux_sel))).ps2_2_data_i <= ps2_2_data when '0', '0' when others;          

-- Jumper
JP: for i in 0 to JUMPER_WIDTH-1 generate
    with jumper_arr(to_integer(unsigned(mux_sel))).jumper_dir(i) select
        jumper(i) <= 'Z' when '0',
                     jumper_arr(to_integer(unsigned(mux_sel))).jumper_o(i) when others;
    with jumper_arr(to_integer(unsigned(mux_sel))).jumper_dir(i) select
        jumper_arr(to_integer(unsigned(mux_sel))).jumper_i(i) <= jumper(i) when '0',
                                                                 '0' when others;
end generate;                  

-- Debug:
--b_leds_o <= sw_i & mux_sel(1 downto 0);
pmodC(10 downto 8) <= (others => '0');

end Behavioral;
