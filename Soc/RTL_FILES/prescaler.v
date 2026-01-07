`timescale 1ns / 1ps

module prescaler_spi(
    input [2:0] prescale,
    input clk,
    input rst,
    output reg sclk
);

    wire tff0_out, tff1_out, tff2_out, tff3_out, tff4_out, tff5_out, tff6_out, tff7_out;

    T_ff tff0 (.clk(clk),       .rst(rst), .Qt(tff0_out));
    T_ff tff1 (.clk(tff0_out),  .rst(rst), .Qt(tff1_out));
    T_ff tff2 (.clk(tff1_out),  .rst(rst), .Qt(tff2_out));
    T_ff tff3 (.clk(tff2_out),  .rst(rst), .Qt(tff3_out));
    T_ff tff4 (.clk(tff3_out),  .rst(rst), .Qt(tff4_out));
    T_ff tff5 (.clk(tff4_out),  .rst(rst), .Qt(tff5_out));
    T_ff tff6 (.clk(tff5_out),  .rst(rst), .Qt(tff6_out));
    T_ff tff7 (.clk(tff6_out),  .rst(rst), .Qt(tff7_out));

    always @(*) begin
        case (prescale)
            3'b000: sclk = tff0_out;
            3'b001: sclk = tff1_out;
            3'b010: sclk = tff2_out;
            3'b011: sclk = tff3_out;
            3'b100: sclk = tff4_out;
            3'b101: sclk = tff5_out;
            3'b110: sclk = tff6_out;
            3'b111: sclk = tff7_out;
            default: sclk = tff0_out;
        endcase
    end

endmodule
