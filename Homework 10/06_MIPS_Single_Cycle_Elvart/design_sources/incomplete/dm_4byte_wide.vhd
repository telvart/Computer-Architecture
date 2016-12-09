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

-- Insert your code here --
Process(clk, rst)
begin
    if(rst = '1')then
       dm_mem <= initial_mem;
    elsif(clk'EVENT and clk= '1')then
        if(MemWrite = '1')then
            dm_mem(CONV_INTEGER(Address)) <= WriteData;-- - data_segment_start)/4) <= WriteData;
        end if;
    end if;

end process;

ReadData <= dm_mem(CONV_INTEGER(Address));-- - data_segment_start)/4);
---------------------------

END struct_4byte_wide;
