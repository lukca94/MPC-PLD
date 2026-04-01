----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY debouncer IS
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 12
  );    
  PORT( 
    CLK                 : IN    STD_LOGIC;
    CE                  : IN    STD_LOGIC;
    BTN_IN              : IN    STD_LOGIC;
    BTN_OUT             : OUT   STD_LOGIC
  );
END ENTITY debouncer;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF debouncer IS
----------------------------------------------------------------------------------
signal sig_out      : STD_LOGIC := '0';
signal counter      : INTEGER := G_DEB_PERIOD;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
    debounce : process (CLK)
    BEGIN
        IF rising_edge(CLK) THEN
            IF CE = '1' THEN
                IF counter < G_DEB_PERIOD THEN
                    counter <= counter + 1;
                END IF;
                
                IF counter = G_DEB_PERIOD THEN
                    IF sig_out /= BTN_IN THEN
                        sig_out <= BTN_IN;
                        counter <= 0;                    
                    END IF;
                END IF;    
            END IF;                    
        END IF;        
    END process debounce;          

    BTN_OUT <= sig_out;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
