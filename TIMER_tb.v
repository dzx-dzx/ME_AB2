module TIMER_tb ();

// Parameters
    localparam INTERIM_CYCLE    = 20;
    localparam FULL_CYCLE       = 23;
    localparam OUTPUT_UP_PERIOD = 16;

// Ports
    reg  clk = 0;
    reg  rst = 0;
    reg  en  = 0;
    wire o      ;

    TIMER #(
        .INTERIM_CYCLE   (INTERIM_CYCLE   ),
        .FULL_CYCLE      (FULL_CYCLE      ),
        .OUTPUT_UP_PERIOD(                
                          OUTPUT_UP_PERIOD)  
    ) TIMER_dut (
        .clk(clk),
        .rst(rst),
        .en (en ),
        .o  (o  )
    );

    initial begin
        begin
            $dumpfile("TIMER.vcd");
            $dumpvars(0, TIMER_tb);
            #1 rst=1;
            #1 rst=0;
            #3 en=1;
            #60 en=0;
            #30 en=1;
            #20 en=0;
            $finish;
        end
    end

    always
        #1  clk = ! clk ;

endmodule
