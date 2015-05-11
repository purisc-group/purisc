library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity global_memory is 
	PORT(
			CLK		: IN STD_LOGIC;
			RESET_n	: IN STD_LOGIC;
						--compute group 0
			ADDRESS_A_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_B_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_C_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_0_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_1_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_W_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_CG0		  : IN STD_LOGIC;
			ENABLE_CG0	  : IN STD_LOGIC;
			DATA_A_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_B_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_C_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_1_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			STALL_CG0	  : OUT STD_LOGIC;
						--compute group 1
			ADDRESS_A_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_B_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_C_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_0_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_1_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_W_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_CG1		  : IN STD_LOGIC;
			ENABLE_CG1	  : IN STD_LOGIC;
			DATA_A_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_B_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_C_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_1_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			STALL_CG1	  : OUT STD_LOGIC;
						--compute group 2
			ADDRESS_A_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_B_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_C_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_0_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_1_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_W_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_CG2		  : IN STD_LOGIC;
			ENABLE_CG2	  : IN STD_LOGIC;
			DATA_A_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_B_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_C_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_1_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			STALL_CG2	  : OUT STD_LOGIC;
					--compute group 3
			ADDRESS_A_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_B_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_C_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_0_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_1_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_W_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_CG3		  : IN STD_LOGIC;
			ENABLE_CG3	  : IN STD_LOGIC;
			DATA_A_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_B_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_C_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_1_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			STALL_CG3	  : OUT STD_LOGIC;
						--IO controller
			ADDRESS_IO    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_IO  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_IO		  : IN STD_LOGIC;
			ENABLE_IO	  : IN STD_LOGIC;
			DATA_RET_IO   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        --DONE signals
            DONE_C0       : OUT STD_LOGIC;
            DONE_C1       : OUT STD_LOGIC;
            DONE_C2       : OUT STD_LOGIC;
            DONE_C3       : OUT STD_LOGIC;
            DONE_C4       : OUT STD_LOGIC;
            DONE_C5       : OUT STD_LOGIC;
            DONE_C6       : OUT STD_LOGIC;
            DONE_C7       : OUT STD_LOGIC;
            RCC           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			);
end;

architecture global of global_memory is

	component MAGIC_global
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
	end component;

	type state_type is (cg0, cg1, cg2, cg3);
	signal state : state_type;


	signal address_a_cg0_buffer : std_logic_vector(31 downto 0);
	signal address_b_cg0_buffer : std_logic_vector(31 downto 0);
	signal address_c_cg0_buffer : std_logic_vector(31 downto 0);
	signal address_0_cg0_buffer : std_logic_vector(31 downto 0);
	signal address_1_cg0_buffer : std_logic_vector(31 downto 0);
	signal address_w_cg0_buffer : std_logic_vector(31 downto 0);
	signal data_to_w_cg0_buffer : std_logic_vector(31 downto 0);
	signal w_en_cg0_buffer : std_logic;
	signal access_request_cg0	: std_logic;
	signal data_a_to_cg0_buffer : std_logic_vector (31 downto 0);
	signal data_b_to_cg0_buffer : std_logic_vector (31 downto 0);
	signal data_c_to_cg0_buffer : std_logic_vector (31 downto 0);
	signal data_0_to_cg0_buffer : std_logic_vector (31 downto 0);
	signal data_1_to_cg0_buffer : std_logic_vector (31 downto 0);
	
	signal address_a_cg1_buffer : std_logic_vector(31 downto 0);
	signal address_b_cg1_buffer : std_logic_vector(31 downto 0);
	signal address_c_cg1_buffer : std_logic_vector(31 downto 0);
	signal address_0_cg1_buffer : std_logic_vector(31 downto 0);
	signal address_1_cg1_buffer : std_logic_vector(31 downto 0);
	signal address_w_cg1_buffer : std_logic_vector(31 downto 0);
	signal data_to_w_cg1_buffer : std_logic_vector(31 downto 0);
	signal w_en_cg1_buffer : std_logic;
	signal access_request_cg1	: std_logic;
	signal data_a_to_cg1_buffer : std_logic_vector (31 downto 0);
	signal data_b_to_cg1_buffer : std_logic_vector (31 downto 0);
	signal data_c_to_cg1_buffer : std_logic_vector (31 downto 0);
	signal data_0_to_cg1_buffer : std_logic_vector (31 downto 0);
	signal data_1_to_cg1_buffer : std_logic_vector (31 downto 0);
	
	signal address_a_cg2_buffer : std_logic_vector(31 downto 0);
	signal address_b_cg2_buffer : std_logic_vector(31 downto 0);
	signal address_c_cg2_buffer : std_logic_vector(31 downto 0);
	signal address_0_cg2_buffer : std_logic_vector(31 downto 0);
	signal address_1_cg2_buffer : std_logic_vector(31 downto 0);
	signal address_w_cg2_buffer : std_logic_vector(31 downto 0);
	signal data_to_w_cg2_buffer : std_logic_vector(31 downto 0);
	signal w_en_cg2_buffer : std_logic;
	signal access_request_cg2	: std_logic;
	signal data_a_to_cg2_buffer : std_logic_vector (31 downto 0);
	signal data_b_to_cg2_buffer : std_logic_vector (31 downto 0);
	signal data_c_to_cg2_buffer : std_logic_vector (31 downto 0);
	signal data_0_to_cg2_buffer : std_logic_vector (31 downto 0);
	signal data_1_to_cg2_buffer : std_logic_vector (31 downto 0);
	
	signal address_a_cg3_buffer : std_logic_vector(31 downto 0);
	signal address_b_cg3_buffer : std_logic_vector(31 downto 0);
	signal address_c_cg3_buffer : std_logic_vector(31 downto 0);
	signal address_0_cg3_buffer : std_logic_vector(31 downto 0);
	signal address_1_cg3_buffer : std_logic_vector(31 downto 0);
	signal address_w_cg3_buffer : std_logic_vector(31 downto 0);
	signal data_to_w_cg3_buffer : std_logic_vector(31 downto 0);
	signal w_en_cg3_buffer : std_logic;
	signal access_request_cg3	: std_logic;
	signal data_a_to_cg3_buffer : std_logic_vector (31 downto 0);
	signal data_b_to_cg3_buffer : std_logic_vector (31 downto 0);
	signal data_c_to_cg3_buffer : std_logic_vector (31 downto 0);
	signal data_0_to_cg3_buffer : std_logic_vector (31 downto 0);
	signal data_1_to_cg3_buffer : std_logic_vector (31 downto 0);
	
	signal address_a_to_mem : std_logic_vector(31 downto 0);
	signal address_b_to_mem : std_logic_vector(31 downto 0);
	signal address_c_to_mem : std_logic_vector(31 downto 0);
	signal address_0_to_mem : std_logic_vector(31 downto 0);
	signal address_1_to_mem : std_logic_vector(31 downto 0);
	signal address_w_to_mem : std_logic_vector(31 downto 0);
	signal data_to_w_to_mem : std_logic_vector(31 downto 0);
	signal w_en_to_mem : std_logic;
	signal address_a_mem : std_logic_vector(31 downto 0);
	signal address_b_mem : std_logic_vector(31 downto 0);
	signal address_c_mem : std_logic_vector(31 downto 0);
	signal address_0_mem : std_logic_vector(31 downto 0);
	signal address_1_mem : std_logic_vector(31 downto 0);
	signal address_w_mem : std_logic_vector(31 downto 0);
	signal data_to_w_mem : std_logic_vector(31 downto 0);
	signal w_en_mem : std_logic;
	signal data_a : std_logic_vector(31 downto 0);
	signal data_b : std_logic_vector(31 downto 0);
	signal data_c : std_logic_vector(31 downto 0);
	signal data_0 : std_logic_vector(31 downto 0);
	signal data_1 : std_logic_vector(31 downto 0);
	signal core_id : std_logic;
	signal gnd : std_logic;	
	signal stall_c0 : std_logic;
	signal stall_c1 : std_logic;
	signal stall_c0_raw : std_logic;
	signal stall_c1_raw : std_logic;
	
	signal done_cg0 : std_logic;
	signal done_cg1 : std_logic;
	signal done_cg2 : std_logic;
	signal done_cg3 : std_logic;
	
	signal clear_stall_cg0 : std_logic;
	signal clear_stall_cg1 : std_logic;
	signal clear_stall_cg2 : std_logic;
	signal clear_stall_cg3 : std_logic;
	
	signal buffer_cg0 : std_logic;
	signal buffer_cg1 : std_logic;
	signal buffer_cg2 : std_logic;
	signal buffer_cg3 : std_logic;
    
    signal done_reg_c0 : std_logic;
    signal done_reg_c1 : std_logic;
    signal done_reg_c2 : std_logic;
    signal done_reg_c3 : std_logic;
    signal done_reg_c4 : std_logic;
    signal done_reg_c5 : std_logic;
    signal done_reg_c6 : std_logic;
    signal done_reg_c7 : std_logic;
    
    signal ready_clear_count : std_logic_vector(3 downto 0);

	

	


begin

	gnd <= '0';
	--immidiately stall the requesting core
	STALL_CG0 <= ENABLE_CG0 and clear_stall_cg0;
	STALL_CG1 <= ENABLE_CG1 and clear_stall_cg1;
	STALL_CG2 <= ENABLE_CG2 and clear_stall_cg2;
	STALL_CG3 <= ENABLE_CG3 and clear_stall_cg3;
	--pass buffered values back to compute groups
	DATA_A_TO_CG0 <= data_a_to_cg0_buffer;
	DATA_B_TO_CG0 <= data_b_to_cg0_buffer;
	DATA_C_TO_CG0 <= data_c_to_cg0_buffer;
	DATA_0_TO_CG0 <= data_0_to_cg0_buffer;
	DATA_1_TO_CG0 <= data_1_to_cg0_buffer;
	DATA_A_TO_CG1 <= data_a_to_cg1_buffer;
	DATA_B_TO_CG1 <= data_b_to_cg1_buffer;
	DATA_C_TO_CG1 <= data_c_to_cg1_buffer;
	DATA_0_TO_CG1 <= data_0_to_cg1_buffer;
	DATA_1_TO_CG1 <= data_1_to_cg1_buffer;
	DATA_A_TO_CG2 <= data_a_to_cg2_buffer;
	DATA_B_TO_CG2 <= data_b_to_cg2_buffer;
	DATA_C_TO_CG2 <= data_c_to_cg2_buffer;
	DATA_0_TO_CG2 <= data_0_to_cg2_buffer;
	DATA_1_TO_CG2 <= data_1_to_cg2_buffer;
	DATA_A_TO_CG3 <= data_a_to_cg3_buffer;
	DATA_B_TO_CG3 <= data_b_to_cg3_buffer;
	DATA_C_TO_CG3 <= data_c_to_cg3_buffer;
	DATA_0_TO_CG3 <= data_0_to_cg3_buffer;
	DATA_1_TO_CG3 <= data_1_to_cg3_buffer;
	
	buffer_input_lines : process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			address_a_cg0_buffer <= "00000000000000000000000000000000";
			address_b_cg0_buffer <= "00000000000000000000000000000001";
			address_c_cg0_buffer <= "00000000000000000000000000000010";
			address_0_cg0_buffer <= "00000000000000000000000000000011";
			address_1_cg0_buffer <= "00000000000000000000000000000100";
			address_w_cg0_buffer <= "00000000000000000000000000000101";
			data_to_w_cg0_buffer <= "00000000000000000000000000000110";
			w_en_cg0_buffer <= '0';
			access_request_cg0 <= '0';
			address_a_cg1_buffer <= "00000000000000000000000000000000";
			address_b_cg1_buffer <= "00000000000000000000000000000001";
			address_c_cg1_buffer <= "00000000000000000000000000000010";
			address_0_cg1_buffer <= "00000000000000000000000000000011";
			address_1_cg1_buffer <= "00000000000000000000000000000100";
			address_w_cg1_buffer <= "00000000000000000000000000000101";
			data_to_w_cg1_buffer <= "00000000000000000000000000000110";
			w_en_cg1_buffer <= '0';
			access_request_cg1 <= '0';
			address_a_cg2_buffer <= "00000000000000000000000000000000";
			address_b_cg2_buffer <= "00000000000000000000000000000001";
			address_c_cg2_buffer <= "00000000000000000000000000000010";
			address_0_cg2_buffer <= "00000000000000000000000000000011";
			address_1_cg2_buffer <= "00000000000000000000000000000100";
			address_w_cg2_buffer <= "00000000000000000000000000000101";
			data_to_w_cg2_buffer <= "00000000000000000000000000000110";
			w_en_cg2_buffer <= '0';
			access_request_cg2 <= '0';
			address_a_cg3_buffer <= "00000000000000000000000000000000";
			address_b_cg3_buffer <= "00000000000000000000000000000001";
			address_c_cg3_buffer <= "00000000000000000000000000000010";
			address_0_cg3_buffer <= "00000000000000000000000000000011";
			address_1_cg3_buffer <= "00000000000000000000000000000100";
			address_w_cg3_buffer <= "00000000000000000000000000000101";
			data_to_w_cg3_buffer <= "00000000000000000000000000000110";
			w_en_cg3_buffer <= '0';
			access_request_cg3 <= '0';
			
		elsif (rising_edge(CLK)) then
			address_a_cg0_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_A_CG0(14 downto 13)) - 1) & ADDRESS_A_CG0(12 downto 0);
			address_b_cg0_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_B_CG0(14 downto 13)) - 1) & ADDRESS_B_CG0(12 downto 0);
			address_c_cg0_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_C_CG0(14 downto 13)) - 1) & ADDRESS_C_CG0(12 downto 0);
			address_0_cg0_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_0_CG0(14 downto 13)) - 1) & ADDRESS_0_CG0(12 downto 0);
			address_1_cg0_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_1_CG0(14 downto 13)) - 1) & ADDRESS_1_CG0(12 downto 0);
			address_w_cg0_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_W_CG0(14 downto 13)) - 1) & ADDRESS_W_CG0(12 downto 0);
			data_to_w_cg0_buffer <= DATA_TO_W_CG0;
			w_en_cg0_buffer <= W_EN_CG0;
			access_request_cg0 <= ENABLE_CG0;
			
			address_a_cg1_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_A_CG1(14 downto 13)) - 1) & ADDRESS_A_CG1(12 downto 0);
			address_b_cg1_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_B_CG1(14 downto 13)) - 1) & ADDRESS_B_CG1(12 downto 0);
			address_c_cg1_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_C_CG1(14 downto 13)) - 1) & ADDRESS_C_CG1(12 downto 0);
			address_0_cg1_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_0_CG1(14 downto 13)) - 1) & ADDRESS_0_CG1(12 downto 0);
			address_1_cg1_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_1_CG1(14 downto 13)) - 1) & ADDRESS_1_CG1(12 downto 0);
			address_w_cg1_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_W_CG1(14 downto 13)) - 1) & ADDRESS_W_CG1(12 downto 0);
			data_to_w_cg1_buffer <= DATA_TO_W_CG1;
			w_en_cg1_buffer <= W_EN_CG1;
			access_request_cg1 <= ENABLE_CG1;
			
			address_a_cg2_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_A_CG2(14 downto 13)) - 1) & ADDRESS_A_CG2(12 downto 0);
			address_b_cg2_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_B_CG2(14 downto 13)) - 1) & ADDRESS_B_CG2(12 downto 0);
			address_c_cg2_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_C_CG2(14 downto 13)) - 1) & ADDRESS_C_CG2(12 downto 0);
			address_0_cg2_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_0_CG2(14 downto 13)) - 1) & ADDRESS_0_CG2(12 downto 0);
			address_1_cg2_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_1_CG2(14 downto 13)) - 1) & ADDRESS_1_CG2(12 downto 0);
			address_w_cg2_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_W_CG2(14 downto 13)) - 1) & ADDRESS_W_CG2(12 downto 0);
			data_to_w_cg2_buffer <= DATA_TO_W_CG2;
			w_en_cg2_buffer <= W_EN_CG2;
			access_request_cg2 <= ENABLE_CG2;
			
			address_a_cg3_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_A_CG3(14 downto 13)) - 1) & ADDRESS_A_CG3(12 downto 0);
			address_b_cg3_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_B_CG3(14 downto 13)) - 1) & ADDRESS_B_CG3(12 downto 0);
			address_c_cg3_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_C_CG3(14 downto 13)) - 1) & ADDRESS_C_CG3(12 downto 0);
			address_0_cg3_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_0_CG3(14 downto 13)) - 1) & ADDRESS_0_CG3(12 downto 0);
			address_1_cg3_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_1_CG3(14 downto 13)) - 1) & ADDRESS_1_CG3(12 downto 0);
			address_w_cg3_buffer <= "00000000000000000" & std_logic_vector(unsigned(ADDRESS_W_CG3(14 downto 13)) - 1) & ADDRESS_W_CG3(12 downto 0);
			data_to_w_cg3_buffer <= DATA_TO_W_CG3;
			w_en_cg3_buffer <= W_EN_CG3;
			access_request_cg3 <= ENABLE_CG3;
		end if;
	end process;
	
	buffer_enables: process (RESET_n, CLK) begin
		if (RESET_n = '0') then
			buffer_cg0 <= '0';
			buffer_cg1 <= '0';
			buffer_cg2 <= '0';
			buffer_cg3 <= '0';
		elsif (rising_edge(CLK)) then
			clear_stall_cg0 <= not buffer_cg0;
			clear_stall_cg1 <= not buffer_cg1;
			clear_stall_cg2 <= not buffer_cg2;
			clear_stall_cg3 <= not buffer_cg3;
			buffer_cg0 <= done_cg0 and access_request_cg0;
			buffer_cg1 <= done_cg1 and access_request_cg1;
			buffer_cg2 <= done_cg2 and access_request_cg2;
			buffer_cg3 <= done_cg3 and access_request_cg3;
		end if;
	end process;
	
	buffer_data: process (RESET_n, CLK) begin
		if (RESET_n = '0') then
			data_a_to_cg0_buffer <= "00000000000000000000000000000000";
			data_b_to_cg0_buffer <= "00000000000000000000000000000000";
			data_c_to_cg0_buffer <= "00000000000000000000000000000000";
			data_0_to_cg0_buffer <= "00000000000000000000000000000000";
			data_1_to_cg0_buffer <= "00000000000000000000000000000000";
			data_a_to_cg1_buffer <= "00000000000000000000000000000000";
			data_b_to_cg1_buffer <= "00000000000000000000000000000000";
			data_c_to_cg1_buffer <= "00000000000000000000000000000000";
			data_0_to_cg1_buffer <= "00000000000000000000000000000000";
			data_1_to_cg1_buffer <= "00000000000000000000000000000000";
			data_a_to_cg2_buffer <= "00000000000000000000000000000000";
			data_b_to_cg2_buffer <= "00000000000000000000000000000000";
			data_c_to_cg2_buffer <= "00000000000000000000000000000000";
			data_0_to_cg2_buffer <= "00000000000000000000000000000000";
			data_1_to_cg2_buffer <= "00000000000000000000000000000000";
			data_a_to_cg3_buffer <= "00000000000000000000000000000000";
			data_b_to_cg3_buffer <= "00000000000000000000000000000000";
			data_c_to_cg3_buffer <= "00000000000000000000000000000000";
			data_0_to_cg3_buffer <= "00000000000000000000000000000000";
			data_1_to_cg3_buffer <= "00000000000000000000000000000000";
		elsif (rising_edge(CLK)) then
			if (buffer_cg0 = '1') then
				data_a_to_cg0_buffer <= data_a;
				data_b_to_cg0_buffer <= data_b;
				data_c_to_cg0_buffer <= data_c;
				data_0_to_cg0_buffer <= data_0;
				data_1_to_cg0_buffer <= data_1;
			end if;
			if (buffer_cg1 = '1') then
				data_a_to_cg1_buffer <= data_a;
				data_b_to_cg1_buffer <= data_b;
				data_c_to_cg1_buffer <= data_c;
				data_0_to_cg1_buffer <= data_0;
				data_1_to_cg1_buffer <= data_1;
			end if;
			if (buffer_cg2 = '1') then
				data_a_to_cg2_buffer <= data_a;
				data_b_to_cg2_buffer <= data_b;
				data_c_to_cg2_buffer <= data_c;
				data_0_to_cg2_buffer <= data_0;
				data_1_to_cg2_buffer <= data_1;
			end if;
			if (buffer_cg3 = '1') then
				data_a_to_cg3_buffer <= data_a;
				data_b_to_cg3_buffer <= data_b;
				data_c_to_cg3_buffer <= data_c;
				data_0_to_cg3_buffer <= data_0;
				data_1_to_cg3_buffer <= data_1;
			end if;
		end if;
	end process;
	
	
	state_machine : process (RESET_n, CLK, done_cg0, done_cg1, done_cg2, done_cg3) begin
		if (RESET_n = '0') then
			state <= cg0;
		elsif (rising_edge(CLK)) then
			case state is
				when cg0 =>
					if (done_cg0 = '0') then
						state <= cg0;
					else
						state <= cg1;
					end if;
				when cg1 =>
					if (done_cg1 = '0') then
						state <= cg1;
					else
						state <= cg2;
					end if;
				when cg2 =>
					if (done_cg2 = '0') then
						state <= cg2;
					else
						state <= cg3;
					end if;
				when cg3 =>
					if (done_cg3 = '0') then
						state <= cg3;
					else
						state <= cg0;
					end if;
			end case;
		end if;
	end process;
	
	passing_adresses : process (state, stall_c0, stall_c1, access_request_cg0, access_request_cg1, access_request_cg2, access_request_cg3, 
										address_a_cg0_buffer, address_b_cg0_buffer, address_c_cg0_buffer, address_0_cg0_buffer, address_1_cg0_buffer, 
										address_a_cg1_buffer, address_b_cg1_buffer, address_c_cg1_buffer, address_0_cg1_buffer, address_1_cg1_buffer, 
										address_a_cg2_buffer, address_b_cg2_buffer, address_c_cg2_buffer, address_0_cg2_buffer, address_1_cg2_buffer,
										address_a_cg3_buffer, address_b_cg3_buffer, address_c_cg3_buffer, address_0_cg3_buffer, address_1_cg3_buffer,
										address_w_cg0_buffer, address_w_cg1_buffer, address_w_cg2_buffer, address_w_cg3_buffer, 
										data_to_w_cg0_buffer, data_to_w_cg1_buffer, data_to_w_cg2_buffer, data_to_w_cg3_buffer, 
										w_en_cg0_buffer, w_en_cg1_buffer, w_en_cg2_buffer, w_en_cg3_buffer) begin
		case state is
			when cg0 =>
				--if access requested, pass adresses
				if (access_request_cg0 = '1') then 
					address_a_to_mem <= address_a_cg0_buffer;
					address_b_to_mem <= address_b_cg0_buffer;
					address_c_to_mem <= address_c_cg0_buffer;
					address_0_to_mem <= address_0_cg0_buffer;
					address_1_to_mem <= address_1_cg0_buffer;
					address_w_to_mem <= address_w_cg0_buffer;
					data_to_w_to_mem <= data_to_w_cg0_buffer;
					w_en_to_mem <= w_en_cg0_buffer;
					--wait for memory to respond
					if ((stall_c0 and stall_c1) = '1') then
						done_cg0 <= '0';
					else
						done_cg0 <= '1';
					end if;
				--if access not requested, supply dummy adresses
				else
					address_a_to_mem <= "00000000000000000000000000000000";
					address_b_to_mem <= "00000000000000000000000000000001";
					address_c_to_mem <= "00000000000000000000000000000010";
					address_0_to_mem <= "00000000000000000000000000000011";
					address_1_to_mem <= "00000000000000000000000000000100";
					address_w_to_mem <= "00000000000000000000000000000101";
					data_to_w_to_mem <= "00000000000000000000000000000110";
					w_en_to_mem <= '0';
					--move on to next group
					done_cg0 <= '1';
				end if;
				--all other compute groups not getting service yet
				done_cg1 <= '0';
				done_cg2 <= '0';
				done_cg3 <= '0';
			when cg1 =>
				--if access requested, pass adresses
				if (access_request_cg1 = '1') then 
					address_a_to_mem <= address_a_cg1_buffer;
					address_b_to_mem <= address_b_cg1_buffer;
					address_c_to_mem <= address_c_cg1_buffer;
					address_0_to_mem <= address_0_cg1_buffer;
					address_1_to_mem <= address_1_cg1_buffer;
					address_w_to_mem <= address_w_cg1_buffer;
					data_to_w_to_mem <= data_to_w_cg1_buffer;
					w_en_to_mem <= w_en_cg1_buffer;
					--wait for memory to respond
					if ((stall_c0 and stall_c1) = '1') then
						done_cg1 <= '0';
					else
						done_cg1 <= '1';
					end if;
				--if access not requested, supply dummy adresses
				else
					address_a_to_mem <= "00000000000000000000000000000000";
					address_b_to_mem <= "00000000000000000000000000000001";
					address_c_to_mem <= "00000000000000000000000000000010";
					address_0_to_mem <= "00000000000000000000000000000011";
					address_1_to_mem <= "00000000000000000000000000000100";
					address_w_to_mem <= "00000000000000000000000000000101";
					data_to_w_to_mem <= "00000000000000000000000000000110";
					w_en_to_mem <= '0';
					--move on to next group
					done_cg1 <= '1';
				end if;
				--all other compute groups not getting service yet
				done_cg0 <= '0';
				done_cg2 <= '0';
				done_cg3 <= '0';		
			when cg2 =>
				--if access requested, pass adresses
				if (access_request_cg2 = '1') then 
					address_a_to_mem <= address_a_cg2_buffer;
					address_b_to_mem <= address_b_cg2_buffer;
					address_c_to_mem <= address_c_cg2_buffer;
					address_0_to_mem <= address_0_cg2_buffer;
					address_1_to_mem <= address_1_cg2_buffer;
					address_w_to_mem <= address_w_cg2_buffer;
					data_to_w_to_mem <= data_to_w_cg2_buffer;
					w_en_to_mem <= w_en_cg2_buffer;
					--wait for memory to respond
					if ((stall_c0 and stall_c1) = '1') then
						done_cg2 <= '0';
					else
						done_cg2 <= '1';
					end if;
				--if access not requested, supply dummy adresses
				else
					address_a_to_mem <= "00000000000000000000000000000000";
					address_b_to_mem <= "00000000000000000000000000000001";
					address_c_to_mem <= "00000000000000000000000000000010";
					address_0_to_mem <= "00000000000000000000000000000011";
					address_1_to_mem <= "00000000000000000000000000000100";
					address_w_to_mem <= "00000000000000000000000000000101";
					data_to_w_to_mem <= "00000000000000000000000000000110";
					w_en_to_mem <= '0';
					--move on to next group
					done_cg2 <= '1';
				end if;
				--all other compute groups not getting service yet
				done_cg1 <= '0';
				done_cg0 <= '0';
				done_cg3 <= '0';
			when cg3 =>
				--if access requested, pass adresses
				if (access_request_cg3 = '1') then 
					address_a_to_mem <= address_a_cg3_buffer;
					address_b_to_mem <= address_b_cg3_buffer;
					address_c_to_mem <= address_c_cg3_buffer;
					address_0_to_mem <= address_0_cg3_buffer;
					address_1_to_mem <= address_1_cg3_buffer;
					address_w_to_mem <= address_w_cg3_buffer;
					data_to_w_to_mem <= data_to_w_cg3_buffer;
					w_en_to_mem <= w_en_cg3_buffer;
					--wait for memory to respond
					if ((stall_c0 and stall_c1) = '1') then
						done_cg3 <= '0';
					else
						done_cg3 <= '1';
					end if;
				--if access not requested, supply dummy adresses
				else
					address_a_to_mem <= "00000000000000000000000000000000";
					address_b_to_mem <= "00000000000000000000000000000001";
					address_c_to_mem <= "00000000000000000000000000000010";
					address_0_to_mem <= "00000000000000000000000000000011";
					address_1_to_mem <= "00000000000000000000000000000100";
					address_w_to_mem <= "00000000000000000000000000000101";
					data_to_w_to_mem <= "00000000000000000000000000000110";
					w_en_to_mem <= '0';
					--move on to next group
					done_cg3 <= '1';
				end if;
				--all other compute groups not getting service yet
				done_cg1 <= '0';
				done_cg2 <= '0';
				done_cg0 <= '0';
		end case;
	end process;
	
	global_cache : MAGIC_global PORT MAP (
								ADDRESS_A => address_a_mem,
								ADDRESS_B => address_b_mem,
								ADDRESS_C => address_c_mem,
								ADDRESS_0 => address_0_mem,
								ADDRESS_1 => address_1_mem,
								ADDRESS_W => address_w_mem,
								DATA_TO_W => data_to_w_mem,
								W_EN => w_en_mem,
								CLK => CLK,
								RESET_n => RESET_n,  
								DATA_OUT_A => data_a,
								DATA_OUT_B => data_b,
								DATA_OUT_C => data_c,
								DATA_OUT_0 => data_0,
								DATA_OUT_1 => data_1,
								C0_STALL => stall_c0_raw,
								C1_STALL	=> stall_c1_raw,
								CORE_IDENT => core_id,
								IO_ENABLE => gnd
								);
	
	--io override
	stall_c0 <= stall_c0_raw or ENABLE_IO;
	stall_c1 <= stall_c1_raw or ENABLE_IO;
	DATA_RET_IO <= data_a;
	process (ENABLE_IO, ADDRESS_IO, DATA_TO_W_IO, W_EN_IO, data_a, address_a_to_mem,
				address_b_to_mem, address_c_to_mem, address_0_to_mem, address_1_to_mem,
				data_to_w_to_mem, w_en_to_mem, address_w_to_mem) begin
		if (ENABLE_IO = '1') then
			if (W_EN_IO = '1') then
				address_a_mem <= "00000000000000000000000000000000";
				address_b_mem <= "00000000000000000000000000000001";
				address_c_mem <= "00000000000000000000000000000010";
				address_0_mem <= "00000000000000000000000000000011";
				address_1_mem <= "00000000000000000000000000000100";
				address_w_mem <= ADDRESS_IO;
				data_to_w_mem <= DATA_TO_W_IO;
				w_en_mem <= '1';
			else
				address_a_mem <= ADDRESS_IO;
				address_b_mem <= "00000000000000000000000000000001";
				address_c_mem <= "00000000000000000000000000000010";
				address_0_mem <= "00000000000000000000000000000011";
				address_1_mem <= "00000000000000000000000000000100";
				address_w_mem <= "00000000000000000000000000000100";
				data_to_w_mem <= data_to_w_to_mem;		
				w_en_mem <= '0';
			end if;
		else
			address_a_mem <= address_a_to_mem;
			address_b_mem <= address_b_to_mem;
			address_c_mem <= address_c_to_mem;
			address_0_mem <= address_0_to_mem;
			address_1_mem <= address_1_to_mem;
			address_w_mem <= address_w_to_mem;
			data_to_w_mem <= data_to_w_to_mem;
			w_en_mem <= w_en_to_mem;
		end if;
	end process;
    
    process (address_w_mem, w_en_mem, data_to_w_mem, CLK, RESET_n) begin
		if (RESET_n = '0') then
			done_reg_c0 <= '0';
            done_reg_c1 <= '0';
            done_reg_c2 <= '0';
            done_reg_c3 <= '0';
            done_reg_c4 <= '0';
            done_reg_c5 <= '0';
            done_reg_c6 <= '0';
            done_reg_c7 <= '0';
            ready_clear_count <= "0000";
		elsif (rising_edge(CLK)) then
			if ((address_w_mem = "00000000000000000010000000000000") and (w_en_mem = '1')) then
				done_reg_c0 <= data_to_w_mem(0);
			end if;
            if ((address_w_mem = "00000000000000000010000000000001") and (w_en_mem = '1')) then
				done_reg_c1 <= data_to_w_mem(0);
			end if;
            if ((address_w_mem = "00000000000000000010000000000010") and (w_en_mem = '1')) then
				done_reg_c2 <= data_to_w_mem(0);
			end if;
            if ((address_w_mem = "00000000000000000010000000000011") and (w_en_mem = '1')) then
				done_reg_c3 <= data_to_w_mem(0);
			end if;
            if ((address_w_mem = "00000000000000000010000000000100") and (w_en_mem = '1')) then
				done_reg_c4 <= data_to_w_mem(0);
			end if;
            if ((address_w_mem = "00000000000000000010000000000101") and (w_en_mem = '1')) then
				done_reg_c5 <= data_to_w_mem(0);
			end if;
            if ((address_w_mem = "00000000000000000010000000000110") and (w_en_mem = '1')) then
				done_reg_c6 <= data_to_w_mem(0);
			end if;
            if ((address_w_mem = "00000000000000000010000000000111") and (w_en_mem = '1')) then
				done_reg_c7 <= data_to_w_mem(0);
			end if;
            if ((address_w_mem = "00000000000000000010000000001000") and (w_en_mem = '1')) then
                ready_clear_count <= std_logic_vector(unsigned(ready_clear_count) + 1);
            end if;
		end if;
	end process;
    
    DONE_C0 <= done_reg_c0;
    DONE_C1 <= done_reg_c1;
    DONE_C2 <= done_reg_c2;
    DONE_C3 <= done_reg_c3;
    DONE_C4 <= done_reg_c4;
    DONE_C5 <= done_reg_c5;
    DONE_C6 <= done_reg_c6;
    DONE_C7 <= done_reg_c7;
    RCC <= ready_clear_count;
	
end;