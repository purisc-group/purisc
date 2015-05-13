/*
Daniel Kokoszka adapted this from SHIP.v to simulate ethmac. 
*/

//`define SIMULATION

`define HOST_REPLY_TIMEOUT 32'd60000

`include "ethmac/rtl/verilog/ethmac_defines.v"
`include "ethmac/rtl/verilog/timescale.v"
`include "io_controller_defines.v"
// TODO: wrap this in an ifdef, if possible
`ifdef simulation
    `include "ethmac/bench/verilog/eth_phy_defines.v"
    `include "ethmac/bench/verilog/tb_eth_defines.v"
`endif

//`default_nettype none




module io_controller (
    input               CLOCK_50,
    input               RESET,
    
    output      [31:0]  wb_mem_adr_o,
    output      [3:0]   wb_mem_sel_o,
    output              wb_mem_we_o,
    output              wb_mem_cyc_o,
    output              wb_mem_stb_o,
    input               wb_mem_ack_i,
    output      [31:0]  wb_mem_dat_o,
    input       [31:0]  wb_mem_dat_i,
    input               wb_mem_err_i,
    
    // Not used in simulation (io_controller connects to signals from fake PHY)
    //input               ENET0_GTX_CLK,        // GMII Transmit Clock
    output              ENET0_MDC,             // Management data clock reference
    inout               ENET0_MDIO,            // Management Data
    output              ENET0_RST_N,        // Hardware reset Signal
    input               ENET0_RX_CLK,        // GMII/MII Receive clock
    input               ENET0_RX_COL,        // GMII/MII Collision
    input               ENET0_RX_CRS,        // GMII/MII Carrier sense
    input       [3:0]   ENET0_RX_DATA,        // GMII/MII Receive data
    input               ENET0_RX_DV,        // GMII/MII Receive data valid
    input               ENET0_RX_ER,        // GMII/MII Receive error
    input               ENET0_TX_CLK,        // MII Transmit Clock
    output      [3:0]   ENET0_TX_DATA,        // MII Transmit Data
    output              ENET0_TX_EN,        // GMII/MII Transmit enable
    output              ENET0_TX_ER,         // GMII/MII Transmit error
    //  logic           ENETCLK_25;         // Internal Clock (SHARED) 25MHZ
    input   reg [15:0]  M,
    output  reg [15:0]  arq_n,
    input  	reg [15:0]  tx_len,
    
    // flag setting input (controlled by io controller)
    output  reg         flag_ready,     //tells controller to set ready flag (cores will start executing)
    output  reg         flag_done_clear,
    input   reg         flag_ack,       //tells ioc that the direct memory operation was successfull
    input   reg [7:0]   flag_done,      //informs IOC that a core has finished executing
    
    output reg [3:0]    hex_val0,
    output reg [3:0]    hex_val1,
    output reg [3:0]    hex_val2,
    output reg [3:0]    hex_val3,
    
    output reg [3:0]    hex_val4,
    output reg [3:0]    hex_val5,
    output reg [3:0]    hex_val6,
    output reg [3:0]    hex_val7
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

// for writing to ethmac registers over WB
reg top_eth_cyc,top_eth_stb,top_eth_ack,top_eth_err;
wire [31:0] top_eth_dat_r;
reg [31:0] top_eth_dat_w;
reg [31:0] top_eth_addr;
reg [3:0] top_eth_sel;
reg top_eth_we;

//convert tristate pin to two separate lines:
wire md_we, md_out, md_in;
assign ENET0_MDIO = md_we? md_out:1'bz;
assign md_in = ENET0_MDIO;

//don't forget reset-delay on ethernet chip
// reset
assign ENET0_RST_N = ~RESET;
wire eth_irq;

ethmac ethwish1(
    // WISHBONE common
    .wb_clk_i(CLOCK_50),
    .wb_rst_i(RESET),
    // WISHBONE slave --connected to main control logic
    .wb_adr_i(top_eth_addr),
    .wb_sel_i(top_eth_sel),
    .wb_we_i(top_eth_we),
    .wb_cyc_i(top_eth_cyc),
    .wb_stb_i(top_eth_stb),
    .wb_ack_o(top_eth_ack),
    .wb_err_o(top_eth_err),
    .wb_dat_i(top_eth_dat_w),
    .wb_dat_o(top_eth_dat_r),
    // WISHBONE master --connected to ram controller
    .m_wb_adr_o(wb_mem_adr_o),
    .m_wb_sel_o(wb_mem_sel_o),
    .m_wb_we_o(wb_mem_we_o),
    .m_wb_dat_o(wb_mem_dat_o),
    .m_wb_dat_i(wb_mem_dat_i),
    .m_wb_cyc_o(wb_mem_cyc_o),
    .m_wb_stb_o(wb_mem_stb_o),
    .m_wb_ack_i(wb_mem_ack_i),
    .m_wb_err_i(wb_mem_err_i),
    
    //TX
    .mtx_clk_pad_i(ENET0_TX_CLK),
    .mtxd_pad_o(ENET0_TX_DATA),
    .mtxen_pad_o(ENET0_TX_EN),
    .mtxerr_pad_o(ENET0_TX_ER),

    //RX
    .mrx_clk_pad_i(ENET0_RX_CLK),
    .mrxd_pad_i(ENET0_RX_DATA),
    .mrxdv_pad_i(ENET0_RX_DV),
    .mrxerr_pad_i(ENET0_RX_ER),
    .mcoll_pad_i(ENET0_RX_COL),
    .mcrs_pad_i(ENET0_RX_CRS),

    // MII Management signals
    .mdc_pad_o(ENET0_MDC),
    .md_pad_i(md_in),
    .md_pad_o(md_out),
    .md_padoe_o(md_we),

    .int_o(eth_irq)

);

logic [31:0] rx_bd_reg;
logic [31:0] tx_bd_reg;

logic [31:0] moder_reg = `MODER_RXEN | `MODER_TXEN | `MODER_FULLD | `MODER_IFG 
        | `MODER_RECSMALL | `MODER_HUGEN | `MODER_CRCEN;
logic [31:0] irq_reg;

logic [31:0] arq_packet_pointer = 32'h8000_0000;//msb used as a flag in memory controller
logic [31:0] ack_packet_pointer = 32'h4000_0000; 
logic [31:0] tx_data_pointer =    32'h2000_0000;

// retry number (for go-back-N ARQ)
logic [15:0] rx_arq_n;
logic [15:0] rx_packet_count;
logic [15:0] counter_counter;

assign arq_n = rx_arq_n;

logic [15:0] tx_arq_n;
logic [15:0] tx_M;
logic [15:0] tx_n;
logic [15:0] tx_packet_len;
logic [15:0] tx_last_len;

//if it's not divisible by 1024, add an extra packet
assign tx_M = (tx_len%1024) ? (tx_len>>8)+1 : (tx_len>>8);
        
logic [64:0] timer;
logic timer_reset;

//Top FSM states and vars
enum {
    s_init_moder,
    s_init_int_mask,
    s_init_mac_addr_0,
    s_init_mac_addr_1,
    
    s_rx_first,
    s_rx_retry,
    s_rx_arq,
    s_rx_ack,
    s_rx_flag,
    
    s_crunch_time,
    
    s_tx_first,
    s_tx_arq,
    s_tx_retry,
    s_clear_ioflag
} top_fsm_state;



enum {
    s_bd1, 
    s_bd2,
    s_wait, 
    s_irq_r, 
    s_irq_w,
    s_update,
    s_ifg,
    s_none,
    s_wtf
} sub_state;

//next-state block
always @ (posedge CLOCK_50 or posedge RESET) 
begin
    if (RESET == 1'b1) begin
        top_fsm_state   <= s_init_moder;
        sub_state       <= s_none;
        
        irq_reg         <= 0;
        rx_packet_count <= 0;
        rx_arq_n        <= 0;
        
        flag_ready      <= 0;
        
        tx_n            <= 0;
    end else begin
        
        case(sub_state)
            s_ifg:
                if(timer == `IFG_TIME)
                    sub_state <= s_bd2;
            s_bd1:
                if(top_eth_ack == 1)
                    sub_state <= s_bd2;
            s_bd2:
                if(top_eth_ack == 1)
                    sub_state <= s_wait;
            s_wait:
                if(eth_irq == 1)
                    sub_state <= s_irq_r;
            s_irq_r:
                if(top_eth_ack == 1) begin
                    sub_state <= s_irq_w;
                    irq_reg <= top_eth_dat_r;
                end
            s_irq_w:
                if(top_eth_ack == 1)
                    sub_state <= s_update;
            
        endcase
        
        case(top_fsm_state)
            s_init_moder:
                if(top_eth_ack == 1)
                    top_fsm_state <= s_init_int_mask;
            s_init_int_mask:
                if(top_eth_ack == 1) begin
                    top_fsm_state <= s_init_mac_addr_0;
                end
            s_init_mac_addr_0:
                if(top_eth_ack == 1) begin
                    top_fsm_state <= s_init_mac_addr_1;
                end
            s_init_mac_addr_1:
                if(top_eth_ack == 1) begin
                    top_fsm_state <= s_rx_first;
                    sub_state <= s_bd1;
                end
            s_clear_ioflag:
            begin
                if(flag_ack) begin
                    top_fsm_state <= s_rx_first;
                    sub_state <= s_bd1;
                end
            end
            s_rx_first:
                if(sub_state == s_update) begin
                    /// 
                    /// From combinational logic
                    /// 
                    
                    //in the event of an error 
                    if(irq_reg&`INT_RXE) begin
                        if( rx_arq_n == 0 )
                            rx_arq_n <= M-rx_packet_count;
                        
                    // If successfully received
                    end else if(irq_reg&`INT_RXB) begin
                        //if wrong sequence number, request repeat starting at last one
                        //NOT IMPLEMENTED YET - assuming no lost packets and a cooperative host
                    end
                
                    ///
                    /// State change logic
                    ///
                    
                    // we have seen all packets
                    if(rx_packet_count+1 == M) begin
                        rx_packet_count <= 0;
                        counter_counter <= counter_counter + 1;
                        // no packets with failed crc, tell the host w/ ack
                        if(rx_arq_n == 0) begin
                            top_fsm_state <= s_rx_ack;
                            sub_state <= s_bd1;
                        // some packets with failed crc
                        end else begin
                            top_fsm_state <= s_rx_arq;
                            sub_state <= s_bd1;
                        end
                    // there are still more packets to RX
                    end else begin
                        if(rx_packet_count == 0)
                            rx_arq_n <= 0;
                        sub_state <= s_bd2;
                        rx_packet_count <= rx_packet_count + 1;
                        counter_counter <= counter_counter + 1;
                    end
                end    
            s_rx_retry:
                if(sub_state == s_update) begin
                    ///
                    /// From combinational logic
                    ///
                    
                    //in the event of an error 
                    if(irq_reg&`INT_RXE) begin
                        if( rx_arq_n == 0 )
                            rx_arq_n <= M-rx_packet_count;
                    // If successfully received
                    end else if(irq_reg&`INT_RXB) begin
                        //if wrong sequence number, request repeat starting at last one
                        //NOT IMPLEMENTED YET - assuming no lost packets and a cooperative host
                    end
                
                    /// 
                    /// state change logic 
                    /// 
                
                    // we have seen all retry packets 
                    if(rx_packet_count+1 == M) begin
                        rx_packet_count <= 0;
                        counter_counter <= counter_counter + 1;
                        // no retry packets have failed crc, tell the host w/ ack
                        if(rx_arq_n == 0) begin
                            top_fsm_state <= s_rx_ack;
                            sub_state <= s_bd1;
                        // some retry packets have failed crc
                        end else begin
                            top_fsm_state <= s_rx_arq;
                            sub_state <= s_bd1;
                        end
                    // there are still more packets to RX
                    end else begin
                        if(rx_packet_count == 0)
                            rx_arq_n <= 0;
                        rx_packet_count <= rx_packet_count + 1;
                        counter_counter <= counter_counter + 1;
                        sub_state <= s_bd2;
                    end
                end else if(sub_state == s_wait) begin
                    //if the host is taking too long to respond
                    if( timer == `HOST_REPLY_TIMEOUT ) begin
                        top_fsm_state <= s_rx_arq;
                        sub_state <= s_bd1;
                    end
                end
            s_tx_first:
            begin
                flag_ready <= 0;
                if(sub_state == s_update) begin
                    ///
                    /// output logic
                    ///
                    

                    
                    ///
                    /// state change logic
                    ///
                    
                    // if not done sending
                    if(tx_n < tx_M-1) begin
                        if(flag_done == 8'hFF) begin
                            //if error sending
                            if(irq_reg&`INT_TXE) begin
                                // ARQ not implemented, keep going
                                tx_n <= tx_n + 1;
                                sub_state <= s_bd1;
                            //if successfully sent
                            end else if(irq_reg&`INT_TXB) begin
                                tx_n <= tx_n + 1;
                                sub_state <= s_bd1;
                            end
                        end 
                    end 
                    // if done sending
                    else begin
                        tx_n <= 0;
                        //if error sending
                        if(irq_reg&`INT_TXE) begin
                            // ARQ not implemented, keep going
                            top_fsm_state <= s_clear_ioflag;
                            sub_state <= s_none;
                        //if successfully sent
                        end else if(irq_reg&`INT_TXB) begin
                            top_fsm_state <= s_clear_ioflag;
                            sub_state <= s_none;
                        end
                    end
                end
            end
            s_tx_retry:
            begin
            end
            s_tx_arq:
            begin
            end                
            s_rx_arq:
                if(sub_state == s_update)
                    //if sent successfully, go back to listening for retries
                    if(irq_reg & `INT_TXB) begin 
                        top_fsm_state <= s_rx_retry;
                        sub_state <= s_bd1;
                    //if error sending, repeat arq
                    end else if(irq_reg & `INT_TXE) 
                        sub_state <= s_ifg;
                     //if neither, then wtf?
                    else                       
                        sub_state <= s_wtf;

            s_rx_ack:
                if(sub_state == s_update)
                    if(irq_reg & `INT_TXB) begin
                        top_fsm_state <= s_rx_flag;
                        sub_state <= s_none;
                    end else if(irq_reg & `INT_TXE)
                        sub_state <= s_ifg; 
                    else 
                        sub_state <= s_wtf;
            s_rx_flag:
            begin
                flag_ready <= 1;
                if(flag_ack) begin
                    top_fsm_state <= s_crunch_time;
                    sub_state <= s_wait;
                end
            end
            s_crunch_time:
            begin
                if(flag_done == 8'hFF) begin
                    top_fsm_state <= s_tx_first;
                    sub_state <= s_bd1;
                end
            end
        endcase
    end
end
//////////
// FSM output function block
//////////
assign top_eth_stb = top_eth_cyc;
always @(top_fsm_state or sub_state or moder_reg or arq_packet_pointer 
        or ack_packet_pointer or irq_reg or tx_data_pointer or tx_n or RESET) begin
    if(RESET == 1) begin
        top_eth_cyc     = 0;        
        top_eth_we      = 0;        
        top_eth_addr    = 32'h0;    
        top_eth_dat_w   = 32'h0;    
        timer_reset     = 0;
        // specified once at top
        top_eth_sel     = 4'hF;
        // moving to next-state logic
//      irq_reg         = 0;        //LATCHING  // moved to next-state logic
//      rx_packet_count = 0;        //LATCHING  // moved to next-state logic
//      rx_arq_n        = 0;        //LATCHING  // moved to next-state logic

        flag_done_clear = 0;
    end else begin 
        top_eth_sel     = 4'hF;
        top_eth_cyc     = 0;
        top_eth_we      = 0;
        top_eth_addr    = 0;
        top_eth_dat_w   = 0;
        timer_reset     = 0;
        flag_done_clear = 0;
        
        case(sub_state)
            s_none: 
            begin
                top_eth_cyc     = 1'b1;
                top_eth_we      = 1'b1;
                timer_reset     = 0;
                        
                case(top_fsm_state)
                    s_init_moder:
                    begin
                        top_eth_addr    = `ETH_MODER_ADR;
                        top_eth_dat_w   = moder_reg;
                    end
                    s_init_int_mask:
                    begin
                        top_eth_addr    = `ETH_INT_MASK_ADR;
                        top_eth_dat_w   = 32'h0 /*| `INT_MASK_RXC | `INT_MASK_TXC */ //there's no good reason to receive control frames
                                | `INT_MASK_BUSY | `INT_MASK_RXE | `INT_MASK_RXB | `INT_MASK_TXE 
                                | `INT_MASK_TXB;
                    end
                    s_init_mac_addr_0:
                    begin
                        top_eth_addr    = `ETH_MAC_ADDR0_ADR;
                        top_eth_dat_w   = 32'h52495343;
                    end
                    s_init_mac_addr_1:
                    begin
                        top_eth_addr    = `ETH_MAC_ADDR1_ADR;
                        top_eth_dat_w   = {16'd0, 16'h5055};
                    end
                    s_clear_ioflag:
                    begin
                        flag_done_clear = 1;
                    end
                    default:
                    begin
                        top_eth_addr    = 0;
                        top_eth_dat_w   = 0;
                        top_eth_cyc     = 0;
                        top_eth_we      = 0;
                    end
                endcase
            end
            s_bd1: 
            begin
                top_eth_cyc     = 1'b1;
                top_eth_we      = 1'b1;
                timer_reset     = 0;
                
                //set pointers in second half of buffer descriptor
                if(top_fsm_state == s_rx_first || top_fsm_state == s_rx_retry) begin
                    top_eth_addr    = `RX_BD_ADR+1;
                    top_eth_dat_w   = 32'h0;
                    
                end else if(top_fsm_state == s_rx_arq) begin
                    top_eth_addr    = `TX_BD_ADR+1;
                    top_eth_dat_w   = arq_packet_pointer;
                    
                end else if(top_fsm_state == s_rx_ack) begin
                    top_eth_addr    = `TX_BD_ADR+1;
                    top_eth_dat_w   = ack_packet_pointer;
                end else if(top_fsm_state == s_tx_first || top_fsm_state == s_tx_retry) begin
                    top_eth_addr    = `TX_BD_ADR+1; //location of the tx data buffer descriptor
                    top_eth_dat_w   = tx_data_pointer | tx_n*1024; //location of the tx data
                end else begin
                    top_eth_cyc     = 0;
                    top_eth_we      = 0;
                    top_eth_addr    = 0;
                    top_eth_dat_w   = 0;
                end
                
            end
            s_bd2: 
            begin
                top_eth_cyc     = 1'b1;
                top_eth_we      = 1'b1;
                timer_reset     = 0;
                
                //set flags in first half of buffer descriptor
                if(top_fsm_state == s_rx_first || top_fsm_state == s_rx_retry) begin
                    top_eth_addr    = `RX_BD_ADR;
                    top_eth_dat_w   = 32'h0 | `RX_BD_EMPTY | `RX_BD_IRQ | `RX_BD_WR;
                    timer_reset     = 1;
                end else if(top_fsm_state == s_rx_arq) begin
                    top_eth_addr    = `TX_BD_ADR;
                    top_eth_dat_w   = {16'h40, 16'h0} | `TX_BD_READY | `TX_BD_IRQ | `TX_BD_WR | `TX_BD_CRC;
                    
                end else if(top_fsm_state == s_rx_ack) begin
                    top_eth_addr    = `TX_BD_ADR;
                    top_eth_dat_w   = {16'h40, 16'h0} | `TX_BD_READY | `TX_BD_IRQ | `TX_BD_WR | `TX_BD_CRC;
                    
                end else if(top_fsm_state == s_tx_first || top_fsm_state == s_tx_retry) begin
                    top_eth_addr    = `TX_BD_ADR;
                    top_eth_dat_w   = {16'h400, 16'h0} | `TX_BD_READY | `TX_BD_IRQ | `TX_BD_WR | `TX_BD_CRC;
                end else begin 
                    // this doesn't ever happen, it only exists to remove latching warnings
                    top_eth_cyc     = 0;
                    top_eth_we      = 0;
                    top_eth_addr    = 0;
                    top_eth_dat_w   = 0;
                end
            end
            s_wait: //LATCHING REMOVED
            begin
                top_eth_cyc     = 0;
                top_eth_we      = 0;
                top_eth_addr    = 0;
                top_eth_dat_w   = 0;
                timer_reset     = 0;
            end
            s_irq_r: //LATCHING REMOVED
            begin
                top_eth_cyc     = 1;
                top_eth_we      = 0;
                top_eth_addr    = `ETH_INT_SOURCE_ADR;
                top_eth_dat_w   = 0;
                timer_reset     = 0;
            end 
            s_irq_w: //LATCHING REMOVED
            begin
                // clear the IRQ source reg
                top_eth_cyc     = 1'b1;
                top_eth_we      = 1'b1;
                top_eth_addr    = `ETH_INT_SOURCE_ADR;
                top_eth_dat_w   = irq_reg;             // ADD THIS TO STATE-CHANGE LOGIC
                timer_reset     = 0;
            end
            s_update: //LATCHING REMOVED
            begin
                top_eth_cyc     = 0;
                top_eth_we      = 0;
                top_eth_addr    = 0;
                top_eth_dat_w   = 0;
                timer_reset     = 1;
            end
            s_wtf:
            begin
                //abstract yourself out of existence
            end
        endcase
    end
end


always @(posedge CLOCK_50) 
begin
    if(timer_reset) begin
        timer <= 0;
    end else begin
        timer <= timer + 1;
    end
end

always @(top_fsm_state or sub_state) 
begin
	case(top_fsm_state)
		 s_init_moder:
			hex_val4 = 4'h0;
		 s_init_int_mask:
			hex_val4 = 4'h1;
		 s_init_mac_addr_0:
			hex_val4 = 4'h2;
		 s_init_mac_addr_1:
			hex_val4 = 4'h3;
		 s_rx_first:
			hex_val4 = 4'h4;
		 s_rx_retry:
			hex_val4 = 4'h5;
		 s_rx_arq:
			hex_val4 = 4'h6;
		 s_rx_ack:
			hex_val4 = 4'h7;
         s_tx_first:
			hex_val4 = 4'h8;
		 default:
			hex_val4 = 4'hE;
	endcase
	case(sub_state)
		 s_bd1:
			hex_val5 = 4'h0;
		 s_bd2:
			hex_val5 = 4'h1;
		 s_wait: 
			hex_val5 = 4'h2;
		 s_irq_r:
			hex_val5 = 4'h3;
		 s_irq_w:
			hex_val5 = 4'h4;
		 s_update:
			hex_val5 = 4'h5;
		 s_none:
			hex_val5 = 4'h6;
		 s_wtf:
			hex_val5 = 4'h7;
	    default:
			hex_val5 = 4'hE;
	endcase
end

assign hex_val7 = eth_irq;
assign hex_val6 = rx_arq_n[11:8];
//assign hex_val5 = rx_arq_n[7:4];
//assign hex_val4 = rx_arq_n[3:0];

assign hex_val3 = irq_reg[7:4];
assign hex_val2 = irq_reg[3:0];
assign hex_val1 = counter_counter[7:4];
assign hex_val0 = counter_counter[3:0];

endmodule //top module
