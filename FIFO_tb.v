`include "FIFO.v"
module FIFO_tb;

// Parameters

// Ports
reg          clk_i     = 0;
reg          rst_n_i   = 0;
reg  [183:0] data_in      ;
wire [127:0] data_out0    ;
wire [127:0] data_out1    ;
wire [127:0] data_out2    ;
wire [127:0] data_out3    ;
wire [127:0] data_out4    ;
wire [127:0] data_out5    ;
wire [127:0] data_out6    ;
wire [127:0] data_out7    ;

FIFO FIFO_dut (
    .clk_i    (clk_i    ),
    .rst_n_i  (rst_n_i  ),
    .data_in  (data_in  ),
    .data_out0(data_out0),
    .data_out1(data_out1),
    .data_out2(data_out2),
    .data_out3(data_out3),
    .data_out4(data_out4),
    .data_out5(data_out5),
    .data_out6(data_out6),
    .data_out7(data_out7)
);

initial begin
    begin
        $dumpfile("FIFO.vcd");
        $dumpvars(0, FIFO_tb);
        data_in={8'hda,8'h2e,8'hca,8'h45,8'h7f,8'hce,8'h8a,8'h96,8'hc8,8'h06,8'h47,8'h18,8'h20,8'h4e,8'hc2,8'h75,8'h08,8'h37,8'h87,8'hab,8'h67,8'hac,8'h3b};
        #20 data_in={8'h3b,8'hac,8'h67,8'hab,8'h87,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #20 data_in={8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h3b,8'hac,8'h67,8'hab,8'h87,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #20 data_in={8'h20,8'h18,8'h47,8'h06,8'hc8,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h3b,8'hac,8'h67,8'hab,8'h87,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #20 data_in={8'h96,8'h8a,8'hce,8'h7f,8'h45,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h3b,8'hac,8'h67,8'hab,8'h87,8'hca,8'h2e,8'hda};
        #20 data_in={8'h7f,8'h45,8'hca,8'h2e,8'hda,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h3b,8'hac,8'h67,8'hab,8'h87};
        #20 data_in={8'h3b,8'hac,8'h67,8'hab,8'h87,8'h37,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #20 data_in={8'h3b,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'hac,8'h67,8'hab,8'h87,8'h37,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #20 data_in={8'h3b,8'h18,8'h47,8'h06,8'hc8,8'h96,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'hac,8'h67,8'hab,8'h87,8'h37,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h2e,8'hda};
        #20 data_in={8'h3b,8'h8a,8'hce,8'h7f,8'h45,8'hca,8'h08,8'h75,8'hc2,8'h4e,8'h20,8'h18,8'h47,8'h06,8'hc8,8'h96,8'hac,8'h67,8'hab,8'h87,8'h37,8'h2e,8'hda};
        #500 $finish;
    end
end

always
    #5  clk_i = ! clk_i ;
initial
    begin
        rst_n_i = 0;
        #6 rst_n_i=1;
    end
endmodule
