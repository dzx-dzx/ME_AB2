`timescale 1ns/1ns

module RefSRAM_tb ();

// Parameters

// Ports
    reg          clk        = 0;
    reg          rst           ;
    reg          en            ;
    wire [ 63:0] ref_in        ;
    wire [183:0] ref_out       ;
    wire         sram_ready    ;
    wire         next_block    ;

    wire [31:0] ref_mem_addr;

    ref_mem U_ref_mem (
        .en      (en          ),
        .addr    (ref_mem_addr),
        .ref_data(ref_in      )
    );

    RefSRAM U_RefSRAM (
        .clk         (clk         ),
        .rst         (rst         ),
        .en          (en          ),
        .ref_in      (ref_in      ),
        .ref_out     (ref_out     ),
        .ref_mem_addr(ref_mem_addr),
        .sram_ready  (sram_ready  ),
        .next_block  (next_block  )
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, RefSRAM_tb);
        #3000 $finish;
    end

    initial begin
        clk = 0;
        rst = 1;
        en = 0;
        #20 rst = 0;
        #20 en = 1;
    end

    always
        #5  clk = ! clk ;

endmodule
