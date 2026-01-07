
module SOC(
    input clk_top,
    input reset,
    input miso,
    input miso_spi,
    output mosi,
    output mosi_spi,
    output sclk,
    output cs,
    inout cs_spi,
    inout Pin_1 , Pin_2 , Pin_3, Pin_4,Pin_5,Pin_6 , Pin_7 , Pin_8,Pin_9,Pin_10,Pin_11,Pin_12,Pin_13,Pin_14,Pin_15,Pin_16,
    output SCL,
    inout sclk_spi,
    inout SDA,
    input RX,
    output TX
 );
 wire preset_top,APB_ack_top,PWRITE_top,PENABLE_top,PREADY_top,PSEL_mem_top,PSEL_pwm_top,write_en_top,prg_mode_top,PSEL_gpio_top;
 wire transfer_abp_top,proc_write_top;
 wire PSEL_i2c_top,interrupt_i2c_top;
 wire PSEL_spi_top,interrupt_spi_top;
 wire [9:0]SPI_CONTROL_top;
 wire [1:0]control_reg_out_spi_top;
 wire [31:0]proc_addr_top,proc_wdata_top,proc_rdata_top,PADDR_top,PWDATA_top,PRDATA_top,instruction_top,dummy_pc_top;
 wire clk;
 reg rst;
 wire [10:0]I2C_control_top;
 wire UART_RXIF_top,PSEL_uart_top;
 wire [7:0]UART_control_top;
 
 wire PSEL_timer_top,PREADY_TIMER_top,timer_interrupt_top;
 wire [6:0]TIMER_CONTROL_top;
 
 wire PREADY_PWM_top,PREADY_MEM_top,PREADY_GPIO_top,PREADY_I2C_top,PREADY_SPI_top,PREADY_UART_top;
 assign PREADY_top = (PSEL_mem_top)  ? PREADY_MEM_top  :
                     (PSEL_pwm_top)  ? PREADY_PWM_top  :
                     (PSEL_gpio_top) ? PREADY_GPIO_top :
                     //(PSEL_i2c_top)  ? PREADY_I2C_top  :
                     (PSEL_spi_top)  ? PREADY_SPI_top  : 
                     (PSEL_uart_top) ? PREADY_UART_top : 
                     (PSEL_timer_top)? PREADY_TIMER_top : 1'b0 ;
                     
                        
 always @( negedge clk_top) 
    begin 
        begin 
            rst <= 0;
        end 
     end 
    
 always @(posedge prg_mode_top) 
    begin 
        begin 
            rst  <= 1'b1;
         end
     end
 assign clk = prg_mode_top && clk_top;
 assign preset_top = ~rst;  
 processor_core pcore(
        .clk(clk),
        .rst(rst), //to be changed
        .transfer_abp(transfer_abp_top),
        .proc_addr(proc_addr_top),
        .proc_write(proc_write_top),
        .proc_wdata(proc_wdata_top),
        .proc_rdata(proc_rdata_top),
        .APB_ack(APB_ack_top),
        .ext_clk(clk_top),
        .write_en(write_en_top),
        .prg_mode(prg_mode_top),
        .instruction(instruction_top),
        .dummy_pc(dummy_pc_top),
        .I2C_control(I2C_control_top),
        .SPI_CONTROL(SPI_CONTROL_top),
        .interrupt_i2c(interrupt_i2c_top),
        .interrupt_spi(interrupt_spi_top),
        .control_reg_bo_spi(control_reg_out_spi_top),
        .UART_RXIF(UART_RXIF_top),
        .UART_control(UART_control_top),
        .TIMER_CONTROL(TIMER_CONTROL_top),
        .timer_interrupt(timer_interrupt_top)
    );
    
APB_Master APBM(
       .PCLK(clk_top),
       .PRESETn(preset_top),     
       .addr_CPU(proc_addr_top),
       .wdata_CPU(proc_wdata_top),
       .write_CPU(proc_write_top),
       .transfer(transfer_abp_top),
       .CPU_rdata(proc_rdata_top),
       .APB_ack(APB_ack_top),
       .PADDR(PADDR_top),
       .PWRITE(PWRITE_top),
       .PWDATA(PWDATA_top),
       .PENABLE(PENABLE_top),
       .state(),
       .PRDATA(PRDATA_top),
       .PREADY(PREADY_top),
       .PSLVERR(),
       .PSEL_gpio(PSEL_gpio_top),
       .PSEL_uart(PSEL_uart_top), 
       .PSEL_pwm(PSEL_pwm_top), 
       .PSEL_i2c(PSEL_i2c_top),
       .PSEL_spi(PSEL_spi_top), 
       .PSEL_timer(PSEL_timer_top), 
       .PSEL_periph6(),
       .PSEL_mem(PSEL_mem_top)
);

MEM_SLAVE slave0(
             .PCLK(clk_top),
             .PRESETn(preset_top),
             .PADDR(PADDR_top),
             .PSEL(PSEL_mem_top),
             .PENABLE(PENABLE_top),
             .PWRITE(PWRITE_top),
             .PWDATA(PWDATA_top),
             .PRDATA(PRDATA_top),
             .PREADY(PREADY_MEM_top),
             .PSLVERR()
);

PWM_SLAVE slave1(
            .PCLK(clk_top),
            .PRESETn(rst),
            .PADDR(PADDR_top),
            .PSEL_pwm(PSEL_pwm_top),
            .PENABLE(PENABLE_top),
            .PWRITE(PWRITE_top),
            .PWDATA(PWDATA_top),
            .PREADY(PREADY_PWM_top),
            .PSLVERR()
);

GPIO_SLAVE slave2(
            .PCLK(clk_top),
            .PRESETn(rst),
            .PADDR(PADDR_top),
            .PSEL(PSEL_gpio_top),
            .PENABLE(PENABLE_top),
            .PWRITE(PWRITE_top),
            .PWDATA(PWDATA_top),
            .PRDATA(PRDATA_top),
            .PREADY(PREADY_GPIO_top),
            .PSLVERR(),
            .Pin_1(Pin_1), 
            .Pin_2(Pin_2) , 
            .Pin_3(Pin_3),
            .Pin_4(Pin_4),
            .Pin_5(Pin_5),
            .Pin_6(Pin_6) ,
            .Pin_7(Pin_7),
            .Pin_8(Pin_8),
            .Pin_9(Pin_9),
            .Pin_10(Pin_10),
            .Pin_11(Pin_11),
            .Pin_12(Pin_12),
            .Pin_13(Pin_13),
            .Pin_14(Pin_14),
            .Pin_15(Pin_15),
            .Pin_16(Pin_16)
);

/*I2C_SLAVE slave3(
    .PCLK(clk_top),
    .PRESETn(rst),
    .PADDR(PADDR_top),
    .PSEL(PSEL_i2c_top),
    .PENABLE(PENABLE_top),
    .PWRITE(PWRITE_top),
    .PWDATA(PWDATA_top),
    .PRDATA(PRDATA_top),
    .PREADY(PREADY_I2C_top),
    .I2C_control(I2C_control_top),
    .PSLVERR(),
    .SCL(SCL),
    .SDA(SDA),
    .interrupt_i2c(interrupt_i2c_top)
);*/

SPI_SLAVE slave4(
            .PCLK(clk_top),
            .PRESETn(rst),
            .PADDR(PADDR_top),
            .PSEL(PSEL_spi_top),
            .PENABLE(PENABLE_top),
            .PWRITE(PWRITE_top),
            .PWDATA(PWDATA_top),
            .PRDATA(PRDATA_top),
            .PREADY(PREADY_SPI_top),
            .PSLVERR(),
            .miso_spi(miso_spi),
            .SPI_CONTROL(SPI_CONTROL_top),
            .mosi_spi(mosi_spi),
            .cs_spi(cs_spi),
            .interrupt_spi(interrupt_spi_top),
            .sclk_spi(sclk_spi),
            .control_reg_out_spi(control_reg_out_spi_top)
);

UART_Slave slave5(
            .PCLK(clk_top),
            .RX(RX),
            .PRESETn(preset_top),
            .PADDR(PADDR_top),
            .PSEL(PSEL_uart_top),
            .PENABLE(PENABLE_top),
            .PWRITE(PWRITE_top),
            .PWDATA(PWDATA_top),
            .PRDATA(PRDATA_top),
            .PREADY(PREADY_UART_top),
            .PSLVERR(),
            .RXIF(UART_RXIF_top),
            .TX(TX),
            .uart_control(UART_control_top)
    );
 
 TIMER_Slave slave6(
            .PCLK(clk_top),
            .PRESETn(rst),
            .PSEL_timer(PSEL_timer_top),
            .PENABLE(PENABLE_top),
            .PWRITE(PWRITE_top),
            .PWDATA(PWDATA_top),
            .timer_control(TIMER_CONTROL_top),
            .PREADY(PREADY_TIMER_top),
            .PSLVERR(),
            .ext_clk(clk_top),
            .int_clk(clk),
            .timer_interrupt(timer_interrupt_top)
);

SPI_flashcontroller spif(
                .miso(miso),
                .clk(clk_top) ,
                .reset(reset),
                .mosi(mosi),
                .sclk(sclk),
                .cs(cs),
                .instruction(instruction_top),
                .dummy_pc(dummy_pc_top),
                .write_en(write_en_top),
                .prg_mode(prg_mode_top)
    );

endmodule
