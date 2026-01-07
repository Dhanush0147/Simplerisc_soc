module Single_GPIO(input  PRESETn , PCLK , WR_TRIS , WR_PORT , PWDATA_s , RD_PORT , output  PRDATA_tri_buf , inout Pin);
wire reset_flip;
wire Pin_buf;
wire TRIS_en;
wire PORT_data;
wire input_data;
wire PRDATA_s;    //reg HRDATA_s
assign reset_flip = PRESETn;
d_flip_flop_gpio_tris TRIS (.clock(PCLK) , .en(WR_TRIS), .d(PWDATA_s) , .reset(reset_flip) , .q(TRIS_en));
d_flip_flop_gpio_port PORT (.clock(PCLK) , .en(WR_PORT), .d(PWDATA_s) , .reset(reset_flip) , .q(PORT_data));
assign Pin = (!TRIS_en)?PORT_data:input_data;
buf P1 (Pin_buf,Pin); 
d_latch_gpio PORT_READ (.d(Pin),.en(RD_PORT),.rstn(reset_flip),.q(PRDATA_s));

bufif1 (PRDATA_tri_buf , PRDATA_s , RD_PORT);
endmodule