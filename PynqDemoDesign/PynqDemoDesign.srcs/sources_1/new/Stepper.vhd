----------------------------------------------------------------------------------
-- Company: Uni Kassel FG Digitaltechnik
-- Engineer: Benjamin Lagershausen-Keßler
-- 
-- Create Date: 13.05.2020 08:23:38
-- Design Name: Pynq Demo Base Entity
-- Module Name: ??? - Behavioral
-- Project Name: Pynq Board Demo Design
-- Target Devices: Pynq Board
-- Tool Versions: 
-- Description: This is an example entity and shows how use the Pynq Demo Design. 
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
-- Contains definitions of constants.
use work.records_p.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stepper is
    Port ( -- Ports to transmit the Modulename
           name_ptr_i : in std_logic_vector(CHAR_WIDTH-1 downto 0);
           name_len_o : out std_logic_vector(CHAR_WIDTH-1 downto 0);
           name_dat_o : out std_logic_vector(CHAR_WIDTH-1 downto 0);
           
           -----------------------------
           -- Signals to and from IOs --
           -----------------------------
           -- Clock
           clk_i : in STD_LOGIC;
           
           -- Switches 
           -- sw_i : in std_logic_vector(1 downto 0); -- (1,0)

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
           ps2_2_clk_o  : out std_logic

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
end stepper;

architecture Behavioral of stepper is

-- Name:
-- Usable Characters:
--(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
--(A, C, E, F, G, H, I, J, L, O)
--(P, S, U, a, b, c, d, h, n, o)
--(q, r, t, u, y)         
constant name_str : string := "StEPPEr";

-- Directions: (Set to 0 for Inputs, Set to 1 for Outputs)
-- These constants can configure PMOD A, PMOD B, PMOD C, Jumper and the PS2 Ports as in- or output.
-- This is done by a multiplexer in the top-level design, which either switches Tri-State-Buffer
-- at the FPGA-Pins to high-impedance or routes the output signal through those buffers.
-- Unused Ports should be set as inputs.  
constant pmodA_dir : std_logic_vector (PMOD_WIDTH-1 downto 0) := (others=> '1');
constant pmodB_dir : std_logic_vector (PMOD_WIDTH-1 downto 0) := (others => '0');
constant pmodC_dir : std_logic_vector (PMOD_WIDTH-1 downto 0) := (others => '0');
constant jumper_dir : std_logic_vector (JUMPER_WIDTH-1 downto 0) := (others => '0');
constant PS2_1_dir : std_logic_vector (1 downto 0) := (others => '0'); -- (Data, CLK)
constant PS2_2_dir : std_logic_vector (1 downto 0) := (others => '0'); -- (Data, CLK)

-- Toplevel Component of your Design:
-- In this example an implementation of the Crane Controller from sheet 5 of the VHDL-Kurs. 
component StepperTOP is
  generic (f_in : integer);
  Port ( clk_i : in std_logic;
         rst_i : in std_logic;
         direction_cw_i : in std_logic;
         half_step_i : in std_logic;
         step_frequency_i : in std_logic_vector(7 downto 0);
         stepper_o : out std_logic_vector(3 downto 0));
end component;

signal StepperControl : std_logic_vector(3 downto 0);

begin

-- Name Transmission:
name_len_o <= std_logic_vector(to_unsigned(name_str'length, name_len_o'length));
name_dat_o <= std_logic_vector(to_unsigned(character'pos(name_str(to_integer(unsigned(name_ptr_i)))), 8));

-- I/O Directions:
pmodA_dir_o <= pmodA_dir;
pmodB_dir_o <= pmodB_dir;
pmodC_dir_o <= pmodC_dir;
jumper_dir_o <= jumper_dir;
PS2_1_dir_o <= PS2_1_dir;
PS2_2_dir_o <= PS2_2_dir;

-- Instantiation of the toplevelmodule of your Design:
Toplevel:StepperTOP
generic map (f_in => 125000000)
port map (clk_i => clk_i,
          rst_i => btn_i(3),
          direction_cw_i => btn_i(0),
          half_step_i => btn_i(1),
          step_frequency_i => n_sw_shield_i,
          stepper_o => StepperControl);
          
n_SSD_en_o <= ( others => '1' );
n_leds_shield_o <= n_sw_shield_i;

leds_o <= StepperControl;
pmodA_o(3 downto 0) <= StepperControl;
pmodA_o(7 downto 4) <= StepperControl;

end Behavioral;