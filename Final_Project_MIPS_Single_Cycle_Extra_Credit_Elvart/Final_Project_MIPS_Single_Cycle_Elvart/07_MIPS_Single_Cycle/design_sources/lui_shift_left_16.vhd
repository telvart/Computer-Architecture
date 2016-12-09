LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY lui_shift_left_16 IS
    port(
        Instr_15_0_sign_extended : IN std_logic_vector (31 downto 0);
        Instr_15_0_lui_value : OUT std_logic_vector (31 downto 0)
    );
End lui_shift_left_16;

ARCHITECTURE struct OF lui_shift_left_16 IS
BEGIN

Instr_15_0_lui_value <= Instr_15_0_sign_extended(15 downto 0) & "0000000000000000";

END struct;


