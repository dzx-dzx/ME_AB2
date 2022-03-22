module A #(
        parameter PIXELS_IN_BATCH  = 16,
        parameter PSAD_BIT_DEPTH = 14,
        parameter ADDEND_BIT_DEPTH = 11
    ) (
        input      [PIXELS_IN_BATCH*PSAD_BIT_DEPTH-1:0] psad_ad_input ,
        input      [PIXELS_IN_BATCH*ADDEND_BIT_DEPTH-1:0] psad_ad_addend,
        output reg [PIXELS_IN_BATCH*PSAD_BIT_DEPTH-1:0] psad_ad_output
    );


    genvar i;
    generate
        for (i = 0;i < PIXELS_IN_BATCH;i = i + 1)
        begin
            always @(*)
            begin
                psad_ad_output[(i+1)*PSAD_BIT_DEPTH-1:i*PSAD_BIT_DEPTH]=psad_ad_input[(i+1)*PSAD_BIT_DEPTH-1:i*PSAD_BIT_DEPTH]+psad_ad_addend[(i+1)*ADDEND_BIT_DEPTH-1:i*ADDEND_BIT_DEPTH];
            end
        end
    endgenerate
endmodule
