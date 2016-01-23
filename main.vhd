----------------------------------------------------------------------------------
-- Company: University of Warsaw
-- Author: Szymon Acedanski
--
-- Creation date: 11.04.2011
-- Target Devices: Basys2, Spartan3E 100K
-- Tool versions: ISE 12.4
--
-- Description: PLD laboratory - various components: RAM, Multipliers, VGA
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 
entity demo is
  port(mclk: in  std_logic;  -- 50 MHz unstable
       uclk: in  std_logic;  -- 20 MHz stable, used for pixel clock
		 
       sw:  in  std_logic_vector(7 downto 0); 
       btn: in  std_logic_vector(3 downto 0);
       led: out std_logic_vector(7 downto 0);
       seg: out std_logic_vector(0 to 7);
       an:  out std_logic_vector(3 downto 0);
		 
		 hsync: out std_logic;
		 vsync: out std_logic;
		 vout: out std_logic_vector(7 downto 0)
		 
		 );
end entity demo;

architecture simple of demo is
begin
	seg <= sw;
	an <= "1110";
	life: entity work.life_manager port map(btn(3), mclk, btn(0), led, sw, btn(1));
	hsync <= '0';
	vsync <= '0';
	vout <= (others => '0');
end simple;

--architecture structural of demo is
--	signal rst: std_logic;
--	signal mclk_buf: std_logic;
--	signal khz_clock: std_logic;
--	signal disp_value: std_logic_vector(15 downto 0);
--	signal an_sig: std_logic_vector(3 downto 0);
--	
--	signal vclk: std_logic;
--	signal vclk1: std_logic;    -- clock from external quartz oscillator
--	signal vclk1_ok: std_logic;
--	signal vclk2: std_logic;    -- clock from unstable 50MHz source
--	signal vclk2_ok: std_logic;
--	signal vx: std_logic_vector(7 downto 0);
--	signal vy: std_logic_vector(7 downto 0);
--	signal vblank: std_logic;
--	signal v_rst: std_logic;
--	
--	signal mem_rst: std_logic;
--	signal mem_clk: std_logic;
--	signal mem_init: std_logic;
--	
--	COMPONENT pixclkgen
--	PORT(
--		CLKIN_IN : IN std_logic;
--		RST_IN : IN std_logic;          
--		CLKFX_OUT : OUT std_logic;
--		CLKIN_IBUFG_OUT : OUT std_logic;
--		LOCKED_OUT : OUT std_logic
--		);
--	END COMPONENT;
--
--	COMPONENT pixmclkgen
--	PORT(
--		CLKIN_IN : IN std_logic;
--		RST_IN : IN std_logic;          
--		CLKFX_OUT : OUT std_logic;
--		CLKIN_IBUFG_OUT : OUT std_logic;
--		LOCKED_OUT : OUT std_logic
--		);
--	END COMPONENT;
--
--
--begin
--	khzclkgen: entity work.clockdiv
--		generic map (50000)
--		port map (rst, mclk_buf, khz_clock);
--	
--	memclkgen: entity work.clockdiv
--		generic map (400)
--		port map (rst, mclk_buf, mem_clk);
--	
--	pixclkgen1: pixclkgen PORT MAP(
--		CLKIN_IN => uclk,
--		RST_IN => rst,
--		CLKFX_OUT => vclk1,
--		CLKIN_IBUFG_OUT => open,
--		LOCKED_OUT => vclk1_ok
--	);
--		
--	pixclkgen2: pixmclkgen PORT MAP(
--		CLKIN_IN => mclk,
--		RST_IN => rst,
--		CLKFX_OUT => vclk2,
--		CLKIN_IBUFG_OUT => mclk_buf,
--		LOCKED_OUT => vclk2_ok
--	);
--		
--	segdriver: entity work.segdriver
--		generic map (4)
--		port map(
--			nrst => not rst,
--			clk => khz_clock,
--			n => disp_value,
--			dots => "1111",
--			seg => seg,
--			an => an_sig);
--		
--   vga : entity work.vga_controller_640_60
--      port map (
--			pixel_clk => vclk,
--			rst => rst,
--			blank => vblank,
--			hcount(10 downto 9) => open,
--			hcount(8 downto 1) => vx,
--			hcount(0) => open,
--			HS => hsync,
--			vcount(10 downto 9) => open,
--			vcount(8 downto 1) => vy,
--			vcount(0) => open,
--			VS => vsync
--		);
--	
--	display: entity work.display_logic
--		port map(
--			mem_clk => mem_clk,
--			mem_rst => mem_rst,
--			mem_init => mem_init,
--			v_clk => vclk,
--			v_rst => v_rst,
--			vx => vx,
--			vy => vy,
--			vblank => vblank,
--			vout => vout
--		);
--	
--	rst <= btn(3);	
--	v_rst <= btn(2);	
--	mem_rst <= btn(1);
--	mem_init <= btn(0);
--	
--	disp_value <= (others => '1');
--	an <= an_sig;
--		
--	vclk <= vclk1 when sw(7) = '0' else vclk2;
--	
--	led(7) <= vclk1_ok;
--	led(6) <= vclk2_ok;
--	led(5 downto 0) <= (others => '0');
--end architecture structural;
