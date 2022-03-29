`include "ME.v"

`timescale 1ns/1ps

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
        #100000 $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ME_tb);
    end

    reg [7:0] cur_mem[ 0:8300000]; // Need 3840x2160 = 8294400
    reg [7:0] ref_mem[0:23945800]; // Need 23945760

    reg [23:0] cur_mem_addr;
    reg [25:0] ref_mem_addr;

    initial begin
        $readmemh("./data_preprocess/data/cur_processed.txt", cur_mem);
        $readmemh("./data_preprocess/data/ref_processed.txt", ref_mem);
    end

    reg [31:0] cur_in;
    reg [63:0] ref_in;

    wire need_cur;
    wire need_ref;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cur_mem_addr <= 0;
            ref_mem_addr <= 0;
            cur_in       <= 0;
            ref_in       <= 0;
        end
        else begin
            if (need_cur) begin
                cur_in       <= cur_mem[cur_mem_addr];
                cur_mem_addr <= cur_mem_addr + 1;
            end
            else if (need_ref) begin
                ref_in       <= ref_mem[ref_mem_addr];
                ref_mem_addr <= ref_mem_addr + 1;
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