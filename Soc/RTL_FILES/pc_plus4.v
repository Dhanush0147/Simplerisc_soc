//-------------------------
// PC + 4 Adder
//-------------------------
module pc_plus4(
    input [31:0] pc,
    input clk,
    output reg [31:0] pcplus4
);
always @(posedge clk)
begin
    pcplus4 = pc + 1; // Computes pcplus4 = pc + 4 (next sequential instruction)
end
endmodule
