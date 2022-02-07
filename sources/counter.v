`timescale 1ns / 1ps

module counter(
    input clk,
    input rst,
    input [15:0] period,
    output clk_counter
);

reg [16:0] count;
reg [15:0] ms;

assign clk_counter = (ms % period == 0) ? 1'b1 : 1'b0;

always @(posedge clk, posedge rst) begin
    if (rst)
        count <= 17'b0;
    else if (count == (17'd100_000) - 1)
        count <= 17'b0;
    else
        count <= count + 1;
end

always @(posedge clk, posedge rst) begin
    if (rst)
        ms <= 16'b0;
    else if (ms == period)
        ms <= 16'b0;
    else if (count == (17'd100_000 >> 1) - 1)
        ms <= ms + 1;
end

endmodule :counter
