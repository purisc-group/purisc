library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM_ARRAY is
	PORT (
			CLK 		: IN STD_LOGIC;
			RESET_n 	: IN STD_LOGIC;
			--READ REQUEST 1
			ROW_A		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
			--READ REQUEST 2
			ROW_B		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
			--READ REQUEST 3
			ROW_C		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
			--READ REQUEST 4
			ROW_D		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
			--READ REQUEST 5
			ROW_E		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
			--OUTPUTS OF READS
			OUTPUT_A : OUT STD_LOGIC_VECTOR (64 DOWNTO 0);
			OUTPUT_B : OUT STD_LOGIC_VECTOR (64 DOWNTO 0);
			OUTPUT_C : OUT STD_LOGIC_VECTOR (64 DOWNTO 0);
			OUTPUT_D : OUT STD_LOGIC_VECTOR (64 DOWNTO 0);
			OUTPUT_E : OUT STD_LOGIC_VECTOR (64 DOWNTO 0);
			--WRITE REQUEST
			ADDR_W	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ROW_W		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
			--WRITE DATA
			INPUT_W  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			--WRITE ENABLE 
			W_EN		: IN STD_LOGIC;
			--OPCODES
			OPCODE_0_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			OPCODE_1_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			OPCODE_2_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			OPCODE_3_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			OPCODE_4_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			OPCODE_5_IN : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			--STALLING
			WAIT_FLAG : OUT STD_LOGIC;
			STALL_0_OUT : OUT STD_LOGIC;
			STALL_1_OUT : OUT STD_LOGIC;
			STALL_2_OUT : OUT STD_LOGIC;
			STALL_3_OUT : OUT STD_LOGIC;
			STALL_4_OUT : OUT STD_LOGIC;
			STALL_5_OUT : OUT STD_LOGIC;
			OP_0_RET : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			OP_1_RET : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			OP_2_RET : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			OP_3_RET : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			OP_4_RET : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			OP_5_RET : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
			);
end RAM_ARRAY;

architecture ram_connect of RAM_ARRAY is			
		
	signal OUT_A_SIG	 : std_logic_vector (64 downto 0);
	signal OUT_B_SIG	 : std_logic_vector (64 downto 0);
	signal OUT_C_SIG	 : std_logic_vector (64 downto 0);
	signal OUT_D_SIG	 : std_logic_vector (64 downto 0);
	signal OUT_E_SIG	 : std_logic_vector (64 downto 0);
	
	signal ram_0_out_0 : std_logic_vector (64 downto 0);
	signal ram_0_out_1 : std_logic_vector (64 downto 0);
	signal ram_1_out_0 : std_logic_vector (64 downto 0);
	signal ram_1_out_1 : std_logic_vector (64 downto 0);
	signal ram_2_out_0 : std_logic_vector (64 downto 0);
	signal ram_2_out_1 : std_logic_vector (64 downto 0);
	signal ram_3_out_0 : std_logic_vector (64 downto 0);
	signal ram_3_out_1 : std_logic_vector (64 downto 0);
	signal ram_4_out_0 : std_logic_vector (64 downto 0);
	signal ram_4_out_1 : std_logic_vector (64 downto 0);
	signal ram_5_out_0 : std_logic_vector (64 downto 0);
	signal ram_5_out_1 : std_logic_vector (64 downto 0);
	signal stall_0		 : std_logic;
	signal stall_1		 : std_logic;
	signal stall_2		 : std_logic;
	signal stall_3		 : std_logic;
	signal stall_4		 : std_logic;
	signal stall_5		 : std_logic;
	signal op_0_out	 : std_logic_vector (5 downto 0);
	signal op_1_out	 : std_logic_vector (5 downto 0);
	signal op_2_out	 : std_logic_vector (5 downto 0);
	signal op_3_out	 : std_logic_vector (5 downto 0);
	signal op_4_out	 : std_logic_vector (5 downto 0);
	signal op_5_out	 : std_logic_vector (5 downto 0);
	
	signal sel_B_0 : std_logic;
	signal sel_C_0 : std_logic;
	signal sel_D_0 : std_logic;
	signal sel_E_0 : std_logic;
	signal sel_B_1 : std_logic;
	signal sel_C_1 : std_logic;
	signal sel_D_1 : std_logic;
	signal sel_E_1 : std_logic;
	signal sel_B_2 : std_logic;
	signal sel_C_2 : std_logic;
	signal sel_D_2 : std_logic;
	signal sel_E_2 : std_logic;
	signal sel_B_3 : std_logic;
	signal sel_C_3 : std_logic;
	signal sel_D_3 : std_logic;
	signal sel_E_3 : std_logic;
	signal sel_B_4 : std_logic;
	signal sel_C_4 : std_logic;
	signal sel_D_4 : std_logic;
	signal sel_E_4 : std_logic;
	signal sel_B_5 : std_logic;
	signal sel_C_5 : std_logic;
	signal sel_D_5 : std_logic;
	signal sel_E_5 : std_logic;
	
	signal sel_A00 : std_logic;
	signal sel_A01 : std_logic;
	signal sel_A10 : std_logic;
	signal sel_A11 : std_logic;
	signal sel_A20 : std_logic;
	signal sel_A21 : std_logic;
	signal sel_A30 : std_logic;
	signal sel_A31 : std_logic;
	signal sel_A40 : std_logic;
	signal sel_A41 : std_logic;
	signal sel_A50 : std_logic;
	signal sel_A51 : std_logic;
	
	signal sel_B00 : std_logic;
	signal sel_B01 : std_logic;
	signal sel_B10 : std_logic;
	signal sel_B11 : std_logic;
	signal sel_B20 : std_logic;
	signal sel_B21 : std_logic;
	signal sel_B30 : std_logic;
	signal sel_B31 : std_logic;
	signal sel_B40 : std_logic;
	signal sel_B41 : std_logic;
	signal sel_B50 : std_logic;
	signal sel_B51 : std_logic;
	
	signal sel_C00 : std_logic;
	signal sel_C01 : std_logic;
	signal sel_C10 : std_logic;
	signal sel_C11 : std_logic;
	signal sel_C20 : std_logic;
	signal sel_C21 : std_logic;
	signal sel_C30 : std_logic;
	signal sel_C31 : std_logic;
	signal sel_C40 : std_logic;
	signal sel_C41 : std_logic;
	signal sel_C50 : std_logic;
	signal sel_C51 : std_logic;
	
	signal sel_D00 : std_logic;
	signal sel_D01 : std_logic;
	signal sel_D10 : std_logic;
	signal sel_D11 : std_logic;
	signal sel_D20 : std_logic;
	signal sel_D21 : std_logic;
	signal sel_D30 : std_logic;
	signal sel_D31 : std_logic;
	signal sel_D40 : std_logic;
	signal sel_D41 : std_logic;
	signal sel_D50 : std_logic;
	signal sel_D51 : std_logic;
	
	signal sel_E00 : std_logic;
	signal sel_E01 : std_logic;
	signal sel_E10 : std_logic;
	signal sel_E11 : std_logic;
	signal sel_E20 : std_logic;
	signal sel_E21 : std_logic;
	signal sel_E30 : std_logic;
	signal sel_E31 : std_logic;
	signal sel_E40 : std_logic;
	signal sel_E41 : std_logic;
	signal sel_E50 : std_logic;
	signal sel_E51 : std_logic;
	
	signal serviced_0 : std_logic_vector (5 downto 0);
	signal serviced_1 : std_logic_vector (5 downto 0);
	signal serviced_2 : std_logic_vector (5 downto 0);
	signal serviced_3 : std_logic_vector (5 downto 0);
	signal serviced_4 : std_logic_vector (5 downto 0);
	signal serviced_5 : std_logic_vector (5 downto 0);
	
	signal control_A : std_logic_vector (5 downto 0);
	signal control_B : std_logic_vector (5 downto 0);
	signal control_C : std_logic_vector (5 downto 0);
	signal control_D : std_logic_vector (5 downto 0);
	signal control_E : std_logic_vector (5 downto 0);
	
	
	component RAMS
		PORT (
				clock_base 		: IN STD_LOGIC;
				RESET_n 	: IN STD_LOGIC;
				--READ REQUEST 1
				ROW_A		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
				--READ REQUEST 2
				ROW_B		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
				--READ REQUEST 3
				ROW_C		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
				--READ REQUEST 4
				ROW_D		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
				--READ REQUEST 5
				ROW_E		: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
				--OUTPUTS OF READS
				OUTPUT_0 : OUT STD_LOGIC_VECTOR (64 DOWNTO 0);
				OUTPUT_1 : OUT STD_LOGIC_VECTOR (64 DOWNTO 0);
				--WRITE REQUEST
				ADDR_W	: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				ROW_W		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
				--WRITE DATA
				INPUT_W  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				--WRITE ENABLE 
				W_EN		: IN STD_LOGIC;
				--STALL FLAG
				STALL		: OUT STD_LOGIC;
				--OPCODES
				OPCODE : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
				OPCODE_RET : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
				--some select outputs 
				SEL_B	: OUT STD_LOGIC;
				SEL_C : OUT STD_LOGIC;
				SEL_D : OUT STD_LOGIC;
				SEL_E : OUT STD_LOGIC
				);
	end component;
	
	component tristate_64
		PORT(
				my_in : in std_logic_vector(64 downto 0);
				sel :   in std_logic;
				my_out : out std_logic_vector(64 downto 0)
				);
	end component;
	
	begin
	
		RAM_0 : RAMS PORT MAP (
											 clock_base => CLK,
											 RESET_n => RESET_n,
											 ROW_A => ROW_A,
											 ROW_B => ROW_B,
											 ROW_C => ROW_C,
											 ROW_D => ROW_D,
											 ROW_E => ROW_E,
											 ROW_W => ROW_W,
											 OUTPUT_0 => ram_0_out_0,
											 OUTPUT_1 => ram_0_out_1,
											 ADDR_W => ADDR_W,
											 INPUT_W => INPUT_W,
											 W_EN => W_EN,
											 STALL => stall_0,
											 OPCODE => OPCODE_0_IN,
											 OPCODE_RET => op_0_out,
											 SEL_B => SEL_B_0,
											 SEL_C => SEL_C_0,
											 SEL_D => SEL_D_0,
											 SEL_E => SEL_E_0
											 );
		RAM_1 : RAMS PORT MAP (
											 clock_base => CLK,
											 RESET_n => RESET_n,
											 ROW_A => ROW_A,
											 ROW_B => ROW_B,
											 ROW_C => ROW_C,
											 ROW_D => ROW_D,
											 ROW_E => ROW_E,
											 ROW_W => ROW_W,
											 OUTPUT_0 => ram_1_out_0,
											 OUTPUT_1 => ram_1_out_1,
											 ADDR_W => ADDR_W,
											 INPUT_W => INPUT_W,
											 W_EN => W_EN,
											 STALL => stall_1,
											 OPCODE => OPCODE_1_IN,
											 OPCODE_RET => op_1_out,
											 SEL_B => SEL_B_1,
											 SEL_C => SEL_C_1,
											 SEL_D => SEL_D_1,
											 SEL_E => SEL_E_1
											 );
		RAM_2 : RAMS PORT MAP (
											 clock_base => CLK,
											 RESET_n => RESET_n,
											 ROW_A => ROW_A,
											 ROW_B => ROW_B,
											 ROW_C => ROW_C,
											 ROW_D => ROW_D,
											 ROW_E => ROW_E,
											 ROW_W => ROW_W,
											 OUTPUT_0 => ram_2_out_0,
											 OUTPUT_1 => ram_2_out_1,
											 ADDR_W => ADDR_W,
											 INPUT_W => INPUT_W,
											 W_EN => W_EN,
											 STALL => stall_2,
											 OPCODE => OPCODE_2_IN,
											 OPCODE_RET => op_2_out,
											 SEL_B => SEL_B_2,
											 SEL_C => SEL_C_2,
											 SEL_D => SEL_D_2,
											 SEL_E => SEL_E_2
											 );
		RAM_3 : RAMS PORT MAP (
											 clock_base => CLK,
											 RESET_n => RESET_n,
											 ROW_A => ROW_A,
											 ROW_B => ROW_B,
											 ROW_C => ROW_C,
											 ROW_D => ROW_D,
											 ROW_E => ROW_E,
											 ROW_W => ROW_W,
											 OUTPUT_0 => ram_3_out_0,
											 OUTPUT_1 => ram_3_out_1,
											 ADDR_W => ADDR_W,
											 INPUT_W => INPUT_W,
											 W_EN => W_EN,
											 STALL => stall_3,
											 OPCODE => OPCODE_3_IN,
											 OPCODE_RET => op_3_out,
											 SEL_B => SEL_B_3,
											 SEL_C => SEL_C_3,
											 SEL_D => SEL_D_3,
											 SEL_E => SEL_E_3
											 );
		RAM_4 : RAMS PORT MAP (
											 clock_base => CLK,
											 RESET_n => RESET_n,
											 ROW_A => ROW_A,
											 ROW_B => ROW_B,
											 ROW_C => ROW_C,
											 ROW_D => ROW_D,
											 ROW_E => ROW_E,
											 ROW_W => ROW_W,
											 OUTPUT_0 => ram_4_out_0,
											 OUTPUT_1 => ram_4_out_1,
											 ADDR_W => ADDR_W,
											 INPUT_W => INPUT_W,
											 W_EN => W_EN,
											 STALL => stall_4,
											 OPCODE => OPCODE_4_IN,
											 OPCODE_RET => op_4_out,
											 SEL_B => SEL_B_4,
											 SEL_C => SEL_C_4,
											 SEL_D => SEL_D_4,
											 SEL_E => SEL_E_4
											 );
		RAM_5 : RAMS PORT MAP (
											 clock_base => CLK,
											 RESET_n => RESET_n,
											 ROW_A => ROW_A,
											 ROW_B => ROW_B,
											 ROW_C => ROW_C,
											 ROW_D => ROW_D,
											 ROW_E => ROW_E,
											 ROW_W => ROW_W,
											 OUTPUT_0 => ram_5_out_0,
											 OUTPUT_1 => ram_5_out_1,
											 ADDR_W => ADDR_W,
											 INPUT_W => INPUT_W,
											 W_EN => W_EN,
											 STALL => stall_5,
											 OPCODE => OPCODE_5_IN,
											 OPCODE_RET => op_5_out,
											 SEL_B => SEL_B_5,
											 SEL_C => SEL_C_5,
											 SEL_D => SEL_D_5,
											 SEL_E => SEL_E_5
											 );
											 
		flow_A00 : tristate_64 PORT MAP (
												my_in => ram_0_out_0,
												sel => control_a(5),
												my_out => OUT_A_SIG
												);
		flow_A10 : tristate_64 PORT MAP (
												my_in => ram_1_out_0,
												sel => control_a(4),
												my_out => OUT_A_SIG
												);
		flow_A20 : tristate_64 PORT MAP (
												my_in => ram_2_out_0,
												sel => control_a(3),
												my_out => OUT_A_SIG
												);
		flow_A30 : tristate_64 PORT MAP (
												my_in => ram_3_out_0,
												sel => control_a(2),
												my_out => OUT_A_SIG
												);
		flow_A40 : tristate_64 PORT MAP (
												my_in => ram_4_out_0,
												sel => control_a(1),
												my_out => OUT_A_SIG
												);
		flow_A50 : tristate_64 PORT MAP (
												my_in => ram_5_out_0,
												sel => control_a(0),
												my_out => OUT_A_SIG
												);
		---------------------------------------------------------------------										
												
		flow_B00 : tristate_64 PORT MAP (
												my_in => ram_0_out_0,
												sel => sel_B00,
												my_out => OUT_B_SIG
												);
		flow_B01 : tristate_64 PORT MAP (
												my_in => ram_0_out_1,
												sel => sel_B01,
												my_out => OUT_B_SIG
												);
		flow_B10 : tristate_64 PORT MAP (
												my_in => ram_1_out_0,
												sel => sel_B10,
												my_out => OUT_B_SIG
												);
		flow_B11 : tristate_64 PORT MAP (
												my_in => ram_1_out_1,
												sel => sel_B11,
												my_out => OUT_B_SIG
												);
		flow_B20 : tristate_64 PORT MAP (
												my_in => ram_2_out_0,
												sel => sel_B20,
												my_out => OUT_B_SIG
												);
		flow_B21 : tristate_64 PORT MAP (
												my_in => ram_2_out_1,
												sel => sel_B21,
												my_out => OUT_B_SIG
												);
		flow_B30 : tristate_64 PORT MAP (
												my_in => ram_3_out_0,
												sel => sel_B30,
												my_out => OUT_B_SIG
												);
		flow_B31 : tristate_64 PORT MAP (
												my_in => ram_3_out_1,
												sel => sel_B31,
												my_out => OUT_B_SIG
												);
		flow_B40 : tristate_64 PORT MAP (
												my_in => ram_4_out_0,
												sel => sel_B40,
												my_out => OUT_B_SIG
												);
		flow_B41 : tristate_64 PORT MAP (
												my_in => ram_4_out_1,
												sel => sel_B41,
												my_out => OUT_B_SIG
												);
		flow_B50 : tristate_64 PORT MAP (
												my_in => ram_5_out_0,
												sel => sel_B50,
												my_out => OUT_B_SIG
												);
		flow_B51 : tristate_64 PORT MAP (
												my_in => ram_5_out_1,
												sel => sel_B51,
												my_out => OUT_B_SIG
												);
	----------------------------------------------------------------
		flow_C00 : tristate_64 PORT MAP (
												my_in => ram_0_out_0,
												sel => sel_C00,
												my_out => OUT_C_SIG
												);
		flow_C01 : tristate_64 PORT MAP (
												my_in => ram_0_out_1,
												sel => sel_C01,
												my_out => OUT_C_SIG
												);
		flow_C10 : tristate_64 PORT MAP (
												my_in => ram_1_out_0,
												sel => sel_C10,
												my_out => OUT_C_SIG
												);
		flow_C11 : tristate_64 PORT MAP (
												my_in => ram_1_out_1,
												sel => sel_C11,
												my_out => OUT_C_SIG
												);
		flow_C20 : tristate_64 PORT MAP (
												my_in => ram_2_out_0,
												sel => sel_C20,
												my_out => OUT_C_SIG
												);
		flow_C21 : tristate_64 PORT MAP (
												my_in => ram_2_out_1,
												sel => sel_C21,
												my_out => OUT_C_SIG
												);
		flow_C30 : tristate_64 PORT MAP (
												my_in => ram_3_out_0,
												sel => sel_C30,
												my_out => OUT_C_SIG
												);
		flow_C31 : tristate_64 PORT MAP (
												my_in => ram_3_out_1,
												sel => sel_C31,
												my_out => OUT_C_SIG
												);
		flow_C40 : tristate_64 PORT MAP (
												my_in => ram_4_out_0,
												sel => sel_C40,
												my_out => OUT_C_SIG
												);
		flow_C41 : tristate_64 PORT MAP (
												my_in => ram_4_out_1,
												sel => sel_C41,
												my_out => OUT_C_SIG
												);
		flow_C50 : tristate_64 PORT MAP (
												my_in => ram_5_out_0,
												sel => sel_C50,
												my_out => OUT_C_SIG
												);
		flow_C51 : tristate_64 PORT MAP (
												my_in => ram_5_out_1,
												sel => sel_C51,
												my_out => OUT_C_SIG
												);
		------------------------------------------------------------------
		flow_D00 : tristate_64 PORT MAP (
												my_in => ram_0_out_0,
												sel => sel_D00,
												my_out => OUT_D_SIG
												);
		flow_D01 : tristate_64 PORT MAP (
												my_in => ram_0_out_1,
												sel => sel_D01,
												my_out => OUT_D_SIG
												);
		flow_D10 : tristate_64 PORT MAP (
												my_in => ram_1_out_0,
												sel => sel_D10,
												my_out => OUT_D_SIG
												);
		flow_D11 : tristate_64 PORT MAP (
												my_in => ram_1_out_1,
												sel => sel_D11,
												my_out => OUT_D_SIG
												);
		flow_D20 : tristate_64 PORT MAP (
												my_in => ram_2_out_0,
												sel => sel_D20,
												my_out => OUT_D_SIG
												);
		flow_D21 : tristate_64 PORT MAP (
												my_in => ram_2_out_1,
												sel => sel_D21,
												my_out => OUT_D_SIG
												);
		flow_D30 : tristate_64 PORT MAP (
												my_in => ram_3_out_0,
												sel => sel_D30,
												my_out => OUT_D_SIG
												);
		flow_D31 : tristate_64 PORT MAP (
												my_in => ram_3_out_1,
												sel => sel_D31,
												my_out => OUT_D_SIG
												);
		flow_D40 : tristate_64 PORT MAP (
												my_in => ram_4_out_0,
												sel => sel_D40,
												my_out => OUT_D_SIG
												);
		flow_D41 : tristate_64 PORT MAP (
												my_in => ram_4_out_1,
												sel => sel_D41,
												my_out => OUT_D_SIG
												);
		flow_D50 : tristate_64 PORT MAP (
												my_in => ram_5_out_0,
												sel => sel_D50,
												my_out => OUT_D_SIG
												);
		flow_D51 : tristate_64 PORT MAP (
												my_in => ram_5_out_1,
												sel => sel_D51,
												my_out => OUT_D_SIG
												);
		------------------------------------------------------------------
		flow_E00 : tristate_64 PORT MAP (
												my_in => ram_0_out_0,
												sel => sel_E00,
												my_out => OUT_E_SIG
												);
		flow_E01 : tristate_64 PORT MAP (
												my_in => ram_0_out_1,
												sel => sel_E01,
												my_out => OUT_E_SIG
												);
		flow_E10 : tristate_64 PORT MAP (
												my_in => ram_1_out_0,
												sel => sel_E10,
												my_out => OUT_E_SIG
												);
		flow_E11 : tristate_64 PORT MAP (
												my_in => ram_1_out_1,
												sel => sel_E11,
												my_out => OUT_E_SIG
												);
		flow_E20 : tristate_64 PORT MAP (
												my_in => ram_2_out_0,
												sel => sel_E20,
												my_out => OUT_E_SIG
												);
		flow_E21 : tristate_64 PORT MAP (
												my_in => ram_2_out_1,
												sel => sel_E21,
												my_out => OUT_E_SIG
												);
		flow_E30 : tristate_64 PORT MAP (
												my_in => ram_3_out_0,
												sel => sel_E30,
												my_out => OUT_E_SIG
												);
		flow_E31 : tristate_64 PORT MAP (
												my_in => ram_3_out_1,
												sel => sel_E31,
												my_out => OUT_E_SIG
												);
		flow_E40 : tristate_64 PORT MAP (
												my_in => ram_4_out_0,
												sel => sel_E40,
												my_out => OUT_E_SIG
												);
		flow_E41 : tristate_64 PORT MAP (
												my_in => ram_4_out_1,
												sel => sel_E41,
												my_out => OUT_E_SIG
												);
		flow_E50 : tristate_64 PORT MAP (
												my_in => ram_5_out_0,
												sel => sel_E50,
												my_out => OUT_E_SIG
												);
		flow_E51 : tristate_64 PORT MAP (
												my_in => ram_5_out_1,
												sel => sel_E51,
												my_out => OUT_E_SIG
												);

--******************************************
--output control logic
--******************************************
		sel_B00 <= control_b(5) and SEL_B_0;
		sel_B01 <= control_b(5) and not SEL_B_0;
		sel_B10 <= control_b(4) and SEL_B_1;
		sel_B11 <= control_b(4) and not SEL_B_1;
		sel_B20 <= control_b(3) and SEL_B_2;
		sel_B21 <= control_b(3) and not SEL_B_2;
		sel_B30 <= control_b(2) and SEL_B_3;
		sel_B31 <= control_b(2) and not SEL_B_3;
		sel_B40 <= control_b(1) and SEL_B_4;
		sel_B41 <= control_b(1) and not SEL_B_4;
		sel_B50 <= control_b(0) and SEL_B_5;
		sel_B51 <= control_b(0) and not SEL_B_5;
		
		sel_C00 <= control_c(5) and SEL_C_0;
		sel_C01 <= control_c(5) and not SEL_C_0;
		sel_C10 <= control_c(4) and SEL_C_1;
		sel_C11 <= control_c(4) and not SEL_C_1;
		sel_C20 <= control_c(3) and SEL_C_2;
		sel_C21 <= control_c(3) and not SEL_C_2;
		sel_C30 <= control_c(2) and SEL_C_3;
		sel_C31 <= control_c(2) and not SEL_C_3;
		sel_C40 <= control_c(1) and SEL_C_4;
		sel_C41 <= control_c(1) and not SEL_C_4;
		sel_C50 <= control_c(0) and SEL_C_5;
		sel_C51 <= control_c(0) and not SEL_C_5;
		
		sel_D00 <= control_d(5) and SEL_D_0;
		sel_D01 <= control_d(5) and not SEL_D_0;
		sel_D10 <= control_d(4) and SEL_D_1;
		sel_D11 <= control_d(4) and not SEL_D_1;
		sel_D20 <= control_d(3) and SEL_D_2;
		sel_D21 <= control_d(3) and not SEL_D_2;
		sel_D30 <= control_d(2) and SEL_D_3;
		sel_D31 <= control_d(2) and not SEL_D_3;
		sel_D40 <= control_d(1) and SEL_D_4;
		sel_D41 <= control_d(1) and not SEL_D_4;
		sel_D50 <= control_d(0) and SEL_D_5;
		sel_D51 <= control_d(0) and not SEL_D_5;
		
		sel_E00 <= control_e(5) and SEL_E_0;
		sel_E01 <= control_e(5) and not SEL_E_0;
		sel_E10 <= control_e(4) and SEL_E_1;
		sel_E11 <= control_e(4) and not SEL_E_1;
		sel_E20 <= control_e(3) and SEL_E_2;
		sel_E21 <= control_e(3) and not SEL_E_2;
		sel_E30 <= control_e(2) and SEL_E_3;
		sel_E31 <= control_e(2) and not SEL_E_3;
		sel_E40 <= control_e(1) and SEL_E_4;
		sel_E41 <= control_e(1) and not SEL_E_4;
		sel_E50 <= control_e(0) and SEL_E_5;
		sel_E51 <= control_e(0) and not SEL_E_5;
		
		serviced_0 <= OPCODE_0_IN xor op_0_out;
		serviced_1 <= OPCODE_1_IN xor op_1_out;
		serviced_2 <= OPCODE_2_IN xor op_2_out;
		serviced_3 <= OPCODE_3_IN xor op_3_out;
		serviced_4 <= OPCODE_4_IN xor op_4_out;
		serviced_5 <= OPCODE_5_IN xor op_5_out;
		
		control_a <= serviced_0(5)&serviced_1(5)&serviced_2(5)&serviced_3(5)&serviced_4(5)&serviced_5(5);
		control_b <= serviced_0(4)&serviced_1(4)&serviced_2(4)&serviced_3(4)&serviced_4(4)&serviced_5(4);
		control_c <= serviced_0(3)&serviced_1(3)&serviced_2(3)&serviced_3(3)&serviced_4(3)&serviced_5(3);
		control_d <= serviced_0(2)&serviced_1(2)&serviced_2(2)&serviced_3(2)&serviced_4(2)&serviced_5(2);
		control_e <= serviced_0(1)&serviced_1(1)&serviced_2(1)&serviced_3(1)&serviced_4(1)&serviced_5(1);
		
		WAIT_FLAG <= stall_0 or stall_1 or stall_2 or stall_3 or stall_4 or stall_5;
		
		STALL_0_OUT <= stall_0;
		STALL_1_OUT <= stall_1;
		STALL_2_OUT <= stall_2;
		STALL_3_OUT <= stall_3;
		STALL_4_OUT <= stall_4;
		STALL_5_OUT <= stall_5;
		
		OP_0_RET <= op_0_out;
		OP_1_RET <= op_1_out;
		OP_2_RET <= op_2_out;
		OP_3_RET <= op_3_out;
		OP_4_RET <= op_4_out;
		OP_5_RET <= op_5_out;
		
		OUTPUT_A <= OUT_A_SIG;
		OUTPUT_B <= OUT_B_SIG;
		OUTPUT_C <= OUT_C_SIG;
		OUTPUT_D <= OUT_D_SIG;
		OUTPUT_E <= OUT_E_SIG;
end;
			 