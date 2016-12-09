LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY DataMem IS
   PORT( 
      Address : IN     std_logic_vector (31 DOWNTO 0);
      MemWrite   : IN     std_logic;
      WriteData  : IN     std_logic_vector (31 DOWNTO 0);
      clk        : IN     std_logic;
      rst        : IN     std_logic;
      ReadData : OUT    std_logic_vector (31 DOWNTO 0)
   );
END DataMem ;


ARCHITECTURE struct OF DataMem IS

   -- Architecture declarations
   type data_mem_type is array(0 to 255) of std_logic_vector(31 downto 0);
      
   constant zero_register : std_logic_vector(31 downto 0) := (others => '0');
   constant initial_mem : data_mem_type := (others => zero_register);

   -- Internal signal declarations
   SIGNAL data_mem : data_mem_type;

BEGIN
  -- insert your design here --

    Operation: Process(clk, rst)
    Begin
    if (rst = '1') Then
        data_mem <= initial_mem;
    elsif (clk'EVENT and clk= '1')Then
        if (MemWrite = '1') THEN
            data_mem(CONV_INTEGER(Address)) <= WriteData;
        End If;
    End If;
    End Process;
    
    ReadData <= data_mem(CONV_INTEGER(Address));

 
   -----------------------------

END struct;
