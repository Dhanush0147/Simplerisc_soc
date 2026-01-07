`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 18:38:10
// Design Name: 
// Module Name: baudrate_gen_rx
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



module baudrate_gen_rx(clk,rst,baud_out,EN_50MHz);
    
input wire clk,rst,EN_50MHz; // this EN_100MHz is the control bit 
output wire baud_out;

wire clk_out_top3_mux;
wire clk_out_top1,clk_out_top2,clk_out_top3,clk_out_top4,clk_out_top5,clk_out_top6,clk_out_top7;
modu3 modu3 (.clk_in(clk),.rst(rst),.clk_out(clk_out_top1));

modu2 modu2_1(.clk_in(clk_out_top1),.rst(rst),.clk_out(clk_out_top2));
modu2 modu2_2(.clk_in(clk_out_top2),.rst(rst),.clk_out(clk_out_top3));  // eliminating this modulo 2 for 50MHz
modu2 modu2_3(.clk_in(clk_out_top3_mux),.rst(rst),.clk_out(clk_out_top4));

modu2 modu2_4(.clk_in(clk_out_top4),.rst(rst),.clk_out(clk_out_top5));

modu7 modu7_1(.clk_in(clk_out_top5),.clk_ext(clk),.rst(rst),.clk_out(clk_out_top6));

modu31 modu31(.clk(clk_out_top6),.clk_ext(clk),.reset(rst),.dout(baud_out));



assign clk_out_top3_mux = (EN_50MHz) ? clk_out_top2 : clk_out_top3;
endmodule
 

