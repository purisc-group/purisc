library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BIST_core is
		PORT (
				clk, reset_n : in std_logic;
				r_addr_a, r_addr_b, r_addr_c, r_addr_0, r_addr_1 : out std_logic_vector(31 downto 0);
				w_data, w_addr :	out std_logic_vector(31 downto 0);
				we	:	out std_logic;
				stall : in std_logic;
				id	: in std_logic_vector(2 downto 0);
				r_data_a, r_data_b, r_data_c, 
				r_data_0, r_data_1	: 	in	std_logic_vector(31 downto 0)
				);
end;

architecture BIST of BIST_core is
	signal start_address : std_logic_vector(31 downto 0);
	signal error_a : std_logic;
	signal error_b : std_logic;
	signal error_c : std_logic;
	signal error_0 : std_logic;
	signal error_1 : std_logic;
	signal address_a : std_logic_vector(31 downto 0);
	signal address_b : std_logic_vector(31 downto 0);
	signal address_c : std_logic_vector(31 downto 0);
	signal address_0 : std_logic_vector(31 downto 0);
	signal address_1 : std_logic_vector(31 downto 0);
begin

	process (start_address, id) begin
		if (id(0) = '1') then
			address_a <= start_address;
			address_b <= std_logic_vector(unsigned(start_address) + 1);
			address_c <= std_logic_vector(unsigned(start_address) + 2);
			address_0 <= std_logic_vector(unsigned(start_address) + 3);
			address_1 <= std_logic_vector(unsigned(start_address) + 4);
		else
			address_a <= start_address;
			address_b <= std_logic_vector(unsigned(start_address) + 1);
			address_c <= std_logic_vector(unsigned(start_address) + 2);
			address_0 <= std_logic_vector(unsigned(start_address) + 3);
			address_1 <= std_logic_vector(unsigned(start_address) + 4);
		end if;
	end process;
	w_addr <= "00000000000000000000000000000000";
	w_data <= "00000000000000000000000000000000";
	we <= '0';
	
	r_addr_a <= address_a;
	r_addr_b <= address_b;
	r_addr_c <= address_c;
	r_addr_0 <= address_0;
	r_addr_1 <= address_1;
	
	process (reset_n, clk) begin
		if (reset_n = '0') then
			if (id(0) = '0') then
				start_address <= "00000000000000000000000000010000";
			else
				start_address <= "00000000000000000000000000010000";
			end if;
		elsif (rising_edge(clk)) then
			if (stall = '0') then 
				start_address <= std_logic_vector(unsigned(start_address) + 5);
			end if;
		end if;
	end process;
	
	process (reset_n, clk) begin
		if (reset_n = '0') then
			error_a <= '0';
			error_b <= '0';
			error_c <= '0';
			error_0 <= '0';
			error_1 <= '0';
		elsif(rising_edge(clk)) then
			if (stall = '0') then
				if (r_data_a = address_a) then
					error_a <= '0';
				else
					error_a <= '1';
				end if;
				if (r_data_b = address_b) then
					error_b <= '0';
				else
					error_b <= '1';
				end if;
				if (r_data_c = address_c) then
					error_c <= '0';
				else
					error_c <= '1';
				end if;
				if (r_data_a = address_a) then
					error_0 <= '0';
				else
					error_0 <= '1';
				end if;
				if (r_data_a = address_a) then
					error_1 <= '0';
				else
					error_1 <= '1';
				end if;
			end if;
		end if;
	end process;
	
end;