module GPIO_main(
input PCLK, PWRITE , PRESETn , PSEL , PENABLE ,
input[4:0] PADDR , 
input[15:0] PWDATA ,
inout Pin_1 , Pin_2 , Pin_3, Pin_4,Pin_5,Pin_6 , Pin_7 , Pin_8,Pin_9,Pin_10,Pin_11,Pin_12,Pin_13,Pin_14,Pin_15,Pin_16,
output [15:0] PRDATA_top);
//reg[7:0] Port_reg;
//reg[7:0] Tris_reg;
wire WR_TRIS_main;
wire WR_PORT_main;
wire RD_PORT_main;
//assign HREADYOUT = 1'b1;
reg[7:0] PWDATA_latch;
assign WR_TRIS_main = (PSEL==1 && PWRITE == 1 && PADDR[4:0] == 5'b11110)?1'b1:1'b0;
assign WR_PORT_main = (PSEL==1 && PWRITE == 1 && PADDR[4:0] == 5'b11111)?1'b1:1'b0;
assign RD_PORT_main = (PSEL==1 && PWRITE == 0 && PADDR[4:0] == 5'b11111)?1'b1:1'b0;

always@(posedge PCLK or negedge PRESETn)begin
   if(!PRESETn) begin
   PWDATA_latch <= 0;
   end
   else begin
      PWDATA_latch<=PWDATA;
   end
   
end
Single_GPIO Pin_module_1 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[0] , RD_PORT_main , PRDATA_top[0] , Pin_1);
Single_GPIO Pin_module_2 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[1] , RD_PORT_main , PRDATA_top[1] , Pin_2);
Single_GPIO Pin_module_3 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[2] , RD_PORT_main , PRDATA_top[2] , Pin_3);
Single_GPIO Pin_module_4 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[3] , RD_PORT_main , PRDATA_top[3] , Pin_4);
Single_GPIO Pin_module_5 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[4] , RD_PORT_main , PRDATA_top[4] , Pin_5);
Single_GPIO Pin_module_6 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[5] , RD_PORT_main , PRDATA_top[5] , Pin_6);
Single_GPIO Pin_module_7 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[6] , RD_PORT_main , PRDATA_top[6] , Pin_7);
Single_GPIO Pin_module_8 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[7] , RD_PORT_main , PRDATA_top[7] , Pin_8);
Single_GPIO Pin_module_9 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[8] , RD_PORT_main , PRDATA_top[8] , Pin_9);
Single_GPIO Pin_module_10(PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[9] , RD_PORT_main , PRDATA_top[9] , Pin_10);
Single_GPIO Pin_module_11 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[10] , RD_PORT_main , PRDATA_top[10] , Pin_11);
Single_GPIO Pin_module_12 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[11] , RD_PORT_main , PRDATA_top[11] , Pin_12);
Single_GPIO Pin_module_13 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[12] , RD_PORT_main , PRDATA_top[12] , Pin_13);
Single_GPIO Pin_module_14 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[13] , RD_PORT_main , PRDATA_top[13] , Pin_14);
Single_GPIO Pin_module_15 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[14] , RD_PORT_main , PRDATA_top[14] , Pin_15);
Single_GPIO Pin_module_16 (PRESETn , PCLK , WR_TRIS_main , WR_PORT_main , PWDATA[15] , RD_PORT_main , PRDATA_top[15] , Pin_16);

endmodule