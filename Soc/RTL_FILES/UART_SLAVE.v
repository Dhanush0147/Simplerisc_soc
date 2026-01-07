module UART_Slave(
    input  wire        PCLK,
    input wire         RX,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output   [31:0] PRDATA,
    output        PREADY,
    output  reg  PSLVERR,
    output  RXIF,TX,
    input  [7:0] uart_control
    );
        
        
   // UART peripheral bit 0 -> 50mhzen ,bit 1 ->TXEN,bit 2_>RXEN , bit-3,4 -> baudsel[1:0] , bit 5 ->SPEN
   wire en_50Mhz,TXEN,RXEN,SPEN;
   wire [1:0] baud_sel;
   wire [1:0] DATA_control;
   wire [7:0]PRDATA_uart;
   assign en_50Mhz = uart_control[0];
   assign TXEN = uart_control[1];
   assign RXEN = uart_control[2];
   assign baud_sel = {uart_control[3],uart_control[4]};
   assign SPEN =  uart_control[5];
   assign PRDATA[7:0] = PSEL ? PRDATA_uart : 8'dz;
   assign DATA_control = {uart_control[7],uart_control[6]};
   
    UART_TOP UART(
.EN_50MHz(en_50Mhz),  
.PENABLE(PENABLE),
.PCLK(PCLK),
.PRESETn(PRESETn),
.PWRITE(PWRITE),
.PSEL(PSEL),
.TXEN(TXEN),
.SPEN(SPEN),
.RX(RX),
.RXEN(RXEN),
.PWDATA(PWDATA),
.uart_control(DATA_control),
.BAUD_SEL(baud_sel),
.TXIF(PREADY),
.RXIF(RXIF),
.TX(TX),
.PRDATA(PRDATA_uart)
);

endmodule