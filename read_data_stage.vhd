library ieee;
use ieee.std_logic_1164.all;

entity read_data_stage is
	port(
		clk	:	in std_logic;
		reset_n	:	in std_logic;
		stall : 	in	std_logic;
		noop_in : in std_logic;
		a_in : in std_logic_vector(31 downto 0);
		b_in : in std_logic_vector(31 downto 0);
		c_in : in std_logic_vector(31 downto 0);
		pc : in std_logic_vector(31 downto 0);
		
		a_out : out std_logic_vector(31 downto 0);
		b_out : out std_logic_vector(31 downto 0);
		c_out : out std_logic_vector(31 downto 0);
		ubranch_out : out std_logic;
		noop_out : out std_logic;
		
		r_addr_0	:	out std_logic_vector(31 downto 0);
		r_addr_1	:	out std_logic_vector(31 downto 0);
		pc_out : out std_logic_vector(31 downto 0)
	);
end entity;

architecture a1 of read_data_stage is
--signals
	signal ubranch : std_logic;
--components
begin
	process(clk, reset_n) begin
		if (reset_n = '0') then
			--on boot
			noop_out <= '1';
			ubranch <= '0';
			r_addr_0 <= "00000000000000000000000000000000";
			r_addr_1 <= "00000000000000000000000000000000";
		elsif (rising_edge(clk)) then
			if(stall = '0') then 
				--check for unconditional branch
				if(a_in = b_in and not(pc = c_in) and not(ubranch = '1')) then
					ubranch <= '1';
				else
					ubranch <= '0';
				end if;
				noop_out <= noop_in;
				a_out <= a_in;
				b_out <= b_in;
				c_out <= c_in;
				r_addr_0 <= a_in;
				r_addr_1 <= b_in;
				pc_out <= pc;
			else
				--hold previous outputs on stall (automatic)
			end if;
		end if;
	end process;
end architecture;