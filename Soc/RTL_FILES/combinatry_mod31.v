`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2025 16:25:21
// Design Name: 
// Module Name: combinatory_logic
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



module combinatory_mod31(q0, q1, q2, q3, q4, y0, y1, y2, y3, y4);
    input q0, q1, q2, q3, q4;
    output y0, y1, y2, y3, y4;
    wire q0bar, q1bar, q2bar, q3bar, q4bar;
    wire wrap, carry0, carry1, carry2, carry3, carry4;
    wire y0_temp, y1_temp, y2_temp, y3_temp, y4_temp;

   
    assign q0bar = ~q0;
    assign q1bar = ~q1;
    assign q2bar = ~q2;
    assign q3bar = ~q3;
    assign q4bar = ~q4;

  
    assign wrap = q4 & q3 & q2 & q1 & q0bar;

    
    assign carry0 = 1; 
    assign carry1 = q0 & carry0;
    assign carry2 = q1 & q0 & carry0;
    assign carry3 = q2 & q1 & q0 & carry0;
    assign carry4 = q3 & q2 & q1 & q0 & carry0;

    
    assign y0_temp = q0 ^ carry0;
    assign y1_temp = q1 ^ carry1;
    assign y2_temp = q2 ^ carry2;
    assign y3_temp = q3 ^ carry3;
    assign y4_temp = q4 ^ carry4;

   
    assign y0 = wrap ? 0 : y0_temp;
    assign y1 = wrap ? 0 : y1_temp;
    assign y2 = wrap ? 0 : y2_temp;
    assign y3 = wrap ? 0 : y3_temp;
    assign y4 = wrap ? 0 : y4_temp;
endmodule

