library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Compute_Group_tb is
end;

architecture testing of Compute_Group_tb is
	component Compute_Group
		PORT (
				ADDRESS_A  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
				ADDRESS_B  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
				ADDRESS_C  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
				ADDRESS_0  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
				ADDRESS_1  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
				ADDRESS_W  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
				ADDRESS_IO : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				DATA_IO	  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				IO_ENABLE  : IN STD_LOGIC;
				DATA_TO_W  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
				W_EN		  : OUT STD_LOGIC;
				CLK		  : IN STD_LOGIC;
				RESET_n    : IN STD_LOGIC;
				GLOBAL_EN  : OUT STD_LOGIC;
				IDENT_IN	  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
				DATA_OUT_A : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				DATA_OUT_B : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				DATA_OUT_C : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				DATA_OUT_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				DATA_OUT_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
				STALL_GLOB : IN STD_LOGIC
				);
	end component;
	
	signal ADDRESS_A  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_B  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_C  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_0  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_1  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_W  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal DATA_TO_W  : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal W_EN		  	: STD_LOGIC;
	signal CLK		 	: STD_LOGIC := '1';
	signal RESET_n    : STD_LOGIC := '0';
	signal DATA_OUT_A : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal DATA_OUT_B : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal DATA_OUT_C : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal DATA_OUT_0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal DATA_OUT_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal ADDRESS_IO : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal DATA_IO 	: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal IO_ENABLE  : STD_LOGIC := '0';
	signal GLOBAL_EN  : STD_LOGIC;
	signal IDENT_IN	: STD_LOGIC_VECTOR (1 downto 0);
	signal STALL_GLOB : STD_LOGIC;
	
	
	constant clk_period : time := 20ns;
	
begin

	uut : Compute_Group PORT MAP (
								ADDRESS_A,
								ADDRESS_B,
								ADDRESS_C,
								ADDRESS_0,
								ADDRESS_1,
								ADDRESS_W,
								ADDRESS_IO,
								DATA_IO,
								IO_ENABLE,
								DATA_TO_W,
								W_EN,
								CLK,
								RESET_n,
								GLOBAL_EN,
								IDENT_IN,
								DATA_OUT_A,
								DATA_OUT_B,
								DATA_OUT_C,
								DATA_OUT_0,
								DATA_OUT_1,
								STALL_GLOB
								);
	
	clk_process : process begin
		CLK <= '1';
		wait for clk_period/2;
		CLK <= '0';
		wait for clk_period/2;
	end process;
	
	
	stim_process : process begin
		wait for clk_period;
		IO_ENABLE <= '0';
		IDENT_IN <= "00";
		STALL_GLOB <= '0';
		ADDRESS_IO <= "00000000000000000000000011111111";
		DATA_IO <= "00000000000000000000000011111111";
		wait for clk_period;
		RESET_n <= '1';
		wait;
	end process;
end;