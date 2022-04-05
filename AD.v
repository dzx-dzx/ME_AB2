module AD #(
    parameter PIXELS_IN_BATCH           = 16,
    // parameter EDGE_LEN  = 8,
    parameter BIT_DEPTH                 = 8 ,
    parameter INPUT_PSAD_BITS_PER_PIXEL = 11,
    parameter DEBUG_I                   = 0 ,
    parameter DEBUG_J                   = 0
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
        // always@(*) begin
        //     $display("At %t,AD%d%d receives psad %b and reference input %b, outputting %b",$time,DEBUG_I,DEBUG_J,psad_input,reference_input,psad_output);
        // end
        wire [                BIT_DEPTH-1:0] reference_input_array [0:PIXELS_IN_BATCH-1];
    wire [INPUT_PSAD_BITS_PER_PIXEL-1:0] psad_input_array      [0:PIXELS_IN_BATCH-1];
    wire [                BIT_DEPTH-1:0] reference_output_array[0:PIXELS_IN_BATCH-1];
    wire [INPUT_PSAD_BITS_PER_PIXEL-1:0] psad_output_array     [0:PIXELS_IN_BATCH-1];

    generate
        for (i = 0; i < PIXELS_IN_BATCH; i = i + 1)
            begin

                assign reference_input_array[i]  = reference_input[(i+1)*BIT_DEPTH-1:i*BIT_DEPTH];
                assign psad_input_array[i]       = psad_input[(i+1)*(INPUT_PSAD_BITS_PER_PIXEL)-1:i*(INPUT_PSAD_BITS_PER_PIXEL)];
                assign reference_output_array[i] = reference_output[(i+1)*BIT_DEPTH-1:i*BIT_DEPTH];
                assign psad_output_array[i]      = psad_output[(i+1)*(INPUT_PSAD_BITS_PER_PIXEL)-1:i*(INPUT_PSAD_BITS_PER_PIXEL)];
                initial begin

                    $dumpfile("FIFO_AD_ARRAY.vcd");
                    $dumpvars(0,reference_input_array[i] ,psad_input_array[i]      ,reference_output_array[i],psad_output_array[i]     );
                end
            end
    endgenerate
endmodule
