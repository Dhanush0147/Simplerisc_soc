`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 17:14:07
// Design Name: 
// Module Name: prescalar2
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


module prescalar2(clk_out,clk,rst,prescale_value,en_prescalar);
    input clk,rst,en_prescalar;
    input [4:0] prescale_value;
    output clk_out;
    wire [31:0] Qt;
    wire muxed_clk;
    wire gated_clk;
   // always @(*)begin       wrong, we can't instantiate in always block
   //if(en==1)begin
    
    and And(gated_clk,clk,en_prescalar);
    T_FF_freq_div tffs(.Qt(Qt),.clk(gated_clk),.rst(rst));
    fourbit_mux mux4(.clk_out(muxed_clk),.prescale_value(prescale_value),.Qt(Qt));
    
    assign clk_out = (en_prescalar) ? muxed_clk : clk;
//    else
//        clk_out = clk;
//    end    
endmodule
