library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--                                                                        77
--The IO controller helps the CPU communicate with other devices, since the 
--subleq instruction does not allow normal data transfer into and out of a 
--designated IO region.
--
--The CPU can output data with the folowing sequence
--[0)(optional)] clear the memory location before writing (this technically doesn't matter to the io controller)
--1) write anything to the "output flag" memory location
--2) write the data to the "output" memory location
--3) write the pointer to the "output" memory location
--
--When the CPU reads data from the "input" location, it is automatically 
--detected by the IO controller and the value is updated


entity io_controller is
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
		--for outputting data
		data_out, ptr_out		:	out std_logic_vector(31 downto 0);
		o_en						:	out std_logic
	);

end entity;

architecture ioc of io_controller is
	--fsm signals
	type ofsm_state_type is (swait, sptr, sdata, swtf);
	signal ostate 				:	ofsm_state_type := swait;
	--datapath signals
	signal 	oflag_writing,
				cpu_writing		:	std_logic;
begin
    process(clk, reset_n)
	 begin
		if (reset_n = '0') then
			
		elsif (rising_edge(clk)) then
		--update state
			if ostate = swait then
				if oflag_writing = '1' then
					ostate <= sdata;
				else
					ostate <= swait;
				end if;
			elsif ostate = sdata then
				ostate <= sptr;
			elsif ostate = sptr then
				ostate <= swait;
			else
				ostate <= swtf;
			end if;
		end if;
	end process;
	
	--datapath
	process(ostate, w_data, w_addr)
	begin
		-- is the CPU writing to its output reg?
		if w_addr = output_location then
			cpu_writing <= '1';
		else
			cpu_writing <= '0';
		end if;
		
		-- is the cpu writing to the output flag?
		if w_addr = output_flag_location then
			oflag_writing <= '1';
		else
			oflag_writing <= '0';
		end if;
		
		-- should we be outputting data right now?
		if ostate = sdata then
			data_out <= w_data;
		elsif ostate = sptr then
			o_en <= '1';
			ptr_out <= w_data;
		else
			o_en <= '0';
			--hold previous pointer and data outputs
		end if;
	end process;
end architecture;























