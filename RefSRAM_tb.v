`timescale 1ns/1ns

module RefSRAM_tb ();

// Parameters

// Ports
    reg          clk        = 0;
    reg          rst           ;
    reg  [ 63:0] ref_in        ;
    wire [183:0] ref_out       ;
    wire         sram_ready    ;
    wire         next_block    ;
    wire         read_en       ;

    reg [ 7:0] mem     [0:7000];
    reg [11:0] mem_addr        ;

    initial begin
        $readmemh("./data_preprocess/data/ref_test.txt", mem);
    end


    // always @(posedge clk) begin
    //     if (rst) begin
    //         mem_addr <= 0;
    //         ref_in   <= 0;
    //     end
    //     else if(read_en) begin
    //         ref_in[7:0]   <= mem[mem_addr + 0];
    //         ref_in[15:8]  <= mem[mem_addr + 1];
    //         ref_in[23:16] <= mem[mem_addr + 2];
    //         ref_in[31:24] <= mem[mem_addr + 3];
    //         ref_in[39:32] <= mem[mem_addr + 4];
    //         ref_in[47:40] <= mem[mem_addr + 5];
    //         ref_in[55:48] <= mem[mem_addr + 6];
    //         ref_in[63:56] <= mem[mem_addr + 7];

    //         mem_addr <= mem_addr + 8;
    //     end
    //     else ;
    // end

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
            always @(*) begin
                if (!rst)
                    ref_in[8*i+7:(i)*8] <= mem[mem_addr+i];
            end
    endgenerate

    RefSRAM RefSRAM_dut (
        .clk       (clk       ),
        .rst       (rst       ),
        .ref_in    (ref_in    ),
        .read_en   (read_en   ),
        .ref_out   (ref_out   ),
        .sram_ready(sram_ready),
        .next_block(next_block)
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
