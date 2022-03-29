`include "MIN_16.v"
module MIN_16_tb;

  // Parameters
  localparam  ELEMENT_BIT_DEPTH = 14;

  // Ports
  reg [ELEMENT_BIT_DEPTH*16-1:0] min_array;
  wire [ELEMENT_BIT_DEPTH-1:0] min;
  wire [4-1:0] min_index;

  MIN_16 
  #(
    .ELEMENT_BIT_DEPTH (
        ELEMENT_BIT_DEPTH )
  )
  MIN_16_dut (
    .min_array (min_array ),
    .min (min ),
    .min_index  ( min_index)
  );

  initial begin
    begin

        $dumpfile("MIN_16.vcd");
        $dumpvars(0, MIN_16_tb);
        min_array={14'h1769,14'h1d82,14'h1c68,14'h1f4d,
                   14'h1286,14'h1bd8,14'h16b7,14'h1fb3,
                   14'h1c98,14'h1ef9,14'h17c9,14'h196b,
                   14'h1ea6,14'h1d59,14'h17b9,14'h1875};
      #5 $finish;
    end
  end


endmodule
