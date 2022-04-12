// +FHDR-------------------------------------------------------------------
// FILE NAME: FIFO
// TYPE: verilog
// DEPARTMENT:
// AUTHOR: Zhixing Zhang
// AUTHOR'S EMAIL: 785584784@qq.com
// ------------------------------------------------------------------------
// KEYWORDS:
// ------------------------------------------------------------------------
// PARAMETERS
//
// ------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy:
// Clock Domains:
// Critical Timing:
// Test Features:
// Asynchronous I/F:
// Scan Methodology:
// Instantiations:
// -FHDR-------------------------------------------------------------------

module FIFO_0 (
    input               clk_i    ,
    input               rst_i    ,
    input  wire [183:0] data_in  ,
    output reg  [127:0] data_out0, //first output
    output reg  [ 55:0] data_out1, //left pixels
    output reg  [119:0] data_reg0  //pixels for re-use
);

    always@(posedge clk_i)
        begin
            if(rst_i)
                begin
                    data_out0 <= 0;
                    data_out1 <= 0;
                    data_reg0 <= 0;
                end
            else
                begin
                    data_out0 <= data_in[127:0];
                    data_out1 <= data_in[183:128];
                    data_reg0 <= data_in[127:8];
                end
        end

endmodule
