//-------------------------
// 2:1 Multiplexer (32-bit)
//-------------------------
// Selects between two 32-bit inputs based on 'sel'.
// If rst is asserted, output is zero.
module mux2x1( 
    input [31:0]x,z,
    input sel,rst,
    output [31:0]y
  );
assign y = ( rst )? 0 :
            (sel == 0)? x : z;
endmodule
