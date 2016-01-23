--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:20:40 01/23/2016
-- Design Name:   
-- Module Name:   F:/Xilinx/PULlab/zadanie4/mem_mod_test.vhd
-- Project Name:  zadanie4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mem_mod
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY mem_mod_test IS
END mem_mod_test;
 
ARCHITECTURE behavior OF mem_mod_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mem_mod
    PORT(
         clka : IN  std_logic;
         clkb : IN  std_logic;
         rst : IN  std_logic;
         we : IN  std_logic;
         addra : IN  std_logic_vector(10 downto 0);
         dina : IN  std_logic_vector(31 downto 0);
         douta : OUT  std_logic_vector(31 downto 0);
         addrb : IN  std_logic_vector(15 downto 0);
         dinb : IN  std_logic_vector(0 downto 0);
         doutb : OUT  std_logic_vector(0 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clka : std_logic := '0';
   signal clkb : std_logic := '0';
   signal rst : std_logic := '0';
   signal we : std_logic := '0';
   signal addra : std_logic_vector(10 downto 0) := (others => '0');
   signal dina : std_logic_vector(31 downto 0) := (others => '0');
   signal addrb : std_logic_vector(15 downto 0) := (others => '0');
   signal dinb : std_logic_vector(0 downto 0) := (others => '0');

 	--Outputs
   signal douta : std_logic_vector(31 downto 0);
   signal doutb : std_logic_vector(0 downto 0);

   -- Clock period definitions
   constant clka_period : time := 10 ns;
   constant clkb_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mem_mod PORT MAP (
          clka => clka,
          clkb => clkb,
          rst => rst,
          we => we,
          addra => addra,
          dina => dina,
          douta => douta,
          addrb => addrb,
          dinb => dinb,
          doutb => doutb
        );

   -- Clock process definitions
   clka_process :process
   begin
		clka <= '0';
		wait for clka_period/2;
		clka <= '1';
		wait for clka_period/2;
   end process;
 
   clkb_process :process
   begin
		clkb <= '0';
		wait for clkb_period/2;
		clkb <= '1';
		wait for clkb_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		wait for clka_period/2;
      wait for 100 ns;	
      wait for clka_period*10;
      -- insert stimulus here
		
		addra(1) <= '1';
		wait for clka_period*2;
		dina <= x"01" & x"01" & x"01" & x"01";
		we <= '1';
		wait for clka_period*2;
		we <= '0';
		
		wait for clka_period*5;
		addra(0) <= '1';
		addrb(6) <= '1';
		wait for clka_period*5;
		

      wait;
   end process;

END;
