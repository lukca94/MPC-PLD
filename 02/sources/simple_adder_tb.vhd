----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2026 09:40:48 AM
-- Design Name: 
-- Module Name: simple_adder_tb - Behavioral
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

entity simple_adder_tb is
--  Port ( );
end simple_adder_tb;

architecture Behavioral of simple_adder_tb is
    component simple_adder
        Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Y : out STD_LOGIC_VECTOR (3 downto 0);
               C : out STD_LOGIC
       );
    end component;
    
    SIGNAL a_sig : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL b_sig : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL y_sig : STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL c_sig : STD_LOGIC;
begin

    simple_adder_1 : simple_adder
    Port map ( 
        A => a_sig,
        B => b_sig,
        Y => y_sig,
        C => c_sig
    );
    proc_stim_gen : PROCESS
    begin
        LOOP_1 : FOR i IN 15 downto 0 LOOP
            LOOP_2 : FOR j IN 15 downto 0 LOOP
                a_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(i,a_sig'LENGTH));
                b_sig <= STD_LOGIC_VECTOR(TO_UNSIGNED(j,b_sig'LENGTH));
                WAIT for 10 ns;
            END LOOP LOOP_2;
        END LOOP LOOP_1;               
    end PROCESS proc_stim_gen;
    
    proc_output_ver : PROCESS
        VARIABLE cnt_err : INTEGER := 0;
        VARIABLE y_ref : STD_LOGIC_VECTOR(y_sig'LENGTH downto 0);
    begin
        WAIT ON a_sig, b_sig;
        y_ref := STD_LOGIC_VECTOR(UNSIGNED(a_sig) + UNSIGNED(b_sig));
        WAIT FOR 0 ns;
        IF NOT (y_sig = y_ref) THEN 
            REPORT 
                "ERROR in addition: A = " & INTEGER'image(to_integer(unsigned(a_sig))) &
                " B = " & INTEGER'image(to_integer(unsigned(b_sig))) &
                " actual Y = " & INTEGER'image(to_integer(unsigned(y_sig))) &
                " expected Y = " & INTEGER'image(to_integer(unsigned(y_ref(y_sig'LENGTH-1 downto 0)))) &
                " actual C = " & STD_LOGIC'image(c_sig) &
                " expected C = " & STD_LOGIC'image(y_ref(y_sig'LENGTH)) 
            SEVERITY ERROR;
            cnt_err := cnt_err + 1;
        END IF;
    end PROCESS proc_output_ver;
              

end Behavioral;
