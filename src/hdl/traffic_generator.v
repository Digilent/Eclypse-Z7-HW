`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2022 02:57:25 PM
// Design Name: 
// Module Name: traffic_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module traffic_generator #(
    parameter integer TRANSFER_LENGTH = 256,
    parameter integer COUNT_HIGH = 32'hFFFFFFFF
) (
    input wire clk,
    input wire resetn,
    input wire enable,
    input wire freerun,
    input wire axis_tready,
    output wire [31:0] axis_tdata,
    output wire axis_tlast,
    output wire axis_tvalid
);
    wire reset = ~resetn;
    assign axis_tvalid = enable;
    
    reg counter_enable;
    always @(*) begin
        if (freerun) begin
            // violates axi spec intentionally by potentially changing tdata before it has been axis_tdata
            // "gaps" of more than one in values received by downstream IP can used to detect stalls
            counter_enable = axis_tvalid;
        end else begin
            counter_enable = axis_tready & axis_tvalid;
        end
    end
    
    counter #(
        .HIGH         (COUNT_HIGH)
    ) counter_inst (
        .clock        (clk),
        .clock_enable (1'b1),
        .sync_reset   (reset | ~enable),
        .enable       (counter_enable),
        .count        (axis_tdata),
        .tc           ()
    );
    assign axis_tlast = (TRANSFER_LENGTH-1 == axis_tdata[7:0]) ? 1'b1 : 1'b0;
endmodule
