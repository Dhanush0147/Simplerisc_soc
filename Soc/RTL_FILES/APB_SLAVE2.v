module GPIO_SLAVE (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output   [31:0] PRDATA,
    output          PREADY,
    output reg         PSLVERR,
    inout Pin_1 , Pin_2 , Pin_3, Pin_4,Pin_5,Pin_6 , Pin_7 , Pin_8,Pin_9,Pin_10,Pin_11,Pin_12,Pin_13,Pin_14,Pin_15,Pin_16
);

GPIO_main GPIO(
         .PCLK(PCLK),
         .PWRITE(PWRITE),
         .PRESETn(PRESETn), 
         .PSEL(PSEL), 
         .PENABLE(PENABLE),
         .PADDR(PADDR[4:0]), 
         .PWDATA(PWDATA[15:0]),
         .PRDATA_top(PRDATA),
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

    assign PREADY = 1'b1;

endmodule
