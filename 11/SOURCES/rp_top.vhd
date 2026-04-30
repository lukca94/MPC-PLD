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
    UART_TXD            : OUT STD_LOGIC;
    
    DDR_cas_n           : inout STD_LOGIC;
    DDR_cke             : inout STD_LOGIC;
    DDR_ck_n            : inout STD_LOGIC;
    DDR_ck_p            : inout STD_LOGIC;
    DDR_cs_n            : inout STD_LOGIC;
    DDR_reset_n         : inout STD_LOGIC;
    DDR_odt             : inout STD_LOGIC;
    DDR_ras_n           : inout STD_LOGIC;
    DDR_we_n            : inout STD_LOGIC;
    DDR_ba              : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr            : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm              : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq              : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n           : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p           : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio        : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn    : inout STD_LOGIC;
    FIXED_IO_ddr_vrp    : inout STD_LOGIC;
    FIXED_IO_ps_srstb   : inout STD_LOGIC;
    FIXED_IO_ps_clk     : inout STD_LOGIC;
    FIXED_IO_ps_porb    : inout STD_LOGIC
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


    component BD_PLD is
    port (
        DDR_cas_n : inout STD_LOGIC;
        DDR_cke : inout STD_LOGIC;
        DDR_ck_n : inout STD_LOGIC;
        DDR_ck_p : inout STD_LOGIC;
        DDR_cs_n : inout STD_LOGIC;
        DDR_reset_n : inout STD_LOGIC;
        DDR_odt : inout STD_LOGIC;
        DDR_ras_n : inout STD_LOGIC;
        DDR_we_n : inout STD_LOGIC;
        DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
        DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
        DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
        DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
        FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
        FIXED_IO_ddr_vrn : inout STD_LOGIC;
        FIXED_IO_ddr_vrp : inout STD_LOGIC;
        FIXED_IO_ps_srstb : inout STD_LOGIC;
        FIXED_IO_ps_clk : inout STD_LOGIC;
        FIXED_IO_ps_porb : inout STD_LOGIC;
        
        gpio_rtl_0_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
        gpio_rtl_1_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
        UART_0_0_txd : out STD_LOGIC;
        UART_0_0_rxd : in STD_LOGIC
    );
    end component BD_PLD;
  ------------------------------------------------------------------------------

  SIGNAL dp                 : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL dig_1              : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL dig_2              : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL dig_3              : STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL dig_4              : STD_LOGIC_VECTOR (3 DOWNTO 0);
  
  SIGNAL gpio_rtl_0_tri_i   : STD_LOGIC_VECTOR ( 31 downto 0 );
  SIGNAL gpio_rtl_1_tri_o   : STD_LOGIC_VECTOR ( 31 downto 0 );

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
  -- Zynq SoC
    BD_PLD_i: component BD_PLD
    port map (
        DDR_addr(14 downto 0)             => DDR_addr(14 downto 0),
        DDR_ba(2 downto 0)                => DDR_ba(2 downto 0),
        DDR_cas_n                         => DDR_cas_n,
        DDR_ck_n                          => DDR_ck_n,
        DDR_ck_p                          => DDR_ck_p,
        DDR_cke                           => DDR_cke,
        DDR_cs_n                          => DDR_cs_n,
        DDR_dm(3 downto 0)                => DDR_dm(3 downto 0),
        DDR_dq(31 downto 0)               => DDR_dq(31 downto 0),
        DDR_dqs_n(3 downto 0)             => DDR_dqs_n(3 downto 0),
        DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
        DDR_odt => DDR_odt,
        DDR_ras_n => DDR_ras_n,
        DDR_reset_n => DDR_reset_n,
        DDR_we_n => DDR_we_n,
        FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
        FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
        FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
        FIXED_IO_ps_clk => FIXED_IO_ps_clk,
        FIXED_IO_ps_porb => FIXED_IO_ps_porb,
        FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
        
        UART_0_0_rxd => UART_RXD,
        UART_0_0_txd => UART_TXD,
        gpio_rtl_0_tri_i(31 downto 0) => gpio_rtl_0_tri_i(31 downto 0),
        gpio_rtl_1_tri_o(31 downto 0) => gpio_rtl_1_tri_o(31 downto 0)
    );
    
gpio_rtl_0_tri_i        <= X"000000" & BTN & SW;

dig_1                   <= gpio_rtl_1_tri_o(23 downto 20);
dig_2                   <= gpio_rtl_1_tri_o(19 downto 16);
dig_3                   <= gpio_rtl_1_tri_o(15 downto 12);
dig_4                   <= gpio_rtl_1_tri_o(11 downto 8);
LED                     <= gpio_rtl_1_tri_o(7 downto 0);

----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
