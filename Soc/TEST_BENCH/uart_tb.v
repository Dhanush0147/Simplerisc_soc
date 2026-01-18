`timescale 1ns/1ps

module uart_loopback_tb;

    // ---------------- Clock & reset ----------------
    reg clk;
    reg reset;

    // ---------------- UART control ----------------
    reg  [1:0] baud_sel;
    reg        ENABLE;
    reg        TXEN;
    reg        SPEN;
    reg  [1:0] uart_control;
    reg  [31:0] UART_data;
    reg        rxif_clr;

    // ---------------- Wires ----------------
    wire TXIF;
    wire rxif;
    wire [7:0] rx_data;
    wire TX_line;

    // ---------------- Clock generation ----------------
    initial clk = 1'b0;
    always #5 clk = ~clk;   // 100 MHz clock

    // ---------------- TX DUT ----------------
    UART_tx_top uut_tx (
        .clk(clk),
        .reset(reset),
        .ENABLE(ENABLE),
        .TXEN(TXEN),
        .SPEN(SPEN),
        .baud_sel(baud_sel),
        .uart_control(uart_control),
        .UART_data(UART_data),
        .TXIF(TXIF),
        .RX_data(),       // not used
        .RX_valid()       // not used
    );

    // ---------------- RX DUT ----------------
    UART_rx_top uut_rx (
        .clk(clk),
        .reset(reset),
        .baud_sel(baud_sel),
        .rx_pin(TX_line),   // LOOPBACK CONNECTION
        .rxif_clr(rxif_clr),
        .rx_data(rx_data),
        .rxif(rxif)
    );

    // Internal loopback wire
    assign TX_line = uut_tx.TX_line;

    // ---------------- Test sequence ----------------
    initial begin
        // defaults
        reset        = 1'b1;
        baud_sel     = 2'b00;  // 9600 baud
        ENABLE       = 1'b0;
        TXEN         = 1'b0;
        SPEN         = 1'b0;
        uart_control = 2'b00;
        UART_data    = 32'd0;
        rxif_clr     = 1'b0;

        // reset
        #50;
        reset = 1'b0;

        // enable UART
        ENABLE = 1'b1;
        TXEN   = 1'b1;
        SPEN   = 1'b1;

        // transmit byte
        #50;
        UART_data = 32'h000000A5;  // test byte = 0xA5
        $display("TX sending data = 0x%0h", UART_data[7:0]);

        // wait for TX complete
        wait (TXIF == 1'b1);
        $display("TX done");

        // wait for RX complete
        wait (rxif == 1'b1);
        $display("RX received data = 0x%0h", rx_data);

        // check result
        if (rx_data == UART_data[7:0])
            $display(" TEST PASSED: RX data matches TX data");
        else
            $display(" TEST FAILED: RX data mismatch");

        // clear RX flag
        rxif_clr = 1'b1;
        #10;
        rxif_clr = 1'b0;

        #100;
        $finish;
    end

endmodule
