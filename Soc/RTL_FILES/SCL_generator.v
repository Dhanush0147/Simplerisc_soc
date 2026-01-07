`timescale 1ns / 1ps


module SCL_Generator(
    input rst,
    input clk,
    input scl_en,
    input [8:0] prescale,
    input [2:0] state,
    output reg scl
    );
    
    reg [8:0] clk_count;
    
    always @(posedge clk or posedge rst) 
    begin
        if(rst /*|| state == 3'b000*/ || state == 3'b001 || (~scl_en) ) 
        begin
            clk_count <= 0;
            scl <= 1;
        end
        else begin
            if(clk_count == prescale) 
            begin
                clk_count <= 0;
                scl <= ~scl;
            end
            else begin
                clk_count <= clk_count + 1;
            end
        end
    end
    
    
endmodule
