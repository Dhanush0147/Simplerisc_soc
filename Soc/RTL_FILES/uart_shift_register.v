module uart_shift_register (
    input wire baud_clk,pull_up_en,             // 9600 Hz sampling clock
    input wire rst,                  // asynchronous reset
    input wire serial_in,                   // serial input line
    input wire st_bit_detected,     
  
    output reg [7:0] RX_shift_reg,      // received byte
    output reg shift_done                  
);

    reg [3:0] bit_count = 0;         

    reg shift_en = 0;
    wire counter_reset; 
    assign counter_reset = (~bit_count[0]) & (~bit_count[1]) & (~bit_count[2]) & bit_count[3];
    always @(posedge baud_clk or posedge rst) begin
        if (rst) begin
            bit_count <= 4'd0;
            RX_shift_reg <= 8'd0;

            shift_done <= 1'b0;
            shift_en <= 1'b0;
            
            
        end else begin
            if (st_bit_detected) begin
                shift_en <= 1;
                if(st_bit_detected && !counter_reset)begin
                RX_shift_reg <= {serial_in, RX_shift_reg[7:1]}; // shift serial_in from MSB
                end
                if (counter_reset) begin
                   // RX_shift_reg <= { RX_shift_reg[7:1]}; // final data after 8 bits
                    shift_done <= 1'b1;
                    bit_count <= 4'd0;
                    shift_en <= 1'b0;
                end else if(shift_en)
                 begin
                    bit_count <= bit_count + 1;
                    shift_done <= 1'b0;
                    shift_en <= 1'b1;
                    end
                  else begin
                    shift_done <= 1'b0;
                    end
                    
                
            end else begin
                shift_done <= 1'b0;
            end
        end
    end

endmodule