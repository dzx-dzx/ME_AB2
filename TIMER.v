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
    parameter INTERIM_CYCLE    = 21,
    parameter FULL_CYCLE       = 23,
    parameter OUTPUT_UP_PERIOD = 16
) (
    input            clk               ,
    input            rst               ,
    input            en                ,
    output reg       o                 ,
    output reg [4:0] valid_count       ,
    output reg       output_low_started
);
    localparam INTERIM_BOOT     = 2'b10;
    localparam INTERIM_SHUTDOWN = 2'b01; //Data can still be valid even after sram_ready is low!
    localparam COUNT            = 2'b00;
    localparam SHUTDOWN         = 2'b11;

    reg [1:0] state             ;
    reg [1:0] state_next        ;
    reg [4:0] interim_count     ;
    reg [4:0] interim_count_next;
    reg [4:0] valid_count_next  ;

    always @(posedge clk) begin
        if(rst)
            begin
                state         <= SHUTDOWN;
                interim_count <= 0;
                valid_count   <= 0;
            end
        else
            begin
                state         <= state_next;
                interim_count <= interim_count_next;
                valid_count   <= valid_count_next;
            end
    end

    always @(*) begin
        if(en)
            begin
                if(state==SHUTDOWN)begin
                    state_next = INTERIM_BOOT;
                end
                else if(state==COUNT)begin
                    state_next = COUNT;
                end
                else if(state==INTERIM_SHUTDOWN)begin//Actually shouldn't happen.
                    state_next = INTERIM_BOOT;
                end
                else if(state==INTERIM_BOOT)begin
                    if(interim_count==INTERIM_CYCLE-1)begin
                        state_next = COUNT;
                    end
                    else begin
                        state_next = INTERIM_BOOT;
                    end
                end
                else state_next=state;
            end
        else begin
            if(state==SHUTDOWN)begin
                state_next = SHUTDOWN;
            end
            else if(state==COUNT)begin
                state_next = INTERIM_SHUTDOWN;
            end
            else if(state==INTERIM_BOOT)begin//Actually shouldn't happen.
                state_next = INTERIM_SHUTDOWN;
            end
            else if(state==INTERIM_SHUTDOWN)begin
                if(interim_count==0)begin
                    state_next = SHUTDOWN;
                end
                else begin
                    state_next = INTERIM_SHUTDOWN;
                end
            end
            else state_next=state;
        end
    end

    always @(*) begin
        case(state)
            SHUTDOWN         : interim_count_next=0;
            COUNT            : interim_count_next=interim_count;
            INTERIM_BOOT     : interim_count_next=(interim_count==INTERIM_CYCLE-1)?interim_count:interim_count+1;
            INTERIM_SHUTDOWN : interim_count_next=(interim_count==0)?interim_count:interim_count-1;
            default          : interim_count_next=interim_count;
        endcase
    end

    always @(*) begin
        case(state)
            SHUTDOWN,INTERIM_BOOT : valid_count_next = 0;
            COUNT,INTERIM_SHUTDOWN : valid_count_next = (valid_count==FULL_CYCLE-1)?0:valid_count+1;
            default : valid_count_next=valid_count;
        endcase
    end

    always @(*) begin
        o                  = (state==INTERIM_BOOT||state==SHUTDOWN)?0:valid_count<OUTPUT_UP_PERIOD;
        output_low_started = (state==INTERIM_BOOT||state==SHUTDOWN)?0:valid_count==OUTPUT_UP_PERIOD;
    end
endmodule