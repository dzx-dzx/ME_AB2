// +FHDR-------------------------------------------------------------------
// FILE NAME: FIFO_7.v
// TYPE: module
// DEPARTMENT:
// AUTHOR: Zhixing Zhang
// AUTHOR'S EMAIL: 785584784@qq.com
// ------------------------------------------------------------------------
// KEYWORDS: FIFO
// ------------------------------------------------------------------------
// PARAMETERS
//
// ------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy: synchronous and high_valid
// Clock Domains: global
// Critical Timing:
// Test Features:
// Asynchronous I/F:
// Scan Methodology:
// Instantiations:
// -FHDR-------------------------------------------------------------------

module FIFO_7 (
    input               clk_i   ,
    input               rst_i   ,
    input  wire [119:0] data_in0,
    input  wire [  7:0] data_in1,
    output reg  [127:0] data_out
);

    always@(posedge clk_i)
        begin
            if(rst_i)
                begin
                    data_out <= 0;
                end
            else
                begin
                    data_out <= { data_in1 , data_in0 };
                end
        end

endmodule
