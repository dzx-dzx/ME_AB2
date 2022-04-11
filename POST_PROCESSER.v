module POST_PROCESSOR #(parameter SAD_BIT_WIDTH=14) (
    input                          clk               ,
    input                          rst               ,
    input      [SAD_BIT_WIDTH-1:0] MSAD_interim      ,
    input      [              3:0] MSAD_index_interim,
    input                          en                ,
    output reg [SAD_BIT_WIDTH-1:0] MSAD              ,
    output reg [              3:0] MSAD_index
);
    always @(posedge clk or negedge rst) begin
        if(rst)begin
            MSAD       <= {SAD_BIT_WIDTH{1'b1}};
            MSAD_index <= 0;
        end
        else begin
            if(!en)begin
                MSAD       <= {SAD_BIT_WIDTH{1'b1}};
                MSAD_index <= 0;
            end
            else if(MSAD>MSAD_interim)begin
                MSAD       <= MSAD_interim;
                MSAD_index <= MSAD_index_interim;
            end
            else begin
                MSAD       <= MSAD;
                MSAD_index <= MSAD_index;
            end
        end
    end
endmodule