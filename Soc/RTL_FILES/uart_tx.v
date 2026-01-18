module UART_tx_top (
    input  wire        clk,
    input  wire        reset,
    input  wire        ENABLE,
    input  wire        TXEN,
    input  wire        SPEN,
    input  wire [1:0]  baud_sel,
    input  wire [1:0]  uart_control,
    input  wire [31:0] UART_data,
    output wire        TXIF,
    output wire [7:0]  RX_data,
    output wire        RX_valid
);

    wire baud_tick;
    wire TX_line;

    baud_tick_gen baudgen (
        .clk(clk),
        .reset(reset),
        .baud_sel(baud_sel),
        .baud_tick(baud_tick)
    );

    uart_tx tx (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .ENABLE(ENABLE),
        .TXEN(TXEN),
        .SPEN(SPEN),
        .UART_data(UART_data),
        .uart_control(uart_control),
        .TX(TX_line),
        .TXIF(TXIF)
    );

  
endmodule
