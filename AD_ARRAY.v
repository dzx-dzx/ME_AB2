`include "AD.v"
`include "FF.v"
`include "A.v"
module AD_ARRAY #(
        parameter PIXELS_IN_BATCH = 16,
        parameter EDGE_LEN = 8,
        parameter LOG_EDGE_LEN = 3,
        parameter BIT_DEPTH = 8
    ) (
        input rst,
        input clk,
        input [EDGE_LEN*PIXELS_IN_BATCH*BIT_DEPTH-1:0] reference_input_column,
        input [EDGE_LEN*EDGE_LEN*BIT_DEPTH-1:0] current_input_complete,
        output reg [PIXELS_IN_BATCH*(2*LOG_EDGE_LEN+BIT_DEPTH)-1:0] SAD
    );

    wire [EDGE_LEN*EDGE_LEN*PIXELS_IN_BATCH*BIT_DEPTH-1:0] reference_in_internal;
    wire [EDGE_LEN*EDGE_LEN*PIXELS_IN_BATCH*BIT_DEPTH-1:0] reference_out_internal;

    // wire [(EDGE_LEN+BIT_DEPTH)*EDGE_LEN*PIXELS_IN_BATCH-1:0] AD_in_internal;
    wire [(LOG_EDGE_LEN+BIT_DEPTH)*EDGE_LEN*EDGE_LEN*PIXELS_IN_BATCH-1:0] psad_in_internal ;
    wire [(LOG_EDGE_LEN+BIT_DEPTH)*EDGE_LEN*EDGE_LEN*PIXELS_IN_BATCH-1:0] psad_out_internal;

    wire [(LOG_EDGE_LEN+BIT_DEPTH)*EDGE_LEN*PIXELS_IN_BATCH-1:0] psad_addend_internal;

    assign psad_in_internal[(LOG_EDGE_LEN+BIT_DEPTH)*EDGE_LEN*PIXELS_IN_BATCH-1:0] = 0;
    // assign AD_in_internal=psad_out_internal[(EDGE_LEN+BIT_DEPTH)*EDGE_LEN*EDGE_LEN*PIXELS_IN_BATCH-1:(EDGE_LEN+BIT_DEPTH)*(EDGE_LEN-1)*EDGE_LEN*PIXELS_IN_BATCH];

    genvar i, j;
    generate
        for (i = 0; i < EDGE_LEN; i = i + 1)
        begin
            assign reference_in_internal[((i+1)*EDGE_LEN)*PIXELS_IN_BATCH*BIT_DEPTH-1:((i+1)*EDGE_LEN-1)*PIXELS_IN_BATCH*BIT_DEPTH] = reference_input_column[(i+1)*PIXELS_IN_BATCH*BIT_DEPTH-1:i*PIXELS_IN_BATCH*BIT_DEPTH];

            for (j = 0; j < EDGE_LEN; j = j + 1)
            begin
                AD #(
                       .PIXELS_IN_BATCH          (PIXELS_IN_BATCH),
                       .BIT_DEPTH                (BIT_DEPTH),
                       .INPUT_PSAD_BITS_PER_PIXEL(LOG_EDGE_LEN + BIT_DEPTH)
                   ) ad (
                       .reference_input (reference_in_internal[(i*EDGE_LEN+j+1)*PIXELS_IN_BATCH*BIT_DEPTH-1:(i*EDGE_LEN+j)*PIXELS_IN_BATCH*BIT_DEPTH] ),
                       .current         (current_input_complete[(i*EDGE_LEN+j+1)*BIT_DEPTH-1:(i*EDGE_LEN+j)*BIT_DEPTH]                                ),
                       .psad_input      (psad_in_internal[(i*EDGE_LEN+j)*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH+(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:(i*EDGE_LEN+j)*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH]),
                       .reference_output(reference_out_internal[(i*EDGE_LEN+j+1)*PIXELS_IN_BATCH*BIT_DEPTH-1:(i*EDGE_LEN+j)*PIXELS_IN_BATCH*BIT_DEPTH]),
                       .psad_output     (psad_out_internal[(i*EDGE_LEN+j)*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH+(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:(i*EDGE_LEN+j)*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH])
                   );
                if (j > 0)
                begin
                    FF #(
                           .BITS(PIXELS_IN_BATCH * BIT_DEPTH)
                       ) ff_reference (
                           .clk(clk),
                           .in(reference_out_internal[(i*EDGE_LEN+j+1)*PIXELS_IN_BATCH*BIT_DEPTH-1:(i*EDGE_LEN+j)*PIXELS_IN_BATCH*BIT_DEPTH]),
                           .out(reference_in_internal[(i*EDGE_LEN+j)*PIXELS_IN_BATCH*BIT_DEPTH-1:(i*EDGE_LEN+j-1)*PIXELS_IN_BATCH*BIT_DEPTH])
                       );
                end

            end

            if (i < EDGE_LEN - 1)
            begin
                FF #(
                       .BITS((LOG_EDGE_LEN + BIT_DEPTH) * PIXELS_IN_BATCH * EDGE_LEN)
                   ) ff_psad (
                       .clk(clk),
                       .in(psad_out_internal[(i+1)*EDGE_LEN*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:i*EDGE_LEN*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH]),
                       .out(psad_in_internal[(i+2)*EDGE_LEN*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:(i+1)*EDGE_LEN*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH])
                   );
            end
            else
            begin
                FF #(
                       .BITS((LOG_EDGE_LEN + BIT_DEPTH) * PIXELS_IN_BATCH * EDGE_LEN)
                   ) ff_psad (
                       .clk(clk),
                       .in(psad_out_internal[(i+1)*EDGE_LEN*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:i*EDGE_LEN*(LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH]),
                       .out(psad_addend_internal)
                   );
            end

        end
    endgenerate

    wire [(2*LOG_EDGE_LEN+BIT_DEPTH)*EDGE_LEN*PIXELS_IN_BATCH-1:0] psad_a_in_internal;
    wire [(2*LOG_EDGE_LEN+BIT_DEPTH)*EDGE_LEN*PIXELS_IN_BATCH-1:0] psad_a_out_internal;

    assign psad_a_in_internal[EDGE_LEN*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:(EDGE_LEN-1)*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH] = 0;

    // localparam ADDEND_BIT_DEPTH = LOG_EDGE_LEN + BIT_DEPTH;
    // localparam PSAD_BIT_DEPTH = 2 * LOG_EDGE_LEN + BIT_DEPTH;

    generate
        for (i = 0; i < EDGE_LEN; i = i + 1)
        begin
            A #(
                  .PIXELS_IN_BATCH (PIXELS_IN_BATCH),
                  .ADDEND_BIT_DEPTH(LOG_EDGE_LEN + BIT_DEPTH),
                  .PSAD_BIT_DEPTH  (2 * LOG_EDGE_LEN + BIT_DEPTH)
              ) a (
                  .psad_ad_input(psad_a_in_internal[(i+1)*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:i*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH]),
                  .psad_ad_addend(psad_addend_internal[(i+1)*(LOG_EDGE_LEN + BIT_DEPTH)*PIXELS_IN_BATCH-1:i*(LOG_EDGE_LEN + BIT_DEPTH)*PIXELS_IN_BATCH]),
                  .psad_ad_output(psad_a_out_internal[(i+1)*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:i*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH])
              );
            if(i>0)
            begin
                FF #(
                       .BITS((2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH)
                   ) ff_a (
                       .clk(clk),
                       .in (psad_a_out_internal[(i+1)*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:i*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH]),
                       .out(psad_a_in_internal[(i)*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:(i-1)*(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH])
                   );
            end
        end
    endgenerate
    always @(*)
    begin
        SAD=psad_a_out_internal[(2*LOG_EDGE_LEN+BIT_DEPTH)*PIXELS_IN_BATCH-1:0];
    end
endmodule
