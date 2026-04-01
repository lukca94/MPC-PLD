--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
ENTITY stopwatch_fsm IS
  PORT (
    CLK                 : IN    STD_LOGIC;
    BTN_S_S             : IN    STD_LOGIC;
    BTN_L_C             : IN    STD_LOGIC;
    CNT_RESET           : OUT   STD_LOGIC;
    CNT_ENABLE          : OUT   STD_LOGIC;
    DISP_ENABLE         : OUT   STD_LOGIC
  );
END ENTITY stopwatch_fsm;
--------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF stopwatch_fsm IS
--------------------------------------------------------------------------------
TYPE t_state IS (st_Idle, st_Run, st_Lap, st_Refresh, st_Stop);
SIGNAL pres_st : t_state := st_Idle;
SIGNAL next_st : t_state;

--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------
PROCESS (clk) BEGIN
    IF rising_edge(clk) THEN
        pres_st <= next_st;
    END IF;
END PROCESS;

PROCESS (pres_st, BTN_S_S, BTN_L_C) BEGIN
    CASE pres_st IS
        WHEN st_Idle =>     
            IF BTN_S_S = '1'            THEN next_st <= st_Run;
            ELSIF BTN_L_C = '1'         THEN next_st <= st_Idle;
            ELSE next_st <= st_Idle;
            END IF;
        WHEN st_Run => 
            IF BTN_S_S = '1'            THEN next_st <= st_Stop;
            ELSIF BTN_L_C = '1'         THEN next_st <= st_Lap;
            ELSE next_st <= st_Run;
            END IF;
        WHEN st_Stop => 
            IF BTN_S_S = '1'            THEN next_st <= st_Run;
            ELSIF BTN_L_C = '1'         THEN next_st <= st_Idle;
            ELSE next_st <= st_Stop;
            END IF;
        WHEN st_Lap => 
            IF BTN_S_S = '1'            THEN next_st <= st_Run;
            ELSIF BTN_L_C = '1'         THEN next_st <= st_Refresh;
            ELSE next_st <= st_Lap;
            END IF;
        WHEN st_Refresh => 
            next_st <= st_Lap;                    
    END CASE;
END PROCESS;

--------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
--------------------------------------------------------------------------------
