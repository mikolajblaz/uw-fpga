----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:26:36 01/19/2016 
-- Design Name: 
-- Module Name:    display_logic - behavioral 
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

entity display_logic is
	port (mem_clk: in std_logic;
			mem_rst: in std_logic;
			mem_init: in std_logic;
			v_clk: in std_logic;
			v_rst: in std_logic;
			vx: in std_logic_vector(7 downto 0);
			vy: in std_logic_vector(7 downto 0);
			vblank: in std_logic;
			vout: out std_logic_vector(7 downto 0));
end display_logic;

architecture behavioral of display_logic is	
	signal mem_addra: std_logic_vector(10 downto 0);
	signal mem_dina: std_logic_vector(31 downto 0);
	signal mem_wea_v: std_logic_vector(0 downto 0);
	alias mem_wea: std_logic is mem_wea_v(0);
	
	signal vpixel_v: std_logic_vector(0 downto 0);
	alias vpixel: std_logic is vpixel_v(0);
	
	alias x_addra: std_logic_vector(2 downto 0) is mem_addra(2 downto 0);
	alias y_addra: std_logic_vector(7 downto 0) is mem_addra(10 downto 3);
	
	type STATE_TYPE is (INIT, ACTIVE);
	signal state: STATE_TYPE;
	
	signal init_counter: unsigned(31 downto 0);
	signal do_loop: std_logic;
	signal x_counter: unsigned(2 downto 0);
	signal y_counter: unsigned(7 downto 0);
	constant XMAX: unsigned(2 downto 0) := "111";      -- 7 = (256 / 32) - 1
	constant YMAX: unsigned(7 downto 0) := "11000000"; -- 192

	component videomem
	  port (
		 clka : in std_logic;
		 wea : in std_logic_vector(0 downto 0);
		 addra : in std_logic_vector(10 downto 0);
		 dina : in std_logic_vector(31 downto 0);
		 clkb : in std_logic;
		 rstb : in std_logic;
		 addrb : in std_logic_vector(15 downto 0);
		 doutb : out std_logic_vector(0 downto 0)
	  );
	end component;
	
	-- Synplicity black box declaration
	attribute syn_black_box : boolean;
	attribute syn_black_box of videomem: component is true;

begin
	vout <= (others => '0') when vblank = '1' or vpixel = '0' else (others => '1');

	mem : videomem
	  PORT MAP (
		 clka => mem_clk,
		 wea => mem_wea_v,
		 addra => mem_addra,
		 dina => mem_dina,
		 
		 clkb => v_clk,
		 rstb => v_rst,
		 addrb(7 downto 0) => vx,
		 addrb(15 downto 8) => vy,

		 doutb => vpixel_v
	  );
	
	-- change states
	-- asynchronous reset, TODO: needed?
	states: process(mem_clk, mem_rst)
	begin
		if rising_edge(mem_clk) then
			if mem_rst = '1' or (mem_init = '1' and state = ACTIVE) then
				state <= INIT;
				init_counter <= (others => '0');
			elsif mem_init = '0' and state = INIT then
				state <= ACTIVE;
			end if;
		end if;
	end process;

	-- initialize memory
	init_memory: process(mem_clk)
	begin
		if rising_edge(mem_clk) then
			if state = INIT then
			
			end if;
		end if;
	end process;
	
	-- loop horizontally
	loop_x: process(mem_clk)
	begin
		if rising_edge(mem_clk) then
			if mem_rst = '1' then
				x_counter <= (others => '0');
         elsif do_loop = '1' then
				if x_counter = XMAX then
					x_counter <= (others => '0');
				else
					x_counter <= x_counter + 1;
				end if;
			end if;
		end if;
	end process;
	
	-- loop vartically
	loop_y: process(mem_clk)
	begin
		if rising_edge(mem_clk) then
			if mem_rst = '1' then
				y_counter <= (others => '0');
         elsif do_loop = '1' and x_counter = XMAX then
				if y_counter = YMAX then
					y_counter <= (others => '0');
				else
					y_counter <= y_counter + 1;
				end if;
			end if;
		end if;
	end process;
	
end behavioral;

