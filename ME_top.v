`timescale 1ns/1ns
module ME_top (
    input clk        ,
    input rst        ,
    input en_i       ,
    input finish_flag
);

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ME_top);
    end

    always @(posedge clk) begin
        if (finish_flag)
            $finish;
    end


    always @(posedge clk) begin
        if(data_valid) begin
            $display("%d at (%d,%d)",MSAD,8 - MSAD_column,MSAD_row - 6);
        end
    end

    wire               cur_mem_en ;
    wire               ref_mem_en ;
    wire               cur_read_en;
    wire               ref_read_en;
    wire        [31:0] cur_in     ;
    wire        [63:0] ref_in     ;
    wire               need_cur   ;
    wire               need_ref   ;
    wire signed [13:0] MSAD       ;
    wire signed [ 4:0] MSAD_column;
    wire signed [ 4:0] MSAD_row   ;
    wire               data_valid ;

    ME U_ME (
        .clk        (clk        ),
        .rst        (rst        ),
        .en_i       (en_i       ),
        .cur_in_i   (cur_in     ),
        .ref_in_i   (ref_in     ),
        .cur_read_en(cur_read_en),
        .ref_read_en(ref_read_en),
        .MSAD       (MSAD       ),
        .MSAD_column(MSAD_column),
        .MSAD_row   (MSAD_row   ),
        .data_valid (data_valid )
    );

    cur_mem U_cur_mem (
        .clk     (clk        ),
        .rst     (rst        ),
        .read_en (cur_read_en),
        .cur_data(cur_in     )
    );

    ref_mem U_ref_mem (
        .clk     (clk        ),
        .rst     (rst        ),
        .read_en (ref_read_en),
        .ref_data(ref_in     )
    );
endmodule