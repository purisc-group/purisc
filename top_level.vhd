library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
	PORT(
		--ONLY PHY CONNECTIONS IN TOP LEVEL
		CLOCK_50 : IN STD_LOGIC;
		SW : IN STD_LOGIC_VECTOR(17 downto 0);
		HEX0, HEX1, HEX2, HEX3, 
		HEX4, HEX5, HEX6, HEX7 : OUT std_logic_vector(6 downto 0);
		ENET0_MDC : OUT STD_LOGIC;          -- Management data clock reference
		ENET0_MDIO : INOUT STD_LOGIC;			-- Management Data
		ENET0_RESET_N : OUT STD_LOGIC;			-- Hardware reset Signal
		ENET0_RX_CLK : IN STD_LOGIC;		  	-- GMII/MII Receive clock
		ENET0_RX_COL : IN STD_LOGIC;        -- GMII/MII Collision
		ENET0_RX_CRS : IN STD_LOGIC;			-- GMII/MII Carrier sense
		ENET0_RX_DATA  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);      -- GMII/MII Receive data
		ENET0_RX_DV : IN STD_LOGIC;        -- GMII/MII Receive data valid
		ENET0_RX_ER : IN STD_LOGIC;       -- GMII/MII Receive error
		ENET0_TX_CLK : IN STD_LOGIC;     -- MII Transmit Clock
		ENET0_TX_DATA : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);      -- MII Transmit Data
		ENET0_TX_EN : OUT STD_LOGIC;        -- GMII/MII Transmit enable
		ENET0_TX_ER : OUT STD_LOGIC
		);
end;

architecture purisc of top_level is
	component io_controller
		PORT(
			CLOCK_50 : IN STD_LOGIC;
			RESET 	: IN STD_LOGIC;
				 
			wb_mem_adr_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			wb_mem_sel_o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			wb_mem_we_o	: OUT STD_LOGIC;
			wb_mem_cyc_o : OUT STD_LOGIC;
			wb_mem_stb_o : OUT STD_LOGIC;
			wb_mem_ack_i : IN STD_LOGIC;
			wb_mem_dat_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			wb_mem_dat_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			wb_mem_err_i : IN STD_LOGIC;

			ENET0_MDC : OUT STD_LOGIC;             -- Management data clock reference
			ENET0_MDIO : INOUT STD_LOGIC;            -- Management Data
			ENET0_RST_N : OUT STD_LOGIC;        -- Hardware reset Signal
			ENET0_RX_CLK : IN STD_LOGIC;        -- GMII/MII Receive clock
			ENET0_RX_COL : IN STD_LOGIC;        -- GMII/MII Collision
			ENET0_RX_CRS : IN STD_LOGIC;        -- GMII/MII Carrier sense
			ENET0_RX_DATA : IN STD_LOGIC_VECTOR(3 DOWNTO 0);        -- GMII/MII Receive data
			ENET0_RX_DV : IN STD_LOGIC;        -- GMII/MII Receive data valid
			ENET0_RX_ER : IN STD_LOGIC;        -- GMII/MII Receive error
			ENET0_TX_CLK : IN STD_LOGIC;        -- MII Transmit Clock
			ENET0_TX_DATA : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);        -- MII Transmit Data
			ENET0_TX_EN : OUT STD_LOGIC;        -- GMII/MII Transmit enable
			ENET0_TX_ER : OUT STD_LOGIC;         -- GMII/MII Transmit error

			M : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			arq_n : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            tx_len : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            
            flag_ready : OUT STD_LOGIC;
            flag_done_clear : OUT STD_LOGIC;
            flag_ack : IN STD_LOGIC;
            flag_done : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				 
			hex_val0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			hex_val1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			hex_val2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			hex_val3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
				 
			hex_val4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			hex_val5 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			hex_val6 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			hex_val7 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			);
	end component;
	
	component io_memory_controller
		PORT(
		     wb_rst_i : IN STD_LOGIC;
			 wb_clk_i : IN STD_LOGIC;
			 --connections to magics
			 mem_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			 mem_data_w : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			 mem_we : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			 mem_gl_en : OUT STD_LOGIC;
			 mem_gl_data_r : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

			 --WISHBONE slave
			 wb_adr_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);   -- WISHBONE address input
			 wb_sel_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);   -- WISHBONE byte select input
			 wb_we_i : IN STD_LOGIC;    -- WISHBONE write enable input
			 wb_cyc_i : IN STD_LOGIC;   -- WISHBONE cycle input
			 wb_stb_i : IN STD_LOGIC;   -- WISHBONE strobe input
			 wb_ack_o : OUT STD_LOGIC;   -- WISHBONE acknowledge output
			 wb_dat_i : IN STD_LOGIC_VECTOR(31 DOWNTO 0);   -- WISHBONE data input
			 wb_dat_o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);   -- WISHBONE data output
			 wb_err_o : OUT STD_LOGIC;   -- WISHBONE error output
			 M : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
             
             flag_ready : IN STD_LOGIC;
             flag_ack : OUT STD_LOGIC;
             flag_done_clear : IN STD_LOGIC;
    
			 arq_n : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
             tx_len : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
	end component;
			 
	component global_memory
		PORT (
			CLK		: IN STD_LOGIC;
			RESET_n	: IN STD_LOGIC;
						--compute group 0
			ADDRESS_A_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_B_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_C_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_0_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_1_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_W_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_CG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_CG0		  : IN STD_LOGIC;
			ENABLE_CG0	  : IN STD_LOGIC;
			DATA_A_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_B_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_C_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_1_TO_CG0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			STALL_CG0	  : OUT STD_LOGIC;
						--compute group 1
			ADDRESS_A_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_B_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_C_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_0_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_1_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_W_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_CG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_CG1		  : IN STD_LOGIC;
			ENABLE_CG1	  : IN STD_LOGIC;
			DATA_A_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_B_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_C_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_1_TO_CG1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			STALL_CG1	  : OUT STD_LOGIC;
						--compute group 2
			ADDRESS_A_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_B_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_C_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_0_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_1_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_W_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_CG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_CG2		  : IN STD_LOGIC;
			ENABLE_CG2	  : IN STD_LOGIC;
			DATA_A_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_B_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_C_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_1_TO_CG2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			STALL_CG2	  : OUT STD_LOGIC;
					--compute group 3
			ADDRESS_A_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_B_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_C_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_0_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_1_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDRESS_W_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_CG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_CG3		  : IN STD_LOGIC;
			ENABLE_CG3	  : IN STD_LOGIC;
			DATA_A_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_B_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_C_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_0_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_1_TO_CG3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			STALL_CG3	  : OUT STD_LOGIC;
						--IO controller
			ADDRESS_IO    : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			DATA_TO_W_IO  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			W_EN_IO		  : IN STD_LOGIC;
			ENABLE_IO	  : IN STD_LOGIC;
			DATA_RET_IO   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
                        --DONE signals
            DONE_C0       : OUT STD_LOGIC;
            DONE_C1       : OUT STD_LOGIC;
            DONE_C2       : OUT STD_LOGIC;
            DONE_C3       : OUT STD_LOGIC;
            DONE_C4       : OUT STD_LOGIC;
            DONE_C5       : OUT STD_LOGIC;
            DONE_C6       : OUT STD_LOGIC;
            DONE_C7       : OUT STD_LOGIC;
            RCC           : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
			);
	end component;
	
	component Compute_Group
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
	end component;
	
	component convert_to_seven_seg
		port (
			data_in : in std_logic_vector(3 downto 0);
			hex_out : out std_logic_vector(6 downto 0)
		);
	end component;
	
	signal ident_cg0 : std_logic_vector(1 downto 0);
	signal ident_cg1 : std_logic_vector(1 downto 0);
	signal ident_cg2 : std_logic_vector(1 downto 0);
	signal ident_cg3 : std_logic_vector(1 downto 0);
	
	signal address_a_cg0_sig : std_logic_vector(31 downto 0);
	signal address_b_cg0_sig : std_logic_vector(31 downto 0);
	signal address_c_cg0_sig : std_logic_vector(31 downto 0);
	signal address_0_cg0_sig : std_logic_vector(31 downto 0);
	signal address_1_cg0_sig : std_logic_vector(31 downto 0);
	signal address_w_cg0_sig : std_logic_vector(31 downto 0);
	signal data_to_w_cg0_sig : std_logic_vector(31 downto 0);
	signal w_en_cg0_sig : std_logic;
	signal enable_global_cg0_sig : std_logic;
	signal stall_global_cg0_sig : std_logic;
	signal data_a_cg0_sig : std_logic_vector(31 downto 0);
	signal data_b_cg0_sig : std_logic_vector(31 downto 0);
	signal data_c_cg0_sig : std_logic_vector(31 downto 0);
	signal data_0_cg0_sig : std_logic_vector(31 downto 0);
	signal data_1_cg0_sig : std_logic_vector(31 downto 0);
	
	signal address_a_cg1_sig : std_logic_vector(31 downto 0);
	signal address_b_cg1_sig : std_logic_vector(31 downto 0);
	signal address_c_cg1_sig : std_logic_vector(31 downto 0);
	signal address_0_cg1_sig : std_logic_vector(31 downto 0);
	signal address_1_cg1_sig : std_logic_vector(31 downto 0);
	signal address_w_cg1_sig : std_logic_vector(31 downto 0);
	signal data_to_w_cg1_sig : std_logic_vector(31 downto 0);
	signal w_en_cg1_sig : std_logic;
	signal enable_global_cg1_sig : std_logic;
	signal stall_global_cg1_sig : std_logic;
	signal data_a_cg1_sig : std_logic_vector(31 downto 0);
	signal data_b_cg1_sig : std_logic_vector(31 downto 0);
	signal data_c_cg1_sig : std_logic_vector(31 downto 0);
	signal data_0_cg1_sig : std_logic_vector(31 downto 0);
	signal data_1_cg1_sig : std_logic_vector(31 downto 0);

	signal address_a_cg2_sig : std_logic_vector(31 downto 0);
	signal address_b_cg2_sig : std_logic_vector(31 downto 0);
	signal address_c_cg2_sig : std_logic_vector(31 downto 0);
	signal address_0_cg2_sig : std_logic_vector(31 downto 0);
	signal address_1_cg2_sig : std_logic_vector(31 downto 0);
	signal address_w_cg2_sig : std_logic_vector(31 downto 0);
	signal data_to_w_cg2_sig : std_logic_vector(31 downto 0);
	signal w_en_cg2_sig : std_logic;
	signal enable_global_cg2_sig : std_logic;
	signal stall_global_cg2_sig : std_logic;
	signal data_a_cg2_sig : std_logic_vector(31 downto 0);
	signal data_b_cg2_sig : std_logic_vector(31 downto 0);
	signal data_c_cg2_sig : std_logic_vector(31 downto 0);
	signal data_0_cg2_sig : std_logic_vector(31 downto 0);
	signal data_1_cg2_sig : std_logic_vector(31 downto 0);
	
	signal address_a_cg3_sig : std_logic_vector(31 downto 0);
	signal address_b_cg3_sig : std_logic_vector(31 downto 0);
	signal address_c_cg3_sig : std_logic_vector(31 downto 0);
	signal address_0_cg3_sig : std_logic_vector(31 downto 0);
	signal address_1_cg3_sig : std_logic_vector(31 downto 0);
	signal address_w_cg3_sig : std_logic_vector(31 downto 0);
	signal data_to_w_cg3_sig : std_logic_vector(31 downto 0);
	signal w_en_cg3_sig : std_logic;
	signal enable_global_cg3_sig : std_logic;
	signal stall_global_cg3_sig : std_logic;
	signal data_a_cg3_sig : std_logic_vector(31 downto 0);
	signal data_b_cg3_sig : std_logic_vector(31 downto 0);
	signal data_c_cg3_sig : std_logic_vector(31 downto 0);
	signal data_0_cg3_sig : std_logic_vector(31 downto 0);
	signal data_1_cg3_sig : std_logic_vector(31 downto 0);
	
	signal address_io_sig : std_logic_vector(31 downto 0);
	signal data_to_w_io_sig : std_logic_vector(31 downto 0);
	signal data_read_io_sig : std_logic_vector(31 downto 0);
	signal w_en_io_sig : std_logic;
	signal enable_io_cg0 : std_logic;
	signal enable_io_cg1 : std_logic;
	signal enable_io_cg2 : std_logic;
	signal enable_io_cg3 : std_logic;
	signal enable_io_global : std_logic;
	
--	signal test_reg : std_logic_vector(31 downto 0);
	
	signal RESET_n : std_logic;
	signal RESET : std_logic;
	
	signal wb_adr : std_logic_vector(31 downto 0);
	signal wb_sel : std_logic_vector(3 downto 0);
	signal wb_we : std_logic;
	signal wb_cyc : std_logic;
	signal wb_stb : std_logic;
	signal wb_ack : std_logic;
	signal wb_dat_o : std_logic_vector(31 downto 0);
	signal wb_dat_i :	std_logic_vector(31 downto 0);
	signal wb_err : std_logic;
	signal M : std_logic_vector(15 downto 0);
	signal hex_val0 : std_logic_vector(3 downto 0);
	signal hex_val1 : std_logic_vector(3 downto 0);
	signal hex_val2 : std_logic_vector(3 downto 0);
	signal hex_val3 : std_logic_vector(3 downto 0);
	signal hex_val4 : std_logic_vector(3 downto 0);
	signal hex_val5 : std_logic_vector(3 downto 0);
	signal hex_val6 : std_logic_vector(3 downto 0);
	signal hex_val7 : std_logic_vector(3 downto 0);
	signal mem_we : std_logic_vector(4 downto 0);
	
	signal to_hex_0 : std_logic_vector(3 downto 0);
	signal to_hex_1 : std_logic_vector(3 downto 0);
	signal to_hex_2 : std_logic_vector(3 downto 0);
	signal to_hex_3 : std_logic_vector(3 downto 0);
	signal to_hex_4 : std_logic_vector(3 downto 0);
	signal to_hex_5 : std_logic_vector(3 downto 0);
	signal to_hex_6 : std_logic_vector(3 downto 0);
	signal to_hex_7 : std_logic_vector(3 downto 0);
	
	signal test_float_a : std_logic_vector(31 downto 0);
	signal test_float_b : std_logic_vector(31 downto 0);
	signal test_float_c : std_logic_vector(4 downto 0);
	signal test_float_d : std_logic;
	signal test_float_e : std_logic_vector(31 downto 0);
	
	signal arq_n : std_logic_vector(15 downto 0);
    signal tx_len : std_logic_vector(15 downto 0);
    
    signal flag_ready : std_logic;
    signal flag_ack : std_logic;
    signal flag_done : std_logic_vector(7 downto 0);
    signal flag_done_clear : std_logic;
    
    signal DONE_C0 : std_logic;
    signal DONE_C1 : std_logic;
    signal DONE_C2 : std_logic;
    signal DONE_C3 : std_logic;
    signal DONE_C4 : std_logic;
    signal DONE_C5 : std_logic;
    signal DONE_C6 : std_logic;
    signal DONE_C7 : std_logic;
    
    signal perf_counter : unsigned(63 downto 0);
    signal counter_active : std_logic;
    signal ready_rising_edge : std_logic;
    signal done_rising_edge : std_logic;
    signal all_done : std_logic;
    signal all_done_buff : std_logic;
    signal ready_buff : std_logic;
    signal RCC : std_logic_vector(3 downto 0);
    
    signal enable_io_global_raw : std_logic;
     
	
begin

	RESET_n <= SW(17);
	RESET <= not RESET_n;

	--IO CONTROLLER SIGNALS HARDCODED FOR NOW
	ident_cg0 <= "00";
	ident_cg1 <= "01";
	ident_cg2 <= "10";
	ident_cg3 <= "11";
--	address_io_sig <= "00000000000000000000000000000000";
--	data_to_w_io_sig <= "00000000000000000000000000000000";
--	w_en_io_sig <= '0';
--	enable_io_cg0 <= '0';
--	enable_io_cg1 <= '0';
--	enable_io_cg2 <= '0';
--	enable_io_cg3 <= '0';
--	enable_io_global <= '0';
	enable_io_cg0 <= mem_we(0);
	enable_io_cg1 <= mem_we(1);
	enable_io_cg2 <= mem_we(2);
	enable_io_cg3 <= mem_we(3);
------	w_en_cg0_sig <= mem_we(0);
------	w_en_cg1_sig <= mem_we(1);
------	w_en_cg2_sig <= mem_we(2);
------	w_en_cg3_sig <= mem_we(3);
	w_en_io_sig <= mem_we(4);
    enable_io_global <= enable_io_global_raw or w_en_io_sig;

	
	ioc : io_controller PORT MAP(
                                 CLOCK_50 => CLOCK_50,
                                 RESET => RESET, 
                                 
                                 wb_mem_adr_o => wb_adr,
                                 wb_mem_sel_o => wb_sel,
                                 wb_mem_we_o => wb_we,
                                 wb_mem_cyc_o => wb_cyc,
                                 wb_mem_stb_o => wb_stb,
                                 wb_mem_ack_i => wb_ack,
                                 wb_mem_dat_o => wb_dat_o,
                                 wb_mem_dat_i => wb_dat_i,
                                 wb_mem_err_i => wb_err,
    
                                 ENET0_MDC => ENET0_MDC,          -- Management data clock reference
                                 ENET0_MDIO => ENET0_MDIO,       -- Management Data
                                 ENET0_RST_N => ENET0_RESET_N,  -- Hardware reset Signal
                                 ENET0_RX_CLK => ENET0_RX_CLK,     -- GMII/MII Receive clock
                                 ENET0_RX_COL => ENET0_RX_COL,       -- GMII/MII Collision
                                 ENET0_RX_CRS => ENET0_RX_CRS,        -- GMII/MII Carrier sense
                                 ENET0_RX_DATA => ENET0_RX_DATA,       -- GMII/MII Receive data
                                 ENET0_RX_DV => ENET0_RX_DV,        -- GMII/MII Receive data valid
                                 ENET0_RX_ER => ENET0_RX_ER,       -- GMII/MII Receive error
                                 ENET0_TX_CLK => ENET0_TX_CLK,     -- MII Transmit Clock
                                 ENET0_TX_DATA => ENET0_TX_DATA,       -- MII Transmit Data
                                 ENET0_TX_EN => ENET0_TX_EN,        -- GMII/MII Transmit enable
                                 ENET0_TX_ER => ENET0_TX_ER,        -- GMII/MII Transmit error
    
                                 M => M,
                                 
                                 flag_ready => flag_ready,
                                 flag_ack => flag_ack,
                                 flag_done_clear => flag_done_clear,
                                 flag_done => flag_done,
                                 
                                 hex_val0 => hex_val0,
                                 hex_val1 => hex_val1,
                                 hex_val2 => hex_val2,
                                 hex_val3 => hex_val3,
                                 
                                 hex_val4 => hex_val4,
                                 hex_val5 => hex_val5,
                                 hex_val6 => hex_val6,
                                 hex_val7 => hex_val7,
                                 
                                 arq_n => arq_n,
                                 tx_len => tx_len
                                 );
											
	iomc : io_memory_controller PORT MAP(
                                             --connections to magics
                                         mem_addr => address_io_sig,
                                         mem_data_w => data_to_w_io_sig,
                                         mem_we => mem_we,
                                         mem_gl_en => enable_io_global_raw,
                                         mem_gl_data_r => data_read_io_sig,

                                         wb_clk_i => CLOCK_50,    -- WISHBONE clock
                                         wb_rst_i => RESET,       -- WISHBONE reset
                                         wb_adr_i => wb_adr,      -- WISHBONE address input
                                         wb_sel_i => wb_sel,      -- WISHBONE byte select input
                                         wb_we_i => wb_we,        -- WISHBONE write enable input
                                         wb_cyc_i => wb_cyc,      -- WISHBONE cycle input
                                         wb_stb_i => wb_stb,      -- WISHBONE strobe input
                                         wb_ack_o => wb_ack,      -- WISHBONE acknowledge output
                                         wb_dat_i => wb_dat_o,    -- WISHBONE data input
                                         wb_dat_o => wb_dat_i,    -- WISHBONE data output
                                         wb_err_o => wb_err,      -- WISHBONE error output
                                         
                                         M => M,
                                         
                                         flag_ready => flag_ready,
                                         flag_ack => flag_ack,
                                         flag_done_clear => flag_done_clear,
                                         
                                         arq_n => arq_n,
                                         tx_len => tx_len
                                         );
	
	
	Compute_Group_0 : Compute_Group PORT MAP (
                                                ADDRESS_A => address_a_cg0_sig,
                                                ADDRESS_B => address_b_cg0_sig,
                                                ADDRESS_C => address_c_cg0_sig,
                                                ADDRESS_0 => address_0_cg0_sig,
                                                ADDRESS_1 => address_1_cg0_sig,
                                                ADDRESS_W => address_w_cg0_sig,
                                                ADDRESS_IO => address_io_sig,
                                                DATA_IO => data_to_w_io_sig,
                                                IO_ENABLE => enable_io_cg0,
                                                DATA_TO_W => data_to_w_cg0_sig,
                                                W_EN => w_en_cg0_sig,
                                                CLK => CLOCK_50,
                                                RESET_n => RESET_n,
                                                GLOBAL_EN => enable_global_cg0_sig,
                                                IDENT_IN => ident_cg0,
                                                DATA_OUT_A => data_a_cg0_sig,
                                                DATA_OUT_B => data_b_cg0_sig,
                                                DATA_OUT_C => data_c_cg0_sig,
                                                DATA_OUT_0 => data_0_cg0_sig,
                                                DATA_OUT_1 => data_1_cg0_sig,
                                                STALL_GLOB => stall_global_cg0_sig
                                                );
															
	Compute_Group_1 : Compute_Group PORT MAP (
                                                ADDRESS_A => address_a_cg1_sig,
                                                ADDRESS_B => address_b_cg1_sig,
                                                ADDRESS_C => address_c_cg1_sig,
                                                ADDRESS_0 => address_0_cg1_sig,
                                                ADDRESS_1 => address_1_cg1_sig,
                                                ADDRESS_W => address_w_cg1_sig,
                                                ADDRESS_IO => address_io_sig,
                                                DATA_IO => data_to_w_io_sig,
                                                IO_ENABLE => enable_io_cg1,
                                                DATA_TO_W => data_to_w_cg1_sig,
                                                W_EN => w_en_cg1_sig,
                                                CLK => CLOCK_50,
                                                RESET_n => RESET_n,
                                                GLOBAL_EN => enable_global_cg1_sig,
                                                IDENT_IN => ident_cg1,
                                                DATA_OUT_A => data_a_cg1_sig,
                                                DATA_OUT_B => data_b_cg1_sig,
                                                DATA_OUT_C => data_c_cg1_sig,
                                                DATA_OUT_0 => data_0_cg1_sig,
                                                DATA_OUT_1 => data_1_cg1_sig,
                                                STALL_GLOB => stall_global_cg1_sig
                                                );
															
	Compute_Group_2 : Compute_Group PORT MAP (
                                                ADDRESS_A => address_a_cg2_sig,
                                                ADDRESS_B => address_b_cg2_sig,
                                                ADDRESS_C => address_c_cg2_sig,
                                                ADDRESS_0 => address_0_cg2_sig,
                                                ADDRESS_1 => address_1_cg2_sig,
                                                ADDRESS_W => address_w_cg2_sig,
                                                ADDRESS_IO => address_io_sig,
                                                DATA_IO => data_to_w_io_sig,
                                                IO_ENABLE => enable_io_cg2,
                                                DATA_TO_W => data_to_w_cg2_sig,
                                                W_EN => w_en_cg2_sig,
                                                CLK => CLOCK_50,
                                                RESET_n => RESET_n,
                                                GLOBAL_EN => enable_global_cg2_sig,
                                                IDENT_IN => ident_cg2,
                                                DATA_OUT_A => data_a_cg2_sig,
                                                DATA_OUT_B => data_b_cg2_sig,
                                                DATA_OUT_C => data_c_cg2_sig,
                                                DATA_OUT_0 => data_0_cg2_sig,
                                                DATA_OUT_1 => data_1_cg2_sig,
                                                STALL_GLOB => stall_global_cg2_sig
                                                );
															
	Compute_Group_3 : Compute_Group PORT MAP (
                                                ADDRESS_A => address_a_cg3_sig,
                                                ADDRESS_B => address_b_cg3_sig,
                                                ADDRESS_C => address_c_cg3_sig,
                                                ADDRESS_0 => address_0_cg3_sig,
                                                ADDRESS_1 => address_1_cg3_sig,
                                                ADDRESS_W => address_w_cg3_sig,
                                                ADDRESS_IO => address_io_sig,
                                                DATA_IO => data_to_w_io_sig,
                                                IO_ENABLE => enable_io_cg3,
                                                DATA_TO_W => data_to_w_cg3_sig,
                                                W_EN => w_en_cg3_sig,
                                                CLK => CLOCK_50,
                                                RESET_n => RESET_n,
                                                GLOBAL_EN => enable_global_cg3_sig,
                                                IDENT_IN => ident_cg3,
                                                DATA_OUT_A => data_a_cg3_sig,
                                                DATA_OUT_B => data_b_cg3_sig,
                                                DATA_OUT_C => data_c_cg3_sig,
                                                DATA_OUT_0 => data_0_cg3_sig,
                                                DATA_OUT_1 => data_1_cg3_sig,
                                                STALL_GLOB => stall_global_cg3_sig
                                                );
								
	level_2_memory : global_memory PORT MAP(
                                                CLK => CLOCK_50,
                                                RESET_n => RESET_n,
                                                            --compute group 0
                                                ADDRESS_A_CG0 => address_a_cg0_sig,
                                                ADDRESS_B_CG0 => address_b_cg0_sig,
                                                ADDRESS_C_CG0 => address_c_cg0_sig,
                                                ADDRESS_0_CG0 => address_0_cg0_sig,
                                                ADDRESS_1_CG0 => address_1_cg0_sig,
                                                ADDRESS_W_CG0 => address_w_cg0_sig,
                                                DATA_TO_W_CG0 => data_to_w_cg0_sig,
                                                W_EN_CG0	=> w_en_cg0_sig,
                                                ENABLE_CG0 => enable_global_cg0_sig,
                                                DATA_A_TO_CG0 => data_a_cg0_sig,
                                                DATA_B_TO_CG0 => data_b_cg0_sig,
                                                DATA_C_TO_CG0 => data_c_cg0_sig,
                                                DATA_0_TO_CG0 => data_0_cg0_sig,
                                                DATA_1_TO_CG0 => data_1_cg0_sig,
                                                STALL_CG0 => stall_global_cg0_sig,
                                                            --compute group 1
                                                ADDRESS_A_CG1 => address_a_cg1_sig,
                                                ADDRESS_B_CG1 => address_b_cg1_sig,
                                                ADDRESS_C_CG1 => address_c_cg1_sig,
                                                ADDRESS_0_CG1 => address_0_cg1_sig,
                                                ADDRESS_1_CG1 => address_1_cg1_sig,
                                                ADDRESS_W_CG1 => address_w_cg1_sig,
                                                DATA_TO_W_CG1 => data_to_w_cg1_sig,
                                                W_EN_CG1	=> w_en_cg1_sig,
                                                ENABLE_CG1 => enable_global_cg1_sig,
                                                DATA_A_TO_CG1 => data_a_cg1_sig,
                                                DATA_B_TO_CG1 => data_b_cg1_sig,
                                                DATA_C_TO_CG1 => data_c_cg1_sig,
                                                DATA_0_TO_CG1 => data_0_cg1_sig,
                                                DATA_1_TO_CG1 => data_1_cg1_sig,
                                                STALL_CG1 => stall_global_cg1_sig,
                                                            --compute group 2
                                                ADDRESS_A_CG2 => address_a_cg2_sig,
                                                ADDRESS_B_CG2 => address_b_cg2_sig,
                                                ADDRESS_C_CG2 => address_c_cg2_sig,
                                                ADDRESS_0_CG2 => address_0_cg2_sig,
                                                ADDRESS_1_CG2 => address_1_cg2_sig,
                                                ADDRESS_W_CG2 => address_w_cg2_sig,
                                                DATA_TO_W_CG2 => data_to_w_cg2_sig,
                                                W_EN_CG2	=> w_en_cg2_sig,
                                                ENABLE_CG2 => enable_global_cg2_sig,
                                                DATA_A_TO_CG2 => data_a_cg2_sig,
                                                DATA_B_TO_CG2 => data_b_cg2_sig,
                                                DATA_C_TO_CG2 => data_c_cg2_sig,
                                                DATA_0_TO_CG2 => data_0_cg2_sig,
                                                DATA_1_TO_CG2 => data_1_cg2_sig,
                                                STALL_CG2 => stall_global_cg2_sig,
                                                        --compute group 3
                                                ADDRESS_A_CG3 => address_a_cg3_sig,
                                                ADDRESS_B_CG3 => address_b_cg3_sig,
                                                ADDRESS_C_CG3 => address_c_cg3_sig,
                                                ADDRESS_0_CG3 => address_0_cg3_sig,
                                                ADDRESS_1_CG3 => address_1_cg3_sig,
                                                ADDRESS_W_CG3 => address_w_cg3_sig,
                                                DATA_TO_W_CG3 => data_to_w_cg3_sig,
                                                W_EN_CG3	=> w_en_cg3_sig,
                                                ENABLE_CG3 => enable_global_cg3_sig,
                                                DATA_A_TO_CG3 => data_a_cg3_sig,
                                                DATA_B_TO_CG3 => data_b_cg3_sig,
                                                DATA_C_TO_CG3 => data_c_cg3_sig,
                                                DATA_0_TO_CG3 => data_0_cg3_sig,
                                                DATA_1_TO_CG3 => data_1_cg3_sig,
                                                STALL_CG3 => stall_global_cg3_sig,
                                                            --IO controller
                                                ADDRESS_IO => address_io_sig,
                                                DATA_TO_W_IO => data_to_w_io_sig,
                                                W_EN_IO => w_en_io_sig,
                                                ENABLE_IO => enable_io_global,
                                                DATA_RET_IO => data_read_io_sig,
                                                            --DONE flags
                                                DONE_C0 => DONE_C0,
                                                DONE_C1 => DONE_C1,
                                                DONE_C2 => DONE_C2,
                                                DONE_C3 => DONE_C3,
                                                DONE_C4 => DONE_C4,
                                                DONE_C5 => DONE_C5,
                                                DONE_C6 => DONE_C6,
                                                DONE_C7 => DONE_C7,
                                                RCC => RCC
                                                );												
		
        
    flag_done <= DONE_C7 & DONE_C6 & DONE_C5 & DONE_C4 & DONE_C3 & DONE_C2 & DONE_C1 & DONE_C0;
    all_done <= DONE_C7 and DONE_C6 and DONE_C5 and DONE_C4 and DONE_C3 and DONE_C2 and DONE_C1 and DONE_C0;
        
--	process (SW, hex_val0, hex_val1, hex_val2, hex_val3, hex_val4, hex_val5, 
--				hex_val6, hex_val7, test_reg) begin
--		if (SW(0) = '1')then
			to_hex_0 <=  hex_val0;
			to_hex_1 <=  hex_val1;
			to_hex_2 <=  hex_val2;
			--to_hex_3 <=  hex_val3;
            to_hex_3 <=  RCC;
			to_hex_4 <=  hex_val4;
			to_hex_5 <=  hex_val5;
            to_hex_6 <=  flag_done(3 downto 0);
            to_hex_7 <=  flag_done(7 downto 4);
			--to_hex_6 <=  hex_val6;
			--to_hex_7 <=  hex_val7;
--		else
--			to_hex_0 <= test_reg(3 downto 0);
--			to_hex_1 <= test_reg(7 downto 4);
--			to_hex_2 <= test_reg(11 downto 8);
--			to_hex_3 <= test_reg(15 downto 12);
--			to_hex_4 <= test_reg(19 downto 16);
--			to_hex_5 <= test_reg(23 downto 20);
--			to_hex_6 <= test_reg(27 downto 24);
--			to_hex_7 <= test_reg(31 downto 28);
--		end if;
--	end process;
		
	hex_convert_0 : convert_to_seven_seg port map (
		to_hex_0,
		HEX0
	);
	hex_convert_1 : convert_to_seven_seg port map (
		to_hex_1,
		HEX1
	);
	hex_convert_2 : convert_to_seven_seg port map(
		to_hex_2,
		HEX2
	);
	hex_convert_3 : convert_to_seven_seg port map(
		to_hex_3,
		HEX3
	);
	
	hex_convert_4 : convert_to_seven_seg port map(
		to_hex_4,
		HEX4
	);	
	hex_convert_5 : convert_to_seven_seg port map(
		to_hex_5,
		HEX5
	);
	hex_convert_6 : convert_to_seven_seg port map(
		to_hex_6,
		HEX6
	);
	hex_convert_7 : convert_to_seven_seg port map(
		to_hex_7,
		HEX7
	);

    
    --PERFORMANCE COUNTER LOGIC;
    --buffering signals for edge detector
    process (CLOCK_50, RESET_n, flag_ready, all_done) begin
        if (RESET_n = '0') then
            ready_buff <= '0';
            all_done_buff <= '0';
        elsif (rising_edge(CLOCK_50)) then
            ready_buff <= flag_ready;
            all_done_buff <= all_done;
        end if;
    end process;
    --edge detector
    ready_rising_edge <= (flag_ready xor ready_buff) and flag_ready;
    done_rising_edge <= (all_done_buff xor all_done) and all_done;
    --counter enable
    process (CLOCK_50, RESET_n, ready_rising_edge, done_rising_edge) begin
        if (RESET_n = '0') then
            counter_active <= '0';
        elsif (rising_edge(CLOCK_50)) then
            if(ready_rising_edge = '1') then
                counter_active <= '1';
            elsif(done_rising_edge = '1') then
                counter_active <= '0';
            end if;
        end if;
    end process;
    --counter itself
    process (CLOCK_50, RESET_n, counter_active, ready_rising_edge) begin
        if (RESET_n = '0') then
            perf_counter <= "0000000000000000000000000000000000000000000000000000000000000000";
        elsif (rising_edge(CLOCK_50)) then
            if (counter_active = '1') then
                perf_counter <= perf_counter + 1;
            elsif (ready_rising_edge = '1') then
                perf_counter <= "0000000000000000000000000000000000000000000000000000000000000000";
            end if;
        end if;
    end process;
end;
