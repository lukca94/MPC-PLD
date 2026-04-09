----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
    PORT(
        CLK             : IN  STD_LOGIC;
        LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
        BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0)
    );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS

    COMPONENT seg_disp_driver
    PORT(
        CLK             : IN  STD_LOGIC;
        DIG_1           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        DIG_2           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        DIG_3           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        DIG_4           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
        DP              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
        DOTS            : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
        DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
    );
    END COMPONENT seg_disp_driver;

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
    
    component ILA_PWM
    PORT (
        clk : IN STD_LOGIC;
    
        probe0                  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe1                  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe2                  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        probe3                  : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
    end component ILA_PWM;
    
    component VIO_PWM
    PORT (
        clk : IN STD_LOGIC;
        probe_in0               : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_in1               : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out0              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out1              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out2              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out3              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out4              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out5              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out6              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out7              : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe_out8              : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        probe_out9              : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        probe_out10             : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        probe_out11             : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) 
        
    );
    end component;   
----------------------------------------------------------------------------------    
    -- Signal declaration
    signal sig_pwm_ref_7        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_pwm_ref_6        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_pwm_ref_5        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_pwm_ref_4        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_pwm_ref_3        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_pwm_ref_2        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_pwm_ref_1        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_pwm_ref_0        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_pwm_out          : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_count_out        : STD_LOGIC_VECTOR(7 downto 0);
    signal sig_num_0            : STD_LOGIC_VECTOR(3 downto 0);
    signal sig_num_1            : STD_LOGIC_VECTOR(3 downto 0);
    signal sig_num_2            : STD_LOGIC_VECTOR(3 downto 0);
    signal sig_num_3            : STD_LOGIC_VECTOR(3 downto 0);
    
----------------------------------------------------------------------------------
begin
----------------------------------------------------------------------------------

    pwm_driver_i  : pwm_driver
    PORT MAP(
        CLK                 => CLK,
        PWM_REF_7           => sig_pwm_ref_7,
        PWM_REF_6           => sig_pwm_ref_6,
        PWM_REF_5           => sig_pwm_ref_5,
        PWM_REF_4           => sig_pwm_ref_4,
        PWM_REF_3           => sig_pwm_ref_3,
        PWM_REF_2           => sig_pwm_ref_2,
        PWM_REF_1           => sig_pwm_ref_1,
        PWM_REF_0           => sig_pwm_ref_0,   
        PWM_OUT             => sig_pwm_out,
        CNT_OUT             => sig_count_out
    );            
----------------------------------------------------------------------------------
-- LED connection
  LED <= sig_pwm_out;
  
----------------------------------------------------------------------------------
  vio_pwm_i : VIO_PWM
  PORT MAP (
    clk => clk,
    probe_in0           => sig_pwm_out,
    probe_in1           => sig_count_out,
    probe_out0          => sig_pwm_ref_0,
    probe_out1          => sig_pwm_ref_1,
    probe_out2          => sig_pwm_ref_2,
    probe_out3          => sig_pwm_ref_3,
    probe_out4          => sig_pwm_ref_4,
    probe_out5          => sig_pwm_ref_5,
    probe_out6          => sig_pwm_ref_6,
    probe_out7          => sig_pwm_ref_7,
    probe_out8          => sig_num_0,
    probe_out9          => sig_num_1,
    probe_out10         => sig_num_2,
    probe_out11         => sig_num_3
  );
----------------------------------------------------------------------------------
your_instance_name : ILA_PWM
PORT MAP (
	clk => clk,

	probe0             => sig_pwm_out,
	probe1             => sig_count_out,
	probe2             => BTN,
	probe3             => SW
);
----------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  -- display driver
  --
  --       DIG 1       DIG 2       DIG 3       DIG 4
  --                                       L3
  --       -----       -----       -----   o   -----
  --      |     |     |     |  L1 |     |     |     |
  --      |     |     |     |  o  |     |     |     |
  --       -----       -----       -----       -----
  --      |     |     |     |  o  |     |     |     |
  --      |     |     |     |  L2 |     |     |     |
  --       -----  o    -----  o    -----  o    -----  o
  --             DP1         DP2         DP3         DP4
  --
  --------------------------------------------------------------------------------

  seg_disp_driver_i : seg_disp_driver
  PORT MAP(
    CLK                 => CLK,
    DIG_1               => sig_num_0,
    DIG_2               => sig_num_1,
    DIG_3               => sig_num_2,
    DIG_4               => sig_num_3,
    DP                  => "0000",
    DOTS                => "011",
    DISP_SEG            => DISP_SEG,
    DISP_DIG            => DISP_DIG
  );

  --------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
