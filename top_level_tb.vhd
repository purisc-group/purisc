library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end;

architecture test of top_level_tb is
	component top_level
		PORT(
		--ONLY PHY CONNECTIONS IN TOP LEVEL
		CLOCK_50 : IN STD_LOGIC;
		SW : IN STD_LOGIC_VECTOR(17 downto 0);
		HEX0, HEX1, HEX2, HEX3, 
		HEX4, HEX5, HEX6, HEX7 : OUT std_logic_vector(6 downto 0)
		);
	end component;
	
	constant clk_period : time := 20ns;
	
	signal CLOCK_50 : std_logic;
	signal SW : std_logic_vector(17 downto 0);
	signal HEX0 : std_logic_vector(6 downto 0);
	signal HEX1 : std_logic_vector(6 downto 0);
	signal HEX2 : std_logic_vector(6 downto 0);
	signal HEX3 : std_logic_vector(6 downto 0);
	signal HEX4 : std_logic_vector(6 downto 0);
	signal HEX5 : std_logic_vector(6 downto 0);
	signal HEX6 : std_logic_vector(6 downto 0);
	signal HEX7 : std_logic_vector(6 downto 0);
	
begin

	uut : top_level PORT MAP(
									CLOCK_50 => CLOCK_50,
									SW => SW,
									HEX0 => HEX0,
									HEX1 => HEX1,
									HEX2 => HEX2,
									HEX3 => HEX3,
									HEX4 => HEX4,
									HEX5 => HEX5,
									HEX6 => HEX6,
									HEX7 => HEX7
									);

	clk_process : process begin
		CLOCK_50 <= '1';
		wait for clk_period/2;
		CLOCK_50 <= '0';
		wait for clk_period/2;
	end process;
	
	stim_process : process begin
		SW(17) <= '0';
		wait for clk_period*2;
		SW(17) <= '1';
		wait;
		
	end process;
	
end;