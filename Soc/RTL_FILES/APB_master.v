module APB_Master (
    input  wire        PCLK,
    input  wire        PRESETn,     // Active-low

    // From CPU
    input  wire [31:0] addr_CPU,
    input  wire [31:0] wdata_CPU,
    input  wire        write_CPU,
    input  wire        transfer,

    // To CPU
    output reg [31:0] CPU_rdata,
    output reg APB_ack,

    // To peripherals
    output reg  [31:0]  PADDR,
    output reg         PWRITE,
    output reg  [31:0] PWDATA,
    output reg         PENABLE,
    
    output reg [1:0]    state,
    // From selected peripheral
    input  wire [31:0] PRDATA,
    input  wire        PREADY,
    input  wire        PSLVERR,
    
    //change
    output PSEL_gpio,
    output PSEL_uart, 
    output PSEL_pwm, 
    output PSEL_i2c,
    output PSEL_spi, 
    output PSEL_timer, 
    output PSEL_periph6,
    output PSEL_mem
);
    wire [7:0] psel_decode;
    localparam [1:0]
        IDLE   = 2'b00,
        SETUP  = 2'b01,
        ACCESS = 2'b10;
        
        
        //mem --> 0 to 31
        //slave1(pwm) ---> 32 , 33
        //slave 2(uart) ---> 34
        //slave3   --->  35
        // slave 4 ----> 36
        // slave 5 ----> 37
       // slave 6 ----> 38
       // slave 7 ----> 39
    reg         [7:0] PSEL;  //change
    assign psel_decode =  (addr_CPU[16] == 1) ?
                            ((addr_CPU[3:0] == 4'b0000) ? 8'd2: //pwm 
                            (addr_CPU[3:0] == 4'b0001) ? 8'd4://gpio
                             (addr_CPU[3:0] == 4'b0010) ? 8'd8://i2c
                             (addr_CPU[3:0] == 4'b0011) ? 8'd16://uart
                             (addr_CPU[3:0] == 4'b0100) ? 8'd32: 8'd0)://spi
                             8'd1;
    /*(addr_CPU[31:2] == 30'h100000 && addr_CPU[1:0] <= 2'd3) ? 8'b00000001 : // Timer: 0x400000-0x400003
                         (addr_CPU[31:2] == 30'h200000 && addr_CPU[1:0] <= 2'd3) ? 8'b00000010 : // UART: 0x800000-0x800003
                         (addr_CPU[31:2] == 30'h300000 && addr_CPU[1:0] <= 2'd1) ? 8'b00000100 : // PWM: 0xC00000-0xC00003
                         (addr_CPU[31:2] == 30'h400000 && addr_CPU[1:0] <= 2'd3) ? 8'b00001000 : // Periph3: 0x1000000-0x1000003
                         (addr_CPU[31:2] == 30'h500000 && addr_CPU[1:0] <= 2'd3) ? 8'b00010000 : // Periph4: 0x1400000-0x1400003
                         (addr_CPU[31:2] == 30'h600000 && addr_CPU[1:0] <= 2'd3) ? 8'b00100000 : // Periph5: 0x1800000-0x1800003
                         (addr_CPU[31:2] == 30'h700000 && addr_CPU[1:0] <= 2'd3) ? 8'b01000000 : // Periph6: 0x1C00000-0x1C00003
                         (addr_CPU[31:5] == 24'h000000 && addr_CPU[4:0] <= 8'd32) ? 8'b10000000 : // Memory: 0x2000000-0x20003FF (256 words)
                         8'b00000000;  */


    // ------------------------------------------------------
    // 1) COMBINATIONAL: compute next_state from current state
    // ------------------------------------------------------
    always @(negedge PCLK ) begin
       // default stay put
         
        case (state)
            
            IDLE: begin
                if (transfer)
                begin 
                    state = SETUP;
                     APB_ack = 1'b0;
                 end 
                else
                begin 
                    state = IDLE;
                     APB_ack = 1'b1;
                end 
            end

            SETUP: begin
                // Always move to ACCESS on the very next cycle
                state = ACCESS;
                APB_ack = 1'b0;
            end

            ACCESS: begin
                if (PREADY) begin
                    // If CPU is still asking for another transfer, loop back to SETUP
                    // otherwise go back to IDLE
                    state  =  IDLE;
                    APB_ack = 1'b1;
                    
                end 
                else begin
                    // Stay in ACCESS (wait-state) until PREADY goes high
                    state = ACCESS;
                      APB_ack = 1'b0;
                end
            end

            default: begin
                state = IDLE;
                APB_ack = 1'b1;
            end
        endcase
      
    end

    // ------------------------------------------------------
    // 2) SEQUENTIAL: update state <= next_state and drive ALL outputs 
    // ------------------------------------------------------
    always @(*) begin
        if (!PRESETn) begin
            // Reset: force state=RESET and clear every output
            state      <= IDLE;
            PADDR      <= 32'd0;
            PWRITE     <= 1'b0;
            PWDATA     <= 32'd0;
            PSEL       <= 16'd0;
            PENABLE    <= 1'b0;
            CPU_rdata  <= 32'd0;
        end else begin
            // 1) Update stat
            
            case (state)

                IDLE: 
                begin
                    PENABLE <=0;
                    PSEL <=0;
                    PWRITE     <= 1'b0;
                end
                
                
                SETUP: begin
                    // Setup (T1) happens immediately on the same clock that next_state=SETUP
                    PADDR  <= addr_CPU[31:0];
                    PSEL <= psel_decode;
                    PWRITE <= write_CPU;
                    PWDATA <= wdata_CPU;
                    PENABLE<=0;

                    // One-hot select:
             //       PSEL[ addr_CPU[7:4] ] <= 1'b1;
                    // PENABLE stays 0 until ACCESS
                end
                
                ACCESS: 
                    begin
                        PENABLE <= 1'b1;
                        
                        //Level sensing of PREADY
                        if (PREADY) begin
                            if (!write_CPU) begin
                                CPU_rdata <= PRDATA;
                            end
                        end
                    end

                default: begin

                end
            endcase
        end
    end
    

   assign PSEL_mem     = PSEL[0]; 
    assign PSEL_pwm     = PSEL[1]; 
    assign PSEL_gpio   = PSEL[2];
    //assign PSEL_I2C = PSEL[3]; 
    assign PSEL_uart    = PSEL[4]; 
    assign PSEL_spi = PSEL[5]; 
    assign PSEL_timer = PSEL[3]; 
    assign PSEL_periph7 = PSEL[7]; 


    
endmodule
