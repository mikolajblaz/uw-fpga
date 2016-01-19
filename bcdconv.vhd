library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package bcdconv is
	function to_bcd(bin: in std_logic_vector) return std_logic_vector;
end bcdconv;

package body bcdconv is
function to_bcd(bin: in std_logic_vector) return std_logic_vector is
   constant n: natural := bin'length;
   constant q: natural := n / 4;
   variable i: integer:=0;
   variable j: integer:=1;
   variable bcd: unsigned(((4*q)-1) downto 0) := (others => '0');
   variable bint: unsigned((n-1) downto 0) := unsigned(bin);
begin
   for i in 0 to n-1 loop
      for j in 1 to q loop
         if bcd(((4*j)-1) downto ((4*j)-4)) > 4 then
            bcd(((4*j)-1) downto ((4*j)-4)) := bcd(((4*j)-1) downto ((4*j)-4)) + 3;
         end if;
      end loop;
		bcd := bcd sll 1;
      bcd(0) := bint(n-1);
		bint := bint sll 1;
   end loop;
   return std_logic_vector(bcd);
end to_bcd;

end bcdconv;

---------------------