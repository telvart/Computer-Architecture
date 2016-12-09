LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.ALL;


ENTITY mips_single_cycle IS
   PORT( 
      clk : IN     std_logic;
      rst : IN     std_logic
   );
END mips_single_cycle ;


ARCHITECTURE struct OF mips_single_cycle IS

   -- Internal signal declarations
   SIGNAL ALUOp                                       : std_logic_vector(1 DOWNTO 0);
   SIGNAL ALUSrc                                      : std_logic;
   SIGNAL ALU_control                                 : std_logic_vector(3 DOWNTO 0);
   SIGNAL ALU_result                                  : std_logic_vector(31 DOWNTO 0);
   SIGNAL Beq                                         : std_logic;
   SIGNAL Bne                                         : std_logic;
   SIGNAL Instruction                                 : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_15_0_Sign_Extended              : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_15_0_Sign_Extended_Left_Shifted : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_25_0_Left_Shifted               : std_logic_vector(27 DOWNTO 0);
   SIGNAL J                                           : std_logic;
   SIGNAL Jal                                         : std_logic;
   SIGNAL Jump                                        : std_logic;
   SIGNAL Jr                                          : std_logic;
   signal Lui                                         : std_logic;
   signal Ori                                         : std_logic;
   SIGNAL MemRead                                     : std_logic;
   SIGNAL MemToReg                                    : std_logic;
   SIGNAL MemWrite                                    : std_logic;
   SIGNAL PC                                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL PC_icremented                               : std_logic_vector(31 DOWNTO 0);
   SIGNAL PC_next                                     : std_logic_vector(31 DOWNTO 0);
   SIGNAL RegDst                                      : std_logic;
   SIGNAL RegWrite                                    : std_logic;
   SIGNAL adder_second_result                         : std_logic_vector(31 DOWNTO 0);
   SIGNAL alu_second_operand                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL PCSrc                                       : std_logic;
   SIGNAL dm_ReadData                                 : std_logic_vector(31 DOWNTO 0);
   SIGNAL jump_address                                : std_logic_vector(31 DOWNTO 0);
   SIGNAL mux_first_i1_output                         : std_logic_vector(4 DOWNTO 0);
   SIGNAL mux_second_i2_output                        : std_logic_vector(31 DOWNTO 0);
   SIGNAL mux_second_i3_output                        : std_logic_vector(31 DOWNTO 0);
   SIGNAL mux_second_i4_output                        : std_logic_vector(31 DOWNTO 0);   
   signal jal_mux2_output                             : std_logic_vector(31 downto 0);
   signal lui_mux_output                              : std_logic_vector(31 downto 0);
   SIGNAL regfile_ReadData_1                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL regfile_ReadData_2                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL regfile_WriteAddr                           : std_logic_vector(4 DOWNTO 0);
   SIGNAL regfile_WriteData                           : std_logic_vector(31 DOWNTO 0);
   SIGNAL zero                                        : std_logic;
   SIGNAL overflow                                    : std_logic;
   
   signal Instr_15_0_sign_extended_shifted16          : std_logic_vector(31 downto 0);
   signal oriValue                                    : std_logic_vector(31 downto 0);
   
   constant value_31 : std_logic_vector(4 downto 0) := "11111";
   
   -- Component Declarations
   COMPONENT lui_shift_left_16
   port (
      Instr_15_0_sign_extended : IN std_logic_vector (31 downto 0);
      Instr_15_0_lui_value : OUT std_logic_vector (31 downto 0)
   );
   End Component;
   
   
   COMPONENT ALU
   PORT (
      A           : IN     std_logic_vector (31 DOWNTO 0);
      ALU_control : IN     std_logic_vector (3 DOWNTO 0);
      B           : IN     std_logic_vector (31 DOWNTO 0);
      ALU_result  : OUT    std_logic_vector (31 DOWNTO 0);
      zero        : OUT    std_logic;
      overflow    : OUT    std_logic
   );
   END COMPONENT;
   
   COMPONENT ALU_controller
   PORT (
      ALU_op      : IN     std_logic_vector (1 DOWNTO 0);
      funct       : IN     std_logic_vector (5 DOWNTO 0);
      ALU_control : OUT    std_logic_vector (3 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT DM
   PORT (
      Address   : IN     std_logic_vector (31 DOWNTO 0);
      MemRead   : IN     std_logic ;
      MemWrite  : IN     std_logic ;
      WriteData : IN     std_logic_vector (31 DOWNTO 0);
      clk       : IN     std_logic ;
      rst       : IN     std_logic ;
      ReadData  : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT First_Shift_Left_2
   PORT (
      Instruction_25_0              : IN     std_logic_vector (25 DOWNTO 0);
      Instruction_25_0_Left_Shifted : OUT    std_logic_vector (27 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT IM
   PORT (
      ReadAddress : IN     std_logic_vector (31 DOWNTO 0);
      rst         : IN     std_logic ;
      Instruction : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT Main_Control_Unit
   PORT (
      Instruction_31_26 : IN     std_logic_vector (5 DOWNTO 0);
      Instruction_5_0   : IN     std_logic_vector (5 DOWNTO 0);      
      ALUOp             : OUT    std_logic_vector (1 DOWNTO 0);
      ALUSrc            : OUT    std_logic ;
      Beq               : OUT    std_logic;
      Bne               : OUT    std_logic;
      J                 : OUT    std_logic ;
      Jal               : OUT    std_logic ;      
      Jr                : OUT    std_logic;      
      Lui               : OUT    std_logic;
      Ori               : OUT    std_logic;
      MemRead           : OUT    std_logic ;
      MemToReg          : OUT    std_logic ;
      MemWrite          : OUT    std_logic ;
      RegDst            : OUT    std_logic ;
      RegWrite          : OUT    std_logic 
   );
   END COMPONENT;

   COMPONENT PC_register
   PORT (
      PC_next : IN     std_logic_vector (31 DOWNTO 0);
      clk     : IN     std_logic ;
      rst     : IN     std_logic ;
      PC      : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT RegFile
   PORT (
      ReadAddr_1 : IN     std_logic_vector (4 DOWNTO 0);
      ReadAddr_2 : IN     std_logic_vector (4 DOWNTO 0);
      RegWrite   : IN     std_logic ;
      WriteAddr  : IN     std_logic_vector (4 DOWNTO 0);
      WriteData  : IN     std_logic_vector (31 DOWNTO 0);
      clk        : IN     std_logic ;
      rst        : IN     std_logic ;
      ReadData_1 : OUT    std_logic_vector (31 DOWNTO 0);
      ReadData_2 : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT Second_Shift_Left_2
   PORT (
      Instruction_15_0_Sign_Extended              : IN     std_logic_vector (31 DOWNTO 0);
      Instruction_15_0_Sign_Extended_Left_Shifted : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT adder_first
   PORT (
      PC            : IN     std_logic_vector (31 DOWNTO 0);
      PC_icremented : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT adder_second
   PORT (
      A          : IN     std_logic_vector (31 DOWNTO 0);
      B          : IN     std_logic_vector (31 DOWNTO 0);
      add_result : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT mux_first
   PORT (
      input_0 : IN     std_logic_vector (4 DOWNTO 0);
      input_1 : IN     std_logic_vector (4 DOWNTO 0);
      sel     : IN     std_logic ;
      output  : OUT    std_logic_vector (4 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT mux_second
   PORT (
      input_0 : IN     std_logic_vector (31 DOWNTO 0);
      input_1 : IN     std_logic_vector (31 DOWNTO 0);
      sel     : IN     std_logic ;
      output  : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT sign_extend
   PORT (
      Instruction_15_0               : IN     std_logic_vector (15 DOWNTO 0);
      Instruction_15_0_Sign_Extended : OUT    std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;


BEGIN

-- Insert your code here --
jump_address <= (PC_icremented(31 downto 28) & Instruction_25_0_Left_Shifted);

PCSrc <= ((Beq and zero) or (Bne and (not zero)));

oriValue <= regfile_ReadData_1 or Instruction_15_0_Sign_Extended;


theAlu : ALU
    port map(
        A => regFile_ReadData_1,
        ALU_control => ALU_control,
        B => alu_second_operand,
        ALU_result => ALU_result,
        zero => zero,
        overflow => overflow
    );
    
aluController : ALU_controller
    port map(
        ALU_op => ALUOp,
        funct => Instruction(5 downto 0),
        ALU_control => ALU_control
    );
    
dataMemory : DM
    port map(
        Address => ALU_result,
        MemRead => MemRead,
        MemWrite => MemWrite,
        WriteData => regfile_ReadData_2,
        clk => clk,
        rst => rst,
        ReadData => dm_readData
    );
    
firstShiftLeft2 : First_Shift_Left_2
    port map(
        Instruction_25_0 => Instruction(25 downto 0),
        Instruction_25_0_Left_Shifted => Instruction_25_0_Left_Shifted
    );
    
instructionMemory : IM
    port map(
        ReadAddress => PC,
        rst => rst,
        Instruction => Instruction
    );
    
mainControl : Main_Control_Unit
    port map(
        Instruction_31_26 => Instruction(31 downto 26),
        Instruction_5_0 => Instruction(5 downto 0),
        ALUOp => ALUOp,
        ALUSrc => ALUSrc,
        Beq => Beq,
        Bne => Bne,
        J => J,
        Jal => Jal,
        Jr => Jr,
        Lui => Lui,
        Ori => Ori,
        MemRead => MemRead,
        MemToReg => MemToReg,
        MemWrite => MemWrite,
        RegDst => RegDst,
        RegWrite => RegWrite
    );
    
pcRegister : PC_register
    port map(
        PC_next => PC_next,
        clk => clk,
        rst => rst,
        PC => PC
    );
    
theregFile : RegFile
    port map(
        ReadAddr_1 => Instruction(25 downto 21),
        ReadAddr_2 => Instruction(20 downto 16),
        RegWrite => RegWrite,
        WriteAddr => regfile_WriteAddr,
        WriteData => regfile_WriteData,
        clk => clk,
        rst => rst,
        ReadData_1 => regfile_ReadData_1,
        ReadData_2 => regfile_ReadData_2
    );
    
secondShiftLeft : Second_Shift_Left_2 
    port map(
        Instruction_15_0_Sign_Extended              => Instruction_15_0_Sign_Extended,
        Instruction_15_0_Sign_Extended_Left_Shifted => Instruction_15_0_Sign_Extended_Left_Shifted 
      );
      
      
firstAdder : adder_first
    port map(
        PC => PC,
        PC_icremented => PC_icremented
    );
    
secondAddet : adder_second
    port map(
        A => PC_icremented,
        B => Instruction_15_0_Sign_Extended_Left_Shifted,
        add_result => adder_second_result
    );
    
firstMux1 : mux_first
    port map(
          input_0 => Instruction(20 DOWNTO 16),
          input_1 => Instruction(15 DOWNTO 11),
          sel               => RegDst,
          output            => mux_first_i1_output   
    );
    
jalMux1 : mux_first
    port map(
         input_0 => mux_first_i1_output,
         input_1 => value_31,
         sel => Jal,
         output => regfile_WriteAddr
    );

mux_second_i1 : mux_second
    port map(
        input_0 => regfile_ReadData_2,
        input_1 => Instruction_15_0_Sign_Extended,
        sel => ALUSrc,
        output => alu_second_operand
    );

mux_second_i2 : mux_second
    port map(
        input_0 => ALU_result,
        input_1 => dm_ReadData,
        sel => MemToReg,
        output => mux_second_i2_output
    );
    
luiMux : mux_second
    port map(
        input_0 => jal_mux2_output,
        input_1 => Instr_15_0_sign_extended_shifted16,
        sel => Lui,
        output => lui_mux_output
    );    
    
oriMux : mux_second
    port map(
        input_0 => lui_mux_output,
        input_1 => oriValue,
        sel => Ori,
        output => regfile_WriteData
    );
    
leftShift16 : lui_shift_left_16
    port map(
        Instr_15_0_sign_extended => Instruction_15_0_Sign_Extended,
         Instr_15_0_lui_value => Instr_15_0_sign_extended_shifted16
    );
    
jalMux2 : mux_second
    port map(
        input_0 => mux_second_i2_output,
        input_1 => PC_icremented,
        sel => Jal,
        output => jal_mux2_output
    );
    
mux_second_i3 : mux_second
    port map(
        input_0 => PC_icremented,
        input_1 => adder_second_result,
        sel => PCSrc,
        output => mux_second_i3_output
    );
    
mux_second_i4 : mux_second
    port map(
        input_0 => mux_second_i3_output,
        input_1 => jump_address,
        sel => J,
        output => mux_second_i4_output
    );
    
jrMux : mux_second
    port map(
        input_0 => mux_second_i4_output,
        input_1 => regfile_ReadData_1,
        sel => Jr,
        output => PC_next
    );
signExtender : sign_extend
    port map(
          Instruction_15_0               => Instruction(15 DOWNTO 0),
          Instruction_15_0_Sign_Extended => Instruction_15_0_Sign_Extended
);






















---------------------------

END struct;
