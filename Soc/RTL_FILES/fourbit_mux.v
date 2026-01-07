`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 18:17:36
// Design Name: 
// Module Name: fourbit_mux
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


module fourbit_mux(clk_out,prescale_value,Qt);
    input [4:0]prescale_value;
    input [31:0]Qt;
    output clk_out;
    
    assign clk_out = Qt[prescale_value]; 

endmodule
