module UART_rx_top (
    input  wire       clk,
    input  wire       reset,
    input  wire [1:0] baud_sel,
    input  wire       rx_pin,
    input  wire       rxif_clr,
    output wire [7:0] rx_data,
    output wire       rxif
);

    wire rx_tick_int;

    baud_gen_rx b_rx (
        .clk      (clk),
        .reset    (reset),
        .baud_sel (baud_sel),
        .rx_tick  (rx_tick_int)
    );

    uart_rx rx (
        .clk        (clk),
        .reset      (reset),
        .rx_tick    (rx_tick_int),
        .rx         (rx_pin),
        .rxif_clr   (rxif_clr),
        .rx_buffer  (rx_data),
        .rxif       (rxif)
    );

endmodule
