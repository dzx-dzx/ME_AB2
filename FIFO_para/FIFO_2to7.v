module FIFO_2to7(
input clk_i,
input rst_n_i,
input wire [OUTPUT_WIDTH - 1:0]data_in0,
input wire [STAGE_OUT_WIDTH - 1:0]data_in1,
output wire [OUTPUT_WIDTH - 1:0]data_out0,
output reg [STAGE_OUT_WIDTH - 9:0]data_out1
);

parameter OUTPUT_WIDTH = 128;
parameter STAGE_OUT_WIDTH = 56;

always@(posedge clk_i or negedge rst_n_i)
begin
    if(!rst_n_i)
    begin
        data_out1 <= 0;
    end
    else
    begin
        data_out1 <= data_in1[55:8];
    end
end

assign data_out0 = { data_in1[7:0] , data_in0[127:8] };

endmodule

