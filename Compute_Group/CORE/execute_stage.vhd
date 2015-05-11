library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity execute_stage is
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		stall : 	in	std_logic;
		a_in : in std_logic_vector(31 downto 0);
		b_in : in std_logic_vector(31 downto 0);
		c_in : in std_logic_vector(31 downto 0);
		da_in : in std_logic_vector(31 downto 0);
		db_in : in std_logic_vector(31 downto 0);
		next_pc : in std_logic_vector(31 downto 0);
		noop_in : in std_logic;
		
		b_out : out std_logic_vector(31 downto 0);
		c_out : out std_logic_vector(31 downto 0);
		db_out : out std_logic_vector(31 downto 0);
		cbranch : out std_logic;
		noop_out : out std_logic
	);
end entity;

architecture a1 of execute_stage is
--signals
--components
begin
-- c may change (check that it always has a value)
-- db always changes
	process(clk) begin
		if(reset_n = '0') then
			--initial values
			noop_out <= '1';
			cbranch <= '0';
		elsif (rising_edge(clk)) then
			if(stall = '0') then 
				-- SUB
				db_out <= std_logic_vector(signed(db_in) - signed(da_in));
				-- BLEQ --not testing the 'equal to zero' condition because that was done in the RD stage
				if((signed(db_in) - signed(da_in)) < 0 and noop_in = '0' and not(c_in = next_pc)) then
					cbranch <= '1';
				else
					cbranch <= '0';
				end if;
				
				b_out <= b_in;
				c_out <= c_in;
				noop_out <= noop_in;
			else
				--hold previous outputs on stall (automatic)
			end if;
		end if;
	end process;
end architecture;