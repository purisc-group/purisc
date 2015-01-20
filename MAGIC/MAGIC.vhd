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
			DATA_OUT_A : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_B : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_C : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			STALL		  : OUT STD_LOGIC
			);
end;

architecture behav of MAGIC is
	
	signal ADDRESS_A_SIG : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_B_SIG : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_C_SIG : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_0_SIG : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_1_SIG : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_W_SIG : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal DATA_TO_W_SIG : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal W_EN_SIG : STD_LOGIC;
	
	signal ROW_A_SIG : unsigned (12 downto 0);
	signal ROW_B_SIG : unsigned (12 downto 0);
	signal ROW_C_SIG : unsigned (12 downto 0);
	signal ROW_0_SIG : unsigned (12 downto 0);
	signal ROW_1_SIG : unsigned (12 downto 0);
	signal ROW_W_SIG : unsigned (12 downto 0);
	
	signal ROW_A_TO_RAMS : unsigned (12 downto 0);
	signal ROW_B_TO_RAMS : unsigned (12 downto 0);
	signal ROW_C_TO_RAMS : unsigned (12 downto 0);
	signal ROW_0_TO_RAMS : unsigned (12 downto 0);
	signal ROW_1_TO_RAMS : unsigned (12 downto 0);
	signal ROW_W_TO_RAMS : unsigned (12 downto 0);
	
	signal COL_A_SIG : unsigned (2 downto 0);
	signal COL_B_SIG : unsigned (2 downto 0);
	signal COL_C_SIG : unsigned (2 downto 0);
	signal COL_0_SIG : unsigned (2 downto 0);
	signal COL_1_SIG : unsigned (2 downto 0);
	signal COL_W_SIG : unsigned (2 downto 0);
	
	signal OPCODE_0_SIG : std_logic_vector (5 downto 0);
	signal OPCODE_1_SIG : std_logic_vector (5 downto 0);
	signal OPCODE_2_SIG : std_logic_vector (5 downto 0);
	signal OPCODE_3_SIG : std_logic_vector (5 downto 0);
	signal OPCODE_4_SIG : std_logic_vector (5 downto 0);
	signal OPCODE_5_SIG : std_logic_vector (5 downto 0);
	
	
	signal DATA_TO_A : std_logic_vector (31 downto 0);
	signal DATA_TO_B : std_logic_vector (31 downto 0);
	signal DATA_TO_C : std_logic_vector (31 downto 0);
	signal DATA_TO_0 : std_logic_vector (31 downto 0);
	signal DATA_TO_1 : std_logic_vector (31 downto 0);
	
	signal OPCODE_0_PASS : std_logic_vector (5 downto 0);
	signal OPCODE_1_PASS : std_logic_vector (5 downto 0);
	signal OPCODE_2_PASS : std_logic_vector (5 downto 0);
	signal OPCODE_3_PASS : std_logic_vector (5 downto 0);
	signal OPCODE_4_PASS : std_logic_vector (5 downto 0);
	signal OPCODE_5_PASS : std_logic_vector (5 downto 0);
	
	signal OPCODE_0_RAMS : std_logic_vector (5 downto 0);
	signal OPCODE_1_RAMS : std_logic_vector (5 downto 0);
	signal OPCODE_2_RAMS : std_logic_vector (5 downto 0);
	signal OPCODE_3_RAMS : std_logic_vector (5 downto 0);
	signal OPCODE_4_RAMS : std_logic_vector (5 downto 0);
	signal OPCODE_5_RAMS : std_logic_vector (5 downto 0);
	
	signal DATA_OUT_A_SIG : std_logic_vector (64 downto 0);
	signal DATA_OUT_B_SIG : std_logic_vector (64 downto 0);
	signal DATA_OUT_C_SIG : std_logic_vector (64 downto 0);
	signal DATA_OUT_0_SIG : std_logic_vector (64 downto 0);
	signal DATA_OUT_1_SIG : std_logic_vector (64 downto 0);
	
	signal DATA_OUT_A_RAW : std_logic_vector (64 downto 0);
	signal DATA_OUT_B_RAW : std_logic_vector (64 downto 0);
	signal DATA_OUT_C_RAW : std_logic_vector (64 downto 0);
	signal DATA_OUT_0_RAW : std_logic_vector (64 downto 0);
	signal DATA_OUT_1_RAW : std_logic_vector (64 downto 0);
	
	signal STALL_A : std_logic := '0';
	signal STALL_B : std_logic := '0';
	signal STALL_C : std_logic := '0';
	signal STALL_0 : std_logic := '0';
	signal STALL_1 : std_logic := '0';
	signal STALL_W : std_logic := '0';
		
	signal op_0_override : std_logic_vector (5 downto 0);
	signal stall_0_override : std_logic;
	signal op_0_in : std_logic_vector (5 downto 0);
	
	component address_transcode
		PORT (
			ADDRESS 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ROW		: OUT unsigned (12 DOWNTO 0);
			COL		: OUT unsigned (2 DOWNTO 0)
			);
	end component;
	
	component create_opcode
		PORT (
			COL_A		: IN UNSIGNED(2 DOWNTO 0);
			COL_B		: IN UNSIGNED(2 DOWNTO 0);
			COL_C		: IN UNSIGNED(2 DOWNTO 0);
			COL_D		: IN UNSIGNED(2 DOWNTO 0);
			COL_E		: IN UNSIGNED(2 DOWNTO 0);
			COL_W		: IN UNSIGNED(2 DOWNTO 0);
			OPCODE_0	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_1	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_2	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_3	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_4	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
			OPCODE_5	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
			);
	end component;
	
	component hazard_resolution
		PORT (
			CLK : IN STD_LOGIC;
			RESET_n : IN STD_LOGIC;
			ADDR_0_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_1_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_2_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_3_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_4_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_5_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_0_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_1_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_2_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_3_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_4_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR_5_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_FROM_RAM : IN STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_1_FROM_RAM : IN STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_2_FROM_RAM : IN STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_3_FROM_RAM : IN STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_4_FROM_RAM : IN STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_0_OUTPUT : OUT STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_1_OUTPUT : OUT STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_2_OUTPUT : OUT STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_3_OUTPUT : OUT STD_LOGIC_VECTOR(64 DOWNTO 0);
			DATA_4_OUTPUT : OUT STD_LOGIC_VECTOR(64 DOWNTO 0);
			W_EN : IN STD_LOGIC
			);
	end component;
	
	component RAM_ARRAY
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
			WAIT_FLAG : OUT STD_LOGIC
			);
	end component;

begin
	
	transcode_A : address_transcode PORT MAP (
						ADDRESS => ADDRESS_A_SIG,
						ROW => ROW_A_SIG,
						COL => COL_A_SIG
						);
	transcode_B : address_transcode PORT MAP (
						ADDRESS => ADDRESS_B_SIG,
						ROW => ROW_B_SIG,
						COL => COL_B_SIG
						);
	transcode_C : address_transcode PORT MAP (
						ADDRESS => ADDRESS_C_SIG,
						ROW => ROW_C_SIG,
						COL => COL_C_SIG
						);
	transcode_D : address_transcode PORT MAP (
						ADDRESS => ADDRESS_0_SIG,
						ROW => ROW_0_SIG,
						COL => COL_0_SIG
						);
	transcode_E : address_transcode PORT MAP (
						ADDRESS => ADDRESS_1_SIG,
						ROW => ROW_1_SIG,
						COL => COL_1_SIG
						);
	transcode_W : address_transcode PORT MAP (
						ADDRESS => ADDRESS_W_SIG,
						ROW => ROW_W_SIG,
						COL => COL_W_SIG
						);
	opcodery : create_opcode PORT MAP (
						COL_A => COL_A_SIG,
						COL_B => COL_B_SIG,
						COL_C => COL_C_SIG,
						COL_D => COL_0_SIG,
						COL_E => COL_1_SIG,
						COL_W => COL_W_SIG,
						OPCODE_0 => OPCODE_0_SIG,
						OPCODE_1 => OPCODE_1_SIG,
						OPCODE_2 => OPCODE_2_SIG,
						OPCODE_3 => OPCODE_3_SIG,
						OPCODE_4 => OPCODE_4_SIG,
						OPCODE_5 => OPCODE_5_SIG
						);
	cache : RAM_ARRAY PORT MAP (
						CLK => CLK,
						RESET_n => RESET_n,
						ROW_A => std_logic_vector(ROW_A_SIG),
						ROW_B => std_logic_vector(ROW_B_SIG),
						ROW_C => std_logic_vector(ROW_C_SIG),
						ROW_D => std_logic_vector(ROW_0_SIG),
						ROW_E => std_logic_vector(ROW_1_SIG),
						ROW_W => std_logic_vector(ROW_W_SIG),
						ADDR_W => ADDRESS_W_SIG,
						INPUT_W => DATA_TO_W_SIG,
						W_EN => W_EN_SIG,
						OPCODE_0_IN => OPCODE_0_PASS,
						OPCODE_1_IN => OPCODE_1_PASS,
						OPCODE_2_IN => OPCODE_2_PASS,
						OPCODE_3_IN => OPCODE_3_PASS,
						OPCODE_4_IN => OPCODE_4_PASS,
						OPCODE_5_IN => OPCODE_5_PASS,
						OUTPUT_A => DATA_OUT_A_SIG,
						OUTPUT_B => DATA_OUT_B_SIG,
						OUTPUT_C => DATA_OUT_C_SIG,
						OUTPUT_D => DATA_OUT_0_SIG,
						OUTPUT_E => DATA_OUT_1_SIG,
						WAIT_FLAG => STALL_W
						);
	resolve : hazard_resolution PORT MAP (
						CLK => CLK,
						RESET_n => RESET_n,
						ADDR_0_IN => ADDRESS_A,
						ADDR_1_IN => ADDRESS_B,
						ADDR_2_IN => ADDRESS_C,
						ADDR_3_IN => ADDRESS_0,
						ADDR_4_IN => ADDRESS_1,
						ADDR_5_IN => ADDRESS_W,
						ADDR_0_OUT => ADDRESS_A_SIG,
						ADDR_1_OUT => ADDRESS_B_SIG,
						ADDR_2_OUT => ADDRESS_C_SIG,
						ADDR_3_OUT => ADDRESS_0_SIG,
						ADDR_4_OUT => ADDRESS_1_SIG,
						ADDR_5_OUT => ADDRESS_W_SIG,
						DATA_0_FROM_RAM => DATA_OUT_A_SIG,
						DATA_1_FROM_RAM => DATA_OUT_B_SIG,
						DATA_2_FROM_RAM => DATA_OUT_C_SIG,
						DATA_3_FROM_RAM => DATA_OUT_0_SIG,
						DATA_4_FROM_RAM => DATA_OUT_1_SIG,
						DATA_0_OUTPUT => DATA_OUT_A_RAW,
						DATA_1_OUTPUT => DATA_OUT_B_RAW,
						DATA_2_OUTPUT => DATA_OUT_C_RAW,
						DATA_3_OUTPUT => DATA_OUT_0_RAW,
						DATA_4_OUTPUT => DATA_OUT_1_RAW,
						W_EN => W_EN
						);
	

	DATA_TO_W_SIG <= DATA_TO_W;
	W_EN_SIG <= W_EN;
	
	OPCODE_0_PASS <= OPCODE_0_SIG(5 downto 1) & (OPCODE_0_SIG(0) and W_EN_SIG);
	OPCODE_1_PASS <= OPCODE_1_SIG(5 downto 1) & (OPCODE_1_SIG(0) and W_EN_SIG);
	OPCODE_2_PASS <= OPCODE_2_SIG(5 downto 1) & (OPCODE_2_SIG(0) and W_EN_SIG);
	OPCODE_3_PASS <= OPCODE_3_SIG(5 downto 1) & (OPCODE_3_SIG(0) and W_EN_SIG);
	OPCODE_4_PASS <= OPCODE_4_SIG(5 downto 1) & (OPCODE_4_SIG(0) and W_EN_SIG);
	OPCODE_5_PASS <= OPCODE_5_SIG(5 downto 1) & (OPCODE_5_SIG(0) and W_EN_SIG);

	DATA_OUT_A <= DATA_OUT_A_RAW(31 DOWNTO 0);
	DATA_OUT_B <= DATA_OUT_B_RAW(31 DOWNTO 0);
	DATA_OUT_C <= DATA_OUT_C_RAW(31 DOWNTO 0);
	DATA_OUT_0 <= DATA_OUT_0_RAW(31 DOWNTO 0);
	DATA_OUT_1 <= DATA_OUT_1_RAW(31 DOWNTO 0);
	
	stalling : process (DATA_OUT_A_RAW, DATA_OUT_B_RAW, DATA_OUT_C_RAW, DATA_OUT_0_RAW, DATA_OUT_1_RAW,
								ADDRESS_A, ADDRESS_B, ADDRESS_C, ADDRESS_0, ADDRESS_1)
		begin
		
			if (DATA_OUT_A_RAW(64) = '1' AND DATA_OUT_A_RAW(63 downto 32) = ADDRESS_A) then
				STALL_A <= '0';
			else
				STALL_A <= '1';
			end if;
			
			if (DATA_OUT_B_RAW(64) = '1' AND DATA_OUT_B_RAW(63 downto 32) = ADDRESS_B) then
				STALL_B <= '0';
			else
				STALL_B <= '1';
			end if;
			
			if (DATA_OUT_C_RAW(64) = '1' AND DATA_OUT_C_RAW(63 downto 32) = ADDRESS_C) then
				STALL_C <= '0';
			else
				STALL_C <= '1';
			end if;
			
			if (DATA_OUT_0_RAW(64) = '1' AND DATA_OUT_0_RAW(63 downto 32) = ADDRESS_0) then
				STALL_0 <= '0';
			else
				STALL_0 <= '1';
			end if;
			
			if (DATA_OUT_1_RAW(64) = '1' AND DATA_OUT_1_RAW(63 downto 32) = ADDRESS_1) then
				STALL_1 <= '0';
			else
				STALL_1 <= '1';
			end if;
	end process;
--	process (DATA_OUT_A_SIG, DATA_OUT_B_SIG, DATA_OUT_C_SIG,
--				DATA_OUT_0_SIG, DATA_OUT_1_SIG, ADDRESS_A_SIG,
--				ADDRESS_B_SIG, ADDRESS_C_SIG, ADDRESS_0_SIG,
--				ADDRESS_1_SIG, CLK, DATA_OUT_0_BUFF, DATA_OUT_1_BUFF,
--				DATA_OUT_A_BUFF, DATA_OUT_B_BUFF, DATA_OUT_C_BUFF)
--		begin
--		
--		if (DATA_OUT_A_SIG(64) = '1' AND DATA_OUT_A_SIG(63 DOWNTO 32) = ADDRESS_A_SIG) then
--			DATA_OUT_A <= DATA_OUT_A_SIG (31 DOWNTO 0);
--			if (rising_edge(CLK)) then
--				DATA_OUT_A_BUFF <= DATA_OUT_A_SIG;
--			end if;
--			STALL_A <= '0';
--		elsif (DATA_OUT_A_BUFF(64) = '1' and DATA_OUT_A_BUFF(63 DOWNTO 32) = ADDRESS_A_SIG) then
--			DATA_OUT_A <= DATA_OUT_A_BUFF (31 DOWNTO 0);
--			STALL_A <= '0';
--		else
--			DATA_OUT_A <= DATA_OUT_A_BUFF (31 DOWNTO 0);
--			STALL_A <= '1';
--		end if;
--
--		if (DATA_OUT_B_SIG(64) = '1' AND DATA_OUT_B_SIG(63 DOWNTO 32) = ADDRESS_B_SIG) then
--			DATA_OUT_B <= DATA_OUT_B_SIG (31 DOWNTO 0);
--			if (rising_edge(CLK)) then
--				DATA_OUT_B_BUFF <= DATA_OUT_B_SIG;
--			end if;
--			STALL_B <= '0';
--		elsif (DATA_OUT_B_BUFF(64) = '1' and DATA_OUT_B_BUFF(63 DOWNTO 32) = ADDRESS_B_SIG) then
--			DATA_OUT_B <= DATA_OUT_B_BUFF (31 DOWNTO 0);
--			STALL_B <= '0';
--		else
--			DATA_OUT_B <= DATA_OUT_B_BUFF (31 DOWNTO 0);
--			STALL_B <= '1';
--		end if;
--		
--		if (DATA_OUT_C_SIG(64) = '1' AND DATA_OUT_C_SIG(63 DOWNTO 32) = ADDRESS_C_SIG) then
--			DATA_OUT_C <= DATA_OUT_C_SIG (31 DOWNTO 0);
--			if (rising_edge(CLK)) then
--				DATA_OUT_C_BUFF <= DATA_OUT_C_SIG;
--			end if;
--			STALL_C <= '0';
--		elsif (DATA_OUT_C_BUFF(64) = '1' and DATA_OUT_C_BUFF(63 DOWNTO 32) = ADDRESS_C_SIG) then
--			DATA_OUT_C <= DATA_OUT_C_BUFF (31 DOWNTO 0);
--			STALL_C <= '0';
--		else
--			DATA_OUT_C <= DATA_OUT_C_BUFF (31 DOWNTO 0);
--			STALL_C <= '1';
--		end if;
--		
--		if (DATA_OUT_0_SIG(64) = '1' AND DATA_OUT_0_SIG(63 DOWNTO 32) = ADDRESS_0_SIG) then
--			DATA_OUT_0 <= DATA_OUT_0_SIG (31 DOWNTO 0);
--			if (rising_edge(CLK)) then
--				DATA_OUT_0_BUFF <= DATA_OUT_0_SIG;
--			end if;
--			STALL_0 <= '0';
--		elsif (DATA_OUT_0_BUFF(64) = '1' and DATA_OUT_0_BUFF(63 DOWNTO 32) = ADDRESS_0_SIG) then
--			DATA_OUT_0 <= DATA_OUT_0_BUFF (31 DOWNTO 0);
--			STALL_0 <= '0';
--		else
--			DATA_OUT_0 <= DATA_OUT_0_BUFF (31 DOWNTO 0);
--			STALL_0 <= '1';
--		end if;
--		
--		if (DATA_OUT_1_SIG(64) = '1' AND DATA_OUT_1_SIG(63 DOWNTO 32) = ADDRESS_1_SIG) then
--			DATA_OUT_1 <= DATA_OUT_1_SIG (31 DOWNTO 0);
--			if (rising_edge(CLK)) then
--				DATA_OUT_1_BUFF <= DATA_OUT_1_SIG;
--			end if;
--			STALL_1 <= '0';
--		elsif (DATA_OUT_1_BUFF(64) = '1' and DATA_OUT_1_BUFF(63 DOWNTO 32) = ADDRESS_1_SIG) then
--			DATA_OUT_1 <= DATA_OUT_1_BUFF (31 DOWNTO 0);
--			STALL_1 <= '0';
--		else
--			DATA_OUT_1 <= DATA_OUT_1_BUFF (31 DOWNTO 0);
--			STALL_1 <= '1';
--		end if;
--		
--	end process;
	
	process (STALL_A, STALL_B, STALL_C,
				STALL_0, STALL_1, STALL_W) 
		begin
		
		if (STALL_A = '1' OR
			 STALL_B = '1' OR
			 STALL_C = '1' OR
			 STALL_0 = '1' OR
			 STALL_1 = '1' OR
			 STALL_W = '1') then
			 
			STALL <= '1';
		else
			STALL <= '0';
		end if;
	end process;
	
end behav;