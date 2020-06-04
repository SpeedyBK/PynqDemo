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
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           demo_i : in std_logic;
           start_i : in std_logic;
           btnUP_i : in std_logic;
           btnDown_i : in std_logic;
           mux_en_o : out std_logic;
           mux_sel_o : out std_logic_vector (CHAR_WIDTH-1 downto 0);
           name_ptr_o : out STD_LOGIC_VECTOR (CHAR_WIDTH-1 downto 0);
           name_ptr_i : in STD_LOGIC_VECTOR (CHAR_WIDTH-1 downto 0);
           name_len_i : in STD_LOGIC_VECTOR (CHAR_WIDTH-1 downto 0);
           name_dat_i : in STD_LOGIC_VECTOR (CHAR_WIDTH-1 downto 0);
           segments_o : out std_logic_vector (7 downto 0);
           digit_o : out std_logic_vector(7 downto 0));
end ControlMenu;

architecture Behavioral of ControlMenu is

component ClockEnableManager is
    Generic (SysClock : integer := 125000000;
             MovEn : integer := 2;
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
constant spacestr : string := "        ";
constant datastr : string := "HELLO MartIn thIS IS an ExamPLE oF a movInG tExt";
constant teststr : string := spacestr & datastr;
constant test_len : std_logic_vector (7 downto 0) := std_logic_vector(to_unsigned(teststr'length, 8));
signal test_dat : std_logic_vector (7 downto 0);
signal namesel : std_logic;

-- Name:
-- Usable Characters:
--(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
--(A, C, E, F, G, H, I, J, L, O)
--(P, S, U, a, b, c, d, h, n, o)
--(q, r, t, u, y)         
constant name_str : string := "        Pynq boArd  USE btn1 And btn0 to SELECt your APPLICAtIOn And PrESS btn2 to StArt";

begin

-- Invert the reset, if an activ High Reset is needed:
rst <= not rst_i;

-- Mux_enable if you chose an application, this signal enables the Seven Segment display
-- for the application you have chosen. If you haven't chosen an application, the Seven- 
-- Segment-Display will display the output from the controll menu
process (rst, clk_i)
begin 
    if (rst = '0') then 
        mux_en <= '0'; 
    elsif rising_edge(clk_i) then 
        if (start_i = '1') then 
            mux_en <= '1';
        else
            mux_en <= mux_en;
        end if;
    end if;
end process;

-- Generating the internal example data to display
test_dat <= std_logic_vector(to_unsigned(character'pos(teststr(to_integer(unsigned(name_ptr)))), 8));

process (rst, clk_i)
begin 
    if (rst = '0') then 
        namesel <= '0'; 
    elsif rising_edge(clk_i) then 
        if (btn_deb_up = '1' or btn_deb_down = '1') then 
            namesel <= '1';
        else
            namesel <= namesel;
        end if;
    end if;
end process;

with namesel select 
    name_dat_temp <= name_dat_i when '1',
                     std_logic_vector(to_unsigned(character'pos(name_str(to_integer(unsigned(name_ptr)))), 8)) when others;
                     
with namesel select 
    name_len_temp <= name_len_i when '1',
                     std_logic_vector(to_unsigned(name_str'length, name_len_temp'length)) when others;  

-- Select internal example (SW1)
with demo_i select
    name_dat<= name_dat_temp when '0',
               test_dat when others;

-- Select internal example (SW1)               
with demo_i select
    name_len <= name_len_temp when '0',
                test_len when others;
                
UPDebounce:Debouncer
generic map (prescaler => 10000)
port map    (clk_i => clk_i, 
             rst_i => rst,
             signal_i => btnUp_i,
             signal_o => open,
             risingedge_o => btn_deb_up,
             fallingedge_o => open);
             
DownDebounce:Debouncer
generic map (prescaler => 10000)
port map    (clk_i => clk_i, 
             rst_i => rst,
             signal_i => btnDown_i,
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
           digit_o => dig,
           segments_o => segments_o);
           
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

digit_o <= dig;
name_ptr_o <= name_ptr;

mux_en_o <= mux_en;
mux_sel_o <= mux_sel;

end Behavioral;
