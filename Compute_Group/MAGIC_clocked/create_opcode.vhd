library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity create_opcode is
	PORT (
			COL_A		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_B		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_C		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_D		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_E		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_W		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			W_EN		: IN STD_LOGIC;
			--OUTPUTS OF READS
			OPCODE_0	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_1	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_2	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_3	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_4	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_5	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_6	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_7	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
			);
end;

architecture gen of create_opcode is
	
	begin
	
		OPCODE_0(5) <= not(COL_A(2)) and not(COL_A(1)) and not(COL_A(0));
		OPCODE_1(5) <= not(COL_A(2)) and not(COL_A(1)) and (COL_A(0));
		OPCODE_2(5) <= not(COL_A(2)) and (COL_A(1)) and not(COL_A(0));
		OPCODE_3(5) <= not(COL_A(2)) and (COL_A(1)) and (COL_A(0));
		OPCODE_4(5) <= (COL_A(2)) and not(COL_A(1)) and not(COL_A(0));
		OPCODE_5(5) <= (COL_A(2)) and not(COL_A(1)) and (COL_A(0));
		OPCODE_6(5) <= (COL_A(2)) and (COL_A(1)) and not(COL_A(0));
		OPCODE_7(5) <= (COL_A(2)) and (COL_A(1)) and (COL_A(0));
		
		OPCODE_0(4) <= not(COL_B(2)) and not(COL_B(1)) and not(COL_B(0));
		OPCODE_1(4) <= not(COL_B(2)) and not(COL_B(1)) and (COL_B(0));
		OPCODE_2(4) <= not(COL_B(2)) and (COL_B(1)) and not(COL_B(0));
		OPCODE_3(4) <= not(COL_B(2)) and (COL_B(1)) and (COL_B(0));
		OPCODE_4(4) <= (COL_B(2)) and not(COL_B(1)) and not(COL_B(0));
		OPCODE_5(4) <= (COL_B(2)) and not(COL_B(1)) and (COL_B(0));
		OPCODE_6(4) <= (COL_B(2)) and (COL_B(1)) and not(COL_B(0));
		OPCODE_7(4) <= (COL_B(2)) and (COL_B(1)) and (COL_B(0));
		
		OPCODE_0(3) <= not(COL_C(2)) and not(COL_C(1)) and not(COL_C(0));
		OPCODE_1(3) <= not(COL_C(2)) and not(COL_C(1)) and (COL_C(0));
		OPCODE_2(3) <= not(COL_C(2)) and (COL_C(1)) and not(COL_C(0));
		OPCODE_3(3) <= not(COL_C(2)) and (COL_C(1)) and (COL_C(0));
		OPCODE_4(3) <= (COL_C(2)) and not(COL_C(1)) and not(COL_C(0));
		OPCODE_5(3) <= (COL_C(2)) and not(COL_C(1)) and (COL_C(0));
		OPCODE_6(3) <= (COL_C(2)) and (COL_C(1)) and not(COL_C(0));
		OPCODE_7(3) <= (COL_C(2)) and (COL_C(1)) and (COL_C(0));
		
		OPCODE_0(2) <= not(COL_D(2)) and not(COL_D(1)) and not(COL_D(0));
		OPCODE_1(2) <= not(COL_D(2)) and not(COL_D(1)) and (COL_D(0));
		OPCODE_2(2) <= not(COL_D(2)) and (COL_D(1)) and not(COL_D(0));
		OPCODE_3(2) <= not(COL_D(2)) and (COL_D(1)) and (COL_D(0));
		OPCODE_4(2) <= (COL_D(2)) and not(COL_D(1)) and not(COL_D(0));
		OPCODE_5(2) <= (COL_D(2)) and not(COL_D(1)) and (COL_D(0));
		OPCODE_6(2) <= (COL_D(2)) and (COL_D(1)) and not(COL_D(0));
		OPCODE_7(2) <= (COL_D(2)) and (COL_D(1)) and (COL_D(0));
		
		OPCODE_0(1) <= not(COL_E(2)) and not(COL_E(1)) and not(COL_E(0));
		OPCODE_1(1) <= not(COL_E(2)) and not(COL_E(1)) and (COL_E(0));
		OPCODE_2(1) <= not(COL_E(2)) and (COL_E(1)) and not(COL_E(0));
		OPCODE_3(1) <= not(COL_E(2)) and (COL_E(1)) and (COL_E(0));
		OPCODE_4(1) <= (COL_E(2)) and not(COL_E(1)) and not(COL_E(0));
		OPCODE_5(1) <= (COL_E(2)) and not(COL_E(1)) and (COL_E(0));
		OPCODE_6(1) <= (COL_E(2)) and (COL_E(1)) and not(COL_E(0));
		OPCODE_7(1) <= (COL_E(2)) and (COL_E(1)) and (COL_E(0));
		
		OPCODE_0(0) <= (not(COL_W(2)) and not(COL_W(1)) and not(COL_W(0))) and W_EN;
		OPCODE_1(0) <= (not(COL_W(2)) and not(COL_W(1)) and (COL_W(0))) and W_EN;
		OPCODE_2(0) <= (not(COL_W(2)) and (COL_W(1)) and not(COL_W(0))) and W_EN;
		OPCODE_3(0) <= (not(COL_W(2)) and (COL_W(1)) and (COL_W(0))) and W_EN;
		OPCODE_4(0) <= ((COL_W(2)) and not(COL_W(1)) and not(COL_W(0))) and W_EN;
		OPCODE_5(0) <= ((COL_W(2)) and not(COL_W(1)) and (COL_W(0))) and W_EN;
		OPCODE_6(0) <= ((COL_W(2)) and (COL_W(1)) and not(COL_W(0))) and W_EN;
		OPCODE_7(0) <= ((COL_W(2)) and (COL_W(1)) and (COL_W(0))) and W_EN;
		
--		process (COL_A, COL_B, COL_C, COL_D, COL_E, COL_W, W_EN) begin
--			--assigning address A to column
--			if (COL_A = 0) then
--				OPCODE_0(5) <= '1';
--				OPCODE_1(5) <= '0';
--				OPCODE_2(5) <= '0';
--				OPCODE_3(5) <= '0';
--				OPCODE_4(5) <= '0';
--				OPCODE_5(5) <= '0';
--				OPCODE_6(5) <= '0';
--				OPCODE_7(5) <= '0';
--			elsif (COL_A = 1) then
--				OPCODE_0(5) <= '0';
--				OPCODE_1(5) <= '1';
--				OPCODE_2(5) <= '0';
--				OPCODE_3(5) <= '0';
--				OPCODE_4(5) <= '0';
--				OPCODE_5(5) <= '0';
--				OPCODE_6(5) <= '0';
--				OPCODE_7(5) <= '0';
--			elsif (COL_A = 2) then
--				OPCODE_0(5) <= '0';
--				OPCODE_1(5) <= '0';
--				OPCODE_2(5) <= '1';
--				OPCODE_3(5) <= '0';
--				OPCODE_4(5) <= '0';
--				OPCODE_5(5) <= '0';
--				OPCODE_6(5) <= '0';
--				OPCODE_7(5) <= '0';
--			elsif (COL_A = 3) then
--				OPCODE_0(5) <= '0';
--				OPCODE_1(5) <= '0';
--				OPCODE_2(5) <= '0';
--				OPCODE_3(5) <= '1';
--				OPCODE_4(5) <= '0';
--				OPCODE_5(5) <= '0';
--				OPCODE_6(5) <= '0';
--				OPCODE_7(5) <= '0';
--			elsif (COL_A = 4) then
--				OPCODE_0(5) <= '0';
--				OPCODE_1(5) <= '0';
--				OPCODE_2(5) <= '0';
--				OPCODE_3(5) <= '0';
--				OPCODE_4(5) <= '1';
--				OPCODE_5(5) <= '0';
--				OPCODE_6(5) <= '0';
--				OPCODE_7(5) <= '0';
--			elsif (COL_A = 5) then
--				OPCODE_0(5) <= '0';
--				OPCODE_1(5) <= '0';
--				OPCODE_2(5) <= '0';
--				OPCODE_3(5) <= '0';
--				OPCODE_4(5) <= '0';
--				OPCODE_5(5) <= '1';
--				OPCODE_6(5) <= '0';
--				OPCODE_7(5) <= '0';
--			elsif (COL_A = 6) then
--				OPCODE_0(5) <= '0';
--				OPCODE_1(5) <= '0';
--				OPCODE_2(5) <= '0';
--				OPCODE_3(5) <= '0';
--				OPCODE_4(5) <= '0';
--				OPCODE_5(5) <= '0';
--				OPCODE_6(5) <= '1';
--				OPCODE_7(5) <= '0';
--			elsif (COL_A = 7) then
--				OPCODE_0(5) <= '0';
--				OPCODE_1(5) <= '0';
--				OPCODE_2(5) <= '0';
--				OPCODE_3(5) <= '0';
--				OPCODE_4(5) <= '0';
--				OPCODE_5(5) <= '0';
--				OPCODE_6(5) <= '0';
--				OPCODE_7(5) <= '1';
--			else
--				OPCODE_0(5) <= '0';
--				OPCODE_1(5) <= '0';
--				OPCODE_2(5) <= '0';
--				OPCODE_3(5) <= '0';
--				OPCODE_4(5) <= '0';
--				OPCODE_5(5) <= '0';
--				OPCODE_6(5) <= '0';
--				OPCODE_7(5) <= '0';
--			end if;
--
--			--assigning address B to column
--			if (COL_B = 0) then
--				OPCODE_0(4) <= '1';
--				OPCODE_1(4) <= '0';
--				OPCODE_2(4) <= '0';
--				OPCODE_3(4) <= '0';
--				OPCODE_4(4) <= '0';
--				OPCODE_5(4) <= '0';
--				OPCODE_6(4) <= '0';
--				OPCODE_7(4) <= '0';
--			elsif (COL_B = 1) then
--				OPCODE_0(4) <= '0';
--				OPCODE_1(4) <= '1';
--				OPCODE_2(4) <= '0';
--				OPCODE_3(4) <= '0';
--				OPCODE_4(4) <= '0';
--				OPCODE_5(4) <= '0';
--				OPCODE_6(4) <= '0';
--				OPCODE_7(4) <= '0';
--			elsif (COL_B = 2) then
--				OPCODE_0(4) <= '0';
--				OPCODE_1(4) <= '0';
--				OPCODE_2(4) <= '1';
--				OPCODE_3(4) <= '0';
--				OPCODE_4(4) <= '0';
--				OPCODE_5(4) <= '0';
--				OPCODE_6(4) <= '0';
--				OPCODE_7(4) <= '0';
--			elsif (COL_B = 3) then
--				OPCODE_0(4) <= '0';
--				OPCODE_1(4) <= '0';
--				OPCODE_2(4) <= '0';
--				OPCODE_3(4) <= '1';
--				OPCODE_4(4) <= '0';
--				OPCODE_5(4) <= '0';
--				OPCODE_6(4) <= '0';
--				OPCODE_7(4) <= '0';
--			elsif (COL_B = 4) then
--				OPCODE_0(4) <= '0';
--				OPCODE_1(4) <= '0';
--				OPCODE_2(4) <= '0';
--				OPCODE_3(4) <= '0';
--				OPCODE_4(4) <= '1';
--				OPCODE_5(4) <= '0';
--				OPCODE_6(4) <= '0';
--				OPCODE_7(4) <= '0';
--			elsif (COL_B = 5) then
--				OPCODE_0(4) <= '0';
--				OPCODE_1(4) <= '0';
--				OPCODE_2(4) <= '0';
--				OPCODE_3(4) <= '0';
--				OPCODE_4(4) <= '0';
--				OPCODE_5(4) <= '1';
--				OPCODE_6(4) <= '0';
--				OPCODE_7(4) <= '0';
--			elsif (COL_B = 6) then
--				OPCODE_0(4) <= '0';
--				OPCODE_1(4) <= '0';
--				OPCODE_2(4) <= '0';
--				OPCODE_3(4) <= '0';
--				OPCODE_4(4) <= '0';
--				OPCODE_5(4) <= '0';
--				OPCODE_6(4) <= '1';
--				OPCODE_7(4) <= '0';
--			elsif (COL_B = 7) then
--				OPCODE_0(4) <= '0';
--				OPCODE_1(4) <= '0';
--				OPCODE_2(4) <= '0';
--				OPCODE_3(4) <= '0';
--				OPCODE_4(4) <= '0';
--				OPCODE_5(4) <= '0';
--				OPCODE_6(4) <= '0';
--				OPCODE_7(4) <= '1';
--			else
--				OPCODE_0(4) <= '0';
--				OPCODE_1(4) <= '0';
--				OPCODE_2(4) <= '0';
--				OPCODE_3(4) <= '0';
--				OPCODE_4(4) <= '0';
--				OPCODE_5(4) <= '0';
--				OPCODE_6(4) <= '0';
--				OPCODE_7(4) <= '0';
--			end if;
--			
--			--assigning address C to column
--			if (COL_C = 0) then
--				OPCODE_0(3) <= '1';
--				OPCODE_1(3) <= '0';
--				OPCODE_2(3) <= '0';
--				OPCODE_3(3) <= '0';
--				OPCODE_4(3) <= '0';
--				OPCODE_5(3) <= '0';
--				OPCODE_6(3) <= '0';
--				OPCODE_7(3) <= '0';
--			elsif (COL_C = 1) then
--				OPCODE_0(3) <= '0';
--				OPCODE_1(3) <= '1';
--				OPCODE_2(3) <= '0';
--				OPCODE_3(3) <= '0';
--				OPCODE_4(3) <= '0';
--				OPCODE_5(3) <= '0';
--				OPCODE_6(3) <= '0';
--				OPCODE_7(3) <= '0';
--			elsif (COL_C = 2) then
--				OPCODE_0(3) <= '0';
--				OPCODE_1(3) <= '0';
--				OPCODE_2(3) <= '1';
--				OPCODE_3(3) <= '0';
--				OPCODE_4(3) <= '0';
--				OPCODE_5(3) <= '0';
--				OPCODE_6(3) <= '0';
--				OPCODE_7(3) <= '0';
--			elsif (COL_C = 3) then
--				OPCODE_0(3) <= '0';
--				OPCODE_1(3) <= '0';
--				OPCODE_2(3) <= '0';
--				OPCODE_3(3) <= '1';
--				OPCODE_4(3) <= '0';
--				OPCODE_5(3) <= '0';
--				OPCODE_6(3) <= '0';
--				OPCODE_7(3) <= '0';
--			elsif (COL_C = 4) then
--				OPCODE_0(3) <= '0';
--				OPCODE_1(3) <= '0';
--				OPCODE_2(3) <= '0';
--				OPCODE_3(3) <= '0';
--				OPCODE_4(3) <= '1';
--				OPCODE_5(3) <= '0';
--				OPCODE_6(3) <= '0';
--				OPCODE_7(3) <= '0';
--			elsif (COL_C = 5) then
--				OPCODE_0(3) <= '0';
--				OPCODE_1(3) <= '0';
--				OPCODE_2(3) <= '0';
--				OPCODE_3(3) <= '0';
--				OPCODE_4(3) <= '0';
--				OPCODE_5(3) <= '1';
--				OPCODE_6(3) <= '0';
--				OPCODE_7(3) <= '0';
--			elsif (COL_C = 6) then
--				OPCODE_0(3) <= '0';
--				OPCODE_1(3) <= '0';
--				OPCODE_2(3) <= '0';
--				OPCODE_3(3) <= '0';
--				OPCODE_4(3) <= '0';
--				OPCODE_5(3) <= '0';
--				OPCODE_6(3) <= '1';
--				OPCODE_7(3) <= '0';
--			elsif (COL_C = 7) then
--				OPCODE_0(3) <= '0';
--				OPCODE_1(3) <= '0';
--				OPCODE_2(3) <= '0';
--				OPCODE_3(3) <= '0';
--				OPCODE_4(3) <= '0';
--				OPCODE_5(3) <= '0';
--				OPCODE_6(3) <= '0';
--				OPCODE_7(3) <= '1';
--			else
--				OPCODE_0(3) <= '0';
--				OPCODE_1(3) <= '0';
--				OPCODE_2(3) <= '0';
--				OPCODE_3(3) <= '0';
--				OPCODE_4(3) <= '0';
--				OPCODE_5(3) <= '0';
--				OPCODE_6(3) <= '0';
--				OPCODE_7(3) <= '0';
--			end if;
--			--assigning address D to column
--			if (COL_D = 0) then
--				OPCODE_0(2) <= '1';
--				OPCODE_1(2) <= '0';
--				OPCODE_2(2) <= '0';
--				OPCODE_3(2) <= '0';
--				OPCODE_4(2) <= '0';
--				OPCODE_5(2) <= '0';
--				OPCODE_6(2) <= '0';
--				OPCODE_7(2) <= '0';
--			elsif (COL_D = 1) then
--				OPCODE_0(2) <= '0';
--				OPCODE_1(2) <= '1';
--				OPCODE_2(2) <= '0';
--				OPCODE_3(2) <= '0';
--				OPCODE_4(2) <= '0';
--				OPCODE_5(2) <= '0';
--				OPCODE_6(2) <= '0';
--				OPCODE_7(2) <= '0';
--			elsif (COL_D = 2) then
--				OPCODE_0(2) <= '0';
--				OPCODE_1(2) <= '0';
--				OPCODE_2(2) <= '1';
--				OPCODE_3(2) <= '0';
--				OPCODE_4(2) <= '0';
--				OPCODE_5(2) <= '0';
--				OPCODE_6(2) <= '0';
--				OPCODE_7(2) <= '0';
--			elsif (COL_D = 3) then
--				OPCODE_0(2) <= '0';
--				OPCODE_1(2) <= '0';
--				OPCODE_2(2) <= '0';
--				OPCODE_3(2) <= '1';
--				OPCODE_4(2) <= '0';
--				OPCODE_5(2) <= '0';
--				OPCODE_6(2) <= '0';
--				OPCODE_7(2) <= '0';
--			elsif (COL_D = 4) then
--				OPCODE_0(2) <= '0';
--				OPCODE_1(2) <= '0';
--				OPCODE_2(2) <= '0';
--				OPCODE_3(2) <= '0';
--				OPCODE_4(2) <= '1';
--				OPCODE_5(2) <= '0';
--				OPCODE_6(2) <= '0';
--				OPCODE_7(2) <= '0';
--			elsif (COL_D = 5) then
--				OPCODE_0(2) <= '0';
--				OPCODE_1(2) <= '0';
--				OPCODE_2(2) <= '0';
--				OPCODE_3(2) <= '0';
--				OPCODE_4(2) <= '0';
--				OPCODE_5(2) <= '1';
--				OPCODE_6(2) <= '0';
--				OPCODE_7(2) <= '0';
--			elsif (COL_D = 6) then
--				OPCODE_0(2) <= '0';
--				OPCODE_1(2) <= '0';
--				OPCODE_2(2) <= '0';
--				OPCODE_3(2) <= '0';
--				OPCODE_4(2) <= '0';
--				OPCODE_5(2) <= '0';
--				OPCODE_6(2) <= '1';
--				OPCODE_7(2) <= '0';
--			elsif (COL_D = 7) then
--				OPCODE_0(2) <= '0';
--				OPCODE_1(2) <= '0';
--				OPCODE_2(2) <= '0';
--				OPCODE_3(2) <= '0';
--				OPCODE_4(2) <= '0';
--				OPCODE_5(2) <= '0';
--				OPCODE_6(2) <= '0';
--				OPCODE_7(2) <= '1';
--			else
--				OPCODE_0(2) <= '0';
--				OPCODE_1(2) <= '0';
--				OPCODE_2(2) <= '0';
--				OPCODE_3(2) <= '0';
--				OPCODE_4(2) <= '0';
--				OPCODE_5(2) <= '0';
--				OPCODE_6(2) <= '0';
--				OPCODE_7(2) <= '0';
--			end if;
--			--assigning address E to column
--			if (COL_E = 0) then
--				OPCODE_0(1) <= '1';
--				OPCODE_1(1) <= '0';
--				OPCODE_2(1) <= '0';
--				OPCODE_3(1) <= '0';
--				OPCODE_4(1) <= '0';
--				OPCODE_5(1) <= '0';
--				OPCODE_6(1) <= '0';
--				OPCODE_7(1) <= '0';
--			elsif (COL_E = 1) then
--				OPCODE_0(1) <= '0';
--				OPCODE_1(1) <= '1';
--				OPCODE_2(1) <= '0';
--				OPCODE_3(1) <= '0';
--				OPCODE_4(1) <= '0';
--				OPCODE_5(1) <= '0';
--				OPCODE_6(1) <= '0';
--				OPCODE_7(1) <= '0';
--			elsif (COL_E = 2) then
--				OPCODE_0(1) <= '0';
--				OPCODE_1(1) <= '0';
--				OPCODE_2(1) <= '1';
--				OPCODE_3(1) <= '0';
--				OPCODE_4(1) <= '0';
--				OPCODE_5(1) <= '0';
--				OPCODE_6(1) <= '0';
--				OPCODE_7(1) <= '0';
--			elsif (COL_E = 3) then
--				OPCODE_0(1) <= '0';
--				OPCODE_1(1) <= '0';
--				OPCODE_2(1) <= '0';
--				OPCODE_3(1) <= '1';
--				OPCODE_4(1) <= '0';
--				OPCODE_5(1) <= '0';
--				OPCODE_6(1) <= '0';
--				OPCODE_7(1) <= '0';
--			elsif (COL_E = 4) then
--				OPCODE_0(1) <= '0';
--				OPCODE_1(1) <= '0';
--				OPCODE_2(1) <= '0';
--				OPCODE_3(1) <= '0';
--				OPCODE_4(1) <= '1';
--				OPCODE_5(1) <= '0';
--				OPCODE_6(1) <= '0';
--				OPCODE_7(1) <= '0';
--			elsif (COL_E = 5) then
--				OPCODE_0(1) <= '0';
--				OPCODE_1(1) <= '0';
--				OPCODE_2(1) <= '0';
--				OPCODE_3(1) <= '0';
--				OPCODE_4(1) <= '0';
--				OPCODE_5(1) <= '1';
--				OPCODE_6(1) <= '0';
--				OPCODE_7(1) <= '0';
--			elsif (COL_E = 6) then
--				OPCODE_0(1) <= '0';
--				OPCODE_1(1) <= '0';
--				OPCODE_2(1) <= '0';
--				OPCODE_3(1) <= '0';
--				OPCODE_4(1) <= '0';
--				OPCODE_5(1) <= '0';
--				OPCODE_6(1) <= '1';
--				OPCODE_7(1) <= '0';
--			elsif (COL_E = 7) then
--				OPCODE_0(1) <= '0';
--				OPCODE_1(1) <= '0';
--				OPCODE_2(1) <= '0';
--				OPCODE_3(1) <= '0';
--				OPCODE_4(1) <= '0';
--				OPCODE_5(1) <= '0';
--				OPCODE_6(1) <= '0';
--				OPCODE_7(1) <= '1';
--			else
--				OPCODE_0(1) <= '0';
--				OPCODE_1(1) <= '0';
--				OPCODE_2(1) <= '0';
--				OPCODE_3(1) <= '0';
--				OPCODE_4(1) <= '0';
--				OPCODE_5(1) <= '0';
--				OPCODE_6(1) <= '0';
--				OPCODE_7(1) <= '0';
--			end if;
--			--assigning address W to column
--			if (COL_W = 0) then
--				OPCODE_0(0) <= '1' and W_EN;
--				OPCODE_1(0) <= '0';
--				OPCODE_2(0) <= '0';
--				OPCODE_3(0) <= '0';
--				OPCODE_4(0) <= '0';
--				OPCODE_5(0) <= '0';
--				OPCODE_6(0) <= '0';
--				OPCODE_7(0) <= '0';
--			elsif (COL_W = 1) then
--				OPCODE_0(0) <= '0';
--				OPCODE_1(0) <= '1' and W_EN;
--				OPCODE_2(0) <= '0';
--				OPCODE_3(0) <= '0';
--				OPCODE_4(0) <= '0';
--				OPCODE_5(0) <= '0';
--				OPCODE_6(0) <= '0';
--				OPCODE_7(0) <= '0';
--			elsif (COL_W = 2) then
--				OPCODE_0(0) <= '0';
--				OPCODE_1(0) <= '0';
--				OPCODE_2(0) <= '1' and W_EN;
--				OPCODE_3(0) <= '0';
--				OPCODE_4(0) <= '0';
--				OPCODE_5(0) <= '0';
--				OPCODE_6(0) <= '0';
--				OPCODE_7(0) <= '0';
--			elsif (COL_W = 3) then
--				OPCODE_0(0) <= '0';
--				OPCODE_1(0) <= '0';
--				OPCODE_2(0) <= '0';
--				OPCODE_3(0) <= '1' and W_EN;
--				OPCODE_4(0) <= '0';
--				OPCODE_5(0) <= '0';
--				OPCODE_6(0) <= '0';
--				OPCODE_7(0) <= '0';
--			elsif (COL_W = 4) then
--				OPCODE_0(0) <= '0';
--				OPCODE_1(0) <= '0';
--				OPCODE_2(0) <= '0';
--				OPCODE_3(0) <= '0';
--				OPCODE_4(0) <= '1' and W_EN;
--				OPCODE_5(0) <= '0';
--				OPCODE_6(0) <= '0';
--				OPCODE_7(0) <= '0';
--			elsif (COL_W = 5) then
--				OPCODE_0(0) <= '0';
--				OPCODE_1(0) <= '0';
--				OPCODE_2(0) <= '0';
--				OPCODE_3(0) <= '0';
--				OPCODE_4(0) <= '0';
--				OPCODE_5(0) <= '1' and W_EN;
--				OPCODE_6(0) <= '0';
--				OPCODE_7(0) <= '0';
--			elsif (COL_W = 6) then
--				OPCODE_0(0) <= '0';
--				OPCODE_1(0) <= '0';
--				OPCODE_2(0) <= '0';
--				OPCODE_3(0) <= '0';
--				OPCODE_4(0) <= '0';
--				OPCODE_5(0) <= '0';
--				OPCODE_6(0) <= '1' and W_EN;
--				OPCODE_7(0) <= '0';
--			elsif (COL_W = 7) then
--				OPCODE_0(0) <= '0';
--				OPCODE_1(0) <= '0';
--				OPCODE_2(0) <= '0';
--				OPCODE_3(0) <= '0';
--				OPCODE_4(0) <= '0';
--				OPCODE_5(0) <= '0';
--				OPCODE_6(0) <= '0';
--				OPCODE_7(0) <= '1' and W_EN;
--			else
--				OPCODE_0(0) <= '0';
--				OPCODE_1(0) <= '0';
--				OPCODE_2(0) <= '0';
--				OPCODE_3(0) <= '0';
--				OPCODE_4(0) <= '0';
--				OPCODE_5(0) <= '0';
--				OPCODE_6(0) <= '0';
--				OPCODE_7(0) <= '0';
--			end if;
--		end process;

end gen;