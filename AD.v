module AD #(
    parameter PIXELS_IN_BATCH           = 16,
    // parameter EDGE_LEN  = 8,
    parameter BIT_DEPTH                 = 8 ,
    parameter INPUT_PSAD_BITS_PER_PIXEL = 11
) (
    input      [                PIXELS_IN_BATCH*BIT_DEPTH-1:0] reference_input ,
    input      [                                BIT_DEPTH-1:0] current         ,
    input      [INPUT_PSAD_BITS_PER_PIXEL*PIXELS_IN_BATCH-1:0] psad_input      ,
    output reg [                PIXELS_IN_BATCH*BIT_DEPTH-1:0] reference_output,
    output reg [INPUT_PSAD_BITS_PER_PIXEL*PIXELS_IN_BATCH-1:0] psad_output
);
    // wire [INPUT_PSAD_BITS_PER_PIXEL-1:0] psad_input_unpacked[0:PIXELS_IN_BATCH-1];
    // // genvar j;
    // // generate
    // //     for (j = 0; j < PIXELS_IN_BATCH; j = j + 1)
    // //     begin
    // //         assign psad_input_unpacked[j] = psad_input[(j+1)*INPUT_PSAD_BITS_PER_PIXEL-1:j*INPUT_PSAD_BITS_PER_PIXEL];
    // //     end
    // // endgenerate
    always @(reference_input)
        begin
            reference_output <= reference_input;
        end

    genvar i;
    generate
        for (i = 0; i < PIXELS_IN_BATCH; i = i + 1)
            begin
                always @(*)
                    begin
                        psad_output[(i+1)*(INPUT_PSAD_BITS_PER_PIXEL)-1:i*(INPUT_PSAD_BITS_PER_PIXEL)]
                            <= psad_input[(i+1)*(INPUT_PSAD_BITS_PER_PIXEL)-1:i*(INPUT_PSAD_BITS_PER_PIXEL)]+(reference_input[(i+1)*BIT_DEPTH-1:i*BIT_DEPTH]>current?
                                reference_input[(i+1)*BIT_DEPTH-1:i*BIT_DEPTH]-current
                                :current-reference_input[(i+1)*BIT_DEPTH-1:i*BIT_DEPTH]);
                    end
                end
        endgenerate

    endmodule
