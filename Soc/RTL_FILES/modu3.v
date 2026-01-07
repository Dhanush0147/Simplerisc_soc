
module modu3(clk_out, rst,clk_in);
    input rst, clk_in;
    output clk_out;
    wire y1, y2, q0bar, q1bar, q0, q1, q2, din;
    assign q0bar = ~q0;
    assign y1 = q0;
    assign y2 = q1;
    assign q1bar = ~q1;
    
    and a1(din, q0bar, q1bar);
    DFF d1(clk_in, din, q0, rst);
    DFF d2(clk_in, y1, q1, rst);
    DFF_negedge d3(clk_in, y2, q2, rst);
    or o1(clk_out, q1, q2); 
endmodule
