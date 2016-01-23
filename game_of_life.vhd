library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package game_of_life is
	function live_or_die(env: in std_logic_vector(8 downto 0)) return std_logic;
	function perform_step(
			row_a: in std_logic_vector;
			row_b: in std_logic_vector;
			row_c: in std_logic_vector
		) return std_logic_vector;

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end game_of_life;

package body game_of_life is

	function live_or_die(env: in std_logic_vector(8 downto 0)) return std_logic is
		variable sum: unsigned(3 downto 0) := "0000";
	begin
		for i in 0 to 8 loop
			if env(i) = '1' then
				sum := sum + 1;
			end if;
		end loop;
		if sum = 3 then
			return env(4);
		elsif sum = 4 then
			return '1';
		else
			return '0';
		end if;
	end live_or_die;
	
	function perform_step(
			row_a: in std_logic_vector;
			row_b: in std_logic_vector;
			row_c: in std_logic_vector
		) return std_logic_vector is
	begin
		return row_a;
	end perform_step;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end game_of_life;
