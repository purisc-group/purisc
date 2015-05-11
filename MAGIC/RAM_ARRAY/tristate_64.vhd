library ieee;
use ieee.std_logic_1164.all;

entity tristate_64 is
	PORT(
		my_in : in std_logic_vector(64 downto 0);
		sel :   in std_logic;
		my_out : out std_logic_vector(64 downto 0)
		);
end tristate_64;

architecture control of tristate_64 is
begin
	my_out <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when (sel = '0') else my_in;
end control;