`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 09:00:41
// Design Name: 
// Module Name: active_low_buffer
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

module act_low_buffer(in, out, enable);
    input in, enable;
    output   out;
  //  reg out;
    assign out = (~enable) ? in: 1'bz;
/*   always @(**//*in or enable*//*)
    begin
        if(enable)
            out = 1'bz;
        else
            out = in;
    end
    */
endmodule
