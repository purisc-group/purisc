library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity cache is

	port( CLK			: in std_logic;
			RESET_n		: in std_logic;
			write_addr	: in std_logic_vector(31 downto 0);
			write_data	: in std_logic_vector(31 downto 0);
			read_addr_a	: in std_logic_vector(31 downto 0);
			read_addr_b	: in std_logic_vector(31 downto 0);
			read_addr_c	: in std_logic_vector(31 downto 0);
			read_addr_0	: in std_logic_vector(31 downto 0);
			read_addr_1	: in std_logic_vector(31 downto 0);
			w_en			: in std_logic;
			hit_flag_a	: out std_logic;
			hit_flag_b	: out std_logic;
			hit_flag_c	: out std_logic;
			hit_flag_0	: out std_logic;
			hit_flag_1	: out std_logic;
			data_out_a	: out std_logic_vector(31 downto 0);
			data_out_b	: out std_logic_vector(31 downto 0);
			data_out_c	: out std_logic_vector(31 downto 0);
			data_out_0	: out std_logic_vector(31 downto 0);
			data_out_1	: out std_logic_vector(31 downto 0)
			);
end;

architecture cache_1 of cache is

	constant c_rows : integer := 511; --cache capacity is 512 rows containing 32 bits of meaningful data in each
	subtype cache_row_vector is std_logic_vector(55 downto 0);
	type cache_format is array (c_rows downto 0) of cache_row_vector;
	
	signal write_row : integer range c_rows downto 0;
	signal cache_row_valid_a : std_logic;
	signal cache_row_valid_b : std_logic;
	signal cache_row_valid_c : std_logic;
	signal cache_row_valid_0 : std_logic;
	signal cache_row_valid_1 : std_logic;
	signal cahce_row_data_a : std_logic_vector(31 downto 0);
	signal cahce_row_data_b : std_logic_vector(31 downto 0);
	signal cahce_row_data_c : std_logic_vector(31 downto 0);
	signal cahce_row_data_0 : std_logic_vector(31 downto 0);
	signal cahce_row_data_1 : std_logic_vector(31 downto 0);
	signal tag_equal_a : std_logic;
	signal tag_equal_b : std_logic;
	signal tag_equal_c : std_logic;
	signal tag_equal_0 : std_logic;
	signal tag_equal_1 : std_logic;
	--create 2d array
	signal cache : cache_format;
	
	begin
	
		write_row <= conv_integer(unsigned(write_addr(8 downto 0)));
		
		--reset and write processs
		process (CLK, RESET_n, w_en)
		begin
			if (RESET_n = '0') then
				L1: for I in 0 to c_rows loop
					cache(I)<="00000000000000000000000000000000000000000000000000000000";
				end loop L1;
			elsif (CLK = '1' and CLK'event and w_en = '1') then
				cache(write_row)<='1' & write_addr(31 downto 9) & write_data;
			end if;
		end process;	
		
		--cache operations here
		process (w_en, read_addr_a, read_addr_b, read_addr_c, read_addr_0, read_addr_1, cache)
		--local variable
		variable read_row_a : integer range c_rows downto 0;
		variable read_row_b : integer range c_rows downto 0;
		variable read_row_c : integer range c_rows downto 0;
		variable read_row_0 : integer range c_rows downto 0;
		variable read_row_1 : integer range c_rows downto 0;
		variable cache_tag_a : std_logic_vector(22 downto 0);
		variable cache_tag_b : std_logic_vector(22 downto 0);
		variable cache_tag_c : std_logic_vector(22 downto 0);
		variable cache_tag_0 : std_logic_vector(22 downto 0);
		variable cache_tag_1 : std_logic_vector(22 downto 0);
		begin
			--use address bits 8..0 to create a cache row address (9 bits for index)
			read_row_a := conv_integer(unsigned(read_addr_a(8 downto 0)));
			read_row_b := conv_integer(unsigned(read_addr_b(8 downto 0))); 
			read_row_c := conv_integer(unsigned(read_addr_c(8 downto 0))); 
			read_row_0 := conv_integer(unsigned(read_addr_0(8 downto 0))); 
			read_row_1 := conv_integer(unsigned(read_addr_1(8 downto 0))); 

			--copy the data from its field into the output signal
			cahce_row_data_a <= cache(read_row_a)(31 downto 0);
			cahce_row_data_b <= cache(read_row_b)(31 downto 0);
			cahce_row_data_c <= cache(read_row_c)(31 downto 0);
			cahce_row_data_0 <= cache(read_row_0)(31 downto 0);
			cahce_row_data_1 <= cache(read_row_1)(31 downto 0);
				
			--this process is level sensitive not edge sensitive;
			--if (w_en = '0') then
				--bit 64 of cache row == valid bit
				--copy it into the output port
				cache_row_valid_a <= cache(read_row_a)(55);
				cache_row_valid_b <= cache(read_row_b)(55);
				cache_row_valid_c <= cache(read_row_c)(55);
				cache_row_valid_0 <= cache(read_row_0)(55);
				cache_row_valid_1 <= cache(read_row_1)(55);
			--else
				--if we are not reading from the cache data is invalid
--				cache_row_valid_a <= '0';
--				cache_row_valid_b <= '0';
--				cache_row_valid_c <= '0';
--				cache_row_valid_0 <= '0';
--				cache_row_valid_1 <= '0';
			--end if;
			
			--the address of the word stored in this row is in bits 54:32 (only part of the address is stored)
			cache_tag_a := cache(read_row_a)(54 downto 32);
			cache_tag_b := cache(read_row_b)(54 downto 32);
			cache_tag_c := cache(read_row_c)(54 downto 32);
			cache_tag_0 := cache(read_row_0)(54 downto 32);
			cache_tag_1 := cache(read_row_1)(54 downto 32);
			
			--compare the adress to see if its a cache hit for all 5 reads
			if (cache_tag_a = read_addr_a(31 downto 9)) then
				tag_equal_a <= '1';
			else
				tag_equal_a <= '0';
			end if;
			if (cache_tag_b = read_addr_b(31 downto 9)) then
				tag_equal_b <= '1';
			else
				tag_equal_b <= '0';
			end if;
			if (cache_tag_c = read_addr_c(31 downto 9)) then
				tag_equal_c <= '1';
			else
				tag_equal_c <= '0';
			end if;
			if (cache_tag_0 = read_addr_0(31 downto 9)) then
				tag_equal_0 <= '1';
			else
				tag_equal_0 <= '0';
			end if;
			if (cache_tag_1 = read_addr_1(31 downto 9)) then
				tag_equal_1 <= '1';
			else
				tag_equal_1 <= '0';
			end if;
		end process;
		

		--return the hit flag, 1 if hit on all 5 addresses
		hit_flag_a <= tag_equal_a and cache_row_valid_a;
		hit_flag_b <= tag_equal_b and cache_row_valid_b;
		hit_flag_c <= tag_equal_c and cache_row_valid_c;
		hit_flag_0 <= tag_equal_0 and cache_row_valid_0;
		hit_flag_1 <= tag_equal_1 and cache_row_valid_1;
		--return data unconditionally
		data_out_a <= cahce_row_data_a;
		data_out_b <= cahce_row_data_b;
		data_out_c <= cahce_row_data_c;
		data_out_0 <= cahce_row_data_0;
		data_out_1 <= cahce_row_data_1;
							
end cache_1;
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		