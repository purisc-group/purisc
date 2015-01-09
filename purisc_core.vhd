library ieee;
use ieee.std_logic_1164.all;

entity urisc_core is
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
end entity;

architecture arch of urisc_core is
		--ri output signals
		signal ri_a : std_logic_vector(31 downto 0);
		signal ri_next_pc : std_logic_vector(31 downto 0);
		
		--rd output signals 
		signal rd_a : std_logic_vector(31 downto 0);
		signal rd_b : std_logic_vector(31 downto 0);
		signal rd_c : std_logic_vector(31 downto 0);
		signal rd_next_pc : std_logic_vector(31 downto 0);
		signal rd_ubranch : std_logic;
		signal rd_noop : std_logic;
		
		--ex output signals
		signal ex_b : std_logic_vector(31 downto 0);
		signal ex_c : std_logic_vector(31 downto 0);
		signal ex_db : std_logic_vector(31 downto 0);
		signal ex_cbranch : std_logic;
		signal ex_noop : std_logic;
		--ex input signals
		signal ex_da_in, ex_db_in : std_logic_vector(31 downto 0);
		--wd output signals
		signal wd_data, wd_addr : std_logic_vector(31 downto 0);
		--ri stage
		component read_instruction_stage
			port(
				--inputs 
				clk	:	in std_logic;
				reset_n	:	in std_logic;
				stall : 	in	std_logic;
				cbranch	:	in std_logic;
				cbranch_address : in std_logic_vector(31 downto 0);
				ubranch : in std_logic;
				ubranch_address : in std_logic_vector(31 downto 0);
				--outputs
				next_pc : out std_logic_vector(31 downto 0);
				--memory
				r_addr_inst	:	out std_logic_vector(31 downto 0)
			);
		end component;
		--rd stage
		component read_data_stage
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
		end component;
		--ex stage
		component execute_stage
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
		end component;
		--wd stage
		component write_data_stage
			port(
				clk : in std_logic;
				reset_n : in std_logic;
				stall : 	in	std_logic;
				
				b_in : in std_logic_vector(31 downto 0);
				db_in : in std_logic_vector(31 downto 0);
				noop_in : in std_logic;
				
				w_data	: 	out std_logic_vector(31 downto 0);
				w_addr	:	out std_logic_vector(31 downto 0);
				we			:	out std_logic
			);
		end component;
	begin
	
	ri : read_instruction_stage  port map (
		--in
		clk, reset_n, not hit,
		ex_cbranch,ex_c,
		rd_ubranch,rd_c,
		ri_next_pc,
		ri_a
	);
	rd : read_data_stage port map (
		--inputs
		clk, reset_n, not hit, rd_ubranch or ex_cbranch,
		r_data_a, r_data_b, r_data_c, 
		ri_next_pc,
		--outputs
		rd_a, rd_b, rd_c, 
		rd_ubranch, rd_noop,
		r_addr_0, r_addr_1,
		rd_next_pc
	);
	ex : execute_stage port map (
		--inputs
		clk, reset_n, not hit,
		rd_a, rd_b, rd_c, ex_da_in, ex_db_in, 
		rd_next_pc,
		rd_noop or ex_cbranch, 
		--outputs
		ex_b, ex_c, ex_db, ex_cbranch, ex_noop
	);
	wd	: write_data_stage port map (
		--inputs
		clk, reset_n, not hit,
		ex_b, ex_db, ex_noop, 
		--memory
		wd_data, wd_addr, we
	);

	--data forwarding
	ex_da_in <=	ex_db when rd_a=ex_b else
					wd_data when rd_a=wd_addr else
					r_data_0;
	ex_db_in <=	ex_db when rd_b=ex_b else
					wd_data when rd_b=wd_addr else
					r_data_1;
	
	w_data <= wd_data;
	w_addr <= wd_addr;
	r_addr_inst <= ri_a;
end architecture;