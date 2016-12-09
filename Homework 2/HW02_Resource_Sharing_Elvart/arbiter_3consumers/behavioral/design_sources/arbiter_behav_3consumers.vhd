LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY arbiter_bahav_3cons IS
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
END arbiter_bahav_3cons ;



ARCHITECTURE behav_priority OF arbiter_bahav_3cons IS

   -- Architecture Declarations
   SUBTYPE STATE_TYPE IS 
      std_logic_vector(1 DOWNTO 0);

   -- Hard encoding
   CONSTANT NO_ACCESS : STATE_TYPE := "00" ;
   CONSTANT Con_01 : STATE_TYPE := "01" ;
   CONSTANT Con_02 : STATE_TYPE := "10" ;
   CONSTANT Con_03 : STATE_TYPE := "11" ;

   -- Declare current and next state signals
   SIGNAL current_state : STATE_TYPE ;
   SIGNAL next_state : STATE_TYPE ;
   
   SIGNAL REQ_VEC : std_logic_vector(1 TO 3);

BEGIN

   REQ_VEC <= (REQ_01 & REQ_02 & REQ_03);

   ---------------------------------------------------------------------------
   memory_elements : PROCESS(clk, rst)
   ----------------------------------------------------------------------------
   BEGIN
   --- insert your code here ---
    IF (rst = '1') THEN
        current_state <= NO_ACCESS;
    ELSIF (clk'EVENT AND clk = '1') THEN
        current_state <= next_state;
    END IF;
   -----------------------------
   END PROCESS memory_elements;
   ----------------------------------------------------------------------------
   state_logic : PROCESS (REQ_VEC, current_state)
   ----------------------------------------------------------------------------
   BEGIN
   --- insert your code here ---
    CASE current_state IS
    WHEN NO_ACCESS =>
        next_state <= NO_ACCESS;
        IF (REQ_VEC = "000") THEN
            next_state <= NO_ACCESS;
        ELSIF (REQ_VEC = "001") THEN
            next_state <= Con_03;
        ELSIF (REQ_VEC = "011") THEN
            next_state <= Con_02;
        ELSIF (REQ_VEC = "010") THEN
            next_state <= Con_02;
        ELSE
            next_state <= Con_01;
        END IF; 
    WHEN Con_01 =>
        next_state <= Con_01;
        IF (REQ_VEC = "110") THEN
            next_state <= Con_01;
        ELSIF (REQ_VEC = "111") THEN
            next_state <= Con_01;
        ELSIF (REQ_VEC = "101") THEN
            next_state <= Con_01;
        ELSIF (REQ_VEC = "100") THEN
            next_state <= Con_01;
        ELSE
            next_state <= NO_ACCESS;
        END IF;
    WHEN Con_02 =>
        next_state <= Con_02;
        IF (REQ_VEC = "011") THEN
            next_state <= Con_02;
        ELSIF (REQ_VEC = "010") THEN
            next_state <= Con_02;
        ELSE
            next_state <= NO_ACCESS;
        END IF;
    WHEN Con_03 =>
        next_state <= Con_03;
        IF (REQ_VEC = "001") THEN
            next_state <= Con_03;
        ELSE
            next_state <= NO_ACCESS;
        END IF;
    WHEN OTHERS =>
        next_state <= NO_ACCESS;
    END CASE;
   -----------------------------
   END PROCESS state_logic;
   ----------------------------------------------------------------------------
   output_logic : PROCESS (current_state)
   ----------------------------------------------------------------------------
   BEGIN
   --- insert your code here ---
    CASE current_state IS
    WHEN NO_ACCESS =>
        ACK_01 <= '0';
        ACK_02 <= '0';
        ACK_03 <= '0';
    WHEN Con_01 =>
        ACK_01 <= '1';
        ACK_02 <= '0';
        ACK_03 <= '0';
    WHEN Con_02 =>
        ACK_01 <= '0';
        ACK_02 <= '1';
        ACK_03 <= '0';
    WHEN Con_03 =>
        ACK_01 <= '0';
        ACK_02 <= '0';
        ACK_03 <= '1';
    WHEN OTHERS =>
        ACK_01 <= '0';
        ACK_02 <= '0';
        ACK_03 <= '0';
    END CASE;
   -----------------------------
   END PROCESS output_logic;
END behav_priority;
