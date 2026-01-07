`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 16:07:10
// Design Name: 
// Module Name: UART_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_TOP(
input EN_50MHz,  
input PENABLE,
input PCLK,PRESETn,
input PWRITE,PSEL,
input TXEN,SPEN,
input RX,RXEN,
input [31:0] PWDATA,
input [1:0] BAUD_SEL,
input [1:0] uart_control,
output TXIF,RXIF,TX,
output [7:0] PRDATA
);

wire RESET = ~PRESETn;



wire ENABLE = PSEL & PWRITE & PENABLE;

wire READ_EN = PSEL & (~PWRITE) & PENABLE;


    UART_transmitter u1(
    .EN_50MHz(EN_50MHz),
    .ENABLE(ENABLE),
    .UART_data(PWDATA),
    .baud_sel(BAUD_SEL),
     .clk(PCLK),.reset(RESET),
     .uart_control(uart_control),
     .TXEN(TXEN),.TXIF(TXIF),
     .TX(TX),
     .SPEN(SPEN)
     );
    
    UART_RX rec1(
    .RX(RX),
    .data_bus(PRDATA),
    .EN_50MHz(EN_50MHz),
    .clk(PCLK),.rst(RESET),
    .SPEN(SPEN),
    .read_en(READ_EN),
    .RXEN(RXEN),
    .RXIF(RXIF)
    );
    
   

endmodule