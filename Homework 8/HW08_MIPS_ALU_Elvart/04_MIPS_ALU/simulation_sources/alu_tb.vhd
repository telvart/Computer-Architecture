LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY alu_tb IS
END alu_tb;
 
ARCHITECTURE behavior OF alu_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
          A           : IN     std_logic_vector (31 DOWNTO 0);
          ALU_control : IN     std_logic_vector (3 DOWNTO 0);
          B           : IN     std_logic_vector (31 DOWNTO 0);
          ALU_result  : OUT    std_logic_vector (31 DOWNTO 0);
          zero        : OUT    std_logic;
          overflow    : OUT    std_logic
        );
    END COMPONENT;

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_control : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal ALU_result : std_logic_vector(31 downto 0);
   signal zero : std_logic;
   signal overflow : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant delay_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          ALU_control => ALU_control,
          B => B,
          ALU_result => ALU_result,
          zero => zero,
          overflow => overflow
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- insert stimulus here
		A <= "00000000000000000000000000000011";
		B <= "00000000000000000000000000001000";
		
		ALU_control <= "0000";
		wait for delay_period*3; 
		
		ALU_control <= "0001";
		wait for delay_period*3; 
		
		ALU_control <= "0010";
		wait for delay_period*3;		

		ALU_control <= "0110";
		wait for delay_period*3; 
		
		ALU_control <= "0111";
		wait for delay_period*3;
		
		ALU_control <= "1100";
		wait for delay_period*3;		

		B <= "00000000000000000000000000000011";
		A <= "00000000000000000000000000001000";
		
		ALU_control <= "0000";
		wait for delay_period*3; 
		
		ALU_control <= "0001";
		wait for delay_period*3; 
		
		ALU_control <= "0010";
		wait for delay_period*3;	

		ALU_control <= "0110";
		wait for delay_period*3; 
		
		ALU_control <= "0111";
		wait for delay_period*3;
		
		ALU_control <= "1100";
		wait for delay_period*3;	


		A <= "01000000000000000000000000000011";
		B <= "01000000000000000000000000001000";
		
		ALU_control <= "0010";
		wait for delay_period*3;		

		ALU_control <= "0110";
		wait for delay_period*3; 

		B <= "01000000000000000000000000000011";
		A <= "01000000000000000000000000001000";
		
		ALU_control <= "0010";
		wait for delay_period*3;		

		ALU_control <= "0110";
		wait for delay_period*3; 

		A <= "10000000000000000000000000000011";
		B <= "10000000000000000000000000001000";
		
		ALU_control <= "0010";
		wait for delay_period*3;		

		ALU_control <= "0110";
		wait for delay_period*3; 

		B <= "10000000000000000000000000000011";
		A <= "10000000000000000000000000001000";
		
		ALU_control <= "0010";
		wait for delay_period*3;		

		ALU_control <= "0110";
		wait for delay_period*3; 


      wait;
   end process;

END;
