//-------------------------
// Register File
//-------------------------
// 16-register file, 32-bit each.
// Supports two reads and one write per cycle
module register__file(
    input clk,isWb,
    input [31:0]pc,
    input [1:0]flags_in,
    input interrupt,
    input [3:0]rs1,rs2,rd_ra,
    input [31:0]data,
    output  [31:0]rd1,rd2,
    output [1:0]flags_out
);

reg [31:0]register[30:0];  
        
initial
begin
    register[14]=32'd20;
    register[15]=12;
// Initialize registers
//    register[0]=3;
//    register[1]=6;
//    register[2]=5;
//    register[3]=2;
//    register[4]=7;
//    register[5]=7;
//    register[6]=8;
//    register[7]=9;
//    register[8]=10;
//    register[9]=3;
//    register[10]=2;
//    register[11]=1;
//    register[12]=35;
//    register[13]=42;
//    register[14]=11;
//    register[15]=12;
end

assign rd1 = register[rs1];
assign rd2 = register[rs2];

always @(*)
begin
    register[13] <= {30'b0,flags_in};     //connect tha flag always          
end
always @(posedge interrupt)
begin
    
    register[12] <= pc;   
end
always @(posedge clk)
begin
    
     if(isWb )
        begin
            register[rd_ra] <= data; //writing to register file if enabled 
        end
end
endmodule
