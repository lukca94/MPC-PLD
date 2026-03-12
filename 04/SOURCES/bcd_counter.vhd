----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY bcd_counter IS
  PORT(
    CLK                 : IN    STD_LOGIC;      -- clock signal
    CE_100HZ            : IN    STD_LOGIC;      -- 100 Hz clock enable
    CNT_RESET           : IN    STD_LOGIC;      -- counter reset
    CNT_ENABLE          : IN    STD_LOGIC;      -- counter enable
    DISP_ENABLE         : IN    STD_LOGIC;      -- enable display update
    CNT_0               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_1               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_2               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_3               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END ENTITY bcd_counter;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF bcd_counter IS
----------------------------------------------------------------------------------
signal sig_cnt_0    : unsigned(3 downto 0); 
signal sig_cnt_1    : unsigned(3 downto 0); 
signal sig_cnt_2    : unsigned(3 downto 0); 
signal sig_cnt_3    : unsigned(3 downto 0); 

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  -- BCD counter
    bcd_counter : process (CLK) 
    BEGIN
        IF rising_edge(CLK) THEN
            IF CNT_ENABLE = '1' THEN
                IF CE_100HZ = '1' THEN
                    IF sig_cnt_0 /= X"9" THEN
                        sig_cnt_0 <= sig_cnt_0 + 1;
                    ELSE
                        sig_cnt_0 <= (OTHERS => '0');
                        IF sig_cnt_1 /= X"9" THEN
                            sig_cnt_1 <= sig_cnt_1 + 1;
                        ELSE
                            sig_cnt_1 <= (OTHERS => '0');
                            IF sig_cnt_2 /= X"9" THEN
                                sig_cnt_2 <= sig_cnt_2 + 1;
                            ELSE  
                                sig_cnt_2 <= (OTHERS => '0');
                                IF sig_cnt_3 /= X"5" THEN
                                    sig_cnt_3 <= sig_cnt_3 + 1;
                                ELSE
                                    sig_cnt_3 <= (OTHERS => '0');
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                        
                END IF;
            END IF;            
            IF CNT_RESET = '1' THEN
                sig_cnt_0 <= (OTHERS => '0');
                sig_cnt_1 <= (OTHERS => '0');
                sig_cnt_2 <= (OTHERS => '0');
                sig_cnt_3 <= (OTHERS => '0');
            END IF;    
        END IF;        
    END process bcd_counter;

  --------------------------------------------------------------------------------
  -- Output (display) register
    output_register : process (CLK) 
    BEGIN
        IF rising_edge(CLK) THEN
            IF DISP_ENABLE = '1' THEN
                CNT_0 <= std_logic_vector(sig_cnt_0);
                CNT_1 <= std_logic_vector(sig_cnt_1);
                CNT_2 <= std_logic_vector(sig_cnt_2);
                CNT_3 <= std_logic_vector(sig_cnt_3);
            END IF;
        END IF;                
    END process output_register;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
