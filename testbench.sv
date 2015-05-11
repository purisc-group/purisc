/*
This module just provides clock and reset signals for test_ethmac

*/
`include "io_controller/ethmac/rtl/verilog/timescale.v"
//`default_nettype none
`define ET_APPLETALK 16'h809B
`define ET_INET_PROT 16'h0800
module testbench;

logic Clock_50;
logic reset;

wire SRAM_resetn;
wire [15:0] SRAM_DQ;
wire [17:0] SRAM_ADDR;
wire SRAM_UB_N;
wire SRAM_LB_N;
wire SRAM_WE_N;
wire SRAM_CE_N;
wire SRAM_OE_N;

assign SRAM_resetn = ~reset;

//connections to fake phy
wire eth_reset_n, Mdc_O, Mdio_IO, mrx_clk, MColl, MCrs, MRxDV, MRxErr, mtx_clk, MTxEn, MTxErr;
wire [3:0] MRxD;
wire [3:0] MTxD;

//fake memory bypass signal
reg [7:0] flag_done;

// Instantiate the unit under test
top_level uut (
	//////////// CLOCK //////////
	.CLOCK_50_I(Clock_50),
	.SWITCH_I(reset),
    
    //a fake phy exists in the module
    .ENET0_MDC(Mdc_O),          // Management data clock reference
    .ENET0_MDIO(Mdio_IO),       // Management Data
    .ENET0_RST_N(eth_reset_n),  // Hardware reset Signal
    .ENET0_RX_CLK(mrx_clk),     // GMII/MII Receive clock
    .ENET0_RX_COL(MColl),       // GMII/MII Collision
    .ENET0_RX_CRS(MCrs),        // GMII/MII Carrier sense
    .ENET0_RX_DATA(MRxD),       // GMII/MII Receive data
    .ENET0_RX_DV(MRxDV),        // GMII/MII Receive data valid
    .ENET0_RX_ER(MRxErr),       // GMII/MII Receive error
    .ENET0_TX_CLK(mtx_clk),     // MII Transmit Clock
    .ENET0_TX_DATA(MTxD),       // MII Transmit Data
    .ENET0_TX_EN(MTxEn),        // GMII/MII Transmit enable
    .ENET0_TX_ER(MTxErr),       // GMII/MII Transmit error
    
    .tb_flag_input(flag_done)
);

// The emulator for the external SRAM during simulation
tb_SRAM_Emulator SRAM_component (
	.Clock_50(Clock_50),
	.Resetn(SRAM_resetn),
	
	.SRAM_data_io(SRAM_DQ),
	.SRAM_address(SRAM_ADDR),
	.SRAM_UB_N(SRAM_UB_N),
	.SRAM_LB_N(SRAM_LB_N),
	.SRAM_WE_N(SRAM_WE_N),
	.SRAM_CE_N(SRAM_CE_N),
	.SRAM_OE_N(SRAM_OE_N)
);

//phy module
eth_phy eth_phy (
  // WISHBONE reset
  .m_rst_n_i(eth_reset_n),
  // MAC TX
  .mtx_clk_o(mtx_clk),    .mtxd_i(MTxD),    .mtxen_i(MTxEn),    .mtxerr_i(MTxErr),
  // MAC RX
  .mrx_clk_o(mrx_clk),    .mrxd_o(MRxD),    .mrxdv_o(MRxDV),    .mrxerr_o(MRxErr),
  .mcoll_o(MColl),        .mcrs_o(MCrs),
  // MIIM
  .mdc_i(Mdc_O),          .md_io(Mdio_IO)
  // SYSTEM
  //.phy_log(phy_log_file_desc)
);

// Generate a 50 MHz clock
always begin
	# 10;
	Clock_50 = ~Clock_50;
end

// Task for generating master reset
task master_reset;
begin
	wait (Clock_50 !== 1'bx);
	@ (posedge Clock_50);
	reset = 1'b1;
	// Activate reset for 1 clock cycle
	@ (posedge Clock_50);
	reset = 1'b0;
end
endtask

// Initialize signals
initial begin
	Clock_50 = 1'b0;
	// Apply master reset
	master_reset;
end

// inputs? outputs?
reg st_data;
logic [15:0] header_len;
logic [15:0] pp_header_len;
logic [15:0] payload_len;
logic [15:0] crc_len;

logic [15:0] n;         //packet id
logic [15:0] M;         //number of packets
logic [15:0] retry_M;
logic [15:0] mem_id;    //the destination memory
logic break_packet;
initial begin
    
    #1 eth_phy.control_bit14_10 = 5'b01000; // bit 13 set, 100mbps?
    #1 eth_phy.control_bit8_0   = 9'h1_00;  // bit 6 reset  - (10/100), bit 8 set - FD

    # 50000;
    //
    //  HOST SENDS CLIENT combined_updown.machine IN SEVERAL PACKETS
    //

    //lengths of everything in bytes
    header_len = 16'h6; //this never changes
    pp_header_len = 16'd20;
    crc_len = 16'h4;    //this never changes
    
    payload_len = 16'h400; //before crc //in BYTES NOT WORDS
    
    //no idea what this does, might need it
    eth_phy.no_carrier_sense_rx_fd_detect(0);
    eth_phy.collision(0);
    
    //
    // send 5 packets (even packets have bad crc)
    //
    
    M=3;        //total number of packets
    mem_id=16'h0400;   //send to global
    break_packet=0;
    for(n=0; n < M; n++) begin
//        if(n == 2)
//            break_packet = 1'd1;
//        else
//            break_packet = 1'd0;
        set_rx_packet_from_file(32'd0,  pp_header_len+header_len+payload_len, 1'b0, 48'h5055_5249_5343, 
                48'hA1B2_C3D4_E5F6, `ET_APPLETALK, payload_len, payload_len*n, mem_id, n, M);
        append_rx_crc (32'd0/*rx pointer*/, pp_header_len+payload_len/*length*/, 1'b0, break_packet/*negated crc*/);
        #1 eth_phy.send_rx_packet(64'h0055_5555_5555_5555, 4'h7, 8'hD5, 32'd0, pp_header_len+payload_len+crc_len, 1'b0);
        # 96000;
    end 
    
    ///
    /// re-send everything including and after the first broken packet
    ///
//    wait (MTxEn === 1'b0);
//    # 50000;
//    retry_M = 2;
//    break_packet = 0;
//    for(n=3; n < M; n++) begin
//        set_rx_packet_from_file(32'd0,  header_len+payload_len, 1'b0, 48'h5055_5249_5343, 48'hA1B2_C3D4_E5F6, `ET_APPLETALK, payload_len, payload_len*n, mem_id, n, retry_M);
//        append_rx_crc (32'd0/*rx pointer*/, payload_len/*length*/, 1'b0, break_packet/*negated crc*/);
//        #1 eth_phy.send_rx_packet(64'h0055_5555_5555_5555, 4'h7, 8'hD5, 32'd0, payload_len+crc_len, 1'b0);
//        # 50000;
//    end 
    
    
    # 50000; // pretend to crunch for a while
    
    flag_done = 8'hF0;
    
    # 50000; // pretend to crunch for a while
    
    flag_done = 8'hFF;
    
end


task set_rx_packet_from_file;
    input   [31:0]  rxpnt;
    input   [15:0]  len;
    input           plus_dribble_nibble; // if length is longer for one nibble
    input   [47:0]  eth_dest_addr;
    input   [47:0]  eth_source_addr;
    input   [15:0]  eth_type_len;
    input   [15:0]  payload_length;
    input   [15:0]  file_start_index;
    // for custom protocol header
    input   [15:0]  mem_id;
    input   [15:0]  n;
    input   [15:0]  M;
    
    integer         i, sd;
    reg     [47:0]  dest_addr;
    reg     [47:0]  source_addr;
    reg     [15:0]  type_len;
    reg     [21:0]  buffer;
    reg             delta_t;
    integer         data_file;
    integer         scan_file;
    logic signed [31:0] captured_data;
    reg     [7:0]   write_data;
begin
    $display("OPENING FILE: ../../machine_code/global_mem.machine\n");
    data_file = $fopen("../../machine_code/global_mem.machine", "r");
    if (data_file == 0) begin
        $display("data_file handle was NULL");
        // $finish; //this causes nothing but pain
    end
    //convert to int
    sd = file_start_index; 
    // seek to the right position in the file (fseek uses bytes, not lines)
    for(i = 0; i < sd/4; i = i+1) begin
        if (!$feof(data_file)) begin
            $fscanf(data_file, "%d\n", captured_data); 
        end
    end

    buffer = rxpnt[21:0];
    dest_addr = eth_dest_addr;
    source_addr = eth_source_addr;
    type_len = eth_type_len;
    delta_t = 0;

    for(i = 0; i < len; i = i + 1) begin
        $display("i=%d", i);
        if (i < 6) begin
            eth_phy.rx_mem[buffer] = dest_addr[47:40];
            dest_addr = dest_addr << 8;
        end
        else if (i < 12) begin
            eth_phy.rx_mem[buffer] = source_addr[47:40];
            source_addr = source_addr << 8;
        end
        else if (i < 14) begin
            eth_phy.rx_mem[buffer] = type_len[15:8];
            type_len = type_len << 8;
        end
        else if (i < 24) begin
            // APPEND THE CUSTOM PROTOCOL HEADER
            eth_phy.rx_mem[buffer] = 8'd0;
            
            case(i)
            14: 
                eth_phy.rx_mem[buffer] = 8'd0;
            15:
                eth_phy.rx_mem[buffer] = 8'd0;
            16:
            begin
                $display("payload_length[15:8] %d\tbuffer:%X",payload_length[15:8],buffer);
                eth_phy.rx_mem[buffer] = payload_length[15:8];
            end
            17:
            begin
                $display("payload_length[7:0] %d\tbuffer:%X",payload_length[7:0],buffer);
                eth_phy.rx_mem[buffer] = payload_length[7:0];
            end
            18:
            begin
                $display("mem_id[15:8] %d\tbuffer:%X",mem_id[15:8],buffer);
                eth_phy.rx_mem[buffer] = mem_id[15:8];
            end
            19:
            begin
                $display("mem_id[7:0] %d\tbuffer:%X",mem_id[7:0],buffer);
                eth_phy.rx_mem[buffer] = mem_id[7:0]; //memory identifier (cg id(0-3) or global(4))
            end
            20:
            begin
                $display("n[15:8] %d\tbuffer:%X",n[15:8],buffer);
                eth_phy.rx_mem[buffer] = n[15:8]; //packet number (n)
            end
            21:
            begin
                $display("n[7:0]%d\tbuffer:%X",n[7:0],buffer);
                eth_phy.rx_mem[buffer] = n[7:0]; //packet number (n)
            end
            22:
            begin
                $display("M[15:8]%d\tbuffer:%X",M[15:8],buffer);
                eth_phy.rx_mem[buffer] = M[15:8]; //out of how many packets (M)
            end
            23:
            begin
                $display("M[7:0]%d\tbuffer:%X",M[7:0],buffer);
                eth_phy.rx_mem[buffer] = M[7:0]; //out of how many packets (M)
            end
            endcase
            
        end 
        else begin
            if((i+0)%4 == 0) begin
                $display("1");
                if (!$feof(data_file)) begin
                    scan_file = $fscanf(data_file, "%d\n", captured_data); 
                end else begin
                    captured_data = 32'd0;
                end
                write_data = captured_data[31:24];
            end else if((i+0)%4 == 1) begin
                $display("2");
                write_data = captured_data[23:16];
            end else if((i+0)%4 == 2) begin
                $display("3");
                write_data = captured_data[15:8];
            end else begin
                $display("4");
                write_data = captured_data[7:0];
            end
            eth_phy.rx_mem[buffer] = write_data;
            $display("write_data:%X\tbuffer:%X\tcaptured_data:%X", write_data, buffer, captured_data);
        end
        
        buffer = buffer + 1;
    end
    delta_t = !delta_t;
    if (plus_dribble_nibble)
        eth_phy.rx_mem[buffer] = {4'h0, 4'hD /*sd[3:0]*/};
        delta_t = !delta_t;
    end
    
endtask // set_rx_packet_from_memory


task set_rx_packet;
  input  [31:0] rxpnt;
  input  [15:0] len;
  input         plus_dribble_nibble; // if length is longer for one nibble
  input  [47:0] eth_dest_addr;
  input  [47:0] eth_source_addr;
  input  [15:0] eth_type_len;
  input  [7:0]  eth_start_data;
  integer       i, sd;
  reg    [47:0] dest_addr;
  reg    [47:0] source_addr;
  reg    [15:0] type_len;
  reg    [21:0] buffer;
  reg           delta_t;
begin
  buffer = rxpnt[21:0];
  dest_addr = eth_dest_addr;
  source_addr = eth_source_addr;
  type_len = eth_type_len;
  sd = eth_start_data;
  delta_t = 0;
  for(i = 0; i < len; i = i + 1) 
  begin
    if (i < 6)
    begin
      eth_phy.rx_mem[buffer] = dest_addr[47:40];
      dest_addr = dest_addr << 8;
    end
    else if (i < 12)
    begin
      eth_phy.rx_mem[buffer] = source_addr[47:40];
      source_addr = source_addr << 8;
    end
    else if (i < 14)
    begin
      eth_phy.rx_mem[buffer] = type_len[15:8];
      type_len = type_len << 8;
    end
    else
    begin
      eth_phy.rx_mem[buffer] = sd[7:0];
      sd = sd + 1;
    end
    buffer = buffer + 1;
  end
  delta_t = !delta_t;
  if (plus_dribble_nibble)
    eth_phy.rx_mem[buffer] = {4'h0, 4'hD /*sd[3:0]*/};
  delta_t = !delta_t;
end
endtask // set_rx_packet

task append_rx_crc;
  input  [31:0] rxpnt_phy; // source
  input  [15:0] len; // length in bytes without CRC
  input         plus_dribble_nibble; // if length is longer for one nibble
  input         negated_crc; // if appended CRC is correct or not
  reg    [31:0] crc;
  reg    [7:0]  tmp;
  reg    [31:0] addr_phy;
  reg           delta_t;
begin
  addr_phy = rxpnt_phy + len;
  delta_t = 0;
  // calculate CRC from prepared packet
  paralel_crc_phy_rx(rxpnt_phy, {16'h0, len}, plus_dribble_nibble, crc);
  if (negated_crc)
    crc = ~crc;
  delta_t = !delta_t;

  if (plus_dribble_nibble)
  begin
    tmp = eth_phy.rx_mem[addr_phy];
    eth_phy.rx_mem[addr_phy]     = {crc[27:24], tmp[3:0]};
    eth_phy.rx_mem[addr_phy + 1] = {crc[19:16], crc[31:28]};
    eth_phy.rx_mem[addr_phy + 2] = {crc[11:8], crc[23:20]};
    eth_phy.rx_mem[addr_phy + 3] = {crc[3:0], crc[15:12]};
    eth_phy.rx_mem[addr_phy + 4] = {4'h0, crc[7:4]};
  end
  else
  begin
    eth_phy.rx_mem[addr_phy]     = crc[31:24];
    eth_phy.rx_mem[addr_phy + 1] = crc[23:16];
    eth_phy.rx_mem[addr_phy + 2] = crc[15:8];
    eth_phy.rx_mem[addr_phy + 3] = crc[7:0];
  end
end
endtask // append_rx_crc

// paralel CRC calculating for PHY RX
task paralel_crc_phy_rx;
  input  [31:0] start_addr; // start address
  input  [31:0] len; // length of frame in Bytes without CRC length
  input         plus_dribble_nibble; // if length is longer for one nibble
  output [31:0] crc_out;
  reg    [21:0] addr_cnt; // only 22 address lines
  integer       word_cnt;
  integer       nibble_cnt;
  reg    [31:0] load_reg;
  reg           delta_t;
  reg    [31:0] crc_next;
  reg    [31:0] crc;
  reg           crc_error;
  reg     [3:0] data_in;
  integer       i;
begin
  #1 addr_cnt = start_addr[21:0];
  word_cnt = 24; // 27; // start of the frame - nibble granularity (MSbit first)
  crc = 32'hFFFF_FFFF; // INITIAL value
  delta_t = 0;
  // length must include 4 bytes of ZEROs, to generate CRC
  // get number of nibbles from Byte length (2^1 = 2)
  if (plus_dribble_nibble)
    nibble_cnt = ((len + 4) << 1) + 1'b1; // one nibble longer
  else
    nibble_cnt = ((len + 4) << 1);
  // because of MAGIC NUMBER nibbles are swapped [3:0] -> [0:3]
  load_reg[31:24] = eth_phy.rx_mem[addr_cnt];
  addr_cnt = addr_cnt + 1;
  load_reg[23:16] = eth_phy.rx_mem[addr_cnt];
  addr_cnt = addr_cnt + 1;
  load_reg[15: 8] = eth_phy.rx_mem[addr_cnt];
  addr_cnt = addr_cnt + 1;
  load_reg[ 7: 0] = eth_phy.rx_mem[addr_cnt];
  addr_cnt = addr_cnt + 1;
  while (nibble_cnt > 0)
  begin
    // wait for delta time
    delta_t = !delta_t;
    // shift data in

    if(nibble_cnt <= 8) // for additional 8 nibbles shift ZEROs in!
      data_in[3:0] = 4'h0;
    else

      data_in[3:0] = {load_reg[word_cnt], load_reg[word_cnt+1], load_reg[word_cnt+2], load_reg[word_cnt+3]};
    crc_next[0]  = (data_in[0] ^ crc[28]);
    crc_next[1]  = (data_in[1] ^ data_in[0] ^ crc[28]    ^ crc[29]);
    crc_next[2]  = (data_in[2] ^ data_in[1] ^ data_in[0] ^ crc[28]  ^ crc[29] ^ crc[30]);
    crc_next[3]  = (data_in[3] ^ data_in[2] ^ data_in[1] ^ crc[29]  ^ crc[30] ^ crc[31]);
    crc_next[4]  = (data_in[3] ^ data_in[2] ^ data_in[0] ^ crc[28]  ^ crc[30] ^ crc[31]) ^ crc[0];
    crc_next[5]  = (data_in[3] ^ data_in[1] ^ data_in[0] ^ crc[28]  ^ crc[29] ^ crc[31]) ^ crc[1];
    crc_next[6]  = (data_in[2] ^ data_in[1] ^ crc[29]    ^ crc[30]) ^ crc[ 2];
    crc_next[7]  = (data_in[3] ^ data_in[2] ^ data_in[0] ^ crc[28]  ^ crc[30] ^ crc[31]) ^ crc[3];
    crc_next[8]  = (data_in[3] ^ data_in[1] ^ data_in[0] ^ crc[28]  ^ crc[29] ^ crc[31]) ^ crc[4];
    crc_next[9]  = (data_in[2] ^ data_in[1] ^ crc[29]    ^ crc[30]) ^ crc[5];
    crc_next[10] = (data_in[3] ^ data_in[2] ^ data_in[0] ^ crc[28]  ^ crc[30] ^ crc[31]) ^ crc[6];
    crc_next[11] = (data_in[3] ^ data_in[1] ^ data_in[0] ^ crc[28]  ^ crc[29] ^ crc[31]) ^ crc[7];
    crc_next[12] = (data_in[2] ^ data_in[1] ^ data_in[0] ^ crc[28]  ^ crc[29] ^ crc[30]) ^ crc[8];
    crc_next[13] = (data_in[3] ^ data_in[2] ^ data_in[1] ^ crc[29]  ^ crc[30] ^ crc[31]) ^ crc[9];
    crc_next[14] = (data_in[3] ^ data_in[2] ^ crc[30]    ^ crc[31]) ^ crc[10];
    crc_next[15] = (data_in[3] ^ crc[31])   ^ crc[11];
    crc_next[16] = (data_in[0] ^ crc[28])   ^ crc[12];
    crc_next[17] = (data_in[1] ^ crc[29])   ^ crc[13];
    crc_next[18] = (data_in[2] ^ crc[30])   ^ crc[14];
    crc_next[19] = (data_in[3] ^ crc[31])   ^ crc[15];
    crc_next[20] =  crc[16];
    crc_next[21] =  crc[17];
    crc_next[22] = (data_in[0] ^ crc[28])   ^ crc[18];
    crc_next[23] = (data_in[1] ^ data_in[0] ^ crc[29]    ^ crc[28]) ^ crc[19];
    crc_next[24] = (data_in[2] ^ data_in[1] ^ crc[30]    ^ crc[29]) ^ crc[20];
    crc_next[25] = (data_in[3] ^ data_in[2] ^ crc[31]    ^ crc[30]) ^ crc[21];
    crc_next[26] = (data_in[3] ^ data_in[0] ^ crc[31]    ^ crc[28]) ^ crc[22];
    crc_next[27] = (data_in[1] ^ crc[29])   ^ crc[23];
    crc_next[28] = (data_in[2] ^ crc[30])   ^ crc[24];
    crc_next[29] = (data_in[3] ^ crc[31])   ^ crc[25];
    crc_next[30] =  crc[26];
    crc_next[31] =  crc[27];

    crc = crc_next;
    crc_error = crc[31:0] != 32'hc704dd7b;  // CRC not equal to magic number
    case (nibble_cnt)
    9: crc_out = {!crc[24], !crc[25], !crc[26], !crc[27], !crc[28], !crc[29], !crc[30], !crc[31],
                  !crc[16], !crc[17], !crc[18], !crc[19], !crc[20], !crc[21], !crc[22], !crc[23],
                  !crc[ 8], !crc[ 9], !crc[10], !crc[11], !crc[12], !crc[13], !crc[14], !crc[15],
                  !crc[ 0], !crc[ 1], !crc[ 2], !crc[ 3], !crc[ 4], !crc[ 5], !crc[ 6], !crc[ 7]};
    default: crc_out = crc_out;
    endcase
    // wait for delta time
    delta_t = !delta_t;
    // increment address and load new data
    if ((word_cnt+3) == 7)//4)
    begin
      // because of MAGIC NUMBER nibbles are swapped [3:0] -> [0:3]
      load_reg[31:24] = eth_phy.rx_mem[addr_cnt];
      addr_cnt = addr_cnt + 1;
      load_reg[23:16] = eth_phy.rx_mem[addr_cnt];
      addr_cnt = addr_cnt + 1;
      load_reg[15: 8] = eth_phy.rx_mem[addr_cnt];
      addr_cnt = addr_cnt + 1;
      load_reg[ 7: 0] = eth_phy.rx_mem[addr_cnt];
      addr_cnt = addr_cnt + 1;
    end
    // set new load bit position
    if((word_cnt+3) == 31)
      word_cnt = 16;
    else if ((word_cnt+3) == 23)
      word_cnt = 8;
    else if ((word_cnt+3) == 15)
      word_cnt = 0;
    else if ((word_cnt+3) == 7)
      word_cnt = 24;
    else
      word_cnt = word_cnt + 4;// - 4;
    // decrement nibble counter
    nibble_cnt = nibble_cnt - 1;
    // wait for delta time
    delta_t = !delta_t;
  end // while
  #1;
end
endtask // paralel_crc_phy_rx

endmodule