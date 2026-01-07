`timescale 1ns / 1ps

module freq_div(
    input clk,
    input EN,
    input prescale_0,
    input prescale_1,
    input prescale_2,
    output reg watch_clk
);

    reg [2:0] freq_div_counter;
    wire [2:0] watchdog_control;
    wire clk_in;
    
    assign clk_in = clk & EN;
    assign watchdog_control = {prescale_2, prescale_1, prescale_0};
    
    always @(posedge clk) begin
    if (!EN) 
    begin
        freq_div_counter <= 3'b001;
        watch_clk <= 1'b0;
    end 
    else 
        begin
            if (freq_div_counter < watchdog_control)
                freq_div_counter <= freq_div_counter + 1;
            else 
            begin
                freq_div_counter <= 3'b001;
                watch_clk <= ~watch_clk;
            end
        end
    end
endmodule

