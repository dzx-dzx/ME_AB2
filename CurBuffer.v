// +FHDR-------------------------------------------------------------------
// FILE NAME: CurBuffer.v
// TYPE: Module
// DEPARTMENT:
// AUTHOR: Yaotian Liu
// AUTHOR'S EMAIL: henry_liu@sjtu.edu.cn
// ------------------------------------------------------------------------
// KEYWORDS:
// ------------------------------------------------------------------------
// PARAMETERS
// None
// ------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy: Synchronous & High valid
// Clock Domains: Global
// Critical Timing:
// Test Features:
// Asynchronous I/F:
// Scan Methodology:
// Instantiations: ~
// -FHDR-------------------------------------------------------------------

module CurBuffer (
    input               clk       ,
    input               rst       ,
    input               en        ,
    input               next_block, // To send the next_block
    input       [ 31:0] cur_in    , // 4 pixels
    output wire [511:0] cur_out   , // 8*8 pixels
    output reg          read_en
);

    // 2 buffer. each stores 64 pixels
    reg [511:0] buffer_0;
    reg [511:0] buffer_1;


    reg [3:0] buffer_addr     ;
    reg [3:0] buffer_addr_late;

    reg       half       ;
    reg       at_inter   ;
    reg [2:0] inter_state;

    reg cold_boot;
    // reg read_en  ;
    reg read_en_late;

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


    always @(posedge clk) begin
        if (rst) begin
            buffer_addr <= 0;
            cold_boot   <= 1;
            read_en     <= 0;
        end
        else if (en) begin
            if (next_block || cold_boot) begin
                buffer_addr <= 0;
                cold_boot   <= 0;
                read_en     <= 1;
            end
            else if (read_en) begin
                if (buffer_addr == 15)
                    read_en <= 0;
                else
                    buffer_addr <= buffer_addr + 1;
            end
            else;
        end
        else ;
    end


    // Buffer_addr FF to meet timing
    always @(posedge clk) begin
        if (rst) begin
            buffer_addr_late <= 0;
            read_en_late     <= 0;
        end
        else begin
            buffer_addr_late <= buffer_addr;
            read_en_late     <= read_en;
        end
    end


    always @(posedge clk) begin
        if (rst) begin
            half        <= 0;
            at_inter    <= 0;
            inter_state <= 0;
        end
        else if (en) begin
            if (next_block || cold_boot) begin
                half     <= ~half;
                at_inter <= 1;
            end
            else if (at_inter) begin
                if (inter_state == 6) begin
                    at_inter    <= 0;
                    inter_state <= 0;
                end
                else
                    inter_state <= inter_state + 1;
            end
            else;
        end
    end

    always @(*) begin
        if(en) begin
            if (at_inter) begin
                case ({half, inter_state})
                    // next block in in buffer 0
                    4'b0000 : begin
                        out_row_1 = buffer_0[63 : 0];
                        out_row_2 = buffer_1[127 : 64];
                        out_row_3 = buffer_1[191 : 128];
                        out_row_4 = buffer_1[255 : 192];
                        out_row_5 = buffer_1[319 : 256];
                        out_row_6 = buffer_1[383 : 320];
                        out_row_7 = buffer_1[447 : 384];
                        out_row_8 = buffer_1[511 : 448];
                    end
                    4'b0001 : begin
                        out_row_1 = buffer_0[63 : 0];
                        out_row_2 = buffer_0[127 : 64];
                        out_row_3 = buffer_1[191 : 128];
                        out_row_4 = buffer_1[255 : 192];
                        out_row_5 = buffer_1[319 : 256];
                        out_row_6 = buffer_1[383 : 320];
                        out_row_7 = buffer_1[447 : 384];
                        out_row_8 = buffer_1[511 : 448];
                    end
                    4'b0010 : begin
                        out_row_1 = buffer_0[63 : 0];
                        out_row_2 = buffer_0[127 : 64];
                        out_row_3 = buffer_0[191 : 128];
                        out_row_4 = buffer_1[255 : 192];
                        out_row_5 = buffer_1[319 : 256];
                        out_row_6 = buffer_1[383 : 320];
                        out_row_7 = buffer_1[447 : 384];
                        out_row_8 = buffer_1[511 : 448];
                    end
                    4'b0011 : begin
                        out_row_1 = buffer_0[63 : 0];
                        out_row_2 = buffer_0[127 : 64];
                        out_row_3 = buffer_0[191 : 128];
                        out_row_4 = buffer_0[255 : 192];
                        out_row_5 = buffer_1[319 : 256];
                        out_row_6 = buffer_1[383 : 320];
                        out_row_7 = buffer_1[447 : 384];
                        out_row_8 = buffer_1[511 : 448];
                    end
                    4'b0100 : begin
                        out_row_1 = buffer_0[63 : 0];
                        out_row_2 = buffer_0[127 : 64];
                        out_row_3 = buffer_0[191 : 128];
                        out_row_4 = buffer_0[255 : 192];
                        out_row_5 = buffer_0[319 : 256];
                        out_row_6 = buffer_1[383 : 320];
                        out_row_7 = buffer_1[447 : 384];
                        out_row_8 = buffer_1[511 : 448];
                    end
                    4'b0101 : begin
                        out_row_1 = buffer_0[63 : 0];
                        out_row_2 = buffer_0[127 : 64];
                        out_row_3 = buffer_0[191 : 128];
                        out_row_4 = buffer_0[255 : 192];
                        out_row_5 = buffer_0[319 : 256];
                        out_row_6 = buffer_0[383 : 320];
                        out_row_7 = buffer_1[447 : 384];
                        out_row_8 = buffer_1[511 : 448];
                    end
                    4'b0110 : begin
                        out_row_1 = buffer_0[63 : 0];
                        out_row_2 = buffer_0[127 : 64];
                        out_row_3 = buffer_0[191 : 128];
                        out_row_4 = buffer_0[255 : 192];
                        out_row_5 = buffer_0[319 : 256];
                        out_row_6 = buffer_0[383 : 320];
                        out_row_7 = buffer_0[447 : 384];
                        out_row_8 = buffer_1[511 : 448];
                    end
                    4'b1000 : begin
                        out_row_1 = buffer_1[63 : 0];
                        out_row_2 = buffer_0[127 : 64];
                        out_row_3 = buffer_0[191 : 128];
                        out_row_4 = buffer_0[255 : 192];
                        out_row_5 = buffer_0[319 : 256];
                        out_row_6 = buffer_0[383 : 320];
                        out_row_7 = buffer_0[447 : 384];
                        out_row_8 = buffer_0[511 : 448];
                    end
                    4'b1001 : begin
                        out_row_1 = buffer_1[63 : 0];
                        out_row_2 = buffer_1[127 : 64];
                        out_row_3 = buffer_0[191 : 128];
                        out_row_4 = buffer_0[255 : 192];
                        out_row_5 = buffer_0[319 : 256];
                        out_row_6 = buffer_0[383 : 320];
                        out_row_7 = buffer_0[447 : 384];
                        out_row_8 = buffer_0[511 : 448];
                    end
                    4'b1010 : begin
                        out_row_1 = buffer_1[63 : 0];
                        out_row_2 = buffer_1[127 : 64];
                        out_row_3 = buffer_1[191 : 128];
                        out_row_4 = buffer_0[255 : 192];
                        out_row_5 = buffer_0[319 : 256];
                        out_row_6 = buffer_0[383 : 320];
                        out_row_7 = buffer_0[447 : 384];
                        out_row_8 = buffer_0[511 : 448];
                    end
                    4'b1011 : begin
                        out_row_1 = buffer_1[63 : 0];
                        out_row_2 = buffer_1[127 : 64];
                        out_row_3 = buffer_1[191 : 128];
                        out_row_4 = buffer_1[255 : 192];
                        out_row_5 = buffer_0[319 : 256];
                        out_row_6 = buffer_0[383 : 320];
                        out_row_7 = buffer_0[447 : 384];
                        out_row_8 = buffer_0[511 : 448];
                    end
                    4'b1100 : begin
                        out_row_1 = buffer_1[63 : 0];
                        out_row_2 = buffer_1[127 : 64];
                        out_row_3 = buffer_1[191 : 128];
                        out_row_4 = buffer_1[255 : 192];
                        out_row_5 = buffer_1[319 : 256];
                        out_row_6 = buffer_0[383 : 320];
                        out_row_7 = buffer_0[447 : 384];
                        out_row_8 = buffer_0[511 : 448];
                    end
                    4'b1101 : begin
                        out_row_1 = buffer_1[63 : 0];
                        out_row_2 = buffer_1[127 : 64];
                        out_row_3 = buffer_1[191 : 128];
                        out_row_4 = buffer_1[255 : 192];
                        out_row_5 = buffer_1[319 : 256];
                        out_row_6 = buffer_1[383 : 320];
                        out_row_7 = buffer_0[447 : 384];
                        out_row_8 = buffer_0[511 : 448];
                    end
                    4'b1110 : begin
                        out_row_1 = buffer_1[63 : 0];
                        out_row_2 = buffer_1[127 : 64];
                        out_row_3 = buffer_1[191 : 128];
                        out_row_4 = buffer_1[255 : 192];
                        out_row_5 = buffer_1[319 : 256];
                        out_row_6 = buffer_1[383 : 320];
                        out_row_7 = buffer_1[447 : 384];
                        out_row_8 = buffer_0[511 : 448];
                    end
                    default :
                        {out_row_8, out_row_7, out_row_6, out_row_5,
                            out_row_4, out_row_3, out_row_2, out_row_1} = 0;
                endcase
            end
            // Not at inter
            else begin
                case (half)
                    // Buffer 0 in cur block
                    1'b0 : begin
                        out_row_1 = buffer_0[63 : 0];
                        out_row_2 = buffer_0[127 : 64];
                        out_row_3 = buffer_0[191 : 128];
                        out_row_4 = buffer_0[255 : 192];
                        out_row_5 = buffer_0[319 : 256];
                        out_row_6 = buffer_0[383 : 320];
                        out_row_7 = buffer_0[447 : 384];
                        out_row_8 = buffer_0[511 : 448];
                    end
                    // Buffer 1 in cur block
                    1'b1 : begin
                        out_row_1 = buffer_1[63 : 0];
                        out_row_2 = buffer_1[127 : 64];
                        out_row_3 = buffer_1[191 : 128];
                        out_row_4 = buffer_1[255 : 192];
                        out_row_5 = buffer_1[319 : 256];
                        out_row_6 = buffer_1[383 : 320];
                        out_row_7 = buffer_1[447 : 384];
                        out_row_8 = buffer_1[511 : 448];
                    end
                endcase
            end
        end
        else {out_row_8, out_row_7, out_row_6, out_row_5,
            out_row_4, out_row_3, out_row_2, out_row_1} = 0;
    end

    // Input Logic
    always @ (posedge clk) begin
        if (rst) begin
            buffer_0 <= 0;
            buffer_1 <= 0;
        end
        else if (read_en_late)
            case (half)
                // buffer_0 is valid and write buffer_1
                1'b0 : begin
                    buffer_1[{buffer_addr_late,5'b00000}+0]  <= cur_in[0];
                    buffer_1[{buffer_addr_late,5'b00000}+1]  <= cur_in[1];
                    buffer_1[{buffer_addr_late,5'b00000}+2]  <= cur_in[2];
                    buffer_1[{buffer_addr_late,5'b00000}+3]  <= cur_in[3];
                    buffer_1[{buffer_addr_late,5'b00000}+4]  <= cur_in[4];
                    buffer_1[{buffer_addr_late,5'b00000}+5]  <= cur_in[5];
                    buffer_1[{buffer_addr_late,5'b00000}+6]  <= cur_in[6];
                    buffer_1[{buffer_addr_late,5'b00000}+7]  <= cur_in[7];
                    buffer_1[{buffer_addr_late,5'b00000}+8]  <= cur_in[8];
                    buffer_1[{buffer_addr_late,5'b00000}+9]  <= cur_in[9];
                    buffer_1[{buffer_addr_late,5'b00000}+10] <= cur_in[10];
                    buffer_1[{buffer_addr_late,5'b00000}+11] <= cur_in[11];
                    buffer_1[{buffer_addr_late,5'b00000}+12] <= cur_in[12];
                    buffer_1[{buffer_addr_late,5'b00000}+13] <= cur_in[13];
                    buffer_1[{buffer_addr_late,5'b00000}+14] <= cur_in[14];
                    buffer_1[{buffer_addr_late,5'b00000}+15] <= cur_in[15];
                    buffer_1[{buffer_addr_late,5'b00000}+16] <= cur_in[16];
                    buffer_1[{buffer_addr_late,5'b00000}+17] <= cur_in[17];
                    buffer_1[{buffer_addr_late,5'b00000}+18] <= cur_in[18];
                    buffer_1[{buffer_addr_late,5'b00000}+19] <= cur_in[19];
                    buffer_1[{buffer_addr_late,5'b00000}+20] <= cur_in[20];
                    buffer_1[{buffer_addr_late,5'b00000}+21] <= cur_in[21];
                    buffer_1[{buffer_addr_late,5'b00000}+22] <= cur_in[22];
                    buffer_1[{buffer_addr_late,5'b00000}+23] <= cur_in[23];
                    buffer_1[{buffer_addr_late,5'b00000}+24] <= cur_in[24];
                    buffer_1[{buffer_addr_late,5'b00000}+25] <= cur_in[25];
                    buffer_1[{buffer_addr_late,5'b00000}+26] <= cur_in[26];
                    buffer_1[{buffer_addr_late,5'b00000}+27] <= cur_in[27];
                    buffer_1[{buffer_addr_late,5'b00000}+28] <= cur_in[28];
                    buffer_1[{buffer_addr_late,5'b00000}+29] <= cur_in[29];
                    buffer_1[{buffer_addr_late,5'b00000}+30] <= cur_in[30];
                    buffer_1[{buffer_addr_late,5'b00000}+31] <= cur_in[31];
                end
                // buffer_1 is valid and write buffer_0
                1'b1 : begin
                    buffer_0[{buffer_addr_late,5'b00000}+0]  <= cur_in[0];
                    buffer_0[{buffer_addr_late,5'b00000}+1]  <= cur_in[1];
                    buffer_0[{buffer_addr_late,5'b00000}+2]  <= cur_in[2];
                    buffer_0[{buffer_addr_late,5'b00000}+3]  <= cur_in[3];
                    buffer_0[{buffer_addr_late,5'b00000}+4]  <= cur_in[4];
                    buffer_0[{buffer_addr_late,5'b00000}+5]  <= cur_in[5];
                    buffer_0[{buffer_addr_late,5'b00000}+6]  <= cur_in[6];
                    buffer_0[{buffer_addr_late,5'b00000}+7]  <= cur_in[7];
                    buffer_0[{buffer_addr_late,5'b00000}+8]  <= cur_in[8];
                    buffer_0[{buffer_addr_late,5'b00000}+9]  <= cur_in[9];
                    buffer_0[{buffer_addr_late,5'b00000}+10] <= cur_in[10];
                    buffer_0[{buffer_addr_late,5'b00000}+11] <= cur_in[11];
                    buffer_0[{buffer_addr_late,5'b00000}+12] <= cur_in[12];
                    buffer_0[{buffer_addr_late,5'b00000}+13] <= cur_in[13];
                    buffer_0[{buffer_addr_late,5'b00000}+14] <= cur_in[14];
                    buffer_0[{buffer_addr_late,5'b00000}+15] <= cur_in[15];
                    buffer_0[{buffer_addr_late,5'b00000}+16] <= cur_in[16];
                    buffer_0[{buffer_addr_late,5'b00000}+17] <= cur_in[17];
                    buffer_0[{buffer_addr_late,5'b00000}+18] <= cur_in[18];
                    buffer_0[{buffer_addr_late,5'b00000}+19] <= cur_in[19];
                    buffer_0[{buffer_addr_late,5'b00000}+20] <= cur_in[20];
                    buffer_0[{buffer_addr_late,5'b00000}+21] <= cur_in[21];
                    buffer_0[{buffer_addr_late,5'b00000}+22] <= cur_in[22];
                    buffer_0[{buffer_addr_late,5'b00000}+23] <= cur_in[23];
                    buffer_0[{buffer_addr_late,5'b00000}+24] <= cur_in[24];
                    buffer_0[{buffer_addr_late,5'b00000}+25] <= cur_in[25];
                    buffer_0[{buffer_addr_late,5'b00000}+26] <= cur_in[26];
                    buffer_0[{buffer_addr_late,5'b00000}+27] <= cur_in[27];
                    buffer_0[{buffer_addr_late,5'b00000}+28] <= cur_in[28];
                    buffer_0[{buffer_addr_late,5'b00000}+29] <= cur_in[29];
                    buffer_0[{buffer_addr_late,5'b00000}+30] <= cur_in[30];
                    buffer_0[{buffer_addr_late,5'b00000}+31] <= cur_in[31];
                end
            endcase
        else ;

    end

endmodule