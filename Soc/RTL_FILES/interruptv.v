`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 14:33:05
// Design Name: 
// Module Name: interrupt_controller
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


module interrupt_controller(
input [31:0] int_reg,
output  interrupt_pin_high,
        interrupt_pin_low
        
    );
   /* 
        int_reg[1:0] --  e_int0e,e_int0f
        int_reg[3:2] --  e_int1e,e_int1f
        int_reg[5:4]-- e_int2e,e_int2f
        int_reg[7:6] -- e_int3e,e_int3f
        int_reg[9:8] -- uart_inte,uart_intf
        int_reg[11:10] -- spi_inte,spi_intf
        int_reg[13:12] -- i2c_inte,i2c_intf
        int_reg[15:14] -- timer_inte,timer_intf
        int-reg[17:16] -- GIEH,GIEL        
        int_reg[19:18] -- high_int_active , low_int_active -- we'll set these two whiile starting of each of the priority 
        int_reg[20] -- low_pending 
        int_reg[21] -- is_nested interrupt 
        
    */
        wire interrupt_pin_hi ;
  assign interrupt_pin_hi = 
                                (int_reg[17]  &  
                                        (
                                            (int_reg[1]& int_reg[0]) || 
                                            (int_reg[3]& int_reg[2]) || 
                                            (int_reg[5]& int_reg[4]) || 
                                            (int_reg[7]& int_reg[6]) 
                                        )
                                );
                                
                                

  assign interrupt_pin_low =        ( (~interrupt_pin_hi) & (~int_reg[19]) &                                    
                                            
                                            (int_reg[16]  & 
                                                    (
                                                            (int_reg[9]& int_reg[8]) || 
                                                            (int_reg[11]& int_reg[10]) ||
                                                            (int_reg[13]& int_reg[12]) || 
                                                            (int_reg[15]& int_reg[14]) 
                                                    )
                                            )
                                         ); 
  assign interrupt_pin_high = interrupt_pin_hi;                          

                                
                            
        
endmodule

