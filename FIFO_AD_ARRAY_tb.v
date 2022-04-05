`include "FIFO.v"
`include "AD_ARRAY.v"
`include "ADD_8.v"
`include "MIN_16.v"

module FIFO_AD_ARRAY_tb;

// Parameters

// Ports
reg           clk_i                  = 0;
reg           rst_n_i                = 0;
reg  [ 183:0] data_in                   ;
wire [1023:0] reference_input_column    ;

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

parameter PIXELS_IN_BATCH = 16;
parameter EDGE_LEN        = 8 ;
parameter BIT_DEPTH       = 8 ;
parameter SAD_BIT_WIDTH   = 14;
parameter PSAD_BIT_WIDTH  = 11;

reg  [EDGE_LEN*EDGE_LEN*BIT_DEPTH-1:0] cur_out               ;
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

wire [PIXELS_IN_BATCH*SAD_BIT_WIDTH-1:0] SAD_batch_interim ;
wire [                SAD_BIT_WIDTH-1:0] MSAD_interim      ;
wire [                              3:0] MSAD_index_interim;

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

initial begin
    $dumpfile("FIFO_AD_ARRAY.vcd");
    $dumpvars(0, FIFO_AD_ARRAY_tb);

    cur_out=0;
    #10 data_in={8'h0c,8'ha7,8'hec,8'h79,8'he7,8'h2d,8'h17,8'h10,8'h41,8'h65,8'hee,8'h01,8'heb,8'h26,8'h06,8'h69,8'hb1,8'hb7,8'h54,8'hbb,8'hee,8'hdd,8'h13};
    #10 data_in={8'hb4,8'h22,8'hc6,8'h73,8'hc4,8'h41,8'h32,8'h79,8'hf6,8'he7,8'h1c,8'h04,8'h1c,8'h5d,8'ha1,8'h77,8'hd6,8'he6,8'h59,8'hf5,8'h9c,8'he0,8'ha8};
    #10 data_in={8'ha3,8'hdf,8'hcc,8'h92,8'h62,8'hb4,8'h85,8'h9c,8'hf8,8'hd3,8'hae,8'hbb,8'h5e,8'h31,8'h5f,8'h95,8'hf9,8'h74,8'h06,8'he4,8'h4d,8'hf5,8'h95};
    #10 data_in={8'h49,8'h1b,8'hc3,8'h19,8'hdd,8'h1d,8'h4f,8'hac,8'hb4,8'hba,8'hae,8'hc3,8'hf7,8'h38,8'h7f,8'h75,8'h96,8'hf1,8'h3f,8'h6d,8'hc9,8'h16,8'h8d};
    #10 data_in={8'hd9,8'he1,8'h89,8'hcd,8'h4d,8'h52,8'hcb,8'hf3,8'h6a,8'h5c,8'h64,8'ha6,8'h47,8'h22,8'h47,8'h40,8'h88,8'h53,8'hb1,8'hb2,8'hf5,8'h6e,8'h2c};
    #10 data_in={8'h56,8'hf8,8'h26,8'h1d,8'hf0,8'h97,8'h42,8'he7,8'hf2,8'h95,8'h60,8'h9b,8'h9f,8'hf7,8'h15,8'h8b,8'h6e,8'hb3,8'h41,8'hdc,8'h52,8'h34,8'h52};
    #10 data_in={8'h21,8'h6f,8'h7b,8'h74,8'h59,8'ha6,8'h9b,8'h76,8'h14,8'had,8'h58,8'ha6,8'h23,8'h4b,8'h69,8'hf0,8'h32,8'hd9,8'h0b,8'h53,8'h87,8'hee,8'h6e};
    #10 data_in={8'h37,8'h11,8'h1a,8'he7,8'h55,8'hcc,8'h03,8'hd2,8'h8c,8'h94,8'ha4,8'h16,8'hd4,8'h04,8'hd1,8'h4c,8'h60,8'hae,8'h72,8'h0a,8'hdc,8'h57,8'h83};
    #10 data_in={8'h50,8'h40,8'hdf,8'h16,8'hd0,8'h7e,8'h21,8'h8d,8'h41,8'hbd,8'hca,8'h6e,8'h92,8'h72,8'h34,8'hf3,8'hfd,8'h85,8'hcd,8'h52,8'h06,8'h02,8'h3d};
    #10 data_in={8'h70,8'h86,8'h6b,8'hd3,8'hbb,8'h97,8'h89,8'h4a,8'h1f,8'h45,8'h77,8'hf7,8'h10,8'h67,8'h84,8'h51,8'h5f,8'h53,8'h26,8'h47,8'h40,8'h61,8'he9};
    #10 data_in=0;
    #5000 $finish;
end
// generate

//     for(i=0;i<PIXELS_IN_BATCH;i=i+1)
//         begin
//             for(j=0;j<EDGE_LEN;j=j+1)
//                 begin
//                     always @(posedge clk_i) begin
//                         // $display("At%t:i=%d,j=%d,PSAD=%h",$time,i,j,psad_addend_batch[(j*PIXELS_IN_BATCH+i+1)*PSAD_BIT_WIDTH-1:(j*PIXELS_IN_BATCH+i)*PSAD_BIT_WIDTH]);
//                     end
//                 end
//         end
// endgenerate

// wire [PSAD_BIT_WIDTH-1:0] psad_debug [0:PIXELS_IN_BATCH-1][0:EDGE_LEN-1];
// generate
//     for(i=0;i<PIXELS_IN_BATCH;i=i+1)
//         begin
//             for(j=0;j<EDGE_LEN;j=j+1)
//                 begin
//                     assign psad_debug[i][j] = psad_addend_batch[(j*PIXELS_IN_BATCH+i+1)*PSAD_BIT_WIDTH-1:(j*PIXELS_IN_BATCH+i)*PSAD_BIT_WIDTH];
//                     initial begin
//                         $dumpfile("FIFO_AD_ARRAY.vcd");
//                         $dumpvars(0,psad_debug[i][j]);
//                     end
//                 end
//         end
// endgenerate
always
    #5  clk_i = ! clk_i ;
initial
    begin
        rst_n_i = 1;
        #6 rst_n_i=0;
    end
endmodule
