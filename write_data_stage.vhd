library ieee;
use ieee.std_logic_1164.all;

entity write_data_stage is
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		stall : 	in	std_logic;
		--although there is no ambiguity, _in is here for consistency (to make coding easier)
		b_in : in std_logic_vector(31 downto 0);
		db_in : in std_logic_vector(31 downto 0);
		noop_in : in std_logic;
		
		w_data	: 	out std_logic_vector(31 downto 0);
		w_addr	:	out std_logic_vector(31 downto 0);
		we			:	out std_logic
	);
end entity;

architecture a1 of write_data_stage is
--signals
--components
begin
	process(clk) begin
		if(reset_n = '0') then
			--default values
			we <= '0';
			w_data <= "00000000000000000000000000000000";
			w_addr <= "00000000000000000000000000000000";
		elsif (rising_edge(clk)) then
			if(stall = '0') then 
				if(noop_in = '0') then
					we <= '1';
					w_addr <= b_in;
					w_data <= db_in;
				--noop (don't write)
				else
					we <= '0';
				end if;
			else
				--hold previous outputs on stall (automatic)
			end if;
		end if;
	end process;
end architecture;