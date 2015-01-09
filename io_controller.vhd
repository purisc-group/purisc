library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--                                                                        77
--The IO controller helps the CPU communicate with other devices, since the 
--subleq instruction does not allow normal data transfer into and out of a 
--designated IO region.
--
--The CPU can output data with the folowing sequence
--1) change the value in the "output flag" memory location
--2) clear the data stored at the "output" memory location
--3) write the data to the "output" memory location
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
		data_out					:	out std_logic_vector(31 downto 0);
		o_en						:	out std_logic
	);

end entity;

architecture ioc of io_controller is
	--fsm signals
	type ofsm_state_type is (swait, stoggled, soutput, swtf);
	signal ostate 				:	ofsm_state_type := swait;
	signal w_data_last		:	std_logic_vector(31 downto 0);
	--datapath signals
	signal 	oflag_toggle,
				cpu_writing		:	std_logic;
begin
    process(clk, reset_n)
	 begin
		if (reset_n = '0') then
			
		elsif (rising_edge(clk)) then
		--update state
			if ostate = swait then
				if oflag_toggle = '1' and cpu_writing = '1' then
					ostate <= soutput;
				else
					ostate <= swait;
				end if;
			elsif ostate = soutput then
				if oflag_toggle = '1' and cpu_writing = '1' then
					ostate <= soutput;
				else
					ostate <= swait;
				end if;
			else
				ostate <= swtf;
			end if;
		end if;
		
		w_data_last <= w_data;
		
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
		
		-- has the output flag been changed?
		if w_addr = output_flag_location and not(w_data_last = w_data) then
			oflag_toggle <= '1';
		else
			oflag_toggle <= '0';
		end if;
		
		-- should we be outputting something right now?
		if ostate = soutput then
			data_out <= w_data;
			o_en <= '1';
		else
			--hold previous data_output
			o_en <= '0';
		end if;
	end process;
end architecture;























