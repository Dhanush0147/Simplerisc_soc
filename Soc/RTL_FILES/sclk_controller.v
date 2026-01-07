`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 20:31:52
// Design Name: 
// Module Name: sclk_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sclk_controller(
    input rst,
    input cpol,
    input master_slave,
    input cpha,
    input prescale_clk,
    inout sclk
    );
    
    reg clock;//This clock will have half the frequency of the prescaled clock
    reg edge_selector;
    
    always@(*) begin
        edge_selector = cpha ^ cpol;
    end
    
    always@(posedge prescale_clk or posedge rst) begin
        if(rst) begin
            clock <= 0;
        end
        else begin
            clock <= ~ clock;
        end
    end
    
    assign sclk = (master_slave) ? (clock ^ edge_selector) : 1'bz;
    
endmodule
