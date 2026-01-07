`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2025 16:49:10
// Design Name: 
// Module Name: pull_up
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


module pull_up(serial_in,RX_serial_in,pullup_en);

input serial_in,pullup_en;
output RX_serial_in;
wire w1;

   
 assign w1 = (~serial_in) & pullup_en; 
wire RX_serial_in_1;
assign RX_serial_in = RX_serial_in_1;
active_high_buffer tri_buff(.in(1'b1), .out(RX_serial_in_1),.enable(w1));
act_low_buffer low_tri_buff(.in(serial_in),.out(RX_serial_in_1),.enable(w1));


endmodule
