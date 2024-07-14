


module spi_tb();
  parameter SPI_MODE = 1; // CPOL = 1, CPHA = 1
  parameter CLKS_PER_HALF_BIT = 2;  // 6.25 MHz
  parameter MAIN_CLK_DELAY = 2;  // 25 MHz

  reg reset = 1'b0;
  reg clk = 1'b0;
  reg [7:0] mosi_byte = 0;
  reg mosi_tick = 1'b0;
  wire mosi_ready;
  
  wire miso_tick;
  wire [7:0] miso_byte;
  
  wire spi_clk;
  reg spi_miso;
  wire spi_mosi; 

  // Clock Generators:
  always #(MAIN_CLK_DELAY) clk = ~clk;

  // Instantiate UUT
  spi 
  #(.SPI_MODE(SPI_MODE),
    .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) SPI_Master_UUT
  (
   // Control/Data Signals,
   .reset(reset),     // FPGA Reset
   .clk(clk),         // FPGA Clock
   
   // TX (MOSI) Signals
   .mosi_byte(mosi_byte),     // Byte to transmit on MOSI
   .mosi_tick(mosi_tick),         // Data Valid Pulse with i_TX_Byte
   .mosi_ready(mosi_ready),   // Transmit Ready for Byte
   
   // RX (MISO) Signals
   .miso_tick(miso_tick),       // Data Valid pulse (1 clock cycle)
   .miso_byte(miso_byte),   // Byte received on MISO

   // SPI Interface
   .spi_clk(spi_clk),
   .spi_miso(spi_miso),
   .spi_mosi(spi_mosi)
   );


  // Sends a single byte from master.
  task SendSingleByte(input [7:0] data);
  begin
    @(posedge clk);
    mosi_byte <= data;
    mosi_tick   <= 1'b1;
    @(posedge clk);
    mosi_tick <= 1'b0;
    @(posedge mosi_ready);
    end
  endtask // SendSingleByte

  
  initial
    begin
      
      
      repeat(10) @(posedge clk);
      reset  = 1'b0;
      repeat(10) @(posedge clk);
      reset          = 1'b1;
      
      // Test single byte
      SendSingleByte(8'hC1);
      $display("Sent out 0xC1, Received 0x%X", miso_byte); 
      
      // Test double byte
      SendSingleByte(8'hBE);
      $display("Sent out 0xBE, Received 0x%X", miso_byte); 
      SendSingleByte(8'hEF);
      $display("Sent out 0xEF, Received 0x%X", miso_byte); 
      repeat(10) @(posedge clk);
      $finish();      
    end // initial begin

endmodule // SPI_Slave


