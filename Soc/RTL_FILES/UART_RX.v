`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 17:28:00
// Design Name: 
// Module Name: UART_RX
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


module UART_RX(RX,data_bus,clk,rst,EN_50MHz,SPEN,FERR,read_en,RXEN,RXIF);
input read_en,EN_50MHz;
input clk,rst,RX,SPEN,RXEN;
output [7:0] data_bus;
output FERR,RXIF;

wire serial_in,RX_serial_in;
wire baud_out_top;
wire st_bit_detected_top;
wire [7:0] data_out_top;
wire shift_done_top;
wire stop_valid_top;
wire pullup_en;

active_high_buffer  active_high_buffer(.in(RX_serial_in),.out(serial_in),.enable(SPEN));
baudrate_gen_rx  baud_rec(
    .clk(clk),.rst(rst),.EN_50MHz(EN_50MHz),.baud_out(baud_out_top)
    );

and a1(RX_baudrate, RXEN, baud_out_top);

Edge_Detector ED(
.clk(clk),
.rst(rst),
.serial_in(serial_in),
.shift_done(shift_done_top),
.st_bit_detected(st_bit_detected_top)
);


uart_shift_register sf (
    .baud_clk(RX_baudrate),             
    .rst(rst),                  
    .serial_in(serial_in),                  
    .st_bit_detected(st_bit_detected_top),      
    .RX_shift_reg(data_out_top),       
    .shift_done(shift_done_top),
    .pull_up_en(pullup_en)                 
);


checking_stop_bit chk(
    .clk(RX_baudrate),
    .rst(rst),
    .serial_in(serial_in),            
    .shift_done(shift_done_top),  
    .ext_clk(clk),  
    .fram_err(FERR),
    .stop_valid(stop_valid_top),
    .pullup_en(pullup_en)      
);


RCREG RCREG (
    .clk(clk),
    .rst(rst),
    .stop_valid(stop_valid_top),
    .data_in(data_out_top),
    .read_en(read_en),           
    .data_out(data_bus),
    .RXIF(RXIF)                
);


//assign pull_up_en = (~stop_valid_top) & shift_done_top;
pull_up pull_up(.serial_in(RX),.RX_serial_in(RX_serial_in),.pullup_en(pullup_en));

endmodule
