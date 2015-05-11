library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FLOW is
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
end;

architecture flow of FLOW is
	
	component SELECTOR
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
	end component;
	
	component tristate
		PORT(
			my_in  : in std_logic_vector(9 downto 0);
			sel 	 : in std_logic;
			my_out : out std_logic_vector(9 downto 0)
			);
	end component;
	
	signal sel_a0 : std_logic;
	signal sel_b0 : std_logic;
	signal sel_c0 : std_logic;
	signal sel_d0 : std_logic;
	signal sel_e0 : std_logic;
	signal sel_w0 : std_logic;
	signal sel_a1 : std_logic;
	signal sel_b1 : std_logic;
	signal sel_c1 : std_logic;
	signal sel_d1 : std_logic;
	signal sel_e1 : std_logic;
	signal sel_w1 : std_logic;
	
begin
	select_address : SELECTOR PORT MAP (
										CLK => CLK,
										RESET_n => RESET_n,
										OPCODE => OPCODE,
										EQUALITY => EQUALITY,
										SEL_A_0 => sel_a0,
										SEL_B_0 => sel_b0,
										SEL_C_0 => sel_c0,
										SEL_D_0 => sel_d0,
										SEL_E_0 => sel_e0,
										SEL_W_0 => sel_w0,
										SEL_A_1 => sel_a1,
										SEL_B_1 => sel_b1,
										SEL_C_1 => sel_c1,
										SEL_D_1 => sel_d1,
										SEL_E_1 => sel_e1,
										SEL_W_1 => sel_w1
										);
												
	TRI_0_PORT_A : tristate PORT MAP (
												my_in => ROW_A,
												sel => sel_a0,
												my_out => ADDRESS_A
												);
	TRI_1_PORT_A : tristate PORT MAP (
												my_in => ROW_B,
												sel => sel_b0,
												my_out => ADDRESS_A
												);
	TRI_2_PORT_A : tristate PORT MAP (
												my_in => ROW_C,
												sel => sel_c0,
												my_out => ADDRESS_A
												);
	TRI_3_PORT_A : tristate PORT MAP (
												my_in => ROW_D,
												sel => sel_d0,
												my_out => ADDRESS_A
												);
	TRI_4_PORT_A : tristate PORT MAP (
												my_in => ROW_E,
												sel => sel_e0,
												my_out => ADDRESS_A
												);
	TRI_5_PORT_A : tristate PORT MAP (
												my_in => ROW_W,
												sel => sel_w0,
												my_out => ADDRESS_A
												);
	TRI_0_PORT_B : tristate PORT MAP (
												my_in => ROW_A,
												sel => sel_a1,
												my_out => ADDRESS_B
												);
	TRI_1_PORT_B : tristate PORT MAP (
												my_in => ROW_B,
												sel => sel_b1,
												my_out => ADDRESS_B
												);
	TRI_2_PORT_B : tristate PORT MAP (
												my_in => ROW_C,
												sel => sel_c1,
												my_out => ADDRESS_B
												);
	TRI_3_PORT_B : tristate PORT MAP (
												my_in => ROW_D,
												sel => sel_d1,
												my_out => ADDRESS_B
												);
	TRI_4_PORT_B : tristate PORT MAP (
												my_in => ROW_E,
												sel => sel_e1,
												my_out => ADDRESS_B
												);
	TRI_5_PORT_B : tristate PORT MAP (
												my_in => ROW_W,
												sel => sel_w1,
												my_out => ADDRESS_B
												);
	WREN_A <= '0';
	process (HAZARD, OPCODE) begin --addred this if block
		if (HAZARD = '1') then
			WREN_B <= '0';
		else
			WREN_B <= OPCODE(0); --used to be just this line
		end if;
	end process;
	SEL_VECTOR <= sel_a0 & sel_a1 & sel_b0 & sel_b1 & sel_c0 & sel_c1 & sel_d0 & sel_d1 & sel_e0 & sel_e1;
end;