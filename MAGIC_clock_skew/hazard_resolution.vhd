library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_resolution is
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
end hazard_resolution;

architecture resolve of hazard_resolution is

	type STATE_TYPE is (normal, hazard, hazard_1, hazard_1_delay, hazard_2, hazard_2_delay, INIT);
	signal state : STATE_TYPE;
	
	signal sum_0 : unsigned(2 downto 0);
	signal sum_1 : unsigned(2 downto 0);
	signal sum_2 : unsigned(2 downto 0);
	signal sum_3 : unsigned(2 downto 0);
	signal sum_4 : unsigned(2 downto 0);
	signal sum_5 : unsigned(2 downto 0);
	
	signal col_0 : unsigned(31 downto 0);
	signal col_1 : unsigned(31 downto 0);
	signal col_2 : unsigned(31 downto 0);
	signal col_3 : unsigned(31 downto 0);
	signal col_4 : unsigned(31 downto 0);
	signal col_5 : unsigned(31 downto 0);
	
	signal op_0 : std_logic_vector(5 downto 0);
	signal op_1 : std_logic_vector(5 downto 0);
	signal op_2 : std_logic_vector(5 downto 0);
	signal op_3 : std_logic_vector(5 downto 0);
	signal op_4 : std_logic_vector(5 downto 0);
	signal op_5 : std_logic_vector(5 downto 0);
	
	signal op_0_pass : std_logic_vector(5 downto 0);
	signal op_1_pass : std_logic_vector(5 downto 0);
	signal op_2_pass : std_logic_vector(5 downto 0);
	signal op_3_pass : std_logic_vector(5 downto 0);
	signal op_4_pass : std_logic_vector(5 downto 0);
	signal op_5_pass : std_logic_vector(5 downto 0);
	
	signal DATA_0_BUFF : std_logic_vector(64 downto 0);
	signal DATA_1_BUFF : std_logic_vector(64 downto 0);
	signal DATA_4_BUFF : std_logic_vector(64 downto 0);

	
	function sum (X : std_logic_vector)
						return unsigned is
		variable TMP : unsigned(2 downto 0);
	begin
		TMP := "000";
		for J in X'range loop
			if (X(J) = '1') then
				TMP := TMP + 1;
			end if;
		end loop;
		return TMP;
	end sum;
	
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
	
begin

	hazard_ops :  create_opcode PORT MAP (
						COL_A => col_0(2 downto 0),
						COL_B => col_1(2 downto 0),
						COL_C => col_2(2 downto 0),
						COL_D => col_3(2 downto 0),
						COL_E => col_4(2 downto 0),
						COL_W => col_5(2 downto 0),
						OPCODE_0 => op_0,
						OPCODE_1 => op_1,
						OPCODE_2 => op_2,
						OPCODE_3 => op_3,
						OPCODE_4 => op_4,
						OPCODE_5 => op_5
						);
						
-----state change logic
	process (CLK, RESET_n, sum_0, sum_1, sum_2, sum_3, sum_4, sum_5)
	begin
		if (RESET_n = '0') then
			state <= INIT;
		elsif (rising_edge(CLK)) then
			case state is
				when INIT =>
					state <= normal;
				when normal =>					
					if ((sum_0 < 3) and (sum_1 < 3) and (sum_2 < 3) and (sum_3 < 3) and (sum_4 < 3) and (sum_5 < 3)) then
						state <= normal;
					else
						state <= hazard;
					end if;
				when hazard =>
					state <= hazard_1;
				when hazard_1 =>
					state <= hazard_1_delay;
				when hazard_1_delay=>
					state <= hazard_2;
				when hazard_2 =>
					state <= hazard_2_delay;
				when hazard_2_delay =>
					state <= normal;
			end case;
		end if;
	end process;
-----state output control logic (combinational);		
	process (state, ADDR_0_IN, ADDR_1_IN, ADDR_2_IN, ADDR_3_IN, ADDR_4_IN, ADDR_5_IN, sum_0, sum_1, sum_2, sum_3, sum_4, sum_5,
				DATA_0_FROM_RAM, DATA_1_FROM_RAM, DATA_2_FROM_RAM, DATA_3_FROM_RAM, DATA_4_FROM_RAM, DATA_0_BUFF, DATA_1_BUFF, DATA_4_BUFF)
	begin
		case state is
			when INIT =>
				ADDR_0_OUT <= ADDR_0_IN;
				ADDR_1_OUT <= ADDR_1_IN;
				ADDR_2_OUT <= ADDR_2_IN;
				ADDR_3_OUT <= ADDR_3_IN;
				ADDR_4_OUT <= ADDR_4_IN;
				ADDR_5_OUT <= ADDR_5_IN;
			when normal =>
				if ((sum_0 < 3) and (sum_1 < 3) and (sum_2 < 3) and (sum_3 < 3) and (sum_4 < 3) and (sum_5 < 3)) then
					ADDR_0_OUT <= ADDR_0_IN;
					ADDR_1_OUT <= ADDR_1_IN;
					ADDR_2_OUT <= ADDR_2_IN;
					ADDR_3_OUT <= ADDR_3_IN;
					ADDR_4_OUT <= ADDR_4_IN;
					ADDR_5_OUT <= ADDR_5_IN;
					DATA_0_OUTPUT <= DATA_0_FROM_RAM;
					DATA_1_OUTPUT <= DATA_1_FROM_RAM;
					DATA_2_OUTPUT <= DATA_2_FROM_RAM;
					DATA_3_OUTPUT <= DATA_3_FROM_RAM;
					DATA_4_OUTPUT <= DATA_4_FROM_RAM;
				else
					ADDR_0_OUT <= ADDR_0_IN;
					ADDR_1_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
					ADDR_2_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
					ADDR_3_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
					ADDR_4_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
					ADDR_5_OUT <= ADDR_5_IN;
					DATA_0_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
					DATA_1_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
					DATA_2_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
					DATA_3_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
					DATA_4_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				end if;
			when hazard =>
				ADDR_0_OUT <= ADDR_0_IN;
				ADDR_1_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_2_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_3_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_4_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_5_OUT <= ADDR_5_IN;
				DATA_0_BUFF <= DATA_0_FROM_RAM;
				DATA_0_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_1_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_2_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_3_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_4_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
			when hazard_1 =>
				ADDR_0_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_1_OUT <= ADDR_1_IN;
				ADDR_2_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_3_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_4_OUT <= ADDR_4_IN;
				ADDR_5_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_0_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_1_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_2_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_3_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_4_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
			when hazard_1_delay =>
				ADDR_0_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_1_OUT <= ADDR_1_IN;
				ADDR_2_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_3_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_4_OUT <= ADDR_4_IN;
				ADDR_5_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_1_BUFF <= DATA_1_FROM_RAM;
				DATA_4_BUFF <= DATA_4_FROM_RAM;
				DATA_0_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_1_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_2_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_3_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_4_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
			when hazard_2 =>
				ADDR_0_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_1_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_2_OUT <= ADDR_2_IN;
				ADDR_3_OUT <= ADDR_3_IN;
				ADDR_4_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_5_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_0_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_1_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_2_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_3_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_4_OUTPUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
			when hazard_2_delay =>
				ADDR_0_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_1_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_2_OUT <= ADDR_2_IN;
				ADDR_3_OUT <= ADDR_3_IN;
				ADDR_4_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				ADDR_5_OUT <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
				DATA_0_OUTPUT <= DATA_0_BUFF;
				DATA_1_OUTPUT <= DATA_1_BUFF;
				DATA_2_OUTPUT <= DATA_2_FROM_RAM;
				DATA_3_OUTPUT <= DATA_3_FROM_RAM;
				DATA_4_OUTPUT <= DATA_4_BUFF;
		end case;
	end process;
	
----------async stuff
	sum_0 <= sum(op_0_pass);
	sum_1 <= sum(op_1_pass);
	sum_2 <= sum(op_2_pass);
	sum_3 <= sum(op_3_pass);
	sum_4 <= sum(op_4_pass);
	sum_5 <= sum(op_5_pass);
	col_0 <= unsigned(ADDR_0_IN) mod 6;
	col_1 <= unsigned(ADDR_1_IN) mod 6;
	col_2 <= unsigned(ADDR_2_IN) mod 6;
	col_3 <= unsigned(ADDR_3_IN) mod 6;
	col_4 <= unsigned(ADDR_4_IN) mod 6;
	col_5 <= unsigned(ADDR_5_IN) mod 6;
	op_0_pass<= op_0(5 downto 1) & (op_0(0) and W_EN);
	op_1_pass<= op_1(5 downto 1) & (op_1(0) and W_EN);
	op_2_pass<= op_2(5 downto 1) & (op_2(0) and W_EN);
	op_3_pass<= op_3(5 downto 1) & (op_3(0) and W_EN);
	op_4_pass<= op_4(5 downto 1) & (op_4(0) and W_EN);
	op_5_pass<= op_5(5 downto 1) & (op_5(0) and W_EN);


	
end resolve;
		