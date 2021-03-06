`timescale 1ns/1ns
module ME_highBW_tb ();
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
        $dumpvars(0, ME_highBW_tb);
    end

    always @(posedge clk) begin
        if(data_valid) $display("%h at (%h,%h)",MSAD,MSAD_row,MSAD_column);
    end

    // initial begin
    //     $readmemh("cur_test.txt", cur_mem);
    //     $readmemh("ref_test.txt", ref_mem);
    // end

    wire        cur_mem_en  ;
    wire        ref_mem_en  ;
    wire [31:0] cur_mem_addr;
    wire [31:0] ref_mem_addr;
    wire [63:0] cur_in      ;
    wire [63:0] ref_in      ;
    wire        need_cur    ;
    wire        need_ref    ;
    wire [13:0] MSAD        ;
    wire [ 4:0] MSAD_column ;
    wire [ 4:0] MSAD_row    ;
    wire        data_valid  ;

    ME_highBW U_ME_highBW (
        .clk         (clk         ),
        .rst         (rst         ),
        .en_i        (en_i        ),
        .cur_in_i    (cur_in      ),
        .ref_in_i    (ref_in      ),
        .cur_mem_addr(cur_mem_addr),
        .ref_mem_addr(ref_mem_addr),
        .cur_mem_en  (cur_mem_en  ),
        .ref_mem_en  (ref_mem_en  ),
        .MSAD        (MSAD        ),
        .MSAD_column (MSAD_column ),
        .MSAD_row    (MSAD_row    ),
        .data_valid  (data_valid  )
    );

    cur_mem_highBW U_cur_mem_highBW (
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