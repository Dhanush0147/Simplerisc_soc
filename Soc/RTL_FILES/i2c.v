/*`timescale 1ns / 1ps

module i2c(
    input clk,
    input rst,
    input [8:0] prescale,
    input [31:0] PWDATA,
    input PWRITE,
    input PENABLE,
    input PSEL,
    output SCL,
    output reg PREADY,
    output  [31:0] PRDATA,
    output reg interrupt_i2c,
    inout SDA
    );

    ///////////////First here we will generate the start command////////////////////////////////////////////////
    reg [31:0] read_data;//This shift register will be used to recieve data from the slave
    reg start_command;//this commad will take my state from idle to start state 
 ///////////////////////////////////////Here we generate the SCL///////////////////////////////////////////////
reg [2:0] state;
parameter [2:0] IDLE = 3'b000;
parameter [2:0] START = 3'b001;
parameter [2:0] ADDRESS = 3'b010;
parameter [2:0] ACKNOWLEDGEMENT = 3'b011;
parameter [2:0] SEND_DATA = 3'b100;
parameter [2:0] READ_DATA = 3'b101;
parameter [2:0] SEND_ACK = 3'b110;
parameter [2:0] STOP = 3'b111;

*//*always@(posedge clk) begin
            
end*//*
    
wire divided_clk;//This is the clock coming from the frequency divider
 
 SCL_Generator SCL_Generator(
    .rst(rst),
    .clk(clk),
    .prescale(prescale),
    .state(state),
    .scl(divided_clk)
    );
    
/////////////////////////////////////Here we will design the state changes/////////////////////////////////////
*//*  All the thing done here is till start stahe because till then everything is driven by syatem clock
    Later states will be driven by the divided_clk                                                      *//*


 
reg [31:0] bit_cnt;//This is used to count the nunber of bits transferred and we will be using it from ADDRESS stage
reg scl_driver;//This will drive the clock when the divided_clk is not there
reg sda_out;//This signal will drive the bus and float it
reg [1:0] clk_cnt; //This will be only used for the start state 
reg scl_en;//This will enable and disable the prescaled clock
reg ack_bit;//This is the bit where we will store the acknowledgement coming from the slave side
reg [31:0] data;//This shift register will be used to send data to the slave
reg ppwrite;//This will store the bit after sending the address so that accordingly it does to read or write state 

assign SCL = (scl_en)? divided_clk : scl_driver;
assign SDA = (sda_out)? 1'bz : 1'b0;
assign PRDATA = (PSEL && PENABLE && ~PWRITE) ? read_data : 32'bz;
              
                    

always@(posedge clk or posedge rst) begin
     //PRDATA <= read_data;
    if(rst)begin
            start_command <= 1'b0;
            interrupt_i2c <= 1'b0;
        end
        else if(PENABLE & PSEL & PWRITE)begin //just now changed while loading n0 need to start the command
            start_command <= 1'b1;
        end
        else begin
            start_command <= 1'b0;
        end
    if(rst) begin
        state <= IDLE;
        bit_cnt <= 0;
        scl_en <= 0;
        scl_driver <= 1;
        sda_out <= 1;
        clk_cnt <= 0;
        ack_bit <= 1;
    end
    
    case(state)
        IDLE : begin
            PREADY <= 1;
            ack_bit <= 1;
            scl_driver <= 1;
            scl_en <= 0;
            sda_out <= 1;
            clk_cnt <= 0;
            bit_cnt <= 0;
            data <= PWDATA;
            if(start_command) begin
                state <= START;
            end
        end
        
        START : begin
            if(clk_cnt == 0) begin
                PREADY <= 0;
                sda_out <= 0;
                clk_cnt <= clk_cnt + 1;
                ppwrite <= data[24];
            end
            else if(clk_cnt == 1) begin
                scl_driver <= 0;
                clk_cnt <= clk_cnt + 1;
            end
            else begin
                state <= ADDRESS;
                clk_cnt <= 0;
                scl_en <= 1;
                //scl_driver <= 0;//////////////////////////////////////////////////////////////
                bit_cnt <= 0;
                sda_out <= data[31];//////////////////////////////////////
            end
        end
        
        STOP : begin
            if(clk_cnt == 0) begin
                 scl_driver <= 1;
                 clk_cnt <= clk_cnt + 1;
            end
            else if(clk_cnt == 1) begin
                clk_cnt <= clk_cnt + 1;
            end
            else begin
                sda_out <= 1;
                state <= IDLE;
                clk_cnt <= 0;
                interrupt_i2c <= 0;
            end
        end
        
    endcase

end 

///////////////////////////////////////////////Here we will define the state changes after the START stage///////////////////////////////////////////////

always@(divided_clk) begin
    case(state)
        ADDRESS:begin
            if(~divided_clk) begin
                sda_out <= data[31];
            end
        end
        
        SEND_DATA : begin
            if(~divided_clk) begin
                sda_out <= data[31];
            end
        end
    endcase
end

always@(posedge divided_clk) begin

    if(state == ADDRESS) begin
        data <= {data[30:0],1'b0};
        bit_cnt <= bit_cnt + 1;
    end
    
    if(state == ACKNOWLEDGEMENT) begin
        ack_bit <= SDA;  //this id correct but just for testing purpose now commenting this
        //ack_bit <= ack; //just for testing purpose
    end
    
    if(state == SEND_DATA) begin
        data <= {data[30:0],1'b0};
        bit_cnt <= bit_cnt + 1;
    end
    
    if(state == READ_DATA) begin
        //read_data <= {SDA,read_data[30:0]};
        read_data <= {read_data[30:0],SDA};
        bit_cnt <= bit_cnt + 1;
    end
    
end

always@(negedge divided_clk) begin
    case(state)
        ADDRESS : begin
            if(bit_cnt == 8) begin
                sda_out <= 1;
                state <= ACKNOWLEDGEMENT;
            end
        end
        
        ACKNOWLEDGEMENT : begin
        
        ////////////////////////////////////////////////////////////////////////////
        *//* This part is for acknowledgement given recieved by master after address state or while 
           master is sending data *//*
            if(ack_bit == 0) begin
                if(bit_cnt == 32)begin
                    state <= STOP;
                    scl_en <= 0;
                    scl_driver <= 0;
                    sda_out  <= 0;
                    ack_bit <= 1;
                end
                else begin
                    if(!ppwrite) begin
                        state <= SEND_DATA;
                        sda_out <= data[31];
                        ack_bit <= 1;
                    end
                    else begin
                        state <= READ_DATA;
                        bit_cnt <= 0;
                        ack_bit <= 1;
                        sda_out <= 1; // here master is leaving the SDA
                    end
                end
            end
            else begin
                state <= STOP;
                ack_bit <= 1;
                scl_en <= 0;
                scl_driver <= 0;
                sda_out <= 0;
            end
            
        end
        
        //////////////////////////////////////////////////////////////////////////////////////////
        
        SEND_DATA : begin
            if(bit_cnt == 16 || bit_cnt == 24) begin
                state <= ACKNOWLEDGEMENT;
                sda_out <= 1;
            end
            else if(bit_cnt ==32) begin
                state <= ACKNOWLEDGEMENT;
                sda_out <= 1;
            end
//            if(bit_cnt == 32) begin //THis part will be written after we clarify if we need a buffer or not
                
//            end
        end
        
        READ_DATA : begin
            if(bit_cnt == 8 || bit_cnt == 16 || bit_cnt == 24) begin
                state <= SEND_ACK;
                sda_out <= 0;
            end
            else if(bit_cnt == 32) begin
                state <= SEND_ACK;
                sda_out <= 0;
            end
        end
        
        SEND_ACK : begin
            if(bit_cnt == 32) begin
                state <= STOP;
                scl_en <= 0;
                scl_driver <= 0;
                sda_out <= 0;
                //PRDATA <= read_data;        
                interrupt_i2c <= 1;
            end
            else begin
                sda_out <= 1;
                state <= READ_DATA;
            end 
        end
    endcase
end
endmodule
*/
/*`timescale 1ns / 1ps

module I2C(
    input clk,
    input rst,
    input [8:0] prescale,
    input [31:0] PWDATA,
    input PWRITE,
    input PENABLE,
    input PSEL,
    output SCL,
    output reg PREADY,
    output  [31:0] PRDATA,
    output reg interrupt_i2c,
    inout SDA
    );

    ///////////////First here we will generate the start command////////////////////////////////////////////////
    reg [31:0] read_data;//This shift register will be used to recieve data from the slave
    reg start_command;//this commad will take my state from idle to start state 
 ///////////////////////////////////////Here we generate the SCL///////////////////////////////////////////////
reg [2:0] state;
parameter [2:0] IDLE = 3'b000;
parameter [2:0] START = 3'b001;
parameter [2:0] ADDRESS = 3'b010;
parameter [2:0] ACKNOWLEDGEMENT = 3'b011;
parameter [2:0] SEND_DATA = 3'b100;
parameter [2:0] READ_DATA = 3'b101;
parameter [2:0] SEND_ACK = 3'b110;
parameter [2:0] STOP = 3'b111;

*//*always@(posedge clk) begin
            
end*//*
    
wire divided_clk;//This is the clock coming from the frequency divider
 
 SCL_Generator SCL_Generator(
    .rst(rst),
    .clk(clk),
    .prescale(prescale),
    .state(state),
    .scl(divided_clk)
    );
    
/////////////////////////////////////Here we will design the state changes/////////////////////////////////////
*//*  All the thing done here is till start stahe because till then everything is driven by syatem clock
    Later states will be driven by the divided_clk                                                      *//*


 
reg [31:0] bit_cnt;//This is used to count the nunber of bits transferred and we will be using it from ADDRESS stage
reg scl_driver;//This will drive the clock when the divided_clk is not there
reg sda_out;//This signal will drive the bus and float it
reg [1:0] clk_cnt; //This will be only used for the start state 
reg scl_en;//This will enable and disable the prescaled clock
reg ack_bit;//This is the bit where we will store the acknowledgement coming from the slave side
reg [31:0] data;//This shift register will be used to send data to the slave
reg ppwrite;//This will store the bit after sending the address so that accordingly it does to read or write state 

assign SCL = (scl_en)? divided_clk : scl_driver;
assign SDA = (sda_out)? 1'bz : 1'b0;
assign PRDATA =  (PSEL & PENABLE & (~PWRITE)) ? read_data : 32'bz;
always @(posedge clk or posedge rst) begin
     //PRDATA <= read_data;
    if(rst)begin
       start_command <= 1'b0;
       interrupt_i2c <= 1'b0;
        end
        else if(PENABLE & PSEL & PWRITE)begin
                     start_command <= 1'b1;
        end
        else
             begin
                start_command <= 1'b0;
             end
     if(rst)begin
        state <= IDLE;
        bit_cnt <= 0;
        scl_en <= 0;
        scl_driver <= 1;
        sda_out <= 1;
        clk_cnt <= 0;
        ack_bit <= 1;
     end
     
    
    case(state)
        IDLE : begin
            PREADY <= 1;
            ack_bit <= 1;
            scl_driver <= 1;
            scl_en <= 0;
            sda_out <= 1;
            clk_cnt <= 0;
            bit_cnt <= 0;
            data <= PWDATA;
            if(start_command) begin
                state <= START;
            end
        end
       START : begin
            if(clk_cnt == 0) begin
                PREADY <= 0;
                sda_out <= 0;
                clk_cnt <= clk_cnt + 1;
                ppwrite <= data[24];
            end
            else if(clk_cnt == 1) begin
                scl_driver <= 0;
                clk_cnt <= clk_cnt + 1;
            end
            else 
                begin
                    state <= ADDRESS;
                    clk_cnt <= 0;
                    scl_en <= 1;
                    //scl_driver <= 0;//////////////////////////////////////////////////////////////
                    bit_cnt <= 0;
                    sda_out <= data[31];//////////////////////////////////////
            end
        end
        STOP : begin
            if(clk_cnt == 0) begin
                 scl_driver <= 1;
                 clk_cnt <= clk_cnt + 1;
            end
            else if(clk_cnt == 1) begin
                clk_cnt <= clk_cnt + 1;
            end
            else begin
                sda_out <= 1;
                state <= IDLE;
                clk_cnt <= 0;
                interrupt_i2c <= 0;
            end
        end       
    endcase
end 
///////////////////////////////////////////////Here we will define the state changes after the START stage///////////////////////////////////////////////
always@(divided_clk) begin
    case(state)
       ADDRESS:begin
            if(~divided_clk) begin
                sda_out <= data[31];
            end
        end
        
        SEND_DATA : begin
            if(~divided_clk) begin
                sda_out <= data[31];
            end
        end
    endcase
end
always@(posedge divided_clk) begin
    if(state == ADDRESS) begin
        data <= {data[30:0],1'b0};
        bit_cnt <= bit_cnt + 1;
    end
    
    if(state == ACKNOWLEDGEMENT) begin
        ack_bit <= SDA;  //this id correct but just for testing purpose now commenting this
        //ack_bit <= ack; //just for testing purpose
    end
    
    if(state == SEND_DATA) begin
        data <= {data[30:0],1'b0};
        bit_cnt <= bit_cnt + 1;
    end
    
    if(state == READ_DATA) begin
        read_data <= {read_data[30:0],SDA};
        bit_cnt <= bit_cnt + 1;
    end
    
end

always@(negedge divided_clk) begin
    case(state)
        ADDRESS : begin
            if(bit_cnt == 8) begin
                sda_out <= 1;
                state <= ACKNOWLEDGEMENT;
            end
        end
        
        ACKNOWLEDGEMENT : begin
        
        ////////////////////////////////////////////////////////////////////////////
        *//* This part is for acknowledgement given recieved by master after address state or while 
           master is sending data *//*
            if(ack_bit == 0) begin
                if(bit_cnt == 32)begin
                    state <= STOP;
                    scl_en <= 0;
                    scl_driver <= 0;
                    sda_out  <= 0;
                    ack_bit <= 1;
                end
                else begin
                    if(!ppwrite) begin
                        state <= SEND_DATA;
                        sda_out <= data[31];
                        ack_bit <= 1;
                    end
                    else begin
                        state <= READ_DATA;
                        bit_cnt <= 0;
                        ack_bit <= 1;
                        sda_out <= 1; // here master is leaving the SDA
                    end
                end
            end
            else begin
                state <= STOP;
                ack_bit <= 1;
                scl_en <= 0;
                scl_driver <= 0;
                sda_out <= 0;
            end
            
        end
        
        //////////////////////////////////////////////////////////////////////////////////////////
        
        SEND_DATA : begin
            if(bit_cnt == 16 || bit_cnt == 24) begin
                state <= ACKNOWLEDGEMENT;
                sda_out <= 1;
            end
            else if(bit_cnt ==32) begin
                state <= ACKNOWLEDGEMENT;
                sda_out <= 1;
            end
//            if(bit_cnt == 32) begin //THis part will be written after we clarify if we need a buffer or not
                
//            end
        end
        
        READ_DATA : begin
            if(bit_cnt == 8 || bit_cnt == 16 || bit_cnt == 24) begin
                state <= SEND_ACK;
                sda_out <= 0;
            end
            else if(bit_cnt == 32) begin
                state <= SEND_ACK;
                sda_out <= 0;
            end
        end
        
        SEND_ACK : begin
            if(bit_cnt == 32) begin
                state <= STOP;
                scl_en <= 0;
                scl_driver <= 0;
                sda_out <= 0;
               // PRDATA <= read_data;
                interrupt_i2c <= 1;
            end
            else begin
                sda_out <= 1;
                state <= READ_DATA;
            end 
        end
    endcase
end
    
endmodule*/

module i2c(
    input clk,
    input rst,
    input [10:0] I2C_control,
    input [31:0] PWDATA,
    input PWRITE,
    input PENABLE,
    input PSEL,
    output SCL,
    output reg PREADY,
    output  [31:0] PRDATA,
    output reg interrupt_i2c,
    inout SDA
    );

reg scl_en; 
reg start_command;    
reg [31:0] read_data;  
reg [31:0]data; 
reg [3:0]address_count;
reg [5:0]data_count;
reg ack_bit;
reg sda_out;
reg ack_from_master;
reg ack_from_slave;
wire [8:0]prescaler;
reg [18:0]count_prescaler;
wire read_write_signal;
wire [1:0]data_length = I2C_control[10:9];
 
reg [2:0] state;
parameter [2:0] IDLE = 3'b000;
parameter [2:0] START = 3'b001;
parameter [2:0] ADDRESS = 3'b010;
parameter [2:0] ACKNOWLEDGEMENT_FROM_SLAVE = 3'b011;
parameter [2:0] SEND_DATA = 3'b100;
parameter [2:0] READ_DATA = 3'b101;
parameter [2:0] ACKNOWLEDGEMENT_FROM_MASTER = 3'b110;
parameter [2:0] STOP = 3'b111;  

 
SCL_Generator SCL_Generator(
    .rst(rst),
    .clk(clk),
    .scl_en(scl_en),
    .prescale(prescaler),
    .state(state),
    .scl(SCL)
    );   
    
 wire last_byte =  (data_length == 2'b00 && data_count == 6'd8 ) || // 1-byte
                   (data_length == 2'b01 && data_count == 6'd16) || // 2-byte
                   (data_length == 2'b10 && data_count == 6'd24);
    
assign SDA = (sda_out) ? 1'bz : 1'b0;
assign read_write_signal = PWDATA[24];  
assign PRDATA =  (PSEL & PENABLE & (~PWRITE)) ? read_data : 32'bz;
assign prescaler = I2C_control[8:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        //PREADY        <= 1'b0;
        interrupt_i2c <= 1'b0;
        start_command <= 1'b0;
        scl_en        <= 1'b0;      // keep SCL high (released)
        state         <= IDLE;
        address_count  <= 4'd0;
        data_count     <= 6'd0;
        read_data      <= 32'd0;
        ack_bit        <= 1'b0;
        sda_out <= 1'b1;
        count_prescaler <= 0;
    end
    if (PSEL && PENABLE &&  PWRITE)  
                    start_command <= 1'b1;
    else                             
                start_command <= 1'b0;
                
                
    case (state)
            IDLE:    begin
                        data   <= PWDATA;
                        PREADY   <= 1'b1;
                        if(start_command)
                            state  <= START;  
                    end

            START:  begin
                        address_count <= 4'd0;
                        PREADY   <= 1'b0;
                        state  <= ADDRESS;
                        sda_out <= 1'b0;
                        scl_en <= 1'b1; 
                    end
            ADDRESS:begin
                        if(count_prescaler == 2 * prescaler - 1)
                            address_count <= address_count + 1;
                        else
                            count_prescaler <= count_prescaler +1;   
                        if (address_count == 4'd7)
                            state <= ACKNOWLEDGEMENT_FROM_SLAVE;
                    end

            ACKNOWLEDGEMENT_FROM_SLAVE:begin
                                        ack_from_slave <= SDA;
                                        if(count_prescaler == 2 * prescaler)
                                        begin
                                            if (~SDA)                  // ACK received
                                            begin
                                                if(~last_byte)
                                                state <= (read_write_signal ) ? READ_DATA : SEND_DATA;
                                                else 
                                                begin
                                                    state <= STOP;
                                                end
                                            end
                                            else
                                                state <= STOP;
                                        end
                                        else
                                                count_prescaler <= count_prescaler +1;   
                                        end

            SEND_DATA: begin
                        data_count   <= data_count + 1;
                        if ((data_count == 6'd7)  ||
                            (data_count == 6'd15) ||
                            (data_count == 6'd23))
                            state <= ACKNOWLEDGEMENT_FROM_SLAVE;
                      end

            READ_DATA:begin
                        read_data   <= {read_data[30:0], SDA};
                        data_count  <= data_count + 1;
                        if ((data_count == 6'd7)  ||
                            (data_count == 6'd15) ||
                            (data_count == 6'd23))
                            state <= ACKNOWLEDGEMENT_FROM_MASTER;
                      end

            ACKNOWLEDGEMENT_FROM_MASTER:begin
                                            ack_from_master <= SDA;
                                            state   <= last_byte ? STOP   : READ_DATA;    
                                        end
            STOP:   begin
                        interrupt_i2c <= (ack_from_master) ? 1'b1 :interrupt_i2c;
                        state         <= IDLE;
                        scl_en        <= 1'b1;          // hold SCL high
                        sda_out <= 1'b1;
                    end
   endcase
end
always@(negedge clk)
begin
    if (rst) begin
        sda_out <= 1'b1;             // release
    end
    else begin
        case (state)
            START:              sda_out <= 1'b0;                  // SDA↓ while SCL high
            ADDRESS:            sda_out <= data[31];              // MSB first
            ACKNOWLEDGEMENT_FROM_SLAVE : sda_out <= 1'b1;
            READ_DATA:          sda_out <= 1'b1;                  // release, let slave drive
            SEND_DATA:          sda_out <= data[31];              // next TX bit
            ACKNOWLEDGEMENT_FROM_MASTER:
                                sda_out <= last_byte ? 1'b1       // NACK on last byte
                                                     : 1'b0;      // ACK otherwise
            STOP:               sda_out <= 1'b1;                  // SDA↑ while SCL high
            default:            sda_out <= 1'b1;                  // release
        endcase

        if (state == ADDRESS || state == SEND_DATA)
            data <= {data[30:0], 1'b0};
    end



end

endmodule

/*always @(posedge SCL or posedge rst) begin
    if (rst) begin
        state          <= IDLE;
        address_count  <= 4'd0;
        data_count     <= 6'd0;
        read_data      <= 32'd0;
        ack_bit        <= 1'b1;
    end
    else begin
        case (state)
            IDLE:    begin
                        data   <= PWDATA;
                        PREADY   <= 1'b1;
                        if(start_command)
                            state  <= START;  
                    end

            START:  begin
                        address_count <= 4'd0;
                        PREADY   <= 1'b0;
                        state  <= ADDRESS;
                        scl_en <= 1'b1;
                         
                    end

            ADDRESS:begin
                        address_count <= address_count + 1;
                        if (address_count == 4'd7)
                            state <= ACKNOWLEDGEMENT_FROM_SLAVE;
                    end

            ACKNOWLEDGEMENT_FROM_SLAVE:begin
                                        ack_from_slave <= SDA;
                                        if (~SDA)                     // ACK received
                                            if(~last_byte)
                                            state <= (read_write_signal ) ? READ_DATA : SEND_DATA;
                                            else 
                                            begin
                                            //sda_out <= 1'b1;
                                            state <= STOP;
                                            end
                                        else
                                            state <= STOP;              // NACK → abort
                                        end

            SEND_DATA: begin
                        data_count   <= data_count + 1;
                        if ((data_count == 6'd7)  ||
                            (data_count == 6'd15) ||
                            (data_count == 6'd23))
                            state <= ACKNOWLEDGEMENT_FROM_SLAVE;
                      end

            READ_DATA:begin
                        read_data   <= {read_data[30:0], SDA};
                        data_count  <= data_count + 1;
                        if ((data_count == 6'd7)  ||
                            (data_count == 6'd15) ||
                            (data_count == 6'd23))
                            state <= ACKNOWLEDGEMENT_FROM_MASTER;
                      end

            ACKNOWLEDGEMENT_FROM_MASTER:begin
                                            ack_from_master <= SDA;
                                            state   <= last_byte ? STOP   : READ_DATA;    
                                        end

            STOP:   begin
                        interrupt_i2c <= (ack_from_master) ? 1'b1 :interrupt_i2c;
                        state         <= IDLE;
                        scl_en        <= 1'b0;          // hold SCL high
                    end
        endcase
    end
end*/

/*always @(negedge SCL or posedge rst) begin
    if (rst) begin
        sda_out <= 1'b1;             // release
    end
    else begin
        case (state)
            START:              sda_out <= 1'b0;                  // SDA↓ while SCL high
            ADDRESS:            sda_out <= data[31];              // MSB first
            ACKNOWLEDGEMENT_FROM_SLAVE : sda_out <= 1'b1;
            READ_DATA:          sda_out <= 1'b1;                  // release, let slave drive
            SEND_DATA:          sda_out <= data[31];              // next TX bit
            ACKNOWLEDGEMENT_FROM_MASTER:
                                sda_out <= last_byte ? 1'b1       // NACK on last byte
                                                     : 1'b0;      // ACK otherwise
            STOP:               sda_out <= 1'b1;                  // SDA↑ while SCL high
            default:            sda_out <= 1'b1;                  // release
        endcase

        if (state == ADDRESS || state == SEND_DATA)
            data <= {data[30:0], 1'b0};
    end
end
endmodule*/
/*always @(posedge clk or posedge rst) 
begin
        if(rst)begin
           start_command <= 1'b0;
           interrupt_i2c <= 1'b0;
           state <= IDLE;
           address_count <= 3'b000;
           ack_bit <= 1'b1;
           data_count <= 5'b0;
           scl_en <= 1'b0;
        end
        else if(PENABLE & PSEL & PWRITE)
        begin
                start_command <= 1'b1;
        end
        else
             begin
                start_command <= 1'b0;
             end 
       case(state)
        IDLE : begin
                    sda_out <= 1'b1; 
                    PREADY <= 1'b1;
                    if(start_command)
                        state <= START;   
               end
        START : begin
                    sda_out <= 1'b0; 
                    PREADY <= 1'b0;
                    data <= PWDATA;
                    state <= ADDRESS;   
               end
         STOP : begin
            sda_out <= 1'b1;
            //scl_en <= 1'b1;
            state <= IDLE; 
            interrupt_i2c <= 1'b0; 
          end
        endcase
        
end       

always @(posedge SCL)
begin
    case(state)
    ADDRESS : begin
              sda_out <= data[31];
              data <= {data[30:0],1'b0};
              address_count <= address_count + 1;
              if(address_count == 7)
              begin
                    state <= ACKNOWLEDGEMENT_FROM_SLAVE;
              end   
            end
    ACKNOWLEDGEMENT_FROM_SLAVE : begin
                                 if(address_count == 8)
                                    begin
                                        address_count <= 0;
                                        sda_out <= 1'b1;
                                        ack_bit <= SDA;
                                        if(!SDA)
                                            begin
                                            if(!read_write_signal)
                                                state <= SEND_DATA;
                                            else
                                                state <= READ_DATA;    
                                            end 
                                        else
                                            state <= STOP;
                                    end
                                 else 
                                    begin
                                        sda_out <= 1'b1;
                                        ack_bit <= SDA;
                                        if(!ack_bit)
                                            begin
                                                if(data_count == 8 & data_length == 2'b00)
                                                begin
                                                    data_count <= 5'b0;
                                                    state <= STOP;
                                                    //scl_en <= 1'b1;
                                                    //sda_out <= 1'b1;
                                                 end
                                                 else if(data_count == 16 & data_length == 2'b01)
                                                 begin
                                                    data_count <= 5'b0;
                                                    state <= STOP;
                                                    //scl_en <= 1'b1;
                                                    //sda_out <= 1'b1;
                                                 end
                                                 else if(data_count == 24 & data_length == 2'b10)
                                                 begin
                                                    data_count <= 5'b0;
                                                    state <= STOP;
                                                    //scl_en <= 1'b1;
                                                    //sda_out <= 1'b1;
                                                 end
                                                 else
                                                    state <= SEND_DATA;  
                                            end
                                        else
                                            state <= SEND_DATA;        
                                    end 
                                 end
                                  
    SEND_DATA : begin
                sda_out <= data[31];
                data <= {data[30:0],1'b0};  
                data_count <= data_count + 1;
                if(data_count == 7 | data_count == 15 | data_count == 23)
                    begin
                        state <= ACKNOWLEDGEMENT_FROM_SLAVE;     
                     end
                end
  
   READ_DATA : begin
               read_data <= {read_data[30:0],SDA};
               data_count <= data_count + 1;
               if(data_count == 8 | data_count == 16 | data_count == 24)
                    begin
                        state <= ACKNOWLEDGEMENT_FROM_MASTER;     
                     end
                end
    ACKNOWLEDGEMENT_FROM_MASTER : begin
                                    sda_out <= 1'b1;
                                    if(data_count == 8 & data_length == 2'b00)
                                                begin
                                                    data_count <= 5'b0;
                                                    state <= STOP;
                                                    interrupt_i2c <= 1'b1;
                                                 end
                                    else if(data_count == 16 & data_length == 2'b01)
                                                 begin
                                                    data_count <= 5'b0;
                                                    state <= STOP;
                                                    interrupt_i2c <= 1'b1;
                                                 end
                                     else if(data_count == 24 & data_length == 2'b10)
                                                 begin
                                                    data_count <= 5'b0;
                                                    state <= STOP;
                                                    interrupt_i2c <= 1'b1;
                                                 end
                                     else
                                                    state <= READ_DATA;
                                  end
    endcase                                                                
end  */
