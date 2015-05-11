library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SELECTOR_global is
	PORT(
			CLK	: IN STD_LOGIC;
			RESET_n : IN STD_LOGIC;
			OPCODE : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
			EQUALITY : OUT STD_LOGIC;
			sel_A_0 : OUT STD_LOGIC;
			sel_B_0 : OUT STD_LOGIC;
			sel_C_0 : OUT STD_LOGIC;
			sel_D_0 : OUT STD_LOGIC;
			sel_E_0 : OUT STD_LOGIC;
			sel_W_0 : OUT STD_LOGIC;
			sel_A_1 : OUT STD_LOGIC;
			sel_B_1 : OUT STD_LOGIC;
			sel_C_1 : OUT STD_LOGIC;
			sel_D_1 : OUT STD_LOGIC;
			sel_E_1 : OUT STD_LOGIC;
			sel_W_1 : OUT STD_LOGIC
			);
end;

architecture input_select of SELECTOR_global is

	signal opcode_sig : std_logic_vector (5 downto 0) := "000000";
	signal serviced_vector : std_logic_vector	(5 downto 0) := "000000";
	signal equality_vector : std_logic_vector (5 downto 0) := "111111";
	signal equality_extend : std_logic_vector (5 downto 0) := "111111";
	signal equality_signal : std_logic := '1';
	signal equality_buff : std_logic;
	signal to_service_next : std_logic_vector (5 downto 0) := "000000";
	signal hazard_to_mask : std_logic_vector (5 downto 0) := "111111";
	signal hazard_mask : std_logic_vector (5 downto 0) := "111111";
	
	signal SEL_A_0_sig : std_logic;
	signal SEL_B_0_sig : std_logic;
	signal SEL_C_0_sig : std_logic;
	signal SEL_D_0_sig : std_logic;
	signal SEL_E_0_sig : std_logic;
	signal SEL_W_0_sig : std_logic;
	signal SEL_A_1_sig : std_logic;
	signal SEL_B_1_sig : std_logic;
	signal SEL_C_1_sig : std_logic;
	signal SEL_D_1_sig : std_logic;
	signal SEL_E_1_sig : std_logic;
	signal SEL_W_1_sig : std_logic;

begin 
	sel_A_0_sig <= opcode_sig(5) and RESET_n;
	sel_B_0_sig  <= opcode_sig(4) and (not opcode_sig(5)) and RESET_n;
	sel_C_0_sig  <= opcode_sig(3) and (not (opcode_sig(5) or opcode_sig(4))) and RESET_n;
	sel_D_0_sig  <= opcode_sig(2) and (not (opcode_sig(5) or opcode_sig(4) or opcode_sig(3))) and RESET_n;
	sel_E_0_sig  <= opcode_sig(1) and (not (opcode_sig(5) or opcode_sig(4) or opcode_sig(3) or opcode_sig(2))) and RESET_n;
	sel_W_0_sig  <= opcode_sig(0) and (not (opcode_sig(5) or opcode_sig(4) or opcode_sig(3) or opcode_sig(2) or opcode_sig(1))) and RESET_n;
	
	sel_W_1_sig  <= opcode_sig(0) and RESET_n;
	sel_E_1_sig  <= opcode_sig(1) and (not opcode_sig(0)) and RESET_n;
	sel_D_1_sig  <= opcode_sig(2) and (not (opcode_sig(1) or opcode_sig(0))) and RESET_n;
	sel_C_1_sig  <= opcode_sig(3) and (not (opcode_sig(2) or opcode_sig(1) or opcode_sig(0))) and RESET_n;
	sel_B_1_sig  <= opcode_sig(4) and (not (opcode_sig(3) or opcode_sig(2) or opcode_sig(1) or opcode_sig(0))) and RESET_n;
	sel_A_1_sig  <= opcode_sig(5) and (not (opcode_sig(4) or opcode_sig(3) or opcode_sig(2) or opcode_sig(1) or opcode_sig(0))) and RESET_n;
	
--	opcode_sig <= OPCODE and hazard_mask;
--	opcode_sig <= OPCODE;
	opcode_sig <= (OPCODE(5) and hazard_mask(5)) & (OPCODE(4) and hazard_mask(4)) & (OPCODE(3) and hazard_mask(3)) &
						(OPCODE(2) and hazard_mask(2)) & (OPCODE(1) and hazard_mask(1)) & (OPCODE(0) and hazard_mask(0));
	
	serviced_vector <= (sel_A_0_sig  or sel_A_1_sig ) &
								(sel_B_0_sig  or sel_B_1_sig ) &
								(sel_C_0_sig  or sel_C_1_sig ) &
								(sel_D_0_sig  or sel_D_1_sig ) &
								(sel_E_0_sig  or sel_E_1_sig ) &
								(sel_W_0_sig  or sel_W_1_sig );
								
	to_service_next <= serviced_vector xor opcode_sig;
								
	equality_vector <= opcode_sig xor (not serviced_vector);
	
	hazard_to_mask <= to_service_next xor equality_extend;
	
	hazard_latching : process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			hazard_mask <= "111111";
		elsif (rising_edge(CLK)) then
			hazard_mask <= hazard_to_mask;
		end if;
	end process;
	
	equality_extend <= equality_signal & equality_signal & equality_signal & equality_signal & equality_signal & equality_signal;
	
	equality_signal <= equality_vector(5) and equality_vector(4) and equality_vector(3) and equality_vector(2) and equality_vector(1) and equality_vector(0);
	
--	derp : process (CLK) begin
--		if (falling_edge(CLK)) then
--			equality_buff <= equality_signal;
--		end if;
--	end process;
	
	EQUALITY <= equality_signal;	--used to be equality_signal
	
	SEL_A_0 <= SEL_A_0_sig;
	SEL_B_0 <= SEL_B_0_sig;
	SEL_C_0 <= SEL_C_0_sig;
	SEL_D_0 <= SEL_D_0_sig;
	SEL_E_0 <= SEL_E_0_sig;
	SEL_W_0 <= SEL_W_0_sig;
	
	SEL_A_1 <= SEL_A_1_sig;
	SEL_B_1 <= SEL_B_1_sig;
	SEL_C_1 <= SEL_C_1_sig;
	SEL_D_1 <= SEL_D_1_sig;
	SEL_E_1 <= SEL_E_1_sig;
	SEL_W_1 <= SEL_W_1_sig;
end;