library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Compute_Group is
	PORT (
			ADDRESS_A  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_B  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_C  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_0  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_1  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_W  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_IO : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_IO	  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			IO_ENABLE  : IN STD_LOGIC;
			DATA_TO_W  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			W_EN		  : OUT STD_LOGIC;
			CLK		  : IN STD_LOGIC;
			RESET_n    : IN STD_LOGIC;
			GLOBAL_EN  : OUT STD_LOGIC;
			IDENT_IN	  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			DATA_OUT_A : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_B : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_C : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			STALL_GLOB : IN STD_LOGIC
			);
end;

architecture cg of Compute_Group is

	component MAGIC
		PORT (
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
			HAZ_GLOB	  : IN STD_LOGIC;
			DATA_OUT_A : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_B : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_C : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_OUT_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			C0_STALL	  : OUT STD_LOGIC;
			C1_STALL	  : OUT STD_LOGIC;
			CORE_IDENT : OUT STD_LOGIC;
			IO_ENABLE  : IN STD_LOGIC
			);
	end component;
	
	component LOAD_BALANCER
		PORT (
			CORE_ID 	: IN STD_LOGIC;
			
			ADDRESS_A_C0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_B_C0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_C_C0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_0_C0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_1_C0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_W_C0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_TO_W_C0  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			W_EN_C0		  : IN STD_LOGIC;
			
			ADDRESS_A_C1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_B_C1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_C_C1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_0_C1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_1_C1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_W_C1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_TO_W_C1  : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			W_EN_C1		  : IN STD_LOGIC;
			
			ADDRESS_IO		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_IO			: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			IO_ENABLE		: IN STD_LOGIC;
			
			global_enable	: IN STD_LOGIC_VECTOR (5 downto 0);

			ADDRESS_A_MAG  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_B_MAG  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_C_MAG  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_0_MAG  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_1_MAG  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			ADDRESS_W_MAG  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			DATA_TO_W_MAG  : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			W_EN_MAG		  	: OUT STD_LOGIC
			);
	end component;
	
	component purisc_core
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
	end component;
	
	component BIST_core
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
	end component;
	
	
	signal address_a_sig : std_logic_vector(31 downto 0);
	signal address_b_sig : std_logic_vector(31 downto 0);
	signal address_c_sig : std_logic_vector(31 downto 0);
	signal address_0_sig : std_logic_vector(31 downto 0);
	signal address_1_sig : std_logic_vector(31 downto 0);
	signal address_w_sig : std_logic_vector(31 downto 0);
	signal data_to_w_sig : std_logic_vector(31 downto 0);
	signal w_en_sig : std_logic;
	signal w_en_local : std_logic;
	signal w_en_global : std_logic;
	
	signal address_a_sig_c0 : std_logic_vector(31 downto 0);
	signal address_b_sig_c0 : std_logic_vector(31 downto 0);
	signal address_c_sig_c0 : std_logic_vector(31 downto 0);
	signal address_0_sig_c0 : std_logic_vector(31 downto 0);
	signal address_1_sig_c0 : std_logic_vector(31 downto 0);
	signal address_w_sig_c0 : std_logic_vector(31 downto 0);
	signal data_to_w_sig_c0 : std_logic_vector(31 downto 0);
	signal w_en_sig_c0 : std_logic;
	
	signal address_a_sig_c1 : std_logic_vector(31 downto 0);
	signal address_b_sig_c1 : std_logic_vector(31 downto 0);
	signal address_c_sig_c1 : std_logic_vector(31 downto 0);
	signal address_0_sig_c1 : std_logic_vector(31 downto 0);
	signal address_1_sig_c1 : std_logic_vector(31 downto 0);
	signal address_w_sig_c1 : std_logic_vector(31 downto 0);
	signal data_to_w_sig_c1 : std_logic_vector(31 downto 0);
	signal w_en_sig_c1 : std_logic;
	
	signal data_a : std_logic_vector(31 downto 0);
	signal data_b : std_logic_vector(31 downto 0);
	signal data_c : std_logic_vector(31 downto 0);
	signal data_0 : std_logic_vector(31 downto 0);
	signal data_1 : std_logic_vector(31 downto 0);
	
	signal data_a_final : std_logic_vector(31 downto 0);
	signal data_b_final : std_logic_vector(31 downto 0);
	signal data_c_final : std_logic_vector(31 downto 0);
	signal data_0_final : std_logic_vector(31 downto 0);
	signal data_1_final : std_logic_vector(31 downto 0);
	
	signal data_a_c0_buff : std_logic_vector(31 downto 0);
	signal data_b_c0_buff : std_logic_vector(31 downto 0);
	signal data_c_c0_buff : std_logic_vector(31 downto 0);
	signal data_0_c0_buff : std_logic_vector(31 downto 0);
	signal data_1_c0_buff : std_logic_vector(31 downto 0);

	signal data_a_c1 : std_logic_vector(31 downto 0);
	signal data_b_c1 : std_logic_vector(31 downto 0);
	signal data_c_c1 : std_logic_vector(31 downto 0);
	signal data_0_c1 : std_logic_vector(31 downto 0);
	signal data_1_c1 : std_logic_vector(31 downto 0);
	
	signal data_a_c1_buff : std_logic_vector(31 downto 0);
	signal data_b_c1_buff : std_logic_vector(31 downto 0);
	signal data_c_c1_buff : std_logic_vector(31 downto 0);
	signal data_0_c1_buff : std_logic_vector(31 downto 0);
	signal data_1_c1_buff : std_logic_vector(31 downto 0);
		
	signal stall_c0 : std_logic;
	signal stall_c1 : std_logic;
	signal stall_c0_io : std_logic;
	signal stall_c1_io : std_logic;
	signal core_id  : std_logic;
	signal io_buffer_en : std_logic;
	signal flags_0 : std_logic_vector(2 downto 0);
	signal flags_1 : std_logic_vector(2 downto 0);
	signal global_enable : std_logic_vector(5 downto 0);
	signal global_enable_delayed : std_logic_vector(5 downto 0);
	signal global_enable_delayed_2 : std_logic_vector(5 downto 0);
	signal global_data_buffer_flag_delay : std_logic;
	signal global_data_buffer_flag : std_logic;
	signal global_buffer_enable : std_logic;
	signal global_data_feed_a : std_logic_vector(31 downto 0);
	signal global_data_feed_b : std_logic_vector(31 downto 0);
	signal global_data_feed_c : std_logic_vector(31 downto 0);
	signal global_data_feed_0 : std_logic_vector(31 downto 0);
	signal global_data_feed_1 : std_logic_vector(31 downto 0);
	signal global_data_buffer_a : std_logic_vector(31 downto 0);
	signal global_data_buffer_b : std_logic_vector(31 downto 0);
	signal global_data_buffer_c : std_logic_vector(31 downto 0);
	signal global_data_buffer_0 : std_logic_vector(31 downto 0);
	signal global_data_buffer_1 : std_logic_vector(31 downto 0);
	signal hold_local : std_logic;
	signal hazard : std_logic;
	signal override_global : std_logic;
	signal startup_hold_1 : std_logic;
	signal startup_hold_2 : std_logic;
	signal startup_hold_3 : std_logic;
	signal startup_hold_4 : std_logic;
	signal startup_hold_5 : std_logic;
	
	signal FUCK : std_logic;
	signal dick : std_logic;

begin

	core_0 : purisc_core PORT MAP(
											clk => CLK,
											reset_n => RESET_n,
											r_addr_a => address_a_sig_c0,
											r_addr_b => address_b_sig_c0,
											r_addr_c => address_c_sig_c0,
											r_addr_0 => address_0_sig_c0,
											r_addr_1 => address_1_sig_c0,
											w_addr => address_w_sig_c0,
											we => w_en_sig_c0,
											w_data => data_to_w_sig_c0,
											stall => stall_c0_io,
											id => flags_0,
											r_data_a => data_a_final,
											r_data_b => data_b_final,
											r_data_c => data_c_final,
											r_data_0 => data_0_final,
											r_data_1 => data_1_final
											);
									
	core_1 : purisc_core PORT MAP(
											clk => CLK,
											reset_n => RESET_n,
											r_addr_a => address_a_sig_c1,
											r_addr_b => address_b_sig_c1,
											r_addr_c => address_c_sig_c1,
											r_addr_0 => address_0_sig_c1,
											r_addr_1 => address_1_sig_c1,
											w_addr => address_w_sig_c1,
											we => w_en_sig_c1,
											w_data => data_to_w_sig_c1,
											stall => stall_c1_io,
											id => flags_1,
											r_data_a => data_a_final,
											r_data_b => data_b_final,
											r_data_c => data_c_final,
											r_data_0 => data_0_final,
											r_data_1 => data_1_final
											);
									
	cache : MAGIC PORT MAP (
									ADDRESS_A => address_a_sig,
									ADDRESS_B => address_b_sig,
									ADDRESS_C => address_c_sig,
									ADDRESS_0 => address_0_sig,
									ADDRESS_1 => address_1_sig,
									ADDRESS_W => address_w_sig,
									DATA_TO_W => data_to_w_sig,
									W_EN => w_en_local,
									CLK => CLK,
									RESET_n => RESET_n,
									HAZ_GLOB => STALL_GLOB,
									DATA_OUT_A => data_a,
									DATA_OUT_B => data_b,
									DATA_OUT_C => data_c,
									DATA_OUT_0 => data_0,
									DATA_OUT_1 => data_1,
									C0_STALL => stall_c0,
									C1_STALL	=> stall_c1,
									CORE_IDENT => core_id,
									IO_ENABLE => hold_local
									);
									
	balance : LOAD_BALANCER PORT MAP(
												CORE_ID => core_id,
												
												ADDRESS_A_C0 => address_a_sig_c0,
												ADDRESS_B_C0 => address_b_sig_c0,
												ADDRESS_C_C0 => address_c_sig_c0,
												ADDRESS_0_C0 => address_0_sig_c0,
												ADDRESS_1_C0 => address_1_sig_c0,
												ADDRESS_W_C0 => address_w_sig_c0,
												DATA_TO_W_C0 => data_to_w_sig_c0,
												W_EN_C0 => w_en_sig_c0,
												
												ADDRESS_A_C1 => address_a_sig_c1,
												ADDRESS_B_C1 => address_b_sig_c1,
												ADDRESS_C_C1 => address_c_sig_c1,
												ADDRESS_0_C1 => address_0_sig_c1,
												ADDRESS_1_C1 => address_1_sig_c1,
												ADDRESS_W_C1 => address_w_sig_c1,
												DATA_TO_W_C1 => data_to_w_sig_c1,
												W_EN_C1 => w_en_sig_c1,
												
												ADDRESS_IO => ADDRESS_IO,
												DATA_IO => DATA_IO,
												IO_ENABLE => IO_ENABLE,
												
												global_enable => global_enable,
									
												ADDRESS_A_MAG => address_a_sig,
												ADDRESS_B_MAG => address_b_sig,
												ADDRESS_C_MAG => address_c_sig,
												ADDRESS_0_MAG => address_0_sig,
												ADDRESS_1_MAG => address_1_sig,
												ADDRESS_W_MAG => address_w_sig,
												DATA_TO_W_MAG => data_to_w_sig,
												W_EN_MAG	=> w_en_sig
												);
	
	
	process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			startup_hold_1 <= '1';
			startup_hold_2 <= '1';
			startup_hold_3 <= '1';
			startup_hold_4 <= '1';
			startup_hold_5 <= '1';
		elsif (rising_edge(CLK)) then
			startup_hold_1 <= not RESET_n;
			startup_hold_2 <= startup_hold_1;
			startup_hold_3 <= startup_hold_2;
			startup_hold_4 <= startup_hold_3;
			startup_hold_5 <= startup_hold_4;
		end if;
	end process;
	
	process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			override_global <= '1';
		elsif (rising_edge(CLK)) then
			if ((STALL_GLOB = '0') and (hazard = '1')) then
				override_global <= '0';
			else
				override_global <= '1';
			end if;
		end if;
	end process;
	
	process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			global_enable_delayed <= "000000";
			global_enable_delayed_2 <= "000000";
		elsif (rising_edge(CLK)) then
			global_enable_delayed_2 <= global_enable_delayed;
			if ((stall_c0_io and stall_c1_io) = '0') then   --OR STALL GLOBAL = 0
				global_enable_delayed <= global_enable;	
			end if;
		end if;
	end process;
	
	process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			global_data_buffer_flag_delay <= '0';
			--FUCK <= '0';
		elsif (rising_edge(CLK)) then
			global_data_buffer_flag_delay <= global_data_buffer_flag;
			--FUCK <= dick;
		end if;
	end process;
	global_buffer_enable <= (global_data_buffer_flag_delay xor global_data_buffer_flag) and global_data_buffer_flag;
	
	process (CLK, RESET_n) begin
		if (RESET_n = '0') then
			global_data_buffer_a <= "00000000000000000000000000000000";
			global_data_buffer_b <= "00000000000000000000000000000000";
			global_data_buffer_c <= "00000000000000000000000000000000";
			global_data_buffer_0 <= "00000000000000000000000000000000";
			global_data_buffer_1 <= "00000000000000000000000000000000";
		elsif (rising_edge(CLK)) then
			if (global_buffer_enable = '1') then
				global_data_buffer_a <= DATA_OUT_A;
				global_data_buffer_b <= DATA_OUT_B;
				global_data_buffer_c <= DATA_OUT_C;
				global_data_buffer_0 <= DATA_OUT_0;
				global_data_buffer_1 <= DATA_OUT_1;
			end if;
		end if;
	end process;
	
	process (global_enable, global_enable_delayed, global_enable_delayed_2, DATA_OUT_A, DATA_OUT_B, DATA_OUT_C,
				DATA_OUT_0, DATA_OUT_1, global_data_buffer_a, global_data_buffer_b, global_data_buffer_c, 
				global_data_buffer_0, global_data_buffer_1, hazard) begin
		if ((global_enable_delayed = global_enable_delayed_2) and 
			((global_enable(5) or global_enable(4) or global_enable(3) or global_enable(2) or 
				global_enable(1) or global_enable(0)) = '1')) then
			global_data_buffer_flag <= hazard;
			global_data_feed_a <= global_data_buffer_a;
			global_data_feed_b <= global_data_buffer_b;
			global_data_feed_c <= global_data_buffer_c;
			global_data_feed_0 <= global_data_buffer_0;
			global_data_feed_1 <= global_data_buffer_1;
		else
			global_data_buffer_flag <= '0';
			global_data_feed_a <= DATA_OUT_A;
			global_data_feed_b <= DATA_OUT_B;
			global_data_feed_c <= DATA_OUT_C;
			global_data_feed_0 <= DATA_OUT_0;
			global_data_feed_1 <= DATA_OUT_1;
		end if;
	end process;
	
	
	process (global_enable_delayed, data_a, data_b, data_c, data_0, data_1,
				DATA_OUT_A, DATA_OUT_B, DATA_OUT_C, DATA_OUT_0, DATA_OUT_1, global_data_feed_a,
				global_data_feed_b, global_data_feed_c, global_data_feed_0, global_data_feed_1) begin
		if(global_enable_delayed(5) = '1') then
			data_a_final <= global_data_feed_a;
		else
			data_a_final <= data_a;
		end if;
		if(global_enable_delayed(4) = '1') then
			data_b_final <= global_data_feed_b;
		else
			data_b_final <= data_b;
		end if;
		if(global_enable_delayed(3) = '1') then
			data_c_final <= global_data_feed_c;
		else
			data_c_final <= data_c;
		end if;
		if(global_enable_delayed(2) = '1') then
			data_0_final <= global_data_feed_0;
		else
			data_0_final <= data_0;
		end if;
		if(global_enable_delayed(1) = '1') then
			data_1_final <= global_data_feed_1;
		else
			data_1_final <= data_1;
		end if;
	end process;
	
	flags_0 <= IDENT_IN & '0';
	flags_1 <= IDENT_IN & '1';
	ADDRESS_A <= address_a_sig;
	ADDRESS_B <= address_b_sig;
	ADDRESS_C <= address_c_sig;
	ADDRESS_0 <= address_0_sig;
	ADDRESS_1 <= address_1_sig;
	ADDRESS_W <= address_w_sig;
	DATA_TO_W <= data_to_w_sig;
	W_EN <= w_en_global;
	stall_c0_io <= (stall_c0 or IO_ENABLE or STALL_GLOB or startup_hold_5);
	stall_c1_io <= (stall_c1 or IO_ENABLE or STALL_GLOB or startup_hold_5);
	global_enable(5) <= address_a_sig(14) or address_a_sig(13) or address_a_sig(15);  --a
	global_enable(4) <= address_b_sig(14) or address_b_sig(13) or address_a_sig(15);  --b
	global_enable(3) <= address_c_sig(14) or address_c_sig(13) or address_a_sig(15);  --c
	global_enable(2) <= address_0_sig(14) or address_0_sig(13) or address_a_sig(15);  --0
	global_enable(1) <= address_1_sig(14) or address_1_sig(13) or address_a_sig(15);  --1
	global_enable(0) <= address_w_sig(14) or address_w_sig(13) or address_a_sig(15);  --w
	GLOBAL_EN <= dick;
	dick <= (global_enable(5) or global_enable(4) or global_enable(3) or global_enable(2) or global_enable(1) or global_enable(0)) and override_global;
	w_en_local <= w_en_sig and (not global_enable(0));
	w_en_global <= w_en_sig and (global_enable(0));
	hold_local <= IO_ENABLE or STALL_GLOB;
	hazard <= stall_c0_io and stall_c1_io;
	
end;