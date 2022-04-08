`include "ME.v"

`timescale 1ns/1ns

module ME_tb ();
    reg clk;
    reg rst;

    initial begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        #10 rst = 1'b0;
        #10000 $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ME_tb);
    end

    reg [7:0] cur_mem[ 0:8300000]; // Need 3840x2160 = 8294400
    reg [7:0] ref_mem[0:23945800]; // Need 23945760

    reg [31:0] cur_mem_addr;
    reg [31:0] ref_mem_addr;

    // initial begin
    //     $readmemh("./data_preprocess/data/cur_processed.txt", cur_mem);
    //     $readmemh("./data_preprocess/data/ref_processed.txt", ref_mem);
    // end

    initial begin
        $readmemh("cur_test.txt", cur_mem);
        $readmemh("ref_test.txt", ref_mem);
    end

    reg [31:0] cur_in;
    reg [63:0] ref_in;

    wire need_cur;
    wire need_ref;

    always @(posedge clk) begin
        if (rst) begin
            cur_mem_addr <= 0;
            ref_mem_addr <= 0;
            cur_in       <= 0;
            ref_in       <= 0;
        end
        else begin
            if (need_cur) begin
                cur_in[7:0]   <= cur_mem[cur_mem_addr];
                cur_in[15:8]  <= cur_mem[cur_mem_addr + 1];
                cur_in[23:16] <= cur_mem[cur_mem_addr + 2];
                cur_in[31:24] <= cur_mem[cur_mem_addr + 3];

                cur_mem_addr <= cur_mem_addr + 4;
            end
            else if (need_ref) begin
                ref_in[7:0]   <= cur_mem[cur_mem_addr + 0];
                ref_in[15:8]  <= cur_mem[cur_mem_addr + 1];
                ref_in[23:16] <= cur_mem[cur_mem_addr + 2];
                ref_in[31:24] <= cur_mem[cur_mem_addr + 3];
                ref_in[39:32] <= cur_mem[cur_mem_addr + 4];
                ref_in[47:40] <= cur_mem[cur_mem_addr + 5];
                ref_in[55:48] <= cur_mem[cur_mem_addr + 6];
                ref_in[63:56] <= cur_mem[cur_mem_addr + 7];

                ref_mem_addr <= ref_mem_addr + 8;
            end
            else ;
        end
    end

    ME U_ME (
        .clk     (clk     ),
        .rst     (rst     ),
        .cur_in  (cur_in  ),
        .ref_in  (ref_in  ),
        .need_cur(need_cur),
        .need_ref(need_ref)
    );
endmodule