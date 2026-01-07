

module modu31(dout,clk_ext, clk, reset);
    input clk, reset,clk_ext;
    output  dout;
    wire w1;
    wire din, q0, q1, q2, q3, q4, q5, q6, y1, y2, y3, y4;
    combinatory_mod31 c1(.q0(q0), .q1(q1), .q2(q2), .q3(q3), .q4(q4),
                         .y0(din), .y1(y1), .y2(y2), .y3(y3), .y4(y4));
    
    DFF dff0 (clk, din, q0, reset);
    DFF dff1(clk, y1, q1, reset);
    DFF dff2(clk, y2, q2, reset);
    DFF dff3(clk, y3, q3, reset);
    DFF dff4(clk, y4, q4, reset);
    DFF dff5(clk, q4, q5, reset);
    DFF_negedge dff6(clk, q5, q6, reset);
    
    or o1(w1, q4, q5);
    or o2(dout, w1, q6);
endmodule