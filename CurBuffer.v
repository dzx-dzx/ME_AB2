module CurBuffer (
    input               clk       ,
    input               rst       ,
    input               next_block, // To send the next_block
    input               read_en   ,
    input  wire [ 63:0] cur_in    , // 8 pixels
    output wire [511:0] cur_out     // 8*8 pixels
);

    // 2 buffer. each stores 64 pixels
    reg [511:0] buffer_0;
    reg [511:0] buffer_1;
    // reg [7:0] buffer_0[0:63];
    // reg [7:0] buffer_1[0:63];

    reg [8:0] addr; // 0 ~ 511

    reg       half       ;
    reg       at_inter   ;
    reg [2:0] inter_state;

    reg [63:0] out_row_1;
    reg [63:0] out_row_2;
    reg [63:0] out_row_3;
    reg [63:0] out_row_4;
    reg [63:0] out_row_5;
    reg [63:0] out_row_6;
    reg [63:0] out_row_7;
    reg [63:0] out_row_8;

    assign cur_out = {out_row_8, out_row_7, out_row_6, out_row_5,
        out_row_4, out_row_3, out_row_2, out_row_1};

    genvar i;

    generate
        for (i = 0; i < 64; i = i + 1)
            always @ (*) begin
                case (half)
                    // buffer_0 is valid and write buffer_1
                    1'b0 : begin
                        buffer_1[addr+i] = cur_in[i];
                    end
                    // buffer_1 is valid and write buffer_0
                    1'b1 : begin
                        buffer_0[addr+i] = cur_in[i];
                    end

                endcase
            end
    endgenerate

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addr <= 0;
        end
        else if (read_en) begin
            addr <= addr + 64;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            half <= 0;
        end
        else begin
            if (next_block)
                half <= ~half;
            else ;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            at_inter    <= 0;
            inter_state <= 0;

            out_row_1 <= 0;
            out_row_2 <= 0;
            out_row_3 <= 0;
            out_row_4 <= 0;
            out_row_5 <= 0;
            out_row_6 <= 0;
            out_row_7 <= 0;
            out_row_8 <= 0;
        end
        else begin
            if (next_block)
                at_inter <= 1;
            else ;
            case ({half, at_inter, inter_state})
                // buffer_0 valid not not at inter
                5'b00000 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                // new block is in buffer_0
                5'b01000 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b001;

                    out_row_1 <= {buffer_1[55 : 0], buffer_0[63 : 56]};
                    out_row_2 <= {buffer_1[119 : 64], buffer_0[127 : 120]};
                    out_row_3 <= {buffer_1[183 : 128], buffer_0[191 : 184]};
                    out_row_4 <= {buffer_1[247 : 192], buffer_0[255 : 248]};
                    out_row_5 <= {buffer_1[311 : 256], buffer_0[319 : 312]};
                    out_row_6 <= {buffer_1[375 : 320], buffer_0[383 : 376]};
                    out_row_7 <= {buffer_1[439 : 384], buffer_0[447 : 440]};
                    out_row_8 <= {buffer_1[503 : 448], buffer_0[511 : 504]};
                end
                5'b01001 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b010;

                    out_row_1 <= {buffer_1[47 : 0], buffer_0[63 : 48]};
                    out_row_2 <= {buffer_1[111 : 64], buffer_0[127 : 112]};
                    out_row_3 <= {buffer_1[175 : 128], buffer_0[191 : 176]};
                    out_row_4 <= {buffer_1[239 : 192], buffer_0[255 : 240]};
                    out_row_5 <= {buffer_1[303 : 256], buffer_0[319 : 304]};
                    out_row_6 <= {buffer_1[367 : 320], buffer_0[383 : 368]};
                    out_row_7 <= {buffer_1[431 : 384], buffer_0[447 : 432]};
                    out_row_8 <= {buffer_1[495 : 448], buffer_0[511 : 496]};
                end
                5'b01010 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b011;

                    out_row_1 <= {buffer_1[39 : 0], buffer_0[63 : 40]};
                    out_row_2 <= {buffer_1[103 : 64], buffer_0[127 : 104]};
                    out_row_3 <= {buffer_1[167 : 128], buffer_0[191 : 168]};
                    out_row_4 <= {buffer_1[231 : 192], buffer_0[255 : 232]};
                    out_row_5 <= {buffer_1[295 : 256], buffer_0[319 : 296]};
                    out_row_6 <= {buffer_1[359 : 320], buffer_0[383 : 360]};
                    out_row_7 <= {buffer_1[423 : 384], buffer_0[447 : 424]};
                    out_row_8 <= {buffer_1[487 : 448], buffer_0[511 : 488]};
                end
                5'b01011 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b100;

                    out_row_1 <= {buffer_1[31 : 0], buffer_0[63 : 32]};
                    out_row_2 <= {buffer_1[95 : 64], buffer_0[127 : 96]};
                    out_row_3 <= {buffer_1[159 : 128], buffer_0[191 : 160]};
                    out_row_4 <= {buffer_1[223 : 192], buffer_0[255 : 224]};
                    out_row_5 <= {buffer_1[287 : 256], buffer_0[319 : 288]};
                    out_row_6 <= {buffer_1[351 : 320], buffer_0[383 : 352]};
                    out_row_7 <= {buffer_1[415 : 384], buffer_0[447 : 416]};
                    out_row_8 <= {buffer_1[479 : 448], buffer_0[511 : 480]};
                end
                5'b01100 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b101;

                    out_row_1 <= {buffer_1[23 : 0], buffer_0[63 : 24]};
                    out_row_2 <= {buffer_1[87 : 64], buffer_0[127 : 88]};
                    out_row_3 <= {buffer_1[151 : 128], buffer_0[191 : 152]};
                    out_row_4 <= {buffer_1[215 : 192], buffer_0[255 : 216]};
                    out_row_5 <= {buffer_1[279 : 256], buffer_0[319 : 280]};
                    out_row_6 <= {buffer_1[343 : 320], buffer_0[383 : 344]};
                    out_row_7 <= {buffer_1[407 : 384], buffer_0[447 : 408]};
                    out_row_8 <= {buffer_1[471 : 448], buffer_0[511 : 472]};
                end
                5'b01101 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b110;

                    out_row_1 <= {buffer_1[15 : 0], buffer_0[63 : 16]};
                    out_row_2 <= {buffer_1[79 : 64], buffer_0[127 : 80]};
                    out_row_3 <= {buffer_1[143 : 128], buffer_0[191 : 144]};
                    out_row_4 <= {buffer_1[207 : 192], buffer_0[255 : 208]};
                    out_row_5 <= {buffer_1[271 : 256], buffer_0[319 : 272]};
                    out_row_6 <= {buffer_1[335 : 320], buffer_0[383 : 336]};
                    out_row_7 <= {buffer_1[399 : 384], buffer_0[447 : 400]};
                    out_row_8 <= {buffer_1[463 : 448], buffer_0[511 : 464]};
                end
                5'b01110 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b111;

                    out_row_1 <= {buffer_1[7 : 0], buffer_0[63 : 8]};
                    out_row_2 <= {buffer_1[71 : 64], buffer_0[127 : 72]};
                    out_row_3 <= {buffer_1[135 : 128], buffer_0[191 : 136]};
                    out_row_4 <= {buffer_1[199 : 192], buffer_0[255 : 200]};
                    out_row_5 <= {buffer_1[263 : 256], buffer_0[319 : 264]};
                    out_row_6 <= {buffer_1[327 : 320], buffer_0[383 : 328]};
                    out_row_7 <= {buffer_1[391 : 384], buffer_0[447 : 392]};
                    out_row_8 <= {buffer_1[455 : 448], buffer_0[511 : 456]};
                end
                5'b01111 : begin
                    at_inter    <= 0;
                    inter_state <= 0;

                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                // buffer_1 is valid and not at inter
                5'b10000 : begin
                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
                // new block is in buffer_1
                5'b11000 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b001;

                    out_row_1 <= {buffer_0[55 : 0], buffer_1[63 : 56]};
                    out_row_2 <= {buffer_0[119 : 64], buffer_1[127 : 120]};
                    out_row_3 <= {buffer_0[183 : 128], buffer_1[191 : 184]};
                    out_row_4 <= {buffer_0[247 : 192], buffer_1[255 : 248]};
                    out_row_5 <= {buffer_0[311 : 256], buffer_1[319 : 312]};
                    out_row_6 <= {buffer_0[375 : 320], buffer_1[383 : 376]};
                    out_row_7 <= {buffer_0[439 : 384], buffer_1[447 : 440]};
                    out_row_8 <= {buffer_0[503 : 448], buffer_1[511 : 504]};
                end
                5'b11001 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b010;

                    out_row_1 <= {buffer_0[47 : 0], buffer_1[63 : 48]};
                    out_row_2 <= {buffer_0[111 : 64], buffer_1[127 : 112]};
                    out_row_3 <= {buffer_0[175 : 128], buffer_1[191 : 176]};
                    out_row_4 <= {buffer_0[239 : 192], buffer_1[255 : 240]};
                    out_row_5 <= {buffer_0[303 : 256], buffer_1[319 : 304]};
                    out_row_6 <= {buffer_0[367 : 320], buffer_1[383 : 368]};
                    out_row_7 <= {buffer_0[431 : 384], buffer_1[447 : 432]};
                    out_row_8 <= {buffer_0[495 : 448], buffer_1[511 : 496]};
                end
                5'b11010 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b011;

                    out_row_1 <= {buffer_0[39 : 0], buffer_1[63 : 40]};
                    out_row_2 <= {buffer_0[103 : 64], buffer_1[127 : 104]};
                    out_row_3 <= {buffer_0[167 : 128], buffer_1[191 : 168]};
                    out_row_4 <= {buffer_0[231 : 192], buffer_1[255 : 232]};
                    out_row_5 <= {buffer_0[295 : 256], buffer_1[319 : 296]};
                    out_row_6 <= {buffer_0[359 : 320], buffer_1[383 : 360]};
                    out_row_7 <= {buffer_0[423 : 384], buffer_1[447 : 424]};
                    out_row_8 <= {buffer_0[487 : 448], buffer_1[511 : 488]};
                end
                5'b11011 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b100;

                    out_row_1 <= {buffer_0[31 : 0], buffer_1[63 : 32]};
                    out_row_2 <= {buffer_0[95 : 64], buffer_1[127 : 96]};
                    out_row_3 <= {buffer_0[159 : 128], buffer_1[191 : 160]};
                    out_row_4 <= {buffer_0[223 : 192], buffer_1[255 : 224]};
                    out_row_5 <= {buffer_0[287 : 256], buffer_1[319 : 288]};
                    out_row_6 <= {buffer_0[351 : 320], buffer_1[383 : 352]};
                    out_row_7 <= {buffer_0[415 : 384], buffer_1[447 : 416]};
                    out_row_8 <= {buffer_0[479 : 448], buffer_1[511 : 480]};
                end
                5'b11100 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b101;

                    out_row_1 <= {buffer_0[23 : 0], buffer_1[63 : 24]};
                    out_row_2 <= {buffer_0[87 : 64], buffer_1[127 : 88]};
                    out_row_3 <= {buffer_0[151 : 128], buffer_1[191 : 152]};
                    out_row_4 <= {buffer_0[215 : 192], buffer_1[255 : 216]};
                    out_row_5 <= {buffer_0[279 : 256], buffer_1[319 : 280]};
                    out_row_6 <= {buffer_0[343 : 320], buffer_1[383 : 344]};
                    out_row_7 <= {buffer_0[407 : 384], buffer_1[447 : 408]};
                    out_row_8 <= {buffer_0[471 : 448], buffer_1[511 : 472]};
                end
                5'b11101 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b110;

                    out_row_1 <= {buffer_0[15 : 0], buffer_1[63 : 16]};
                    out_row_2 <= {buffer_0[79 : 64], buffer_1[127 : 80]};
                    out_row_3 <= {buffer_0[143 : 128], buffer_1[191 : 144]};
                    out_row_4 <= {buffer_0[207 : 192], buffer_1[255 : 208]};
                    out_row_5 <= {buffer_0[271 : 256], buffer_1[319 : 272]};
                    out_row_6 <= {buffer_0[335 : 320], buffer_1[383 : 336]};
                    out_row_7 <= {buffer_0[399 : 384], buffer_1[447 : 400]};
                    out_row_8 <= {buffer_0[463 : 448], buffer_1[511 : 464]};
                end
                5'b11110 : begin
                    at_inter    <= 1;
                    inter_state <= 3'b111;

                    out_row_1 <= {buffer_0[7 : 0], buffer_1[63 : 8]};
                    out_row_2 <= {buffer_0[71 : 64], buffer_1[127 : 72]};
                    out_row_3 <= {buffer_0[135 : 128], buffer_1[191 : 136]};
                    out_row_4 <= {buffer_0[199 : 192], buffer_1[255 : 200]};
                    out_row_5 <= {buffer_0[263 : 256], buffer_1[319 : 264]};
                    out_row_6 <= {buffer_0[327 : 320], buffer_1[383 : 328]};
                    out_row_7 <= {buffer_0[391 : 384], buffer_1[447 : 392]};
                    out_row_8 <= {buffer_0[455 : 448], buffer_1[511 : 456]};
                end
                5'b11111 : begin
                    at_inter    <= 0;
                    inter_state <= 0;

                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
            endcase
        end
    end


endmodule