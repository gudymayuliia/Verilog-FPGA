module spi_cs
#(parameter SPI_MODE = 0,
parameter CLKS_PER_HALF_BIT = 2,
parameter MAX_BYTES_PER_CS = 2,
parameter CS_INACTIVE_CLKS = 1)
(
input        reset,     // FPGA Reset
input        clk,       // FPGA Clock
   
// TX (MOSI) Signals
input [$clog2(MAX_BYTES_PER_CS+1)-1:0] mosi_count,  // # bytes per CS low
input [7:0]  mosi_byte,       // Byte to transmit on MOSI
input        mosi_tick,         // Data Valid Pulse with i_TX_Byte
output       mosi_ready,      // Transmit Ready for next byte
   
// RX (MISO) Signals
output reg [$clog2(MAX_BYTES_PER_CS+1)-1:0] miso_count,  // Index RX byte
output       miso_tick,     // Data Valid pulse (1 clock cycle)
output  [7:0] miso_byte,   // Byte received on MISO

// SPI Interface
output spi_clk,
input  spi_miso,
output spi_mosi,
output spi_cs
);

//state machine for chip select
localparam IDLE        = 2'b00;
localparam TRANSFER    = 2'b01;
localparam CS_INACTIVE = 2'b10;

reg [1:0] sm_cs;
reg cs_reg;
reg [$clog2(CS_INACTIVE_CLKS)-1:0] cs_count;
reg [$clog2(MAX_BYTES_PER_CS+1)-1:0] byte_count;
wire master_ready;

//instatiating module spi
spi #(.SPI_MODE(SPI_MODE), 
.CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) SPI_master (
.reset(reset),
.clk(clk),
 // TX (MOSI) Signals
.mosi_byte(mosi_byte),         // Byte to transmit
.mosi_tick(mosi_tick),             // Data Valid Pulse 
.mosi_ready(mosi_ready),   // Transmit Ready for Byte
   
   // RX (MISO) Signals
.miso_tick(miso_tick),       // Data Valid pulse (1 clock cycle)
.miso_byte(miso_byte),   // Byte received on MISO

   // SPI Interface
.spi_clk(spi_clk),
.spi_miso(spi_miso),
.spi_mosi(spi_mosi)
);



always @(posedge clk, negedge reset) begin
if(~reset) begin
    sm_cs <= IDLE;
    cs_reg <= 1'b1;
    byte_count <= 0;
    cs_count <= CS_INACTIVE_CLKS;
end//if
else begin
    case(sm_cs)
        IDLE: begin
            if(cs_reg & mosi_tick) begin
            byte_count <= mosi_count - 1'b1;
            cs_reg <= 1'b0;
            sm_cs <= TRANSFER;
            end
        end
        TRANSFER: begin
            if(master_ready) begin
                if(byte_count > 0) begin
                    if(mosi_tick) begin
                    byte_count <= byte_count -1'b1;
                    end
                end
            else begin 
                cs_reg <= 1'b1;
                cs_count <= CS_INACTIVE_CLKS;
                sm_cs <= CS_INACTIVE;
            end
            end // master ready
        end
        CS_INACTIVE: begin
            if(cs_count > 0)
                cs_count <= cs_count - 1'b1;
            else
                sm_cs <= IDLE;
        end
        default: begin
            cs_reg <= 1'b1;
            sm_cs <= IDLE;
        end
        endcase
end//else
end//always

//keeping track of miso byte count

always @(posedge clk) begin
    if(cs_reg)
        miso_count <= 0;
    else if (miso_tick)
        miso_count <= miso_count + 1'b1;
end//always

assign spi_cs = cs_reg;
assign mosi_ready = ((sm_cs == IDLE) | (sm_cs == TRANSFER && master_ready == 1'b1 && byte_count > 0)) & ~mosi_tick;

endmodule
