LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY ALU_controller IS
   PORT( 
      ALU_op      : IN     std_logic_vector (1 DOWNTO 0);
      funct       : IN     std_logic_vector (5 DOWNTO 0);
      ALU_control : OUT    std_logic_vector (3 DOWNTO 0)
   );
END ALU_controller ;


ARCHITECTURE behav OF ALU_controller IS

signal ALU_control_internal : std_logic_vector (3 downto 0);

BEGIN

-- Insert your code here --

ALU_control <= ALU_control_internal;

Process(ALU_op, funct)
begin
    
   if(ALU_op = "00")then
    ALU_control_internal <= "0010";
   elsif(ALU_op = "01")then
    ALU_control_internal <= "0110";
   elsif(ALU_op = "10")then
    if(funct = "100000")then
        ALU_control_internal <= "0010";
    elsif(funct = "100010")then
        ALU_control_internal <= "0110";
    elsif(funct = "100100")then
        ALU_control_internal <= "0000";
    elsif(funct = "100101")then
        ALU_control_internal <= "0001";
    elsif(funct = "101010")then
        ALU_control_internal <= "0111";
    end if;
   end if;
    
end process;
---------------------------

END behav;
