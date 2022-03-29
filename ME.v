`include "CurBuffer.v"
`include "RefSRAM.v"

`include "FIFO.v"

`include "AD_ARRAY.v"

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
    reg  [ 13:0] ref_line_cnt ; //Every row (4096) costs 11086 (482 blocks * 23 cycles/block) cycles, which needs 14 bits to store and count.
    wire [183:0] ref_out      ;
    wire         sram_ready   ; // When the SRAM is ready, set high for one cycle.

    // CurBuffer related
    wire         cur_read_start   ; // When cur start to read, set high for one cycle.
    wire         cur_read_enable  ; // When CurBuffer is set to read, set high.
    wire         cur_next_block   ; // When AD needs data from the next cur block, set high for 1 cycle.
    wire [511:0] cur_out          ; // Data outputt from CurBuffer to AD;
    reg  [  4:0] cur_read_cnt     ;
    reg  [  2:0] cur_cold_boot_cnt; // Counter for cold boot. Cur read 2 blocks during cold boot.

    assign ref_next_line   = (ref_line_cnt == 0);
    assign cur_read_enable = (cur_read_cnt > 0);

    assign need_cur = cur_read_enable;
    assign need_ref = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ref_line_cnt <= 0;
        end
        else begin
            if (ref_line_cnt > 0) begin
                ref_line_cnt <= ref_line_cnt - 1;
            end
            else begin
                ref_line_cnt <= 11086;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cur_read_cnt      <= 0;
            cur_cold_boot_cnt <= 2;
        end
        else if (cur_read_cnt > 0) begin
            cur_read_cnt <= cur_read_cnt - 1;
        end
        else if (cur_read_start || cur_cold_boot_cnt > 0) begin
            cur_read_cnt <= 16;
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

    wire [1023:0] reference_input_column;

    FIFO fifo (
        .clk_i    (clk                             ),
        .rst_n_i  (rst                             ),
        .data_in  (ref_out                         ),
        .data_out0(reference_input_column[127:0]   ),
        .data_out1(reference_input_column[255:128] ),
        .data_out2(reference_input_column[383:256] ),
        .data_out3(reference_input_column[511:384] ),
        .data_out4(reference_input_column[639:512] ),
        .data_out5(reference_input_column[767:640] ),
        .data_out6(reference_input_column[895:768] ),
        .data_out7(reference_input_column[1023:896])
    );

    parameter PIXELS_IN_BATCH = 16;
    parameter EDGE_LEN        = 8 ;
    parameter BIT_DEPTH       = 8 ;

    wire [EDGE_LEN*EDGE_LEN*BIT_DEPTH-1:0] current_input_complete;

    genvar i,j;
    generate
        for(i=0;i<EDGE_LEN;i=i+1)
            begin
                for(j=0;j<EDGE_LEN;j=j+1)
                    begin
                        assign current_input_complete[(i*EDGE_LEN+j+1)*BIT_DEPTH-1:(i*EDGE_LEN+j)*BIT_DEPTH] = cur_out[(j*EDGE_LEN+i+1)*BIT_DEPTH-1:(j*EDGE_LEN+i)*BIT_DEPTH];
                    end
            end
    endgenerate

    AD_ARRAY #(
        .PIXELS_IN_BATCH(16),
        .EDGE_LEN       (8 ),
        .LOG_EDGE_LEN   (3 ),
        .BIT_DEPTH      (8 )
    ) ad_array (
        .clk                   (clk),
        .rst                   (rst),
        .reference_input_column(reference_input_column),
        .current_input_complete(current_input_complete),
        .SAD                   (   )
    );

endmodule