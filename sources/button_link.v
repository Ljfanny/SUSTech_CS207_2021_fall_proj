`timescale 1ns / 1ps

module button_link(
    input clk,
    input but_in,
    output but_link
);

wire but_out;
counter_down counter(clk, but_in, but_out);

reg [1:0] record = 2'b00;

always @(posedge clk)
    record <= {record[0], but_out};
assign but_link = record[0] & ~record[1];

endmodule
