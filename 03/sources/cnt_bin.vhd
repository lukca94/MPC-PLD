----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2026 09:36:48 AM
-- Design Name: 
-- Module Name: cnt_bin - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cnt_bin is
    Port ( CLK : in STD_LOGIC;
           SRST : in STD_LOGIC;
           CE : in STD_LOGIC;
           CNT_LOAD : in STD_LOGIC;
           CNT_UP : in STD_LOGIC;
           CNT : out STD_LOGIC_VECTOR (31 downto 0)
   );
end cnt_bin;

architecture Behavioral of cnt_bin is
    signal cnt_sig      : STD_LOGIC_VECTOR (31 downto 0) := (OTHERS => '0');

begin

    process (CLK) begin
        IF rising_edge(CLK) THEN
            IF SRST = '1' THEN
                cnt_sig <= (OTHERS => '0');
            ELSIF CE = '1' THEN
                IF CNT_LOAD = '1' THEN
                    cnt_sig <= x"55555555";
                ELSIF CNT_UP = '1' THEN
                    cnt_sig <= STD_LOGIC_VECTOR( UNSIGNED(cnt_sig) + 1);
                ELSE
                    cnt_sig <= STD_LOGIC_VECTOR( UNSIGNED(cnt_sig) - 1);
                end IF;                
            end IF;            
        end IF;
    end process;
    
    CNT <= cnt_sig;

end Behavioral;
