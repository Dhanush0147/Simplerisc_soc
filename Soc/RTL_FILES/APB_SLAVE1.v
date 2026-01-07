module PWM_SLAVE (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL_pwm,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
   // output reg  [31:0] PRDATA,
    output reg         PREADY,
    output reg         PSLVERR
);

  
  reg [31:0]PWM_Reg[0:1];
 
    // APB3 slave logic
    always @(posedge PCLK or posedge PRESETn) begin
        if (PRESETn) begin
            PREADY <= 1'b0;
            PSLVERR <= 1'b0;
        end
        else begin
               PREADY <= 1'b1;
                PSLVERR <= 1'b0;   
                if(PENABLE & PSEL_pwm)begin
                PWM_Reg[PADDR[0]] <= PWDATA;
        end            
      end
    end
///////////////////////////////////////////////
    
//duty_cycle_in [15:0]-> PWM_Reg[1][15:0]
//pr_in [15:0] -> PWM_Reg[0][31:16]
//rst -> PWM_Reg[0][0]
// en_prescalar ->  PWM_Reg[0][1]
//EN_TMR -> PWM_Reg[0][2]
// prescale_value [4:0] -> PWM_Reg[0][7:3]

PWM pwm_slave( 
    .rst(PRESETn),
    .clk(PCLK),
    .pr_in( PWM_Reg[0][31:16]),
    .duty_cycle_in( PWM_Reg[1][15:0]),
    .prescale_value(PWM_Reg[0][7:3] ),
    .en_prescalar(PWM_Reg[0][1]),
    .EN_TMR(PWM_Reg[0][2])
);
endmodule