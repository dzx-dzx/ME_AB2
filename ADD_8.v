`include "ADD.v"
module ADD_8 #(
        parameter ELEMENT_BIT_DEPTH = 14
    ) (
        input [ELEMENT_BIT_DEPTH*8-1:0] addend_array,
        output reg [ELEMENT_BIT_DEPTH-1:0] add
    );
    genvar i;
    wire [ELEMENT_BIT_DEPTH-1:0] add_intermediate_4;

    generate

        wire [ELEMENT_BIT_DEPTH*4-1:0] add_intermediate_1;
        for(i=0;i<4;i=i+1)
        begin
            ADD #(
                .BIT_WIDTH(ELEMENT_BIT_DEPTH)
            ) add(
                .element0(addend_array[(2*i+1)*ELEMENT_BIT_DEPTH-1:(2*i)*ELEMENT_BIT_DEPTH]),
                .element1(addend_array[(2*i+2)*ELEMENT_BIT_DEPTH-1:(2*i+1)*ELEMENT_BIT_DEPTH]),
                .element(add_intermediate_1[(i+1)*ELEMENT_BIT_DEPTH-1:i*ELEMENT_BIT_DEPTH])
            );
        end

        wire [ELEMENT_BIT_DEPTH*2-1:0] add_intermediate_2;
        for(i=0;i<2;i=i+1)
        begin
            ADD #(
                .BIT_WIDTH(ELEMENT_BIT_DEPTH)
            ) add(
                .element0(add_intermediate_1[(2*i+1)*ELEMENT_BIT_DEPTH-1:(2*i)*ELEMENT_BIT_DEPTH]),
                .element1(add_intermediate_1[(2*i+2)*ELEMENT_BIT_DEPTH-1:(2*i+1)*ELEMENT_BIT_DEPTH]),
                .element(add_intermediate_2[(i+1)*ELEMENT_BIT_DEPTH-1:i*ELEMENT_BIT_DEPTH])
            );
        end

        wire [ELEMENT_BIT_DEPTH-1:0] add_intermediate_3;
        for(i=0;i<1;i=i+1)
        begin
            ADD #(
                .BIT_WIDTH(ELEMENT_BIT_DEPTH)
            ) add(
                .element0(add_intermediate_2[(2*i+1)*ELEMENT_BIT_DEPTH-1:(2*i)*ELEMENT_BIT_DEPTH]),
                .element1(add_intermediate_2[(2*i+2)*ELEMENT_BIT_DEPTH-1:(2*i+1)*ELEMENT_BIT_DEPTH]),
                .element(add_intermediate_3[(i+1)*ELEMENT_BIT_DEPTH-1:i*ELEMENT_BIT_DEPTH])
            );
        end
    endgenerate
    always @(*)
    begin
      add=add_intermediate_3;
    end
endmodule
