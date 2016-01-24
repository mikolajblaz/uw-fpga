--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:30:04 01/23/2016
-- Design Name:   
-- Module Name:   F:/Xilinx/PULlab/zadanie4/demo_test.vhd
-- Project Name:  zadanie4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: demo
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
 
ENTITY demo_test IS
END demo_test;
 
ARCHITECTURE behavior OF demo_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT demo
    PORT(
         mclk : IN  std_logic;
         uclk : IN  std_logic;
         sw : IN  std_logic_vector(7 downto 0);
         btn : IN  std_logic_vector(3 downto 0);
         led : OUT  std_logic_vector(7 downto 0);
         seg : OUT  std_logic_vector(0 to 7);
         an : OUT  std_logic_vector(3 downto 0);
         hsync : OUT  std_logic;
         vsync : OUT  std_logic;
         vout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal mclk : std_logic := '0';
   signal uclk : std_logic := '0';
   signal sw : std_logic_vector(7 downto 0) := (others => '0');
   signal btn : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal led : std_logic_vector(7 downto 0);
   signal seg : std_logic_vector(0 to 7);
   signal an : std_logic_vector(3 downto 0);
   signal hsync : std_logic;
   signal vsync : std_logic;
   signal vout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant mclk_period : time := 20 ns;
   constant uclk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: demo PORT MAP (
          mclk => mclk,
          uclk => uclk,
          sw => sw,
          btn => btn,
          led => led,
          seg => seg,
          an => an,
          hsync => hsync,
          vsync => vsync,
          vout => vout
        );

   -- Clock process definitions
   mclk_process :process
   begin
		mclk <= '0';
		wait for mclk_period/2;
		mclk <= '1';
		wait for mclk_period/2;
   end process;
 
   uclk_process :process
   begin
		uclk <= '0';
		wait for uclk_period/2;
		uclk <= '1';
		wait for uclk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		--reset
		btn(3) <= '1';

      wait for uclk_period*10;
		btn(3) <= '0';
		sw <= "00001110";

      -- insert stimulus here
		
		for i in 0 to 20 loop
			wait for uclk_period*10;
			btn(0) <= '1';
			wait for uclk_period*100;
			btn(0) <= '0';
			wait for uclk_period*10;
			btn(1) <= '1';
			wait for uclk_period*10;
			btn(1) <= '0';
		end loop;
		
		sw <= "00001101";
		btn(1) <= '1';
		
      wait;
   end process;

END;
