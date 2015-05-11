library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROUTE_SIGNAL_global is
		PORT(
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
			select_vector : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			hazard	: IN STD_LOGIC;
			hazard_advanced : IN STD_LOGIC;
			CLK : IN STD_LOGIC;
			RESET_n : IN STD_LOGIC;
			OUTPUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
			);
end;

architecture signal_routing of ROUTE_SIGNAL_global is

	component tristate_32
		PORT(
			my_in  : in std_logic_vector(31 downto 0);
			sel 	 : in std_logic;
			my_out : out std_logic_vector(31 downto 0)
			);
	end component;
	
	component HAZARD_RESOLVE_global
		PORT(
				select_signal : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
				hazard : IN STD_LOGIC;
				data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				CLK : IN STD_LOGIC;
				RESET_n : IN STD_LOGIC;
				hazard_advanced : IN STD_LOGIC;
				data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	end component;
	
	signal data : std_logic_vector(31 downto 0);
	
begin
	
	a_0 : tristate_32 PORT MAP (
									my_in => ram_0_out_a,
									sel => select_vector(15),
									my_out => data
									);
	b_0 : tristate_32 PORT MAP (
									my_in => ram_0_out_b,
									sel => select_vector(14),
									my_out => data
									);
	a_1 : tristate_32 PORT MAP (
									my_in => ram_1_out_a,
									sel => select_vector(13),
									my_out => data
									);
	b_1 : tristate_32 PORT MAP (
									my_in => ram_1_out_b,
									sel => select_vector(12),
									my_out => data
									);
	a_2 : tristate_32 PORT MAP (
									my_in => ram_2_out_a,
									sel => select_vector(11),
									my_out => data
									);
	b_2 : tristate_32 PORT MAP (
									my_in => ram_2_out_b,
									sel => select_vector(10),
									my_out => data
									);
	a_3 : tristate_32 PORT MAP (
									my_in => ram_3_out_a,
									sel => select_vector(9),
									my_out => data
									);
	b_3 : tristate_32 PORT MAP (
									my_in => ram_3_out_b,
									sel => select_vector(8),
									my_out => data
									);
	a_4 : tristate_32 PORT MAP (
									my_in => ram_4_out_a,
									sel => select_vector(7),
									my_out => data
									);
	b_4 : tristate_32 PORT MAP (
									my_in => ram_4_out_b,
									sel => select_vector(6),
									my_out => data
									);
	a_5 : tristate_32 PORT MAP (
									my_in => ram_5_out_a,
									sel => select_vector(5),
									my_out => data
									);
	b_5 : tristate_32 PORT MAP (
									my_in => ram_5_out_b,
									sel => select_vector(4),
									my_out => data
									);
	a_6 : tristate_32 PORT MAP (
									my_in => ram_6_out_a,
									sel => select_vector(3),
									my_out => data
									);
	b_6 : tristate_32 PORT MAP (
									my_in => ram_6_out_b,
									sel => select_vector(2),
									my_out => data
									);
	a_7 : tristate_32 PORT MAP (
									my_in => ram_7_out_a,
									sel => select_vector(1),
									my_out => data
									);
	b_7 : tristate_32 PORT MAP (
									my_in => ram_7_out_b,
									sel => select_vector(0),
									my_out => data
									);
	resolve_hazard : HAZARD_RESOLVE_global PORT MAP (
															select_signal => select_vector,
															hazard => hazard,
															data => data,
															CLK => CLK,
															RESET_n => RESET_n,
															hazard_advanced => hazard_advanced,
															data_out => OUTPUT
															);
															
end;