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

module ADD #(parameter BIT_WIDTH=14) (
    input      [BIT_WIDTH-1:0] element0,
    input      [BIT_WIDTH-1:0] element1,
    output reg [BIT_WIDTH-1:0] element
);
    always @(*)
        begin
            element = element0+element1;
        end
endmodule
