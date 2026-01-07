`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.06.2025 16:36:17
// Design Name: 
// Module Name: instruction_mem_new
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


module instruction_mem_new(
        input [31:0] address_pointer,
        inout [31:0] BUS,
        input prg_mode,
        input clk_input,
        input we
    );
    
     reg [31:0] mem [150:0];
     reg [31:0] rdata;
     assign BUS = (prg_mode)?rdata : 32'bz;
     
    /* initial begin
        mem[0]  = 0;
        mem[1]  = 8;
        mem[2]  = 4;
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
        mem[25] = 1;
    end*/
     always@(posedge clk_input)
     begin 
     
        if(~prg_mode)begin
        if(we)
            mem[address_pointer] <= BUS;
        end
        else begin
            rdata <= mem[address_pointer];
        end
     end
    
    
endmodule
