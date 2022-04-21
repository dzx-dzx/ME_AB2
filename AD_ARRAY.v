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

module AD_ARRAY #(
    parameter PIXELS_IN_BATCH = 16,
    parameter EDGE_LEN        = 8 ,
    parameter BIT_DEPTH       = 8 ,
    parameter PSAD_BIT_WIDTH  = 11
) (
    input                                                      rst                   ,
    input                                                      clk                   ,
    input      [       EDGE_LEN*PIXELS_IN_BATCH*BIT_DEPTH-1:0] reference_input_column,
    input      [              EDGE_LEN*EDGE_LEN*BIT_DEPTH-1:0] current_input_complete,
    output reg [(PSAD_BIT_WIDTH)*EDGE_LEN*PIXELS_IN_BATCH-1:0] psad_addend_batch
);

    wire [PIXELS_IN_BATCH*BIT_DEPTH-1:0] reference_in_internal [0:EDGE_LEN-1][0:EDGE_LEN-1];
    wire [PIXELS_IN_BATCH*BIT_DEPTH-1:0] reference_out_internal[0:EDGE_LEN-1][0:EDGE_LEN-1];

    // wire [(EDGE_LEN+BIT_DEPTH)*EDGE_LEN*PIXELS_IN_BATCH-1:0] AD_in_internal;
    wire [(PSAD_BIT_WIDTH)*PIXELS_IN_BATCH-1:0] psad_in_internal [0:EDGE_LEN-1][0:EDGE_LEN-1];
    wire [(PSAD_BIT_WIDTH)*PIXELS_IN_BATCH-1:0] psad_out_internal[0:EDGE_LEN-1][0:EDGE_LEN-1];

    wire [(PSAD_BIT_WIDTH)*PIXELS_IN_BATCH-1:0] psad_addend_internal[0:EDGE_LEN-1];


    // assign AD_in_internal=psad_out_internal[(EDGE_LEN+BIT_DEPTH)*EDGE_LEN*EDGE_LEN*PIXELS_IN_BATCH-1:(EDGE_LEN+BIT_DEPTH)*(EDGE_LEN-1)*EDGE_LEN*PIXELS_IN_BATCH];

    genvar i, j;
    generate
        for(i=0;i<EDGE_LEN;i=i+1)begin
            assign psad_in_internal[0][i] = 0;
        end
    endgenerate
    generate
        for (i = 0; i < EDGE_LEN; i = i + 1)
            begin
                assign reference_in_internal[i][EDGE_LEN-1] = reference_input_column[(i+1)*PIXELS_IN_BATCH*BIT_DEPTH-1:i*PIXELS_IN_BATCH*BIT_DEPTH];

                for (j = 0; j < EDGE_LEN; j = j + 1)
                    begin
                        AD #(
                            .PIXELS_IN_BATCH          (PIXELS_IN_BATCH),
                            .BIT_DEPTH                (BIT_DEPTH),
                            .INPUT_PSAD_BITS_PER_PIXEL(PSAD_BIT_WIDTH),
                            .DEBUG_I(i),
                            .DEBUG_J(j)
                        ) ad (
                            .reference_input (reference_in_internal[i][j] ),
                            .current         (current_input_complete[(i*EDGE_LEN+j+1)*BIT_DEPTH-1:(i*EDGE_LEN+j)*BIT_DEPTH]),
                            .psad_input      (psad_in_internal[i][j]),
                            .reference_output(reference_out_internal[i][j]),
                            .psad_output     (psad_out_internal[i][j])
                        );
                        if (j > 0)
                            begin
                                FF #(
                                    .BITS(PIXELS_IN_BATCH * BIT_DEPTH)
                                ) ff_reference (
                                    .clk(clk),
                                    .in(reference_out_internal[i][j]),
                                    .out(reference_in_internal[i][j-1])
                                );
                            end

                    end
                for (j = 0; j < EDGE_LEN; j = j + 1)
                    begin
                        if (i < EDGE_LEN - 1)
                            begin
                                FF #(
                                    .BITS((PSAD_BIT_WIDTH) * PIXELS_IN_BATCH )
                                ) ff_psad (
                                    .clk(clk),
                                    .in(psad_out_internal[i][j]),
                                    .out(psad_in_internal[i+1][j])
                                );
                            end
                        else
                            begin
                                FF #(
                                    .BITS((PSAD_BIT_WIDTH) * PIXELS_IN_BATCH )
                                ) ff_psad (
                                    .clk(clk),
                                    .in(psad_out_internal[i][j]),
                                    .out(psad_addend_internal[j])
                                );
                            end
                    end


            end
    endgenerate

    generate
        for(i = 0; i < EDGE_LEN; i = i + 1)begin
            always @(psad_addend_internal[i])
                begin
                    psad_addend_batch = psad_addend_internal[i];
                end
            end
        endgenerate

    endmodule
