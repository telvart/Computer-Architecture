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

   branch_when_equal <= branch and zero;

   jump_address <= (PC_icremented(31 downto 28) & Instruction_25_0_Left_Shifted);

   -- Instance port mappings.
   alu_i1 : ALU
      PORT MAP (
         A           => regfile_ReadData_1,
         ALU_control => ALU_control,
         B           => alu_second_operand,
         ALU_result  => ALU_result,
         zero        => zero,
         overflow    => overflow
      );
   
   alu_controller_i1 : ALU_controller
      PORT MAP (
         ALU_op      => ALUOp,
         funct       => Instruction(5 DOWNTO 0),
         ALU_control => ALU_control
      );
   
   dm_i1 : DM
      PORT MAP (
         Address   => ALU_result,
         MemRead   => MemRead,
         MemWrite  => MemWrite,
         WriteData => regfile_ReadData_2,
         clk       => clk,
         rst       => rst,
         ReadData  => dm_ReadData
      );
   
   first_shift_left_2_i1 : First_Shift_Left_2
      PORT MAP (
         Instruction_25_0              => Instruction(25 DOWNTO 0),
         Instruction_25_0_Left_Shifted => Instruction_25_0_Left_Shifted
      );
   
   im_i1 : IM
      PORT MAP (
         ReadAddress => PC,
         rst         => rst,
         Instruction => Instruction
      );
   
   main_control_unit_i1 : Main_Control_Unit
      PORT MAP (
         Instruction_31_26 => Instruction(31 DOWNTO 26),
         ALUOp             => ALUOp,
         ALUSrc            => ALUSrc,
         Branch            => Branch,
         Jump              => Jump,
         MemRead           => MemRead,
         MemToReg          => MemToReg,
         MemWrite          => MemWrite,
         RegDst            => RegDst,
         RegWrite          => RegWrite
      );
   
   pc_register_i1 : PC_register
      PORT MAP (
         PC_next => PC_next,
         clk     => clk,
         rst     => rst,
         PC      => PC
      );
   
   regfile_i1 : RegFile
      PORT MAP (
         ReadAddr_1 => Instruction(25 DOWNTO 21),
         ReadAddr_2 => Instruction(20 DOWNTO 16),
         RegWrite   => RegWrite,
         WriteAddr  => regfile_WriteAddr,
         WriteData  => regfile_WriteData,
         clk        => clk,
         rst        => rst,
         ReadData_1 => regfile_ReadData_1,
         ReadData_2 => regfile_ReadData_2
      );
   
   second_shift_left_2_i1 : Second_Shift_Left_2
      PORT MAP (
         Instruction_15_0_Sign_Extended              => Instruction_15_0_Sign_Extended,
         Instruction_15_0_Sign_Extended_Left_Shifted => Instruction_15_0_Sign_Extended_Left_Shifted
      );
   
   adder_first_i1 : adder_first
      PORT MAP (
         PC            => PC,
         PC_icremented => PC_icremented
      );
   
   adder_second_i1 : adder_second
      PORT MAP (
         A          => PC_icremented,
         B          => Instruction_15_0_Sign_Extended_Left_Shifted,
         add_result => adder_second_result
      );
   
   mux_first_i1 : mux_first
      PORT MAP (
         instruction_15_11 => Instruction(15 DOWNTO 11),
         instruction_20_16 => Instruction(20 DOWNTO 16),
         sel               => RegDst,
         output            => regfile_WriteAddr
      );
   
   mux_second_i1 : mux_second
      PORT MAP (
         input_0 => regfile_ReadData_2,
         input_1 => Instruction_15_0_Sign_Extended,
         sel     => ALUSrc,
         output  => alu_second_operand
      );
   
   mux_second_i3 : mux_second
      PORT MAP (
         input_0 => PC_icremented,
         input_1 => adder_second_result,
         sel     => branch_when_equal,
         output  => mux_second_i3_output
      );
   
   mux_second_i4 : mux_second
      PORT MAP (
         input_0 => mux_second_i3_output,
         input_1 => jump_address,
         sel     => Jump,
         output  => PC_next
      );
   
   mux_second_i2 : mux_second
      PORT MAP (
         input_0 => ALU_result,
         input_1 => dm_ReadData,
         sel     => MemToReg,
         output  => regfile_WriteData
      );
   
   sign_extend_i1 : sign_extend
      PORT MAP (
         Instruction_15_0               => Instruction(15 DOWNTO 0),
         Instruction_15_0_Sign_Extended => Instruction_15_0_Sign_Extended
      );

END struct;
