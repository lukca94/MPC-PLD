----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2026 09:32:30 AM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
  Port 
  (
        CLK         : IN STD_LOGIC;
        TX_START    : IN STD_LOGIC;  
        CLK_EN      : IN STD_LOGIC;
        DATA_IN     : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        TX_BUSY     : OUT STD_LOGIC;
        UART_TXD    : OUT STD_LOGIC := '1'
  );
end uart_tx;

architecture Behavioral of uart_tx is
    type module_state is (st_idle, st_store, st_wait, st_send);
    signal current_state    : module_state := st_idle;
    signal next_state       : module_state;   
    signal busy             : STD_LOGIC := '0';
    signal count_over       : STD_LOGIC := '0';
    signal count_reset      : STD_LOGIC := '1';
    signal count            : INTEGER := 0;
    signal transmit         : STD_LOGIC := '0';
    signal bit_storage      : STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
    
begin
    uart_tx : process (CLK)
    begin
        if rising_edge(CLK) then
            current_state <= next_state;
        end if;    
    end process uart_tx;    

    fsm : process (CLK_EN, TX_START, count_over, current_state)
    begin
        case current_state is
            when st_idle =>  
                if (TX_START = '1')                         then next_state <= st_store;
                else next_state <= st_idle;
                end if;
            when st_store =>  
                next_state <= st_wait;
            when st_wait =>
                if (CLK_EN = '1')                           then next_state <= st_send;
                else next_state <= st_wait;
                end if;
            when st_send =>
                if (count_over = '1')                       then next_state <= st_idle;
                else
                    next_state <= st_send;
                end if;          
        end case; 
    end process fsm;
    
    fsm_actions : process (current_state)
    begin
        case current_state is
            when st_idle =>
                count_reset <= '1';
                busy <= '0';
                transmit <= '0';
            when st_store =>  
                busy <= '1';
            when st_wait =>
                count_reset <= '0';
                transmit <= '1';        
            when st_send =>
                NULL;
        end case; 
    end process fsm_actions;
    
    bit_storage_reg : process (CLK)
    begin
        if rising_edge(CLK) then
            if current_state = st_store then
                bit_storage <= '1' & DATA_IN & '0';
            end if;
        end if;
    end process;
    
    bit_counter : process (CLK)
    begin
        if rising_edge(CLK) then
            if (CLK_EN = '1') then
                if (count_reset = '1') then
                    count <= 0;
                    count_over <= '0';
                elsif (count = 9) then
                    count_over <= '1';
                else
                    count <= count + 1;
                    count_over <= '0';
                end if;
            end if;
        end if;
    end process bit_counter;
    
    transmitter : process (CLK)
    begin
        if rising_edge(CLK) then
            if (CLK_EN = '1') then
                if (transmit = '1') then
                    UART_TXD <= bit_storage(count);
                else 
                    UART_TXD <= '1';
                end if;
            end if;
        end if;
    end process transmitter;
    

    TX_BUSY <= busy;

end Behavioral;
