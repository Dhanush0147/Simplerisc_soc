`timescale 1ns / 1ps

module soc_tb;
    // Testbench signals
    reg clk_top;
    reg reset;
    
    reg miso,interrupt;
    reg miso_spi;
    wire mosi, sclk, cs,mosi_spi,cs_spi,sclk_spi;
    wire SDA,SCL;
    reg [15:0] ext_drive =0;
    reg [31:0] stimulus;
    reg [31:0] shift_reg,instruction;      // For sampling received data
    integer bit_cnt = 0;
    wire  [15:0]data ; 
    parameter MAX_LINES = 256;
    integer file, status;
    integer index;
    
    reg [1023:0] line_buffer;
    reg [31:0] line_data [0:MAX_LINES-1];
    reg [(MAX_LINES*32)-1:0] miso_data;
     wire        Pin_1, Pin_2, Pin_3, Pin_4,
                       Pin_5, Pin_6, Pin_7, Pin_8,
                       Pin_9, Pin_10, Pin_11, Pin_12,
                       Pin_13, Pin_14, Pin_15, Pin_16;
    // Shift logic inside always block
    wire integer total_bits;
    
    initial begin
      file = $fopen("C:\\Users\\raqeeb\\Downloads\\assembler\\output.bin", "r");
      if (file == 0) begin
        $display("Error: Cannot open input.txt");
        $finish;
      end
    
      for (index = 0; index < MAX_LINES; index = index + 1) begin
        status = $fgets(line_buffer, file);
        if (status != 0) begin
            $sscanf(line_buffer, "%b", line_data[index]);  // <-- changed to %b
            $display("Line %0d: %b", index, line_data[index]);
        end else begin
            line_data[index] = 32'h00000000;
            $display("Line %0d: <padded with 0>", index);
        end
      end

    
    
        for (index = 0; index < MAX_LINES; index = index + 1) begin
            miso_data[((MAX_LINES - index)*32 - 1) -: 32] = line_data[index];
        end

    end

    // Instantiate the DUT
    SOC uut (
        .clk_top(clk_top),
        .reset(reset),
        .miso(miso),
        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
         .Pin_1 (Pin_1),
            .Pin_2 (Pin_2),
            .Pin_3 (Pin_3),
            .Pin_4 (Pin_4),
            .Pin_5 (Pin_5),
            .Pin_6 (Pin_6),
            .Pin_7 (Pin_7),
            .Pin_8 (Pin_8),
            .Pin_9 (Pin_9),
            .Pin_10(Pin_10),
            .Pin_11(Pin_11),
            .Pin_12(Pin_12),
            .Pin_13(Pin_13),
            .Pin_14(Pin_14),
            .Pin_15(Pin_15),
            .Pin_16(Pin_16),
            .SCL(SCL),
            .SDA(SDA),
            .miso_spi(miso_spi),
            .mosi_spi(mosi_spi),
            .cs_spi(cs_spi),
            .sclk_spi(sclk_spi)
    );

/*tri SDA, SCL;      // declare as tri (already kiyaa hai)
pullup (SDA);      // weak-1 device
pullup (SCL);*/
     
           

    // Clock generator
    always #5 clk_top = ~clk_top; // 100MHz clock (10ns period)
  

    // Reset logic and simulation end
    initial begin
        clk_top = 0;
        reset = 1;
       shift_reg = 32'h0;
        stimulus = 32'hFF0FF0F0;
        #10;
        reset = 0;

        
       #4000;

        
        $display("Final Shift Register = %h", shift_reg);

        $finish;
    end
    //for gpio
   /*always @(*) begin 
        if(uut.pcore.p.instruction_mem.instruction_pc == 32'h75040001)
            begin 
                ext_drive = 16'hFF00;
            end 
    end */
      //for gpio read
    /*assign Pin_1 = (ext_drive[0] ) ? stimulus[0] : 1'bz;
    assign Pin_2 = (ext_drive[1]) ? stimulus[1] : 1'bz;
    assign Pin_3 = (ext_drive[2]) ? stimulus[2] : 1'bz;
    assign Pin_4 = (ext_drive[3]) ? stimulus[3] : 1'bz;
    assign Pin_5 = (ext_drive[4]) ? stimulus[4] : 1'bz;
    assign Pin_6 = (ext_drive[5]) ? stimulus[5] : 1'bz;
    assign Pin_7 = (ext_drive[6]) ? stimulus[6] : 1'bz;
    assign Pin_8 = (ext_drive[7]) ? stimulus[7] : 1'bz;
    assign Pin_9 = (ext_drive[8]) ? stimulus[8] : 1'bz;
    assign Pin_10 = (ext_drive[9]) ? stimulus[9] : 1'bz;
    assign Pin_11 = (ext_drive[10]) ? stimulus[10] : 1'bz;
    assign Pin_12 = (ext_drive[11]) ? stimulus[11] : 1'bz;
    assign Pin_13 = (ext_drive[12]) ? stimulus[12] : 1'bz;
    assign Pin_14 = (ext_drive[13]) ? stimulus[13] : 1'bz;
    assign Pin_15 = (ext_drive[14]) ? stimulus[14] : 1'bz;
    assign Pin_16 = (ext_drive[15]) ? stimulus[15] : 1'bz;*/
    //for i2c
    /*reg external_drive_ack= 0 ;
    reg external_drive_trans= 0 ;
    //fori2c send
    always @(posedge SCL)
    begin
        if(uut.slave3.i2c.state == 3'b011)
            external_drive_ack <= 1'b1;
        else
            external_drive_ack <= 1'b0;   
    end
    assign SDA = (external_drive_ack) ? 1'b0 : 1'bz;*/
    /*//for i2c read
    always @(*)
    begin
        if(uut.slave3.i2c.state == 3'b101)
            external_drive_trans = 1'b1;
        else
            external_drive_trans = 1'b0; 
    end
    assign SDA = (external_drive_trans) ? stimulus[31] : 1'bz;
    always @(posedge SCL)
    begin
    if(external_drive_trans)
    stimulus <= {stimulus[30:0], 1'b0};
    end*/
    
    //for spi
   /* reg external_drive_ack= 0 ;
    reg external_drive_trans= 0 ;
     always @(*)
    begin
        if(uut.slave4.spi.state == 3'b010)
            external_drive_ack = 1'b1;
        else
            external_drive_ack = 1'b0;     
    end
    always @(negedge sclk_spi)
    begin
        if(!cs_spi)
        stimulus <= {stimulus[30:0], 1'b0};
     end
     always @(negedge sclk_spi)
     begin
        if(!cs_spi)
            miso_spi =  stimulus[31] ;
        else
            miso_spi =  1'bz;    
     end*/
    
    

    // 32-bit Shift Register Sampling at posedge of sclk when cs is low
    always @(posedge sclk) begin
        if (!cs) begin
            shift_reg <= {shift_reg[30:0], mosi}; // Left shift in
            bit_cnt <= bit_cnt + 1;

            // After 32 bits are received, start driving miso
            if (bit_cnt >= 33) begin
                miso <= miso_data[(MAX_LINES*32)-1];
                miso_data <= {miso_data[(MAX_LINES*32)-2:0], 1'b0};

            end
           
        end
    end
    
    ////////////i2c slave////////////////
/*    i2c_slave_demo #( .SLAVE_ADDR(7'b0101000) ) sensor (
    .scl (SCL),
    .sda (SDA)
);*/


endmodule
// ===========================================================================
//  Very-small demo I²C-slave
//      • 7-bit address configurable
//      • 3 bytes 55-AA-33 return karta hai (read) 
//      • Write par sirf ACK deta hai, data ignore
//  ACK now pulled LOW **during SCL-LOW → HIGH transition** (spec-accurate)
//
//  How it works:
//  ─────────────
//  master 8 bits bhejta hai
//  slave:  SCL low rehte hi SDA low kheenchega (ACK)
//  SCL high hote hi master ACK sample karega
// ===========================================================================
`timescale 1ns/1ps
module i2c_slave_demo #(
    parameter [6:0] SLAVE_ADDR = 7'h50     // default 0x50
)(
    inout tri scl,
    inout tri sda
);

    // ── open-drain driver
    reg sda_drv /* synthesis keep */ = 1'b0;  // 1 = drive LOW
    assign sda = sda_drv ? 1'b0 : 1'bz;

    // ── fixed payload for read demo
    reg [7:0] rom [0:2];
    initial begin
        rom[0] = 8'h55;
        rom[1] = 8'hAA;
        rom[2] = 8'h33;
    end

    // ── local state machine
   parameter [1:0] IDLE = 2'b00,
                ADDR = 2'b01,
                TX   = 2'b10,
                RX   = 2'b11;

    reg [1:0] st = IDLE;

    reg [7:0] sh;
    integer   bitcnt;
    integer   idx;

    // ── START  (SDA ↓ while SCL ↑)
    always @(negedge sda) if (scl) begin
        st     <= ADDR;
        sh     <= 0;
        bitcnt <= 7;
        idx    <= 0;
    end

    // ── SCL rising edge : sample incoming bit
    always @(posedge scl) begin
        case (st)
          ADDR: begin
              sh[bitcnt] <= sda;
              if (bitcnt == 0) begin
                  if (sh[7:1] == SLAVE_ADDR) begin
                      st      <= (sh[0]) ? TX : RX;   // R/W decide
                  end else
                      st <= IDLE;                      // wrong address
              end
              bitcnt <= bitcnt - 1;
          end

          RX:begin
            bitcnt <= bitcnt - 1;
           end                   // just counting

          default: ;                                   // no action in TX
        endcase
    end

    // ── SCL *falling* edge : drive ACK or data bit
    always @(negedge scl) begin
        // default release
        if (sda_drv) sda_drv <= 1'b0;

        case (st)
          // ---------- ACK after address or write-data ----------
          ADDR: begin
              if (bitcnt == -1) begin   // just after 8th bit sampled
                  sda_drv <= 1'b1;      // pull low for ACK
                  bitcnt   <= 7;
              end
          end
          RX: begin                     // write from master
              if (bitcnt == -1) begin
                  sda_drv <= 1'b1;      // ACK each data byte
                  bitcnt   <= 8;
              end
          end
          // ---------- Send data during read ----------
          TX: begin
              sda_drv <= ~rom[idx][7];  // drive 0s, release for 1s
              rom[idx] <= {rom[idx][6:0],1'b0};
              bitcnt   <= bitcnt - 1;
              if (bitcnt == 0) begin
                  idx    <= idx + 1;
                  if (idx == 3)
                      st <= IDLE;       // only 3 bytes
                  bitcnt <= 7;
              end
          end
        endcase
    end

    // ── STOP  (SDA ↑ while SCL ↑)
    always @(posedge sda) if (scl) st <= IDLE;

endmodule


