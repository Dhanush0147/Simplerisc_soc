`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2025 11:36:54
// Design Name: 
// Module Name: checking_stop_bit
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



module checking_stop_bit(
    input wire clk,
    input wire rst,
    input wire serial_in,
    input wire shift_done,
    input wire ext_clk,
    output wire fram_err,
    output wire stop_valid,
    output reg pullup_en
);

    // Direct combinational evaluation
    
  
   assign stop_valid = shift_done && serial_in & (~pullup_en);
    always @(*) 
        begin 
            if(shift_done &(~stop_valid)) begin 
                pullup_en <= 1'b1;
                end 
             else 
                 pullup_en <= 1'b0;
         end      
    assign fram_err   = shift_done && ~stop_valid;



endmodule

