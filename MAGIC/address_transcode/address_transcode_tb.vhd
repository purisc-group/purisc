library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_transcode_tb is
end;

architecture bahv of address_transcode_tb is

	component address_transcode
	PORT (
			ADDRESS 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ROW		: OUT unsigned (12 DOWNTO 0);
			COL		: OUT unsigned (2 DOWNTO 0)
			);
	end component;
	
	signal address_signal : std_logic_vector(31 downto 0);
	signal row_out : unsigned (12 downto 0);
	signal col_out : unsigned (2 downto 0);
	signal counter : unsigned(31 downto 0) := "00000000000000000000000000000000";
	constant delay : time := 100ps;
	
	begin
	
	uut : address_transcode PORT MAP ( ADDRESS => address_signal, ROW => row_out, COL => col_out );
	
	count : process
	begin
		wait for delay;
		counter <= counter + 1;
	end process;
	
	address_signal <= std_logic_vector(counter);
	
end;