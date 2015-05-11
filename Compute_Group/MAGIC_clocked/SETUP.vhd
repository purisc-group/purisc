library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SETUP is
	PORT(
			CLK : IN STD_LOGIC;
			ADDRESS_A  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_B  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_C  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_W  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			W_EN		  : IN STD_LOGIC;
			RESET_n    : IN STD_LOGIC;
			STALL			: OUT STD_LOGIC;
			HAZARD 		: IN STD_LOGIC;
			ram_0_port_a : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_0_port_b : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_0_wren_a : OUT STD_LOGIC;
			ram_0_wren_b : OUT STD_LOGIC;
			ram_1_port_a : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_1_port_b : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_1_wren_a : OUT STD_LOGIC;
			ram_1_wren_b : OUT STD_LOGIC;
			ram_2_port_a : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_2_port_b : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_2_wren_a : OUT STD_LOGIC;
			ram_2_wren_b : OUT STD_LOGIC;
			ram_3_port_a : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_3_port_b : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_3_wren_a : OUT STD_LOGIC;
			ram_3_wren_b : OUT STD_LOGIC;
			ram_4_port_a : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_4_port_b : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_4_wren_a : OUT STD_LOGIC;
			ram_4_wren_b : OUT STD_LOGIC;
			ram_5_port_a : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_5_port_b : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_5_wren_a : OUT STD_LOGIC;
			ram_5_wren_b : OUT STD_LOGIC;
			ram_6_port_a : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_6_port_b : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_6_wren_a : OUT STD_LOGIC;
			ram_6_wren_b : OUT STD_LOGIC;
			ram_7_port_a : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_7_port_b : OUT STD_LOGIC_VECTOR (9 downto 0);
			ram_7_wren_a : OUT STD_LOGIC;
			ram_7_wren_b : OUT STD_LOGIC;
			ram_0_sel_vector : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			ram_1_sel_vector : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			ram_2_sel_vector : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			ram_3_sel_vector : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			ram_4_sel_vector : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			ram_5_sel_vector : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			ram_6_sel_vector : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			ram_7_sel_vector : OUT STD_LOGIC_VECTOR (9 DOWNTO 0)
			);
end;

architecture control of SETUP is

	component address_transcode
		PORT (
			ADDRESS 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ROW		: OUT STD_LOGIC_VECTOR (9 downto 0);
			COL		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
			);
	end component; 
	
	component create_opcode
		PORT (
			COL_A		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_B		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_C		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_D		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_E		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			COL_W		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			W_EN		: IN STD_LOGIC;
			OPCODE_0	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_1	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_2	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_3	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_4	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_5	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_6	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_7	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
			);
	end component;
	
	component FLOW
		PORT(
			CLK : IN STD_LOGIC;
			RESET_n : IN STD_LOGIC;
			OPCODE : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			ROW_A : IN STD_LOGIC_VECTOR(9 downto 0);
			ROW_B : IN STD_LOGIC_VECTOR(9 downto 0);
			ROW_C : IN STD_LOGIC_VECTOR(9 downto 0);
			ROW_D : IN STD_LOGIC_VECTOR(9 downto 0);
			ROW_E : IN STD_LOGIC_VECTOR(9 downto 0);
			ROW_W : IN STD_LOGIC_VECTOR(9 downto 0);
			HAZARD : IN STD_LOGIC;
			EQUALITY : OUT STD_LOGIC;
			ADDRESS_A : OUT STD_LOGIC_VECTOR(9 downto 0);
			ADDRESS_B : OUT STD_LOGIC_VECTOR(9 downto 0);
			SEL_VECTOR : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
			WREN_A : OUT STD_LOGIC;
			WREN_B : OUT STD_LOGIC
			);
	end component;
	
	signal COL_A : std_logic_vector (2 downto 0);
	signal COL_B : std_logic_vector (2 downto 0);
	signal COL_C : std_logic_vector (2 downto 0);
	signal COL_D : std_logic_vector (2 downto 0);
	signal COL_E : std_logic_vector (2 downto 0);
	signal COL_W : std_logic_vector (2 downto 0);
	signal ROW_A : std_logic_vector (9 downto 0);
	signal ROW_B : std_logic_vector (9 downto 0);
	signal ROW_C : std_logic_vector (9 downto 0);
	signal ROW_D : std_logic_vector (9 downto 0);
	signal ROW_E : std_logic_vector (9 downto 0);
	signal ROW_W : std_logic_vector (9 downto 0);
	signal OPCODE_0 : std_logic_vector (5 downto 0);
	signal OPCODE_1 : std_logic_vector (5 downto 0);
	signal OPCODE_2 : std_logic_vector (5 downto 0);
	signal OPCODE_3 : std_logic_vector (5 downto 0);
	signal OPCODE_4 : std_logic_vector (5 downto 0);
	signal OPCODE_5 : std_logic_vector (5 downto 0);
	signal OPCODE_6 : std_logic_vector (5 downto 0);
	signal OPCODE_7 : std_logic_vector (5 downto 0);
	signal equality_0 : std_logic;
	signal equality_1 : std_logic;
	signal equality_2 : std_logic;
	signal equality_3 : std_logic;
	signal equality_4 : std_logic;
	signal equality_5 : std_logic;
	signal equality_6 : std_logic;
	signal equality_7 : std_logic;
	
begin

	transcode_a : address_transcode PORT MAP (
															ADDRESS => ADDRESS_A,
															ROW => ROW_A,
															COL => COL_A
															);
	transcode_b : address_transcode PORT MAP (
															ADDRESS => ADDRESS_B,
															ROW => ROW_B,
															COL => COL_B
															);
	transcode_c : address_transcode PORT MAP (
															ADDRESS => ADDRESS_C,
															ROW => ROW_C,
															COL => COL_C
															);
	transcode_d : address_transcode PORT MAP (
															ADDRESS => ADDRESS_0,
															ROW => ROW_D,
															COL => COL_D
															);
	transcode_e : address_transcode PORT MAP (
															ADDRESS => ADDRESS_1,
															ROW => ROW_E,
															COL => COL_E
															);
	transcode_w : address_transcode PORT MAP (
															ADDRESS => ADDRESS_W,
															ROW => ROW_W,
															COL => COL_W
															);
	opcodery : create_opcode PORT MAP (
													COL_A => COL_A,
													COL_B => COL_B,
													COL_C => COL_C,
													COL_D => COL_D,
													COL_E => COL_E,
													COL_W => COL_W,
													W_EN => W_EN,
													OPCODE_0 => OPCODE_0,
													OPCODE_1 => OPCODE_1,
													OPCODE_2 => OPCODE_2,
													OPCODE_3 => OPCODE_3,
													OPCODE_4 => OPCODE_4,
													OPCODE_5 => OPCODE_5,
													OPCODE_6 => OPCODE_6,
													OPCODE_7 => OPCODE_7
												);
			
	RAM_0_CONTROL : FLOW PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												OPCODE => OPCODE_0,
												ROW_A => std_logic_vector(ROW_A),
												ROW_B => std_logic_vector(ROW_B),
												ROW_C => std_logic_vector(ROW_C),
												ROW_D => std_logic_vector(ROW_D),
												ROW_E => std_logic_vector(ROW_E),
												ROW_W => std_logic_vector(ROW_W),
												HAZARD => HAZARD,
												EQUALITY => equality_0,
												ADDRESS_A => ram_0_port_a,
												ADDRESS_B => ram_0_port_b,
												SEL_VECTOR => ram_0_sel_vector,
												WREN_A => ram_0_wren_a,
												WREN_B => ram_0_wren_b
											);
											
	RAM_1_CONTROL : FLOW PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												OPCODE => OPCODE_1,
												ROW_A => std_logic_vector(ROW_A),
												ROW_B => std_logic_vector(ROW_B),
												ROW_C => std_logic_vector(ROW_C),
												ROW_D => std_logic_vector(ROW_D),
												ROW_E => std_logic_vector(ROW_E),
												ROW_W => std_logic_vector(ROW_W),
												HAZARD => HAZARD,
												EQUALITY => equality_1,
												ADDRESS_A => ram_1_port_a,
												ADDRESS_B => ram_1_port_b,
												SEL_VECTOR => ram_1_sel_vector,
												WREN_A => ram_1_wren_a,
												WREN_B => ram_1_wren_b
											);
											
	RAM_2_CONTROL : FLOW PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												OPCODE => OPCODE_2,
												ROW_A => std_logic_vector(ROW_A),
												ROW_B => std_logic_vector(ROW_B),
												ROW_C => std_logic_vector(ROW_C),
												ROW_D => std_logic_vector(ROW_D),
												ROW_E => std_logic_vector(ROW_E),
												ROW_W => std_logic_vector(ROW_W),
												HAZARD => HAZARD,
												EQUALITY => equality_2,
												ADDRESS_A => ram_2_port_a,
												ADDRESS_B => ram_2_port_b,
												SEL_VECTOR => ram_2_sel_vector,
												WREN_A => ram_2_wren_a,
												WREN_B => ram_2_wren_b
											);
											
	RAM_3_CONTROL : FLOW PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												OPCODE => OPCODE_3,
												ROW_A => std_logic_vector(ROW_A),
												ROW_B => std_logic_vector(ROW_B),
												ROW_C => std_logic_vector(ROW_C),
												ROW_D => std_logic_vector(ROW_D),
												ROW_E => std_logic_vector(ROW_E),
												ROW_W => std_logic_vector(ROW_W),
												HAZARD => HAZARD,
												EQUALITY => equality_3,
												ADDRESS_A => ram_3_port_a,
												ADDRESS_B => ram_3_port_b,
												SEL_VECTOR => ram_3_sel_vector,
												WREN_A => ram_3_wren_a,
												WREN_B => ram_3_wren_b
											);
											
	RAM_4_CONTROL : FLOW PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												OPCODE => OPCODE_4,
												ROW_A => std_logic_vector(ROW_A),
												ROW_B => std_logic_vector(ROW_B),
												ROW_C => std_logic_vector(ROW_C),
												ROW_D => std_logic_vector(ROW_D),
												ROW_E => std_logic_vector(ROW_E),
												ROW_W => std_logic_vector(ROW_W),
												HAZARD => HAZARD,
												EQUALITY => equality_4,
												ADDRESS_A => ram_4_port_a,
												ADDRESS_B => ram_4_port_b,
												SEL_VECTOR => ram_4_sel_vector,
												WREN_A => ram_4_wren_a,
												WREN_B => ram_4_wren_b
											);
											
	RAM_5_CONTROL : FLOW PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												OPCODE => OPCODE_5,
												ROW_A => std_logic_vector(ROW_A),
												ROW_B => std_logic_vector(ROW_B),
												ROW_C => std_logic_vector(ROW_C),
												ROW_D => std_logic_vector(ROW_D),
												ROW_E => std_logic_vector(ROW_E),
												ROW_W => std_logic_vector(ROW_W),
												HAZARD => HAZARD,
												EQUALITY => equality_5,
												ADDRESS_A => ram_5_port_a,
												ADDRESS_B => ram_5_port_b,
												SEL_VECTOR => ram_5_sel_vector,
												WREN_A => ram_5_wren_a,
												WREN_B => ram_5_wren_b
											);
	RAM_6_CONTROL : FLOW PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												OPCODE => OPCODE_6,
												ROW_A => std_logic_vector(ROW_A),
												ROW_B => std_logic_vector(ROW_B),
												ROW_C => std_logic_vector(ROW_C),
												ROW_D => std_logic_vector(ROW_D),
												ROW_E => std_logic_vector(ROW_E),
												ROW_W => std_logic_vector(ROW_W),
												HAZARD => HAZARD,
												EQUALITY => equality_6,
												ADDRESS_A => ram_6_port_a,
												ADDRESS_B => ram_6_port_b,
												SEL_VECTOR => ram_6_sel_vector,
												WREN_A => ram_6_wren_a,
												WREN_B => ram_6_wren_b
											);
											
	RAM_7_CONTROL : FLOW PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												OPCODE => OPCODE_7,
												ROW_A => std_logic_vector(ROW_A),
												ROW_B => std_logic_vector(ROW_B),
												ROW_C => std_logic_vector(ROW_C),
												ROW_D => std_logic_vector(ROW_D),
												ROW_E => std_logic_vector(ROW_E),
												ROW_W => std_logic_vector(ROW_W),
												HAZARD => HAZARD,
												EQUALITY => equality_7,
												ADDRESS_A => ram_7_port_a,
												ADDRESS_B => ram_7_port_b,
												SEL_VECTOR => ram_7_sel_vector,
												WREN_A => ram_7_wren_a,
												WREN_B => ram_7_wren_b
											);
											
	STALL <= not (equality_0 and equality_1 and equality_2 and equality_3 and equality_4 and equality_5 and equality_6 and equality_7);
												
end;
															

	