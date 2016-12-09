LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY Main_Control_Unit IS
   PORT( 
      Instruction_31_26 : IN     std_logic_vector (5 DOWNTO 0);
      Instruction_5_0   : IN     std_logic_vector (5 DOWNTO 0);
      ALUOp             : OUT    std_logic_vector (1 DOWNTO 0);
      ALUSrc            : OUT    std_logic;
      Beq               : OUT    std_logic;
      Bne               : OUT    std_logic;
      J                 : OUT    std_logic;
      Jal               : OUT    std_logic;      
      Jr                : OUT    std_logic;
      Lui               : OUT    std_logic;
      Ori               : OUT    std_logic;
      MemRead           : OUT    std_logic;
      MemToReg          : OUT    std_logic;
      MemWrite          : OUT    std_logic;
      RegDst            : OUT    std_logic;
      RegWrite          : OUT    std_logic
   );
END Main_Control_Unit ;


ARCHITECTURE struct OF Main_Control_Unit IS

BEGIN

-- Insert your code here --
process(Instruction_31_26, Instruction_5_0)


begin
ALUOp <= "00";
ALUSrc <= '0';
Beq <= '0';
Bne <= '0';
J <= '0';
Jal <= '0';
Jr <= '0';
Lui <= '0';
Ori <= '0';
MemRead <= '0';
MemToReg <= '0';
MemWrite <= '0';
RegDst <= '0';
RegWrite <= '0';


if(Instruction_31_26 = "000000")then
    if(Instruction_5_0 = "001000")then
        Jr <= '1';
    else
        RegDst <= '1';
        RegWrite <= '1';
        ALUOp <= "10";
    end if;
elsif(Instruction_31_26 = "100011")then
    ALUSrc <= '1';
    MemToReg <= '1';
    RegWrite <= '1';
    MemRead <= '1';
elsif(Instruction_31_26 = "101011")then
     ALUSrc <= '1';
     MemWrite <= '1';
elsif(Instruction_31_26 = "000100")then
    Beq <= '1';
    ALUOp <= "01";
elsif(Instruction_31_26 = "000101")then
    Bne <= '1';
    ALUOp <= "01";
elsif(Instruction_31_26 = "000010")then
    J <= '1';
elsif(Instruction_31_26 = "000011")then
    Jal <= '1';
    J <= '1';
    RegWrite <='1';
elsif(Instruction_31_26 = "001000")then
    ALUSrc <= '1';
    RegWrite <= '1';
elsif(Instruction_31_26 = "001111")then
    Lui <= '1';
    RegWrite <= '1';
elsif(Instruction_31_26 = "001101")then
    Ori <= '1';
    RegWrite <= '1';
end if;

end process;
---------------------------

END struct;
