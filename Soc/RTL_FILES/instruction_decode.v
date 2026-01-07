//-------------------------
// Instruction Decoder
//-------------------------
// Decodes instruction to extract register fields (RS1, RS2, RD, ra).
// Output fields depend on instruction opcode
module instruction_decode(
    input [31:0]instruction,
    input clk,rst,
    output reg [3:0]RS1,RS2,RD,ra
);
always @(*)
begin
        case(instruction[31:27])
        5'b00000,5'b00001,5'b00010,5'b00011,5'b00100,5'b01010,5'b00110,5'b00111,5'b01011,5'b01100,5'b01110,5'b01111 : begin
        /*add, sub, mul, div, mod, and, or, lsl, lsr, asr */                                       RS1 <=instruction[21:18];
                                                                                                   RS2 <=instruction[17:14];
                                                                                                   RD  <=instruction[25:22];
                                                                                                   ra  <=4'd15;
                                                                                                   end
        5'b01101,5'b10100 :begin   RS1 <=4'bx;
        /*nop ,  ret */            RS2 <=4'bx;
                                   RD  <=4'bx;
                                   ra  <=4'd15;
                                   end
       5'b10000,5'b10001,5'b10010,5'b10011 : begin   RS1 <=4'bx;
        /*call,  b,  beq,  bgt*/                     RS2 <=4'bx;
                                                     RD  <=4'bx;
                                                     ra  <=4'd15;
                                                    end
       5'b01000,5'b01001 : begin   RS1 <=4'bx;
        /*not,mov*/                RS2 <=instruction[17:14];
                                   RD  <=instruction[25:22];
                                   ra  <=4'd15;
                                     end
       5'b00101 : begin   RS1 <=instruction[21:18];
        /*cmp*/           RS2 <=instruction[17:14];
                          RD  <=4'bx;
                          ra  <=4'd15;
                                     end
        endcase
        
end
endmodule
