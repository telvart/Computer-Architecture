LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;


ENTITY DM IS
   PORT( 
      Address   : IN     std_logic_vector (31 DOWNTO 0);
      MemRead   : IN     std_logic;
      MemWrite  : IN     std_logic;
      WriteData : IN     std_logic_vector (31 DOWNTO 0);
      clk       : IN     std_logic;
      rst       : IN     std_logic;
      ReadData  : OUT    std_logic_vector (31 DOWNTO 0)
   );
END DM ;


ARCHITECTURE struct_4byte_wide OF DM IS

   -- Architecture declarations
   constant data_segment_start : std_logic_vector(31 downto 0) := x"10010000";
   constant dm_size : natural := 128;
   
   type dm_mem_type is array(0 to dm_size-1) of std_logic_vector(31 downto 0);   
   constant zero_register : std_logic_vector(31 downto 0) := (others => '0');
   constant initial_mem : dm_mem_type := (others => zero_register);

   -- Internal signal declarations
   SIGNAL dm_mem : dm_mem_type;   
      
BEGIN
   ---------------------------------------------------------------------------
   process1 : PROCESS (clk, rst)
   ---------------------------------------------------------------------------
   BEGIN
      -- Asynchronous Reset
      IF (rst /= '0') THEN
         -- Reset Actions
         dm_mem <= initial_mem;
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (MemWrite = '1') THEN
            dm_mem( CONV_INTEGER(Address - data_segment_start)/4 ) <= WriteData;
         END IF;
      END IF;
   END PROCESS process1;

   ReadData <= dm_mem( CONV_INTEGER(Address - data_segment_start)/4 ) when (MemRead ='1')
                          else zero_register;
END struct_4byte_wide;
