module DFF(clk, d, q, reset);
    input clk, d, reset;
    output q;
    reg q;
    
    always @(posedge clk or posedge reset)
    begin
        if(reset)
            q <= 1'b0;
        else 
            q <= d;
    end
endmodule
