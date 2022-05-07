// +FHDR-------------------------------------------------------------------
// FILE NAME: cur_mem.v
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

module cur_mem (
    input             clk     ,
    input             rst     ,
    input             read_en ,
    output reg [31:0] cur_data
);
    reg [7:0] cur_mem[0:8300000];

    reg [31:0] addr;

    initial
        $readmemh("./data_preprocess/data/cur_processed.txt", cur_mem);

    always @(posedge clk) begin
        if (rst)
            addr <= 0;
        else if (read_en) begin
            addr <= addr + 4;

            // cur_data[7:0]   <= cur_mem[addr];
            // cur_data[15:8]  <= cur_mem[addr + 1];
            // cur_data[23:16] <= cur_mem[addr + 2];
            // cur_data[31:24] <= cur_mem[addr + 3];
        end
    end

    always @(addr, read_en) begin
        if (read_en) begin
            cur_data[7:0]   = cur_mem[addr];
            cur_data[15:8]  = cur_mem[addr + 1];
            cur_data[23:16] = cur_mem[addr + 2];
            cur_data[31:24] = cur_mem[addr + 3];
        end
        else cur_data = 0;
    end
endmodule