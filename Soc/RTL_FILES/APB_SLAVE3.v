module I2C_SLAVE (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    input [10:0]I2C_control,
    output   [31:0] PRDATA,
    output        PREADY,
    output  reg         PSLVERR,
    output SCL,
    inout SDA,
    output interrupt_i2c  
);


i2c i2c(
    .clk(PCLK),
    .rst(PRESETn),
    .I2C_control(I2C_control),
    .PWDATA(PWDATA),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PSEL(PSEL),
    .SCL(SCL),
    .PREADY(PREADY),
    .PRDATA(PRDATA),
    .SDA(SDA),
    .interrupt_i2c(interrupt_i2c)
    );

endmodule
