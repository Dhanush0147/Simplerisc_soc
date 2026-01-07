`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2025 08:44:22
// Design Name: 
// Module Name: duty_reg2
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


module duty_slave(duty_cycle_out,clk,rst,duty_cycle_stored,rollover);
input clk,rst,rollover;
input [15:0]duty_cycle_stored;
output reg [15:0]duty_cycle_out;

always @(posedge clk or posedge rst) begin
  if (rst)
    duty_cycle_out <= 16'b0;
  else if (rollover)
    duty_cycle_out <= duty_cycle_stored;    // reload here, on the SAME posedge as rollover
  else
    duty_cycle_out <= duty_cycle_out;   // otherwise hold
end

endmodule
