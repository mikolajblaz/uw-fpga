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
	port (rst: in std_logic;
			clka : in std_logic;
			trigger: in std_logic;
			
			
			clkb : in std_logic;
			addrb : in std_logic_vector(12 downto 0);
			doutb : out std_logic_vector(0 downto 0);
			
			row_a_out: out std_logic_vector(31 downto 0);
			row_b_out: out std_logic_vector(31 downto 0);
			row_c_out: out std_logic_vector(31 downto 0);
			new_row: in std_logic_vector(31 downto 0);
			
			will_write: out std_logic
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
	
	-- Synplicity black box declaration
	attribute syn_black_box : boolean;
	attribute syn_black_box of memory_column: component is true;
	
	type STATE_TYPE is (IDLE, FIRST, LOOPING);
	type WRITE_PHASE_TYPE is (READ_DELAY, DO_READ, WRITE_DELAY, DO_WRITE);
	signal state: STATE_TYPE;
	signal write_phase: WRITE_PHASE_TYPE;
	
	signal we: std_logic;
	signal addra : std_logic_vector(7 downto 0);
	signal douta : std_logic_vector(31 downto 0);
	
	signal row_a: std_logic_vector(31 downto 0);
	signal row_b: std_logic_vector(31 downto 0);
	signal row_c: std_logic_vector(31 downto 0);
	--signal new_row: std_logic_vector(31 downto 0);
	
	--signal write_phase: std_logic;
	signal step: unsigned(7 downto 0);
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
		 dinb => (others => '0'),
		 doutb => doutb
	  );
	
	row_a_out <= row_a;
	row_b_out <= row_b;
	row_c_out <= row_c;
	
	we <= '1' when write_phase = DO_WRITE else '0';
	will_write <= we;
	addra <= std_logic_vector(step) when write_phase = DO_WRITE else std_logic_vector(step + 1);

	loop_or_not: process(clka)
	begin
		if rising_edge(clka) then
			if rst = '1' then
				state <= IDLE;
				write_phase <= READ_DELAY;
				step <= (others => '0');
				row_a <= (others => '0');
				row_b <= (others => '0');
				row_c <= (others => '0');
			elsif state = IDLE and trigger = '1' then		-- triggered
				write_phase <= READ_DELAY;
				state <= FIRST;
				step <= (others => '0');
			elsif state = FIRST then	-- initialize signals
				state <= LOOPING;
				step <= step + 1;
				row_b <= (others => '0');
				row_c <= douta;
				
			elsif state = LOOPING then	-- actual "loop" body
				if write_phase = READ_DELAY then
					write_phase <= DO_READ;
				elsif write_phase = DO_READ then			-- set addresses
					write_phase <= WRITE_DELAY;
					row_a <= row_b;
					row_b <= row_c;
					-- reading is happening now
					row_c <= douta;
				elsif write_phase = WRITE_DELAY then
					write_phase <= DO_WRITE;
				elsif write_phase = DO_WRITE then	-- write phase
					write_phase <= READ_DELAY;
					-- writing has just happened
					if step = HEIGHT then
						state <= IDLE;
						step <= (others => '0');
					else
						step <= step + 1;
					end if;
				end if;
			end if;
		end if;
	end process;

end behavioral;

