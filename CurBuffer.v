module CurBuffer (
    input               clk       ,
    input               rst       ,
    input               next_block, // To send the next_block
    input               read_en   ,
    input  wire [ 31:0] cur_in    , // 4 pixels
    output wire [511:0] cur_out     // 8*8 pixels
);

    reg [1023:0] cur_buffer; // 128 * 1 pixels

    reg [6:0] addr;

    reg       half     ;
    reg       at_inter ;
    reg [2:0] inter_cnt;

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
                cur_buffer[addr+i] <= cur_in[i];
            end
    endgenerate

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addr <= 0;
        end
        else if (read_en) begin
            addr <= addr + 4;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            at_inter  <= 0;
            inter_cnt <= 0;
            half      <= 0;
        end
        else begin
            if (next_block) begin
                at_inter  <= 1;
                inter_cnt <= 0;
                half      <= ~half;
            end
            if (at_inter) begin
                inter_cnt <= inter_cnt + 1;
                at_inter  <= (inter_cnt == 7) ? 0 : 1;
            end
        end
    end

    always @(*) begin
        case ({half, at_inter, inter_cnt})
            // At left half
            5'b00000 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= cur_buffer[127 : 64];
                out_row_3 <= cur_buffer[191 : 128];
                out_row_4 <= cur_buffer[255 : 192];
                out_row_5 <= cur_buffer[319 : 256];
                out_row_6 <= cur_buffer[383 : 320];
                out_row_7 <= cur_buffer[447 : 384];
                out_row_8 <= cur_buffer[511 : 448];
            end

            // New half is the left one.
            5'b01000 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= {cur_buffer[583 : 576], cur_buffer[127 : 72]};
                out_row_3 <= {cur_buffer[655 : 640], cur_buffer[191 : 144]};
                out_row_4 <= {cur_buffer[727 : 704], cur_buffer[255 : 216]};
                out_row_5 <= {cur_buffer[799 : 768], cur_buffer[319 : 288]};
                out_row_6 <= {cur_buffer[871 : 832], cur_buffer[383 : 360]};
                out_row_7 <= {cur_buffer[943 : 896], cur_buffer[447 : 432]};
                out_row_8 <= {cur_buffer[1015 : 960], cur_buffer[511 : 504]};
            end
            5'b01001 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= cur_buffer[127 : 64];
                out_row_3 <= {cur_buffer[647 : 640], cur_buffer[191 : 136]};
                out_row_4 <= {cur_buffer[719 : 704], cur_buffer[255 : 208]};
                out_row_5 <= {cur_buffer[791 : 768], cur_buffer[319 : 280]};
                out_row_6 <= {cur_buffer[863 : 832], cur_buffer[383 : 352]};
                out_row_7 <= {cur_buffer[935 : 896], cur_buffer[447 : 424]};
                out_row_8 <= {cur_buffer[1007 : 960], cur_buffer[511 : 496]};
            end
            5'b01010 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= cur_buffer[127 : 64];
                out_row_3 <= cur_buffer[191 : 128];
                out_row_4 <= {cur_buffer[711 : 704], cur_buffer[255 : 200]};
                out_row_5 <= {cur_buffer[783 : 768], cur_buffer[319 : 272]};
                out_row_6 <= {cur_buffer[855 : 832], cur_buffer[383 : 344]};
                out_row_7 <= {cur_buffer[927 : 896], cur_buffer[447 : 416]};
                out_row_8 <= {cur_buffer[999 : 960], cur_buffer[511 : 488]};
            end
            5'b01011 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= cur_buffer[127 : 64];
                out_row_3 <= cur_buffer[191 : 128];
                out_row_4 <= cur_buffer[255 : 192];
                out_row_5 <= {cur_buffer[775 : 768], cur_buffer[319 : 264]};
                out_row_6 <= {cur_buffer[847 : 832], cur_buffer[383 : 336]};
                out_row_7 <= {cur_buffer[919 : 896], cur_buffer[447 : 408]};
                out_row_8 <= {cur_buffer[991 : 960], cur_buffer[511 : 480]};
            end
            5'b01100 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= cur_buffer[127 : 64];
                out_row_3 <= cur_buffer[191 : 128];
                out_row_4 <= cur_buffer[255 : 192];
                out_row_5 <= cur_buffer[319 : 256];
                out_row_6 <= {cur_buffer[839 : 832], cur_buffer[383 : 328]};
                out_row_7 <= {cur_buffer[911 : 896], cur_buffer[447 : 400]};
                out_row_8 <= {cur_buffer[983 : 960], cur_buffer[511 : 472]};
            end
            5'b01101 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= cur_buffer[127 : 64];
                out_row_3 <= cur_buffer[191 : 128];
                out_row_4 <= cur_buffer[255 : 192];
                out_row_5 <= cur_buffer[319 : 256];
                out_row_6 <= cur_buffer[383 : 320];
                out_row_7 <= {cur_buffer[903 : 896], cur_buffer[447 : 392]};
                out_row_8 <= {cur_buffer[975 : 960], cur_buffer[511 : 464]};
            end
            5'b01110 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= cur_buffer[127 : 64];
                out_row_3 <= cur_buffer[191 : 128];
                out_row_4 <= cur_buffer[255 : 192];
                out_row_5 <= cur_buffer[319 : 256];
                out_row_6 <= cur_buffer[383 : 320];
                out_row_7 <= cur_buffer[447 : 384];
                out_row_8 <= {cur_buffer[967 : 960], cur_buffer[511 : 456]};
            end
            5'b01111 : begin
                out_row_1 <= cur_buffer[63 : 0];
                out_row_2 <= cur_buffer[127 : 64];
                out_row_3 <= cur_buffer[191 : 128];
                out_row_4 <= cur_buffer[255 : 192];
                out_row_5 <= cur_buffer[319 : 256];
                out_row_6 <= cur_buffer[383 : 320];
                out_row_7 <= cur_buffer[447 : 384];
                out_row_8 <= cur_buffer[511 : 448];
            end

            // At right half
            5'b10000 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= cur_buffer[639 : 576];
                out_row_3 <= cur_buffer[703 : 640];
                out_row_4 <= cur_buffer[767 : 704];
                out_row_5 <= cur_buffer[831 : 768];
                out_row_6 <= cur_buffer[895 : 832];
                out_row_7 <= cur_buffer[959 : 896];
                out_row_8 <= cur_buffer[1023 : 960];
            end

            // New half is right
            5'b11000 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= {cur_buffer[71 : 64] ,cur_buffer[639 : 584]};
                out_row_3 <= {cur_buffer[143 : 128] ,cur_buffer[703 : 656]};
                out_row_4 <= {cur_buffer[215 : 192] ,cur_buffer[767 : 728]};
                out_row_5 <= {cur_buffer[287 : 256] ,cur_buffer[831 : 800]};
                out_row_6 <= {cur_buffer[359 : 320] ,cur_buffer[895 : 872]};
                out_row_7 <= {cur_buffer[431 : 384] ,cur_buffer[959 : 944]};
                out_row_8 <= {cur_buffer[503 : 448] ,cur_buffer[1023 : 1016]};
            end
            5'b11001 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= cur_buffer[639 : 576];
                out_row_3 <= {cur_buffer[135 : 128] ,cur_buffer[703 : 648]};
                out_row_4 <= {cur_buffer[207 : 192] ,cur_buffer[767 : 720]};
                out_row_5 <= {cur_buffer[279 : 256] ,cur_buffer[831 : 792]};
                out_row_6 <= {cur_buffer[351 : 320] ,cur_buffer[895 : 864]};
                out_row_7 <= {cur_buffer[423 : 384] ,cur_buffer[959 : 936]};
                out_row_8 <= {cur_buffer[495 : 448] ,cur_buffer[1023 : 1008]};
            end
            5'b11010 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= cur_buffer[639 : 576];
                out_row_3 <= cur_buffer[703 : 640];
                out_row_4 <= {cur_buffer[199 : 192] ,cur_buffer[767 : 712]};
                out_row_5 <= {cur_buffer[271 : 256] ,cur_buffer[831 : 784]};
                out_row_6 <= {cur_buffer[343 : 320] ,cur_buffer[895 : 856]};
                out_row_7 <= {cur_buffer[415 : 384] ,cur_buffer[959 : 928]};
                out_row_8 <= {cur_buffer[487 : 448] ,cur_buffer[1023 : 1000]};
            end
            5'b11011 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= cur_buffer[639 : 576];
                out_row_3 <= cur_buffer[703 : 640];
                out_row_4 <= cur_buffer[767 : 704];
                out_row_5 <= {cur_buffer[263 : 256] ,cur_buffer[831 : 776]};
                out_row_6 <= {cur_buffer[335 : 320] ,cur_buffer[895 : 848]};
                out_row_7 <= {cur_buffer[407 : 384] ,cur_buffer[959 : 920]};
                out_row_8 <= {cur_buffer[479 : 448] ,cur_buffer[1023 : 992]};
            end
            5'b11100 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= cur_buffer[639 : 576];
                out_row_3 <= cur_buffer[703 : 640];
                out_row_4 <= cur_buffer[767 : 704];
                out_row_5 <= cur_buffer[831 : 768];
                out_row_6 <= {cur_buffer[327 : 320] ,cur_buffer[895 : 840]};
                out_row_7 <= {cur_buffer[399 : 384] ,cur_buffer[959 : 912]};
                out_row_8 <= {cur_buffer[471 : 448] ,cur_buffer[1023 : 984]};
            end
            5'b11101 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= cur_buffer[639 : 576];
                out_row_3 <= cur_buffer[703 : 640];
                out_row_4 <= cur_buffer[767 : 704];
                out_row_5 <= cur_buffer[831 : 768];
                out_row_6 <= cur_buffer[895 : 832];
                out_row_7 <= {cur_buffer[391 : 384] ,cur_buffer[959 : 904]};
                out_row_8 <= {cur_buffer[463 : 448] ,cur_buffer[1023 : 976]};
            end
            5'b11110 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= cur_buffer[639 : 576];
                out_row_3 <= cur_buffer[703 : 640];
                out_row_4 <= cur_buffer[767 : 704];
                out_row_5 <= cur_buffer[831 : 768];
                out_row_6 <= cur_buffer[895 : 832];
                out_row_7 <= cur_buffer[959 : 896];
                out_row_8 <= {cur_buffer[455 : 448] ,cur_buffer[1023 : 968]};
            end
            5'b11111 : begin
                out_row_1 <= cur_buffer[575 : 512];
                out_row_2 <= cur_buffer[639 : 576];
                out_row_3 <= cur_buffer[703 : 640];
                out_row_4 <= cur_buffer[767 : 704];
                out_row_5 <= cur_buffer[831 : 768];
                out_row_6 <= cur_buffer[895 : 832];
                out_row_7 <= cur_buffer[959 : 896];
                out_row_8 <= cur_buffer[1023 : 960];
            end
            default :
                {out_row_1, out_row_2, out_row_3, out_row_4,
                    out_row_5, out_row_6, out_row_7, out_row_8} <= 0;
        endcase
    end
endmodule