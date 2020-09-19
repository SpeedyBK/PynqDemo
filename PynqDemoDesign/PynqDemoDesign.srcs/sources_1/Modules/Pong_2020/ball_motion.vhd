----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.03.2016 13:51:10
-- Design Name: 
-- Module Name: Ball_Motion - Behavioral
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

entity Ball_Motion is
    generic ( ball_length : integer := 6;
              racket_length : integer := 10;
              racket_height : integer := 30;
              racket_left_space : integer := 20;
              racket_right_space : integer := 610;
              screen_height : integer := 480;
              speedup_racket : integer := 10); 
    Port ( clock_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           game_enable_i : in STD_LOGIC;
           push_but1_deb_i : in STD_LOGIC;
           push_but2_deb_i : in STD_LOGIC;
           game_over_i : in STD_LOGIC;
           hit_wall_i : in STD_LOGIC_VECTOR (2 downto 0);
           hit_racket_l_i : in STD_LOGIC_VECTOR (1 downto 0);
           hit_racket_r_i : in STD_LOGIC_VECTOR (1 downto 0);
           ball_x_o : out STD_LOGIC_VECTOR (9 downto 0);
           ball_y_o : out STD_LOGIC_VECTOR (9 downto 0));
           --LEDS : out std_logic_vector (3 downto 0)); -- Visualizing states for debugging, and flashing LEDs are cool. ^^
end Ball_Motion;

architecture Behavioral of Ball_Motion is

---------------------------------------------------------------------------------
-- Signals:
---------------------------------------------------------------------------------

-- Inputsignals:
signal reset_int : std_logic;
signal buttons   : std_logic_vector (1 downto 0); -- Controller pushbuttons [(0) - Controller 1 ; (1) - Controller 2]
signal inputs    : std_logic_vector (6 downto 0); -- 6-4 -> hit_wall, 3-2 hit_left, 1-0 hit_right

-- Controll:
type state_type is (stop, move, hit_left, hit_right, wall_down, wall_up, outside_field);
signal state : state_type := stop;
signal stop_flag : std_logic := '0';
signal free_wall : std_logic := '0';
signal free_left : std_logic := '0';
signal free_right: std_logic := '0';

-- Positioncalculation:
signal ball_x       : integer range 0 to 1024 := 320;
signal ball_y       : integer range 0 to 1024 := 240;
signal delta_x      : integer range 0 to 124 := 2;
signal delta_y      : integer range 0 to 124 := 1;
signal left_right   : std_logic := '0';
signal up_down      : std_logic := '0';

-- Speedup:
signal speed : integer range 0 to 15 := 0;


begin
---------------------------------------------------------------------------------
-- Capturing inputsignals
---------------------------------------------------------------------------------
buttons(0)<= push_but1_deb_i;
buttons(1)<= push_but2_deb_i;

reset_int <= reset_i or game_over_i;

capturing_inputs:process(clock_i, reset_int, free_wall, free_left, free_right) 
begin
    if rising_edge(clock_i) then 
        if (reset_int = '1' or free_wall = '1') then
            inputs(6 downto 4) <= "000";
        elsif (reset_int = '1' or free_left = '1') then
            inputs(3 downto 2) <= "00";
        elsif (reset_int = '1' or free_right = '1') then
            inputs(1 downto 0) <= "00";
        elsif (hit_racket_l_i /= "00") then 
           inputs(3 downto 2) <= hit_racket_l_i;
        elsif (hit_racket_r_i /= "00") then 
           inputs(1 downto 0) <= hit_racket_r_i;
        elsif (hit_wall_i /= "000") then 
            inputs(6 downto 4) <= hit_wall_i;
        else 
            inputs <= inputs;
        end if;        
    end if;
end process;         
 
---------------------------------------------------------------------------------
-- Controll - Statemaschine
---------------------------------------------------------------------------------
Controll: process (clock_i, reset_int)
variable count_y : integer range 1 to 5 := 1;
variable count_x : integer range 1 to 10 := 1;
variable timer   : integer range 0 to 64 := 0;
begin 
    if (reset_int = '1') then
        state <= stop;
            
    elsif rising_edge(clock_i) and game_enable_i = '1' then
        
        case state is
            
            when stop =>
                stop_flag <= '1';
                free_wall <= '1';
                free_left <= '1';
                free_right <= '1';
                --LEDS <= "0001";
                
                -- Randomize starting scenario: 
                
                -- Counter responsible for delta_y
                if (count_y <= 5) then
                    count_y := count_y+1;
                else 
                    count_y := 1;
                end if;
             
                
                -- Counter resonsible for delta_x
                if (count_x <= 10) then    -- half the speed of the Y-Counter.
                    count_x := count_x + 1;
                else 
                    count_x := 2;          -- Avoiding that delta_x becomes 0.
                end if;
                
                delta_y <= count_y;           -- Division by 2 should be possible in ISE as well   
                delta_x <= count_x / 2;       -- (bit-shift right by one bit).
                                
                if (count_y = 1) then         -- Using the Y-Counter to get some random
                    up_down <= '1';           -- up or down ball movements, when the game  
                elsif (count_y = 2) then      -- game starts.
                    up_down <= '0';
                elsif (count_y = 3) then
                    up_down <= '1';
                elsif (count_y = 4) then
                    up_down <= '0';
                else
                    up_down <= '1';
                end if;
                    
                if (buttons = "11") then     -- After resetting the a dead game the counter
                    timer := 0;              -- the counter starts and the signals from the 
                elsif (timer < 60) then      -- buttons are ignored for 1 second. Avoids that
                    timer := timer + 1;      -- that the game starts randomly after a reset. 
                else
                    timer := 60;                     
                    if (buttons = "10") then -- The player who doesn't hit the Button first
                        left_right <= '1';   -- needs to hit the ball for the first time. 
                        state <= move;
                    elsif (buttons = "01") then
                        left_right <= '0';
                        state <= move;
                    else
                        left_right <= '0';
                        state <= stop;
                    end if;
                end if;    

            when move =>
                stop_flag <= '0';
                free_wall <= '0';
                free_left <= '0';
                free_right <= '0';
                --LEDS <= "0010";
                
                if (inputs(1 downto 0) /= "00") then 
                    state <= hit_right;
                elsif (inputs(3 downto 2) /= "00") then
                    state <= hit_left;
                elsif (inputs(6 downto 4) = "010") then
                    state <= wall_up;
                elsif (inputs(6 downto 4) = "001") then
                    state <= wall_down;
                elsif ((inputs(6 downto 4) = "110") or (inputs(6 downto 4) = "101")) then
                    state <= outside_field;
                elsif (buttons = "11") then -- Reset-Option without resetting the whole game.
                    state <= stop;          -- In the tests sometimes the situation occured, 
                else                        -- that the ball just moved up and down, without 
                    state <= move;          -- changing the x-position, so I implemented an 
                end if;                     -- option to reset the game and keep the score.
                
            when wall_up =>
                stop_flag <= '0';
                free_wall <= '1';
                free_left <= '0';
                free_right <= '0';
                up_down <= '0';
                --LEDS <= "0011";
                
                if (inputs(6 downto 4) /= "010") then 
                    state <= move;
                end if;
                
            when wall_down =>
                stop_flag <= '0';
                free_wall <= '1';
                free_left <= '0';
                free_right <= '0';
                up_down <= '1';
                --LEDS <= "0100";
                
                if (inputs(6 downto 4) /= "001") then 
                    state <= move;
                end if;
                    
            when hit_left =>
                stop_flag <= '0';
                free_wall <= '0';
                free_left <= '1';
                free_right <= '0';
                left_right <= '0';
                --LEDS <= "0101";
                
                if (inputs(3 downto 2) = "01") then 
                    if (delta_x > 1) then               -- Delta_x should never become 0, or 
                        delta_x <= delta_x - 1;         -- we have a dead game.
                    else 
                        delta_x <= delta_x;
                    end if;
                    delta_y <= delta_y + 1;
                elsif (inputs(3 downto 2) = "10") then 
                    delta_x <= delta_x + 1;
                    if (delta_y > 1) then               -- Delta_y should never become 0, or
                        delta_y <= delta_y - 1;         -- we can have a dead game.
                    else 
                        delta_y <= delta_y;
                    end if;
                elsif (inputs(3 downto 2) = "11") then 
                    delta_x <= delta_x;
                    delta_y <= delta_y;
                else
                    state <= move;
                end if;
                
            when hit_right =>
                stop_flag <= '0';
                free_wall <= '0';
                free_left <= '0';
                free_right <= '1';
                left_right <= '1';
                --LEDS <= "0110";
            
                if (inputs(1 downto 0) = "01") then 
                    if (delta_x > 1) then 
                        delta_x <= delta_x - 1;
                    else 
                        delta_x <= delta_x;
                    end if;
                    delta_y <= delta_y + 1;
                elsif (inputs(1 downto 0) = "10") then 
                    delta_x <= delta_x + 1;
                    if (delta_y > 1) then
                        delta_y <= delta_y - 1;
                    else 
                        delta_y <= delta_y;
                    end if;
                elsif (inputs(1 downto 0) = "11") then 
                    delta_x <= delta_x;
                    delta_y <= delta_y;
                else
                    state <= move;
                end if;
                
            when outside_field =>
                free_wall <= '1';
                free_left <= '0';
                free_right <= '0';
                --LEDS <= "0111";
                
                state <= stop;                
            
            when others =>
                state <= stop;
                --LEDS <= "1111";
                         
        end case;
    end if;
end process;

---------------------------------------------------------------------------------
-- Positioncalculation
---------------------------------------------------------------------------------

Positioncalculation: process (reset_int, clock_i, game_enable_i, stop_flag)
begin
    if (reset_int = '1' or stop_flag = '1') then 
        ball_x <= 320;
        ball_y <= 240;
    elsif rising_edge(clock_i) then 
        if (game_enable_i = '1') then
            case left_right is
                when '0' =>
                    if (ball_x + delta_x + speed < racket_right_space + racket_length) then -- Checking if the ball will leave the field in the
                        ball_x <= ball_x + delta_x + speed;                                 -- next cycle. If not calculating the position, else     
                    else                                                                    -- the ball is set on the boarder of the field.         
                        ball_x <= racket_right_space + racket_length;
                    end if;
                when others =>
                    if (ball_x - delta_x - speed > racket_left_space -1) then   
                        ball_x <= ball_x - delta_x - speed;
                    else 
                        ball_x <= racket_left_space -1;
                    end if;
                end case;
            case up_down is
                when '0' =>
                    if (ball_y + delta_y + speed < screen_height) then
                        ball_y <= ball_y + delta_y + speed; 
                    else 
                        ball_y <= screen_height;
                    end if;
                when others =>
                    if (ball_y - delta_y - speed > -1) then
                        ball_y <= ball_y - delta_y - speed; 
                    else 
                        ball_y <= 0;
                    end if;
            end case;
        end if;
    end if;
end process;


---------------------------------------------------------------------------------
-- Speedup - Counter
---------------------------------------------------------------------------------

Ballbeschleunigung: process (clock_i, hit_racket_l_i, hit_racket_r_i, reset_int, stop_flag)
variable count : integer range 0 to 10;
begin
    if (reset_int = '1' or stop_flag ='1') then
        count := 0;
        speed <= 0;
    elsif rising_edge(clock_i) then             -- After 10 racket hits --> Speed + 1
        if (count < 10) then 
            if (hit_racket_l_i /= "00" or hit_racket_r_i /= "00") then
                count := count + 1;
            else 
                count := count;
            end if;
        else 
            count := 0;
            if (speed <= speedup_racket) then    -- Max speedup = 10
                speed <= speed + 1;
            else 
                speed <= speed;
            end if;
        end if;
    end if;
end process;
         
 -----------------------------------------------------------------------------------------------------------
 -- Outputs - converting integer values to STD_LOGIC_VECTOR and using a Register to minimize critical Path
 -----------------------------------------------------------------------------------------------------------

process(clock_i) 
begin 
    if rising_edge(clock_i) then  
        ball_x_o <= std_logic_vector(to_signed(ball_x,ball_x_o'length));
        ball_y_o <= std_logic_vector(to_signed(ball_y,ball_y_o'length));
    end if;
end process;

end Behavioral;