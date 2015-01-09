library ieee;
use ieee.std_logic_1164.all;

entity MAGIC is
	generic (W : integer := 32);
	port( CLK 		: in std_logic;
			RESET_n 	: in std_logic;
			w_data 	: in std_logic_vector(w-1 downto 0);
			r_add_a 	: in std_logic_vector(w-1 downto 0);
			r_add_b 	: in std_logic_vector(w-1 downto 0);
			r_add_c 	: in std_logic_vector(w-1 downto 0);
			r_add_0 	: in std_logic_vector(w-1 downto 0);
			r_add_1 	: in std_logic_vector(w-1 downto 0);
			w_add 	: in std_logic_vector(w-1 downto 0);
			w_en 		: in std_logic;
			hit 		: out std_logic;
			res_flag : out std_logic;
			data_a 	: out std_logic_vector(w-1 downto 0);
			data_b 	: out std_logic_vector(w-1 downto 0);
			data_c 	: out std_logic_vector(w-1 downto 0);
			data_0 	: out std_logic_vector(w-1 downto 0);
			data_1 	: out std_logic_vector(w-1 downto 0)
			);
end;

architecture MAGIC_1 of MAGIC is
	signal X : std_logic_vector(w-1 downto 0);
	signal Y : std_logic;
	signal hit_flag_a : std_logic;
	signal hit_flag_b : std_logic;
	signal hit_flag_c : std_logic;
	signal hit_flag_0 : std_logic;
	signal hit_flag_1 : std_logic;
	
	component cache
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
	end component;
	
	begin
		CACHE_1 : cache port map (read_addr_a=>r_add_a, read_addr_c=>r_add_c, read_addr_b=>r_add_b, read_addr_0=>r_add_0,
											read_addr_1=>r_add_1, w_en=>w_en, hit_flag_a=>hit_flag_a, hit_flag_b=>hit_flag_b,
											hit_flag_c=>hit_flag_c, hit_flag_0=>hit_flag_0, hit_flag_1=>hit_flag_1,
											data_out_a=>data_a, data_out_b=>data_b, data_out_c=>data_c, data_out_0=>data_0,
											data_out_1=>data_1, RESET_n=>RESET_n, write_addr=>w_add, write_data=>w_data, CLK=>CLK);
		hit <= (hit_flag_0 and hit_flag_1 and hit_flag_a and hit_flag_b and hit_flag_c);
	end MAGIC_1;
		
	