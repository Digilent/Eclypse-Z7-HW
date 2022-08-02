`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2022 12:05:25 PM
// Design Name: 
// Module Name: test_stream_sink
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:
//     Holds idle high until start is asserted,
//     then receives a single AXI4-stream packet delineated by tlast,
//     counting the number of beats and "missed" beats where tvalid was not asserted.
//     additionally counts the number of beats where tdata does not increment from the previous beat
//     Once tlast is received, returns to idle state.
//     Counters are cleared on start assert.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_stream_sink(
    input wire clk,
    input wire resetn,
    
    input wire start,
    output wire idle,
    
    input wire axis_tvalid,
    input wire [31:0] axis_tdata,
    output wire axis_tready,
    input wire axis_tlast,
    
    output wire [31:0] beat_count, // number of cycles since start where tready and tvalid were both asserted
    output wire [31:0] miss_count, // number of cycles since start where only tready was asserted - in combination with beats, indicates bandwidth utilization
    output wire [31:0] error_count // number of cycles since start where tdata did not match the previous beat + 1 (sample loss indicating axi4-stream spec violation)
);
    wire reset = ~resetn;
    wire [31:0] expected_tdata;

    assign axis_tready = ~idle;

    counter #(
        .HIGH         (32'hffffffff)
    ) beat_counter_inst (
        .clock        (clk),
        .clock_enable (1'b1),
        .sync_reset   (reset | start),
        .enable       (~idle & axis_tready & axis_tvalid),
        .count        (beat_count),
        .tc           ()
    );
    
    counter #(
        .HIGH         (32'hffffffff)
    ) miss_counter_inst (
        .clock        (clk),
        .clock_enable (1'b1),
        .sync_reset   (reset | start),
        .enable       (~idle & axis_tready & ~axis_tvalid),
        .count        (miss_count),
        .tc           ()
    );
    
    register #(
        .RESET_VALUE  (0),
        .WIDTH        (32)
    ) expected_tdata_reg_inst (
        .clock        (clk),
        .reset        (reset | start),
        .write_enable (axis_tready & axis_tvalid),
        .data_i       (axis_tdata + 1'b1),
        .data_o       (expected_tdata)
    );
    
    counter #(
        .HIGH         (32'hffffffff)
    ) error_counter_inst (
        .clock        (clk),
        .clock_enable (1'b1),
        .sync_reset   (reset | start),
        .enable       (~idle & axis_tready & axis_tvalid & (expected_tdata != axis_tdata)),
        .count        (error_count),
        .tc           ()
    );
    
    register #(
        .RESET_VALUE  (1),
        .WIDTH        (1)
    ) idle_reg_inst (
        .clock        (clk),
        .reset        (reset),
        .write_enable (start | axis_tlast),
        .data_i       (axis_tlast),
        .data_o       (idle)
    );
endmodule
