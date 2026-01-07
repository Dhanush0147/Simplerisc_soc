module SPI_SLAVE (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output   [31:0] PRDATA,
    output        PREADY,
    output  reg         PSLVERR,
    input miso_spi,
    input [10:0]SPI_CONTROL,
    output mosi_spi,
    inout cs_spi,
    output interrupt_spi,
    inout sclk_spi ,
    output [2:0]control_reg_out_spi
);

SPI spi(
     .clk(PCLK),
     .rst(PRESETn),
     .PWDATA(PWDATA),
     .PWRITE(PWRITE),
     .PENABLE(PENABLE),
     .PSEL(PSEL),
     .miso(miso_spi),
     .control_reg(SPI_CONTROL),
     .mosi(mosi_spi),
     .cs(cs_spi),
     .interrupt_spi(interrupt_spi),
     .sclk(sclk_spi),
     .control_reg_out_bo(control_reg_out_spi),
     .PREADY(PREADY),
     .PRDATA(PRDATA)
    );




endmodule