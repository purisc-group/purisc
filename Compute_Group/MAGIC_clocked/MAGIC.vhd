library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAGIC is
	PORT (
			ADDRESS_A  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_B  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_C  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_W  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_TO_W  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			W_EN		  : IN STD_LOGIC;
			CLK		  : IN STD_LOGIC;
			RESET_n    : IN STD_LOGIC;
			HAZ_GLOB	  : IN STD_LOGIC;
			--HAZARD_TEST : OUT STD_LOGIC;
			DATA_OUT_A : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_B : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_C : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			C0_STALL	  : OUT STD_LOGIC;
			C1_STALL	  : OUT STD_LOGIC;
			CORE_IDENT : OUT STD_LOGIC;
			IO_ENABLE  : IN STD_LOGIC
			);
end;

architecture magic of MAGIC is

	component SETUP
		PORT(
				CLK	: IN STD_LOGIC;
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
	end component;
	
	component ROUTE
		PORT(
				hazard		: IN STD_LOGIC;
				hazard_advanced : IN STD_LOGIC;
				CLK			: IN STD_LOGIC;
				RESET_n		: IN STD_LOGIC;
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
				OUTPUT_A : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				OUTPUT_B : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				OUTPUT_C : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				OUTPUT_0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
				OUTPUT_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
				);
	end component;
	
	component RAM_0
		PORT
		(
			aclr		: IN STD_LOGIC;
			address_a		: IN STD_LOGIC_VECTOR (9 downto 0);
			address_b		: IN STD_LOGIC_VECTOR (9 downto 0);
			clock		: IN STD_LOGIC;
			data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren_a		: IN STD_LOGIC;
			wren_b		: IN STD_LOGIC;
			q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
	
	component RAM_1
		PORT
		(
			aclr		: IN STD_LOGIC;
			address_a		: IN STD_LOGIC_VECTOR (9 downto 0);
			address_b		: IN STD_LOGIC_VECTOR (9 downto 0);
			clock		: IN STD_LOGIC;
			data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren_a		: IN STD_LOGIC;
			wren_b		: IN STD_LOGIC;
			q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
	
	component RAM_2
		PORT
		(
			aclr		: IN STD_LOGIC;
			address_a		: IN STD_LOGIC_VECTOR (9 downto 0);
			address_b		: IN STD_LOGIC_VECTOR (9 downto 0);
			clock		: IN STD_LOGIC;
			data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren_a		: IN STD_LOGIC;
			wren_b		: IN STD_LOGIC;
			q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
	
	component RAM_3
		PORT
		(
			aclr		: IN STD_LOGIC;
			address_a		: IN STD_LOGIC_VECTOR (9 downto 0);
			address_b		: IN STD_LOGIC_VECTOR (9 downto 0);
			clock		: IN STD_LOGIC;
			data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren_a		: IN STD_LOGIC;
			wren_b		: IN STD_LOGIC;
			q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
	
	component RAM_4
		PORT
		(
			aclr		: IN STD_LOGIC;
			address_a		: IN STD_LOGIC_VECTOR (9 downto 0);
			address_b		: IN STD_LOGIC_VECTOR (9 downto 0);
			clock		: IN STD_LOGIC;
			data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren_a		: IN STD_LOGIC;
			wren_b		: IN STD_LOGIC;
			q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
	
	component RAM_5
		PORT
		(
			aclr		: IN STD_LOGIC;
			address_a		: IN STD_LOGIC_VECTOR (9 downto 0);
			address_b		: IN STD_LOGIC_VECTOR (9 downto 0);
			clock		: IN STD_LOGIC;
			data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren_a		: IN STD_LOGIC;
			wren_b		: IN STD_LOGIC;
			q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
	
	component RAM_6
		PORT
		(
			aclr		: IN STD_LOGIC;
			address_a		: IN STD_LOGIC_VECTOR (9 downto 0);
			address_b		: IN STD_LOGIC_VECTOR (9 downto 0);
			clock		: IN STD_LOGIC;
			data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren_a		: IN STD_LOGIC;
			wren_b		: IN STD_LOGIC;
			q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;
	
	component RAM_7
		PORT
		(
			aclr		: IN STD_LOGIC;
			address_a		: IN STD_LOGIC_VECTOR (9 downto 0);
			address_b		: IN STD_LOGIC_VECTOR (9 downto 0);
			clock		: IN STD_LOGIC;
			data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			wren_a		: IN STD_LOGIC;
			wren_b		: IN STD_LOGIC;
			q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	end component;

	signal address_a_sig : std_logic_vector (31 downto 0);
	signal address_b_sig : std_logic_vector (31 downto 0);
	signal address_c_sig : std_logic_vector (31 downto 0);
	signal address_0_sig : std_logic_vector (31 downto 0);
	signal address_1_sig : std_logic_vector (31 downto 0);
	signal address_w_sig : std_logic_vector (31 downto 0);
	signal data_to_w_sig : std_logic_vector (31 downto 0);
	signal w_en_sig		: std_logic;
	signal RESET 			: std_logic;
	signal stall_flag		: std_logic;
	signal hazard			: std_logic;
	signal hazard_w_io	: std_logic;
	signal io_buffer_en	: std_logic;
	signal ram_0_port_a : std_logic_vector (9 downto 0);
	signal ram_0_port_b : std_logic_vector (9 downto 0);
	signal ram_0_wren_a : std_logic;
	signal ram_0_wren_b : std_logic;
	signal ram_1_port_a : std_logic_vector (9 downto 0);
	signal ram_1_port_b : std_logic_vector (9 downto 0);
	signal ram_1_wren_a : std_logic;
	signal ram_1_wren_b : std_logic;
	signal ram_2_port_a : std_logic_vector (9 downto 0);
	signal ram_2_port_b : std_logic_vector (9 downto 0);
	signal ram_2_wren_a : std_logic;
	signal ram_2_wren_b : std_logic;
	signal ram_3_port_a : std_logic_vector (9 downto 0);
	signal ram_3_port_b : std_logic_vector (9 downto 0);
	signal ram_3_wren_a : std_logic;
	signal ram_3_wren_b : std_logic;
	signal ram_4_port_a : std_logic_vector (9 downto 0);
	signal ram_4_port_b : std_logic_vector (9 downto 0);
	signal ram_4_wren_a : std_logic;
	signal ram_4_wren_b : std_logic;
	signal ram_5_port_a : std_logic_vector (9 downto 0);
	signal ram_5_port_b : std_logic_vector (9 downto 0);
	signal ram_5_wren_a : std_logic;
	signal ram_5_wren_b : std_logic;
	signal ram_6_port_a : std_logic_vector (9 downto 0);
	signal ram_6_port_b : std_logic_vector (9 downto 0);
	signal ram_6_wren_a : std_logic;
	signal ram_6_wren_b : std_logic;
	signal ram_7_port_a : std_logic_vector (9 downto 0);
	signal ram_7_port_b : std_logic_vector (9 downto 0);
	signal ram_7_wren_a : std_logic;
	signal ram_7_wren_b : std_logic;
	signal ram_0_sel_vector : std_logic_vector(9 downto 0);
	signal ram_1_sel_vector : std_logic_vector(9 downto 0);
	signal ram_2_sel_vector : std_logic_vector(9 downto 0);
	signal ram_3_sel_vector : std_logic_vector(9 downto 0);
	signal ram_4_sel_vector : std_logic_vector(9 downto 0);
	signal ram_5_sel_vector : std_logic_vector(9 downto 0);
	signal ram_6_sel_vector : std_logic_vector(9 downto 0);
	signal ram_7_sel_vector : std_logic_vector(9 downto 0);
	signal ram_0_sel : std_logic_vector(9 downto 0);
	signal ram_1_sel : std_logic_vector(9 downto 0);
	signal ram_2_sel : std_logic_vector(9 downto 0);
	signal ram_3_sel : std_logic_vector(9 downto 0);
	signal ram_4_sel : std_logic_vector(9 downto 0);
	signal ram_5_sel : std_logic_vector(9 downto 0);
	signal ram_6_sel : std_logic_vector(9 downto 0);
	signal ram_7_sel : std_logic_vector(9 downto 0);	
	signal ram_0_out_a : std_logic_vector (31 downto 0);
	signal ram_0_out_b : std_logic_vector (31 downto 0);
	signal ram_1_out_a : std_logic_vector (31 downto 0);
	signal ram_1_out_b : std_logic_vector (31 downto 0);
	signal ram_2_out_a : std_logic_vector (31 downto 0);
	signal ram_2_out_b : std_logic_vector (31 downto 0);
	signal ram_3_out_a : std_logic_vector (31 downto 0);
	signal ram_3_out_b : std_logic_vector (31 downto 0);
	signal ram_4_out_a : std_logic_vector (31 downto 0);
	signal ram_4_out_b : std_logic_vector (31 downto 0);
	signal ram_5_out_a : std_logic_vector (31 downto 0);
	signal ram_5_out_b : std_logic_vector (31 downto 0);
	signal ram_6_out_a : std_logic_vector (31 downto 0);
	signal ram_6_out_b : std_logic_vector (31 downto 0);
	signal ram_7_out_a : std_logic_vector (31 downto 0);
	signal ram_7_out_b : std_logic_vector (31 downto 0);
	signal output_a : std_logic_vector (31 downto 0);
	signal output_b : std_logic_vector (31 downto 0);
	signal output_c : std_logic_vector (31 downto 0);
	signal output_0 : std_logic_vector (31 downto 0);
	signal output_1 : std_logic_vector (31 downto 0);
	signal stall : std_logic;
	signal hold : std_logic;
	signal core_id : std_logic;
	signal c0_stall_sig : std_logic;
	signal c1_stall_sig : std_logic;
	signal hazard_advanced : std_logic;
	
	
--	
begin

	input_control : SETUP PORT MAP (
												CLK => CLK,
												ADDRESS_A => address_a_sig,
												ADDRESS_B => address_b_sig,
												ADDRESS_C => address_c_sig,
												ADDRESS_0 => address_0_sig,
												ADDRESS_1 => address_1_sig,
												ADDRESS_W => address_w_sig,
												W_EN => w_en_sig,
												RESET_n => RESET_n,
												STALL => stall_flag,
												HAZARD => hazard,
												ram_0_port_a => ram_0_port_a,
												ram_0_port_b => ram_0_port_b,
												ram_0_wren_a => ram_0_wren_a,
												ram_0_wren_b => ram_0_wren_b,
												ram_1_port_a => ram_1_port_a,
												ram_1_port_b => ram_1_port_b,
												ram_1_wren_a => ram_1_wren_a,
												ram_1_wren_b => ram_1_wren_b,
												ram_2_port_a => ram_2_port_a,
												ram_2_port_b => ram_2_port_b,
												ram_2_wren_a => ram_2_wren_a,
												ram_2_wren_b => ram_2_wren_b,
												ram_3_port_a => ram_3_port_a,
												ram_3_port_b => ram_3_port_b,
												ram_3_wren_a => ram_3_wren_a,
												ram_3_wren_b => ram_3_wren_b,
												ram_4_port_a => ram_4_port_a,
												ram_4_port_b => ram_4_port_b,
												ram_4_wren_a => ram_4_wren_a,
												ram_4_wren_b => ram_4_wren_b,
												ram_5_port_a => ram_5_port_a,
												ram_5_port_b => ram_5_port_b,
												ram_5_wren_a => ram_5_wren_a,
												ram_5_wren_b => ram_5_wren_b,
												ram_6_port_a => ram_6_port_a,
												ram_6_port_b => ram_6_port_b,
												ram_6_wren_a => ram_6_wren_a,
												ram_6_wren_b => ram_6_wren_b,
												ram_7_port_a => ram_7_port_a,
												ram_7_port_b => ram_7_port_b,
												ram_7_wren_a => ram_7_wren_a,
												ram_7_wren_b => ram_7_wren_b,
												ram_0_sel_vector => ram_0_sel_vector,
												ram_1_sel_vector => ram_1_sel_vector,
												ram_2_sel_vector => ram_2_sel_vector,
												ram_3_sel_vector => ram_3_sel_vector,
												ram_4_sel_vector => ram_4_sel_vector,
												ram_5_sel_vector => ram_5_sel_vector,
												ram_6_sel_vector => ram_6_sel_vector,
												ram_7_sel_vector => ram_7_sel_vector
												);
												
	RAM_0_inst : RAM_0 PORT MAP (
											aclr	 => RESET,
											address_a	 => ram_0_port_a,
											address_b	 => ram_0_port_b,
											clock	 => CLK,
											data_a	 => data_to_w_sig,
											data_b	 => data_to_w_sig,
											wren_a	 => ram_0_wren_a,
											wren_b	 => ram_0_wren_b,
											q_a	 => ram_0_out_a,
											q_b	 => ram_0_out_b
										);
										
	RAM_1_inst : RAM_1 PORT MAP (
											aclr	 => RESET,
											address_a	 => ram_1_port_a,
											address_b	 => ram_1_port_b,
											clock	 => CLK,
											data_a	 => data_to_w_sig,
											data_b	 => data_to_w_sig,
											wren_a	 => ram_1_wren_a,
											wren_b	 => ram_1_wren_b,
											q_a	 => ram_1_out_a,
											q_b	 => ram_1_out_b
										);
										
	RAM_2_inst : RAM_2 PORT MAP (
											aclr	 => RESET,
											address_a	 => ram_2_port_a,
											address_b	 => ram_2_port_b,
											clock	 => CLK,
											data_a	 => data_to_w_sig,
											data_b	 => data_to_w_sig,
											wren_a	 => ram_2_wren_a,
											wren_b	 => ram_2_wren_b,
											q_a	 => ram_2_out_a,
											q_b	 => ram_2_out_b
										);
										
	RAM_3_inst : RAM_3 PORT MAP (
											aclr	 => RESET,
											address_a	 => ram_3_port_a,
											address_b	 => ram_3_port_b,
											clock	 => CLK,
											data_a	 => data_to_w_sig,
											data_b	 => data_to_w_sig,
											wren_a	 => ram_3_wren_a,
											wren_b	 => ram_3_wren_b,
											q_a	 => ram_3_out_a,
											q_b	 => ram_3_out_b
										);
										
	RAM_4_inst : RAM_4 PORT MAP (
											aclr	 => RESET,
											address_a	 => ram_4_port_a,
											address_b	 => ram_4_port_b,
											clock	 => CLK,
											data_a	 => data_to_w_sig,
											data_b	 => data_to_w_sig,
											wren_a	 => ram_4_wren_a,
											wren_b	 => ram_4_wren_b,
											q_a	 => ram_4_out_a,
											q_b	 => ram_4_out_b
										);
										
	RAM_5_inst : RAM_5 PORT MAP (
											aclr	 => RESET,
											address_a	 => ram_5_port_a,
											address_b	 => ram_5_port_b,
											clock	 => CLK,
											data_a	 => data_to_w_sig,
											data_b	 => data_to_w_sig,
											wren_a	 => ram_5_wren_a,
											wren_b	 => ram_5_wren_b,
											q_a	 => ram_5_out_a,
											q_b	 => ram_5_out_b
										);
										
	RAM_6_inst : RAM_6 PORT MAP (
											aclr	 => RESET,
											address_a	 => ram_6_port_a,
											address_b	 => ram_6_port_b,
											clock	 => CLK,
											data_a	 => data_to_w_sig,
											data_b	 => data_to_w_sig,
											wren_a	 => ram_6_wren_a,
											wren_b	 => ram_6_wren_b,
											q_a	 => ram_6_out_a,
											q_b	 => ram_6_out_b
										);

	RAM_7_inst : RAM_7 PORT MAP (
											aclr	 => RESET,
											address_a	 => ram_7_port_a,
											address_b	 => ram_7_port_b,
											clock	 => CLK,
											data_a	 => data_to_w_sig,
											data_b	 => data_to_w_sig,
											wren_a	 => ram_7_wren_a,
											wren_b	 => ram_7_wren_b,
											q_a	 => ram_7_out_a,
											q_b	 => ram_7_out_b
										);
									
	output_control : ROUTE PORT MAP (
												CLK => CLK,
												RESET_n => RESET_n,
												hazard => hazard_w_io,
												hazard_advanced => hazard_advanced,
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
												ram_0_sel_vector => ram_0_sel,
												ram_1_sel_vector => ram_1_sel,
												ram_2_sel_vector => ram_2_sel,
												ram_3_sel_vector => ram_3_sel,
												ram_4_sel_vector => ram_4_sel,
												ram_5_sel_vector => ram_5_sel,
												ram_6_sel_vector => ram_6_sel,
												ram_7_sel_vector => ram_7_sel,
												OUTPUT_A => output_a,
												OUTPUT_B => output_b,
												OUTPUT_C => output_c,
												OUTPUT_0 => output_0,
												OUTPUT_1 => output_1
											);
										
	
--	latch_outputs : process (CLK, RESET_n) begin
--		if (RESET_n = '0') then
--			DATA_OUT_A <= "00000000000000000000000000000000";
--			DATA_OUT_B <= "00000000000000000000000000000000";
--			DATA_OUT_C <= "00000000000000000000000000000000";
--			DATA_OUT_0 <= "00000000000000000000000000000000";
--			DATA_OUT_1 <= "00000000000000000000000000000000";
--		elsif (rising_edge(CLK)) then
--			DATA_OUT_A <= output_a;
--			DATA_OUT_B <= output_b;
--			DATA_OUT_C <= output_c;
--			DATA_OUT_0 <= output_0;
--			DATA_OUT_1 <= output_1;
--		end if;
--	end process;
--********above latching used for testing************
			DATA_OUT_A <= output_a;
			DATA_OUT_B <= output_b;
			DATA_OUT_C <= output_c;
			DATA_OUT_0 <= output_0;
			DATA_OUT_1 <= output_1;
	
	latch_vectors : process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			ram_0_sel <= "0000000000";
			ram_1_sel <= "0000000000";
			ram_2_sel <= "0000000000";
			ram_3_sel <= "0000000000";
			ram_4_sel <= "0000000000";
			ram_5_sel <= "0000000000";
			ram_6_sel <= "0000000000";
			ram_7_sel <= "0000000000";
			hazard <= '0';
		elsif (rising_edge(CLK)) then
			ram_0_sel <= ram_0_sel_vector;
			ram_1_sel <= ram_1_sel_vector;
			ram_2_sel <= ram_2_sel_vector;
			ram_3_sel <= ram_3_sel_vector;
			ram_4_sel <= ram_4_sel_vector;
			ram_5_sel <= ram_5_sel_vector;
			ram_6_sel <= ram_6_sel_vector;
			ram_7_sel <= ram_7_sel_vector;
			hazard <= stall_flag;
		end if;
	end process;

												
												
--	latch_inputs : process (CLK, RESET_n) begin
--		if (RESET_n = '0') then
--			address_a_sig <= "00000000000000000000000000000000";
--			address_b_sig <= "00000000000000000000000000000000";
--			address_c_sig <= "00000000000000000000000000000000";
--			address_0_sig <= "00000000000000000000000000000000";
--			address_1_sig <= "00000000000000000000000000000000";
--			address_w_sig <= "00000000000000000000000000000000";
--			data_to_w_sig <= "00000000000000000000000000000000";
--			w_en_sig <= '0';
--		elsif (rising_edge(CLK)) then
--			address_a_sig <= ADDRESS_A;
--			address_b_sig <= ADDRESS_B;
--			address_c_sig <= ADDRESS_C;
--			address_0_sig <= ADDRESS_0;
--			address_1_sig <= ADDRESS_1;
--			address_w_sig <= ADDRESS_W;
--			data_to_w_sig <= DATA_TO_W;
--			w_en_sig <= W_EN;
--		end if;
--	end process;
--********above latching used for testing***************
			address_a_sig <= ADDRESS_A;
			address_b_sig <= ADDRESS_B;
			address_c_sig <= ADDRESS_C;
			address_0_sig <= ADDRESS_0;
			address_1_sig <= ADDRESS_1;
			address_w_sig <= ADDRESS_W;
			data_to_w_sig <= DATA_TO_W;
			w_en_sig <= W_EN;
	
	RESET <= not RESET_n;
	stall <= stall_flag or hazard_w_io;  --maybe without io
	hold <= c0_stall_sig and c1_stall_sig;
	C0_STALL <= (not core_id) or c0_stall_sig;			--flipped not statement
	C1_STALL <= (core_id) or c1_stall_sig;	--between these two lines
	CORE_IDENT <= core_id;
	hazard_w_io <= hazard or io_buffer_en;
	--HAZARD_TEST <= hazard_w_io; --THIS IS FOR DEBUGGING
	hazard_advanced <= hazard_w_io or stall_flag or HAZ_GLOB; --ALSO NEW
	
	id_gen : process (CLK, RESET_n, hold) begin
		if (RESET_n = '0') then
			core_id <= '0';
		elsif (rising_edge(CLK)) then
			if (hold = '0' and IO_ENABLE = '0') then
				core_id <= not core_id;
			end if;
		end if;
	end process;
	
	override_io : process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			io_buffer_en <= '0';
		elsif (rising_edge(CLK)) then
			io_buffer_en <= IO_ENABLE;
		end if;
	end process;
	
	stalling : process (core_id, stall_flag, stall) begin
		if (core_id = '0' and stall = '1') then
			c0_stall_sig <= stall;
			c1_stall_sig <= stall_flag;
		elsif (core_id = '1' and stall = '1') then
			c0_stall_sig <= stall_flag;
			c1_stall_sig <= stall;
		else
			c0_stall_sig <= '0';
			c1_stall_sig <= '0';
		end if;
	end process;

	
end;
	