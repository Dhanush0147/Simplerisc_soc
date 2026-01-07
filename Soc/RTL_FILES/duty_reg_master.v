`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2025 16:20:09
// Design Name: 
// Module Name: duty_reg_lower
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


module duty_reg_master(duty_cycle_stored,rst,duty_cycle_in);
input [15:0]duty_cycle_in;
input rst;
output reg [15:0]duty_cycle_stored;

always @* begin
  if (rst)
    duty_cycle_stored <= 16'b0;
  else 
   duty_cycle_stored <= duty_cycle_in;
  
end

endmodule
