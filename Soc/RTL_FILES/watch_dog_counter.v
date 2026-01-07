

//In this design there is a chance that the processor will go inta a metastable state
module watchdog_rst_counter(
    input clk,
    input [31:0] present_pc,
    input [31:0] previous_pc,
    output reg watchdog_rst
    );

    reg [3:0] counter;
    wire pc_changed;
    initial 
        begin 
            counter = 0;
         end 
    assign pc_changed = |(present_pc ^ previous_pc);

    always @(posedge clk) 
    begin
        if (pc_changed) 
        begin
            if (counter == 4'hF) 
            begin
                watchdog_rst <= 1'b1;   
                counter <= 4'd0;       
            end 
            else 
            begin
                counter <= counter + 1; 
                watchdog_rst <= 1'b0;   
            end
        end
    end

endmodule

