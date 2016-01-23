----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:22:42 01/23/2016 
-- Design Name: 
-- Module Name:    life_column - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.game_of_life.perform_step;

entity life_column is
	port (clka : in std_logic;
			trigger: in std_logic;
			
			
			clkb : in std_logic;
			addrb : in std_logic_vector(12 downto 0);
			doutb : out std_logic_vector(0 downto 0)
			);
end life_column;

architecture behavioral of life_column is

	component memory_column
	  port (
		 clka : in std_logic;
		 wea : in std_logic_vector(0 downto 0);
		 addra : in std_logic_vector(7 downto 0);
		 dina : in std_logic_vector(31 downto 0);
		 douta : out std_logic_vector(31 downto 0);
		 
		 clkb : in std_logic;
		 web : in std_logic_vector(0 downto 0);
		 addrb : in std_logic_vector(12 downto 0);
		 dinb : in std_logic_vector(0 downto 0);
		 doutb : out std_logic_vector(0 downto 0)
	  );
	end component;
	
	type STATE_TYPE is (IDLE, FIRST, LOOPING);
	signal state: STATE_TYPE;
	
	signal we: std_logic;
	signal addra : std_logic_vector(7 downto 0);
	signal dina : std_logic_vector(31 downto 0);
	signal douta : std_logic_vector(31 downto 0);
	
	signal row_a: std_logic_vector(31 downto 0);
	signal row_b: std_logic_vector(31 downto 0);
	signal row_c: std_logic_vector(31 downto 0);
	signal new_row: std_logic_vector(31 downto 0);
	
	signal write_phase: std_logic;
	signal step: unsigned(7 downto 0);
	signal step_next: unsigned(7 downto 0);
	constant HEIGHT: unsigned(7 downto 0) := "11111110"; -- 254
	
begin
	mem : memory_column
	  PORT MAP (
		 clka => clka,
		 wea(0) => we,
		 addra => addra,
		 dina => new_row,
		 douta => douta,
		 clkb => clkb,
		 web => "0",
		 addrb => addrb,
		 dinb => "0",
		 doutb => doutb
	  );
	
	
	new_row <= perform_step(row_a, row_b, row_c);
	
	we <= write_phase;
	addra <= std_logic_vector(step) when write_phase = '1' else std_logic_vector(step + 1);
	

	loop_or_not: process(clka)
	begin
		if rising_edge(clka) then
			if state = IDLE and trigger = '1' then		-- triggered
				write_phase <= '0';
				state <= FIRST;
				step <= (others => '0');
			elsif state = FIRST then	-- initialize signals
				state <= LOOPING;
				step <= step + 1;
				row_b <= (others => '0');
				row_c <= douta;
				
			elsif state = LOOPING then	-- actual "loop" body
				write_phase <= not write_phase;
				if write_phase = '0' then		-- read phase
					row_a <= row_b;
					row_b <= row_c;
					-- reading is happening now
					row_c <= douta;			
				else									-- write phase
					-- writing has just happened
					if step = HEIGHT then
						state <= IDLE;
					else
						step <= step + 1;
					end if;
				end if;
				
			end if;
		end if;
	end process;

end behavioral;

