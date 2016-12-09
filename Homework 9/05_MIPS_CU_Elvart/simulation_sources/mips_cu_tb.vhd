
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY main_control_unit_tb IS
END main_control_unit_tb;
 
ARCHITECTURE behavior OF main_control_unit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Main_Control_Unit
    PORT(
         Instruction_31_26 : IN  std_logic_vector(5 downto 0);
         ALUOp : OUT  std_logic_vector(1 downto 0);
         ALUSrc : OUT  std_logic;
         Branch : OUT  std_logic;
         Jump : OUT  std_logic;
         MemRead : OUT  std_logic;
         MemToReg : OUT  std_logic;
         MemWrite : OUT  std_logic;
         RegDst : OUT  std_logic;
         RegWrite : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Instruction_31_26 : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal ALUOp : std_logic_vector(1 downto 0);
   signal ALUSrc : std_logic;
   signal Branch : std_logic;
   signal Jump : std_logic;
   signal MemRead : std_logic;
   signal MemToReg : std_logic;
   signal MemWrite : std_logic;
   signal RegDst : std_logic;
   signal RegWrite : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant delay_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Main_Control_Unit PORT MAP (
          Instruction_31_26 => Instruction_31_26,
          ALUOp => ALUOp,
          ALUSrc => ALUSrc,
          Branch => Branch,
          Jump => Jump,
          MemRead => MemRead,
          MemToReg => MemToReg,
          MemWrite => MemWrite,
          RegDst => RegDst,
          RegWrite => RegWrite
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- insert stimulus here
		Instruction_31_26 <= "000000"; -- R-Type
		wait for delay_period*3;
		
		Instruction_31_26 <= "100011"; -- lw
		wait for delay_period*3;
		
		Instruction_31_26 <= "101011"; -- sw
		wait for delay_period*3;
		
		Instruction_31_26 <= "000100"; -- beq
		wait for delay_period*3;
		
		Instruction_31_26 <= "000010"; -- j
		wait for delay_period*3;

		Instruction_31_26 <= "001000"; -- addi
		wait for delay_period*3;
		
		Instruction_31_26 <= "111111"; -- undefined
		wait for delay_period*3;
				
      wait;
   end process;

END;
