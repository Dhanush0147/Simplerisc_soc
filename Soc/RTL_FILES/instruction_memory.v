
///////////////////////////////////////////////////////////////////////////////
// Instruction Memory
///////////////////////////////////////////////////////////////////////////////
// Stores program instructions. Indexed by address.
// Outputs the instruction at the given address.
/*module instruction_memory(address,instruction);
input [31:0]address;
output reg [31:0]instruction;

reg [31:0]i_mem[255:0];// 256-entry memory   



 
initial 
begin
        // Sample program initialization
        //memory stores the instruction to calculate the febonacci series till the number stored at r0 and store it in r1
        i_mem[0]  = 32'b01101000000000000000000000000000;   //nop
        i_mem[1]  = 32'b0;
        i_mem[2]  = 32'b0;
        i_mem[3]  = 32'b0;
        i_mem[4]  = 32'b01001100010000000000000000000000;  //mov r1,0
        i_mem[5]  = 32'b0;
        i_mem[6]  = 32'b0;
        i_mem[7]  = 32'b0;
        i_mem[8]  = 32'b01001100100000000000000000000001;  //mov r2,1
        i_mem[9]  = 32'b0;
        i_mem[10]  = 32'b0;
        i_mem[11]  = 32'b0;
        i_mem[12] = 32'b01001100000000000000000000000111;   //mov r0,7
        i_mem[13]  = 32'b0;
        i_mem[14]  = 32'b0;
        i_mem[15]  = 32'b0;
        i_mem[16]  = 32'b00101100000000000000000000000000;    // cmp r0,0
        i_mem[17]  = 32'b0;
        i_mem[18]  = 32'b0;
        i_mem[19]  = 32'b0;
        i_mem[20]  = 32'b10000000000000000000000000001101;  //beq end  
        i_mem[21]  = 32'b0;
        i_mem[22]  = 32'b0;
        i_mem[23]  = 32'b0;
        i_mem[24]  = 32'b00101100000000000000000000000001;    //cmp r0,1 
        i_mem[25]  = 32'b0;
        i_mem[26]  = 32'b0;
        i_mem[27]  = 32'b0; 
        i_mem[28]  = 32'b10000000000000000000000000001010;   //beq movr2 
        i_mem[29]  = 32'b0;
        i_mem[30]  = 32'b0;
        i_mem[31]  = 32'b0;
        i_mem[32]  = 32'b01001100110000000000000000000010;    //mov r3,2
        i_mem[33]  = 32'b0;
        i_mem[34]  = 32'b0;
        i_mem[35]  = 32'b0;
        i_mem[36]  = 32'b00000001000001001000000000000000;    //loop : add r4,r1,r2
        i_mem[37]  = 32'b0;
        i_mem[38]  = 32'b0;
        i_mem[39]  = 32'b0;
        i_mem[40]  = 32'b01001000010000001000000000000000;    //mov r1,r2
        i_mem[41]  = 32'b0;
        i_mem[42]  = 32'b0;
        i_mem[43]  = 32'b0;
        i_mem[44]  = 32'b01001000100000010000000000000000;  //mov r2,r4
        i_mem[45]  = 32'b0;
        i_mem[46]  = 32'b0;
        i_mem[47]  = 32'b0;
        i_mem[48]  = 32'b00000100110011000000000000000001; //add r3,r3,1
        i_mem[49]  = 32'b0;
        i_mem[50]  = 32'b0;
        i_mem[51]  = 32'b0;
        i_mem[52]  = 32'b00101000000000001100000000000000; //cmp r0,r3
        i_mem[53]  = 32'b0;
        i_mem[54]  = 32'b0;
        i_mem[55]  = 32'b0;
        i_mem[56]  = 32'b10001111111111111111111111111011; //bgt loop
        i_mem[57]  = 32'b0;
        i_mem[58]  = 32'b0;
        i_mem[59]  = 32'b0;
        i_mem[60]  = 32'b01001000010000001000000000000000; //mov r1,r2
        i_mem[61]  = 32'b0;
        i_mem[62]  = 32'b0;
        i_mem[63]  = 32'b0;
        i_mem[64]  = 32'b10010000000000000000000000000010;  //b end
        i_mem[68]  = 32'b01001000010000001000000000000000;  //movr2 : mov r1,r2
        i_mem[72]  = 32'b11111000000000000000000000000000;  //end : hlt
       
end

always @(*)
begin
     instruction <= i_mem[address];     
end
endmodule*/

///////////////////////////////////////////////////////////////////////////////
// Instruction Memory
///////////////////////////////////////////////////////////////////////////////
// Stores program instructions. Indexed by address.
// Outputs the instruction at the given address.
module instruction_memory(address,instruction);
input [31:0]address;
output reg [31:0]instruction;


reg [31:0]i_mem[255:0];// 256-entry memory   
integer i ,file,status;
reg [31:0]inst;
initial
begin
/// Initialize memory with instructions from a file
        file = $fopen("C:\\Users\\raqeeb\\Downloads\\assembler\\output.bin", "r");
        if (file == 0) begin
            $display("Error opening instruction file.");
            $finish;
        end

        i = 0;
        while (!$feof(file)) begin
            status = $fscanf(file, "%b\n", inst);
            if (status == 1) begin
                i_mem[i] = inst;
                i = i + 1;
            end
        end

        $fclose(file);
end

 /*
initial 
begin
        // Sample program initialization
        //memory stores the instruction to calculate the febonacci series till the number stored at r0 and store it in r1
        i_mem[0]  = 32'b01001000010000010000000000000000;   //mov r1,0
        i_mem[1]  = 32'b0;
        i_mem[2]  = 32'b0;
        i_mem[3]  = 32'b0;
        i_mem[4]  = 32'b00000001010011001000000000000000;  //mov r2,1
        i_mem[5]  = 32'b0;
        i_mem[6]  = 32'b0;
        i_mem[7]  = 32'b0;
        i_mem[8]  = 32'b00110000110001001000000000000000;  //mov r0,10
        
        i_mem[9]  = 32'b0;
        i_mem[10]  = 32'b0;
        i_mem[11]  = 32'b0;
        i_mem[12] = 32'b01001000100000001100000000000000;   //cmp r0,0 
        i_mem[13]  = 32'b0;
        i_mem[14]  = 32'b0;
        i_mem[15]  = 32'b0;
        i_mem[16]  = 32'b01001000110000010100000000000000;    //beq end
        i_mem[17]  = 32'b0;
        i_mem[18]  = 32'b0;
        i_mem[19]  = 32'b0;
        i_mem[20]  = 32'b00000000100001001000000000000000; //nop 
        i_mem[21]  = 32'b0;
        i_mem[22]  = 32'b0;
        i_mem[23]  = 32'b0;
        i_mem[24]  = 32'b00000000010010001100000000000000;    //nop 
        i_mem[25]  = 32'b0;
        i_mem[26]  = 32'b0;
        i_mem[27]  = 32'b0; 
        i_mem[28]  = 32'b00010000010010001100000000000000;   //cmp r0,1
        i_mem[29]  = 32'b0;
        i_mem[30]  = 32'b0;
        i_mem[31]  = 32'b0;
        i_mem[32]  = 32'b01001101000000000000000000000010;    //beq movr2
        i_mem[33]  = 32'b0;
        i_mem[34]  = 32'b0;
        i_mem[35]  = 32'b0;
        i_mem[36]  = 32'b10101000000000000000000000000000;    //nop
        i_mem[37]  = 32'b0;
        i_mem[38]  = 32'b0;
        i_mem[39]  = 32'b0;
        i_mem[40]  = 32'b01101000000000000000000000000000;    //nop
        i_mem[41]  = 32'b0;
        i_mem[42]  = 32'b0;
        i_mem[43]  = 32'b0;
        i_mem[44]  = 32'b01001100110000000000000000000010;  //mov r3,2
        i_mem[45]  = 32'b0;
        i_mem[46]  = 32'b0;
        i_mem[47]  = 32'b0;
        i_mem[48]  = 32'b00000001000001001000000000000000; //loop : add r4,r1,r2
        i_mem[49]  = 32'b0;
        i_mem[50]  = 32'b0;
        i_mem[51]  = 32'b0;
        i_mem[52]  = 32'b01001000010000001000000000000000; //mov r1,r2
        i_mem[53]  = 32'b0;
        i_mem[54]  = 32'b0;
        i_mem[55]  = 32'b0;
        i_mem[56]  = 32'b01001000100000010000000000000000; //mov r2,r4
        i_mem[57]  = 32'b0;
        i_mem[58]  = 32'b0;
        i_mem[59]  = 32'b0;
        i_mem[60]  = 32'b00000100110011000000000000000001; //add r3,r3,1
        i_mem[61]  = 32'b0;
        i_mem[62]  = 32'b0;
        i_mem[63]  = 32'b0;
        i_mem[64]  = 32'b00101000000000001100000000000000;  //cmp r0,r3
        i_mem[68]  = 32'b10001111111111111111111111111011;  //bgt loop
        i_mem[72]  = 32'b01101000000000000000000000000000;  //nop
        i_mem[76]  = 32'b01101000000000000000000000000000; //nop
        i_mem[80]  = 32'b01001000010000001000000000000000;  //mov r1,r2
        i_mem[84]  = 32'b10010000000000000000000000000100;   //b end
        i_mem[88]  = 32'b01101000000000000000000000000000;    //nop
        i_mem[92]  = 32'b01101000000000000000000000000000;     //nop
        i_mem[96]  = 32'b01001000010000001000000000000000;    //movr2 : mov r1,r2
        i_mem[100]  = 32'b11111000000000000000000000000000;   //end : hlt
       
end
*/
always @(*)
begin
     instruction <= i_mem[address];     
end
endmodule

