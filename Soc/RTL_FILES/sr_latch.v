`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2025 10:16:53
// Design Name: 
// Module Name: sr_latch
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


module sr_latch(pwm_signal,R,S,rst);
input R,S,rst;
output reg pwm_signal;

always @*
begin 
    if(rst==1)
    pwm_signal=1'b0;
    else if(R==1 & S==0)
        pwm_signal <= 1'b0;
    else if(S==1)
        pwm_signal <=1'b1;
    else
        pwm_signal<=pwm_signal;

end

endmodule
