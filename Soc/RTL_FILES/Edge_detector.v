`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 18:40:13
// Design Name: 
// Module Name: Edge_Detector
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


// this will detect the high to low transition 

module Edge_Detector (
    input wire clk,           
    input wire rst,
    input wire shift_done,
    input wire serial_in,           
    output reg st_bit_detected
);



    always @(posedge clk or posedge rst) begin
        if (rst) begin
             
            st_bit_detected <= 0;
        end else begin
 
                                                
            if (serial_in == 1'b0)            
                st_bit_detected <= 1;
            else if(shift_done)begin
                st_bit_detected <= 0;
            end
        end
    end
endmodule



