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
    parameter integer COUNT_HIGH = 32'hFFFFFFFF
//    parameter integer TRANSFER_LENGTH = 32'hFFFFFFFF
) (
    input wire clk,
    input wire resetn,
    input wire enable,
    input wire freerun,
    input wire axis_tready,
    output wire [31:0] axis_tdata,
    output wire axis_tvalid
);
    assign axis_tvalid = enable;
    
    reg incr;
    always @(*) begin
        if (freerun) begin
            // violates axi spec intentionally by potentially changing tdata before it has been axis_tdata
            // "gaps" of more than one in values received by downstream IP can used to detect stalls
            incr = axis_tvalid;
        end else begin
            incr = axis_tready & axis_tvalid;
        end
    end
    
	reg [$clog2(COUNT_HIGH)-1:0] count;
    initial begin
        count <= 'b0;
    end
    always @(posedge clk) begin
		if (resetn == 1'b0) begin
			count <= 'b0;
		end else if (enable == 1'b0) begin
			count <= 'b0;
		end else begin // not optimized, tvalid used as input twice, once to incr and once to enable
			if (incr == 1'b1) begin
				if (count == COUNT_HIGH) begin
					count <= 'b0;
				end else begin
					count <= count + 1'b1;
				end
			end
		end
    end
	assign axis_tdata = count;
endmodule
