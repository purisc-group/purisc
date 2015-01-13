library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAMS is
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
end;




architecture CACHE of RAMS is

	signal OPCODE_SIG	: std_logic_vector(5 downto 0):= "000000";

	signal WRITE_DATA : std_logic_vector(64 downto 0);

	signal RESET 		: std_logic;
	
	signal CLK 			: std_logic;
	
	signal CLK_LOCKED : std_logic;
	
	signal locked		: std_logic;

--addresses for all 6 banks of DPRAMS
	signal addr_a : std_logic_vector(12 downto 0);
	signal addr_b : std_logic_vector(12 downto 0);

--write data for all 6 banks	
	signal data_a : std_logic_vector (64 downto 0);
	signal data_b : std_logic_vector (64 downto 0);

--write enables
	signal wren_a : std_logic := '0';
	signal wren_b : std_logic := '0';
	
	signal rden_a : std_logic := '1';
	signal rden_b : std_logic := '1';

--returned data from all 6 banks
	signal read_data_a : std_logic_vector (64 downto 0);
	signal read_data_b : std_logic_vector (64 downto 0);
	
--select signals
	signal sel_A_0 : std_logic;
	signal sel_B_0 : std_logic;
	signal sel_C_0 : std_logic;
	signal sel_D_0 : std_logic;
	signal sel_E_0 : std_logic;
	signal sel_W_0 : std_logic;
	signal sel_A_1 : std_logic;
	signal sel_B_1 : std_logic;
	signal sel_C_1 : std_logic;
	signal sel_D_1 : std_logic;
	signal sel_E_1 : std_logic;
	signal sel_W_1 : std_logic;
	
--declaring a ram block as a component
	component DPRAM_BLOCK
		PORT
	(
		aclr			: IN STD_LOGIC  := '0';
		address_a	: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		address_b	: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		clock			: IN STD_LOGIC  := '1';
		data_a		: IN STD_LOGIC_VECTOR (64 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (64 DOWNTO 0);
		rden_a		: IN STD_LOGIC  := '1';
		rden_b		: IN STD_LOGIC  := '1';
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a			: OUT STD_LOGIC_VECTOR (64 DOWNTO 0);
		q_b			: OUT STD_LOGIC_VECTOR (64 DOWNTO 0)
	);
	end component;
--declaring a PLL to overclock RAM
--	component PLL
--		PORT
--	(
--		areset		: IN STD_LOGIC  := '0';
--		inclk0		: IN STD_LOGIC  := '0';
--		c0		: OUT STD_LOGIC ;
--		locked		: OUT STD_LOGIC 
--	);
--	end component;

--declaring tristate buffer as a component
	component tristate
		PORT
	(
		my_in  : in std_logic_vector(12 downto 0);
		sel 	 : in std_logic;
		my_out : out std_logic_vector(12 downto 0)
	);
	end component;
	
	begin
--*************************************
--driving the PPL
--*************************************
--		PLL_0 : PLL PORT MAP (
--									areset => RESET,
--									inclk0 => clock_base,
--									c0 => CLK,
--									locked => locked
--									);
--*************************************	
--instantiating ram
--*************************************
		RAM_0 : DPRAM_BLOCK PORT MAP (
												aclr	 => RESET,
												address_a	 => addr_a,
												address_b	 => addr_b,
												clock	 => clock_base,
												data_a	 => data_a,
												data_b	 => data_b,
												wren_a	 => wren_a,
												wren_b	 => wren_b,
												rden_a	 => rden_a,
												rden_b	 => rden_b,
												q_a	 => read_data_a,
												q_b	 => read_data_b
											); 			
--*************************************
--instantiating tristate buffers
--*************************************
		TRI_0_PORT_A : tristate PORT MAP (
													my_in => ROW_A,
													sel => sel_A_0,
													my_out => addr_a
													);
		TRI_1_PORT_A : tristate PORT MAP (
													my_in => ROW_B,
													sel => sel_B_0,
													my_out => addr_a
													);
		TRI_2_PORT_A : tristate PORT MAP (
													my_in => ROW_C,
													sel => sel_C_0,
													my_out => addr_a
													);
		TRI_3_PORT_A : tristate PORT MAP (
													my_in => ROW_D,
													sel => sel_D_0,
													my_out => addr_a
													);
		TRI_4_PORT_A : tristate PORT MAP (
													my_in => ROW_E,
													sel => sel_E_0,
													my_out => addr_a
													);
		TRI_5_PORT_A : tristate PORT MAP (
													my_in => ROW_W,
													sel => sel_W_0,
													my_out => addr_a
													);
		TRI_0_PORT_B : tristate PORT MAP (
													my_in => ROW_A,
													sel => sel_A_1,
													my_out => addr_b
													);
		TRI_1_PORT_B : tristate PORT MAP (
													my_in => ROW_B,
													sel => sel_B_1,
													my_out => addr_b
													);
		TRI_2_PORT_B : tristate PORT MAP (
													my_in => ROW_C,
													sel => sel_C_1,
													my_out => addr_b
													);
		TRI_3_PORT_B : tristate PORT MAP (
													my_in => ROW_D,
													sel => sel_D_1,
													my_out => addr_b
													);
		TRI_4_PORT_B : tristate PORT MAP (
													my_in => ROW_E,
													sel => sel_E_1,
													my_out => addr_b
													);
		TRI_5_PORT_B : tristate PORT MAP (
													my_in => ROW_W,
													sel => sel_W_1,
													my_out => addr_b
													);

--***********************************
--ASYNC SIGNALS 
--***********************************
		process (RESET_n, OPCODE_SIG) begin
			if (RESET_n = '0') then
				sel_A_0 <= '0';
				sel_B_0 <= '0';
				sel_C_0 <= '0';
				sel_D_0 <= '0';
				sel_E_0 <= '0';
				sel_W_0 <= '0';
				
				sel_W_1 <= '0';
				sel_E_1 <= '0';
				sel_D_1 <= '0';
				sel_C_1 <= '0';
				sel_B_1 <= '0';
				sel_A_1 <= '0';
			else 
				sel_A_0 <= OPCODE_SIG(5);
				sel_B_0 <= OPCODE_SIG(4) and (not OPCODE_SIG(5));
				sel_C_0 <= OPCODE_SIG(3) and (not (OPCODE_SIG(5) or OPCODE_SIG(4)));
				sel_D_0 <= OPCODE_SIG(2) and (not (OPCODE_SIG(5) or OPCODE_SIG(4) or OPCODE_SIG(3)));
				sel_E_0 <= OPCODE_SIG(1) and (not (OPCODE_SIG(5) or OPCODE_SIG(4) or OPCODE_SIG(3) or OPCODE_SIG(2)));
				sel_W_0 <= OPCODE_SIG(0) and (not (OPCODE_SIG(5) or OPCODE_SIG(4) or OPCODE_SIG(3) or OPCODE_SIG(2) or OPCODE_SIG(1)));
				
				sel_W_1 <= OPCODE_SIG(0);
				sel_E_1 <= OPCODE_SIG(1) and (not OPCODE_SIG(0));
				sel_D_1 <= OPCODE_SIG(2) and (not (OPCODE_SIG(1) or OPCODE_SIG(0)));
				sel_C_1 <= OPCODE_SIG(3) and (not (OPCODE_SIG(2) or OPCODE_SIG(1) or OPCODE_SIG(0)));
				sel_B_1 <= OPCODE_SIG(4) and (not (OPCODE_SIG(3) or OPCODE_SIG(2) or OPCODE_SIG(1) or OPCODE_SIG(0)));
				sel_A_1 <= OPCODE_SIG(5) and (not (OPCODE_SIG(4) or OPCODE_SIG(3) or OPCODE_SIG(2) or OPCODE_SIG(1) or OPCODE_SIG(0)));
			end if;
		end process;
		
		rden_a <= not wren_a;
		rden_b <= not wren_b;
		
		data_a <= WRITE_DATA;
		data_b <= WRITE_DATA;

		RESET <= not RESET_n;
		WRITE_DATA <= ('1' & ADDR_W & INPUT_W);
	
		
--		lock_clock : process (CLK, locked) begin
--			if (locked = '1') then
--				CLK_LOCKED <= CLK;
--			else
--				CLK_LOCKED <= '0';
--			end if;
--		end process;
		
		write_slect : process (W_EN, sel_W_0, sel_W_1) begin
			if (sel_W_1 = '1') then
				wren_b <= W_EN;
				wren_a <= '0';
			elsif (sel_W_0 = '1') then
				wren_a <= W_EN;
				wren_b <= '0';
			else
				wren_a <= '0';
				wren_b <= '0';
			end if;
		end process;
	
		STALL <= (OPCODE_SIG(4) xor (sel_B_0 or sel_B_1)) or (OPCODE_SIG(3) xor (sel_C_0 or sel_C_1)) or
					(OPCODE_SIG(2) xor (sel_D_0 or sel_D_1)) or (OPCODE_SIG(1) xor (sel_E_0 or sel_E_1));
		
		OPCODE_RET <= ('0') & (OPCODE_SIG(4) xor (sel_B_0 or sel_B_1)) & (OPCODE_SIG(3) xor (sel_C_0 or sel_C_1)) & 
							(OPCODE_SIG(2) xor (sel_D_0 or sel_D_1)) & (OPCODE_SIG(1) xor (sel_E_0 or sel_E_1)) & ('0');
		OPCODE_SIG <= OPCODE;
		OUTPUT_0 <= read_data_a;
		OUTPUT_1 <= read_data_b;
		SEL_B <= sel_B_0;
		SEL_C <= sel_C_0;
		SEL_D <= sel_D_0;
		SEL_E <= sel_E_0;

end CACHE;