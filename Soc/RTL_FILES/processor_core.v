`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2025 16:45:49
// Design Name: 
// Module Name: processor_core
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


module processor_core(
    input clk,
    input rst,
    input [31:0]proc_rdata,
    input APB_ack,
    output transfer_abp,
    output [31:0]proc_addr,
    output proc_write,
    output [31:0]proc_wdata,
    input ext_clk,
    input write_en,
    input prg_mode,
    input [31:0]instruction,
    input [31:0]dummy_pc,
    output [10:0]I2C_control,
    output [9:0]SPI_CONTROL,
    input interrupt_i2c,
    input interrupt_spi,
    input [1:0]control_reg_bo_spi,
    input UART_RXIF,
    output [7:0]UART_control,
    output [6:0]TIMER_CONTROL,
    input timer_interrupt
    );
    
assign gated_clk = APB_ack && clk;

wire [3:0]rd_write_csr_top,rd_read_csr_top;
wire isWbcsr_top,isRdcsr_top,interrupt_pin_high_top,interrupt_pin_low_top,Iret_top,watchdogrst_top,pc_rst_top; 
wire [31:0]data_in_csr,data_out_csr; 
wire [31:0]int_reg_top; 
wire [3:0]watchdog_control_top;

    
 processor p(
    .clk(gated_clk),
    .rst(rst),
    .rd_write_csr(rd_write_csr_top),
    .rd_read_csr(rd_read_csr_top),
    .isWbcsr(isWbcsr_top),
    .isRdcsr(isRdcsr_top),
    .data_in_csr(data_in_csr),
    .data_out_csr(data_out_csr),
    .Iret(Iret_top),
    .watchdog_rst(watchdogrst_top),
    .interrupt_pin_high(interrupt_pin_high_top),
    .interrupt_pin_low(interrupt_pin_low_top),
    .pc_rst(pc_rst_top),
    .transfer_abp(transfer_abp),
    .proc_addr(proc_addr),
    .proc_write(proc_write),
    .proc_wdata(proc_wdata),
    .proc_rdata(proc_rdata),
    .ext_clk(ext_clk),
    .write_en(write_en),
    .prg_mode(prg_mode),
    .instruction(instruction),
    .dummy_pc(dummy_pc)
    );
    
    
 control_status_register csr(
            .clk(clk),
            .rd_write(rd_write_csr_top),
            .isWbCsr(isWbcsr_top),
            .isRdCsr(isRdcsr_top),
            .data_in(data_in_csr),
            .data_out(data_out_csr),
            .rd_read(rd_read_csr_top),
            .int_reg(int_reg_top),
            .Iret(Iret_top),
            .interrupt_pin_high(interrupt_pin_high_top),
            .interrupt_pin_low(interrupt_pin_low_top),
            .watchdog_control(watchdog_control_top),
            .I2C_control(I2C_control),
            .interrupt_i2c(interrupt_i2c),
            .SPI_CONTROL(SPI_CONTROL),
            .interrupt_spi(interrupt_spi),
            .control_reg_bo_spi(control_reg_bo_spi),
            .UART_RXIF(UART_RXIF),
            .UART_control(UART_control),
            .TIMER_CONTROL(TIMER_CONTROL),
            .timer_interrupt(timer_interrupt)
            );
          
interrupt_controller IC(
         .int_reg(int_reg_top),
         .interrupt_pin_high(interrupt_pin_high_top),
         .interrupt_pin_low(interrupt_pin_low_top)
        );
        
watchdog w(
     .clk(clk),
     .EN(watchdog_control_top[0]),
     .prescale_0(watchdog_control_top[1]),
     .prescale_1(watchdog_control_top[2]),
     .prescale_2(watchdog_control_top[3]),
     .watchdog_rst(watchdogrst_top),
     .pc_rst(pc_rst_top)
    );
endmodule
