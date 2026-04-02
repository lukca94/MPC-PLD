----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2026 09:35:43 AM
-- Design Name: 
-- Module Name: pwm_driver - Behavioral
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

entity pwm_driver is
    Port (
        CLK                 : IN    STD_LOGIC;
        PWM_REF_7           : IN    STD_LOGIC_VECTOR(7 downto 0);
        PWM_REF_6           : IN    STD_LOGIC_VECTOR(7 downto 0);
        PWM_REF_5           : IN    STD_LOGIC_VECTOR(7 downto 0);
        PWM_REF_4           : IN    STD_LOGIC_VECTOR(7 downto 0);
        PWM_REF_3           : IN    STD_LOGIC_VECTOR(7 downto 0);
        PWM_REF_2           : IN    STD_LOGIC_VECTOR(7 downto 0);
        PWM_REF_1           : IN    STD_LOGIC_VECTOR(7 downto 0);
        PWM_REF_0           : IN    STD_LOGIC_VECTOR(7 downto 0);    
        PWM_OUT             : OUT   STD_LOGIC_VECTOR(7 downto 0);
        CNT_OUT             : OUT   STD_LOGIC_VECTOR(7 downto 0)
    );
end pwm_driver;
----------------------------------------------------------------------------------------
architecture Behavioral of pwm_driver is
----------------------------------------------------------------------------------------
    component pwm_core
        Port ( 
            PWM_REF     : in STD_LOGIC_VECTOR(7 downto 0);
            CLK         : in STD_LOGIC;
            COUNT       : in INTEGER;
            PWM_OUT     : out STD_LOGIC
        );
    end component pwm_core;    
----------------------------------------------------------------------------------------

    signal count        : INTEGER := 0;
    
---------------------------------------------------------------------------------------- 
begin
----------------------------------------------------------------------------------------
    pwm_core_0_i    : pwm_core
    PORT MAP(
        PWM_REF     => PWM_REF_0,
        CLK         => CLK,
        COUNT       => count,
        PWM_OUT     => PWM_OUT(0)
    );
    pwm_core_1_i    : pwm_core
    PORT MAP(
        PWM_REF     => PWM_REF_1,
        CLK         => CLK,
        COUNT       => count,
        PWM_OUT     => PWM_OUT(1)
    );
    pwm_core_2_i    : pwm_core
    PORT MAP(
        PWM_REF     => PWM_REF_2,
        CLK         => CLK,
        COUNT       => count,
        PWM_OUT     => PWM_OUT(2)
    );
    pwm_core_3_i    : pwm_core
    PORT MAP(
        PWM_REF     => PWM_REF_3,
        CLK         => CLK,
        COUNT       => count,
        PWM_OUT     => PWM_OUT(3)
    );
    pwm_core_4_i    : pwm_core
    PORT MAP(
        PWM_REF     => PWM_REF_4,
        CLK         => CLK,
        COUNT       => count,
        PWM_OUT     => PWM_OUT(4)
    );
    pwm_core_5_i    : pwm_core
    PORT MAP(
        PWM_REF     => PWM_REF_5,
        CLK         => CLK,
        COUNT       => count,
        PWM_OUT     => PWM_OUT(5)
    );
    pwm_core_6_i    : pwm_core
    PORT MAP(
        PWM_REF     => PWM_REF_6,
        CLK         => CLK,
        COUNT       => count,
        PWM_OUT     => PWM_OUT(6)
    );
    pwm_core_7_i    : pwm_core
    PORT MAP(
        PWM_REF     => PWM_REF_7,
        CLK         => CLK,
        COUNT       => count,
        PWM_OUT     => PWM_OUT(7)
    );

    counter     : process(CLK)
    begin
        if rising_edge(CLK) then
            if (count = (2**8)-2) then
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if;
        
    end process counter;
    
----------------------------------------------------------------------------------------
    CNT_OUT <= std_logic_vector(to_unsigned(count,8));
----------------------------------------------------------------------------------------
end Behavioral;
