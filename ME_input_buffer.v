// +FHDR-------------------------------------------------------------------
// FILE NAME: ME_input_buffer.v
// TYPE: module
// DEPARTMENT:
// AUTHOR: Yaotian Liu
// AUTHOR'S EMAIL: henry_liu@sjtu.edu.cn
// ------------------------------------------------------------------------
// KEYWORDS:
// ------------------------------------------------------------------------
// PARAMETERS
//
// ------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy: Synchronous & High valid
// Clock Domains: Global
// Critical Timing: ~
// Test Features: ~
// Asynchronous I/F: ~
// Scan Methodology: ~
// Instantiations: ~
// -FHDR-------------------------------------------------------------------

module ME_input_buffer (
    input             clk     ,
    input             rst     ,
    input             en_i    ,
    input      [31:0] cur_in_i,
    input      [63:0] ref_in_i,
    output reg        en_o    ,
    output reg [31:0] cur_in_o,
    output reg [63:0] ref_in_o
);
    always @(posedge clk) begin
        if (rst) begin
            en_o     <= 0;
            cur_in_o <= 0;
            ref_in_o <= 0;
        end
        else begin
            en_o     <= en_i;
            cur_in_o <= cur_in_i;
            ref_in_o <= ref_in_i;
        end
    end

endmodule