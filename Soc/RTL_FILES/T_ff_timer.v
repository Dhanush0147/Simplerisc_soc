`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025 15:14:23
// Design Name: 
// Module Name: T_ff
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


module T_ff(Qt,clk,rst);
    input clk,rst;
    output reg Qt;
    
    
    always @(posedge clk or posedge rst)begin 
        if(rst==1)begin 
            Qt <= 1'b0;
        end
        else begin
            Qt <= ~ Qt;
        end
    end    
endmodule
