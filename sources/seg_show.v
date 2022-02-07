`timescale 1ns / 1ps

module seg_show(input[4:0] num,
                output reg [7:0] seg_out);

always @(num) begin
    case(num)
        4'h0: seg_out  = 8'b1100_0000;
        4'h1: seg_out  = 8'b1111_1001;
        4'h2: seg_out  = 8'b1010_0100;
        4'h3: seg_out  = 8'b1011_0000;
        4'h4: seg_out  = 8'b1001_1001;
        4'h5: seg_out  = 8'b1001_0010;
        4'h6: seg_out  = 8'b1000_0010;
        4'h7: seg_out  = 8'b1111_1000;
        4'h8: seg_out  = 8'b1000_0000;
        4'h9: seg_out  = 8'b1001_0000;
        4'ha: seg_out  = 8'b1000_1000;
        4'hb: seg_out  = 8'b1000_0011;
        4'hc: seg_out  = 8'b1100_0110;
        4'hd: seg_out  = 8'b1010_0001;
        4'he: seg_out  = 8'b1000_0110;
        4'hf: seg_out  = 8'b1000_1110;
        5'd16: seg_out = 8'b1100_0111;//L
        5'd17: seg_out = 8'b1000_0111;//t
        5'd18: seg_out = 8'b1001_0010;//S
        5'd19: seg_out = 8'b1010_1111;//r
        5'd20: seg_out = 8'b1000_1011;//h
        5'd21: seg_out = 8'b1010_1011;//down n
        5'd22: seg_out = 8'b1001_0000;//g
        5'd23: seg_out = 8'b1001_0001;//y
        5'd24: seg_out = 8'b1000_1100;//P
        5'd25: seg_out = 8'b1110_0011;//down u
        5'd26: seg_out = 8'b1101_1100;//up n
        5'd27: seg_out = 8'b1010_0011;//o
        5'd28: seg_out = 8'b1001_1101;//up u
        
        default: seg_out = 8'b1111_1111;
    endcase
end
endmodule
