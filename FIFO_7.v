// +FHDR-------------------------------------------------------------------
// FILE NAME:
// TYPE:
// DEPARTMENT:
// AUTHOR:
// AUTHOR'S EMAIL:
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
