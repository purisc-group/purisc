library ieee;
use ieee.std_logic_1164.all;

entity tristate_global is
	PORT(
		my_in : in std_logic_vector(11 downto 0);
		sel :   in std_logic;
		my_out : out std_logic_vector(11 downto 0)
		);
end tristate_global;

architecture control of tristate_global is
begin
	my_out <= "ZZZZZZZZZZZZ" when (sel = '0') else my_in;
end control;