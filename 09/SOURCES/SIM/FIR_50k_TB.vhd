
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity FIR_50k_TB is
end FIR_50k_TB;

architecture tb of FIR_50k_TB is

  COMPONENT FIR_50k_wrapper IS
    GENERIC (
      SIM_MODEL : BOOLEAN := TRUE
    );
    PORT (
      aclk               : IN  STD_LOGIC;
      s_axis_data_tvalid : IN  STD_LOGIC;
      s_axis_data_tready : OUT STD_LOGIC;
      s_axis_data_tdata  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
      m_axis_data_tvalid : OUT STD_LOGIC;
      m_axis_data_tdata  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
  END COMPONENT;

  -----------------------------------------------------------------------
  CONSTANT C_aclk_period : time := 20 ns;

  SIGNAL aclk               : STD_LOGIC := '0';
  SIGNAL s_axis_data_tvalid : STD_LOGIC := '0';
  SIGNAL s_axis_data_tready : STD_LOGIC;
  SIGNAL s_axis_data_tdata  : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

  SIGNAL m_axis_data_tvalid : STD_LOGIC;
  SIGNAL m_axis_data_tdata  : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL sim_finished : BOOLEAN := FALSE;

begin

  -----------------------------------------------------------------------
  -- Clock
  -----------------------------------------------------------------------
  P_aclk: PROCESS
  BEGIN
    WHILE TRUE LOOP
      aclk <= '0';
      WAIT FOR C_aclk_period/2;
      aclk <= '1';
      WAIT FOR C_aclk_period/2;
    END LOOP;
  END PROCESS;

  -----------------------------------------------------------------------
  -- DUT
  -----------------------------------------------------------------------
  FIR_50k_wrapper_i : FIR_50k_wrapper
    GENERIC MAP (
      SIM_MODEL => FALSE   -- switch to FALSE for real IP
    )
    PORT MAP (
      aclk               => aclk,
      s_axis_data_tvalid => s_axis_data_tvalid,
      s_axis_data_tready => s_axis_data_tready,
      s_axis_data_tdata  => s_axis_data_tdata,
      m_axis_data_tvalid => m_axis_data_tvalid,
      m_axis_data_tdata  => m_axis_data_tdata
    );

  -----------------------------------------------------------------------
  -- INPUT PROCESS (AXI CORRECT)
  -----------------------------------------------------------------------
  read_txt: PROCESS
    FILE File_ID : TEXT;
    VARIABLE line_in  : LINE;
    VARIABLE v_number : INTEGER;
  BEGIN
    FILE_OPEN(File_ID, "..\..\..\..\SOURCES\FIR_data\FIR_data_in.txt", READ_MODE);

    WAIT UNTIL rising_edge(aclk);

    WHILE NOT ENDFILE(File_ID) LOOP
      READLINE(File_ID, line_in);
      READ(line_in, v_number);

      s_axis_data_tdata  <= STD_LOGIC_VECTOR(TO_SIGNED(v_number, 16));
      s_axis_data_tvalid <= '1';

      -- wait for handshake
      WAIT UNTIL rising_edge(aclk) AND s_axis_data_tready = '1';

      s_axis_data_tvalid <= '0';
    END LOOP;

    FILE_CLOSE(File_ID);

    -- allow pipeline to flush
    WAIT FOR C_aclk_period * 200;

    sim_finished <= TRUE;

    REPORT "Input finished" SEVERITY NOTE;
    WAIT;
  END PROCESS;

  -----------------------------------------------------------------------
  -- CHECKER PROCESS
  -----------------------------------------------------------------------
  check_output: PROCESS
    FILE File_ID_out : TEXT;
    FILE File_ID_log : TEXT;

    VARIABLE line_out : LINE;
    VARIABLE line_in  : LINE;

    VARIABLE OUT_expected : INTEGER;
    VARIABLE OUT_actual   : INTEGER;

    VARIABLE err_count : INTEGER := 0;
    VARIABLE sample_cnt : INTEGER := 0;

    CONSTANT SKIP_SAMPLES : INTEGER := 20; -- adjust if needed

  BEGIN
    FILE_OPEN(File_ID_out, "..\..\..\..\SOURCES\FIR_data\FIR_data_out.txt", READ_MODE);
    FILE_OPEN(File_ID_log, "..\..\..\..\SOURCES\FIR_data\FIR_sim_log.txt", WRITE_MODE);

    WAIT UNTIL rising_edge(aclk);

    WHILE NOT (ENDFILE(File_ID_out) AND sim_finished) LOOP
      WAIT UNTIL rising_edge(aclk);

      IF m_axis_data_tvalid = '1' THEN

        sample_cnt := sample_cnt + 1;

        READLINE(File_ID_out, line_in);
        READ(line_in, OUT_expected);

        OUT_actual := TO_INTEGER(SIGNED(m_axis_data_tdata));

        IF sample_cnt > SKIP_SAMPLES THEN
          IF OUT_expected /= OUT_actual THEN
            err_count := err_count + 1;

            WRITE(line_out, STRING'("Error at "));
            WRITE(line_out, TIME'image(NOW));
            WRITE(line_out, STRING'(": expected="));
            WRITE(line_out, OUT_expected);
            WRITE(line_out, STRING'(" actual="));
            WRITE(line_out, OUT_actual);

            REPORT line_out.ALL SEVERITY WARNING;
            WRITELINE(File_ID_log, line_out);
          END IF;
        END IF;

      END IF;
    END LOOP;

    -------------------------------------------------------------------
    -- FINAL RESULT
    -------------------------------------------------------------------
    WRITE(line_out, STRING'("Total errors: "));
    WRITE(line_out, err_count);
    
    REPORT line_out.ALL SEVERITY NOTE;
    WRITELINE(File_ID_log, line_out);

    IF err_count = 0 THEN
      WRITE(line_out, STRING'("PASS"));
    ELSE
      WRITE(line_out, STRING'("FAIL"));
    END IF;

    REPORT line_out.ALL SEVERITY NOTE;
    WRITELINE(File_ID_log, line_out);

    FILE_CLOSE(File_ID_out);
    FILE_CLOSE(File_ID_log);

    REPORT "Simulation finished" SEVERITY FAILURE; -- stops simulation
    WAIT;
  END PROCESS;

end tb;
