`timescale 1ns/1ns
module ME_tb ();
    reg clk ;
    reg rst ;
    reg en_i;

    initial begin
        clk = 1'b0;
        forever
            #5 clk = ~clk;
    end

    integer fd;

    initial begin
        rst = 1'b1;
        en_i = 1'b0;
        #10 rst = 1'b0;
        #20 en_i = 1'b1;
        #30000 $fclose(fd);
        $finish;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, ME_tb);
        fd = $fopen("./output","w");
    end

    always @(posedge clk) begin
        if(data_valid) begin
            $fdisplay(fd,"%d at (%d,%d)",MSAD,MSAD_row,MSAD_column);
            $display("%d at (%d,%d)",MSAD,MSAD_row,MSAD_column);
        end
    end

    // initial begin
    //     $readmemh("cur_test.txt", cur_mem);
    //     $readmemh("ref_test.txt", ref_mem);
    // end

    wire        cur_mem_en ;
    wire        ref_mem_en ;
    wire        cur_read_en;
    wire        ref_read_en;
    wire [31:0] cur_in     ;
    wire [63:0] ref_in     ;
    wire        need_cur   ;
    wire        need_ref   ;
    wire [13:0] MSAD       ;
    wire [ 4:0] MSAD_column;
    wire [ 4:0] MSAD_row   ;
    wire        data_valid ;

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