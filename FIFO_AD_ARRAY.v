`include "FIFO.v"
`include "AD_ARRAY.v"
`include "ADD_8.v"
`include "MIN_16.v"

module FIFO_AD_ARRAY#(
    parameter PIXELS_IN_BATCH = 16,
    parameter EDGE_LEN        = 8 ,
    parameter BIT_DEPTH       = 8 ,
    parameter SAD_BIT_WIDTH   = 14,
    parameter PSAD_BIT_WIDTH  = 11
)(
    input           clk_i,
    input           rst_n_i,
    input  [ 183:0] data_in,
    input  [1023:0] reference_input_column,
    input [EDGE_LEN*EDGE_LEN*BIT_DEPTH-1:0] cur_out,
    output [SAD_BIT_WIDTH-1:0] MSAD_interim,
    output [3:0] MSAD_index_interim
);

// Parameters

// Ports

FIFO FIFO_dut (
    .clk_i    (clk_i                           ),
    .rst_i    (rst_n_i                         ),
    .data_in  (data_in                         ),
    .data_out0(reference_input_column[127:0]   ),
    .data_out1(reference_input_column[255:128] ),
    .data_out2(reference_input_column[383:256] ),
    .data_out3(reference_input_column[511:384] ),
    .data_out4(reference_input_column[639:512] ),
    .data_out5(reference_input_column[767:640] ),
    .data_out6(reference_input_column[895:768] ),
    .data_out7(reference_input_column[1023:896])
);


wire [EDGE_LEN*EDGE_LEN*BIT_DEPTH-1:0] current_input_complete;

genvar i,j;
generate
    for(i=0;i<EDGE_LEN;i=i+1)
        begin
            for(j=0;j<EDGE_LEN;j=j+1)
                begin
                    assign current_input_complete[((EDGE_LEN-j-1)*EDGE_LEN+i+1)*BIT_DEPTH-1:((EDGE_LEN-j-1)*EDGE_LEN+i)*BIT_DEPTH] = cur_out[(i*EDGE_LEN+j+1)*BIT_DEPTH-1:(i*EDGE_LEN+j)*BIT_DEPTH];
                end
        end
endgenerate

wire [(PSAD_BIT_WIDTH)*EDGE_LEN*PIXELS_IN_BATCH-1:0] psad_addend_batch;

AD_ARRAY #(
    .PIXELS_IN_BATCH(PIXELS_IN_BATCH),
    .EDGE_LEN       (EDGE_LEN       ),
    .BIT_DEPTH      (BIT_DEPTH      ),
    .PSAD_BIT_WIDTH (PSAD_BIT_WIDTH )
) ad_array (
    .clk                   (clk_i                 ),
    .rst                   (rst_n_i               ),
    .reference_input_column(reference_input_column),
    .current_input_complete(current_input_complete),
    .psad_addend_batch     (psad_addend_batch     )
);

wire [PIXELS_IN_BATCH*SAD_BIT_WIDTH-1:0] SAD_batch_interim;

generate
    for(i=0;i<PIXELS_IN_BATCH;i=i+1)
        begin
            wire [SAD_BIT_WIDTH*EDGE_LEN-1:0] psad_addend;
            for(j=0;j<EDGE_LEN;j=j+1)
                begin
                    assign psad_addend[(j+1)*SAD_BIT_WIDTH-1:j*SAD_BIT_WIDTH] = {{SAD_BIT_WIDTH-PSAD_BIT_WIDTH{1'b0}},psad_addend_batch[(j*PIXELS_IN_BATCH+i+1)*PSAD_BIT_WIDTH-1:(j*PIXELS_IN_BATCH+i)*PSAD_BIT_WIDTH]};
                end
            ADD_8 #(
                .ELEMENT_BIT_DEPTH(SAD_BIT_WIDTH)
            ) add_8 (
                .addend_array(psad_addend),
                .add(SAD_batch_interim[(i+1)*SAD_BIT_WIDTH-1:i*SAD_BIT_WIDTH])
            );
        end
endgenerate

MIN_16 #(
    .ELEMENT_BIT_DEPTH(SAD_BIT_WIDTH)
) min_16(
    .min_array(SAD_batch_interim),
    .min(MSAD_interim),
    .min_index(MSAD_index_interim)
);


endmodule
