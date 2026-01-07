`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.06.2025 18:27:03
// Design Name: 
// Module Name: SPI_flashcontroller
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


module SPI_flashcontroller(
input  miso,
input clk ,
input reset,
output  reg mosi ,
output  sclk,
output  cs,
output reg [31:0] instruction,
output reg [31:0] dummy_pc,
output reg write_en,
output reg prg_mode
    );
    
reg rst;
reg [6:0]timer;
reg[31:0] data_buffer;
reg [31:0] shift_reg;// hard coded instruction 0x03 - read , 0x000000 starting address
reg [31:0] Dummy_Pc;
reg /*shift_enable,tmr_enable,*/buffer_en,mosi_en,sclk_en,CS;
reg start_hap;
reg [1:0] state ;
localparam[1:0] 
        IDLE = 2'b00,
        START = 2'b01,
        READ = 2'b10,
        END = 2'b11; 
        
assign sclk = clk & sclk_en;
assign cs = CS;
 always@(negedge reset)begin
    rst <= 1'b1;
    state <= IDLE;
 end
 
 
always@(*)begin
    
    case(state)
        IDLE:begin
            CS = 1'b1;
            mosi_en = 1'b0;
            buffer_en = 1'b0;
            sclk_en = 1'b0;
            Dummy_Pc = 32'd0;
            timer = 12'd0;
            prg_mode = 1'b0;
        end
        
        START:begin
            CS = 1'b0;
            sclk_en = 1'b1;
        end
        
        READ:begin
            mosi_en = 1'b0;
        end
        
        END:begin
            CS = 1'b1;
            sclk_en = 1'b0;
            write_en = 1'b0;
        end
        
    endcase
    
end
 
 always@(posedge clk)begin
    if(rst)begin
        case(state)
            IDLE:begin
                state <= START; 
                shift_reg <= 32'h03000001;
                rst <= 1'b0;
                start_hap <= 1'b1;
            end
        endcase
    end
    
    case(state)
            START:begin
                if(timer == 32)begin
                    state <= READ;
                    timer <= 0;
                    
                end
            end
            
            READ:begin
                if(timer == 32)begin
                    timer <= 0;
                end
                else if(timer == 1 && !start_hap)begin
                    write_en <= 1'b0;
                    data_buffer <= shift_reg;
                end
                
                
                if(data_buffer == 32'hffffffff)begin
                    state <= END;
                end
            end
            
        endcase
 end
 
 always@(negedge clk)begin
 
 timer = timer + 1 ;
 
    case(state)
        START:begin
            mosi_en = 1'b1;
            mosi <= shift_reg[31];
            shift_reg <= {shift_reg[30:0],1'b0};
        end
        
        READ:begin
            shift_reg <= {shift_reg[30:0],miso};
            if(timer == 2 && !start_hap && shift_reg != 32'hffffffff)begin
                    instruction <= data_buffer;
                    dummy_pc <= Dummy_Pc;
                    Dummy_Pc <= Dummy_Pc + 1;
                    write_en <= 1'b1;
                end
            else if(timer == 2 && start_hap) begin
                start_hap <= 1'b0;
            end
        end
        END:begin
            prg_mode = 1'b1;
        end
    endcase
 end
 
endmodule
