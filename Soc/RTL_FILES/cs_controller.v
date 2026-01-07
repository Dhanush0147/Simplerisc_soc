`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 21:08:08
// Design Name: 
// Module Name: cs_controller
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


module cs_controller(
    input rst,
    input prescale_clk,
    input PWRITE,
    input phase,
    input [1:0] state,
    input master_slave,
    input cpha,
    input cpol,
    inout cs,
    output reg slave_enable,
    output reg start_transfer
    );
    
    reg cs_out;
    reg [2:0] cnt_clk;
    assign cs = (master_slave)? cs_out : 1'bz;
    
    always@(cs) begin
        if(state == 2'b00 & master_slave == 0 & cs == 0) begin
            slave_enable <=  1;
        end
        
        if(cs == 1 & master_slave == 0) begin
            slave_enable <= 0;
        end
    end
    
    always@(negedge prescale_clk) begin
        if(state == 2'b01) begin
            if(cpha == 0 & cpol == 0) begin
                if(cnt_clk == 1) begin
                    cs_out <= 0;
                    start_transfer <= 1;
                end
            end
            
            if(cpha == 1 & cpol == 1) begin
                if(cnt_clk == 3) begin
                    start_transfer <= 1;
                end
            end
            
            if(cpha == 0 & cpol == 1) begin
                if(cnt_clk == 1) begin
                    cs_out <= 0;
                    start_transfer <= 1;
                end
            end
            
            if(cpha == 1 & cpol == 0) begin
                if(cnt_clk == 1) begin
                    start_transfer <= 1;
                end
                
            end
           
        end
        
        if(state == 2'b10) begin
            if(cpha == 1 & cpol == 1) begin
                    cs_out <= 0;
            end
            
            if(cpha == 1 & cpol == 0) begin
                    cs_out <= 0;
            end
            
        end
        
        if(state == 2'b00) begin
            cs_out <= 1;
            start_transfer <= 0;
        end
        
        if(state == 2'b11) begin
            cs_out <= 1;
            start_transfer <= 0;
        end
    end
    
    always@(posedge rst) begin
        cs_out <= 1;
        cnt_clk <= 0;
    end
    
    always@(posedge prescale_clk ) begin
        
        if(~start_transfer) begin
            if(state == 2'b01) begin
                cnt_clk <= cnt_clk + 1;
            end
        end
        else begin
            cnt_clk <= 0 ;
        end
        
    end 
    
endmodule
