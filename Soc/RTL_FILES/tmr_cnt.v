`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2025 07:45:16
// Design Name: 
// Module Name: tmr_cnt
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


module tmr_cnt(TMR,clk,rst,PR,EN_TMR);
input clk,rst,EN_TMR;
input [15:0]PR;
output reg [15:0] TMR;

always @(posedge clk or posedge rst)
begin 
    if(rst==1)
        TMR <= 16'b0;
    else if(EN_TMR==0)begin
        TMR <= 16'b0;
    end 
    else begin   
        if(TMR>=PR)
            TMR<= 16'b0;
        else
            TMR<= TMR + 16'b1;
    end        
end
endmodule

