module TSR11_bit(
    input wire [31:0] TXREG,
    input clk, reset, TXREG_to_TSR_en, clk_ext,write_enable,
    input [1:0] uart_control,
    output reg serial_out,
    output reg TSR_Ready,
    output reg [2:0] mode
);

reg [9:0] TX_shift_reg;
reg [3:0] shift_count;
//wire [7:0] second_byte;

assign second_byte = TXREG[15:8]; 

always @(posedge clk) begin
    if (reset) begin
        mode <= 3'b100;
        TX_shift_reg <= 10'b1111111111;
        shift_count <= 0;
        TSR_Ready <= 1;
        serial_out <= 1; 
    end
    else if (shift_count != 10) begin
        TX_shift_reg <= {1'b1, TX_shift_reg[9:1]}; 
        shift_count <= shift_count + 1;
        TSR_Ready <= 0;
        serial_out <= TX_shift_reg[0];
    end
    else begin
        TX_shift_reg <= 10'b1111111111; 
        shift_count <= 0;
        TSR_Ready <= 1;
        serial_out <= 1;
    end
end
always @(negedge clk_ext) begin
    if (TXREG_to_TSR_en) begin
        case (mode)
            3'b000: begin
                TX_shift_reg <= {1'b1, TXREG[7:0], 1'b0};
                TSR_Ready <= 0;
                shift_count <= 0;
                serial_out <= 1;
                if (uart_control == 2'b01 || uart_control == 2'b10 || uart_control == 2'b11)
                    mode <= 3'b001; 
                else
                    mode <= 3'b100;
            end
            3'b001: begin
                TX_shift_reg <= {1'b1, TXREG[15:8], 1'b0}; 
                TSR_Ready <= 0;
                shift_count <= 0;
                serial_out <= 1;
                if (uart_control == 3'b010 || uart_control == 3'b011)
                    mode <= 2'b010; 
                else
                    mode <= 3'b100; 
            end
            3'b010: begin
                TX_shift_reg <= {1'b1, TXREG[23:16], 1'b0}; // Third byte
                TSR_Ready <= 0;
                shift_count <= 0;
                serial_out <= 1;
                if (uart_control == 2'b11)
                    mode <= 3'b011; 
                else
                    mode <= 3'b100;
            end
            3'b011: begin
                TX_shift_reg <= {1'b1, TXREG[31:24], 1'b0}; // Fourth byte
                TSR_Ready <= 0;
                shift_count <= 0;
                serial_out <= 1;
                mode <= 3'b100;
                
            end
            default: begin
                mode <= 3'b100;
            end
        endcase
    end
end

always@(posedge clk_ext)begin
    if (reset) begin
        mode <= 3'b100;
        TX_shift_reg <= 10'b1111111111;
        shift_count <= 0;
        TSR_Ready <= 1;
        serial_out <= 1; 
    end
     else if(write_enable)begin
         mode <= 3'b000;

     end
end
endmodule