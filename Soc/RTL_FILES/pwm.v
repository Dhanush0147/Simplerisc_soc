`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2025 15:41:06
// Design Name: 
// Module Name: pwm_final
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


module PWM(pwm_signal,rst,pr_in,clk,prescale_value,en_prescalar,EN_TMR,duty_cycle_in);
input rst,clk,en_prescalar,EN_TMR;
input [4:0] prescale_value;
input [15:0] duty_cycle_in;
input [15:0] pr_in;
output pwm_signal;
wire [15:0] TMR,duty_cycle_stored,duty_cycle_out;
wire [15:0] PR;
wire S,R;
wire rollover = (TMR==PR);
wire clk_out;

prescalar2 prescalar(.clk_out(clk_out),.clk(clk),.rst(rst),.prescale_value(prescale_value),.en_prescalar(en_prescalar));
period_reg pr(.PR(PR),.clk(clk_out),.pr_in(pr_in),.rst(rst));
tmr_cnt tmr(.TMR(TMR),.clk(clk_out),.rst(rst),.PR(PR),.EN_TMR(EN_TMR));
comparator_b cmp_b(.S(S),.PR(PR),.TMR(TMR));
duty_reg_master duty_mastr(.duty_cycle_stored(duty_cycle_stored),.rst(rst),.duty_cycle_in(duty_cycle_in));
duty_slave duty_cycle_slv(.duty_cycle_out(duty_cycle_out),.clk(clk_out),.rst(rst),.duty_cycle_stored(duty_cycle_stored),.rollover(rollover));
comparator_a cmp_a(.R(R),.TMR(TMR),.duty_cycle_out(duty_cycle_out));
sr_latch srl(.pwm_signal(pwm_signal),.R(R),.S(S),.rst(rst));
endmodule

