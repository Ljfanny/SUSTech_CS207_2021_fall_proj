`timescale 1ns / 1ps

// this module make press button edge

module edge_gen(
    input clk,
    input in,
    output out_edge
);

reg [1:0] record = 2'b00;

always @(posedge clk)
    record <= {record[0], in};

assign out_edge = record[0] & ~record[1];

endmodule