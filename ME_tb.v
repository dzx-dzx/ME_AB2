`timescale 1ns/1ns
`include "ME.v"
`include "cur_mem.v"
`include "ref_mem.v"
module ME_tb ();
    reg clk ;
    reg rst ;
    reg en_i;

    initial begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    initial begin
        rst = 1'b1;
        en_i = 1'b0;
        #10 rst = 1'b0;
        #20 en_i = 1'b1;
        #3000 $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ME_tb);
    end

    // initial begin
    //     $readmemh("cur_test.txt", cur_mem);
    //     $readmemh("ref_test.txt", ref_mem);
    // end

    wire        cur_mem_en  ;
    wire        ref_mem_en  ;
    wire [31:0] cur_mem_addr;
    wire [31:0] ref_mem_addr;
    wire [31:0] cur_in      ;
    wire [63:0] ref_in      ;
    wire        need_cur    ;
    wire        need_ref    ;

    ME U_ME (
        .clk         (clk         ),
        .rst         (rst         ),
        .en_i        (en_i        ),
        .cur_in_i    (cur_in      ),
        .ref_in_i    (ref_in      ),
        .cur_mem_addr(cur_mem_addr),
        .ref_mem_addr(ref_mem_addr),
        .cur_mem_en  (cur_mem_en  ),
        .ref_mem_en  (ref_mem_en  )
    );

    cur_mem U_cur_mem (
        .en      (cur_mem_en  ),
        .addr    (cur_mem_addr),
        .cur_data(cur_in      )
    );

    ref_mem U_ref_mem (
        .en      (ref_mem_en  ),
        .addr    (ref_mem_addr),
        .ref_data(ref_in      )
    );
endmodule