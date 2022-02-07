`timescale 1ns/1ps

module pay_display (
    input clk,
    input rst,
    input [2:0] view ,
    input [4:0] state,
    output [7:0] seg_out,
    output [7:0] seg_en,
    input [3:0] account,
    input [15:0] psword,
    input [2:0] cnt_psword,
    input isM,
    input [8:0]count,
    input [8:0]fee,
    input [8:0]ch4nge,
    input [8:0]fee_mem,
    input [8:0]rest,
    input [8:0]change_mem,
    input [8:0]change_m2m,
    input [8:0]fee_r
);

parameter NULL = 8'b1111_1111;

reg[7:0] i0, i1, i2, i3, i4, i5, i6, i7;
seg_allocation seg_allo(clk ,rst , i0, i1, i2, i3, i4, i5, i6, i7, seg_out, seg_en);
    
reg [4:0] seg0_num;
wire [7:0] seg0_out;
seg_show seg0(seg0_num,seg0_out);
    
reg [4:0] seg1_num;
wire [7:0] seg1_out; 
seg_show seg1(seg1_num,seg1_out);
    
reg [4:0] seg2_num;
wire [7:0] seg2_out;
seg_show seg2(seg2_num,seg2_out);
    
reg [4:0] seg3_num;
wire [7:0] seg3_out;
seg_show seg3(seg3_num,seg3_out);
    
reg [4:0] seg4_num;
wire [7:0] seg4_out;
seg_show seg4(seg4_num,seg4_out);
    
reg [4:0] seg5_num;
wire [7:0] seg5_out;
seg_show seg5(seg5_num,seg5_out);
    
reg [4:0] seg6_num;
wire [7:0] seg6_out;
seg_show seg6(seg6_num,seg6_out);

always @(posedge clk) begin
    if (view == 4) begin
        case ({state})
            1:begin
                seg0_num <= count/100;
                seg1_num <= (count%100)/10;
                seg2_num <= count%10;
                seg3_num <= fee/100;
                seg4_num <= (fee%100)/10;
                seg5_num <= fee%10;
                {i0,i1,i2,i5,i6,i7}={seg0_out, seg1_out, seg2_out, seg3_out, seg4_out, seg5_out};
                {i3,i4}={2{NULL}};
            end
            2:begin
                    seg0_num <= 5'd16;
                    seg1_num <= 5'd27;
                    seg2_num <= 5'd22;
                    seg3_num <= 5'd1;
                    seg4_num <= 5'd21;
                    {i1,i2,i3,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
                    {i0,i4,i7}={3{NULL}};  
            end
            3:begin
                    seg0_num <= ch4nge/100;
                    seg1_num <= (ch4nge%100)/10;
                    seg2_num <= ch4nge%10;
                    {i5,i6,i7}={seg0_out,seg1_out,seg2_out};
                    {i0,i1,i2,i3,i4}={5{NULL}};
            end
            4:begin
                    seg0_num <= 4'hf;
                    seg1_num <= 4'ha;
                    seg2_num <= 5'd1;
                    seg3_num <= 5'd16;
                    {i4,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out};
                    {i0,i1,i2,i3}={4{NULL}};  
            end
            5:begin
                    if (isM) begin
                        seg0_num <= 5'd5;
                        seg1_num <= account;
                        {i0,i1}={seg0_out,seg1_out};
                        {i2,i3,i4,i5,i6,i7}={6{NULL}}; 
                    end
                    else begin
                        seg0_num <= 5'd5;
                        {i0}={seg0_out};
                        {i1,i2,i3,i4,i5,i6,i7}={7{NULL}}; 
                    end
            end
            6:begin
                    seg0_num <= fee_mem/100;
                    seg1_num <= (fee_mem%100)/10;
                    seg4_num <= fee_mem%10;
                    seg2_num <= rest/100;
                    seg5_num <= (rest%100)/10;
                    seg3_num <= rest%10;
                    {i1,i2,i3,i5,i6,i7}={seg0_out,seg1_out,seg4_out,seg2_out,seg5_out,seg3_out};
                    {i0,i4}={2{NULL}};
            end
            7:begin
                    seg0_num <= change_mem/100;
                    seg1_num <= (change_mem%100)/10;
                    seg2_num <= change_mem%10;
                    {i5,i6,i7}={seg0_out,seg1_out,seg2_out};
                    {i0,i1,i2,i3,i4}={5{NULL}}; 
            end
            8:begin
                    seg0_num <= fee_r/100;
                    seg1_num <= (fee_r%100)/10;
                    seg2_num <= fee_r%10;
                    {i5,i6,i7}={seg0_out,seg1_out,seg2_out};
                    {i0,i1,i2,i3,i4}={5{NULL}}; 
            end
            9:begin
                    seg0_num <= change_m2m/100;
                    seg1_num <= (change_m2m%100)/10;
                    seg2_num <= change_m2m%10;
                    {i5,i6,i7}={seg0_out,seg1_out,seg2_out};
                    {i0,i1,i2,i3,i4}={5{NULL}}; 
            end
            10:begin
                    seg0_num <= 4'hf;
                    seg1_num <= 4'ha;
                    seg2_num <= 5'd1;
                    seg3_num <= 5'd16;
                    {i4,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out};
                    {i0,i1,i2,i3}={4{NULL}};  
            end
            11:begin
                    seg0_num <= 5'he;
                    seg1_num <= 5'd19;
                    seg2_num <= 5'd19;
                    seg3_num <= 5'd0;
                    seg4_num <= 5'd19;
                    {i1,i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
                    {i0,i6,i7}={3{NULL}};
            end
            12:begin
                    seg0_num <= 5'd24;
                    seg1_num <= 5'd5;
                    if(cnt_psword == 0) begin  
                        {i0,i1}={seg0_out,seg1_out};
                        {i2,i3,i4,i5,i6,i7}={6{NULL}}; 
                    end
                    else if(cnt_psword == 1)begin
                        seg2_num <= psword[15:12];
                        {i0,i1,i3}={seg0_out,seg1_out,seg2_out};
                        {i2,i4,i5,i6,i7}={5{NULL}};               
                    end
                    else if(cnt_psword == 2)begin
                        seg2_num <= psword[15:12];
                        seg3_num <= psword[11:8];
                        {i0,i1,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out};
                        {i2,i5,i6,i7}={4{NULL}};               
                    end              
                    else if(cnt_psword == 3)begin
                        seg2_num <= psword[15:12];
                        seg3_num <= psword[11:8];
                        seg4_num <= psword[7:4];
                        {i0,i1,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
                        {i2,i6,i7}={3{NULL}};               
                    end                
                    else if(cnt_psword == 4)begin
                        seg2_num <= psword[15:12];
                        seg3_num <= psword[11:8];
                        seg4_num <= psword[7:4];
                        seg5_num <= psword[3:0];
                        {i0,i1,i3,i4,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                        {i2,i7}={2{NULL}}; 
                    end 
            end
            13:begin
                      seg0_num <= 4'hd;
                      seg1_num <= 4'd0;
                      seg2_num <= 5'd21;
                      seg3_num <= 5'he;
                      {i4,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out};
                      {i0,i1,i2,i3}={4{NULL}};  
            end
            14:begin
                   seg0_num <= 4'hf;
                   seg1_num <= 4'ha;
                   seg2_num <= 5'd1;
                   seg3_num <= 5'd16;
                   {i4,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out};
                   {i0,i1,i2,i3}={4{NULL}};  
               end
        endcase
    end
end

endmodule