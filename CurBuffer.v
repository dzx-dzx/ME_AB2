module CurBuffer (
    input               clk       ,
    input               rst       ,
    input               next_block, // To send the next_block
    input               read_en   ,
    input  wire [ 31:0] cur_in    , // 4 pixels
    output wire [511:0] cur_out   , // 8*8 pixels
);

    reg [7:0] cur_buffer[0:127]; // 128 * 1 pixels

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


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cur_buffer <= 0;
            addr       <= 0;
        end
        else if (read_en) begin
            cur_buffer[addr]   <= cur_in[7:0];
            cur_buffer[addr+1] <= cur_in[15:8];
            cur_buffer[addr+2] <= cur_in[23:16];
            cur_buffer[addr+3] <= cur_in[31:24];

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
                out_row_1 <= cur_buffer[0:7];
                out_row_2 <= cur_buffer[8:15];
                out_row_3 <= cur_buffer[16:23];
                out_row_4 <= cur_buffer[24:31];
                out_row_5 <= cur_buffer[32:39];
                out_row_6 <= cur_buffer[40:47];
                out_row_7 <= cur_buffer[48:55];
                out_row_8 <= cur_buffer[56:63];
            end

            // New half is the left one.
            5'b01000 : begin
                out_row_1 <= cur_buffer[0:7];
                out_row_2 <= {cur_buffer[72], cur_buffer[9:15]};
                out_row_3 <= {cur_buffer[80:81], cur_buffer[18:23]};
                out_row_4 <= {cur_buffer[88:90], cur_buffer[27:31]};
                out_row_5 <= {cur_buffer[96:99], cur_buffer[36:39]};
                out_row_6 <= {cur_buffer[104:108], cur_buffer[45:47]};
                out_row_7 <= {cur_buffer[112:117], cur_buffer[54:55]};
                out_row_8 <= {cur_buffer[120:126], cur_buffer[63]};
            end
            5'b01001 : begin
                out_row_1 <= cur_buffer[0:7];
                out_row_2 <= cur_buffer[8:15];
                out_row_3 <= {cur_buffer[80], cur_buffer[17:23]};
                out_row_4 <= {cur_buffer[88:89], cur_buffer[26:31]};
                out_row_5 <= {cur_buffer[96:98], cur_buffer[35:39]};
                out_row_6 <= {cur_buffer[104:107], cur_buffer[44:47]};
                out_row_7 <= {cur_buffer[112:116], cur_buffer[53:55]};
                out_row_8 <= {cur_buffer[120:125], cur_buffer[62:63]};
            end
            5'b01010 : begin
                out_row_1 <= cur_buffer[0:7];
                out_row_2 <= cur_buffer[8:15];
                out_row_3 <= cur_buffer[16:23];
                out_row_4 <= {cur_buffer[88], cur_buffer[25:31]};
                out_row_5 <= {cur_buffer[96:97], cur_buffer[34:39]};
                out_row_6 <= {cur_buffer[104:106], cur_buffer[43:47]};
                out_row_7 <= {cur_buffer[112:115], cur_buffer[52:55]};
                out_row_8 <= {cur_buffer[120:124], cur_buffer[61:63]};
            end
            5'b01011 : begin
                out_row_1 <= cur_buffer[0:7];
                out_row_2 <= cur_buffer[8:15];
                out_row_3 <= cur_buffer[16:23];
                out_row_4 <= cur_buffer[24:31];
                out_row_5 <= {cur_buffer[96], cur_buffer[33:39]};
                out_row_6 <= {cur_buffer[104:105], cur_buffer[42:47]};
                out_row_7 <= {cur_buffer[112:114], cur_buffer[51:55]};
                out_row_8 <= {cur_buffer[120:123], cur_buffer[60:63]};
            end
            5'b01100 : begin
                out_row_1 <= cur_buffer[0:7];
                out_row_2 <= cur_buffer[8:15];
                out_row_3 <= cur_buffer[16:23];
                out_row_4 <= cur_buffer[24:31];
                out_row_5 <= cur_buffer[32:39];
                out_row_6 <= {cur_buffer[104], cur_buffer[41:47]};
                out_row_7 <= {cur_buffer[112:113], cur_buffer[50:55]};
                out_row_8 <= {cur_buffer[120:122], cur_buffer[59:63]};
            end
            5'b01101 : begin
                out_row_1 <= cur_buffer[0:7];
                out_row_2 <= cur_buffer[8:15];
                out_row_3 <= cur_buffer[16:23];
                out_row_4 <= cur_buffer[24:31];
                out_row_5 <= cur_buffer[32:39];
                out_row_6 <= cur_buffer[40:47];
                out_row_7 <= {cur_buffer[112], cur_buffer[49:55]};
                out_row_8 <= {cur_buffer[120:121], cur_buffer[58:63]};
            end
            5'b01110 : begin
                ut_row_1  <= cur_buffer[0:7];
                out_row_2 <= cur_buffer[8:15];
                out_row_3 <= cur_buffer[16:23];
                out_row_4 <= cur_buffer[24:31];
                out_row_5 <= cur_buffer[32:39];
                out_row_6 <= cur_buffer[40:47];
                out_row_7 <= cur_buffer[48:55];
                out_row_8 <= {cur_buffer[120], cur_buffer[57:63]};
            end
            5'b01111 : begin
                out_row_1 <= cur_buffer[0:7];
                out_row_2 <= cur_buffer[8:15];
                out_row_3 <= cur_buffer[16:23];
                out_row_4 <= cur_buffer[24:31];
                out_row_5 <= cur_buffer[32:39];
                out_row_6 <= cur_buffer[40:47];
                out_row_7 <= cur_buffer[48:55];
                out_row_8 <= cur_buffer[56:63];
            end

            // At right half
            5'b10000 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= cur_buffer[72:79];
                out_row_3 <= cur_buffer[80:87];
                out_row_4 <= cur_buffer[88:95];
                out_row_5 <= cur_buffer[96:103];
                out_row_6 <= cur_buffer[104:111];
                out_row_7 <= cur_buffer[112:119];
                out_row_8 <= cur_buffer[120:127];
            end

            // New half is right
            5'b11000 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= {cur_buffer[8] ,cur_buffer[73:79]};
                out_row_3 <= {cur_buffer[16:17] ,cur_buffer[82:87]};
                out_row_4 <= {cur_buffer[24:26] ,cur_buffer[91:95]};
                out_row_5 <= {cur_buffer[32:35] ,cur_buffer[100:103]};
                out_row_6 <= {cur_buffer[40:44] ,cur_buffer[109:111]};
                out_row_7 <= {cur_buffer[48:53] ,cur_buffer[118:119]};
                out_row_8 <= {cur_buffer[56:62] ,cur_buffer[127]};
            end
            5'b11001 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= cur_buffer[72:79];
                out_row_3 <= {cur_buffer[16] ,cur_buffer[81:87]};
                out_row_4 <= {cur_buffer[24:25] ,cur_buffer[90:95]};
                out_row_5 <= {cur_buffer[32:34] ,cur_buffer[99:103]};
                out_row_6 <= {cur_buffer[40:43] ,cur_buffer[108:111]};
                out_row_7 <= {cur_buffer[48:52] ,cur_buffer[117:119]};
                out_row_8 <= {cur_buffer[56:61] ,cur_buffer[126:127]};
            end
            5'b11010 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= cur_buffer[72:79];
                out_row_3 <= cur_buffer[80:87];
                out_row_4 <= {cur_buffer[24] ,cur_buffer[89:95]};
                out_row_5 <= {cur_buffer[32:33] ,cur_buffer[98:103]};
                out_row_6 <= {cur_buffer[40:42] ,cur_buffer[107:111]};
                out_row_7 <= {cur_buffer[48:51] ,cur_buffer[116:119]};
                out_row_8 <= {cur_buffer[56:60] ,cur_buffer[125:127]};
            end
            5'b11011 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= cur_buffer[72:79];
                out_row_3 <= cur_buffer[80:87];
                out_row_4 <= ,cur_buffer[88:95];
                out_row_5 <= {cur_buffer[32] ,cur_buffer[97:103]};
                out_row_6 <= {cur_buffer[40:41] ,cur_buffer[106:111]};
                out_row_7 <= {cur_buffer[48:50] ,cur_buffer[115:119]};
                out_row_8 <= {cur_buffer[56:59] ,cur_buffer[124:127]};
            end
            5'b11100 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= cur_buffer[72:79];
                out_row_3 <= cur_buffer[80:87];
                out_row_4 <= cur_buffer[88:95];
                out_row_5 <= cur_buffer[96:103];
                out_row_6 <= {cur_buffer[40] ,cur_buffer[105:111]};
                out_row_7 <= {cur_buffer[48:49] ,cur_buffer[114:119]};
                out_row_8 <= {cur_buffer[56:58] ,cur_buffer[123:127]};
            end
            5'b11101 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= cur_buffer[72:79];
                out_row_3 <= cur_buffer[80:87];
                out_row_4 <= cur_buffer[88:95];
                out_row_5 <= cur_buffer[96:103];
                out_row_6 <= cur_buffer[104:111];
                out_row_7 <= {cur_buffer[48] ,cur_buffer[113:119]};
                out_row_8 <= {cur_buffer[56:57] ,cur_buffer[122:127]};
            end
            5'b11110 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= cur_buffer[72:79];
                out_row_3 <= cur_buffer[80:87];
                out_row_4 <= cur_buffer[88:95];
                out_row_5 <= cur_buffer[96:103];
                out_row_6 <= cur_buffer[104:111];
                out_row_7 <= cur_buffer[112:119];
                out_row_8 <= {cur_buffer[56] ,cur_buffer[121:127]};
            end
            5'b11111 : begin
                out_row_1 <= cur_buffer[64:71];
                out_row_2 <= cur_buffer[72:79];
                out_row_3 <= cur_buffer[80:87];
                out_row_4 <= cur_buffer[88:95];
                out_row_5 <= cur_buffer[96:103];
                out_row_6 <= cur_buffer[104:111];
                out_row_7 <= cur_buffer[112:119];
                out_row_8 <= cur_buffer[120:127];
            end
            default :
                {out_row_1, out_row_2, out_row_3, out_row_4,
                    out_row_5, out_row_6, out_row_7, out_row_8} <= 0;
        endcase
    end
endmodule