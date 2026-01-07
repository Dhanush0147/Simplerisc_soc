module MEM_SLAVE (
    input  wire        PCLK,
    input  wire        PRESETn,
    input  wire [31:0] PADDR,
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PWDATA,
    output      [31:0] PRDATA,
    output reg         PREADY,
    output reg         PSLVERR
);



    // APB3 transfer detection
  //  wire apb_transfer = PSEL_mem & PENABLE;
  //  wire valid_addr = (PADDR[7:0] <= 8'd255); // 0x2000000-0x20003FF

    // Instantiate memory_module
    memory_module mem_controller (
        .clk(PCLK),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PWRITE(PWRITE)
    );


     

    // APB3 slave logic
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            PREADY <= 1'b0;
            PSLVERR <= 1'b0;
            
        end
        else begin
            PSLVERR <= 1'b0;
             PREADY <= 1'b1;
        end
    end

endmodule
