// +FHDR-------------------------------------------------------------------
// FILE NAME: FIFO_1to6.v
// TYPE: module
// DEPARTMENT:
// AUTHOR: Zhixing Zhang
// AUTHOR'S EMAIL: 785584784@qq.com
// ------------------------------------------------------------------------
// KEYWORDS: FIFO
// ------------------------------------------------------------------------
// PARAMETERS
// OUTPUT_WIDTH    = 128
// STAGE_OUT_WIDTH = 56
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

module FIFO_1to6 #(
    parameter OUTPUT_WIDTH    = 128,
    parameter STAGE_OUT_WIDTH = 56
) (
    input                             clk_i    ,
    input                             rst_i    ,
    input  wire [   OUTPUT_WIDTH-9:0] data_in0 , //pixels for re-use
    input  wire [STAGE_OUT_WIDTH-1:0] data_in1 , //left pixels
    output reg  [   OUTPUT_WIDTH-1:0] data_out0, //another output
    output reg  [STAGE_OUT_WIDTH-9:0] data_out1, //new left pixels
    output reg  [              119:0] data_reg   //pixels for re-use
);

    always@(posedge clk_i)
        begin
            if(rst_i)
                begin
                    data_out0 <= 0;
                    data_out1 <= 0;
                    data_reg  <= 0;
                end
            else
                begin
                    data_out0 <= { data_in1[7:0] , data_in0 };
                    data_out1 <= data_in1[STAGE_OUT_WIDTH-1:8];
                    data_reg  <= { data_in1[7:0] , data_in0[OUTPUT_WIDTH-9:8] };
                end
        end

endmodule

