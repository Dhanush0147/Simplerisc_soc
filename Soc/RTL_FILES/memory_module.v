`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.06.2025 13:03:27
// Design Name: 
// Module Name: memory_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit bidirectional memory interface using APB-style handshaking
// 
//////////////////////////////////////////////////////////////////////////////////

module memory_module (
    input wire    clk,
    input wire    PSEL,
    input         PENABLE,
    input         PWRITE,
    input  [31:0] PADDR,
    input  [31:0] PWDATA,
    output  [31:0] PRDATA
);
    wire we;
    wire [31:0] BUS; 
    wire ENABLE ;
    assign ENABLE = PSEL && PENABLE;
    assign BUS = (PSEL && PENABLE && PWRITE)  ? PWDATA : 32'dZ;
    assign PRDATA = (PSEL && PENABLE && ~PWRITE) ? BUS : 32'dz;
    assign we = PSEL && PENABLE && PWRITE;
   
/*   mem_256kb your_ram_inst (
  .clka(clk),
  .ena(ENABLE),
  .wea(we),
  .addra(PADDR),
  .dina(PWDATA),
  .douta(PRDATA)
);*/

    memory memory(
     .PADDR(PADDR),
     .BUS(BUS),
     .we(PWRITE),
     .clk(clk),
     .PENABLE(ENABLE)/////////////////////////////////////////////////666666666666666666//////////////////////////
    );
    
endmodule

