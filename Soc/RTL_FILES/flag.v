//-------------------------
// Flag Extraction Module
//-------------------------
// Extracts GT and EQ flags if instruction is CMP.
module flag(
    input Iret,rst,isRdcsr,
    input [1:0]flags_in,flags_out_reg,csr_flag,
    input [4:0]isCMP,
    output reg GT_flag,
    output reg EQ_flag
);

always @(*)
begin
    /*if(rst)
    begin
        GT_flag <= 1'b0 ;
        EQ_flag <= 1'b0; 
    end*/
    if(isCMP == 5'b00101)
    begin
         GT_flag = flags_in[1] ;
         EQ_flag = flags_in[0];
    end
    else if(isRdcsr)
    begin
         GT_flag <= csr_flag ;
         EQ_flag <= ~csr_flag;
    end
    else if(Iret)
    begin
        GT_flag <= flags_out_reg[1] ;
        EQ_flag <= flags_out_reg[0];
    
    end
    else
    begin
        GT_flag <= GT_flag ; // Else retain previous values
        EQ_flag <= EQ_flag;   
    end
    
end
 endmodule   
    

