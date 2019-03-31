library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random is
Port ( clock : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (7 downto 0));
end random;

architecture Behavioral of random is

--signal temp: STD_LOGIC;
signal Qt: STD_LOGIC_VECTOR(7 downto 0) := x"01";

begin

PROCESS(clock)
variable tmp : STD_LOGIC := '0';
BEGIN
IF rising_edge(clock) THEN
      tmp := Qt(4) XOR Qt(3) XOR Qt(2) XOR Qt(0);
      Qt <= tmp & Qt(7 downto 1);
end if;
END PROCESS;
-- check <= temp;
Q <= Qt;

end Behavioral;