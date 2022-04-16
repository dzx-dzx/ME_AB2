module CurBuffer_highBW (
    input               clk         ,
    input               rst         ,
    input               en          ,
    input               next_block  , // To send the next_block
    input       [ 63:0] cur_in      , // 8 pixels
    output wire [511:0] cur_out     , // 8*8 pixels
    output reg  [ 31:0] cur_mem_addr
);
    reg [63:0] row_0;
    reg [63:0] row_1;
    reg [63:0] row_2;
    reg [63:0] row_3;
    reg [63:0] row_4;
    reg [63:0] row_5;
    reg [63:0] row_6;
    reg [63:0] row_7;

    // Read process
    assign cur_out = {row_7, row_6, row_5, row_4,
        row_3, row_2, row_1, row_0};

    // Read Control
    reg       read_en ;
    reg [2:0] read_cnt;

    always @(posedge clk) begin
        if (rst) begin
            read_en      <= 0;
            read_cnt     <= 0;
            cur_mem_addr <= 0;
        end
        else if(en) begin
            case ({next_block, read_en, read_cnt})
                5'b10000 : begin
                    read_en      <= 1;
                    cur_mem_addr <= cur_mem_addr + 8;
                end
                5'b01000 : begin
                    read_cnt     <= read_cnt + 1;
                    cur_mem_addr <= cur_mem_addr + 8;
                    row_0        <= cur_in;
                end
                5'b01001 : begin
                    read_cnt     <= read_cnt + 1;
                    cur_mem_addr <= cur_mem_addr + 8;
                    row_1        <= cur_in;
                end
                5'b01010 : begin
                    read_cnt     <= read_cnt + 1;
                    cur_mem_addr <= cur_mem_addr + 8;
                    row_2        <= cur_in;
                end
                5'b01011 : begin
                    read_cnt     <= read_cnt + 1;
                    cur_mem_addr <= cur_mem_addr + 8;
                    row_3        <= cur_in;
                end
                5'b01100 : begin
                    read_cnt     <= read_cnt + 1;
                    cur_mem_addr <= cur_mem_addr + 8;
                    row_4        <= cur_in;
                end
                5'b01101 : begin
                    read_cnt     <= read_cnt + 1;
                    cur_mem_addr <= cur_mem_addr + 8;
                    row_5        <= cur_in;
                end
                5'b01110 : begin
                    read_cnt     <= read_cnt + 1;
                    cur_mem_addr <= cur_mem_addr + 8;
                    row_6        <= cur_in;
                end
                5'b01111 : begin
                    read_en  <= 0;
                    read_cnt <= read_cnt + 1;
                    row_7    <= cur_in;
                end
                default : ;
            endcase
        end
    end
endmodule