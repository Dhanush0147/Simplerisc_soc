`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2025 16:53:17
// Design Name: 
// Module Name: watchdog
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


module watchdog(
    input clk,
    input EN,
    input prescale_0,
    input prescale_1,
    input prescale_2,
    input watchdog_rst,
    output reg pc_rst
    );
    
    wire watch_clk;
    reg [11:0] counter;
    freq_div freq_div(
        .clk(clk),
        .EN(EN),
        .prescale_0(prescale_0),
        .prescale_1(prescale_1),
        .prescale_2(prescale_2),
        .watch_clk(watch_clk)
    );
    initial 
    begin
        counter =0;
    end 
    
    always @(posedge watch_clk or posedge watchdog_rst)
    begin
        if (watchdog_rst)
        begin
            counter <= 12'd0;
            pc_rst <= 1'b0;
        end
        else if (counter < 12'b111111111111)
        begin
            counter <= counter + 1;
            pc_rst <= 1'b0;
        end
        else
        begin   
            pc_rst <= 1'b1;
            counter <= 12'd0;
        end
    end
endmodule


