///////////////////////////////////////////////////////////////////////////////
// SimpleRisc Processor - Single Cycle Implementation
///////////////////////////////////////////////////////////////////////////////
// Implements a 32-bit  processor with 16 registers and basic instruction set
// Key Features:
// - 32-bit data path
// - 16 general-purpose registers
// - 256-instruction memory capacity
// - Arithmetic, logical, branch, and memory operations
module processor (
    input         clk,
    input         rst,
    input         pc_rst,

    // CSR interface
    input  [31:0] data_out_csr,
    output [4:0]  rd_write_csr,
    output [4:0]  rd_read_csr,
    output        isWbcsr,
    output        isRdcsr,
    output [31:0] data_in_csr,

    // Interrupt interface
    input         interrupt_pin_high,
    input         interrupt_pin_low,
    output        Iret,
    output        watchdog_rst,

    // APB interface
    output        transfer_abp,
    output [31:0] proc_addr,
    output        proc_write,
    output [31:0] proc_wdata,
    input  [31:0] proc_rdata,
    
    input ext_clk,
    input write_en,
    input prg_mode,
    input [31:0]instruction,
    input [31:0]dummy_pc
);


// Central Data Bus Connections and  Control Signals
wire [31:0]pcplus4_top,pc_next_top,pc_top,instruction_top,immx_top,branch_target_top,rd1_top,rd2_top,a_top,b_top,alu_result_top,pc_branch_top,ldresult_out_top,data_top;
wire [3:0]RS1_top,RS2_top,RD_top,ra_top,rs1_ra_top,rs2_rd_top,rd_ra_top,r15_r12_top;
wire isbranchtaken_top,isRet_top,isSt_top,isWb_top,isImmediate_top,isBeq_top,isBgt_top,isUbranch_top,isLd_top,isCall_top,GT_flag_top,EQ_flag_top,isWbcsr_top,isRdcsr_top,isIret_top;
wire [13:0]alusignals_top;
wire [1:0]flags_top,flags_out_top;
wire interrupt_out_top;
wire [31:0]pc_isr_top;

// Program Counter update logic using mux: chooses between PC+4 and branch address
mux2x1 m1(
    .x(pcplus4_top),
    .z(pc_branch_top),
    .sel(isbranchtaken_top),
    .rst(rst),
    .y(pc_next_top)
    );
// Program Counter register
program_counter pc1(
        .clk(clk),
        .rst(rst),
        .pc_rst(pc_rst),
        .interrupt(interrupt_out_top),
        .pc_isr(pc_isr_top),
        .pcnext(pc_next_top),
        .pc(pc_top)
        );
// Fetch instruction from memory
//instruction_memory im1(.address(pc_top),.instruction(instruction_top));
instruction_mem_flash instruction_mem(
     .ext_clk(ext_clk),
     .clk(clk),
     .write_en(write_en),
     .prg_mode(prg_mode),
     .instruction_flash(instruction), 
     .address(pc_top), 
     .dummy_pc(dummy_pc), 
     .instruction_pc(instruction_top)  
    );
// Calculate PC+4 for next sequential instruction
pc_plus4 pc41(
        .clk(clk),
        .pc(pc_top),
        .pcplus4(pcplus4_top)
        );
// Decode instruction to extract register addresses
instruction_decode id1(
        .clk(clk),
        .rst(rst),
        .instruction(instruction_top),
        .RS1(RS1_top),
        .RS2(RS2_top),
        .RD(RD_top),
        .ra(ra_top)
        );
// Generate immediate value and branch target from instruction
immediate_generator ig1(
        .isCall(isCall_top),
        .isWbCsr(isWbcsr_top),
        .pc(pc_top),
        .instruction(instruction_top),
        .immx(immx_top),
        .branch_target(branch_target_top)
        );
// Select correct PC for branch/return operations
mux2x1 m6(
        .x(branch_target_top),
        .z(rd1_top),
        .sel(isRet_top  ),
        .rst(rst),
        .y(pc_branch_top)
        );
// Generate all control signals from instruction
control_unit cu1(
    .instruction(instruction_top) ,
    .isRet(isRet_top),
    .isSt(isSt_top),
    .isWb(isWb_top),
    .isImmediate(isImmediate_top),
    .alusignals(alusignals_top),
    .isBeq(isBeq_top),
    .isBgt(isBgt_top),
    .isUbranch(isUbranch_top),
    .isLd(isLd_top),
    .isCall(isCall_top),
    .isWbcsr(isWbcsr_top),
    .isRdcsr(isRdcsr_top),
    .isIret(isIret_top)
    );
// Multiplexers for register file addressing
mux2x1_4bit m11(
        .x(4'd15),
        .z(4'd12),
        .sel(isIret_top),
        .rst(rst),
        .y(r15_r12_top)
        );
mux2x1_4bit m2(
        .x(RS1_top),
        .z(r15_r12_top),
        .sel(isRet_top),
        .rst(rst),
        .y(rs1_ra_top)
        );

mux2x1_4bit m3(
        .x(RS2_top),
        .z(RD_top),
        .sel(isSt_top),
        .rst(rst),
        .y(rs2_rd_top)
        );

mux2x1_4bit m4(
        .x(RD_top),
        .z(ra_top),
        .sel(isCall_top),
        .rst(rst),
        .y(rd_ra_top)
        );
// Register file: holds general-purpose registers
register__file rf1(
        .clk(clk),
        .flags_in(flags_top),
        .flags_out(flags_out_top),
        .pc(pcplus4_top),
        .rs1(rs1_ra_top),
        .rs2(rs2_rd_top),
        .interrupt(interrupt_out_top),
        .rd_ra(rd_ra_top),
        .isWb(isWb_top),
        .data(data_top),
        .rd1(rd1_top),
        .rd2(rd2_top)
        );
// Select ALU operand: register or immediate
mux2x1 m5(
        .x(rd2_top),
        .z(immx_top),
        .sel(isImmediate_top),
        .rst(rst),.y(b_top)
        );
//multiplexing betwen csr data and processro data
mux2x1 m10(
        .x(rd1_top),
        .z(data_out_csr),
        .sel(isRdcsr_top | isWbcsr_top),
        .rst(rst),.y(a_top)
        );
// ALU: performs arithmetic/logic operations
ALU alu1(
        .a(a_top),
        .b(b_top),
        .alusignals(alusignals_top),
        .result(alu_result_top),
        .flags(flags_top)
        );
// Flag extraction for branch logic
flag f1(
        .rst(rst),
        .Iret(isIret_top),
        .isCMP(alusignals_top[13:9]),
        .csr_flag(alu_result_top[0]),
        .isRdcsr(isRdcsr_top),
        .flags_out_reg(flags_out_top),
        .flags_in(flags_top),
        .GT_flag(GT_flag_top),
        .EQ_flag(EQ_flag_top)
        );
// Branch unit: determines if branch should be taken
branch_unit bu1(
        .EQ_flag(EQ_flag_top),
        .GT_flag(GT_flag_top),
        .isBgt(isBgt_top),
        .isBeq(isBeq_top),
        .isUbranch(isUbranch_top),
        .isBranchtaken(isbranchtaken_top)
        );
// Data memory unit: handles load/store
//memory_unit mu1(.clk(clk),.isLd(isLd_top),.isSt(isSt_top),.address(alu_result_top),.data_in(rd2_top),.data_out(ldresult_out_top));
// Select data to write back to register file
mux3x1 m7(
        .in0(alu_result_top),
        .in1(proc_rdata/*ldresult_out_top*/),
        .in2(pcplus4_top),
        .sel({isCall_top,isLd_top}), 
        .out(data_top)
         );

interrupt_handler ih(
     .clk(clk),
     .interrupt_pin_high(interrupt_pin_high),
     .interrupt_pin_low(interrupt_pin_low),
     .interrupt_out(interrupt_out_top),
     .pc_isr(pc_isr_top)
);
reg [31:0] prev_pc;

always @(posedge clk or posedge rst) begin
    if (rst)
        prev_pc <= 32'd0;
    else
        prev_pc <= pc_top;
end
watchdog_rst_counter wc(
     .clk(clk),
     .present_pc(pc_top),
     .previous_pc(prev_pc),
     .watchdog_rst(watchdog_rst)
    );


assign rd_write_csr = rd_ra_top;
assign rd_read_csr = rd_ra_top;
assign isWbcsr = isWbcsr_top;
assign isRdcsr = isRdcsr_top;
assign data_in_csr = data_top; 
assign Iret = isIret_top;
assign transfer_abp = isLd_top || isSt_top;
assign proc_addr = alu_result_top;
assign proc_write = isSt_top;
assign proc_wdata = rd2_top;
endmodule
