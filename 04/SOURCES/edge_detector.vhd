----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY edge_detector IS
  PORT(
    CLK                 : IN    STD_LOGIC;
    SIG_IN              : IN    STD_LOGIC;
    EDGE_POS            : OUT   STD_LOGIC;
    EDGE_NEG            : OUT   STD_LOGIC;
    EDGE_ANY            : OUT   STD_LOGIC
  );
END ENTITY edge_detector;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF edge_detector IS
----------------------------------------------------------------------------------
signal btn_delayed      : STD_LOGIC := '0';


----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
    delay_process : process (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            btn_delayed <= SIG_IN;
         END IF;
    END process delay_process;
    
    detector : process (CLK) 
    BEGIN
        IF rising_edge(CLK) THEN
            IF (SIG_IN = '1' and btn_delayed = '0') THEN
                EDGE_POS <= '1';
            ELSE 
                EDGE_POS <= '0';
            END IF;
            
            IF (SIG_IN = '0' and btn_delayed = '1') THEN
                EDGE_NEG <= '1';
            ELSE 
                EDGE_NEG <= '0';
            END IF;
            
            IF (SIG_IN /= btn_delayed) THEN
                EDGE_ANY <= '1';
            ELSE 
                EDGE_ANY <= '0';
            END IF;
            
        
        END IF;
    
    END process detector;


----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
