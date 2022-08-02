`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent
// Engineer: Arthur Brown
// 
// Create Date: 07/29/2022 12:19:00 PM
// Design Name: 
// Module Name: level_trigger
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module implements a simple level trigger, when each data channel encoded in tdata rises or falls past a specified level, a trigger is generated on the corresponding output port
//              When the a pair of consecutive samples cross the set level or the second sample falls on the level, a trigger event is issued with the outgoing data beat on the axi4-stream master interface.
//              Trigger outputs are synchronous with the stream clock and are registered alongside the corresponding data beat, the output is not cleared until valid & ready
//              The 32-bit stream is split into two 16-bit data channels assumed to be represented in twos-complement format
//              Only twos-complement data is supported
//              Trigger events are to be masked externally, as this module has no enable pins
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// compare implemented as a separate module to ease conversion of 
module level_trigger_compare (
    input wire signed [15:0] data,
    input wire signed [15:0] data_previous,
    input wire signed [15:0] level,
    output wire trig_rising,
    output wire trig_falling
);
    assign trig_rising  = (data >= level) && (data_previous < level);
    assign trig_falling = (data <= level) && (data_previous > level);
endmodule

module level_trigger (
    input  wire stream_clk,
    input  wire resetn,
    
    output wire s_tready,
    input  wire s_tvalid,
    input  wire [31:0] s_tdata,
    
    input  wire m_tready,
    output wire m_tvalid,
    output wire [31:0] m_tdata,
    
    input  wire signed [15:0] ch1_level,
    input  wire [15:0] ch2_level,
    
    output wire ch1_rising,
    output wire ch1_falling,
    output wire ch2_rising,
    output wire ch2_falling
);
    
    wire signed [15:0] ch1 = s_tdata[15:0];
    wire [15:0] ch2 = s_tdata[31:16];
    reg signed [15:0] ch1_prev;
    reg [15:0] ch2_prev;
    
    wire ch1_rising_raw;
    wire ch1_falling_raw;
    wire ch2_rising_raw;
    wire ch2_falling_raw;
    
    // indicates whether data is present in the _prev registers.
    // used to mask out spurious triggers on the first data beat after reset
    reg loaded = 0;

    assign s_tready = m_tready;
    assign m_tvalid = s_tvalid;
    assign m_tdata = s_tdata;

    always@(posedge stream_clk) begin
        if (resetn == 1'b0) begin
            ch1_prev <= 0;
            ch2_prev <= 0;
            loaded <= 0;
        end else if (s_tvalid == 1'b1) begin
            ch1_prev <= ch1;
            ch2_prev <= ch2;
            loaded <= 1;
        end
    end

    level_trigger_compare ch1_compare (
        .data          (ch1),
        .data_previous (ch1_prev),
        .level         (ch1_level),
        .trig_rising   (ch1_rising),
        .trig_falling  (ch1_falling)
    );
    
//    wire ch1_rising_raw;
//    wire ch1_falling_raw;
    assign ch2_rising = ch2_rising_raw & loaded;
    assign ch2_falling = ch2_falling & loaded;
    
    assign ch1_rising  = (ch1 >= ch1_level) && (ch1_prev < ch1_level) && (loaded == 1'b1);
    assign ch1_falling = (ch1 <= ch1_level) && (ch1_prev > ch1_level) && (loaded == 1'b1);
    
    level_trigger_compare ch2_compare (
        .data          (ch2),
        .data_previous (ch2_prev),
        .level         (ch2_level),
        .trig_rising   (ch2_rising_raw),
        .trig_falling  (ch2_falling_raw)
    );
endmodule
