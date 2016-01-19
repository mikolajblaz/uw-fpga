----------------------------------------------------------------------------------
-- Company: University of Warsaw
-- Author: Szymon Acedañski
--
-- Creation date: 08.03.2011
--
-- Description: PLD laboratory - generic clock divider
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clockdiv is
	generic (div: natural);
   port (
		rst : in  STD_LOGIC;
      x   : in  STD_LOGIC;
      y   : out STD_LOGIC);
end clockdiv;

architecture Behavioral of clockdiv is
	signal counter: natural range 0 to div/2 - 1;
	signal o: std_logic;
begin
	y <= o;
	process (rst, x) is
	begin
		if rst = '1' then
		   counter <= 0;
			o <= '0';
		elsif rising_edge(x) then
		   if counter = div/2 - 1 then
				counter <= 0;
				o <= not o;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;
end Behavioral;

