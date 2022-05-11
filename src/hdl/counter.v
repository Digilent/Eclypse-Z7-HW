`timescale 1ns / 1ps

// counter #(
//     .HIGH         ()
// ) counter_inst (
//     .clock        (),
//     .clock_enable (),
//     .sync_reset   (),
//     .enable       (),
//     .count        (),
//     .tc           ()
// );

module counter #(
    parameter integer HIGH = 2**8-1
) (
    input wire clock,
    input wire clock_enable,
    input wire sync_reset,
    input wire enable,
    output reg [$clog2(HIGH)-1:0] count,
    output wire tc
);
    initial begin
        count <= 'b0;
    end
    always @(posedge clock) begin
        if (clock_enable == 1'b1) begin
            if (sync_reset == 1'b1) begin
                count <= 'b0;
            end else if (enable == 1'b1) begin
                if (tc == 1'b1) begin
                    count <= 'b0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end
    assign tc = (count == HIGH) ? 1'b1 : 1'b0;
endmodule
