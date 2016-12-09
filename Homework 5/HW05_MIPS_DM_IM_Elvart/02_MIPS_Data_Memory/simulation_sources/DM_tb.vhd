LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY DM_tb IS
END DM_tb;
 
ARCHITECTURE behavior OF DM_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DataMem
    PORT(
         Address : IN  std_logic_vector(31 downto 0);
         MemWrite : IN  std_logic;
         WriteData : IN  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         ReadData : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Address : std_logic_vector(31 downto 0) := (others => '0');
   signal MemWrite : std_logic := '0';
   signal WriteData : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal ReadData : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DataMem PORT MAP (
          Address => Address,
          MemWrite => MemWrite,
          WriteData => WriteData,
          clk => clk,
          rst => rst,
          ReadData => ReadData
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
	   Address <= (others => '0');
		MemWrite <= '0';
	   WriteData <= (others => '0');		
      wait for clk_period*10;	
      
		-- insert stimulus here 
		rst <= '0';
		MemWrite <= '1';
	   Address   <= "00000000000000000000000000000101";
	   WriteData <= "00000000000000000000000000001111";		
      wait for clk_period*3;
		
		MemWrite <= '1';
	   Address   <= "00000000000000000000000000001100";
	   WriteData <= "00000000000000000000000000011111";			
      wait for clk_period*3;		

		MemWrite <= '0';
		WriteData <= (others => '1');	

	   Address   <= "00000000000000000000000000000101";
      wait for clk_period*3;
		
	   Address   <= "00000000000000000000000000001100";
      wait for clk_period*3;	
		
		rst <= '1';
      wait for clk_period*3;			
		
      wait;
   end process;

END;
