`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025 15:20:30
// Design Name: 
// Module Name: T_FF_freq_div
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


module T_FF_freq_div(Qt,clk,rst);
    output  [7:0]Qt;
    input clk,rst;
    
    T_ff tff0(.Qt(Qt[0]),.clk(clk),.rst(rst));
    T_ff tff1(.Qt(Qt[1]),.clk(~Qt[0]),.rst(rst));
    T_ff tff2(.Qt(Qt[2]),.clk(~Qt[1]),.rst(rst));
    T_ff tff3(.Qt(Qt[3]),.clk(~Qt[2]),.rst(rst));
    T_ff tff4(.Qt(Qt[4]),.clk(~Qt[3]),.rst(rst));
    T_ff tff5(.Qt(Qt[5]),.clk(~Qt[4]),.rst(rst));
    T_ff tff6(.Qt(Qt[6]),.clk(~Qt[5]),.rst(rst));
    T_ff tff7(.Qt(Qt[7]),.clk(~Qt[6]),.rst(rst));
   
    
endmodule
