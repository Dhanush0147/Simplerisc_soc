module baud_tick_gen (
    input  wire       clk,
    input  wire       reset,
    input  wire [1:0] baud_sel,   
    output reg        baud_tick
);

    integer BAUD_DIV;
    integer cnt;

    always @(*) begin
        case (baud_sel)
            2'b00: BAUD_DIV = 10416; 
            2'b01: BAUD_DIV = 5208;  
            2'b10: BAUD_DIV = 1736;  
            default: BAUD_DIV = 868; 
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt       <= 0;
            baud_tick <= 1'b0;
        end else if (cnt == BAUD_DIV-1) begin
            cnt       <= 0;
            baud_tick <= 1'b1;
        end else begin
            cnt       <= cnt + 1;
            baud_tick <= 1'b0;
        end
    end
endmodule
