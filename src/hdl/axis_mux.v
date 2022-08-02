`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2022 04:44:01 PM
// Design Name: 
// Module Name: axis_mux
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


module axis_mux(
    input wire clk,
    input wire resetn,

    input wire s0_tvalid,
    output wire s0_tready,
    input wire [31:0] s0_tdata,
    
    input wire s1_tvalid,
    output wire s1_tready,
    input wire [31:0] s1_tdata,
    
    input wire select_in,
    
    output wire m0_tvalid,
    input wire m0_tready,
    output wire [31:0] m0_tdata
);
    // note that axi4-stream signals are not registered

    // only change select either when a beat is successfully transferred or when no beat is pending
    reg select_reg = 0;
    always@(posedge clk) begin
        if (resetn == 1'b0) begin
            select_reg <= 0;
        end else begin
            if (m0_tready == 1'b1 || m0_tvalid == 1'b0) begin
                select_reg <= select_in;
            end else begin
                select_reg <= select_reg;
            end
        end
    end

    assign m0_tvalid = (select_reg) ? s1_tvalid : s0_tvalid;
    assign m0_tdata = (select_reg) ? s1_tdata : s0_tdata;
    assign s1_tready = select_reg & m0_tready;
    assign s0_tready = ~select_reg & m0_tready;
endmodule
