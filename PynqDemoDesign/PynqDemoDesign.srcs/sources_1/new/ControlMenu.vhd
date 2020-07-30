----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.05.2020 19:25:46
-- Design Name: 
-- Module Name: ControlMenu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.records_p.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlMenu is
    Generic (SysClock : integer := 125000000;
             MovEn : integer := 2;
             DigitEn : integer := 1000;
             CHAR_WIDTH : integer := 8;
             num_of_modules : integer := 8);
    Port ( -- Ports to transmit the Modulename
           name_ptr_o : out std_logic_vector(CHAR_WIDTH-1 downto 0);
           name_len_i : in std_logic_vector(CHAR_WIDTH-1 downto 0);
           name_dat_i : in std_logic_vector(CHAR_WIDTH-1 downto 0);
           
           -----------------------------
           -- Signals to and from IOs --
           -----------------------------
           -- Clock
           clk_i : in STD_LOGIC;
           
           -- Switches 
           --sw_i : in std_logic_vector(1 downto 0); -- (1,0)

           -- RGB LEDs
           ld4_o : out std_logic_vector(2 downto 0); -- (Red, Green, Blue)
           ld5_o : out std_logic_vector(2 downto 0); -- (Red, Green, Blue)

           -- Board LEDs
           leds_o : out std_logic_vector(3 downto 0); -- (LD3, LD2, LD1, LD0)

           -- Board Buttons
           -- btn(3) will be the Reset-Signal for the Toplevel-Control-Menu,
           -- so we strongly recomment to use btn(3) as a reset as well, or leave 
           -- it unconnected.  
           btn_i : in std_logic_vector (3 downto 0); -- (BTN3, BTN2, BTN1, BTN0)

           -- PMODs:
--         -------------------------
--         |vcc|gnd| 3 | 2 | 1 | 0 |
--         -------------------------
--         |vcc|gnd| 7 | 6 | 5 | 4 |
--         -------------------------
           pmodA_dir_o : out std_logic_vector (PMOD_WIDTH-1 downto 0);
           pmodA_i : in std_logic_vector (PMOD_WIDTH-1 downto 0);
           pmodA_o : out std_logic_vector (PMOD_WIDTH-1 downto 0);
           
           pmodB_dir_o : out std_logic_vector (PMOD_WIDTH-1 downto 0);
           pmodB_i : in std_logic_vector (PMOD_WIDTH-1 downto 0);
           pmodB_o : out std_logic_vector (PMOD_WIDTH-1 downto 0);
           
           -- When pmodC is used as pmod, only bits 7 downto 0 are used, set bits 10, 9 and 8 to '0';
           -- When pmodC is used as Audio Port:
           -- (  10  ,  9  ,   8  ,   7   ,   6   ,    5    ,   4   ,    3    ,   2   ,    1   ,   0  )
           -- (A_MODE, A_CS, A_MCK, A_DOUT, A_SCLK, A_LRCOUT, A_SDIN, A_CLKOUT, A_BCLK, A_LRCIN, A_DIN) 
           pmodC_dir_o : out std_logic_vector (PMOD_WIDTH-1 downto 0);
           pmodC_i : in std_logic_vector (PMOD_WIDTH-1 downto 0); -- Bei 8 Signalen lassen
           pmodC_o : out std_logic_vector (PMOD_WIDTH-1 downto 0);
           -- Zusätzliches Audio_Ext Signal mit 8 - 10;

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

           -- Pynq-Shield
           
           -- Jumper J15
           jumper_dir_o : out std_logic_vector(JUMPER_WIDTH-1 downto 0);
           jumper_i : in std_logic_vector (JUMPER_WIDTH-1 downto 0); --(IO_2, IO_1)
           jumper_o : out std_logic_vector (JUMPER_WIDTH-1 downto 0); --(IO_2, IO_1)

           -- Blue LEDS
           n_leds_shield_o : out std_logic_vector(7 downto 0); --(left downto right)

            -- Switches on the shield
           n_sw_shield_i : in std_logic_vector(7 downto 0); --(left downto right)

            -- Seven Segmend Displays 
           n_SSD_en_o : out std_logic_vector(7 downto 0); --(left downto right)
           n_SSD_o : out std_logic_vector(7 downto 0); --(a,b,c,d,e,f,g,dp)

            -- PS2 Interface
           ps2_1_dir_o : out std_logic_vector(1 downto 0); --(data, clk)
           ps2_1_data_i : in std_logic;
           ps2_1_data_o : out std_logic;
           ps2_1_clk_i  : in std_logic;
           ps2_1_clk_o  : out std_logic;
           
           ps2_2_dir_o : out std_logic_vector(1 downto 0); --(data, clk)
           ps2_2_data_i : in std_logic;
           ps2_2_data_o : out std_logic;
           ps2_2_clk_i  : in std_logic;
           ps2_2_clk_o  : out std_logic;

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
            mux_sel_o : out std_logic_vector(7 downto 0)
           );
end ControlMenu;

architecture Behavioral of ControlMenu is

component ClockEnableManager is
    Generic (SysClock : integer := 125000000;
             MovEn : integer := 1;
             DigitEn : integer := 1000);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           digitEn_o : out STD_LOGIC;
           movEn_o : out STD_LOGIC);
end component;

component Debouncer is
    Generic (prescaler : integer := 10000);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           signal_i : in STD_LOGIC;
           signal_o : out STD_LOGIC;
           risingedge_o : out std_logic;
           fallingedge_o : out std_logic);
end component;

component DisplayController is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_i : in STD_LOGIC;
           name_dat_i : in STD_LOGIC_VECTOR (7 downto 0);
           pointer_o : out std_logic_vector (3 downto 0);
           digit_o : out std_logic_vector (7 downto 0);
           segments_o : out std_logic_vector (7 downto 0));
end component;

component TextMover is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           enable_i : in STD_LOGIC;
           name_len_i : in STD_LOGIC_VECTOR (7 downto 0);
           pointer_i : in STD_LOGIC_VECTOR (3 downto 0);
           name_ptr_o : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component ModuleSelector is
    generic (NUM_OF_MODULES : integer := 8);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           btnUp_Edge_i : in STD_LOGIC;
           btnDown_Edge_i : in STD_LOGIC;
           number_o : out STD_LOGIC_VECTOR (7 downto 0));
end component;

-- Reset if an active High Reset is needed:
signal rst : std_logic;

-- Enable Signals
signal digit_en : std_logic;
signal move_en : std_logic;

-- Debounced Button Edge Signals
signal btn_deb_up : std_logic;
signal btn_deb_down : std_logic;

-- Mux Signals
signal mux_sel : std_logic_vector(CHAR_WIDTH-1 downto 0);
signal mux_en : std_logic := '0';

-- Module Name Signals
signal name_ptr : std_logic_vector (7 downto 0);
signal name_len : std_logic_vector (7 downto 0);
signal name_dat : std_logic_vector (7 downto 0);
signal name_datA : std_logic_vector (7 downto 0);
signal name_len_temp : std_logic_vector (7 downto 0);
signal name_dat_temp : std_logic_vector (7 downto 0);


-- Pointers 
-- pointer represents the index of a byte in an array, this pointer corresponds to the 
-- position of the digit select signal. So if the 1st digit is active, this pointer will be
-- 1, if the 2nd digit is active, this pointer will be 2 and so on.
signal pointer : std_logic_vector (3 downto 0);
-- mPointer is the pointer modified with an offset. To move the pointer through an array of
-- bytes. Maximum offset is 255 - the number of digits used. 
signal mPointer : std_logic_vector (7 downto 0);

-- Digit Select signal used for debugging, to make the Digit Select signal visible on Blue LEDS
signal dig : std_logic_vector(7 downto 0);

-- Internal example for a moving module name. 
-- https://en.wikichip.org/wiki/seven-segment_display/representing_letters
-- Name:
-- Usable Characters:
--(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
--(A, C, E, F, G, H, I, J, L, O)
--(P, S, U, a, b, c, d, h, n, o)
--(q, r, t, u, y)         
constant name_str : string := "Pynq boArd  USE btn1 And btn0 to SELECt your APPLICAtIOn";

begin

-- All Resets in this Design are Active Low, so
-- invert the reset here, if an activ High Reset is needed:
rst <= not btn_i(3);

with mux_sel select 
    name_len <= std_logic_vector(to_unsigned(name_str'length, name_len'length)) when "00000000",
                name_len_i when others;

with mux_sel select     
    name_datA <= std_logic_vector(to_unsigned(character'pos(name_str(to_integer(unsigned(name_ptr)))), 8)) when "00000000",
                name_dat_i when others;

process (name_ptr)                
begin 
    if (signed(name_ptr) < 1 or (signed(name_ptr) > signed(name_len))) then 
        name_dat <= "11111111";
    else 
        name_dat <= name_datA;
    end if;
end process; 
                
UPDebounce:Debouncer
generic map (prescaler => 10000)
port map    (clk_i => clk_i, 
             rst_i => rst,
             signal_i => btn_i(1),
             signal_o => open,
             risingedge_o => btn_deb_up,
             fallingedge_o => open);
             
DownDebounce:Debouncer
generic map (prescaler => 10000)
port map    (clk_i => clk_i, 
             rst_i => rst,
             signal_i => btn_i(0),
             signal_o => open,
             risingedge_o => btn_deb_down,
             fallingedge_o => open);

EnableSignals: ClockEnableManager
generic map ( SysClock => SysClock, 
              MovEn => MovEn,
              DigitEn => DigitEn)
port map    ( clk_i => clk_i,
              rst_i => rst,
              digitEn_o => digit_en,
              movEn_o => move_en);

Display: DisplayController
port map ( clk_i => clk_i,
           rst_i => rst,
           enable_i => digit_en,
           name_dat_i => name_dat,
           pointer_o => pointer,
           digit_o => n_SSD_en_o,
           segments_o => n_SSD_o);
           
MovingText:TextMover
port map ( clk_i => clk_i,
           rst_i => rst,
           enable_i => move_en,
           name_len_i => name_len,
           pointer_i => pointer,
           name_ptr_o => name_ptr);
           
Selector:ModuleSelector
generic map (NUM_OF_MODULES => num_of_modules)
port map( clk_i => clk_i,
          rst_i => rst,
          btnUp_Edge_i => btn_deb_up,
          btnDown_Edge_i => btn_deb_down,
          number_o => mux_sel);

mux_sel_o <= mux_sel;
name_ptr_o <= name_ptr;
n_leds_shield_o <= not mux_sel;

end Behavioral;
