//-------------------------
// Immediate Generator
//-------------------------
// Generates sign-extended immediate and branch target address from instruction.
module immediate_generator(
    input [31:0]pc,instruction,
    input isWbCsr,isCall,
    output reg [31:0]immx,branch_target
);

always @(*)
begin
    if(isCall)
        branch_target <=  ({{5{instruction[26]}}, instruction[26:0]} << 0); 
    else
        branch_target <= pc + ({{5{instruction[26]}}, instruction[26:0]} << 0);
    case(instruction[17:16])
    2'b01   : immx <= {16'b0, instruction[15:0]};
    2'b10   : begin 
                    if(isWbCsr & instruction[18]) 
                        immx <= {instruction[15:0],{16{1'b1}}}; 
                    else
                        immx <= instruction[15:0] << 16 ;
              end
    2'b00 : begin 
                if(isWbCsr & instruction[18])
                    immx <= {{16{1'b1}},instruction[15:0]};  
                else
                    immx <= {{16{instruction[15]}},instruction[15:0]}; 
            end
    default : immx <= {16'b0, instruction[15:0]}; 
    endcase
end
endmodule
