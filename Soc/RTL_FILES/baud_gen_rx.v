module baud_gen_rx (
    input  wire       clk,
    input  wire       reset,
    input  wire [1:0] baud_sel,
    output reg        rx_tick     
);

    reg [15:0] divisor;
    reg [15:0] counter;

    always @(*) begin
        case (baud_sel)
            2'b00: divisor = 16'd651;   
            2'b01: divisor = 16'd325;   
            2'b10: divisor = 16'd108;   
            default: divisor = 16'd54;  
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 16'd0;
            rx_tick <= 1'b0;
        end else if (counter == divisor) begin
            counter <= 16'd0;
            rx_tick <= 1'b1;
        end else begin
            counter <= counter + 1'b1;
            rx_tick <= 1'b0;
        end
    end

endmodule
