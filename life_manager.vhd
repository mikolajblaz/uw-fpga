----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:41:24 01/23/2016 
-- Design Name: 
-- Module Name:    life_manager - behavioral 
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

entity life_manager is
	port (rst: in std_logic;
			clk: in std_logic;
			trigger: in std_logic;
			doutb: out std_logic_vector(7 downto 0);
			
			addrb: in std_logic_vector(7 downto 0);
			enable_b: in std_logic
--			mem_rst: in std_logic;
--			mem_init: in std_logic;
			
--			v_clk: in std_logic;
--			v_rst: in std_logic;
--			vx: in std_logic_vector(7 downto 0);
--			vy: in std_logic_vector(7 downto 0);
--			vblank: in std_logic;
--			vout: out std_logic_vector(7 downto 0)
			);
end life_manager;

architecture behavioral of life_manager is
--	signal vpixel_v: std_logic_vector(0 downto 0);
--	alias vpixel: std_logic is vpixel_v(0);
--	
	type STATE_TYPE is (IDLE, INIT, ACTIVE);
	signal state: STATE_TYPE;
	
	signal last_trigger: std_logic;
	signal true_trigger: std_logic;
	signal doutb_all: std_logic_vector(31 downto 0);
	
--	signal init_counter: unsigned(31 downto 0);
--	signal do_loop: std_logic;
--	signal x_counter: unsigned(2 downto 0);
--	signal y_counter: unsigned(7 downto 0);
--	constant XMAX: unsigned(2 downto 0) := "111";      -- 7 = (256 / 32) - 1
--	constant YMAX: unsigned(7 downto 0) := "11000000"; -- 192
begin
--	vout <= (others => '0') when vblank = '1' or vpixel = '0' else (others => '1');
	
	block1: entity work.life_column port map(rst, clk, true_trigger, clk, addrb, doutb_all, enable_b, "111", "111");
	doutb <= doutb_all(7 downto 0);
	
	true_trigger <= '1' when trigger = '1' and last_trigger = '0' else '0';
	
	tr: process(clk)
	begin
		if rising_edge(clk) then
			last_trigger <= trigger;
		end if;
	end process;
	
	-- change states
	-- asynchronous reset, TODO: needed?
--	states: process(clk)
--	begin
--		if rising_edge(clk) then
--			if mem_rst = '1' then
--				state <= INIT;
--				init_counter <= (others => '0');
--				-- TODO
--			elsif mem_init = '1' and state = ACTIVE then
--				state <= INIT;
--				init_counter <= (others => '0');
--			elsif mem_init = '0' and state = INIT then
--				state <= ACTIVE;
--			end if;
--		end if;
--	end process;

	-- initialize memory
--	init_memory: process(clk)
--	begin
--		if rising_edge(clk) then
--			if state = INIT then
--			
--			end if;
--		end if;
--	end process;	
end behavioral;

