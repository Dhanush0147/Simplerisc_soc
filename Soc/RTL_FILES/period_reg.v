`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.05.2025 16:16:16
// Design Name: 
// Module Name: period_reg
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


module period_reg(PR,clk,pr_in,rst);
input wire [15:0]pr_in;
input wire clk,rst;
output reg [15:0]PR;

always @(posedge clk or posedge rst) begin
  if(rst)
    PR <=16'b1111111111111111;      // force period = ffff on reset
  else
    PR <= pr_in;
end
endmodule

