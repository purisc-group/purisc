library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity purisc is
	port(
		clk, reset_n : in std_logic;
		--memory mapped IO
		data_output : out std_logic_vector(31 downto 0);
		ptr_output	: out std_logic_vector(31 downto 0);
		o_en			: out std_logic;
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
				
	signal we, hit, stall, core_hit, init : std_logic;
	signal we_2 : std_logic;
	signal hit2 : std_logic;
	signal reset_n_core : std_logic;
	signal flags : std_logic_vector(7 downto 0);
	--
	signal w_data_magic, w_addr_magic : std_logic_vector(31 downto 0);
	
	
	signal b,c : unsigned(31 downto 0);
	
	component purisc_core
		port(
			clk, reset_n : in std_logic;
			r_addr_0, r_addr_1, r_addr_inst : out std_logic_vector(31 downto 0);
			w_data, w_addr :	out std_logic_vector(31 downto 0);
			we	:	out std_logic;
			stall : in std_logic;
			flags	: in std_logic_vector(7 downto 0);
			r_data_a, r_data_b, r_data_c, 
			r_data_0, r_data_1	: 	in	std_logic_vector(31 downto 0)
		);
	end component;
	component magic 
		port( 
			ADDRESS_A  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_B  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_C  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_W  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_TO_W  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			W_EN		  : IN STD_LOGIC;
			CLK		  : IN STD_LOGIC;
			RESET_n    : IN STD_LOGIC;
			DATA_OUT_A : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_B : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_C : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			STALL		  : OUT STD_LOGIC
		);
	end component;
	component io_controller
		generic (
			input_location			:	std_logic_vector(31 downto 0);
			output_location		:	std_logic_vector(31 downto 0);
			output_flag_location	:	std_logic_vector(31 downto 0)
		);
		port (
			clk, reset_n			:	in std_logic;
			-- for watching the CPU's writes
			w_data, w_addr			:	in std_logic_vector(31 downto 0);
			w_en						:	in std_logic;
			-- output to ethernet controller
			data_out, ptr_out		:	out std_logic_vector(31 downto 0);
			o_en						:	out std_logic
		);
	end component;
begin
	uc : purisc_core port map(
		clk => clk,
		reset_n  => reset_n_core,
		r_addr_0 => r_addr_0,
		r_addr_1 => r_addr_1,
		r_addr_inst => r_addr_inst,
		w_data => w_data,
		w_addr => w_addr,
		we => we,
		stall => not hit2,
		flags => flags,
		r_data_a => r_data_a,
		r_data_b => r_data_b,
		r_data_c => r_data_c,
		r_data_0 => r_data_0,
		r_data_1 => r_data_1
	);
	ioc : io_controller 
		generic map(
			"00000000000000000000000000000000", --input memory location: 0 (not implemented yet)
			"00000000000000000000000000111110", --output memory location:			62
			"00000000000000000000000000111111"	--output flag memory location:	63
		)
		port map (
			clk, reset_n,
			w_data, w_addr, we,
			data_output, ptr_output,
			o_en
		);
	mc : magic port map(
		address_a => r_addr_inst,
		address_b => std_logic_vector(b),
		address_c => std_logic_vector(c),
		address_0 => r_addr_0,
		address_1 => r_addr_1,
		address_w => w_addr_magic,
		data_to_w => w_data_magic,
		w_en => we_2,
		clk => clk,
		reset_n => reset_n,
		data_out_a => r_data_a,
		data_out_b => r_data_b,
		data_out_c => r_data_c,
		data_out_0 => r_data_0,
		data_out_1 => r_data_1,
		stall => stall
	);
	b <= unsigned(r_addr_inst) + 1;
	c <= unsigned(r_addr_inst) + 2;
	
	hit <= not stall;
	
	w_data_magic <=	o_w_data when w_override = '1' else 
							w_data;
	w_addr_magic <=	o_w_addr when w_override = '1' else 
							w_addr;
	we_2 <= '1' when w_override = '1' else we;
	
	hit2 <= '0' when w_override = '1' else hit;
	
	reset_n_core <= '0' when w_override = '1' else reset_n;
	
end architecture;