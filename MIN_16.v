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

module MIN_16 #(parameter ELEMENT_BIT_DEPTH = 14) (
    input      [ELEMENT_BIT_DEPTH*16-1:0] min_array,
    output reg [   ELEMENT_BIT_DEPTH-1:0] min      ,
    output reg [                   4-1:0] min_index
);
    localparam ELEMENTS = 16;
    genvar i;
    generate
        wire [ELEMENT_BIT_DEPTH*8-1:0] min_intermediate_1;
        wire [8*1-1:0] min_intermediate_index_1;
        for(i=0;i<8;i=i+1)
            begin
                MIN_LEAF #(
                    .BIT_WIDTH(ELEMENT_BIT_DEPTH)
                ) min_leaf(
                    .element0(min_array[(2*i+1)*ELEMENT_BIT_DEPTH-1:(2*i)*ELEMENT_BIT_DEPTH]),
                    .element1(min_array[(2*i+2)*ELEMENT_BIT_DEPTH-1:(2*i+1)*ELEMENT_BIT_DEPTH]),
                    .index(min_intermediate_index_1[i:i]),
                    .element(min_intermediate_1[(i+1)*ELEMENT_BIT_DEPTH-1:i*ELEMENT_BIT_DEPTH])
                );
            end

        wire [ELEMENT_BIT_DEPTH*4-1:0] min_intermediate_2      ;
        wire [                4*2-1:0] min_intermediate_index_2;
        for(i=0;i<4;i=i+1)
            begin
                MIN #(
                    .BIT_WIDTH(ELEMENT_BIT_DEPTH),
                    .PREVIOUS_INDEX_WIDTH(1)
                ) min(
                    .element0(min_intermediate_1[(2*i+1)*ELEMENT_BIT_DEPTH-1:(2*i)*ELEMENT_BIT_DEPTH]),
                    .element1(min_intermediate_1[(2*i+2)*ELEMENT_BIT_DEPTH-1:(2*i+1)*ELEMENT_BIT_DEPTH]),
                    .previous_index0(min_intermediate_index_1[2*i:2*i]),
                    .previous_index1(min_intermediate_index_1[2*i+1:2*i+1]),
                    .index(min_intermediate_index_2[i*2+1:i*2]),
                    .element(min_intermediate_2[(i+1)*ELEMENT_BIT_DEPTH-1:i*ELEMENT_BIT_DEPTH])
                );
            end

        wire [ELEMENT_BIT_DEPTH*2-1:0] min_intermediate_3      ;
        wire [                2*3-1:0] min_intermediate_index_3;
        for(i=0;i<2;i=i+1)
            begin
                MIN #(
                    .BIT_WIDTH(ELEMENT_BIT_DEPTH),
                    .PREVIOUS_INDEX_WIDTH(2)
                ) min(
                    .element0(min_intermediate_2[(2*i+1)*ELEMENT_BIT_DEPTH-1:(2*i)*ELEMENT_BIT_DEPTH]),
                    .element1(min_intermediate_2[(2*i+2)*ELEMENT_BIT_DEPTH-1:(2*i+1)*ELEMENT_BIT_DEPTH]),
                    .previous_index0(min_intermediate_index_2[i*4+1:i*4]),
                    .previous_index1(min_intermediate_index_2[i*4+3:i*4+2]),
                    .index(min_intermediate_index_3[i*3+2:i*3]),
                    .element(min_intermediate_3[(i+1)*ELEMENT_BIT_DEPTH-1:i*ELEMENT_BIT_DEPTH])
                );
            end

        wire [ELEMENT_BIT_DEPTH-1:0] min_intermediate_4      ;
        wire [              1*4-1:0] min_intermediate_index_4;
        for(i=0;i<1;i=i+1)
            begin
                MIN #(
                    .BIT_WIDTH(ELEMENT_BIT_DEPTH),
                    .PREVIOUS_INDEX_WIDTH(3)
                ) min(
                    .element0(min_intermediate_3[(2*i+1)*ELEMENT_BIT_DEPTH-1:(2*i)*ELEMENT_BIT_DEPTH]),
                    .element1(min_intermediate_3[(2*i+2)*ELEMENT_BIT_DEPTH-1:(2*i+1)*ELEMENT_BIT_DEPTH]),
                    .previous_index0(min_intermediate_index_3[i*6+2:i*6]),
                    .previous_index1(min_intermediate_index_3[i*6+5:i*6+3]),
                    .index(min_intermediate_index_4[i*4+3:i*4]),
                    .element(min_intermediate_4[(i+1)*ELEMENT_BIT_DEPTH-1:i*ELEMENT_BIT_DEPTH])
                );
            end
    endgenerate
    always @(*)
        begin
            min       = min_intermediate_4;
            min_index = min_intermediate_index_4;
        end
endmodule
