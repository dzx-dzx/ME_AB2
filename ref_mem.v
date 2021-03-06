// +FHDR-------------------------------------------------------------------
// FILE NAME: ref_mem.v
// TYPE: Test Module
// DEPARTMENT:
// AUTHOR: Yaotian Liu
// AUTHOR'S EMAIL: henry_liu@sjtu.edu.cn
// ------------------------------------------------------------------------
// KEYWORDS:
// ------------------------------------------------------------------------
// PARAMETERS
// None
// ------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy: ~
// Clock Domains: ~
// Critical Timing: ~
// Test Features: ~
// Asynchronous I/F: ~
// Scan Methodology: ~
// Instantiations: ~
// -FHDR-------------------------------------------------------------------

module ref_mem (
    input             clk     ,
    input             rst     ,
    input             read_en ,
    output reg [63:0] ref_data
);
    reg [7:0] ref_mem[0:23945800];

    reg [31:0] addr;

    initial
        $readmemh("./data_preprocess/data/ref_processed.txt", ref_mem);

    always @(posedge clk) begin
        if (rst)
            addr <= 0;
        else if (read_en) begin
            addr <= addr + 8;
        end
    end

    always @(addr) begin
        ref_data[7:0]   = ref_mem[addr + 7];
        ref_data[15:8]  = ref_mem[addr + 6];
        ref_data[23:16] = ref_mem[addr + 5];
        ref_data[31:24] = ref_mem[addr + 4];
        ref_data[39:32] = ref_mem[addr + 3];
        ref_data[47:40] = ref_mem[addr + 2];
        ref_data[55:48] = ref_mem[addr + 1];
        ref_data[63:56] = ref_mem[addr];
    end

endmodule