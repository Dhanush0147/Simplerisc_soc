`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2025 14:28:29
// Design Name: 
// Module Name: memory
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


module memory(
    input [31:0] PADDR,
    inout  [31:0] BUS,
    input we,
    input clk,
    input PENABLE
    );
     reg [31:0] mem [100:0];
     reg [31:0] rdata;
     assign BUS = (~we)?rdata : 32'bz;
     initial begin
     /*   mem[0]  = 0;*/
        //mem[1]  = 8;
 /*       mem[2]  = 4;
        mem[3]  = 6;
        mem[4]  = 2;
        mem[5]  = 3;
        mem[6]  = 9;
        mem[7]  = 10;
        mem[8]  = 22;
        mem[9]  = 7;
        mem[10] = 8;
        mem[11] = 11;
        mem[12] = 13;
        mem[13] = 15;
        mem[14] = 20;
        mem[15] = 1;
        mem[16] = 10;
        mem[17] = 22;
        mem[18] = 7;
        mem[19] = 8;
        mem[20] = 11;
        mem[21] = 13;
        mem[22] = 15;
        mem[23] = 20;
        mem[24] = 1;
        mem[25] = 1;*/
    end
     always@(posedge clk)
     begin 
     if(PENABLE) begin 
        if(we)
            mem[PADDR]<=BUS;
        else 
            rdata<= mem[PADDR];
     end 
    end 
endmodule

