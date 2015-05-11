library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity create_opcode is
	PORT (
			COL_A		: IN UNSIGNED(2 DOWNTO 0);
			COL_B		: IN UNSIGNED(2 DOWNTO 0);
			COL_C		: IN UNSIGNED(2 DOWNTO 0);
			COL_D		: IN UNSIGNED(2 DOWNTO 0);
			COL_E		: IN UNSIGNED(2 DOWNTO 0);
			COL_W		: IN UNSIGNED(2 DOWNTO 0);
			--OUTPUTS OF READS
			OPCODE_0	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_1	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_2	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_3	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_4	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_5	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
			);
end;

architecture gen of create_opcode is
	
	begin
	
		process (COL_A, COL_B, COL_C, COL_D, COL_E, COL_W) begin
			--assigning address A to column
			if (COL_A = 0) then
				OPCODE_0(5) <= '1';
				OPCODE_1(5) <= '0';
				OPCODE_2(5) <= '0';
				OPCODE_3(5) <= '0';
				OPCODE_4(5) <= '0';
				OPCODE_5(5) <= '0';
			elsif (COL_A = 1) then
				OPCODE_0(5) <= '0';
				OPCODE_1(5) <= '1';
				OPCODE_2(5) <= '0';
				OPCODE_3(5) <= '0';
				OPCODE_4(5) <= '0';
				OPCODE_5(5) <= '0';
			elsif (COL_A = 2) then
				OPCODE_0(5) <= '0';
				OPCODE_1(5) <= '0';
				OPCODE_2(5) <= '1';
				OPCODE_3(5) <= '0';
				OPCODE_4(5) <= '0';
				OPCODE_5(5) <= '0';
			elsif (COL_A = 3) then
				OPCODE_0(5) <= '0';
				OPCODE_1(5) <= '0';
				OPCODE_2(5) <= '0';
				OPCODE_3(5) <= '1';
				OPCODE_4(5) <= '0';
				OPCODE_5(5) <= '0';
			elsif (COL_A = 4) then
				OPCODE_0(5) <= '0';
				OPCODE_1(5) <= '0';
				OPCODE_2(5) <= '0';
				OPCODE_3(5) <= '0';
				OPCODE_4(5) <= '1';
				OPCODE_5(5) <= '0';
			else
				OPCODE_0(5) <= '0';
				OPCODE_1(5) <= '0';
				OPCODE_2(5) <= '0';
				OPCODE_3(5) <= '0';
				OPCODE_4(5) <= '0';
				OPCODE_5(5) <= '1';
			end if;

			--assigning address B to column
			if (COL_B = 0) then
				OPCODE_0(4) <= '1';
				OPCODE_1(4) <= '0';
				OPCODE_2(4) <= '0';
				OPCODE_3(4) <= '0';
				OPCODE_4(4) <= '0';
				OPCODE_5(4) <= '0';
			elsif (COL_B = 1) then
				OPCODE_0(4) <= '0';
				OPCODE_1(4) <= '1';
				OPCODE_2(4) <= '0';
				OPCODE_3(4) <= '0';
				OPCODE_4(4) <= '0';
				OPCODE_5(4) <= '0';
			elsif (COL_B = 2) then
				OPCODE_0(4) <= '0';
				OPCODE_1(4) <= '0';
				OPCODE_2(4) <= '1';
				OPCODE_3(4) <= '0';
				OPCODE_4(4) <= '0';
				OPCODE_5(4) <= '0';
			elsif (COL_B = 3) then
				OPCODE_0(4) <= '0';
				OPCODE_1(4) <= '0';
				OPCODE_2(4) <= '0';
				OPCODE_3(4) <= '1';
				OPCODE_4(4) <= '0';
				OPCODE_5(4) <= '0';
			elsif (COL_B = 4) then
				OPCODE_0(4) <= '0';
				OPCODE_1(4) <= '0';
				OPCODE_2(4) <= '0';
				OPCODE_3(4) <= '0';
				OPCODE_4(4) <= '1';
				OPCODE_5(4) <= '0';
			else
				OPCODE_0(4) <= '0';
				OPCODE_1(4) <= '0';
				OPCODE_2(4) <= '0';
				OPCODE_3(4) <= '0';
				OPCODE_4(4) <= '0';
				OPCODE_5(4) <= '1';
			end if;
			
			--assigning address C to column
			if (COL_C = 0) then
				OPCODE_0(3) <= '1';
				OPCODE_1(3) <= '0';
				OPCODE_2(3) <= '0';
				OPCODE_3(3) <= '0';
				OPCODE_4(3) <= '0';
				OPCODE_5(3) <= '0';
			elsif (COL_C = 1) then
				OPCODE_0(3) <= '0';
				OPCODE_1(3) <= '1';
				OPCODE_2(3) <= '0';
				OPCODE_3(3) <= '0';
				OPCODE_4(3) <= '0';
				OPCODE_5(3) <= '0';
			elsif (COL_C = 2) then
				OPCODE_0(3) <= '0';
				OPCODE_1(3) <= '0';
				OPCODE_2(3) <= '1';
				OPCODE_3(3) <= '0';
				OPCODE_4(3) <= '0';
				OPCODE_5(3) <= '0';
			elsif (COL_C = 3) then
				OPCODE_0(3) <= '0';
				OPCODE_1(3) <= '0';
				OPCODE_2(3) <= '0';
				OPCODE_3(3) <= '1';
				OPCODE_4(3) <= '0';
				OPCODE_5(3) <= '0';
			elsif (COL_C = 4) then
				OPCODE_0(3) <= '0';
				OPCODE_1(3) <= '0';
				OPCODE_2(3) <= '0';
				OPCODE_3(3) <= '0';
				OPCODE_4(3) <= '1';
				OPCODE_5(3) <= '0';
			else
				OPCODE_0(3) <= '0';
				OPCODE_1(3) <= '0';
				OPCODE_2(3) <= '0';
				OPCODE_3(3) <= '0';
				OPCODE_4(3) <= '0';
				OPCODE_5(3) <= '1';
			end if;
			
			--assigning address D to column
			if (COL_D = 0) then
				OPCODE_0(2) <= '1';
				OPCODE_1(2) <= '0';
				OPCODE_2(2) <= '0';
				OPCODE_3(2) <= '0';
				OPCODE_4(2) <= '0';
				OPCODE_5(2) <= '0';
			elsif (COL_D = 1) then
				OPCODE_0(2) <= '0';
				OPCODE_1(2) <= '1';
				OPCODE_2(2) <= '0';
				OPCODE_3(2) <= '0';
				OPCODE_4(2) <= '0';
				OPCODE_5(2) <= '0';
			elsif (COL_D = 2) then
				OPCODE_0(2) <= '0';
				OPCODE_1(2) <= '0';
				OPCODE_2(2) <= '1';
				OPCODE_3(2) <= '0';
				OPCODE_4(2) <= '0';
				OPCODE_5(2) <= '0';
			elsif (COL_D = 3) then
				OPCODE_0(2) <= '0';
				OPCODE_1(2) <= '0';
				OPCODE_2(2) <= '0';
				OPCODE_3(2) <= '1';
				OPCODE_4(2) <= '0';
				OPCODE_5(2) <= '0';
			elsif (COL_D = 4) then
				OPCODE_0(2) <= '0';
				OPCODE_1(2) <= '0';
				OPCODE_2(2) <= '0';
				OPCODE_3(2) <= '0';
				OPCODE_4(2) <= '1';
				OPCODE_5(2) <= '0';
			else
				OPCODE_0(2) <= '0';
				OPCODE_1(2) <= '0';
				OPCODE_2(2) <= '0';
				OPCODE_3(2) <= '0';
				OPCODE_4(2) <= '0';
				OPCODE_5(2) <= '1';
			end if;
			--assigning address E to column
			if (COL_E = 0) then
				OPCODE_0(1) <= '1';
				OPCODE_1(1) <= '0';
				OPCODE_2(1) <= '0';
				OPCODE_3(1) <= '0';
				OPCODE_4(1) <= '0';
				OPCODE_5(1) <= '0';
			elsif (COL_E = 1) then
				OPCODE_0(1) <= '0';
				OPCODE_1(1) <= '1';
				OPCODE_2(1) <= '0';
				OPCODE_3(1) <= '0';
				OPCODE_4(1) <= '0';
				OPCODE_5(1) <= '0';
			elsif (COL_E = 2) then
				OPCODE_0(1) <= '0';
				OPCODE_1(1) <= '0';
				OPCODE_2(1) <= '1';
				OPCODE_3(1) <= '0';
				OPCODE_4(1) <= '0';
				OPCODE_5(1) <= '0';
			elsif (COL_E = 3) then
				OPCODE_0(1) <= '0';
				OPCODE_1(1) <= '0';
				OPCODE_2(1) <= '0';
				OPCODE_3(1) <= '1';
				OPCODE_4(1) <= '0';
				OPCODE_5(1) <= '0';
			elsif (COL_E = 4) then
				OPCODE_0(1) <= '0';
				OPCODE_1(1) <= '0';
				OPCODE_2(1) <= '0';
				OPCODE_3(1) <= '0';
				OPCODE_4(1) <= '1';
				OPCODE_5(1) <= '0';
			else
				OPCODE_0(1) <= '0';
				OPCODE_1(1) <= '0';
				OPCODE_2(1) <= '0';
				OPCODE_3(1) <= '0';
				OPCODE_4(1) <= '0';
				OPCODE_5(1) <= '1';
			end if;
			--assigning address W to column
			if (COL_W = 0) then
				OPCODE_0(0) <= '1';
				OPCODE_1(0) <= '0';
				OPCODE_2(0) <= '0';
				OPCODE_3(0) <= '0';
				OPCODE_4(0) <= '0';
				OPCODE_5(0) <= '0';
			elsif (COL_W = 1) then
				OPCODE_0(0) <= '0';
				OPCODE_1(0) <= '1';
				OPCODE_2(0) <= '0';
				OPCODE_3(0) <= '0';
				OPCODE_4(0) <= '0';
				OPCODE_5(0) <= '0';
			elsif (COL_W = 2) then
				OPCODE_0(0) <= '0';
				OPCODE_1(0) <= '0';
				OPCODE_2(0) <= '1';
				OPCODE_3(0) <= '0';
				OPCODE_4(0) <= '0';
				OPCODE_5(0) <= '0';
			elsif (COL_W = 3) then
				OPCODE_0(0) <= '0';
				OPCODE_1(0) <= '0';
				OPCODE_2(0) <= '0';
				OPCODE_3(0) <= '1';
				OPCODE_4(0) <= '0';
				OPCODE_5(0) <= '0';
			elsif (COL_W = 4) then
				OPCODE_0(0) <= '0';
				OPCODE_1(0) <= '0';
				OPCODE_2(0) <= '0';
				OPCODE_3(0) <= '0';
				OPCODE_4(0) <= '1';
				OPCODE_5(0) <= '0';
			else
				OPCODE_0(0) <= '0';
				OPCODE_1(0) <= '0';
				OPCODE_2(0) <= '0';
				OPCODE_3(0) <= '0';
				OPCODE_4(0) <= '0';
				OPCODE_5(0) <= '1';
			end if;
		end process;

end gen;