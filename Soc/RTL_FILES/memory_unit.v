//-------------------------
// Data Memory Unit
//-------------------------
// 16-word data memory. Supports load and store
module memory_unit(clk,isLd,isSt,address,data_in,data_out);
input clk,isLd,isSt;
input [31:0]address,data_in;
output [31:0]data_out;

reg [31:0] data_registers[30:0];
initial
begin
    // Initialize data memory
    data_registers[0] = 5;
    data_registers[1] = 5;
    data_registers[2] = 5;
    data_registers[3] = 5;
    data_registers[4] = 5;
    data_registers[5] = 5;
    data_registers[6] = 5;
    data_registers[7] = 5;
    data_registers[8] = 5;
    data_registers[9] = 5;
    data_registers[10] = 9;
    data_registers[11] = 5;
    data_registers[12] = 5;
    data_registers[13] = 5;
    data_registers[14] = 5;
    data_registers[15] = 2;
end

always @(posedge clk)
begin
    
    if(isSt)
    begin
        data_registers[address] <= data_in; // Store, Write to data memory on clock edge if enabled  
    end
end

assign data_out = (isLd)? data_registers[address] : 32'h00000000;  // load ,Read from data memory if enabled
endmodule

