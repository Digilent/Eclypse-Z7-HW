`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2022 04:45:14 PM
// Design Name: 
// Module Name: inject_tlast
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


module inject_tlast (
    input wire clk,
    input wire resetn,
    
    output wire s0_tready,
    input  wire s0_tvalid,
    input  wire [31:0] s0_tdata,
    input  wire s0_tlast,
    input  wire m0_tready,
    output wire m0_tvalid,
    output wire [31:0] m0_tdata,
    output wire m0_tlast,
    output wire [3:0] m0_tuser
);
endmodule
