`timescale 1ns / 1ps

module generate_bound(
    input clk,
    input in,
    output out_bound
);

reg [1:0] record = 2'b00;

always @(posedge clk)
    record <= {record[0], in};

assign out_bound = record[0] & ~record[1];

endmodule