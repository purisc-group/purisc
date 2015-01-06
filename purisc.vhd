library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity purisc is
	port(
		clk, reset_n : in std_logic;
		--memory mapped IO
		data_output : out std_logic_vector(31 downto 0);
		data_input	: in std_logic_vector(31 downto 0);
		--for loading memory
		w_override	: in std_logic;
		o_w_addr		: in std_logic_vector(31 downto 0);
		o_w_data		: in std_logic_vector(31 downto 0)
	);
end entity;

architecture bhv of purisc is
	signal 	r_addr_0, r_addr_1, r_addr_inst, 
				w_data, w_addr,
				r_data_a, r_data_b, r_data_c, 
				r_data_0, r_data_1 : std_logic_vector(31 downto 0);
				
	signal we, hit, core_hit, init : std_logic;
	signal we_2 : std_logic;
	signal hit2 : std_logic;
	signal reset_n_core : std_logic;
	signal flags : std_logic_vector(7 downto 0);
	--
	signal w_data_magic, w_addr_magic : std_logic_vector(31 downto 0);
	
	
	signal b,c : unsigned(31 downto 0);
	
	component urisc_core
		port(
			clk, reset_n : in std_logic;
			r_addr_0, r_addr_1, r_addr_inst : out std_logic_vector(31 downto 0);
			w_data, w_addr :	out std_logic_vector(31 downto 0);
			we	:	out std_logic;
			hit : in std_logic;
			flags	: in std_logic_vector(7 downto 0);
			r_data_a, r_data_b, r_data_c, 
			r_data_0, r_data_1	: 	in	std_logic_vector(31 downto 0)
		);
	end component;
	component magic 
		port( 
			clk 		: in std_logic;
			reset_n 	: in std_logic;
			w_data 	: in std_logic_vector(31 downto 0);
			r_add_a 	: in std_logic_vector(31 downto 0);
			r_add_b 	: in std_logic_vector(31 downto 0);
			r_add_c 	: in std_logic_vector(31 downto 0);
			r_add_0 	: in std_logic_vector(31 downto 0);
			r_add_1 	: in std_logic_vector(31 downto 0);
			w_add 	: in std_logic_vector(31 downto 0);
			w_en 		: in std_logic;
			hit 		: out std_logic;
			res_flag : out std_logic;
			data_a 	: out std_logic_vector(31 downto 0);
			data_b 	: out std_logic_vector(31 downto 0);
			data_c 	: out std_logic_vector(31 downto 0);
			data_0 	: out std_logic_vector(31 downto 0);
			data_1 	: out std_logic_vector(31 downto 0)
		);
	end component;
begin
	uc : urisc_core port map(
		clk => clk,
		reset_n  => reset_n_core,
		r_addr_0 => r_addr_0,
		r_addr_1 => r_addr_1,
		r_addr_inst => r_addr_inst,
		w_data => w_data,
		w_addr => w_addr,
		we => we,
		hit => hit2,
		flags => flags,
		r_data_a => r_data_a,
		r_data_b => r_data_b,
		r_data_c => r_data_c,
		r_data_0 => r_data_0,
		r_data_1 => r_data_1
	);
	mc : magic port map(
		clk => clk,
		reset_n => reset_n,
		w_data => w_data_magic,
		r_add_a => r_addr_inst,
		r_add_b => std_logic_vector(b),
		r_add_c => std_logic_vector(c),
		r_add_0 => r_addr_0,
		r_add_1 => r_addr_1,
		w_add => w_addr_magic,
		w_en => we_2,
		hit => hit,
		data_a => r_data_a,
		data_b => r_data_b,
		data_c => r_data_c,
		data_0 => r_data_0,
		data_1 => r_data_1
	);
	b <= unsigned(r_addr_inst) + 1;
	c <= unsigned(r_addr_inst) + 2;
	
	w_data_magic <=	o_w_data when w_override = '1' else 
							w_data;
	w_addr_magic <=	o_w_addr when w_override = '1' else 
							w_addr;
	we_2 <= '1' when w_override = '1' else we;
	
	hit2 <= '0' when w_override = '1' else hit;
	
	reset_n_core <= '0' when w_override = '1' else reset_n;
	
end architecture;

