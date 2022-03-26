module FIFO_1(
input clk_i,
input rst_n_i,
input wire [183:0]data_in,
output wire [127:0]data_out0,
output reg [55:0]data_out1
);

always@(posedge clk_i or negedge rst_n_i)
begin
    if(!rst_n_i)
    begin
        data_out1 <= 0;
    end
    else
    begin
        data_out1 <= data_in[183:136];
    end
end

assign data_out0 = data_in[127:0];

endmodule
