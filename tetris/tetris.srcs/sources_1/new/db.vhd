----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2019 11:16:37 AM
-- Design Name: 
-- Module Name: db - Behavioral
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

entity db is
  Port (clk,D_in : in std_logic;
        Q_out: out std_logic);
end db;

architecture Behavioral of db is

signal Q1, Q2, Q3 : std_logic;

begin

process(clk)
begin
   if (clk'event and clk = '1') then
     Q1 <= D_in;
     Q2 <= Q1;
     Q3 <= Q2;
   end if;
end process;

Q_out <= Q1 and Q2 and (not Q3);

end Behavioral;
