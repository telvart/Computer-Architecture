LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY arbiter_behav_3consumers_tb IS
END arbiter_behav_3consumers_tb;
 
ARCHITECTURE behavior OF arbiter_behav_3consumers_tb IS 
 
   -- Component Declaration for the Unit Under Test (UUT)
   COMPONENT arbiter_bahav_3cons IS
      PORT( 
      	 REQ_01 : IN     std_logic;
      	 REQ_02 : IN     std_logic;
      	 REQ_03 : IN     std_logic;
      	 clk    : IN     std_logic;
      	 rst    : IN     std_logic;
      	 ACK_01 : OUT    std_logic;
      	 ACK_02 : OUT    std_logic;
      	 ACK_03 : OUT    std_logic
      );
   END COMPONENT ;   
    
   --Inputs
   signal REQ_01 : std_logic := '0';
   signal REQ_02 : std_logic := '0';
   signal REQ_03 : std_logic := '0';
   signal clk    : std_logic := '0';
   signal rst    : std_logic := '0';

   --Outputs
   signal ACK_01 : std_logic;
   signal ACK_02 : std_logic;
   signal ACK_03 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
   -- Instantiate the Unit Under Test (UUT)
   uut: arbiter_bahav_3cons PORT MAP (
			  	      REQ_01 => REQ_01,
			  	      REQ_02 => REQ_02,
			  	      REQ_03 => REQ_03,
			  	      clk => clk,
			  	      rst => rst,
			  	      ACK_01 => ACK_01,
			  	      ACK_02 => ACK_02,
			  	      ACK_03 => ACK_03
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
      -- hold reset state for 3 clock periods.
		rst <= '1';
      wait for clk_period*3;	
		
		rst <= '0';
      wait for clk_period*3;

      -- insert stimulus here 
		REQ_01 <= '1';
		REQ_02 <= '1';
		REQ_03 <= '1';
      wait for clk_period*3;
		
		REQ_01 <= '1';
		REQ_02 <= '0';
		REQ_03 <= '0';
      wait for clk_period*3;

		REQ_01 <= '1';
		REQ_02 <= '1';
		REQ_03 <= '1';
      wait for clk_period*3;		

		REQ_01 <= '0';
		REQ_02 <= '1';
		REQ_03 <= '1';
      wait for clk_period*3;
      
		REQ_01 <= '0';
		REQ_02 <= '1';
		REQ_03 <= '0';
      wait for clk_period*3;      

		REQ_01 <= '1';
		REQ_02 <= '1';
		REQ_03 <= '1';
      wait for clk_period*3;
		
		REQ_01 <= '1';
		REQ_02 <= '0';
		REQ_03 <= '1';
      wait for clk_period*3;

		REQ_01 <= '0';
		REQ_02 <= '0';
		REQ_03 <= '1';
      wait for clk_period*3;      

		REQ_01 <= '1';
		REQ_02 <= '1';
		REQ_03 <= '1';
      wait for clk_period*3;

		REQ_01 <= '0';
		REQ_02 <= '0';
		REQ_03 <= '0';
      wait for clk_period*9;

		REQ_01 <= '0';
		REQ_02 <= '1';
		REQ_03 <= '1';
      wait for clk_period*3; 
      
		REQ_01 <= '1';
		REQ_02 <= '0';
		REQ_03 <= '1';
      wait for clk_period*3;   

		REQ_01 <= '1';
		REQ_02 <= '1';
		REQ_03 <= '0';
      wait for clk_period*3;       

		rst <= '1';
      wait for clk_period*3;	
		
		rst <= '0';
      wait for clk_period*3;      
		
      wait;
   end process;

END;
