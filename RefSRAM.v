// Cold boot requires 69 cycles

module RefSRAM (
    input               clk       ,
    input               rst       ,
    input               next_line ,
    input  wire [ 63:0] ref_in    , // 8 pixels
    output wire [183:0] ref_out   , // 23 pixels
    output reg          sram_ready
);

    reg [4:0] addr      ;
    reg [3:0] sram_write; // Which sram is at WRITE state

    wire [63:0] q_1;
    wire [63:0] q_2;
    wire [63:0] q_3;
    wire [63:0] q_4;

    wire we_1;
    wire we_2;
    wire we_3;
    wire we_4;

    assign we_1 = (sram_write[0] == 1);
    assign we_2 = (sram_write[1] == 1);
    assign we_3 = (sram_write[2] == 1);
    assign we_4 = (sram_write[3] == 1);

    wire       me  ;
    wire       test;
    wire       rme ;
    wire [3:0] rm  ;
    assign me   = 1;
    assign test = 0;
    assign rme  = 0;
    assign rm   = 4'b0000;

    assign ref_out = we_1 ? {q_2, q_3, q_4[63:8]}
        :we_2 ? {q_3, q_4, q_1[63:8]}
        :we_3 ? {q_4, q_1, q_2[63:8]}
        :{q_1, q_2, q_3[63:8]}

        // All SRAM share the same address
        always @(posedge clk or posedge rst) begin
            if (rst || next_line) begin
                addr       <= 0;
                sram_write <= 0;
            end
            else begin
                if (addr == 5'h22) begin
                    sram_write <= (sram_write == 4'b1000) ? 4'b0001 : sram_write << 1;
                    addr       <= 0;
                end
                else begin
                    addr += 1;
                end
            end
        end

    // First time write sram_4 => Sram is ready
    always @(posedge clk or posedge rst) begin
        if (rst || next_line) begin
            sram_ready <= 0;
        end
        else if (sram_ready == 0 && sram_write == 4'b1000) begin
            sram_ready <= 1;
        end
    end

    sadslspkb1p24x64m4b1w0cp0d0t0 U_SRAM_1 (
        .Q    (q_1   ),
        .ADR  (addr  ),
        .D    (ref_in),
        .WE   (we_1  ),
        .ME   (me    ),
        .CLK  (clk   ),
        .TEST1(test  ),
        .RME  (rme   ),
        .RM   (rm    )
    );

    sadslspkb1p24x64m4b1w0cp0d0t0 U_SRAM_2 (
        .Q    (q_2   ),
        .ADR  (addr  ),
        .D    (ref_in),
        .WE   (we_2  ),
        .ME   (me    ),
        .CLK  (clk   ),
        .TEST1(test  ),
        .RME  (rme   ),
        .RM   (rm    )
    );

    sadslspkb1p24x64m4b1w0cp0d0t0 U_SRAM_3 (
        .Q    (q_3   ),
        .ADR  (addr  ),
        .D    (ref_in),
        .WE   (we_3  ),
        .ME   (me    ),
        .CLK  (clk   ),
        .TEST1(test  ),
        .RME  (rme   ),
        .RM   (rm    )
    );

    sadslspkb1p24x64m4b1w0cp0d0t0 U_SRAM_4 (
        .Q    (q_4   ),
        .ADR  (addr  ),
        .D    (ref_in),
        .WE   (we_4  ),
        .ME   (me    ),
        .CLK  (clk   ),
        .TEST1(test  ),
        .RME  (rme   ),
        .RM   (rm    )
    );

endmodule