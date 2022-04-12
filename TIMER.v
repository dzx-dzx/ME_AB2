// +FHDR-------------------------------------------------------------------
// FILE NAME:
// TYPE:
// DEPARTMENT:
// AUTHOR:
// AUTHOR'S EMAIL:
// ------------------------------------------------------------------------
// KEYWORDS:
// ------------------------------------------------------------------------
// PARAMETERS
//
// ------------------------------------------------------------------------
// REUSE ISSUES
// Reset Strategy:
// Clock Domains:
// Critical Timing:
// Test Features:
// Asynchronous I/F:
// Scan Methodology:
// Instantiations:
// -FHDR-------------------------------------------------------------------

module TIMER #(
    parameter COLD_BOOT_CYCLE  = 20,
    parameter FULL_CYCLE       = 23,
    parameter OUTPUT_UP_PERIOD = 16
) (
    input            clk        ,
    input            rst        ,
    input            en         ,
    output reg       o          ,
    output reg [4:0] valid_count
);
    localparam COLD_BOOT = 1'b0;
    localparam COUNT     = 1'b1;

    reg       state               ;
    reg       state_next          ;
    reg [4:0] cold_boot_count     ;
    reg [4:0] cold_boot_count_next;
    reg [4:0] valid_count_next    ;

    always @(posedge clk) begin
        if(rst)
            begin
                state           <= COLD_BOOT;
                cold_boot_count <= 0;
                valid_count     <= 0;
            end
        else
            begin
                state           <= state_next;
                cold_boot_count <= cold_boot_count_next;
                valid_count     <= valid_count_next;
            end
    end

    always @(*) begin
        if(!en)
            begin
                state_next = COLD_BOOT;
            end
        else if(state==COLD_BOOT&&cold_boot_count==COLD_BOOT_CYCLE)
            begin
                state_next = COUNT;
            end
        else if(state==COUNT)state_next=COUNT;
        else state_next=COLD_BOOT;
    end

    always @(*) begin
        if(!en) begin
            cold_boot_count_next = 0;
        end
        else if(state==COUNT)
            begin
                cold_boot_count_next = 0;
            end
        else if(state==COLD_BOOT&&cold_boot_count==COLD_BOOT_CYCLE)
            begin
                cold_boot_count_next = 0;
            end
        else cold_boot_count_next=cold_boot_count+1;
    end

    always @(*) begin
        if(!en) begin
            valid_count_next = 0;
        end
        else if(state==COLD_BOOT)
            begin
                valid_count_next = 0;
            end
        else if(state==COUNT&&valid_count==FULL_CYCLE)
            begin
                valid_count_next = 0;
            end
        else valid_count_next=valid_count+1;
    end

    always @(*) begin
        o = state==COLD_BOOT?0:valid_count<OUTPUT_UP_PERIOD;
    end
endmodule