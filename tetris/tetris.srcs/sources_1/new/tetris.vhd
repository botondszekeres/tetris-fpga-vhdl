----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2019 11:14:58 AM
-- Design Name: 
-- Module Name: tetris - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tetris is
  Port (clk,L,R,Rot: in std_logic;
        JC,JXADC,JB: out std_logic_vector(0 to 7) );
end tetris;

architecture Behavioral of tetris is

signal Q1,Q2,Q3,Q4,Q5,Q6 : std_logic;
signal sell,selr,selrot : std_logic := '0';
signal Rdb,Ldb,Rotate : std_logic;
component random is
Port ( clock : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR (7 downto 0));
end component;
signal rand : std_logic_vector(7 downto 0) := "00000000";

----afisare
signal catod : std_logic_vector(0 to 15) := "0111111111111111";
signal div : integer range 0 to 50000 := 0;
signal div1 : integer range 0 to 33333334 := 0;
signal flag : std_logic := '0';
signal anod : std_logic_vector(0 to 7) := "00000000";
type mat is array(0 to 15) of std_logic_vector(0 to 7);
signal MATRICE : mat := ("00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000");

signal STORED : mat :=  ("00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000");
                         
signal GAMEOVER : mat :=("00000000",
                         "01000010",
                         "11100111",
                         "01000010",
                         "00000000",
                         "00000000",
                         "01111110",
                         "10000001",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000",
                         "00000000");

signal lose : std_logic := '0';
                       
--joc
type int_array is array(0 to 3) of integer;
type shape is array(0 to 6) of int_array;
signal shapes : shape := ((1,3,5,7),
                          (2,4,5,7),
                          (3,5,4,6),
                          (3,5,4,7),
                          (2,3,5,7),
                          (3,5,7,6),
                          (2,3,4,5));
                          
signal ax,bx,cx: int_array := (4,4,4,4);
signal ay,by,cy : int_array := (0,1,2,3);

begin

-------------------afisare
process(clk)
begin
    if(rising_edge(clk)) then
        div <= div + 1;
        if(div = 49999) then 
            if(flag = '0') then
                flag <= '1';
            else 
                flag <= '0';
            end if;
        end if;
    end if;
end process;

process(flag)
variable i : integer range 0 to 15 := 0 ;
begin
    if(rising_edge(flag)) then
        anod <= MATRICE(i+1);
        catod <= catod(15) & catod(0 to 14);
        i := i+1;
    end if;
end process;

JC <= catod(8 to 15);
JXADC <= catod(0 to 7);
JB <= anod;

------------------joc
randgen: random port map(flag,rand);

process(clk,Ldb,Rdb)
variable free : std_logic;
variable r : integer;
variable k : integer;
variable count1 : integer;
variable axx : int_array := ax;
variable bxx : int_array := bx;
variable ayy : int_array := ay;
variable byy : int_array := by;
variable px : integer;
variable py : integer;
variable sx : integer;
variable sy : integer;
begin
           
    
    if(rising_edge(clk)) then
        div1 <= div1 + 1;
        
        if(lose = '1') then
            STORED <= (others => "00000000");
            MATRICE <= GAMEOVER;
        else
        
        if(div1 = 33333329) then
        k := 15;
           for i in 15 downto 1 loop
            count1 := 0;
            for j in 0 to 7 loop
               if (STORED(i)(j) = '1') then count1 := count1 + 1; end if;
               STORED(k)(j) <= STORED(i)(j);
               MATRICE(k)(j) <= MATRICE(i)(j) or STORED(i)(j);
            end loop;
            if(count1 < 8) then k := k-1; end if;
        end loop;
        end if;
        if(div1 = 33333330) then------------------
            if(selrot = '1') then
                
                for i in 0 to 3 loop
                    bxx(i) := axx(i);
                    byy(i) := ayy(i);
                end loop;
                
                px := axx(1);
                py := ayy(1);
                
                for i in 0 to 3 loop
                    sx := ayy(i) - py;
                    sy := axx(i) -px;
                    axx(i) := px - sx;
                    ayy(i) := py + sy;
                end loop;
                
                free := '1';
                for i in 0 to 3 loop
                    if(axx(i)>7 or axx(i)<0 or ayy(i)>15) then free := '0';
                        elsif(STORED(ayy(i))(axx(i)) = '1') then free := '0';
                    end if;
                end loop;
                
                if (free = '0') then
                    for i in 0 to 3 loop
                        axx(i) := bxx(i);
                        ayy(i) := byy(i);
                    end loop;
                end if;
                
                for i in 0 to 3 loop
                    MATRICE(byy(i))(bxx(i)) <= '0';
                end loop;
                for i in 0 to 3 loop
                    MATRICE(ayy(i))(axx(i)) <= '1';
                end loop;
                
                ax <= axx;
                ay <= ayy;
                bx <= bxx;
                by <= byy;
            end if;     
        end if;
        
        if(div1 = 33333331) then------------------
            if(selr = '1') then
            
                for i in 0 to 3 loop
                    bxx(i) := axx(i);
                    byy(i) := ayy(i);
                end loop;
            
                for i in 0 to 3 loop
                    axx(i) := axx(i) + 1;
                end loop;
                
                free := '1';
                for i in 0 to 3 loop
                    if(axx(i)>7) then free := '0';
                        elsif(STORED(ayy(i))(axx(i)) = '1') then free := '0';
                    end if;
                end loop;
                
                if (free = '0') then
                    for i in 0 to 3 loop
                        axx(i) := bxx(i);
                    end loop;
                end if;
                
                for i in 0 to 3 loop
                    MATRICE(byy(i))(bxx(i)) <= '0';
                end loop;
                for i in 0 to 3 loop
                    MATRICE(ayy(i))(axx(i)) <= '1';
                end loop;
                
                ax <= axx;
                ay <= ayy;
                bx <= bxx;
                by <= byy;
            end if;     
        end if;
        if(div1 = 33333332) then-----------------
            if(sell = '1') then
            
                for i in 0 to 3 loop
                    bxx(i) := axx(i);
                    byy(i) := ayy(i);
                end loop;
            
                for i in 0 to 3 loop
                    axx(i) := axx(i) - 1;
                end loop;
                
                free := '1';
                for i in 0 to 3 loop
                    if(axx(i)<0) then free := '0';
                        elsif(STORED(ayy(i))(axx(i)) = '1') then free := '0';
                    end if;
                end loop;
                
                if (free = '0') then
                    for i in 0 to 3 loop
                        axx(i) := bxx(i);
                    end loop;
                end if;
                
                for i in 0 to 3 loop
                    MATRICE(byy(i))(bxx(i)) <= '0';
                end loop;
                for i in 0 to 3 loop
                    MATRICE(ayy(i))(axx(i)) <= '1';
                end loop;
                
                ax <= axx;
                ay <= ayy;
                bx <= bxx;
                by <= byy;
                
            end if;
--        end if;
        
        
        end if;
        if(div1 = 33333333) then -----------
            ---tick
            for i in 0 to 3 loop
                bxx(i) := axx(i);
                byy(i) := ayy(i);
                ayy(i) := ayy(i) + 1;
            end loop;
            
            free := '1';
            for i in 0 to 3 loop
                if(ayy(i)>15) then free := '0';
                    elsif(STORED(ayy(i))(axx(i)) = '1') then free := '0';
                end if;
            end loop;
            
            if(free = '0') then
                for i in 0 to 3 loop
                    MATRICE(ayy(i))(axx(i)) <= '0';
                    STORED(byy(i))(bxx(i)) <= '1';
                 end loop;
                 
                 for i in 0 to 7 loop
                    if(STORED(1)(i) = '1') then
                        lose <= '1';
                    end if;
                end loop;
                
                r := to_integer(unsigned(rand(2 downto 0)));
                if(r = 7) then r := 6; end if;
                
                for i in 0 to 3 loop
                    axx(i) := shapes(r)(i) mod 2 + 3;
                    ayy(i) := shapes(r)(i) / 2;
                end loop;
                
                
                ------
                
                -----
            end if;
            
            for i in 0 to 3 loop
                MATRICE(byy(i))(bxx(i)) <= '0';
            end loop;
            
            for i in 0 to 3 loop
                MATRICE(ayy(i))(axx(i)) <= '1';
            end loop;
            ax <= axx;
                ay <= ayy;
                bx <= bxx;
                by <= byy;
        
        
        
          end if;
          
          
          
   end if;
    
 end if;
    
end process;

----------move
---debounce
--process(clk)
--begin
--   if (clk'event and clk = '1') then
--       Q1 <= R;
--       Q2 <= Q1;
--       Q3 <= Q2;
--   end if;
--end process;

--Rdb <= Q1 and Q2 and (not Q3);

--process(clk)
--begin
--   if (clk'event and clk = '1') then
--       Q4 <= L;
--       Q5 <= Q4;
--       Q6 <= Q5;
--   end if;
--end process;

--Ldb <= Q4 and Q5 and (not Q6);

lb: entity WORK.db port map(clk,L,Ldb);
rb: entity WORK.db port map(clk,R,Rdb);
rotb: entity WORK.db port map(clk,Rot,Rotate);

process(Rdb,div1)
begin
    if(rising_edge(Rdb)) then
        selr <= '1';
    end if;
    if(div1 = 33333333) then
        selr <= '0';
    end if;
end process;

process(Rotate,div1)
begin
    if(rising_edge(Rotate)) then
        selrot <= '1';
    end if;
    if(div1 = 33333333) then
        selrot <= '0';
    end if;
end process;

process(Ldb,div1)
begin
    if(rising_edge(Ldb)) then
        sell <= '1';
    end if;
    if(div1 = 33333333) then
        sell <= '0';
    end if;
end process;
end Behavioral;
