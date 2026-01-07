`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025 15:15:24
// Design Name: 
// Module Name: prescaler
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


module prescaler_timer(clk_out,clk,rst,prescale_value,en_prescaler);
    input clk,rst,en_prescaler;
    input [2:0] prescale_value;
    output clk_out;
    wire [7:0] Qt;
    wire muxed_clk;
    wire gated_clk;
    
    and And ( gated_clk, clk, en_prescaler );
    T_FF_freq_div tffs(.Qt(Qt),.clk(gated_clk),.rst(rst));
    //fourbit_mux mux4(.clk_out(muxed_clk),.prescale_value(prescale_value),.Qt(Qt));
    
    assign muxed_clk = Qt[prescale_value]; 
    
    assign clk_out = (en_prescaler) ? muxed_clk : clk;
  
endmodule