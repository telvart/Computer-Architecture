LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY im_tb IS
END im_tb;
 
ARCHITECTURE behavior OF im_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IM
    PORT(
         ReadAddress : IN  std_logic_vector(31 downto 0);
         rst : IN  std_logic;
         Instruction : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ReadAddress : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
   signal rst : std_logic := '0';

 	--Outputs
   signal Instruction : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant delay_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IM PORT MAP (
          ReadAddress => ReadAddress,
          rst => rst,
          Instruction => Instruction
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for delay_period*10;

      -- insert stimulus here 
		rst <= '0';
		ReadAddress <= "00000000000000000000000000000000";
      wait for delay_period*3;	

		ReadAddress <= "00000000000000000000000000000001";
      wait for delay_period*3;		

		ReadAddress <= "00000000000000000000000000000010";
      wait for delay_period*3;	

		ReadAddress <= "00000000000000000000000000000011";
      wait for delay_period*3;	

		ReadAddress <= "00000000000000000000000000000100";
      wait for delay_period*3;

		rst <= '1';
      wait for delay_period*10;	

      wait;
   end process;

END;
