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
use work.game_of_life.perform_step;

entity life_manager is
	port (rst: in std_logic;
			clk: in std_logic;
			trigger: in std_logic;
--			mem_init: in std_logic;
			
			vclk: in std_logic;
			vx: in std_logic_vector(7 downto 0);
			vy: in std_logic_vector(6 downto 0);
			vblank: in std_logic;
			vout: out std_logic_vector(7 downto 0)
			);
end life_manager;

architecture behavioral of life_manager is
	type STATE_TYPE is (IDLE, INIT, ACTIVE);
	signal state: STATE_TYPE;
	
	signal last_trigger: std_logic;
	signal true_triggers: std_logic_vector(3 downto 0);
	signal active_block: std_logic_vector(3 downto 0);
	
	signal ra_1: std_logic_vector(31 downto 0);
	signal rb_1: std_logic_vector(31 downto 0);
	signal rc_1: std_logic_vector(31 downto 0);
	signal ra_2: std_logic_vector(31 downto 0);
	signal rb_2: std_logic_vector(31 downto 0);
	signal rc_2: std_logic_vector(31 downto 0);
	signal ra_3: std_logic_vector(31 downto 0);
	signal rb_3: std_logic_vector(31 downto 0);
	signal rc_3: std_logic_vector(31 downto 0);
	signal ra_4: std_logic_vector(31 downto 0);
	signal rb_4: std_logic_vector(31 downto 0);
	signal rc_4: std_logic_vector(31 downto 0);
	
	signal ra: std_logic_vector(31 downto 0);
	signal rb: std_logic_vector(31 downto 0);
	signal rc: std_logic_vector(31 downto 0);
	signal ext_left: std_logic_vector(2 downto 0);
	signal ext_right: std_logic_vector(2 downto 0);
	
	signal new_row: std_logic_vector(31 downto 0);
	
	--	signal init_counter: unsigned(31 downto 0);
	
	-- DISPLAY
	alias block_idx: std_logic_vector(1 downto 0) is vy(6 downto 5);
	signal addrb: std_logic_vector(12 downto 0);
	signal doutb: std_logic_vector(0 downto 0);
	
	signal doutb_all_1: std_logic_vector(0 downto 0);
	signal doutb_all_2: std_logic_vector(0 downto 0);
	signal doutb_all_3: std_logic_vector(0 downto 0);
	signal doutb_all_4: std_logic_vector(0 downto 0);
	
	alias vpixel: std_logic is doutb(0);

begin
	block1: entity work.life_column port map(rst, clk, true_triggers(3), vclk, addrb, doutb_all_1,
														  ra_1, rb_1, rc_1, new_row, active_block(3));
	block2: entity work.life_column port map(rst, clk, true_triggers(2), vclk, addrb, doutb_all_2,
														  ra_2, rb_2, rc_2, new_row, active_block(2));
	block3: entity work.life_column port map(rst, clk, true_triggers(1), vclk, addrb, doutb_all_3,
														  ra_3, rb_3, rc_3, new_row, active_block(1));
	block4: entity work.life_column port map(rst, clk, true_triggers(0), vclk, addrb, doutb_all_4,
														  ra_4, rb_4, rc_4, new_row, active_block(0));
--	block3: entity work.life_column port map(rst, clk, true_trigger, clk, addrb, doutb_all_3);
--	block4: entity work.life_column port map(rst, clk, true_trigger, clk, addrb, doutb_all_4);

--	doutb <= doutb_all_1(1 downto 0) & doutb_all_2(1 downto 0) & doutb_all_3(1 downto 0) & doutb_all_4(1 downto 0);	
	
	-- one "life module" for all memory blocks
	new_row <= perform_step(ra, rb, rc, ext_left, ext_right);
	ra <= ra_1 when active_block = "1000" else
			ra_2 when active_block = "0100" else
			ra_3 when active_block = "0010" else
			ra_4;

	rb <= rb_1 when active_block = "1000" else
			rb_2 when active_block = "0100" else
			rb_3 when active_block = "0010" else
			rb_4;
	
	rc <= rc_1 when active_block = "1000" else
			rc_2 when active_block = "0100" else
			rc_3 when active_block = "0010" else
			rc_4;
	
	ext_left <= "111" when active_block = "1000" else
					ra_1(0) & rb_1(0) & rc_1(0) when active_block = "0100" else
					ra_2(0) & rb_2(0) & rc_2(0) when active_block = "0010" else
					ra_3(0) & rb_3(0) & rc_3(0);
	
	ext_right <= ra_2(31) & rb_2(31) & rc_2(31) when active_block = "1000" else
					 ra_3(31) & rb_3(31) & rc_3(31) when active_block = "0100" else
					 ra_4(31) & rb_4(31) & rc_4(31) when active_block = "0010" else
					 "111";
	
	-- Trigger all block sequentially
	triggers: process(clk, rst)
	begin
		if rst = '1' then
			last_trigger <= '0';
			true_triggers <= (others => '0');
		elsif rising_edge(clk) then
			last_trigger <= trigger;
			if trigger = '1' and last_trigger = '0' then
				true_triggers <= "1000";
			else
				true_triggers <= '0' & true_triggers(3 downto 1);	-- shift right
			end if;
		end if;
	end process;
	
	
	-- DISPLAY
	vout <= (others => '0') when vblank = '1' or vpixel = '0' else (others => '1');
	
	-- The view is mirrored!
	addrb <= vx & vy(4 downto 0);
	doutb <= doutb_all_4 when block_idx = "00" else
				doutb_all_3 when block_idx = "01" else
				doutb_all_2 when block_idx = "10" else
				doutb_all_1;	-- "11"
	
	
end behavioral;

