module FIFO_6 (
    input               clk_i    ,
    input               rst_n_i  ,
    input  wire [127:0] data_in0 ,
    input  wire [ 23:0] data_in1 ,
    output wire [127:0] data_out0,
    output reg  [ 15:0] data_out1
);

    always@(posedge clk_i or negedge rst_n_i)
        begin
            if(!rst_n_i)
                begin
                    data_out1 <= 0;
                end
            else
                begin
                    data_out1 <= data_in1[23:8];
                end
        end

    assign data_out0 = { data_in1[7:0] , data_in0[127:8] };

endmodule

