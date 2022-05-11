`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2022 12:28:11 PM
// Design Name: 
// Module Name: inject_tuser
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


module inject_tuser(
    input wire clk,
    input wire resetn,
    
    input wire [3:0] next_user,
    input wire next_user_write_enable,
    
    output wire s0_tready,
    input wire s0_tvalid,
    input wire [31:0] s0_tdata,
    input wire s0_tlast,
    input wire m0_tready,
    output wire m0_tvalid,
    output wire [31:0] m0_tdata,
    output wire m0_tlast,
    output wire [3:0] m0_tuser
);
    wire first_beat;
    wire user_reg;
    wire reset = ~resetn;
    assign s0_tready = m0_tready;
    assign m0_tvalid = s0_tready;
    assign m0_tready = s0_tready;
    assign m0_tdata = s0_tdata;
    register #(
        .RESET_VALUE  (1),
        .WIDTH        (1)
    ) user_reg_inst (        
        .clock        (clk),
        .reset        (reset),
        .write_enable (s0_tready & s0_tvalid & (first_beat ^ s0_tlast)),
        .data_i       (~first_beat),
        .data_o       (first_beat)
    );
    register #(
        .RESET_VALUE  (0),
        .WIDTH        (1)
    ) user_reg_inst (
        .clock        (clk),
        .reset        (reset),
        .write_enable (next_user_write_enable),
        .data_i       (next_user),
        .data_o       (user_reg)
    );
    register #(
        .RESET_VALUE  (0),
        .WIDTH        (1)
    ) user_reg_inst (        
        .clock        (clk),
        .reset        (reset),
        .write_enable (first_beat),
        .data_i       (user_reg),
        .data_o       (m0_tuser)
    );
endmodule
