`include "ethmac/rtl/verilog/timescale.v"
//`default_nettype none

//`define SIMULATION

// This module makes no claim to behave like memory.
// It requires a very specific sequence of writes in order to work properly.
// It isn't even really wishbone compliant. 
// Don't ever use this module unless you are me.
// If you are me, stop being me. I am me.

module io_memory_controller (
    input               wb_rst_i,
    input               wb_clk_i,
    //connections to fake magics
    output  reg [31:0]  mem_addr,
    output  reg [31:0]  mem_data_w,
    output  reg [8:0]   mem_we,
    output  reg         mem_gl_en,
    input       [31:0]  mem_gl_data_r,
    
    // WISHBONE slave (controlled by ethmac)
    input       [31:0]  wb_adr_i,   // WISHBONE address input
    input       [3:0]   wb_sel_i,   // WISHBONE byte select input
    input               wb_we_i,    // WISHBONE write enable input
    input               wb_cyc_i,   // WISHBONE cycle input
    input               wb_stb_i,   // WISHBONE strobe input
    output  reg         wb_ack_o,   // WISHBONE acknowledge output
    input       [31:0]  wb_dat_i,   // WISHBONE data input
    output  reg [31:0]  wb_dat_o,   // WISHBONE data output
    output  reg         wb_err_o,   // WISHBONE error output
    output  reg [15:0]  M,
    
    // flag setting input (controlled by io controller)
    input   reg         flag_ready,
    input   reg         flag_done_clear,
    output  reg         flag_ack,
    
    
    // data for arq packet
    input   reg [15:0]  arq_n,
    output  reg [15:0]  tx_len
);

logic clock, reset;
reg arq_ack, ack_ack, rx_ack, read_ack;

assign clock = wb_clk_i;
assign reset = wb_rst_i;
assign wb_ack_o = rx_ack | arq_ack | ack_ack | read_ack;



// rx header parts and address translation for MAGIC
reg [15:0]  byte_num;
reg [15:0]  mem_id;
reg [8:0]   mem_id_decode;
reg [15:0]  n;
reg [15:0]  length;
reg [15:0]  last_length;
reg [31:0]  addr_offset;
// tx information
reg global_pointer;

// delays for writing to magic
reg         start_wait;
reg [2:0]   cyc_count;
reg [2:0]   flag_count;
reg [3:0]   flag_clear_count;

// for reading from magic
reg [2:0]   read_count;
reg         read_meta_ready;
reg         read_data_ready;
reg [31:0]  tx_ptr;

//convert the above to a combinational block
always @(wb_rst_i or wb_dat_i or mem_id_decode or wb_cyc_i or wb_stb_i or wb_we_i or 
            wb_adr_i or addr_offset or arq_n or cyc_count or flag_count or read_count or 
            read_meta_ready or read_data_ready or tx_ptr or mem_id or mem_gl_data_r or 
            tx_len or flag_clear_count)
begin
    if(wb_rst_i) begin
        // MAGIC signals
        mem_data_w = 32'd0;
        mem_addr = 32'd0;
        mem_we = 9'b000000000;
        mem_gl_en = 0;
        // WB read signals
        arq_ack = 0;
        ack_ack = 0;
        rx_ack = 0;
        read_ack = 0;
        wb_dat_o = 32'hdeadbeef;
        
        flag_ack = 0;
    end else begin
        wb_dat_o = 32'hdeafb00b;
        mem_gl_en = 0;
        flag_ack = 0;
        
        //if doing any memory operation over WISHBONE
        if(wb_cyc_i&wb_stb_i) begin
            // if trying to write (RX)
            if(wb_we_i) begin
                arq_ack = 0;
                ack_ack = 0;
                read_ack = 0;
                //writing to registers (when addr < header len)
                if(wb_adr_i < 24) begin 
                    mem_data_w = 32'd0;
                    mem_addr = 32'h2222;
                    mem_we = 9'b000000000;
                    //handled in seq logic
                    rx_ack = 1;
                end
                //writing to memory (addr >= header len)
                else begin 
                    mem_data_w = wb_dat_i;
                    //if writing to global
                    if(mem_id == 16'h0400) begin
                        mem_addr = {10'd0, wb_adr_i[23:2]} + addr_offset + 10;
                    end 
                    //if writing to local
                    else begin
                        // minus header plus bootloader
                        mem_addr = {10'd0, wb_adr_i[23:2]} + addr_offset - 6 + 32; 
                    end
                    mem_we = mem_id_decode;
                    if(cyc_count > 2) begin
                        rx_ack = 1;
                    end else begin
                        rx_ack = 0;
                    end
                end
                
                
                
            // if trying to read mem (TX)
            end else begin
                // These shouldn't change
                mem_data_w = 32'd0;
                mem_addr = 32'h1111;
                mem_we = 9'b000000000;
                
                // default values - remove once all paths are covered
                arq_ack = 0;
                ack_ack = 0;
                rx_ack = 0;
                read_ack = 0; // this won't be removed -- too infrequently set
                wb_dat_o = 32'hdeadbeef;
                
                //if reading global memory
                if(wb_adr_i[29]) begin
                    //stall until the metadata has been read from MAGIC (in seq area)
                    if(read_meta_ready) begin
                        mem_gl_en = 1;
                        //if reading within the length of return array
                        if(wb_adr_i[28:2] < tx_len) begin
                            //forward data starting at the pointer
                            mem_addr = tx_ptr + wb_adr_i[28:2];
                            wb_dat_o = mem_gl_data_r; 
                        end 
                        // if reading outside of return array, pad (diregarded by host)
                        else begin
                            wb_dat_o = 32'd0; 
                        end
                        if(read_data_ready) begin
                            read_ack = 1;
                        end
                        
                    end else begin
                        read_ack = 0;
                        wb_dat_o = 32'hb000b1e5;
                        if(read_count < 4) begin
                            mem_gl_en = 1;
                            mem_addr = 32'h00000011;
                        end else begin
                            mem_gl_en = 1;
                            mem_addr = 32'h00000010;
                        end
                    end
                //if reading arq
                end else if(wb_adr_i[31])  begin
                    if(read_count >= 2) begin
                        arq_ack = 1;
                        ack_ack = 0;
                        if(wb_adr_i[23:0] < 4) begin
                            //HOST
                            wb_dat_o = 32'h484f5354;
                        end else if(wb_adr_i[23:0] < 8) begin
                            //PCPU
                            wb_dat_o = 32'h50435055;
                        end else if(wb_adr_i[23:0] < 12) begin
                            //RISC
                            wb_dat_o = 32'h52495343;
                        end else if(wb_adr_i[23:0] < 16) begin
                            //RESERVED, pp_type
                            wb_dat_o = 32'd0;
                        end else if(wb_adr_i[23:0] < 20) begin
                            //length, mem-id
                            wb_dat_o[31:16] = 16'd64;
                            wb_dat_o[15:0]  = 16'd0;
                        end else if(wb_adr_i[23:0] < 24) begin
                            //n, M
                            wb_dat_o[31:16] = 16'd0;
                            wb_dat_o[15:0]  = 16'd1;
                        end else if (wb_adr_i[7:0] < 28) begin 
                            wb_dat_o = {arq_n, 16'hfafa};
                        end else begin
                            wb_dat_o = 32'hfafafafa;
                        end
                    end else begin 
                        wb_dat_o = 32'h0;
                        arq_ack = 0;
                        ack_ack = 0;
                    end
                // if reading ack
                end else if(wb_adr_i[30]) begin
                    if(read_count >= 2) begin
                        arq_ack = 0;
                        ack_ack = 1;
                        // Byte 12-13, word 3:  RESERVED (ethertype - appletalk)
                        // Byte 14-15:          pp_type (purisc protocol packet type)
                        // Byte 16-17, word 4:  length 
                        // Byte 18-19:          mem-id 
                        // Byte 20-21: word 5:  n (packet number) 
                        // Byte 22-23:          M (total packets) 
                        if(wb_adr_i[23:0] < 4) begin
                            //HOST
                            wb_dat_o = 32'h484f5354;
                        end else if(wb_adr_i[23:0] < 8) begin
                            //PCPU
                            wb_dat_o = 32'h50435055;
                        end else if(wb_adr_i[23:0] < 12) begin
                            //RISC
                            wb_dat_o = 32'h52495343;
                        end else if(wb_adr_i[23:0] < 16) begin
                            //RESERVED, pp_type
                            wb_dat_o = 32'd0;
                        end else if(wb_adr_i[23:0] < 20) begin
                            //length, mem-id
                            wb_dat_o[31:16] = 16'd64;
                            wb_dat_o[15:0]  = 16'd0;
                        end else if(wb_adr_i[23:0] < 24) begin
                            //n, M
                            wb_dat_o[31:16] = 16'd0;
                            wb_dat_o[15:0]  = 16'd1;
                        end else if(wb_adr_i[23:0] < 28) begin
                            wb_dat_o = {8'd0, 24'hfafafa};
                        end else begin
                            wb_dat_o = 32'hfafafafa;
                        end
                    end else begin 
                        wb_dat_o = 32'h0;
                        arq_ack = 0;
                        ack_ack = 0;
                    end
                //if multiple of 29, 31, 32 are high - shouldn't ever happen
                end else begin 
                    wb_dat_o = 32'hdeadbeef;
                    arq_ack = 0;
                    ack_ack = 0;
                end //if(wb_adr_i[31:30]) ...
            end //if(wb_we_i)
        end //if(wb_cyc_i&wb_stb_i)
        //if not doing memory operation
        else begin
            // MAGIC signals
            mem_data_w = 32'd0;
            mem_addr = 32'h3333;
            mem_we = 9'b000000000;
            // WB read signals
            arq_ack = 0;
            ack_ack = 0;
            rx_ack = 0;
            read_ack = 0;
            wb_dat_o = 32'd0;
            
            // writing to the ioflag
            if(flag_count > 0 && flag_count < 4) begin
                mem_data_w = 32'd1;
                mem_addr = 32'd8200;
                mem_we = 9'b100000000;
                rx_ack = 0;
                if(flag_count == 3)
                    flag_ack = 1;
            end 
            if(flag_clear_count > 0 && flag_clear_count < 11) begin
                mem_data_w = 32'd0;
                // give magic some time to do its thing
                if(flag_clear_count < 4) begin
                    mem_addr = 32'd8192;
                end else begin
                    mem_addr = 32'd8192 + flag_clear_count - 3;
                end
                if(flag_clear_count == 10) begin
                    flag_ack = 1;
                end
            end
        end
    end
end

///
/// TRANSLATING RX TO MAGIC WRITES
///
always @(posedge clock or posedge reset)
begin
    if (reset) begin
        mem_id <= 0;
        byte_num <= 0;
        wb_err_o <= 0;
        
        last_length <= 0;
        length <= 0;
        addr_offset <= 0;
        
        flag_count <= 0;
        read_count <= 0;
        
        read_meta_ready <= 1'b0;
        read_data_ready <= 1'b0;
        read_count <= 3'd0;
    end else begin
        wb_err_o <= 0;
        
        // WISHBONE writes
        if(wb_cyc_i & wb_stb_i & wb_we_i) begin
            //Extract packet metadata
            // Ethmac specifies address as byte number (increments it by 4)
            // Byte 12-13, word 3:  RESERVED (ethertype - appletalk)
            // Byte 14-15:          pp_type (purisc protocol packet type)
            // Byte 16-17, word 4:  length 
            // Byte 18-19:          mem-id 
            // Byte 20-21: word 5:  n (packet number) 
            // Byte 22-23:          M (total packets) 
            if(wb_adr_i == 32'd12) begin
                //ethtype <= wb_dat_i[31:16];
                //pp_type <= wb_dat_i[15:0]; // indicates whether this is data or metadata
                
            end else if(wb_adr_i == 32'd16) begin
                length <= wb_dat_i[31:16]; 
                mem_id <= wb_dat_i[15:0]; 
                
            end else if(wb_adr_i == 32'd20) begin
                n <= wb_dat_i[31:16];
                M <= wb_dat_i[15:0];
                
                // set the offset now that all required information is available
                addr_offset <= wb_dat_i[31:16]*(length>>2);
            end 
            
            if(cyc_count < 3'd3) begin
                cyc_count <= cyc_count + 3'd1;
            end
        end else begin
            cyc_count <= 3'd0;
            
            
            // FLAG IO state (lower priority than WB IO)
            if(flag_ready) begin
                if(flag_count < 3'd4)
                    flag_count <= flag_count + 3'd1;
            end else begin
                flag_count <= 3'd0;
            end
            
            if(flag_done_clear) begin
                if(flag_clear_count < 4'd11)
                    flag_clear_count <= flag_clear_count + 4'd1;
            end else begin
                flag_clear_count <= 4'd0;
            end
        end 
        
        // WISHBONE reads
        if(wb_cyc_i & wb_stb_i & !wb_we_i) begin
            if(read_count < 3'd7)
                read_count <= read_count + 3'd1;
                
            // read metadata
            if(read_count == 1) begin
                // request the pointer (in comb block)
            end else if(read_count == 3) begin
                //if reading global, get metadata
                if(wb_adr_i[29] && wb_adr_i[23:0] < 2) begin
                    // pointer now available
                    tx_ptr <= mem_gl_data_r;
                    // request the length (in comb block)
                end
            end else if(read_count == 4) begin
                //if reading global, get metadata
                if(wb_adr_i[29]) begin
                    //length now available
                    tx_len <= mem_gl_data_r;
                    read_meta_ready <= 1;
                    read_data_ready <= 0;
                end
            end 
            if(read_count > 4) begin
                read_data_ready <= !read_data_ready;
            end
        end else begin
            read_count <= 3'd0;
            read_meta_ready <= 0;
            read_data_ready <= 0;
        end
    end
end

always @(mem_id) begin
    case(mem_id)
        16'h0000:   mem_id_decode = 9'b000000001;
        16'h0001:   mem_id_decode = 9'b000000010;
        16'h0100:   mem_id_decode = 9'b000000100;
        16'h0101:   mem_id_decode = 9'b000001000;
        16'h0200:   mem_id_decode = 9'b000010000;
        16'h0201:   mem_id_decode = 9'b000100000;
        16'h0300:   mem_id_decode = 9'b001000000;
        16'h0301:   mem_id_decode = 9'b010000000;
        16'h0400:   mem_id_decode = 9'b100000000;
        default:    mem_id_decode = 9'b000000000;
    endcase
end

endmodule