`timescale 1ns/1ns

module RefSRAM_tb ();

// Parameters

// Ports
    reg          clk        = 0;
    reg          rst           ;
    reg          en_i          ;
    wire [ 63:0] ref_in_i      ;
    wire [183:0] ref_out       ;
    wire         sram_ready    ;
    wire         next_block    ;

    wire read_en;

    reg [63:0] ref_in;
    reg        en    ;

    always @(posedge clk) begin
        if (rst) begin
            en_i   <= 0;
            ref_in <= 0;
        end
        else begin
            en     <= en_i;
            ref_in <= ref_in_i;
        end
    end

    ref_mem U_ref_mem (
        .clk     (clk     ),
        .rst     (rst     ),
        .read_en (read_en ),
        .ref_data(ref_in_i)
    );

    RefSRAM U_RefSRAM (
        .clk       (clk       ),
        .rst       (rst       ),
        .en        (en        ),
        .ref_in    (ref_in    ),
        .ref_out   (ref_out   ),
        .read_en   (read_en   ),
        .sram_ready(sram_ready),
        .next_block(next_block)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, RefSRAM_tb);
        #5000 $finish;
    end

    initial begin
        clk = 0;
        rst = 1;
        en_i = 0;
        #20 rst = 0;
        #20 en_i = 1;
    end

    always
        #5  clk = ! clk ;

endmodule
