`include "FIFO.v"
`include "AD_ARRAY.v"
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

initial begin
    begin
        $dumpfile("FIFO_AD_ARRAY.vcd");
        $dumpvars(0, FIFO_AD_ARRAY_tb);
        cur_out=0;
        data_in={8'hda,8'h2e,8'hca,8'h45,8'h7f,8'hce,8'h8a,8'h96,8'hc8,8'h06,8'h47,8'h18,8'h20,8'h4e,8'hc2,8'h75,8'h08,8'h37,8'h87,8'hab,8'h67,8'hac,8'h3b};
        #10 data_in={8'h3b,8'hac,8'h67,8'hab,8'h87,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #10 data_in={8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h3b,8'hac,8'h67,8'hab,8'h87,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #10 data_in={8'h20,8'h18,8'h47,8'h06,8'hc8,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h3b,8'hac,8'h67,8'hab,8'h87,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #10 data_in={8'h96,8'h8a,8'hce,8'h7f,8'h45,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h3b,8'hac,8'h67,8'hab,8'h87,8'hca,8'h2e,8'hda};
        #10 data_in={8'h7f,8'h45,8'hca,8'h2e,8'hda,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h3b,8'hac,8'h67,8'hab,8'h87};
        #10 data_in={8'h3b,8'hac,8'h67,8'hab,8'h87,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #10 data_in={8'h3b,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'hac,8'h67,8'hab,8'h87,8'h37,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #10 data_in={8'h3b,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'hac,8'h67,8'hab,8'h87,8'h37,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #10 data_in={8'h3b,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'hac,8'h67,8'hab,8'h87,8'h37,8'h2e,8'hda};
        #5000 $finish;
    end
end

always
    #5  clk_i = ! clk_i ;
initial
    begin
        rst_n_i = 1;
        #6 rst_n_i=0;
    end
endmodule
