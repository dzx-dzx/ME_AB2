
module cur_mem_highBW (
    input              en      ,
    input  wire [31:0] addr    ,
    output reg  [63:0] cur_data
);
    reg [7:0] cur_mem[0:8300000];

    initial
        $readmemh("./data_preprocess/data/cur_test.txt", cur_mem);

    always @(addr, en) begin
        if (en == 0)
            cur_data <= 0;
        else begin
            cur_data[7:0]   <= cur_mem[addr];
            cur_data[15:8]  <= cur_mem[addr + 1];
            cur_data[23:16] <= cur_mem[addr + 2];
            cur_data[31:24] <= cur_mem[addr + 3];
            cur_data[39:32] <= cur_mem[addr + 4];
            cur_data[47:40] <= cur_mem[addr + 5];
            cur_data[55:48] <= cur_mem[addr + 6];
            cur_data[63:56] <= cur_mem[addr + 7];
        end
    end

endmodule