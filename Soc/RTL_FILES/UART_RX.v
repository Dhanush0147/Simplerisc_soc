module uart_rx (
    input  wire       clk,
    input  wire       reset,
    input  wire       rx_tick,     
    input  wire       rx,
    input  wire       rxif_clr,     
    output reg [7:0]  rx_buffer,   
    output reg        rxif          
);

    localparam IDLE  = 3'd0,
               START = 3'd1,
               DATA  = 3'd2,
               STOP  = 3'd3;

    reg [2:0] state;
    reg [3:0] tick_cnt;   
    reg [2:0] bit_cnt;    
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state      <= IDLE;
            tick_cnt  <= 4'd0;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            rx_buffer <= 8'd0;
            rxif      <= 1'b0;
        end else begin

            if (rxif_clr)
                rxif <= 1'b0;

            if (rx_tick) begin
                case (state)

                    IDLE: begin
                        tick_cnt <= 0;
                        bit_cnt  <= 0;
                        if (rx == 1'b0)
                            state <= START;
                    end

                    START: begin
                        tick_cnt <= tick_cnt + 1'b1;
                        if (tick_cnt == 4'd7) begin
                            if (rx == 1'b0) begin
                                tick_cnt <= 0;
                                state <= DATA;
                            end else begin
                                state <= IDLE;
                            end
                        end
                    end

                    DATA: begin
                        tick_cnt <= tick_cnt + 1'b1;
                        if (tick_cnt == 4'd15) begin
                            tick_cnt  <= 0;
                            shift_reg <= {rx, shift_reg[7:1]};

                            if (bit_cnt == 3'd7) begin
                                bit_cnt <= 0;
                                state <= STOP;
                            end else begin
                                bit_cnt <= bit_cnt + 1'b1;
                            end
                        end
                    end

                    STOP: begin
                        tick_cnt <= tick_cnt + 1'b1;
                        if (tick_cnt == 4'd15) begin
                            rx_buffer <= shift_reg; 
                            rxif      <= 1'b1;      
                            tick_cnt  <= 0;
                            state     <= IDLE;
                        end
                    end

                    default: state <= IDLE;

                endcase
            end
        end
    end
endmodule
