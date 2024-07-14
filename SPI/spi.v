module spi
#(parameter SPI_MODE = 0, //4 modes, depending on CPOl, CPHA
parameter CLKS_PER_HALF_BIT =2)
(
input reset,
input clk,

input [7:0] mosi_byte,
input mosi_tick,
output reg mosi_ready,

output reg miso_tick,
output reg [7:0] miso_byte,

output reg spi_clk,
input spi_miso,
output reg spi_mosi
    );
    
    wire CPOL; //clock polarity
    wire CPHA; //clock phase
    
    reg [3:0] spi_clk_count; 
    reg clk_reg;
    reg [4:0] clk_edges;
    reg leading_edge;
    reg trailing_edge;
    reg mosi_tick_reg;
    reg [7:0] mosi_byte_reg;
    
    reg [2:0] mosi_bit_count;
    reg [2:0] miso_bit_count;
    
    assign CPOL = (SPI_MODE == 2) || (SPI_MODE == 3);
    assign CPHA = (SPI_MODE == 1) || (SPI_MODE == 3);
    
    always @(posedge clk, negedge reset) begin
    if(~reset) begin
      mosi_ready      <= 1'b0;
      clk_edges <= 0;
      leading_edge  <= 1'b0;
      trailing_edge <= 1'b0;
      clk_reg      <= CPOL; // assign default state to idle state
      spi_clk_count <= 0;
    end//if 1
    else begin
        leading_edge <= 1'b0;
        trailing_edge <= 1'b0;

        if(mosi_tick) begin
            mosi_ready <= 1'b0;
            clk_edges <= 16; // 8 bits = 16 edges
        end
        else if(clk_edges > 0) begin
            mosi_ready <= 0;
            if(spi_clk_count == CLKS_PER_HALF_BIT * 2 - 1) begin
                clk_edges <= clk_edges - 1'b1;
                trailing_edge <= 1'b1;
                spi_clk_count <= 0;
                clk_reg <= ~clk_reg;
            end// if
            else if begin
                clk_edges <= clk_edges - 1'b1;
                leading_edge <= 1'b1;
                spi_clk_count <= spi_clk_count + 1'b1;;
                clk_reg <= ~clk_reg;
            end //else if
            else begin
                spi_clk_count <= spi_clk_count + 1'b1;
            end //else
        end //else if(clk_edges > 0)
       else begin
       mosi_ready <= 1'b1;
       end
    end//else
    end //always end
    
    
    always @(posedge clk, negedge reset) begin
    if(~reset) begin
        mosi_byte_reg <= 8'h00;
        mosi_tick_reg <= 1'b0;
    end//if1
    else begin
        mosi_tick_reg <= mosi_tick;
        if(mosi_tick) begin
            mosi_byte_reg <= mosi_byte;
        end
    end
    end //always
    
    //generating mosi data
    always @(posedge clk, negedge reset)begin
    if(~reset)begin
        spi_mosi <= 1'b0;
        mosi_bit_count <= 3'b111;
    end//if1
    else begin
        if(mosi_ready) begin
            mosi_bit_count <= 3'b111; //reseting to default value
        end
        else if(mosi_tick_reg & ~CPHA)begin
            spi_mosi <= mosi_byte_reg[7];
            mosi_bit_count <= 3'b110;
        end
        else if ((leading_edge & CPHA) | (trailing_edge & ~CPHA)) begin
            mosi_bit_count <= mosi_bit_count - 1'b1;
            spi_mosi <= mosi_byte_reg[mosi_bit_count];
        end
    end//else
    end //always
    
    // read in miso data
    always @(posedge clk, negedge reset) begin
    if(reset) begin
        miso_byte <= 8'h00;
        miso_tick <= 1'b0;
        miso_bit_count <= 3'b111;
    end
    else begin 
        miso_tick <= 1'b0;
        
        if(mosi_ready) begin
            miso_bit_count <= 3'b111;
        end
        else if ((leading_edge & ~CPHA) | (trailing_edge & CPHA)) begin
        miso_byte[miso_bit_count] <= spi_miso;
        miso_bit_count <= miso_bit_count - 1'b1;
        if(miso_bit_count == 3'b000) begin
            miso_tick <= 1'b1;
        end
        end
    end
    end//always
    
    //clock delay
    always @(posedge clk, negedge reset) begin
    if(~reset) begin
        spi_clk <= CPOL;
    end
    else begin
        spi_clk <= clk_reg;
    end
    end
    
    
endmodule
