library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity simple_adder is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0);
           C : out STD_LOGIC
   );
end simple_adder;

architecture Behavioral of simple_adder is
    SIGNAL a_uns, b_uns: unsigned(A'length-1 downto 0);
    SIGNAL y_uns: unsigned(A'length downto 0);
begin
    a_uns <= unsigned(A);
    b_uns <= unsigned(B);
    y_uns <= resize(a_uns, A'length+1) + resize(b_uns, A'length+1);
    Y <= std_logic_vector(y_uns(A'length-1 downto 0));
    C <= std_logic(y_uns(A'length));

end Behavioral;
