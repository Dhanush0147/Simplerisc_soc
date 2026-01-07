
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2025 20:44:13
// Design Name: 
// Module Name: SPI
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


module SPI(
    input clk,
    input rst,
    input [31:0] PWDATA,
    input PWRITE,
    input PENABLE,
    input PSEL,
    input miso,
    input [10:0] control_reg,
    output reg mosi,
    inout cs,
    output reg interrupt_spi,
    inout sclk,
    //output  [7:0] control_reg_out,
    output reg [10:8] control_reg_out_bo,
    output reg PREADY,
    output  [31:0] PRDATA
    );
    
    // control_reg[0] = cpol ----> idel state
    // control_reg[1] = cpoh ----> sampling edge
    //control_reg [4:2] --------> prescale
    //control_reg[6:5] ------------>
                                     /*
                                         This wll tell how many bits we need to 
                                         write to the slave
                                         00 ----> 8 bits
                                         01 ----> 16 bits
                                         10 ----> 32 bits   
                                                            */
    //control_reg[7] -------> if hign then master mode, if low then slave mode
    //control_reg[8] -------> overflow
    //control_reg[9] -------> buffer_full-1
    //control_reg[10] ------>buffer_full-2
    
    reg [1:0] state;
    
    parameter IDLE = 2'b00;
    parameter ASSIGN_CS = 2'b01;
    parameter TRANSMISSION = 2'b10;
    parameter END = 2'b11;
    
    wire prescale_clk;
    
    prescaler_spi prescaler(
    .prescale(control_reg[4:2]),
    .clk(clk),
    .rst(rst),
    .prescale_clk(prescale_clk)
    );
    
    reg start_command;
    reg phase;// high then do the task done in posedge , low then do the task done in negedge
    reg [31:0] shift_reg;
    reg [4:0] bit_cnt;
    reg [31:0] buffer;
//    reg [31:0] read_buffer;
    reg [31:0] buffer_1,buffer_2;
    
    assign PRDATA = (PENABLE & PSEL & ~PWRITE & PREADY)?( (control_reg[9] & (~control_reg[10])) ?  buffer_1 : buffer_2) : 32'bz;
    
    always@(posedge clk or posedge rst) begin
        if(rst)  begin
            PREADY <= 1;
            start_command <= 0;
        end
    
        else if(state == IDLE) begin
            if(start_command == 0) begin
         /*   if(control_reg[9] | control_reg[10] )
                interrupt_spi <= 1;
            else */
                interrupt_spi<= 0;
                
                PREADY <= 1;
                buffer_1 <= shift_reg;
              
                
                if(PENABLE & PSEL & ~PWRITE & PREADY) begin
                      buffer_2 <= buffer_1;
                    if(control_reg[10])
                        control_reg_out_bo[10] <= 0; 
                    else if (control_reg[9]) begin 
                        control_reg_out_bo[10] <= 0; 
                        control_reg_out_bo[9] <= 0; 
                      end 
                end
                if(PENABLE & PSEL & PWRITE) begin
                    start_command <= 1;
                    buffer <= PWDATA;
                end
            end
            else if(start_command == 1) begin
                PREADY <= 0;
            end
        end
        else if(state == ASSIGN_CS) begin
            PREADY<= 0;
        end
        else if(state == TRANSMISSION) begin
            PREADY <= 0;
        end
        else if (state == END) begin
            start_command <= 0;
            interrupt_spi <= 1;
            if(control_reg[9] == 1) begin
                control_reg_out_bo[8] = 1;
            end
            else begin
                control_reg_out_bo[9] = 1;
                if(control_reg_out_bo[9]) 
                    control_reg_out_bo[10] = 1'b1;
                 else 
                 control_reg_out_bo[10] = 1'b0;
                 
            end
        end
    end
    
    sclk_controller sclk_control(
    .rst(rst),
    .cpol(control_reg[0]),
    .master_slave(control_reg[7]),
    .cpha(control_reg[1]),
    .prescale_clk(prescale_clk),
    .sclk(sclk)
    );
    
    wire start_transfer;
    wire slave_enable;
    
    cs_controller cs_control(
        .rst(rst),
        .prescale_clk(prescale_clk),
        .state(state),
        .master_slave(control_reg[7]),
        .cpha(control_reg[1]),
        .cpol(control_reg[0]),
        .cs(cs),
        .start_transfer(start_transfer),
        .PWRITE(PWRITE),
        .slave_enable(slave_enable)
    );
    
  
  always@(posedge prescale_clk  or  posedge rst) begin
    if(rst) begin
        state <= IDLE;
        phase <= 1'b1;
    end
    else begin 
        phase <= ~phase;
     end
  end 
  
  
  
  always@(posedge prescale_clk) begin
    
    if(phase) begin
        //Here we will do all the work which needs to be done in the pos edge
        case(state)
            IDLE: begin
                if(start_command) begin
                    state <= ASSIGN_CS;
                    shift_reg <= buffer;
                end
                
                if(slave_enable == 1) begin
                    state <= TRANSMISSION;
                end
            end
            
            ASSIGN_CS : begin
                if(start_transfer) begin
                    state <=  TRANSMISSION;
                    bit_cnt <= 0;
                end
            end
            
            TRANSMISSION : begin
                shift_reg <= {shift_reg[30:0],miso};
                bit_cnt <= bit_cnt + 1 ;
                if(bit_cnt == 31) begin
                    state <= END;
                end
            end
            
            END : begin
                state <= IDLE;
            end
            
        endcase
    end
    else begin
        //Here we will do all the work which needs to be done at negedge
        mosi <= shift_reg[31];
    end
  
  end
 
    
endmodule