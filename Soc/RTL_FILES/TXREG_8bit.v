`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2025 13:09:31
// Design Name: 
// Module Name: TXREG8_bit
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

module TXREG_8bit (
  input        clk,
  input        rst,
  input        write_enable,  
  input [1:0]uart_control,      
  input        TSR_Ready,           // TSR is ready to accept data
  output reg   TXIF,         // Status flag (TXIF)
  input  [31:0] data_in,             // Data from CPU
  input [2:0] mode,
  output reg [31:0] TXREG,        // Output to TSR
  output reg   TXREG_to_TSR_en      // Control signal: hey TSR I am sending the valid data Please recieve it
);

reg delay;

always @(posedge clk) begin
  if (rst) begin
    TXREG <= 8'd0;
    TXIF <= 1'b1;
    TXREG_to_TSR_en <= 1'b0;

    delay <= 0;
  end else begin
    if (write_enable && TXIF) begin
                                       // CPU writes new data
      TXREG <= data_in;
      delay <= 1'b1;
          
    end
    if(delay)begin
                TXIF <= 1'b0;
                delay <= 1'b0;
          end 
       end  
     TXIF = ((uart_control == 2'b00) & (TXIF == 1'b0))? 1'b1: TXIF;
             
       if ((TSR_Ready) || write_enable ) begin
                TXREG_to_TSR_en <= 1'b1;
                    if(((!mode[2] == 1'b1) & (mode[1:0] == uart_control)) && !TXIF) begin                             // TXREG_data_out <= TXREG;
                             TXIF <= 1'b1;  
                    end  
       end
       else begin 
                  TXREG_to_TSR_en <= 1'b0;    
       end             
  end

endmodule