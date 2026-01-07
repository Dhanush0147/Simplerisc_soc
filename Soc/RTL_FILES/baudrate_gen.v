`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2025 15:47:35
// Design Name: 
// Module Name: baudrate_gen
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



module baudrate_gen(
        input wire clk,rst,EN_50MHz, // this EN_100MHz is the control bit 
        input wire [1:0] baud_sel,
        output wire baud_100MHz
);
wire clk_out_top3_mux,clk_out_top1_mux,clk_out_top2_mux,clk_out_top4_mux,clk_out_top5_mux;
wire clk_out_top1,clk_out_top2,clk_out_top3;
wire clk_out_top4,clk_out_top5,clk_out_top6,clk_out_top7;
modu3 modu3 (
        .clk_in(clk),
        .rst(rst),
        .clk_out(clk_out_top1)
        );
modu2 modu2_1(
        .clk_in(clk_out_top1_mux),
        .rst(rst),
        .clk_out(clk_out_top2)
        );
modu2 modu2_2(
        .clk_in(clk_out_top2_mux),
        .rst(rst),
        .clk_out(clk_out_top3)
        );  // eliminating this modulo 2 for 50MHz
modu2 modu2_3(
        .clk_in(clk_out_top3_mux),
        .rst(rst),
        .clk_out(clk_out_top4)
        );
modu2 modu2_4(
        .clk_in(clk_out_top4_mux),
        .rst(rst),
        .clk_out(clk_out_top5)
        );
modu7 modu7_1(
        .clk_in(clk_out_top5),
        .clk_ext(clk),
        .rst(rst),
        .clk_out(clk_out_top6)
        );

modu31 modu31(
        .clk(clk_out_top6),
        .clk_ext(clk),
        .reset(rst),
        .dout(baud_100MHz)
        );


assign clk_out_top3_mux = (EN_50MHz) ? clk_out_top2_mux : clk_out_top3;

assign clk_out_top1_mux =
    (baud_sel == 2'b00) ? clk_out_top1 :           // 9600
    (baud_sel == 2'b01) ? clk_out_top1 :           // 19200
    (baud_sel == 2'b10) ? clk :                    // 57600            //for 57600 removed the mod3
                          clk ;                     // 115200          // for 115200 removed the mod3
    

assign clk_out_top2_mux =
    (baud_sel == 2'b00) ? clk_out_top2 :                // 9600
    (baud_sel == 2'b01) ? clk_out_top1_mux :           // 19200    // for 19200  and 115200 removed the mod 2
    (baud_sel == 2'b10) ? clk_out_top2 :           // 57600        
                          clk_out_top1_mux ;           // 115200    
    
assign clk_out_top4_mux = 
    (baud_sel == 2'b00) ? clk_out_top4 :           // 9600        // for 115200 removed mod 2 
    (baud_sel == 2'b01) ? clk_out_top4 :           // 19200      
    (baud_sel == 2'b10) ? clk_out_top3_mux :           // 57600
                          clk_out_top3_mux ;       // 115200
    
//assign clk_out_top5_mux = (baud_sel == 2'b11)? clk_out_top4_mux : clk_out_top5; 

endmodule



