`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2025 15:59:04
// Design Name: 
// Module Name: DFF_negedge
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




module DFF_negedge(clk, d, q, reset);
    input clk, d, reset;
    output q;
    reg q;
    
    always @(negedge clk or posedge reset)
    begin
        if(reset)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule


