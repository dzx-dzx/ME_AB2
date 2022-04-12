// +FHDR-------------------------------------------------------------------
// FILE NAME:
// TYPE:
// DEPARTMENT:
// AUTHOR:
// AUTHOR'S EMAIL:
// ------------------------------------------------------------------------
// KEYWORDS:
// ------------------------------------------------------------------------
// PARAMETERS
//
// ------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy:
// Clock Domains:
// Critical Timing:
// Test Features:
// Asynchronous I/F:
// Scan Methodology:
// Instantiations:
// -FHDR-------------------------------------------------------------------

module FIFO (
    input               clk_i    ,
    input               rst_i    ,
    input  wire [183:0] data_in  ,
    output wire [127:0] data_out0,
    output wire [127:0] data_out1,
    output wire [127:0] data_out2,
    output wire [127:0] data_out3,
    output wire [127:0] data_out4,
    output wire [127:0] data_out5,
    output wire [127:0] data_out6,
    output wire [127:0] data_out7
);

    wire [55:0] trans_0;
    wire [47:0] trans_1;
    wire [39:0] trans_2;
    wire [31:0] trans_3;
    wire [23:0] trans_4;
    wire [15:0] trans_5;
    wire [ 7:0] trans_6;

    wire [119:0] data_reg0;
    wire [119:0] data_reg1;
    wire [119:0] data_reg2;
    wire [119:0] data_reg3;
    wire [119:0] data_reg4;
    wire [119:0] data_reg5;
    wire [119:0] data_reg6;

    FIFO_0 unit_0 (
        .clk_i    (clk_i    ),
        .rst_i    (rst_i    ),
        .data_in  (data_in  ),
        .data_out0(data_out0),
        .data_out1(trans_0  ),
        .data_reg0(data_reg0)
    );

    FIFO_1to6 #(
        .OUTPUT_WIDTH   (128),
        .STAGE_OUT_WIDTH(56 )
    ) unit_1 (
        .clk_i    (clk_i    ),
        .rst_i    (rst_i    ),
        .data_in0 (data_reg0),
        .data_in1 (trans_0  ),
        .data_out0(data_out1),
        .data_out1(trans_1  ),
        .data_reg (data_reg1)
    );

    FIFO_1to6 #(
        .OUTPUT_WIDTH   (128),
        .STAGE_OUT_WIDTH(48 )
    ) unit_2 (
        .clk_i    (clk_i    ),
        .rst_i    (rst_i    ),
        .data_in0 (data_reg1),
        .data_in1 (trans_1  ),
        .data_out0(data_out2),
        .data_out1(trans_2  ),
        .data_reg (data_reg2)
    );

    FIFO_1to6 #(
        .OUTPUT_WIDTH   (128),
        .STAGE_OUT_WIDTH(40 )
    ) unit_3 (
        .clk_i    (clk_i    ),
        .rst_i    (rst_i    ),
        .data_in0 (data_reg2),
        .data_in1 (trans_2  ),
        .data_out0(data_out3),
        .data_out1(trans_3  ),
        .data_reg (data_reg3)
    );

    FIFO_1to6 #(
        .OUTPUT_WIDTH   (128),
        .STAGE_OUT_WIDTH(32 )
    ) unit_4 (
        .clk_i    (clk_i    ),
        .rst_i    (rst_i    ),
        .data_in0 (data_reg3),
        .data_in1 (trans_3  ),
        .data_out0(data_out4),
        .data_out1(trans_4  ),
        .data_reg (data_reg4)
    );

    FIFO_1to6 #(
        .OUTPUT_WIDTH   (128),
        .STAGE_OUT_WIDTH(24 )
    ) unit_5 (
        .clk_i    (clk_i    ),
        .rst_i    (rst_i    ),
        .data_in0 (data_reg4),
        .data_in1 (trans_4  ),
        .data_out0(data_out5),
        .data_out1(trans_5  ),
        .data_reg (data_reg5)
    );

    FIFO_1to6 #(
        .OUTPUT_WIDTH   (128),
        .STAGE_OUT_WIDTH(16 )
    ) unit_6 (
        .clk_i    (clk_i    ),
        .rst_i    (rst_i    ),
        .data_in0 (data_reg5),
        .data_in1 (trans_5  ),
        .data_out0(data_out6),
        .data_out1(trans_6  ),
        .data_reg (data_reg6)
    );

    FIFO_7 unit_7 (
        .clk_i   (clk_i    ),
        .rst_i   (rst_i    ),
        .data_in0(data_reg6),
        .data_in1(trans_6  ),
        .data_out(data_out7)
    );

endmodule