library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROUTE_global is
	PORT(
			CLK			: IN STD_LOGIC;
			RESET_n		: IN STD_LOGIC;
			hazard		: IN STD_LOGIC;
			hazard_advanced : IN STD_LOGIC;
			ram_0_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_0_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_1_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_1_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_2_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_2_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_3_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_3_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_4_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_4_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_5_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_5_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_6_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_6_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_7_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_7_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_0_sel_vector : IN STD_LOGIC_VECTOR (9 downto 0);
			ram_1_sel_vector : IN STD_LOGIC_VECTOR (9 downto 0);
			ram_2_sel_vector : IN STD_LOGIC_VECTOR (9 downto 0);
			ram_3_sel_vector : IN STD_LOGIC_VECTOR (9 downto 0);
			ram_4_sel_vector : IN STD_LOGIC_VECTOR (9 downto 0);
			ram_5_sel_vector : IN STD_LOGIC_VECTOR (9 downto 0);
			ram_6_sel_vector : IN STD_LOGIC_VECTOR (9 downto 0);
			ram_7_sel_vector : IN STD_LOGIC_VECTOR (9 downto 0);
			OUTPUT_A : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			OUTPUT_B : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			OUTPUT_C : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			OUTPUT_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			OUTPUT_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
end;

architecture control of ROUTE_global is
--******************************************PROTOTYPE FOR REFERENCE************************************************
--								RAM 0	-----> ram_0_sel_vector = A0 A1 B0 B1 C0 C1 D0 D1 E0 E1
--								RAM 1	-----> ram_1_sel_vector = A0 A1 B0 B1 C0 C1 D0 D1 E0 E1
--								RAM 2	-----> ram_2_sel_vector = A0 A1 B0 B1 C0 C1 D0 D1 E0 E1
--								RAM 3	-----> ram_3_sel_vector = A0 A1 B0 B1 C0 C1 D0 D1 E0 E1
--								RAM 4	-----> ram_4_sel_vector = A0 A1 B0 B1 C0 C1 D0 D1 E0 E1
--								RAM 5	-----> ram_5_sel_vector = A0 A1 B0 B1 C0 C1 D0 D1 E0 E1
--								RAM 6	-----> ram_6_sel_vector = A0 A1 B0 B1 C0 C1 D0 D1 E0 E1
--								RAM 7	-----> ram_7_sel_vector = A0 A1 B0 B1 C0 C1 D0 D1 E0 E1

	component ROUTE_SIGNAL_global
		PORT(
			ram_0_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_0_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_1_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_1_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_2_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_2_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_3_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_3_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_4_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_4_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_5_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_5_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_6_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_6_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_7_out_a : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ram_7_out_b : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			select_vector : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			hazard	: IN STD_LOGIC;
			hazard_advanced : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			RESET_n : IN STD_LOGIC;
			OUTPUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
	end component;

	signal select_a : std_logic_vector (15 downto 0);
	signal select_b : std_logic_vector (15 downto 0);
	signal select_c : std_logic_vector (15 downto 0);
	signal select_0 : std_logic_vector (15 downto 0);
	signal select_1 : std_logic_vector (15 downto 0);
	
	signal select_a_1hot : std_logic_vector (15 downto 0);
	signal select_b_1hot : std_logic_vector (15 downto 0);
	signal select_c_1hot : std_logic_vector (15 downto 0);
	signal select_0_1hot : std_logic_vector (15 downto 0);
	signal select_1_1hot : std_logic_vector (15 downto 0);

begin
	
	select_a <= ram_0_sel_vector(9 downto 8) & ram_1_sel_vector(9 downto 8) &
					ram_2_sel_vector(9 downto 8) & ram_3_sel_vector(9 downto 8) &
					ram_4_sel_vector(9 downto 8) & ram_5_sel_vector(9 downto 8) &
					ram_6_sel_vector(9 downto 8) & ram_7_sel_vector(9 downto 8);
					
	select_b <= ram_0_sel_vector(7 downto 6) & ram_1_sel_vector(7 downto 6) &
					ram_2_sel_vector(7 downto 6) & ram_3_sel_vector(7 downto 6) &
					ram_4_sel_vector(7 downto 6) & ram_5_sel_vector(7 downto 6) &
					ram_6_sel_vector(7 downto 6) & ram_7_sel_vector(7 downto 6);
					
	select_c <= ram_0_sel_vector(5 downto 4) & ram_1_sel_vector(5 downto 4) &
					ram_2_sel_vector(5 downto 4) & ram_3_sel_vector(5 downto 4) &
					ram_4_sel_vector(5 downto 4) & ram_5_sel_vector(5 downto 4) &
					ram_6_sel_vector(5 downto 4) & ram_7_sel_vector(5 downto 4);
					
	select_0 <= ram_0_sel_vector(3 downto 2) & ram_1_sel_vector(3 downto 2) &
					ram_2_sel_vector(3 downto 2) & ram_3_sel_vector(3 downto 2) &
					ram_4_sel_vector(3 downto 2) & ram_5_sel_vector(3 downto 2) &
					ram_6_sel_vector(3 downto 2) & ram_7_sel_vector(3 downto 2);
					
	select_1 <= ram_0_sel_vector(1 downto 0) & ram_1_sel_vector(1 downto 0) &
					ram_2_sel_vector(1 downto 0) & ram_3_sel_vector(1 downto 0) &
					ram_4_sel_vector(1 downto 0) & ram_5_sel_vector(1 downto 0) &
					ram_6_sel_vector(1 downto 0) & ram_7_sel_vector(1 downto 0);
					
	select_a_1hot <= select_a(15) & (not(select_a(15) and select_a(14)) and select_a(14)) &
						  select_a(13) & (not(select_a(13) and select_a(12)) and select_a(12)) &
						  select_a(11) & (not(select_a(11) and select_a(10)) and select_a(10)) &
						  select_a(9) & (not(select_a(9) and select_a(8)) and select_a(8)) &
						  select_a(7) & (not(select_a(7) and select_a(6)) and select_a(6)) &
						  select_a(5) & (not(select_a(5) and select_a(4)) and select_a(4)) &
						  select_a(3) & (not(select_a(3) and select_a(2)) and select_a(2)) &
						  select_a(1) & (not(select_a(1) and select_a(0)) and select_a(0));
						  
	select_b_1hot <= select_b(15) & (not(select_b(15) and select_b(14)) and select_b(14)) &
						  select_b(13) & (not(select_b(13) and select_b(12)) and select_b(12)) &
						  select_b(11) & (not(select_b(11) and select_b(10)) and select_b(10)) &
						  select_b(9) & (not(select_b(9) and select_b(8)) and select_b(8)) &
						  select_b(7) & (not(select_b(7) and select_b(6)) and select_b(6)) &
						  select_b(5) & (not(select_b(5) and select_b(4)) and select_b(4)) &
						  select_b(3) & (not(select_b(3) and select_b(2)) and select_b(2)) &
						  select_b(1) & (not(select_b(1) and select_b(0)) and select_b(0));
						  
	select_c_1hot <= select_c(15) & (not(select_c(15) and select_c(14)) and select_c(14)) &
						  select_c(13) & (not(select_c(13) and select_c(12)) and select_c(12)) &
						  select_c(11) & (not(select_c(11) and select_c(10)) and select_c(10)) &
						  select_c(9) & (not(select_c(9) and select_c(8)) and select_c(8)) &
						  select_c(7) & (not(select_c(7) and select_c(6)) and select_c(6)) &
						  select_c(5) & (not(select_c(5) and select_c(4)) and select_c(4)) &
						  select_c(3) & (not(select_c(3) and select_c(2)) and select_c(2)) &
						  select_c(1) & (not(select_c(1) and select_c(0)) and select_c(0));
						
	select_0_1hot <= select_0(15) & (not(select_0(15) and select_0(14)) and select_0(14)) &
						  select_0(13) & (not(select_0(13) and select_0(12)) and select_0(12)) &
						  select_0(11) & (not(select_0(11) and select_0(10)) and select_0(10)) &
						  select_0(9) & (not(select_0(9) and select_0(8)) and select_0(8)) &
						  select_0(7) & (not(select_0(7) and select_0(6)) and select_0(6)) &
						  select_0(5) & (not(select_0(5) and select_0(4)) and select_0(4)) &
						  select_0(3) & (not(select_0(3) and select_0(2)) and select_0(2)) &
						  select_0(1) & (not(select_0(1) and select_0(0)) and select_0(0));
						  
	select_1_1hot <= select_1(15) & (not(select_1(15) and select_1(14)) and select_1(14)) &
						  select_1(13) & (not(select_1(13) and select_1(12)) and select_1(12)) &
						  select_1(11) & (not(select_1(11) and select_1(10)) and select_1(10)) &
						  select_1(9) & (not(select_1(9) and select_1(8)) and select_1(8)) &
						  select_1(7) & (not(select_1(7) and select_1(6)) and select_1(6)) &
						  select_1(5) & (not(select_1(5) and select_1(4)) and select_1(4)) &
						  select_1(3) & (not(select_1(3) and select_1(2)) and select_1(2)) &
						  select_1(1) & (not(select_1(1) and select_1(0)) and select_1(0));
					
	route_a : ROUTE_SIGNAL_global PORT MAP (
												ram_0_out_a => ram_0_out_a,
												ram_0_out_b => ram_0_out_b,
												ram_1_out_a => ram_1_out_a,
												ram_1_out_b => ram_1_out_b,
												ram_2_out_a => ram_2_out_a,
												ram_2_out_b => ram_2_out_b,
												ram_3_out_a => ram_3_out_a,
												ram_3_out_b => ram_3_out_b,
												ram_4_out_a => ram_4_out_a,
												ram_4_out_b => ram_4_out_b,
												ram_5_out_a => ram_5_out_a,
												ram_5_out_b => ram_5_out_b,
												ram_6_out_a => ram_6_out_a,
												ram_6_out_b => ram_6_out_b,
												ram_7_out_a => ram_7_out_a,
												ram_7_out_b => ram_7_out_b,
												select_vector => select_a_1hot,
												hazard => hazard,
												hazard_advanced => hazard_advanced,
												CLK => CLK,
												RESET_n => RESET_n,
												OUTPUT => OUTPUT_A
												);
	
	route_b : ROUTE_SIGNAL_global PORT MAP (
												ram_0_out_a => ram_0_out_a,
												ram_0_out_b => ram_0_out_b,
												ram_1_out_a => ram_1_out_a,
												ram_1_out_b => ram_1_out_b,
												ram_2_out_a => ram_2_out_a,
												ram_2_out_b => ram_2_out_b,
												ram_3_out_a => ram_3_out_a,
												ram_3_out_b => ram_3_out_b,
												ram_4_out_a => ram_4_out_a,
												ram_4_out_b => ram_4_out_b,
												ram_5_out_a => ram_5_out_a,
												ram_5_out_b => ram_5_out_b,
												ram_6_out_a => ram_6_out_a,
												ram_6_out_b => ram_6_out_b,
												ram_7_out_a => ram_7_out_a,
												ram_7_out_b => ram_7_out_b,
												select_vector => select_b_1hot,
												hazard => hazard,
												hazard_advanced => hazard_advanced,
												CLK => CLK,
												RESET_n => RESET_n,
												OUTPUT => OUTPUT_B
												);
												
	route_c : ROUTE_SIGNAL_global PORT MAP (
												ram_0_out_a => ram_0_out_a,
												ram_0_out_b => ram_0_out_b,
												ram_1_out_a => ram_1_out_a,
												ram_1_out_b => ram_1_out_b,
												ram_2_out_a => ram_2_out_a,
												ram_2_out_b => ram_2_out_b,
												ram_3_out_a => ram_3_out_a,
												ram_3_out_b => ram_3_out_b,
												ram_4_out_a => ram_4_out_a,
												ram_4_out_b => ram_4_out_b,
												ram_5_out_a => ram_5_out_a,
												ram_5_out_b => ram_5_out_b,
												ram_6_out_a => ram_6_out_a,
												ram_6_out_b => ram_6_out_b,
												ram_7_out_a => ram_7_out_a,
												ram_7_out_b => ram_7_out_b,
												select_vector => select_c_1hot,
												hazard => hazard,
												hazard_advanced => hazard_advanced,
												CLK => CLK,
												RESET_n => RESET_n,
												OUTPUT => OUTPUT_C
												);
												
	route_0 : ROUTE_SIGNAL_global PORT MAP (
												ram_0_out_a => ram_0_out_a,
												ram_0_out_b => ram_0_out_b,
												ram_1_out_a => ram_1_out_a,
												ram_1_out_b => ram_1_out_b,
												ram_2_out_a => ram_2_out_a,
												ram_2_out_b => ram_2_out_b,
												ram_3_out_a => ram_3_out_a,
												ram_3_out_b => ram_3_out_b,
												ram_4_out_a => ram_4_out_a,
												ram_4_out_b => ram_4_out_b,
												ram_5_out_a => ram_5_out_a,
												ram_5_out_b => ram_5_out_b,
												ram_6_out_a => ram_6_out_a,
												ram_6_out_b => ram_6_out_b,
												ram_7_out_a => ram_7_out_a,
												ram_7_out_b => ram_7_out_b,
												select_vector => select_0_1hot,
												hazard => hazard,
												hazard_advanced => hazard_advanced,
												CLK => CLK,
												RESET_n => RESET_n,
												OUTPUT => OUTPUT_0
												);
												
	route_1 : ROUTE_SIGNAL_global PORT MAP (
												ram_0_out_a => ram_0_out_a,
												ram_0_out_b => ram_0_out_b,
												ram_1_out_a => ram_1_out_a,
												ram_1_out_b => ram_1_out_b,
												ram_2_out_a => ram_2_out_a,
												ram_2_out_b => ram_2_out_b,
												ram_3_out_a => ram_3_out_a,
												ram_3_out_b => ram_3_out_b,
												ram_4_out_a => ram_4_out_a,
												ram_4_out_b => ram_4_out_b,
												ram_5_out_a => ram_5_out_a,
												ram_5_out_b => ram_5_out_b,
												ram_6_out_a => ram_6_out_a,
												ram_6_out_b => ram_6_out_b,
												ram_7_out_a => ram_7_out_a,
												ram_7_out_b => ram_7_out_b,
												select_vector => select_1_1hot,
												hazard => hazard,
												hazard_advanced => hazard_advanced,
												CLK => CLK,
												RESET_n => RESET_n,
												OUTPUT => OUTPUT_1
												);
end;