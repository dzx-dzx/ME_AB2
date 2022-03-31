module CurBuffer (
    input               clk       ,
    input               rst       ,
    input               next_block, // To send the next_block
    input               read_en   ,
    input  wire [ 31:0] cur_in    , // 4 pixels
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
        for (i = 0; i < 32; i = i + 1)
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
            addr <= addr + 32;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            half        <= 0;
            at_inter    <= 0;
            inter_state <= 0;
        end
        else begin
            if (next_block) begin
                half     <= ~half;
                at_inter <= 1;
            end
            else if (at_inter) begin
                if (inter_state == 6)
                    at_inter <= 0;
                else
                    inter_state <= inter_state + 1;
            end
            else;
        end
    end

    always @(*) begin
        if (at_inter) begin
            case ({half, inter_state})
                // next block in in buffer 0
                4'b0000 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
                4'b0001 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
                4'b0010 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
                4'b0011 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
                4'b0100 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
                4'b0101 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
                4'b0110 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_1[511 : 448];
                end
                4'b1000 : begin
                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                4'b1001 : begin
                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                4'b1010 : begin
                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                4'b1011 : begin
                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                4'b1100 : begin
                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                4'b1101 : begin
                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                4'b1110 : begin
                    out_row_1 <= buffer_1[63 : 0];
                    out_row_2 <= buffer_1[127 : 64];
                    out_row_3 <= buffer_1[191 : 128];
                    out_row_4 <= buffer_1[255 : 192];
                    out_row_5 <= buffer_1[319 : 256];
                    out_row_6 <= buffer_1[383 : 320];
                    out_row_7 <= buffer_1[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                default : ;
            endcase
        end
        // Not at inter
        else begin
            case (half)
                // Buffer 0 in cur block
                1'b0 : begin
                    out_row_1 <= buffer_0[63 : 0];
                    out_row_2 <= buffer_0[127 : 64];
                    out_row_3 <= buffer_0[191 : 128];
                    out_row_4 <= buffer_0[255 : 192];
                    out_row_5 <= buffer_0[319 : 256];
                    out_row_6 <= buffer_0[383 : 320];
                    out_row_7 <= buffer_0[447 : 384];
                    out_row_8 <= buffer_0[511 : 448];
                end
                // Buffer 1 in cur block
                1'b1 : begin
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