module MIN #(
        parameter BIT_WIDTH=14,
        parameter PREVIOUS_INDEX_WIDTH = 1
    ) (
        input [BIT_WIDTH-1:0] element0,
        input [BIT_WIDTH-1:0] element1,
        input [PREVIOUS_INDEX_WIDTH-1:0] previous_index0,
        input [PREVIOUS_INDEX_WIDTH-1:0] previous_index1,
        output reg [PREVIOUS_INDEX_WIDTH:0] index,
        output reg [BIT_WIDTH-1:0] element
    );
    always @(*)
    begin

        element=element0<element1?element0:element1;
    end
        always @(*)
        begin
                index={~(element0<element1), element0<element1?previous_index0:previous_index1};
        end
endmodule
