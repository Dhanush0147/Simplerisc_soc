
module modu7(clk_in,clk_ext,rst,clk_out);
input clk_in,rst,clk_ext;
output reg clk_out;


reg [2:0]counter;

always@(posedge clk_ext)begin
  if(rst)begin
    clk_out = 0;
    counter = 3'b000;
end
end
always@(posedge clk_in)begin
  if(rst)begin
    clk_out = 0;
    counter = 3'b000;
end
else begin
    counter = counter + 1;
    if(counter == 3'd7)begin
    clk_out = 0;
    counter = 3'd0;
    end
end
end
always@(negedge clk_in)begin
     if(counter == 3'd3)begin
       clk_out <= 1;
     
     end
end

endmodule


