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

module FF #(parameter BITS = 16) (
    input      [BITS-1:0] in ,
    input                 clk,
    output reg [BITS-1:0] out
);
    always@(posedge clk)begin
        out <= in;
    end
endmodule
