library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HAZARD_RESOLVE_global is
	PORT(
			select_signal : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			hazard : IN STD_LOGIC;
			data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			CLK : IN STD_LOGIC;
			RESET_n : IN STD_LOGIC;
			hazard_advanced : IN STD_LOGIC;
			data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
		);
end;

architecture resolve of HAZARD_RESOLVE_global is
	
	signal data_present : std_logic;
	signal buffer_output : std_logic_vector(31 downto 0);
	signal data_buffer : std_logic_vector(31 downto 0);
	signal hazard_rising_edge : std_logic;
	
begin
	--edge capture
	hazard_rising_edge <= hazard_advanced and (hazard_advanced xor hazard);
	
	data_present <= select_signal(15) or select_signal(14) or select_signal(13) or select_signal(12) or
						select_signal(11) or select_signal(10) or select_signal(9) or select_signal(8) or
						select_signal(7) or select_signal(6) or select_signal(5) or select_signal(4) or
						select_signal(3) or select_signal(2) or select_signal(1) or select_signal(0);
																														
	buffering : process (CLK, RESET_n, hazard, data_present, data) begin
		if (RESET_n = '0') then
			buffer_output <= "00000000000000000000000000000000";
		elsif (rising_edge(CLK)) then
			if (data_present = '1' and hazard = '1') then
				buffer_output <= data;
			end if;
		end if;
	end process;
	
	hazard_detect : process (hazard, data, data_buffer, RESET_n, buffer_output, data_present, CLK) begin
		if (RESET_n = '0') then
			data_buffer <= "00000000000000000000000000000000";
		elsif (rising_edge(CLK))then		--was on rising edge hazard
			if (hazard_rising_edge = '1') then					--this if never existed
				if (data_present = '1') then
					data_buffer <= data;
				else
					data_buffer <= buffer_output;
				end if;
			end if;
		end if;
		
		if (hazard = '0')then
			if (data_present = '1') then
				data_out <= data;
			else
				data_out <= buffer_output;
			end if;
		else
			data_out <= data_buffer;
		end if;
	end process;
	
end;