library ieee;
use ieee.std_logic_1164.all;

entity tristate_32 is
	PORT(
		my_in : in std_logic_vector(31 downto 0);
		sel :   in std_logic;
		my_out : out std_logic_vector(31 downto 0)
		);
end tristate_32;

architecture control of tristate_32 is
begin
	my_out <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when (sel = '0') else my_in;
end control;