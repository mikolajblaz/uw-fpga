----------------------------------------------------------------------------------
-- Company: University of Warsaw
-- Author: Szymon Acedañski
--
-- Creation date: 08.03.2011
--
-- Description: PLD laboratory - generic 7-segment display driver with dots
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.bcdconv.to_bcd;

entity segdriver is
  generic(n_digits: natural);
  port (
   nrst: in  std_logic;
	clk:  in  std_logic;
	n:    in  std_logic_vector(4 * n_digits - 1 downto 0);
	dots: in  std_logic_vector(n_digits - 1 downto 0) := (others => '0');
	seg:  out std_logic_vector(0 to 7);
	an:   out std_logic_vector(n_digits - 1 downto 0));
end segdriver;

architecture behavioral of segdriver is
	signal bcd: std_logic_vector(4 * n_digits - 1 downto 0);
	signal current_digit: std_logic_vector(3 downto 0);	
	signal seg_sig: std_logic_vector(0 to 7);	
	signal an_sig: std_logic_vector(n_digits - 1 downto 0);
	signal cnt: integer range 0 to n_digits - 1;
begin
   bcd <= to_bcd(n);
	
	an <= an_sig when nrst = '1' else (others => '0');
	seg <= seg_sig when nrst = '1' else (others => '0');
	
	segconv: entity work.bcd2digit port map (
		current_digit,
		seg_sig(0 to 6));
	
   current_digit <= bcd(4 * cnt + 3 downto 4 * cnt);
	seg_sig(7) <= dots(cnt);

	process (nrst, clk) is
	begin
	   if nrst = '0' then
			cnt <= 0;
			an_sig <= (0 => '0', others => '1');
		elsif rising_edge(clk) then
			if cnt = n_digits - 1 then
				cnt <= 0;
			else
				cnt <= cnt + 1;
			end if;
			an_sig <= an_sig(an_sig'left - 1 downto 0) & an_sig(an_sig'left);
		end if;
	end process;
end behavioral;

