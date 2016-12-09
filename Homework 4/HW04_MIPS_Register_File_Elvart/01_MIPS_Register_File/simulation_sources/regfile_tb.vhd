LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY regfile_tb IS
END regfile_tb;
 
ARCHITECTURE behavior OF regfile_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegFile
    PORT(
         ReadAddr_1 : IN  std_logic_vector(4 downto 0);
         ReadAddr_2 : IN  std_logic_vector(4 downto 0);
         RegWrite : IN  std_logic;
         WriteAddr : IN  std_logic_vector(4 downto 0);
         WriteData : IN  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         ReadData_1 : OUT  std_logic_vector(31 downto 0);
         ReadData_2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ReadAddr_1 : std_logic_vector(4 downto 0) := (others => '0');
   signal ReadAddr_2 : std_logic_vector(4 downto 0) := (others => '0');
   signal RegWrite : std_logic := '0';
   signal WriteAddr : std_logic_vector(4 downto 0) := (others => '0');
   signal WriteData : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal ReadData_1 : std_logic_vector(31 downto 0);
   signal ReadData_2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegFile PORT MAP (
          ReadAddr_1 => ReadAddr_1,
          ReadAddr_2 => ReadAddr_2,
          RegWrite => RegWrite,
          WriteAddr => WriteAddr,
          WriteData => WriteData,
          clk => clk,
          rst => rst,
          ReadData_1 => ReadData_1,
          ReadData_2 => ReadData_2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
	   ReadAddr_1 <= "00000";
		ReadAddr_2 <= "00000";
		RegWrite <= '0';
	   WriteAddr <= "00000";
	   WriteData <= "00000000000000000000000000000000";		
      wait for clk_period*10;	
      
		-- insert stimulus here 
		rst <= '0';
		RegWrite <= '1';
	   WriteAddr <= "00101";
	   WriteData <= "00000000000000000000000000001111";		
      wait for clk_period*3;
		
		RegWrite <= '1';
	   WriteAddr <= "01100";
	   WriteData <= "00000000000000000000000000011111";		
      wait for clk_period*3;		

	   ReadAddr_1 <= "00101";
		ReadAddr_2 <= "01100";
		RegWrite <= '0';
      wait for clk_period*3;
		
		rst <= '1';
      wait for clk_period*3;			
		
      wait;
   end process;

END;
