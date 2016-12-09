LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;

ENTITY ALU IS
   PORT( 
      A           : IN     std_logic_vector (31 DOWNTO 0);
      ALU_control : IN     std_logic_vector (3 DOWNTO 0);
      B           : IN     std_logic_vector (31 DOWNTO 0);
      ALU_result  : OUT    std_logic_vector (31 DOWNTO 0);
      zero        : OUT    std_logic;
      overflow    : OUT    std_logic
   );
END ALU ;

ARCHITECTURE behav OF ALU IS

   -- Architecture declarations
   CONSTANT zero_value : std_logic_vector(31 downto 0) := (others => '0');
  
   -- Internal signal declarations
   SIGNAL ALU_result_internal : std_logic_vector(31 DOWNTO 0);
   SIGNAL s_A, s_B, s_C : std_logic;
 
BEGIN

   -- insert your design here --
   
   operation: process(ALU_control, A, B)
   begin
 
   overflow <= '0';
   
   if (ALU_control = "0000") then
    ALU_result_internal <= A and B;
     
   elsif(ALU_control = "0001")then
    ALU_result_internal <= A or B;
    
   elsif(ALU_control = "0010")then
    ALU_result_internal <= A + B;
     if((ALU_result_internal > 0) and ((A < 0) and (B < 0) ))then
         overflow <= '1';
     elsif(ALU_result_internal < 0 and ((A > 0) and (B > 0)))then
         overflow <= '1';
     else
         overflow <= '0';
     end if;
    
   elsif(ALU_control = "0110")then
    ALU_result_internal <= A - B;
    
   elsif(ALU_control = "0111")then
    if (A < B)then
        ALU_result_internal <= std_logic_vector(to_unsigned(1,32));
    else
        ALU_result_internal <= std_logic_vector(to_unsigned(0,32));
    end if;
    
   elsif(ALU_control = "1100")then
    ALU_result_internal <= A nor B;
 
   end if;

   end process;
   
   ALU_result <= ALU_result_internal;
   
   zero <= not (
       ALU_result_internal(0)
    or ALU_result_internal(1)
    or ALU_result_internal(2)
    or ALU_result_internal(3)
    or ALU_result_internal(4)
    or ALU_result_internal(5)
    or ALU_result_internal(6)
    or ALU_result_internal(7)
    or ALU_result_internal(8)
    or ALU_result_internal(9)
    or ALU_result_internal(10)
    or ALU_result_internal(11)
    or ALU_result_internal(12)
    or ALU_result_internal(13)
    or ALU_result_internal(14)
    or ALU_result_internal(15)
    or ALU_result_internal(16)
    or ALU_result_internal(17)
    or ALU_result_internal(18)
    or ALU_result_internal(19)
    or ALU_result_internal(20)
    or ALU_result_internal(21)
    or ALU_result_internal(22)
    or ALU_result_internal(23)
    or ALU_result_internal(24)
    or ALU_result_internal(25)
    or ALU_result_internal(26)
    or ALU_result_internal(27)
    or ALU_result_internal(28)
    or ALU_result_internal(29)
    or ALU_result_internal(30)
    or ALU_result_internal(31)
    );
   -----------------------------   

END behav;
