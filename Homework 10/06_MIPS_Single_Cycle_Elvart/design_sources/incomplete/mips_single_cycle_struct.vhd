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
   SIGNAL Branch                                      : std_logic;
   SIGNAL Instruction                                 : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_15_0_Sign_Extended              : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_15_0_Sign_Extended_Left_Shifted : std_logic_vector(31 DOWNTO 0);
   SIGNAL Instruction_25_0_Left_Shifted               : std_logic_vector(27 DOWNTO 0);
   SIGNAL Jump                                        : std_logic;
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
   SIGNAL branch_when_equal                           : std_logic;
   SIGNAL dm_ReadData                                 : std_logic_vector(31 DOWNTO 0);
   SIGNAL jump_address                                : std_logic_vector(31 DOWNTO 0);
   SIGNAL mux_second_i3_output                        : std_logic_vector(31 DOWNTO 0);
   SIGNAL regfile_ReadData_1                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL regfile_ReadData_2                          : std_logic_vector(31 DOWNTO 0);
   SIGNAL regfile_WriteAddr                           : std_logic_vector(4 DOWNTO 0);
   SIGNAL regfile_WriteData                           : std_logic_vector(31 DOWNTO 0);
   SIGNAL zero                                        : std_logic;
   SIGNAL overflow                                    : std_logic;
   
   signal secondmux3sel : std_logic;
   



   -- Component Declarations
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
      ALUOp             : OUT    std_logic_vector (1 DOWNTO 0);
      ALUSrc            : OUT    std_logic ;
      Branch            : OUT    std_logic ;
      Jump              : OUT    std_logic ;
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
      instruction_15_11 : IN     std_logic_vector (4 DOWNTO 0);
      instruction_20_16 : IN     std_logic_vector (4 DOWNTO 0);
      sel               : IN     std_logic ;
      output            : OUT    std_logic_vector (4 DOWNTO 0)
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
secondmux3sel <= Branch and Zero;
jump_address <= PC_Icremented(31 downto 28) &
Instruction_25_0_Left_Shifted;

ALU1 : ALU port map(
    A => regfile_ReadData_1,
    ALU_control => ALU_control,
    B => alu_second_operand,
    ALU_result => ALU_result,
    zero => zero,
    overflow => overflow
);

ALUCONTROL1 :ALU_controller port map(
    ALU_op => ALUOp,
    funct => Instruction(5 downto 0),
    ALU_control => ALU_control
);

DM1 : DM port map(
    Address => ALU_result,
    MemRead => MemRead,
    MemWrite => MemWrite,
    WriteData => regfile_ReadData_2,
    clk => clk,
    rst => rst,
    ReadData => dm_ReadData
);

FSL21 : First_Shift_Left_2 port map(
    Instruction_25_0 => Instruction(25 downto 0),
    Instruction_25_0_Left_Shifted => Instruction_25_0_Left_Shifted
);

InstructionMemory1 : IM port map(
    ReadAddress => PC,
    rst => rst,
    Instruction => Instruction
);

MIPSControl1 : Main_Control_Unit port map(
    Instruction_31_26 => Instruction(31 downto 26),
    ALUOp => ALUop,
    ALUSrc => ALUSrc,
    Branch => Branch,
    Jump => Jump,
    MemRead => MemRead,
    MemToReg => MemToReg,
    MemWrite => MemWrite,
    RegDst => RegDst,
    RegWrite => RegWrite
);

PCREG1 : PC_register port map(
    PC_next => PC_next,
    clk => clk,
    rst => rst,
    PC => PC
);

Regfile1: RegFile port map(
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

SSL2: Second_Shift_Left_2 port map(
    Instruction_15_0_Sign_Extended => Instruction_15_0_Sign_Extended,
    Instruction_15_0_Sign_Extended_Left_Shifted => Instruction_15_0_Sign_Extended_Left_Shifted
);

FIRSTADDER: adder_first port map(
    PC => PC,
    PC_icremented => PC_icremented
);

SECONDADDER: adder_second port map(
    A => PC_icremented,
    B => Instruction_15_0_Sign_Extended_Left_Shifted,
    add_result => adder_second_result
);

MUXFIRST: mux_first port map(
     instruction_15_11 => Instruction(15 downto 11),
     instruction_20_16 => Instruction (20 downto 16),
     sel => RegDst,
     output => regfile_WriteAddr
);

MUXSECOND1: mux_second port map(
    input_0 => regfile_ReadData_2,
    input_1 => Instruction_15_0_Sign_Extended,
    sel => ALUSrc,
    output => alu_second_operand
);

MUXSECOND2: mux_second port map(
    input_0 => ALU_result,
    input_1 => dm_ReadData,
    sel => MemToReg,
    output => regfile_WriteData
);

MUXSECOND3: mux_second port map(
    input_0 => PC_icremented,
    input_1 => adder_second_result,
    sel => secondmux3sel,
    output => mux_second_i3_output
);

MUXSECOND4: mux_second port map(
    input_0 => mux_second_i3_output,
    input_1 => jump_address,
    sel => Jump,
    output => PC_next
);

SIGNEXTEND: sign_extend port map(
    Instruction_15_0 => Instruction(15 downto 0),
    Instruction_15_0_Sign_Extended => Instruction_15_0_Sign_Extended
);
---------------------------

END struct;
