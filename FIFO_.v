module FIFO (
    input               clk_i   ,
    input               rst_n_i ,
    input  wire [183:0] buf_data,
    output reg  [127:0] AD_data0,
    output reg  [127:0] AD_data1,
    output reg  [127:0] AD_data2,
    output reg  [127:0] AD_data3,
    output reg  [127:0] AD_data4,
    output reg  [127:0] AD_data5,
    output reg  [127:0] AD_data6,
    output reg  [127:0] AD_data7
);

    always@(posedge clk_i or negedge rst_n_i)
        begin
            if(!rst_n_i)
                begin
                    AD_data0 <= 0;
                    AD_data1 <= 0;
                    AD_data2 <= 0;
                    AD_data3 <= 0;
                    AD_data4 <= 0;
                    AD_data5 <= 0;
                    AD_data6 <= 0;
                    AD_data7 <= 0;
                end
            else
                begin
                    AD_data0[15:0]    <= buf_data[15:0];
                    AD_data0[31:16]   <= buf_data[16:1];
                    AD_data0[47:32]   <= buf_data[17:2];
                    AD_data0[63:48]   <= buf_data[18:3];
                    AD_data0[79:64]   <= buf_data[19:4];
                    AD_data0[95:80]   <= buf_data[20:5];
                    AD_data0[111:96]  <= buf_data[21:6];
                    AD_data0[127:112] <= buf_data[22:7];

                    AD_data1[15:0]    <= buf_data[38:23];
                    AD_data1[31:16]   <= buf_data[39:24];
                    AD_data1[47:32]   <= buf_data[40:25];
                    AD_data1[63:48]   <= buf_data[41:26];
                    AD_data1[79:64]   <= buf_data[42:27];
                    AD_data1[95:80]   <= buf_data[43:28];
                    AD_data1[111:96]  <= buf_data[44:29];
                    AD_data1[127:112] <= buf_data[45:30];

                    AD_data2[15:0]    <= buf_data[61:46];
                    AD_data2[31:16]   <= buf_data[62:47];
                    AD_data2[47:32]   <= buf_data[63:48];
                    AD_data2[63:48]   <= buf_data[64:49];
                    AD_data2[79:64]   <= buf_data[65:50];
                    AD_data2[95:80]   <= buf_data[66:51];
                    AD_data2[111:96]  <= buf_data[67:52];
                    AD_data2[127:112] <= buf_data[68:53];

                    AD_data3[15:0]    <= buf_data[84:69];
                    AD_data3[31:16]   <= buf_data[85:70];
                    AD_data3[47:32]   <= buf_data[86:71];
                    AD_data3[63:48]   <= buf_data[87:72];
                    AD_data3[79:64]   <= buf_data[88:73];
                    AD_data3[95:80]   <= buf_data[89:74];
                    AD_data3[111:96]  <= buf_data[90:75];
                    AD_data3[127:112] <= buf_data[91:76];

                    AD_data4[15:0]    <= buf_data[107:92];
                    AD_data4[31:16]   <= buf_data[108:93];
                    AD_data4[47:32]   <= buf_data[109:94];
                    AD_data4[63:48]   <= buf_data[110:95];
                    AD_data4[79:64]   <= buf_data[111:96];
                    AD_data4[95:80]   <= buf_data[112:97];
                    AD_data4[111:96]  <= buf_data[113:98];
                    AD_data4[127:112] <= buf_data[114:99];

                    AD_data5[15:0]    <= buf_data[130:115];
                    AD_data5[31:16]   <= buf_data[131:116];
                    AD_data5[47:32]   <= buf_data[132:117];
                    AD_data5[63:48]   <= buf_data[133:118];
                    AD_data5[79:64]   <= buf_data[134:119];
                    AD_data5[95:80]   <= buf_data[135:120];
                    AD_data5[111:96]  <= buf_data[136:121];
                    AD_data5[127:112] <= buf_data[137:122];

                    AD_data6[15:0]    <= buf_data[153:138];
                    AD_data6[31:16]   <= buf_data[154:139];
                    AD_data6[47:32]   <= buf_data[155:140];
                    AD_data6[63:48]   <= buf_data[156:141];
                    AD_data6[79:64]   <= buf_data[157:142];
                    AD_data6[95:80]   <= buf_data[158:143];
                    AD_data6[111:96]  <= buf_data[159:144];
                    AD_data6[127:112] <= buf_data[160:145];

                    AD_data7[15:0]    <= buf_data[176:161];
                    AD_data7[31:16]   <= buf_data[177:162];
                    AD_data7[47:32]   <= buf_data[178:163];
                    AD_data7[63:48]   <= buf_data[179:164];
                    AD_data7[79:64]   <= buf_data[180:165];
                    AD_data7[95:80]   <= buf_data[181:166];
                    AD_data7[111:96]  <= buf_data[182:167];
                    AD_data7[127:112] <= buf_data[183:168];
                end
        end

endmodule


