`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2025 12:00:13
// Design Name: 
// Module Name: RCREG
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


module RCREG (
input wire clk,
input wire rst,
input wire stop_valid,
input wire [7:0] data_in,
input wire read_en,           
         
output wire [7:0] data_out,
output reg RXIF                
);

reg [7:0] RCREG;
reg loaded;

always @(posedge clk or posedge rst) begin
if (rst) begin
RCREG <= 8'd0;
RXIF <= 1'b0;
loaded <= 1'b0;
 
end
else if (read_en) begin
   RXIF <= 1'b0;
   loaded <= 1'b0;
end
end


always@(posedge stop_valid)begin
if (!loaded ) begin
RCREG <= data_in;
RXIF <= 1'b1;
loaded <= 1'b1;
end
end
assign data_out = (read_en) ? RCREG : 8'bz;
endmodule