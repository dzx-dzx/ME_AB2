module FIFO_8 (
    input               clk_i   ,
    input               rst_n_i ,
    input  wire [127:0] data_in0,
    input  wire [  7:0] data_in1,
    output wire [127:0] data_out
);

    assign data_out = { data_in1[7:0] , data_in0[127:8] };

endmodule
