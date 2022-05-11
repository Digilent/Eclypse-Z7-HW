`timescale 1ns/1ps
`default_nettype none

// register #(
//     .RESET_VALUE  (),
//     .WIDTH        ()
// ) register_inst (
//     .clock          (),
//     .reset        (),
//     .write_enable (),
//     .data_i       (),
//     .data_o       ()
// );

module register #(
    parameter RESET_VALUE = 0,
    parameter WIDTH = 1
) (
    input wire             clock,
    input wire             reset,
    input wire             write_enable,
    input wire [WIDTH-1:0] data_i,
    output reg [WIDTH-1:0] data_o = RESET_VALUE
);
    always @(posedge clock) begin
        if (reset) begin
            data_o <= RESET_VALUE;
        end else if (write_enable == 1'b1) begin
            data_o <= data_i;
        end
    end
endmodule