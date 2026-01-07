`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 17:36:14
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
    output  [31:0]Qt;
    input clk,rst;
    
    T_ff tff0(.Qt(Qt[0]),.clk(clk),.rst(rst));
    T_ff tff1(.Qt(Qt[1]),.clk(~Qt[0]),.rst(rst));
    T_ff tff2(.Qt(Qt[2]),.clk(~Qt[1]),.rst(rst));
    T_ff tff3(.Qt(Qt[3]),.clk(~Qt[2]),.rst(rst));
    T_ff tff4(.Qt(Qt[4]),.clk(~Qt[3]),.rst(rst));
    T_ff tff5(.Qt(Qt[5]),.clk(~Qt[4]),.rst(rst));
    T_ff tff6(.Qt(Qt[6]),.clk(~Qt[5]),.rst(rst));
    T_ff tff7(.Qt(Qt[7]),.clk(~Qt[6]),.rst(rst));
    T_ff tff8(.Qt(Qt[8]),.clk(~Qt[7]),.rst(rst));
    T_ff tff9(.Qt(Qt[9]),.clk(~Qt[8]),.rst(rst));
    T_ff tff10(.Qt(Qt[10]),.clk(~Qt[9]),.rst(rst));
    T_ff tff11(.Qt(Qt[11]),.clk(~Qt[10]),.rst(rst));
    T_ff tff12(.Qt(Qt[12]),.clk(~Qt[11]),.rst(rst));
    T_ff tff13(.Qt(Qt[13]),.clk(~Qt[12]),.rst(rst));
    T_ff tff14(.Qt(Qt[14]),.clk(~Qt[13]),.rst(rst));
    T_ff tff15(.Qt(Qt[15]),.clk(~Qt[14]),.rst(rst));
    T_ff tff16(.Qt(Qt[16]),.clk(~Qt[15]),.rst(rst));
    T_ff tff17(.Qt(Qt[17]),.clk(~Qt[16]),.rst(rst));
    T_ff tff18(.Qt(Qt[18]),.clk(~Qt[17]),.rst(rst));
    T_ff tff19(.Qt(Qt[19]),.clk(~Qt[18]),.rst(rst));
    T_ff tff20(.Qt(Qt[20]),.clk(~Qt[19]),.rst(rst));
    T_ff tff21(.Qt(Qt[21]),.clk(~Qt[20]),.rst(rst));
    T_ff tff22(.Qt(Qt[22]),.clk(~Qt[21]),.rst(rst));
    T_ff tff23(.Qt(Qt[23]),.clk(~Qt[22]),.rst(rst));
    T_ff tff24(.Qt(Qt[24]),.clk(~Qt[23]),.rst(rst));
    T_ff tff25(.Qt(Qt[25]),.clk(~Qt[24]),.rst(rst));
    T_ff tff26(.Qt(Qt[26]),.clk(~Qt[25]),.rst(rst));
    T_ff tff27(.Qt(Qt[27]),.clk(~Qt[26]),.rst(rst));
    T_ff tff28(.Qt(Qt[28]),.clk(~Qt[27]),.rst(rst));
    T_ff tff29(.Qt(Qt[29]),.clk(~Qt[28]),.rst(rst));
    T_ff tff30(.Qt(Qt[30]),.clk(~Qt[29]),.rst(rst));
    T_ff tff31(.Qt(Qt[31]),.clk(~Qt[30]),.rst(rst));   
    
endmodule
