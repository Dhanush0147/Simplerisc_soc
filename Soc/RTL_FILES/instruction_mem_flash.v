`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.06.2025 16:27:46
// Design Name: 
// Module Name: instruction_mem_flash
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_mem_flash(
    input ext_clk,clk,
    input write_en,
    input prg_mode,
    input [31:0] instruction_flash,//this is the instruction coming from flash
    input [31:0] address,//this comes from the program counter
    input [31:0] dummy_pc,//this comes from the spi flash driver
    output [31:0] instruction_pc//these the instructions which will go into the processor 
    );
    
    wire [31:0] BUS,address_pointer;
    wire clk_input;
    wire [31:0]instruction;
  //  wire clk_input;
    reg we;
    always @(posedge write_en)
        begin 
            we = 1'b1;
        end 
    always @(negedge clk) begin 
        if(we == 1'b1)
            we = 1'b0;
          end 
    assign address_pointer = (~prg_mode) ? dummy_pc : address;
    assign BUS = (~prg_mode) ? instruction_flash : 32'bz; // Drive BUS only in prg_mode
   assign clk_input = (prg_mode)? clk : ext_clk ; // hetre inverted processor clock was given to the raed port of the instruction memory to read instruction memory at the negedge of the clock
/*  mem_256kb your_ram_inst (
  .clka(clk_input),
  .ena(1'b1),
  .wea(we),
  .addra(address_pointer),
  .dina(instruction_flash),
  .douta(instruction)
);*/
    instruction_mem_new instruction_mem_inst (
        .address_pointer(address_pointer),
        .BUS(BUS),
        .prg_mode(prg_mode),
        .clk_input(clk_input),
        .we(we)
    );
    
    assign instruction_pc = (prg_mode)? BUS : 32'bz;
        
endmodule
