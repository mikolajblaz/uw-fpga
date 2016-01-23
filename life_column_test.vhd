--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:56:45 01/23/2016
-- Design Name:   
-- Module Name:   F:/Xilinx/PULlab/zadanie4/life_column_test.vhd
-- Project Name:  zadanie4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: life_column
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
 
ENTITY life_column_test IS
END life_column_test;
 
ARCHITECTURE behavior OF life_column_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT life_column
    PORT(rst: in std_logic;
         clka : IN  std_logic;
         trigger : IN  std_logic;
         clkb : IN  std_logic;
         addrb : IN  std_logic_vector(7 downto 0);
         doutb : OUT  std_logic_vector(31 downto 0);
			enable_b: in std_logic
        );
    END COMPONENT;
    

   --Inputs
	signal rst: std_logic := '0';
   signal clka : std_logic := '0';
   signal trigger : std_logic := '0';
   signal clkb : std_logic := '0';
   signal addrb : std_logic_vector(7 downto 0) := "00000001";
	signal enable_b: std_logic := '0';

 	--Outputs
   signal doutb : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clka_period : time := 10 ns;
   constant clkb_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: life_column PORT MAP (
			 rst => rst,
          clka => clka,
          trigger => trigger,
          clkb => clkb,
          addrb => addrb,
          doutb => doutb,
			 enable_b => enable_b
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
		rst <= '1';
      wait for 100 ns;
      wait for clka_period*10;
		rst <= '0';
      -- insert stimulus here 
		
		trigger <= '1';
		wait for clka_period;
		--trigger <= '0';

      wait;
   end process;

END;
