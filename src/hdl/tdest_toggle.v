`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2022 09:55:10 AM
// Design Name: 
// Module Name: tdest_toggle
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


module tdest_toggle (
    input wire clk,
    input wire resetn,
    
    input wire s0_tvalid,
    output wire s0_tready,
    input wire s0_tlast,
    input wire [31:0] s0_tdata,
    
    output wire m0_tvalid,
    input wire m0_tready,
    output wire m0_tlast,
    output wire [31:0] m0_tdata,
    output wire [31:0] m0_tdest
);
    assign m0_tdata = s0_tdata;
    assign m0_tvalid = s0_tvalid;
    assign m0_tlast = s0_tlast;
    assign s0_tready = m0_tready;

    wire reset = ~resetn;
    register #(
        .RESET_VALUE  (0),
        .WIDTH        (1)
    ) register_inst (
        .clock        (clk),
        .reset        (reset),
        .write_enable (s0_tvalid & s0_tready & s0_tlast),
        .data_i       (~m0_tdest[0]),
        .data_o       (m0_tdest[0])
    );
    assign m0_tdest[31:1] = 'b0;
endmodule
