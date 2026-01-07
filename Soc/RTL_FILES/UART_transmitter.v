`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2025 13:27:40
// Design Name: 
// Module Name: UART_transmitter11
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


module UART_transmitter(EN_50MHz,ENABLE,UART_data, clk,reset,TXEN, baud_sel,TXIF, TX, uart_control,SPEN);
    input [31:0]UART_data;
    input [1:0]uart_control;
    input ENABLE;
    input wire [1:0] baud_sel;
    input EN_50MHz;
    input clk, reset, TXEN, SPEN;
    output TX;
    output TXIF;
    
    
    
    wire br_out;
    wire not_reset;
    wire baudrate;
    wire TSR_Ready_top;
//    wire TXIF_top;
    wire [31:0] TXREG_top;
    wire TXREG_to_TSR_en_top;
    wire serial_out_top;
    
    wire baud_top;
    wire baud_50MHz_top;
    wire [2:0] mode_top;
    
    assign not_reset = ~reset;
    
  
     
    
  
    baudrate_gen baud(.baud_sel(baud_sel),.clk(clk),.rst(reset),.baud_100MHz(baud_top),.EN_50MHz(EN_50MHz));
  
 
    and a1(baudrate, TXEN, baud_top);
    
  
   
   
   TXREG_8bit TXREG_8bit (
   .clk(clk),
   .rst(reset),
   .write_enable(ENABLE), 
   .uart_control(uart_control),
   .TSR_Ready(TSR_Ready_top),
   .TXIF(TXIF),
   .data_in(UART_data),
   .mode(mode_top),
   .TXREG(TXREG_top),
   .TXREG_to_TSR_en(TXREG_to_TSR_en_top)
   );



    TSR11_bit t2(.TXREG(TXREG_top), 
    .serial_out(serial_out_top), 
    .TSR_Ready(TSR_Ready_top), 
    .TXREG_to_TSR_en(TXREG_to_TSR_en_top),
    .uart_control(uart_control),
    .clk_ext(clk),
    .write_enable(ENABLE),
    .clk(baudrate), 
    .reset(reset),
    .mode(mode_top)
    
    );
   

   active_high_buffer  active_high_buffer(.in(serial_out_top),.out(TX),.enable(SPEN));
   
  
endmodule
