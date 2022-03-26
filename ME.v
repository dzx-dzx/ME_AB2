`include "CurBuffer.v"
`include "RefSRAM.v"

`timescale 1 ns / 1 ps

module ME (
    input              clk     ,
    input              rst     ,
    input  wire [31:0] cur_in  , // 4 pixels
    input  wire [63:0] ref_in  , // 8 pixels
    output wire        need_cur, // ask for cur_in
    output wire        need_ref  // ask for ref_in
);


    // RefSRAM related
    wire         ref_next_line; // When switching to the next line, set high.
    wire [183:0] ref_out      ;
    wire         sram_ready   ; // When the SRAM is ready, set high for one cycle.

    // CurBuffer related
    wire         cur_read_start   ; // When cur start to read, set high for one cycle.
    wire         cur_read_enable  ; // When CurBuffer is set to read, set high.
    wire         cur_next_block   ; // When AD needs data from the next cur block, set high for 1 cycle.
    wire [511:0] cur_out          ; // Data outputt from CurBuffer to AD;
    reg  [  4:0] cur_read_cnt     ;
    reg  [  2:0] cur_cold_boot_cnt; // Counter for cold boot. Cur read 2 blocks during cold boot.

    assign cur_read_enable = (cur_read_cnt > 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cur_read_cnt      <= 0;
            cur_cold_boot_cnt <= 2;
        end
        else if (cur_read_cnt > 0) begin
            cur_read_cnt <= cur_read_cnt - 1;
        end
        else if (cur_read_start || cur_cold_boot_cnt > 0) begin
            cur_read_cnt <= 8;
        end
    end


    RefSRAM U_RefSRAM (
        .clk       (clk          ),
        .rst       (rst          ),
        .next_line (ref_next_line),
        .ref_in    (ref_in       ),
        .ref_out   (ref_out      ),
        .sram_ready(sram_ready   )
    );

    CurBuffer U_CurBuffer (
        .clk       (clk            ),
        .rst       (rst            ),
        .next_block(cur_next_block ),
        .read_en   (cur_read_enable),
        .cur_in    (cur_in         ),
        .cur_out   (cur_out        )
    );



endmodule