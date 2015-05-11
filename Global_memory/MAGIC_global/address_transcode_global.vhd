library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

--***************************
--entity and port declaration
--***************************
entity address_transcode_global is
	PORT (
			ADDRESS 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ROW		: OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
			COL		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
			);
end;


--*********************
--architecture design
--*********************
architecture AtoI of address_transcode_global is
begin
	
	ROW <= ADDRESS(14 downto 3);
	COL <= ADDRESS(2 downto 0);

	
end AtoI;
	