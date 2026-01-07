///////////////////////////////////////////////////////////////////////////////
// Program Counter Module
///////////////////////////////////////////////////////////////////////////////
// Holds the current program counter value.
// Updates to pcnext on clock edge, resets to 0 on rst
module program_counter(
    input [31:0]pcnext,
    input interrupt,pc_rst,
    input [31:0]pc_isr,
    input clk,rst,
    output reg [31:0]pc
);
always@(negedge clk or posedge rst )
begin
    if(rst | pc_rst)
        begin
            pc <= 32'd0; //64
        end
     else if(interrupt)
     begin
        pc <= pc_isr;   
     end
     
    else
        begin
            pc <= pcnext;   
        end
end

    
endmodule
