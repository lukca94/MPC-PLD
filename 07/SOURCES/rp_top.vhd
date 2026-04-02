----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
    PORT(
        CLK             : IN  STD_LOGIC;
        LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS

    signal sig_led      : STD_LOGIC_VECTOR(7 downto 0);

    component pwm_driver
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
    end component pwm_driver;    
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------
    
    pwm_driver_i  : pwm_driver
        PORT MAP(
            CLK                 => CLK,
            PWM_REF_7           => "00000000",
            PWM_REF_6           => "00000001",
            PWM_REF_5           => "00000011",
            PWM_REF_4           => "00000111",
            PWM_REF_3           => "00011111",
            PWM_REF_2           => "00111111",
            PWM_REF_1           => "01111111",
            PWM_REF_0           => "11111111",   
            PWM_OUT             => sig_led,
            CNT_OUT             => open
        );            
----------------------------------------------------------------------------------
-- LED connection
  LED <= sig_led;


----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
