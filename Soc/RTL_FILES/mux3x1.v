module mux3x1 (   
 input  [31:0] in0,   // Input 0
    input  [31:0] in1,   // Input 1
    input  [31:0] in2,   // Input 2
    input  [1:0]  sel,   // 2-bit select signal
    output [31:0] out
    );


assign out = (sel == 2'b00) ? in0 :
             (sel == 2'b01) ? in1 :
             (sel == 2'b10) ? in2 :
             32'b0; // Default: output 0 if sel is invalid (i.e., 2'b11)

endmodule

