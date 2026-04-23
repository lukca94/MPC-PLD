----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    CLK                 : IN  STD_LOGIC;
    BTN                 : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW                  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED                 : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG            : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG            : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
    UART_RXD            : IN  STD_LOGIC;
    UART_TXD            : OUT STD_LOGIC
  );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT(
    CLK                 : IN  STD_LOGIC;
    DIG_1               : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_2               : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_3               : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_4               : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DP                  : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    DOTS                : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    DISP_SEG            : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG            : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
  END COMPONENT seg_disp_driver;
  
  COMPONENT microblaze_mcs_riscv_0
      PORT (
        Clk             : IN STD_LOGIC;
        Reset           : IN STD_LOGIC;
        UART_rxd        : IN STD_LOGIC;
        UART_txd        : OUT STD_LOGIC;
        GPIO1_tri_i     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        GPIO1_tri_o     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        GPIO2_tri_o     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
      );
  END COMPONENT;
  ------------------------------------------------------------------------------

  SIGNAL dp             : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL dig_1          : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL dig_2          : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL dig_3          : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL dig_4          : STD_LOGIC_VECTOR (3 DOWNTO 0);
  
  SIGNAL GPIO1_tri_i    : STD_LOGIC_VECTOR(7 DOWNTO 0); 
  SIGNAL GPIO1_tri_o    : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL GPIO2_tri_o    : STD_LOGIC_VECTOR(15 DOWNTO 0);

----------------------------------------------------------------------------------
BEGIN
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
    DIG_1               => dig_1,
    DIG_2               => dig_2,
    DIG_3               => dig_3,
    DIG_4               => dig_4,
    DP                  => dp,
    DOTS                => "000",
    DISP_SEG            => DISP_SEG,
    DISP_DIG            => DISP_DIG
  );


  dp <= BTN OR SW;


  --------------------------------------------------------------------------------
  -- MicroBlaze-V MCS
    your_instance_name : microblaze_mcs_riscv_0
    PORT MAP (
        Clk             => Clk,
        Reset           => '0',
        UART_rxd        => UART_RXD,
        UART_txd        => UART_TXD,
        GPIO1_tri_i     => GPIO1_tri_i,
        GPIO1_tri_o     => GPIO1_tri_o,
        GPIO2_tri_o     => GPIO2_tri_o
    );
  
    LED <= GPIO1_tri_o;
  
    dig_1 <= GPIO2_tri_o (15 downto 12);    
    dig_2 <= GPIO2_tri_o (11 downto 8);    
    dig_3 <= GPIO2_tri_o (7 downto 4);    
    dig_4 <= GPIO2_tri_o (3 downto 0); 
    
    GPIO1_tri_i(7 downto 4) <= BTN;
    GPIO1_tri_i(3 downto 0) <= SW;   


----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
