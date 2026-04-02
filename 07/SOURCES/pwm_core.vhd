----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2026 10:04:50 AM
-- Design Name: 
-- Module Name: pwm_core - Behavioral
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

entity pwm_core is
    Port ( 
        PWM_REF     : in STD_LOGIC_VECTOR(7 downto 0);
        CLK         : in STD_LOGIC;
        COUNT       : in INTEGER;
        PWM_OUT     : out STD_LOGIC
    );
end pwm_core;

architecture Behavioral of pwm_core is

begin
    pwm_core    : process(CLK)
    begin   
        if rising_edge(CLK) then
            if (unsigned(NOT(PWM_REF)) <= COUNT) then
                PWM_OUT <= '1';
            else
                PWM_OUT <= '0';
            end if;
        end if;
    end process pwm_core;

end Behavioral;
