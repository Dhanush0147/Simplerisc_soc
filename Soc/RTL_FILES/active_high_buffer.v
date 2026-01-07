`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.06.2025 18:34:44
// Design Name: 
// Module Name: active_high_buffer
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


module active_high_buffer(in, out, enable);
    input in, enable;
    output  out;
 
    assign out = enable ? in : 1'bz;
/*    always @(**//*in or enable*//*)
    begin
        if(enable)
            out = in;
        else
            out = 1'bz;
    end  */   
endmodule
   

