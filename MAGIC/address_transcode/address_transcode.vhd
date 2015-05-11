library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

--***************************
--entity and port declaration
--***************************
entity address_transcode is
	PORT (
			ADDRESS 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ROW		: OUT unsigned (12 DOWNTO 0);
			COL		: OUT unsigned (2 DOWNTO 0)
			);
end;


--*********************
--architecture design
--*********************
architecture AtoI of address_transcode is
	
	signal address_sig : unsigned (31 downto 0);
	signal row_sig		 : unsigned (31 downto 0);
	signal col_sig		 : unsigned (31 downto 0);
	
	
	begin
	
	address_sig <= unsigned(ADDRESS);
	row_sig <= address_sig / 6;
	col_sig <= address_sig mod 6;
	ROW <= row_sig(12 downto 0);
	COL <= col_sig(2 downto 0);
	
end AtoI;
	