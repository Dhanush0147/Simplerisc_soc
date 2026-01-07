`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2025 10:05:08
// Design Name: 
// Module Name: mag_cmpa
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


module comparator_a(R,TMR,duty_cycle_out);
input [15:0] TMR,duty_cycle_out;
output R;

assign R = (TMR==duty_cycle_out);
endmodule
