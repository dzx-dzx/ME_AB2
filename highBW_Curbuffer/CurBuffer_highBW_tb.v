`timescale  1ns / 1ns

module CurBuffer_highBW_tb ();

    reg          clk         ;
    reg          rst         ;
    reg          en          ;
    reg          en_i        ;
    reg          next_block  ;
    wire [ 63:0] cur_in_i    ;
    reg  [ 63:0] cur_in      ;
    wire [511:0] cur_out     ;
    wire [ 31:0] cur_mem_addr;


    initial begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    initial begin
        next_block = 0;
        # 305;
        forever begin
            # 200 next_block = ~next_block;
            # 10 next_block = ~next_block;
        end
    end

    initial begin
        rst = 1'b1;
        en_i = 0;
        #10 rst = 1'b0;
        #10 en_i = 1;
        #10000 $finish;
    end

    initial begin
        $dumpfile("cur_wave.vcd");
        $dumpvars(0, CurBuffer_highBW_tb);
    end

    always @(posedge clk) begin
        if (!rst) begin
            en     <= en_i;
            cur_in <= cur_in_i;
        end
    end


    CurBuffer_highBW U_CurBuffer_highBW (
        .clk         (clk         ),
        .rst         (rst         ),
        .en          (en          ),
        .next_block  (next_block  ),
        .cur_in      (cur_in      ),
        .cur_out     (cur_out     ),
        .cur_mem_addr(cur_mem_addr)
    );

    cur_mem_highBW U_cur_mem_highBW (
        .en      (en          ),
        .addr    (cur_mem_addr),
        .cur_data(cur_in_i    )
    );


endmodule
