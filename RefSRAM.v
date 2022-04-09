`timescale 1 ns / 1 ns
`include "sadslspkb1p24x64m4b1w0cp0d0t0.v"
// Cold boot requires 69 cycles


module RefSRAM (
    input               clk       ,
    input               rst       ,
    input  wire [ 63:0] ref_in    , // 8 pixels
    output wire         read_en   ,
    output reg  [183:0] ref_out   , // 23 pixels
    output reg          sram_ready, // Set high when ref_out is valid.
    output reg          next_block  // Set high when CurBuffer need to past the next block
);

    reg [4:0] addr           ;
    reg [3:0] sram_is_written; // Which sram is at WRITE state

    assign read_en = sram_is_written != 4'b0000;

    wire [63:0] q_1;
    wire [63:0] q_2;
    wire [63:0] q_3;
    wire [63:0] q_4;

    wire we_1;
    wire we_2;
    wire we_3;
    wire we_4;

    assign we_1 = (sram_is_written[0] == 1);
    assign we_2 = (sram_is_written[1] == 1);
    assign we_3 = (sram_is_written[2] == 1);
    assign we_4 = (sram_is_written[3] == 1);

    wire       me  ;
    wire       test;
    wire       rme ;
    wire [3:0] rm  ;
    assign me   = 1;
    assign test = 0;
    assign rme  = 0;
    assign rm   = 4'b0000;

    reg [9:0] block_cnt;
    reg       next_line;


    always @(*) begin
        if (addr != 0)
            case (sram_is_written)
                4'b0001 :
                    ref_out <= {q_2, q_3, q_4[63:8]};
                4'b0010 :
                    ref_out <= {q_3, q_4, q_1[63:8]};
                4'b0100 :
                    ref_out <= {q_4, q_1, q_2[63:8]};
                4'b1000 :
                    ref_out <= {q_1, q_2, q_3[63:8]};
                default :
                    ref_out <= 0;
            endcase
        else
            case (sram_is_written)
                4'b0001 :
                    ref_out <= {q_1, q_2, q_3[63:8]};
                4'b0010 :
                    ref_out <= {q_2, q_3, q_4[63:8]};
                4'b0100 :
                    ref_out <= {q_3, q_4, q_1[63:8]};
                4'b1000 :
                    ref_out <= {q_4, q_1, q_2[63:8]};
                default : ref_out <= 0;
            endcase
    end

    // All SRAM share the same address
    always @(posedge clk) begin
        if (rst) begin
            addr            <= 0;
            sram_is_written <= 4'b0001;
            block_cnt       <= 0;
            next_line       <= 0;
        end
        else begin
            // entry to next block
            if (addr == 5'd22) begin
                addr <= 0;
                if(block_cnt == 481) begin // ALready written one whole line
                    next_line       <= 1;
                    sram_is_written <= 4'b0000; // Forbid all written
                    block_cnt       <= 1023;
                end
                else begin
                    if(block_cnt == 1023) begin
                        sram_is_written <= 4'b0001;
                        next_line       <= 0;
                    end
                    else
                        sram_is_written <= (sram_is_written == 4'b1000) ? 4'b0001 : sram_is_written << 1;
                    block_cnt <= block_cnt + 1;
                end
            end
            else begin
                addr <= addr + 1;
            end
        end
    end

    // Next block for CurBuffer
    always @(posedge clk) begin
        if (rst)
            next_block <= 0;
        else if (sram_ready && addr == 8)
            next_block <= 1;
        else next_block <= 0;
    end

    // First time write sram_4 => Sram is ready
    always @(posedge clk) begin
        if (rst) begin
            sram_ready <= 0;
        end
        else if (next_line) begin
            sram_ready <= 0;
        end
        else if (sram_ready == 0 && sram_is_written == 4'b1000) begin
            sram_ready <= 1;
        end
        else
            sram_ready <= sram_ready;
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