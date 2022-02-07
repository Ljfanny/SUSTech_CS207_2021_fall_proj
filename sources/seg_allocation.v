`timescale 1ns / 1ps

module seg_allocation(
    input clk,rst,
    input[7:0] i0, i1, i2, i3, i4, i5, i6, i7,
    output reg[7:0] seg, seg_en
);

wire clock;
counter clok_gene(clk, rst , 16'd2, clock);

reg[7:0] isvisited;

always @(posedge clock)
begin
    if(isvisited != 8'b0000_0000) begin
        isvisited <= isvisited >> 1;
    end
    else begin
        isvisited <= 8'b1000_0000;
    end
    seg_en <= ~isvisited;
    
    case(isvisited)
        8'b1000_0000: seg <= i0;
        8'b0100_0000: seg <= i1;
        8'b0010_0000: seg <= i2;
        8'b0001_0000: seg <= i3;
        8'b0000_1000: seg <= i4;
        8'b0000_0100: seg <= i5;
        8'b0000_0010: seg <= i6;
        8'b0000_0001: seg <= i7;
        8'b0000_0000: seg <= 8'b1111_1111;
    endcase
end

endmodule