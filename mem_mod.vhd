----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:10:38 01/23/2016 
-- Design Name: 
-- Module Name:    mem_mod - behavioral 
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

entity mem_mod is
	port (clka: in std_logic;
			clkb: in std_logic;
			rst: in std_logic;
			
			we : in std_logic;
			addra : in std_logic_vector(10 downto 0);
			dina : in std_logic_vector(31 downto 0);
			douta : out std_logic_vector(31 downto 0);
			
			addrb : in std_logic_vector(15 downto 0);
			dinb : in std_logic_vector(0 downto 0);
			doutb : out std_logic_vector(0 downto 0)
	);
end mem_mod;

architecture behavioral of mem_mod is

	component main_memory
	  port (
		 clka : in std_logic;
		 wea : in std_logic_vector(0 downto 0);
		 addra : in std_logic_vector(10 downto 0);
		 dina : in std_logic_vector(31 downto 0);
		 douta : out std_logic_vector(31 downto 0);
		 clkb : in std_logic;
		 rstb : in std_logic;
		 web : in std_logic_vector(0 downto 0);
		 addrb : in std_logic_vector(15 downto 0);
		 dinb : in std_logic_vector(0 downto 0);
		 doutb : out std_logic_vector(0 downto 0)
	  );
	end component;

begin
	main : main_memory
	  PORT MAP (
		 clka => clka,
		 wea(0) => we,
		 addra => addra,
		 dina => dina,
		 douta => douta,
		 clkb => clkb,
		 rstb => rst,
		 web => "0",
		 addrb => addrb,
		 dinb => dinb,
		 doutb => doutb
	  );

end behavioral;

