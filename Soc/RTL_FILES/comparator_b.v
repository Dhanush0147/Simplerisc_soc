`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2025 10:15:14
// Design Name: 
// Module Name: mag_cmpb
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


module comparator_b(S,TMR,PR);
input [15:0] TMR;
input [15:0] PR;
output S;

assign S = (TMR==PR);
endmodule

