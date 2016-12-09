LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Main_Control_Unit IS
   PORT( 
      Instruction_31_26 : IN     std_logic_vector (5 DOWNTO 0);
      ALUOp             : OUT    std_logic_vector (1 DOWNTO 0);
      ALUSrc            : OUT    std_logic;
      Branch            : OUT    std_logic;
      Jump              : OUT    std_logic;
      MemRead           : OUT    std_logic;
      MemToReg          : OUT    std_logic;
      MemWrite          : OUT    std_logic;
      RegDst            : OUT    std_logic;
      RegWrite          : OUT    std_logic
   );
END Main_Control_Unit ;


ARCHITECTURE behav OF Main_Control_Unit IS

BEGIN

   -- insert your design here --
   MIPScontrol: process(Instruction_31_26)
   begin
   
   if(Instruction_31_26 = "000000")then
        RegDst <= '1';
        ALUSrc <= '0';
        MemToReg <= '0';
        RegWrite <= '1';
        MemRead <= '0';
        MemWrite <= '0';
        Branch <= '0';
        ALUOp <= "10";
        Jump <= '0';
   elsif(Instruction_31_26 = "100011")then
       RegDst <= '0';
       ALUSrc <= '1';
       MemToReg <= '1';
       RegWrite <= '1';
       MemRead <= '1';
       MemWrite <= '0';
       Branch <= '0';
       ALUOp <= "00";
       Jump <= '0';
   elsif(Instruction_31_26 = "101011")then
       RegDst <= '0';
       ALUSrc <= '1';
       MemToReg <= '0';
       RegWrite <= '0';
       MemRead <= '0';
       MemWrite <= '1';
       Branch <= '0';
       ALUOp <= "00";
       Jump <= '0';
   elsif(Instruction_31_26 = "000100")then
       RegDst <= '0';
       ALUSrc <= '0';
       MemToReg <= '0';
       RegWrite <= '0';
       MemRead <= '0';
       MemWrite <= '0';
       Branch <= '1';
       ALUOp <= "01";
       Jump <= '0';
   elsif(Instruction_31_26 = "000010")then
       RegDst <= '0';
       ALUSrc <= '0';
       MemToReg <= '0';
       RegWrite <= '0';
       MemRead <= '0';
       MemWrite <= '0';
       Branch <= '0';
       ALUOp <= "00";
       Jump <= '1';
   elsif(Instruction_31_26 = "001000")then
       RegDst <= '0';
       ALUSrc <= '1';
       MemToReg <= '0';
       RegWrite <= '1';
       MemRead <= '0';
       MemWrite <= '0';
       Branch <= '0';
       ALUOp <= "00";
       Jump <= '0';
   else
       RegDst <= '0';
       ALUSrc <= '0';
       MemToReg <= '0';
       RegWrite <= '0';
       MemRead <= '0';
       MemWrite <= '0';
       Branch <= '0';
       ALUOp <= "00";
       Jump <= '0';
   end if;
   
   end process;
   

   -----------------------------
   
END behav;
