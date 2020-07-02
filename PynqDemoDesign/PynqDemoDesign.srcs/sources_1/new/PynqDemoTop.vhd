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
           n_SSD_en_o : out std_logic_vector(7 downto 0); --(left downto right)
           n_SSD_o : out std_logic_vector(7 downto 0); --(a,b,c,d,e,f,g,dp)

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
constant NUM_OF_MODULES : integer := 5;

-- Module IDs:
constant Menu_ID : integer := 0;
constant Pong_ID : integer := 1;
constant Crane_ID : integer := 2;
constant Input_ID : integer := 3;
constant Light_ID : integer := 4;


-- Connections at Mux 2;
signal inter_mux_o : output_t;
signal inter_mux_i : input_t;
signal mux_to_out : output_t;
signal in_to_mux : input_t;
signal menu_to_mux : output_t;
signal mux_to_menu : input_t;
signal base_to_mux : output_t;
signal mux_to_base : input_t;
signal tbd_to_mux : output_t;
signal mux_to_tbd : input_t;

-- Select Signal for MUX
signal mux_sel : std_logic_vector(CHAR_WIDTH-1 downto 0);

-- Signal Arrays:
type output_arr_t is array (0 to NUM_OF_MODULES-1) of output_t;
signal output_arr : output_arr_t;

type input_arr_t is array (0 to NUM_OF_MODULES-1) of input_t;
signal input_arr : input_arr_t;

type name_arr_t is array (0 to NUM_OF_MODULES-1) of name_t;
signal name_arr : name_arr_t;

begin

Menu: entity work.ControlMenu
generic map (SysClock => 125000000,
             MovEn => 5,
             DigitEn => 1000,
             CHAR_WIDTH => CHAR_WIDTH,
             num_of_modules => NUM_OF_MODULES)
port map (  -- Ports to transmit the Modulename
           name_ptr_o => name_arr(Menu_ID).name_ptr,
           name_len_i => name_arr(Menu_ID).name_len,
           name_dat_i => name_arr(Menu_ID).name_dat,
                      -- Clock
           clk_i => clk_i,
           -- Switches 
           -- sw_i => sw_i,
           -- RGB LEDs
           ld4_o => menu_to_mux.rgb_ld4,
           ld5_o => menu_to_mux.rgb_ld5,
           -- Board LEDs
           leds_o => menu_to_mux.leds,
           -- Board Buttons
           btn_i => mux_to_menu.btn,
           -- PMODs:
           pmodA_dir_o => menu_to_mux.pmodA_dir,
           pmodA_i => mux_to_menu.pmodA,
           pmodA_o => menu_to_mux.pmodA,
           
           pmodB_dir_o => menu_to_mux.pmodB_dir,
           pmodB_i => mux_to_menu.pmodB,
           pmodB_o => menu_to_mux.pmodB,
           
           pmodC_dir_o => menu_to_mux.pmodC_dir,
           pmodC_i => mux_to_menu.pmodC, -- Bei 8 Signalen lassen
           pmodC_o => menu_to_mux.pmodC,
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
           -- Audio Out:
           aud_pwm_o => menu_to_mux.aud_pwm,
           aud_sd_o => menu_to_mux.aud_sd,

           -- Mic Input
           m_clk_o => menu_to_mux.mic_clk,
           m_data_i => mux_to_menu.m_data,

           
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
           jumper_dir_o => menu_to_mux.jumper_dir,
           jumper_i => mux_to_menu.jumper,
           jumper_o => menu_to_mux.jumper,

           -- Blue LEDS
           n_leds_shield_o => menu_to_mux.n_shield_leds,

            -- Switches on the shield
           n_sw_shield_i => mux_to_menu.n_sw_shield,

            -- Seven Segmend Displays 
           n_SSD_en_o => menu_to_mux.n_SSD_en,
           n_SSD_o => menu_to_mux.n_SSD,

            -- PS2 Interface
           ps2_1_dir_o => menu_to_mux.ps2_1_dir,
           ps2_1_data_i => mux_to_menu.ps2_1_data,
           ps2_1_data_o => menu_to_mux.ps2_1_data,
           ps2_1_clk_i => mux_to_menu.ps2_1_clk,
           ps2_1_clk_o => menu_to_mux.ps2_1_clk,
           
           ps2_2_dir_o => menu_to_mux.ps2_2_dir,
           ps2_2_data_i => mux_to_menu.ps2_2_data,
           ps2_2_data_o => menu_to_mux.ps2_2_data,
           ps2_2_clk_i => mux_to_menu.ps2_2_clk,
           ps2_2_clk_o => menu_to_mux.ps2_2_clk,

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
            mux_sel_o => mux_sel
           );


Pong: entity work.Pong
port map    ( -- Ports to transmit the Modulename
           name_ptr_i => name_arr(Pong_ID).name_ptr,
           name_len_o => name_arr(Pong_ID).name_len,
           name_dat_o => name_arr(Pong_ID).name_dat,
           -- Clock
           clk_i => clk_i,
           -- Switches 
           -- sw_i => sw_i,
           -- RGB LEDs
           ld4_o => output_arr(Pong_ID).rgb_ld4,
           ld5_o => output_arr(Pong_ID).rgb_ld5,
           -- Board LEDs
           leds_o => output_arr(Pong_ID).leds,
           -- Board Buttons
           btn_i => input_arr(Pong_ID).btn,
           -- PMODs:
           pmodA_dir_o => output_arr(Pong_ID).pmodA_dir,
           pmodA_i => input_arr(Pong_ID).pmodA,
           pmodA_o => output_arr(Pong_ID).pmodA,
           
           pmodB_dir_o => output_arr(Pong_ID).pmodB_dir,
           pmodB_i => input_arr(Pong_ID).pmodB,
           pmodB_o => output_arr(Pong_ID).pmodB,
           
           pmodC_dir_o => output_arr(Pong_ID).pmodC_dir,
           pmodC_i => input_arr(Pong_ID).pmodC, -- Bei 8 Signalen lassen
           pmodC_o => output_arr(Pong_ID).pmodC,
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
           -- Audio Out:
           aud_pwm_o => output_arr(Pong_ID).aud_pwm,
           aud_sd_o => output_arr(Pong_ID).aud_sd,

           -- Mic Input
           m_clk_o => output_arr(Pong_ID).mic_clk,
           m_data_i => input_arr(Pong_ID).m_data,

           
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
           jumper_dir_o => output_arr(Pong_ID).jumper_dir,
           jumper_i => input_arr(Pong_ID).jumper,
           jumper_o => output_arr(Pong_ID).jumper,

           -- Blue LEDS
           n_leds_shield_o => output_arr(Pong_ID).n_shield_leds,

            -- Switches on the shield
           n_sw_shield_i => input_arr(Pong_ID).n_sw_shield,

            -- Seven Segmend Displays 
           n_SSD_en_o => output_arr(Pong_ID).n_SSD_en,
           n_SSD_o => output_arr(Pong_ID).n_SSD,

            -- PS2 Interface
           ps2_1_dir_o => output_arr(Pong_ID).ps2_1_dir,
           ps2_1_data_i => input_arr(Pong_ID).ps2_1_data,
           ps2_1_data_o => output_arr(Pong_ID).ps2_1_data,
           ps2_1_clk_i => input_arr(Pong_ID).ps2_1_clk,
           ps2_1_clk_o => output_arr(Pong_ID).ps2_1_clk,
           
           ps2_2_dir_o => output_arr(Pong_ID).ps2_2_dir,
           ps2_2_data_i => input_arr(Pong_ID).ps2_2_data,
           ps2_2_data_o => output_arr(Pong_ID).ps2_2_data,
           ps2_2_clk_i => input_arr(Pong_ID).ps2_2_clk,
           ps2_2_clk_o => output_arr(Pong_ID).ps2_2_clk

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
           -- sw_i => sw_i,
           -- RGB LEDs
           ld4_o => output_arr(Crane_ID).rgb_ld4,
           ld5_o => output_Arr(Crane_ID).rgb_ld5,
           -- Board LEDs
           leds_o => output_arr(Crane_ID).leds,
           -- Board Buttons
           btn_i => input_arr(Crane_ID).btn,
           -- PMODs:
           pmodA_dir_o => output_arr(Crane_ID).pmodA_dir,
           pmodA_i => input_arr(Crane_ID).pmodA,
           pmodA_o => output_arr(Crane_ID).pmodA,
           
           pmodB_dir_o => output_arr(Crane_ID).pmodB_dir,
           pmodB_i => input_arr(Crane_ID).pmodB,
           pmodB_o => output_arr(Crane_ID).pmodB,
           
           pmodC_dir_o => output_arr(Crane_ID).pmodC_dir,
           pmodC_i => input_arr(Crane_ID).pmodC, -- Bei 8 Signalen lassen
           pmodC_o => output_arr(Crane_ID).pmodC,
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
           -- Audio Out:
           aud_pwm_o => output_arr(Crane_ID).aud_pwm,
           aud_sd_o => output_arr(Crane_ID).aud_sd,

           -- Mic Input
           m_clk_o => output_arr(Crane_ID).mic_clk,
           m_data_i => input_arr(Crane_ID).m_data,

           
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
           jumper_dir_o => output_arr(Crane_ID).jumper_dir,
           jumper_i => input_arr(Crane_ID).jumper,
           jumper_o => output_arr(Crane_ID).jumper,

           -- Blue LEDS
           n_leds_shield_o => output_arr(Crane_ID).n_shield_leds,

            -- Switches on the shield
           n_sw_shield_i => input_arr(Crane_ID).n_sw_shield,

            -- Seven Segmend Displays 
           n_digit_en_o => output_arr(Crane_ID).n_SSD_en,
           n_segments_o => output_arr(Crane_ID).n_SSD,

            -- PS2 Interface
           ps2_1_dir_o => output_arr(Crane_ID).ps2_1_dir,
           ps2_1_data_i => input_arr(Crane_ID).ps2_1_data,
           ps2_1_data_o => output_arr(Crane_ID).ps2_1_data,
           ps2_1_clk_i => input_arr(Crane_ID).ps2_1_clk,
           ps2_1_clk_o => output_arr(Crane_ID).ps2_1_clk,
           
           ps2_2_dir_o => output_arr(Crane_ID).ps2_2_dir,
           ps2_2_data_i => input_arr(Crane_ID).ps2_2_data,
           ps2_2_data_o => output_arr(Crane_ID).ps2_2_data,
           ps2_2_clk_i => input_arr(Crane_ID).ps2_2_clk,
           ps2_2_clk_o => output_arr(Crane_ID).ps2_2_clk

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
           
MovingLight: entity work.Lauflicht
port map    ( -- Ports to transmit the Modulename
           name_ptr_i => name_arr(Light_ID).name_ptr,
           name_len_o => name_arr(Light_ID).name_len,
           name_dat_o => name_arr(Light_ID).name_dat,
           -- Clock
           clk_i => clk_i,
           -- Switches 
           -- sw_i => sw_i,
           -- RGB LEDs
           ld4_o => output_arr(Light_ID).rgb_ld4,
           ld5_o => output_Arr(Light_ID).rgb_ld5,
           -- Board LEDs
           leds_o => output_arr(Light_ID).leds,
           -- Board Buttons
           btn_i => input_arr(Light_ID).btn,
           -- PMODs:
           pmodA_dir_o => output_arr(Light_ID).pmodA_dir,
           pmodA_i => input_arr(Light_ID).pmodA,
           pmodA_o => output_arr(Light_ID).pmodA,
           
           pmodB_dir_o => output_arr(Light_ID).pmodB_dir,
           pmodB_i => input_arr(Light_ID).pmodB,
           pmodB_o => output_arr(Light_ID).pmodB,
           
           pmodC_dir_o => output_arr(Light_ID).pmodC_dir,
           pmodC_i => input_arr(Light_ID).pmodC, -- Bei 8 Signalen lassen
           pmodC_o => output_arr(Light_ID).pmodC,
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
           -- Audio Out:
           aud_pwm_o => output_arr(Light_ID).aud_pwm,
           aud_sd_o => output_arr(Light_ID).aud_sd,

           -- Mic Input
           m_clk_o => output_arr(Light_ID).mic_clk,
           m_data_i => input_arr(Light_ID).m_data,

           
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
           jumper_dir_o => output_arr(Light_ID).jumper_dir,
           jumper_i => input_arr(Light_ID).jumper,
           jumper_o => output_arr(Light_ID).jumper,

           -- Blue LEDS
           n_leds_shield_o => output_arr(Light_ID).n_shield_leds,

            -- Switches on the shield
           n_sw_shield_i => input_arr(Light_ID).n_sw_shield,

            -- Seven Segmend Displays 
           n_digit_en_o => output_arr(Light_ID).n_SSD_en,
           n_segments_o => output_arr(Light_ID).n_SSD,

            -- PS2 Interface
           ps2_1_dir_o => output_arr(Light_ID).ps2_1_dir,
           ps2_1_data_i => input_arr(Light_ID).ps2_1_data,
           ps2_1_data_o => output_arr(Light_ID).ps2_1_data,
           ps2_1_clk_i => input_arr(Light_ID).ps2_1_clk,
           ps2_1_clk_o => output_arr(Light_ID).ps2_1_clk,
           
           ps2_2_dir_o => output_arr(Light_ID).ps2_2_dir,
           ps2_2_data_i => input_arr(Light_ID).ps2_2_data,
           ps2_2_data_o => output_arr(Light_ID).ps2_2_data,
           ps2_2_clk_i => input_arr(Light_ID).ps2_2_clk,
           ps2_2_clk_o => output_arr(Light_ID).ps2_2_clk

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

--InputT: entity work.InputTest
--port map    ( -- Ports to transmit the Modulename
--           name_ptr_i => name_arr(Input_ID).name_ptr,
--           name_len_o => name_arr(Input_ID).name_len,
--           name_dat_o => name_arr(Input_ID).name_dat,
--           -- Clock
--           clk_i => clk_i,
--           -- Switches 
--           sw_i => sw_i,
--           -- RGB LEDs
--           ld4_o => leds_arr(Input_ID).rgb_ld4,
--           ld5_o => leds_arr(Input_ID).rgb_ld5,
--           -- Board LEDs
--           leds_o => leds_arr(Input_ID).board_leds,
--           -- Board Buttons
--           btn_i => btn_i,
--           -- PMODs:
--           pmodA_dir_o => pmod_arr(Input_ID).pmodA_dir,
--           pmodA_i => pmod_arr(Input_ID).pmodA_i,
--           pmodA_o => pmod_arr(Input_ID).pmodA_o,
           
--           pmodB_dir_o => pmod_arr(Input_ID).pmodB_dir,
--           pmodB_i => pmod_arr(Input_ID).pmodB_i,
--           pmodB_o => pmod_arr(Input_ID).pmodB_o,
           
--           pmodC_dir_o => pmod_arr(Input_ID).pmodC_dir,
--           pmodC_i => pmod_arr(Input_ID).pmodC_i, -- Bei 8 Signalen lassen
--           pmodC_o => pmod_arr(Input_ID).pmodC_o,
--           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
--           -- Audio Out:
--           aud_pwm_o => audio_arr(Input_ID).aud_pwm,
--           aud_sd_o => audio_arr(Input_ID).aud_sd,

--           -- Mic Input
--           m_clk_o => mic_arr(Input_ID),
--           m_data_i => m_data_i,

           
----           -- HDMI Rx
----           hdmi_rx_cec : inout std_logic;
----           hdmi_rx_clk_n : in std_logic;
----           hdmi_rx_clk_p : in std_logic;
----           hdmi_rx_d_n : in std_logic_vector(2 downto 0);
----           hdmi_rx_d_p : in std_logic_vector(2 downto 0);
----           hdmi_rx_hpd : out std_logic;
----           hdmi_rx_scl : inout std_logic;
----           hdmi_rx_sda : inout std_logic;

----           -- HDMI Tx
----           hdmi_tx_cec : inout std_logic;
----           hdmi_tx_clk_n : out std_logic;
----           hdmi_tx_clk_p : out std_logic;
----           hdmi_tx_d_n : out std_logic_vector(2 downto 0);
----           hdmi_tx_d_p : out std_logic_vector(2 downto 0);
----           hdmi_tx_hpd : in std_logic;
----           hdmi_tx_scl : inout std_logic;
----           hdmi_tx_sda : inout std_logic;

--           -- Pynq-Shield
           
--           -- Jumper J15
--           jumper_dir_o => jumper_arr(Input_ID).jumper_dir,
--           jumper_i => jumper_arr(Input_ID).jumper_i,
--           jumper_o => jumper_arr(Input_ID).jumper_o,

--           -- Blue LEDS
--           n_leds_shield_o => leds_arr(Input_ID).blue_leds,

--            -- Switches on the shield
--           n_sw_shield_i => n_sw_shield_i,

--            -- Seven Segmend Displays 
--           n_digit_en_o => ssds_arr(Input_ID).digit_en,
--           n_segments_o => ssds_arr(Input_ID).segments,

--            -- PS2 Interface
--           ps2_1_dir_o => ps2_arr(Input_ID).ps2_1_dir,
--           ps2_1_data_i => ps2_arr(Input_ID).ps2_1_data_i,
--           ps2_1_data_o => ps2_arr(Input_ID).ps2_1_data_o,
--           ps2_1_clk_i => ps2_arr(Input_ID).ps2_1_clk_i,
--           ps2_1_clk_o => ps2_arr(Input_ID).ps2_1_clk_o,
           
--           ps2_2_dir_o => ps2_arr(Input_ID).ps2_2_dir,
--           ps2_2_data_i => ps2_arr(Input_ID).ps2_2_data_i,
--           ps2_2_data_o => ps2_arr(Input_ID).ps2_2_data_o,
--           ps2_2_clk_i => ps2_arr(Input_ID).ps2_2_clk_i,
--           ps2_2_clk_o => ps2_arr(Input_ID).ps2_2_clk_o

--            -- Chip-Kit Ports: 
--            -- (Use only when the shield is not connected. Note, that you have 
--            -- to change connections in the TopLevel design, and you have to comment out the 
--            -- corresponding ports above. Make sure, you know what you are doing when using these
--            -- connections. 
--           --ck_an_n : inout std_logic_vector (5 downto 0);
--           --ck_an_p : inout std_logic_vector (5 downto 0);
--           --ck_io : inout std_logic_vector (42 downto 0);

--            -- ChipKit SPI
--            --ck_miso_i : in std_logic;
--            --ck_mosi_o : out std_logic;
--            --ck_sck_o : out std_logic;
--            --ck_ss : out std_logic;
            
--            -- ChipKit I2C
--            --ck_scl : out std_logic;
--            --ck_sda : inout std_logic;
            
--            -- Crypto SDA 
--            --crypto_sda : out std_logic;
--           );

Basic: entity work.BasicTest
port map    ( -- Ports to transmit the Modulename
           name_ptr_i => (others=>'0'), --name_arr(Basic_ID).name_ptr,
           name_len_o => open,--name_arr(Basic_ID).name_len,
           name_dat_o => open,--name_arr(Basic_ID).name_dat,
           -- Clock
           clk_i => clk_i,
           -- Switches 
           --sw_i => sw_i,
           -- RGB LEDs
           ld4_o => base_to_mux.rgb_ld4,
           ld5_o => base_to_mux.rgb_ld5,
           -- Board LEDs
           leds_o => base_to_mux.leds,
           -- Board Buttons
           btn_i => btn_i,
           -- PMODs:
           pmodA_dir_o => base_to_mux.pmodA_dir,
           pmodA_i => mux_to_base.pmodA,
           pmodA_o => base_to_mux.pmodA,
           
           pmodB_dir_o => base_to_mux.pmodB_dir,
           pmodB_i => mux_to_base.pmodB,
           pmodB_o => base_to_mux.pmodB,
           
           pmodC_dir_o => base_to_mux.pmodC_dir,
           pmodC_i => mux_to_base.pmodC, -- Bei 8 Signalen lassen
           pmodC_o => base_to_mux.pmodC,
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;
           -- Audio Out:
           aud_pwm_o => base_to_mux.aud_pwm,
           aud_sd_o => base_to_mux.aud_sd,

           -- Mic Input
           m_clk_o => base_to_mux.mic_clk,
           m_data_i => mux_to_base.m_data,

           
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
           jumper_dir_o => base_to_mux.jumper_dir,
           jumper_i => mux_to_base.jumper,
           jumper_o => base_to_mux.jumper,

           -- Blue LEDS
           n_leds_shield_o => base_to_mux.n_shield_leds,

            -- Switches on the shield
           n_sw_shield_i => mux_to_base.n_sw_shield,

            -- Seven Segmend Displays 
           n_digit_en_o => base_to_mux.n_SSD_en,
           n_segments_o => base_to_mux.n_SSD,

            -- PS2 Interface
           ps2_1_dir_o => base_to_mux.ps2_1_dir,
           ps2_1_data_i => mux_to_base.ps2_1_data,
           ps2_1_data_o => base_to_mux.ps2_1_data,
           ps2_1_clk_i => mux_to_base.ps2_1_clk,
           ps2_1_clk_o => base_to_mux.ps2_1_clk,
           
           ps2_2_dir_o => base_to_mux.ps2_2_dir,
           ps2_2_data_i => mux_to_base.ps2_2_data,
           ps2_2_data_o => base_to_mux.ps2_2_data,
           ps2_2_clk_i => mux_to_base.ps2_2_clk,
           ps2_2_clk_o => base_to_mux.ps2_2_clk

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

---- Debug:
----b_leds_o <= sw_i & mux_sel(1 downto 0);
pmodC(10 downto 8) <= (others => '0');

--------------------------------------------
-- Mux 1 -- To switch between the modules --
--------------------------------------------

-- This Mux/Demux is controlled by the controlmenue, it connected the selected 
-- project to Mux 2.
inter_mux_o <= output_arr(to_integer(unsigned(mux_sel)));
input_arr(to_integer(unsigned(mux_sel))) <= inter_mux_i;

-- Mux to display the selected project name on the SSD
name_arr(to_integer(unsigned(mux_sel))).name_ptr <= name_arr(Menu_ID).name_ptr;
name_arr(Menu_ID).name_len <= name_arr(to_integer(unsigned(mux_sel))).name_len;
name_arr(Menu_ID).name_dat <= name_arr(to_integer(unsigned(mux_sel))).name_dat;

-------------------------
-- Mux 2 -- In-/Output --
-------------------------

-- This Mux/Demux is controlled by sw0 and sw1 on the Pynq-Board. It can select: 
-- 1. (00) A basic test, which connects the switches and buttons to LEDs and creates a basic 
-- display output.  
-- 2. (01) A controll menue which allows the user to switch between all projects stored on
-- the pynq board. 
-- 3. (10) Something else (tbd). 
-- 4. (11) The project which is selected by the control menue.
with sw_i select 
mux_to_out <= base_to_mux when "00",
              menu_to_mux when "01", 
              tbd_to_mux when "10",
              inter_mux_o when others;  

-- Input -- (De-)Mux 2
DeMux:process(sw_i)
begin 
    if (sw_i = "00") then 
        mux_to_base <= in_to_mux;
    elsif (sw_i = "01") then 
        mux_to_menu <= in_to_mux;
    elsif (sw_i = "10") then 
        mux_to_tbd <= in_to_mux;
    else 
        inter_mux_i <= in_to_mux;
    end if;
end process;


------------------------------------------------------------------------
-- Connections between Mux 2 and the in- and output-pins of the FPGA. --
------------------------------------------------------------------------

-------------
-- Outputs --
-------------

-- RGB LEDs
ld4_o <= mux_to_out.rgb_ld4;
ld5_o <= mux_to_out.rgb_ld5;

-- Board LEDs
leds_o <= mux_to_out.leds;

-- Audio Out:
aud_pwm_o <= mux_to_out.aud_pwm;
aud_sd_o <= mux_to_out.aud_sd;

-- Blue LEDS
n_leds_shield_o <= mux_to_out.n_shield_leds;

-- SSD
n_SSD_en_o <= mux_to_out.n_SSD_en;
n_SSD_o <= mux_to_out.n_SSD;

-- Mic
m_clk_o <= mux_to_out.mic_clk;

------------
-- Inputs --
------------

-- Board Buttons
in_to_mux.btn <= btn_i; 

-- Shield Switches
in_to_mux.n_sw_shield <= n_sw_shield_i;

-- Mic
in_to_mux.m_data <= m_data_i;

------------
-- In-Out --
------------

-- PMODs
PmodA_Direction:for i in 0 to PMOD_WIDTH-1 generate
    with mux_to_out.pmodA_dir(i) select
        pmodA(i) <= 'Z' when '0', 
                    mux_to_out.pmodA(i) when others;
         
    with mux_to_out.pmodA_dir(i)select
        in_to_mux.pmodA(i) <= pmodA(i) when '0',
                                '0' when others;
end generate;

PmodB_Direction:for i in 0 to PMOD_WIDTH-1 generate
    with mux_to_out.pmodB_dir(i) select
        pmodB(i) <= 'Z' when '0', 
                    mux_to_out.pmodB(i) when others;
         
    with mux_to_out.pmodB_dir(i)select
        in_to_mux.pmodB(i) <= pmodB(i) when '0',
                                '0' when others;
end generate;

PmodC_Direction:for i in 0 to PMOD_WIDTH-1 generate
    with mux_to_out.pmodC_dir(i) select
        pmodC(i) <= 'Z' when '0', 
                    mux_to_out.pmodC(i) when others;
         
    with mux_to_out.pmodC_dir(i)select
        in_to_mux.pmodC(i) <= pmodC(i) when '0',
                                '0' when others;
end generate;

-- Jumper
Jumper_Direction:for i in 0 to JUMPER_WIDTH-1 generate
    with mux_to_out.jumper_dir(i) select
        pmodC(i) <= 'Z' when '0', 
                    mux_to_out.jumper(i) when others;
         
    with mux_to_out.jumper_dir(i)select
        in_to_mux.jumper(i) <= jumper(i) when '0',
                                '0' when others;
end generate;
          
-- PS2 (1)
    with mux_to_out.ps2_1_dir(1) select
        ps2_1_data <= 'Z' when '0', 
                       mux_to_out.ps2_1_data when others;
         
    with mux_to_out.ps2_1_dir(1) select
        in_to_mux.ps2_1_data <= ps2_1_data when '0',
                                '0' when others;

    with mux_to_out.ps2_1_dir(0) select
        ps2_1_clk <= 'Z' when '0', 
                       mux_to_out.ps2_1_clk when others;
         
    with mux_to_out.ps2_1_dir(0) select
        in_to_mux.ps2_1_clk <= ps2_1_clk when '0',
                                '0' when others;

-- PS2 (2)
    with mux_to_out.ps2_2_dir(1) select
        ps2_2_data <= 'Z' when '0', 
                       mux_to_out.ps2_2_data when others;
         
    with mux_to_out.ps2_2_dir(1) select
        in_to_mux.ps2_2_data <= ps2_2_data when '0',
                                '0' when others;

    with mux_to_out.ps2_2_dir(0) select
        ps2_2_clk <= 'Z' when '0', 
                       mux_to_out.ps2_2_clk when others;
         
    with mux_to_out.ps2_2_dir(0) select
        in_to_mux.ps2_2_clk <= ps2_2_clk when '0',
                                '0' when others;

end Behavioral;
