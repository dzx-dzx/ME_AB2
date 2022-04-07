module MIN_LEAF #(
        parameter BIT_WIDTH=14
    ) (
        input [BIT_WIDTH-1:0] element0,
        input [BIT_WIDTH-1:0] element1,
        output reg index,
        output reg [BIT_WIDTH-1:0] element
    );
    always @(*)
    begin
        element=element0<element1?element0:element1;
    end
        always @(*)
        begin
                index=element0>element1;
        end
endmodule
