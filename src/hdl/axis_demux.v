`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/17/2022 02:03:19 PM
// Design Name: 
// Module Name: axis_demux
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


module axis_demux(
    input  wire        clk,
    input  wire        resetn,
    input  wire        s0_tvalid,
    output wire        s0_tready,
    input  wire [31:0] s0_tdata,
    input  wire        select,
    output wire        m0_tvalid,
    input  wire        m0_tready,
    output wire [31:0] m0_tdata,
    output wire        m1_tvalid,
    input  wire        m1_tready,
    output wire [31:0] m1_tdata
);
    // note that axi4-stream signals are not registered

    // only change select either when a beat is successfully transferred or when no beat is pending
    reg select_reg = 0;
    always@(posedge clk) begin
        if (resetn == 1'b0) begin
            select_reg <= 0;
        end else begin
            if (s0_tready == 1'b1 || s0_tvalid == 1'b0) begin
                select_reg <= select;
            end else begin
                select_reg <= select_reg;
            end
        end
    end
    
    assign s0_tready = select_reg ? m1_tvalid : m0_tvalid;
    assign m0_tvalid = ~select_reg & s0_tvalid;
    assign m1_tvalid = select_reg & s0_tvalid;
    assign m0_tdata = s0_tdata;
    assign m1_tdata = s0_tdata;
endmodule
