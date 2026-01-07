`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2025 15:10:10
// Design Name: 
// Module Name: Timer
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


module Timer(
input ext_clk, int_clk, rst , PWRITE,  P_EN, P_SEL,
input [6:0] TMCON,
input [15:0] PWDATA,
output reg  PREADY,
output reg int_flag
);


//TMCON[6] = timer on = 1, off= 0;
//TMCON[5] = clock source selection 0 for internal, 1 for external;
// TMCON[4] =  0 (low to high) ; 1 (high  to low)  edge selection;
//TMCON [3] = enable_prescaler when it is 1, 0 for disable;
//TMCON[2:0]= PRESCALE_VALUE;

wire ext_clk_f;
wire muxed_clk;
wire clock;
reg [15:0] timer ;
reg rollover;
 

 
xor x1(ext_clk_f, ext_clk, TMCON[4]);

assign muxed_clk = TMCON[5] ? ext_clk_f : int_clk;


prescaler_timer prescaled_clk (
             .clk_out (clock),
             .clk(muxed_clk),
             .rst(rst),
             .prescale_value(TMCON[2:0]),
             .en_prescaler(TMCON[3])
               );

 always @(posedge clock or posedge rst) begin
        if (rst) begin
            timer     <= 16'd0;
            rollover  <= 1'b0;
            int_flag  <= 1'b0;
            PREADY    <= 1'b0;

        end
        else if (P_EN && PWRITE && P_SEL) begin
            
            timer     <= PWDATA;                                                           
            rollover  <= 1'b0;                                                             
            int_flag  <= 1'b0;
            PREADY    <= 1'b1;
        end
        else if(TMCON[6] && int_flag == 0)  begin
           
           rollover <= ((timer + 16'd1) == 16'd0);
           int_flag <= ((timer + 16'd1) == 16'd0);
           timer    <= timer + 16'd1;  
           PREADY    <= 1'b0;
           end  
        else if(int_flag) 
            int_flag <= 0;                                                

        
    end

endmodule

