`timescale 1ns/1ns

module RefSRAM_tb ();

// Parameters

// Ports
    reg          clk        = 0;
    reg          rst           ;
    reg  [ 63:0] ref_in        ;
    wire [183:0] ref_out       ;
    wire         sram_ready    ;

    reg [ 7:0] mem     [0:5000];
    reg [11:0] mem_addr        ;

    initial begin
        $readmemh("./ref_test.txt", mem);
    end

    always @(posedge clk) begin
        if (rst) begin
            mem_addr <= 0;
        end
        else begin
            mem_addr <= mem_addr + 8;
        end
    end

    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1)
            always @(posedge clk) begin
                if (!rst)
                    ref_in[8*i+7:(i)*8] = mem[mem_addr+i];
            end
    endgenerate

    RefSRAM RefSRAM_dut (
        .clk       (clk       ),
        .rst       (rst       ),
        .ref_in    (ref_in    ),
        .ref_out   (ref_out   ),
        .sram_ready(sram_ready)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, RefSRAM_tb);
        #3000 $finish;
    end

    initial begin
        clk = 0;
        rst = 1;
        #20 rst = 0;
    end

    always
        #5  clk = ! clk ;

endmodule
