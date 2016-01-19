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
	generic (x_width: natural range 1 to 12 := 8;
				y_width: natural range 1 to 12 := 7);
	port (mem_clk: in std_logic;
			vclk: in std_logic;
			mem_rst: in std_logic;
			rstb: in std_logic;
			vx: in std_logic_vector(x_width - 1 downto 0);
			vy: in std_logic_vector(y_width - 1 downto 0);
			vblank: in std_logic;
			vout: out std_logic_vector(7 downto 0));
end display_logic;

architecture behavioral of display_logic is
	signal vpixelb: std_logic_vector(0 downto 0);
	alias vpixel: std_logic is vpixelb(0);

--	signal mem_wea: std_logic;
--	signal mem_addra: std_logic_vector(14 downto 0);
--	signal mem_dina: std_logic_vector(2 downto 0);	
	
--	component videomem
--	port (
--		clka: IN std_logic;
--		wea: IN std_logic_VECTOR(0 downto 0);
--		addra: IN std_logic_VECTOR(14 downto 0);
--		dina: IN std_logic_VECTOR(2 downto 0);
--		clkb: IN std_logic;
--		rstb: IN std_logic;
--		addrb: IN std_logic_VECTOR(14 downto 0);
--		doutb: OUT std_logic_VECTOR(2 downto 0));
--	end component;
--	
--	-- Synplicity black box declaration
--	attribute syn_black_box : boolean;
--	attribute syn_black_box of videomem: component is true;

	signal mem_wea: std_logic;
	signal mem_addra: std_logic_vector(1 downto 0);
	signal mem_dina: std_logic_vector(0 downto 0);
	
	component vm
	port (
		clka: IN std_logic;
		wea: IN std_logic_VECTOR(0 downto 0);
		addra: IN std_logic_VECTOR(1 downto 0);
		dina: IN std_logic_VECTOR(0 downto 0);
		clkb: IN std_logic;
		rstb: IN std_logic;
		addrb: IN std_logic_VECTOR(1 downto 0);
		doutb: OUT std_logic_VECTOR(0 downto 0));
	end component;
	
	-- Synplicity black box declaration
	attribute syn_black_box : boolean;
	attribute syn_black_box of vm: component is true;
	
	--	signal mem_wea: std_logic;
	--	signal mem_addra: std_logic_vector(14 downto 0);
	--	signal mem_dina: std_logic_vector(2 downto 0);	

begin
	--vpixel <= vpixelb(0);
	--vout <= (others => '0') when vpixel = '0' else (others => '1');
	vout <= (others => '0') when vblank = '1' or vpixel = '0' else (others => '1');
	-- "11100000"
	
--	mem : videomem
--		port map (
--			clka => mem_clk,
--			wea(0) => mem_wea,
--			addra => mem_addra,
--			dina => mem_dina,
--			
--			clkb => vclk,
--			rstb => rst,
--			addrb(6 downto 0) => vypostf,
--			addrb(14 downto 7) => vxpostf,
--			doutb => vpixel
--		);

	mem : vm
		port map (
			clka => mem_clk,
			wea(0) => mem_wea,
			addra => mem_addra,
			dina => mem_dina,
			
			clkb => vclk,
			rstb => rstb,
			addrb(1) => vy(5),
			addrb(0) => vx(5),
			doutb => vpixelb
		);
		
	--mem_wea <= '1';
	mem_wea <= '1';
	mem_addra <= "11";

	set: process (mem_rst)
	begin
		if mem_rst = '1' then
			mem_dina <= "1";
		else
			mem_dina <= "0";
		end if;
	end process;

	--vpixel <= not vblank;
--	vout_gen: process (vblank)
--	begin
--		if vblank = '0' then
--			vpixel <= '1';
----			-- Quite stupid grayscale encoding
----			vout(7 downto 5) <= "111";
----			vout(4 downto 2) <= vpixel;
----			vout(1 downto 0) <= vpixel;
--		else
--			vpixel <= '0';
--		end if;
--	end process;	
	
	--	vout_gen: process (vpixel, vblank)
--	begin
--		if vblank = '0' then
--			-- Quite stupid grayscale encoding
--			vout(7 downto 5) <= "111";
--			vout(4 downto 2) <= vpixel;
--			vout(1 downto 0) <= vpixel;
--		else
--			vout <= (others => '0');
--		end if;
--	end process;

end behavioral;

