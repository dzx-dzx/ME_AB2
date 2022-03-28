`include "FIFO_1.v"
`include "FIFO_2to7.v"
`include "FIFO_8.v"

module FIFO(
    input clk_i,
    input rst_n_i,
    input wire [183:0]data_in,
    output wire [127:0]data_out0,
    output wire [127:0]data_out1,
    output wire [127:0]data_out2,
    output wire [127:0]data_out3,
    output wire [127:0]data_out4,
    output wire [127:0]data_out5,
    output wire [127:0]data_out6,
    output wire [127:0]data_out7
);

wire [55:0] trans_0;
wire [47:0] trans_1;
wire [39:0] trans_2;
wire [31:0] trans_3;
wire [23:0] trans_4;
wire [15:0] trans_5;
wire [ 7:0] trans_6;

FIFO_1 unit_1 (
    .clk_i    (clk_i    ),
    .rst_n_i  (rst_n_i  ),
    .data_in  (data_in  ),
    .data_out0(data_out0),
    .data_out1(trans_0  )
);

FIFO_2to7 #(
    .OUTPUT_WIDTH   (128),
    .STAGE_OUT_WIDTH(56 )
) unit_2 (
    .clk_i    (clk_i    ),
    .rst_n_i  (rst_n_i  ),
    .data_in0 (data_out0),
    .data_in1 (trans_0  ),
    .data_out0(data_out1),
    .data_out1(trans_1  )
);

FIFO_2to7 #(
    .OUTPUT_WIDTH   (128),
    .STAGE_OUT_WIDTH(48 )
) unit_3 (
    .clk_i    (clk_i    ),
    .rst_n_i  (rst_n_i  ),
    .data_in0 (data_out1),
    .data_in1 (trans_1  ),
    .data_out0(data_out2),
    .data_out1(trans_2  )
);

FIFO_2to7 #(
    .OUTPUT_WIDTH   (128),
    .STAGE_OUT_WIDTH(40 )
) unit_4 (
    .clk_i    (clk_i    ),
    .rst_n_i  (rst_n_i  ),
    .data_in0 (data_out2),
    .data_in1 (trans_2  ),
    .data_out0(data_out3),
    .data_out1(trans_3  )
);

FIFO_2to7 #(
    .OUTPUT_WIDTH   (128),
    .STAGE_OUT_WIDTH(32 )
) unit_5 (
    .clk_i    (clk_i    ),
    .rst_n_i  (rst_n_i  ),
    .data_in0 (data_out3),
    .data_in1 (trans_3  ),
    .data_out0(data_out4),
    .data_out1(trans_4  )
);

FIFO_2to7 #(
    .OUTPUT_WIDTH   (128),
    .STAGE_OUT_WIDTH(24 )
) unit_6 (
    .clk_i    (clk_i    ),
    .rst_n_i  (rst_n_i  ),
    .data_in0 (data_out4),
    .data_in1 (trans_4  ),
    .data_out0(data_out5),
    .data_out1(trans_5  )
);

FIFO_2to7 #(
    .OUTPUT_WIDTH   (128),
    .STAGE_OUT_WIDTH(16 )
) unit_7 (
    .clk_i    (clk_i    ),
    .rst_n_i  (rst_n_i  ),
    .data_in0 (data_out5),
    .data_in1 (trans_5  ),
    .data_out0(data_out6),
    .data_out1(trans_6  )
);

FIFO_8 unit_8 (
    .clk_i   (clk_i    ),
    .rst_n_i (rst_n_i  ),
    .data_in0(data_out6),
    .data_in1(trans_6  ),
    .data_out(data_out7)
);

endmodule