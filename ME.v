`timescale 1 ns / 1 ns
`include "RefSRAM.v"
`include "CurBuffer.v"
`include "FIFO.v"
`include "AD_ARRAY.v"
`include "MIN_16.v"
`include "ADD_8.v"
`include "ME_input_buffer.v"
module ME #(
    parameter PIXELS_IN_BATCH = 16,
    parameter EDGE_LEN        = 8 ,
    parameter BIT_DEPTH       = 8 ,
    parameter SAD_BIT_WIDTH   = 14,
    parameter PSAD_BIT_WIDTH  = 11
)(
    input                           clk               ,
    input                           rst               ,
    input                           en_i              ,
    input  wire [             31:0] cur_in_i          , // 4 pixels
    input  wire [             63:0] ref_in_i          , // 8 pixels
    output wire [             31:0] cur_mem_addr      ,
    output wire [             31:0] ref_mem_addr      ,
    output wire                     cur_mem_en        ,
    output wire                     ref_mem_en        ,
    output wire [SAD_BIT_WIDTH-1:0] MSAD_interim      ,
    output wire [              3:0] MSAD_index_interim
);

wire        en    ;
wire [31:0] cur_in;
wire [63:0] ref_in;

ME_input_buffer U_ME_input_buffer (
    .clk     (clk     ),
    .rst     (rst     ),
    .en_i    (en_i    ),
    .cur_in_i(cur_in_i),
    .ref_in_i(ref_in_i),
    .en_o    (en      ),
    .cur_in_o(cur_in  ),
    .ref_in_o(ref_in  )
);

assign cur_mem_en = en;
assign ref_mem_en = en;

// RefSRAM related
wire         ref_read_en ;
reg  [ 13:0] ref_line_cnt; //Every row (4096) costs 11086 (482 blocks * 23 cycles/block) cycles, which needs 14 bits to store and count.
wire [183:0] ref_out     ;
wire         sram_ready  ; // When the SRAM is ready, set high for one cycle.
wire         next_block  ;


// -------------------------

// CurBuffer related
wire [511:0] cur_out; // Data output from CurBuffer to AD;

// -------------------------

RefSRAM U_RefSRAM (
    .clk         (clk         ),
    .rst         (rst         ),
    .en          (en          ),
    .ref_in      (ref_in      ),
    .ref_out     (ref_out     ),
    .ref_mem_addr(ref_mem_addr),
    .sram_ready  (sram_ready  ),
    .next_block  (next_block  )
);

CurBuffer U_CurBuffer (
    .clk         (clk         ),
    .rst         (rst         ),
    .en          (en          ),
    .next_block  (next_block  ),
    .cur_in      (cur_in      ),
    .cur_out     (cur_out     ),
    .cur_mem_addr(cur_mem_addr)
);

wire [1023:0] reference_input_column;

FIFO fifo (
    .clk_i    (clk                             ),
    .rst_i    (rst                             ),
    .data_in  (ref_out                         ),
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
    .clk                   (clk                   ),
    .rst                   (rst                   ),
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
