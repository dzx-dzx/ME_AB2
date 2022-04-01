`include "ADD_8.v"
module ADD_8_tb;

// Parameters
localparam ELEMENT_BIT_DEPTH = 14;

// Ports
reg  [ELEMENT_BIT_DEPTH*8-1:0] addend_array;
wire [  ELEMENT_BIT_DEPTH-1:0] add         ;

ADD_8 #(
    .ELEMENT_BIT_DEPTH(                 
                       ELEMENT_BIT_DEPTH)  
) ADD_8_dut (
    .addend_array(addend_array),
    .add         (add         )
);

initial begin
    begin
        $dumpfile("ADD_8.vcd");
        $dumpvars(0, ADD_8_tb);
        addend_array={14'h0769,14'h0182,14'h07b9,14'h0575,
                      14'h0668,14'h034d,14'h0286,14'h02d8};
        #5 $finish;
    end
end


endmodule
