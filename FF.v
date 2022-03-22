module FF #(parameter BITS = 16) (
    input      [BITS-1:0] in ,
    input                 clk,
    output reg [BITS-1:0] out
);
    always@(posedge clk)begin
        out <= in;
    end
endmodule
