library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx_tb is
end uart_tx_tb;

architecture Behavioral of uart_tx_tb is

    component uart_tx
        port (
            CLK         : IN  STD_LOGIC;
            TX_START    : IN  STD_LOGIC;  
            CLK_EN      : IN  STD_LOGIC;
            DATA_IN     : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
            TX_BUSY     : OUT STD_LOGIC;
            UART_TXD    : OUT STD_LOGIC
        );
    end component;

    component ce_gen
        generic (
            G_DIV_FACT  : POSITIVE := 500000
        );
        port (
            CLK         : IN  STD_LOGIC;
            SRST        : IN  STD_LOGIC;
            CE          : IN  STD_LOGIC;
            CE_O        : OUT STD_LOGIC 
        );
    end component;
    
    signal simulation_finished    : BOOLEAN := FALSE;
    
    signal clk          : std_logic := '0';
    signal sig_srst     : std_logic := '0';
    signal sig_ce_in    : std_logic := '1'; 
    signal sig_clk_en   : std_logic;
    
    signal tx_start     : std_logic := '0';
    signal data_in      : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_busy      : std_logic;
    signal uart_txd     : std_logic;

    constant clk_period : time := 10 ns;

begin

    ce_gen_i : ce_gen
        generic map (
            G_DIV_FACT => 10
        )
        port map (
            CLK  => clk,
            SRST => sig_srst,
            CE   => sig_ce_in,
            CE_O => sig_clk_en
        );
        
    uart_tx_i : uart_tx
        port map (
            CLK      => clk,
            TX_START => tx_start,
            CLK_EN   => sig_clk_en,
            DATA_IN  => data_in,
            TX_BUSY  => tx_busy,
            UART_TXD => uart_txd
        );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
        if simulation_finished then
            wait;
        end if;
    end process;

    proc_stim : process
    begin

        wait for clk_period * 5;
        data_in  <= "01010101";
        tx_start <= '1';
        wait for clk_period;
        tx_start <= '0';
        
        wait until tx_busy = '0';
        wait for 100 ns;

        
        
        wait for clk_period * 5;
        simulation_finished <= TRUE;
        wait;
    end process;

end Behavioral;