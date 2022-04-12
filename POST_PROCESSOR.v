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

module POST_PROCESSOR #(parameter SAD_BIT_WIDTH=14) (
    input                          clk               ,
    input                          rst               ,
    input      [SAD_BIT_WIDTH-1:0] MSAD_interim      ,
    input      [              3:0] MSAD_index_interim,
    input                          en                ,
    input      [              4:0] current_row       ,
    output reg [SAD_BIT_WIDTH-1:0] MSAD              ,
    output reg [              4:0] MSAD_column       ,
    output reg [              4:0] MSAD_row
);
    always @(posedge clk) begin
        if(rst)begin
            MSAD        <= {SAD_BIT_WIDTH{1'b1}};
            MSAD_column <= 0;
            MSAD_row    <= 0;
        end
        else begin
            if(!en)begin
                MSAD        <= {SAD_BIT_WIDTH{1'b1}};
                MSAD_column <= 0;
                MSAD_row    <= 0;
            end
            else if(MSAD>MSAD_interim)begin
                MSAD        <= MSAD_interim;
                MSAD_column <= MSAD_index_interim;
                MSAD_row    <= current_row;

            end
            else begin
                MSAD        <= MSAD;
                MSAD_column <= MSAD_column;
                MSAD_row    <= MSAD_row;
            end
        end
    end
endmodule