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
             DigitEn : integer := 45);
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           name_ptr_o : out STD_LOGIC_VECTOR (7 downto 0);
           name_len_i : in STD_LOGIC_VECTOR (7 downto 0);
           name_dat_i : in STD_LOGIC_VECTOR (7 downto 0);
           segments_o : out std_logic_vector (7 downto 0);
           digit : out std_logic_vector(7 downto 0);
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

signal name_ptr : std_logic_vector (7 downto 0);

signal dEnable : std_logic;
signal mEnable : std_logic;
signal ascii : std_logic_vector (7 downto 0);
signal pointer : std_logic_vector (3 downto 0);
signal mPointer : std_logic_vector (7 downto 0);
signal dig : std_logic_vector(7 downto 0);

constant spacestr : string := "        ";
constant datastr : string := "HELLO123456789";
constant teststr : string := spacestr & datastr;

begin

ascii <= std_logic_vector(to_unsigned(character'pos(teststr(to_integer(unsigned(name_ptr)))), 8));

DummyDebounce:Debouncer
generic map (prescaler => 12)
port map    (clk_i => clk_i, 
             rst_i => rst_i,
             signal_i => '1',
             signal_o => open,
             risingedge_o => open,
             fallingedge_o => open);

EnableSignals: ClockEnableManager
generic map ( SysClock => SysClock, 
              MovEn => MovEn,
              DigitEn => DigitEn)
port map    ( clk_i => clk_i,
              rst_i => rst_i,
              digitEn_o => dEnable,
              movEn_o => mEnable);

Display: DisplayController
port map ( clk_i => clk_i,
           rst_i => rst_i,
           enable_i => dEnable,
           name_dat_i => name_dat_i,
           pointer_o => pointer,
           digit_o => dig,
           segments_o => segments_o);
           
MovingText:TextMover
port map ( clk_i => clk_i,
           rst_i => rst_i,
           enable_i => mEnable,
           name_len_i => std_logic_vector(to_unsigned(teststr'length, 8)),
           pointer_i => pointer,
           name_ptr_o => name_ptr);

digit <= dig;
digit_o <= dig;
name_ptr_o <= name_ptr;

end Behavioral;
