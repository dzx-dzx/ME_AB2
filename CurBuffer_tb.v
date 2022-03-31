`include "CurBuffer.v"

`timescale  1ns / 1ns

module CurBuffer_tb ();

    reg          clk       ;
    reg          rst       ;
    reg          next_block;
    reg  [ 31:0] cur_in    ;
    wire [511:0] cur_out   ;
    wire         need_cur  ;

    reg [10:0] mem_addr;

    reg [7:0] cur_mem[0:1000];

    initial begin
        $readmemh("./cur_test.txt", cur_mem);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_addr <= 0;
        end
        else begin
            if (need_cur) begin
                mem_addr <= mem_addr + 4;
            end
        end
    end

    always @(*) begin
        if (need_cur) begin
            cur_in[7:0]   <= cur_mem[mem_addr];
            cur_in[15:8]  <= cur_mem[mem_addr+1];
            cur_in[23:16] <= cur_mem[mem_addr+2];
            cur_in[31:24] <= cur_mem[mem_addr+3];
        end
    end

    initial begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    initial begin
        # 5;
        next_block = 0;
        forever begin
            # 200 next_block = ~next_block;
            # 10 next_block = ~next_block;
        end
    end

    initial begin
        rst = 1'b1;
        #10 rst = 1'b0;
        #10000 $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, CurBuffer_tb);
    end

    CurBuffer U_CurBuffer(
        .clk(clk),
        .rst(rst),
        .next_block(next_block),
        .cur_in(cur_in),
        .cur_out(cur_out),
        .need_cur(need_cur)
    );


endmodule
