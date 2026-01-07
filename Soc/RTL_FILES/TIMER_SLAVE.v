module TIMER_Slave (
    input  wire        PCLK,
    input  wire        PRESETn,
    //input  wire [31:0] PADDR,
    input  wire        PSEL_timer,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    input  wire [6:0]  timer_control,
    //output reg  [31:0] PRDATA,
    output          PREADY,
    output reg         PSLVERR,
    input ext_clk,
    input int_clk,
    output timer_interrupt
);
    
    
Timer TIME(
         .ext_clk(ext_clk),
         .int_clk(int_clk),
         .rst(PRESETn), 
         .PWRITE(PWRITE),  
         .P_EN(PENABLE), 
         .P_SEL(PSEL_timer),
         .TMCON(timer_control),
         .PWDATA(PWDATA),
         .PREADY(PREADY),
         .int_flag(timer_interrupt)
); 
endmodule