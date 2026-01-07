module modu2(clk_in,rst,clk_out);
input clk_in,rst;
output reg clk_out;



always@(posedge clk_in)begin
             if(rst)begin
                 clk_out = 0;
             end
             else begin
                 if(clk_out == 1)
                     clk_out = 0;
                 else
                   clk_out = 1;

              end
    end

endmodule
