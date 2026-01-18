module uart_tx (
    input  wire        clk,
    input  wire        reset,
    input  wire        baud_tick,
    input  wire        ENABLE,
    input  wire        TXEN,
    input  wire        SPEN,
    input  wire [31:0] UART_data,
    input  wire [1:0]  uart_control,   
    output reg         TX,
    output reg         TXIF
);

    parameter IDLE      = 3'b000,
              LOAD      = 3'b001,
              SHIFT     = 3'b010,
              NEXT_BYTE = 3'b011,
              DONE      = 3'b100;
    reg [2:0] state;
    reg [9:0]  shift_reg;
    reg [3:0]  bit_cnt;
    reg [1:0]  byte_cnt;
    reg [31:0] tx_buf;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= IDLE;
            TX        <= 1'b1;
            TXIF      <= 1'b1;
            bit_cnt   <= 4'd0;
            byte_cnt  <= 2'd0;
            shift_reg <= 10'b1111111111;
        end else begin
            case (state)

                IDLE: begin
                    TX   <= 1'b1;
                    TXIF <= 1'b1;
                    if (ENABLE && TXEN && SPEN) begin
                        tx_buf   <= UART_data;
                        byte_cnt <= 2'd0;
                        TXIF     <= 1'b0;
                        state    <= LOAD;
                    end
                end

                LOAD: begin
                    shift_reg <= {1'b1, tx_buf[8*byte_cnt +: 8], 1'b0};
                    bit_cnt   <= 4'd0;
                    state     <= SHIFT;
                end

                SHIFT: begin
                    if (baud_tick) begin
                        TX        <= shift_reg[0];
                        shift_reg <= {1'b1, shift_reg[9:1]};
                        bit_cnt   <= bit_cnt + 1'b1;

                        if (bit_cnt == 4'd9)
                            state <= NEXT_BYTE;
                    end
                end

                NEXT_BYTE: begin
                    if (byte_cnt < uart_control) begin
                        byte_cnt <= byte_cnt + 1'b1;
                        state    <= LOAD;
                    end else begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    TX   <= 1'b1;
                    TXIF <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end
endmodule
