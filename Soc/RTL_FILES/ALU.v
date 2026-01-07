///////////////////////////////////////////////////////////////////////////////
// Arithmetic Logic Unit (ALU)
///////////////////////////////////////////////////////////////////////////////
// Supports 13 operations:
// 00000 - Add       01010 - Logical Shift Left
// 00001 - Subtract   01011 - Logical Shift Right
// 00010 - Multiply   01100 - Arithmetic Shift Right
// 00011 - Divide     01101 - NOP
// 00100 - Modulo     01110 - Load
// 00101 - Compare    01111 - Store
// 00110 - AND
// 00111 - OR
// 01000 - NOT
// 01001 - Move
module ALU(
    input [31:0]a,b,
    input [13:0]alusignals,
    output reg [31:0]result,
    output reg [1:0]flags//flag[1] = gt flag, flag[0] = eq flag
);





always @(*)
begin
    case(alusignals[13:9])
    5'b00000 , 5'b01111,5'b01110: begin flags <= 2'b00; result = a+b; end  //add
    5'b00001: begin flags <= 2'b00; result = a-b; end //sub
    5'b00010: begin flags <= 2'b00; result = a * b; end //mul
    5'b00011: begin flags <= 2'b00; result = a/b; end //div
    5'b00100: begin flags <= 2'b00; result = a % b; end //mod
    5'b00101: begin if(a==b)
                         flags <= 2'b01;
                     else if(a>b) 
                         flags <= 2'b10;
                     else 
                         flags <= 2'b00;
                      result = 0; 
                         end
    5'b00110 : begin flags <= 2'b00; result = a & b ; end //and
    5'b00111 : begin flags <= 2'b00; result =  a| b ; end  //or
    5'b01000 : begin flags <= 2'b00; result = ~a ; end //not
    5'b01001: begin  
                if (alusignals[1])
                    begin flags <= 2'b0; result = a | b; end //set_csr  
                else if (alusignals[0])
                    begin flags <= 2'b0; result = a & b; end //clear_csr
                else if (alusignals[2])
                    begin flags <= 2'b0; result = a >> b; end //read csr
                else   
                    begin flags <= 2'b0; result = b; end //mov
                end
    5'b01010: begin flags <= 2'b00; result = a << b; end //lsl
    5'b01011: begin flags <= 2'b00; result = a>> b; end  //lsr
    5'b01100: begin flags <= 2'b00; result = a >>> b; end //asr
    default : begin flags <= 2'b00; result = result; end
    endcase
end
endmodule
