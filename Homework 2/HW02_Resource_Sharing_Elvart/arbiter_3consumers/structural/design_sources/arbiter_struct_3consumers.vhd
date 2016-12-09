LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY arbiter_struct_3cons IS
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
END arbiter_struct_3cons ;



ARCHITECTURE struct_priority OF arbiter_struct_3cons IS

   -- Declare current and next state signals
   SIGNAL s1_current, s2_current : std_logic;
   SIGNAL s1_next   , s2_next    : std_logic;

BEGIN

   ----------------------------------------------------------------------------
   memory_elements : PROCESS(clk, rst)
   ----------------------------------------------------------------------------
   BEGIN
    IF (rst = '1') THEN
        s1_current <= '0';
        s2_current <= '0';
    ELSIF (clk'EVENT AND clk = '1') THEN
        s1_current <= s1_next;
        s2_current <= s2_next;
    END IF;
   END PROCESS memory_elements;
   
   ----------------------------------------------------------------------------
   -- state_logic
   ----------------------------------------------------------------------------   
   --- insert your code here ---
    s1_next <= ((not REQ_01) and (not REQ_02) and REQ_03 and s1_current and s2_current)
     or ((not REQ_01) and REQ_03 and (not s1_current) and (not s2_current))
     or ((not REQ_01) and REQ_02 and (not s2_current));

    s2_next <= ((not REQ_01) and (not REQ_02) and REQ_03 and (not s1_current) and (not s2_current))
     or ((not REQ_01) and (not REQ_02) and REQ_03 and s1_current and s2_current)
     or (REQ_01 and (not s1_current));

   -----------------------------
   ----------------------------------------------------------------------------
   -- output_logic
   ----------------------------------------------------------------------------
   --- insert your code here ---
    ACK_01 <= (not s1_current) and s2_current;
    ACK_02 <= s1_current and (not s2_current);
    ACK_03 <= s1_current and s2_current;

   -----------------------------

END struct_priority;
