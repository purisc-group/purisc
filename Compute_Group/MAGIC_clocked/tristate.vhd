library ieee;
use ieee.std_logic_1164.all;

entity tristate is
	PORT(
		my_in : in std_logic_vector(9 downto 0);
		sel :   in std_logic;
		my_out : out std_logic_vector(9 downto 0)
		);
end tristate;

architecture control of tristate is
begin
	my_out <= "ZZZZZZZZZZ" when (sel = '0') else my_in;
end control;