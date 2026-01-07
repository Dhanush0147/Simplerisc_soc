module mux2x1_4bit(
    input [3:0]x,z,
    input sel,rst,
    output [3:0]y
);
 
assign y = ( rst )? 0 : 
            (sel == 0)? x : z;
endmodule



