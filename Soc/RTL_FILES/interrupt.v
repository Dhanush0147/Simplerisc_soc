module interrupt_handler(
    input clk,
    input interrupt_pin_high,
    input interrupt_pin_low,
    output reg interrupt_out,
    output reg [31:0]pc_isr
);

    always@(posedge interrupt_pin_high or posedge interrupt_pin_low)
    begin
        if(interrupt_pin_high)
        begin
            interrupt_out <= 1'b1;
            pc_isr <= 32'd0;
        end    
        else if (interrupt_pin_low )
        begin 
            interrupt_out <= 1'b1;
            pc_isr<= 32'h00000015;
         end
    end 
    always@(posedge clk)
    begin 
    if(interrupt_out == 1)begin
         interrupt_out <= 1'b0;
     end 
   end  
     
  endmodule  
