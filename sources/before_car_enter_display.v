`timescale 1ns / 1ps

module before_car_enter_display(
    input clk,
    input rst,
    input [2:0] view,
    input [2:0] current,
    input [2:0] total_a,
    input [2:0] total_b,
    input [2:0] left_a,
    input [2:0] left_b,
    input [1:0] price_start_a, 
    input [1:0] price_start_b, 
    input [1:0] price_add_a,
    input [1:0] price_add_b, 
    output [7:0]  seg_out,
    output [7:0]  seg_en
    //output buzzer
);

reg msp_rst;
//music_player msp(clk, msp_rst, buzzer);

reg [1:0] current_park;
reg [2:0] current_total;
reg [2:0] current_left;
reg [1:0] current_start;
reg [1:0] current_add;

reg [5:0] pos;
reg [4:0] ms100_pass;

wire ms_clk;
divide_clk #(100_000) ms_clk_inst(clk, rst, ms_clk);
wire ms100_clk;
divide_clk #(70) ms100_clk_inst(ms_clk, rst, ms100_clk);
wire ms100_edge;
generate_bound ms100_edge_inst(clk, ms100_clk, ms100_edge);

reg change;
always @(posedge clk) begin
  if(view == 0)begin
    if(rst) begin
      current_park <= 0;
      pos <= 0;
      ms100_pass<=0;
    end
    else begin
      if(current_park != 1 && current == 1) begin
              pos<=0;
              ms100_pass<=0;
              current_park <= 2'd1;
              current_total <= total_a;
              current_left <= left_a;
              current_start <= price_start_a;
              current_add <= price_add_a;
              change <= 1;
      end
      else if(current_park != 2 && current == 2 )begin
              pos<=0;
              ms100_pass<=0;
              current_park <= 2'd2;
              current_total <= total_b;
              current_left <= left_b;
              current_start <= price_start_b;
              current_add <= price_add_b;
              change <= 1;
      end
    end
              
    if(current_park >= 1 && pos <= 43) begin
      if( ms100_pass == 10 ) begin
        if( pos != 43)
          pos <= pos + 1;
        else
          pos <= 0;
          change = 0;
          ms100_pass <= 0;
        end 
        else if(ms100_edge) begin
                ms100_pass <= ms100_pass + 1;
        end
    end
  end
end

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

reg [4:0] seg7_num;
wire [7:0] seg7_out;
seg_show seg7(seg7_num,seg7_out);

reg [4:0] seg8_num;
wire [7:0] seg8_out;
seg_show seg8(seg8_num,seg8_out);

reg [4:0] seg9_num;
wire [7:0] seg9_out;
seg_show seg9(seg9_num,seg9_out);

reg [4:0] seg10_num;
wire [7:0] seg10_out;
seg_show seg10(seg10_num,seg10_out);

reg [4:0] seg11_num;
wire [7:0] seg11_out;
seg_show seg11(seg11_num,seg11_out);

reg [4:0] seg12_num;
wire [7:0] seg12_out;
seg_show seg12(seg12_num,seg12_out);

reg [4:0] seg13_num;
wire [7:0] seg13_out;
seg_show seg13(seg13_num,seg13_out);

reg [4:0] seg14_num;
wire [7:0] seg14_out; 
seg_show seg14(seg14_num,seg14_out);

reg [4:0] seg15_num;
wire [7:0] seg15_out;
seg_show seg15(seg15_num,seg15_out);

reg [4:0] seg16_num;
wire [7:0] seg16_out;
seg_show seg16(seg16_num,seg16_out);

reg [4:0] seg17_num;
wire [7:0] seg17_out;
seg_show seg17(seg17_num,seg17_out);

reg [4:0] seg18_num;
wire [7:0] seg18_out;
seg_show seg18(seg18_num,seg18_out);

reg [4:0] seg19_num;
wire [7:0] seg19_out;
seg_show seg19(seg19_num,seg19_out);

reg [4:0] seg20_num;
wire [7:0] seg20_out;
seg_show seg20(seg20_num,seg20_out);

reg [4:0] seg21_num;
wire [7:0] seg21_out;
seg_show seg21(seg21_num,seg21_out);

reg [4:0] seg22_num;
wire [7:0] seg22_out;
seg_show seg22(seg22_num,seg22_out);

reg [4:0] seg23_num;
wire [7:0] seg23_out;
seg_show seg23(seg23_num,seg23_out);

reg [4:0] seg24_num;
wire [7:0] seg24_out;
seg_show seg24(seg24_num,seg24_out);

reg [4:0] seg25_num;
wire [7:0] seg25_out;
seg_show seg25(seg25_num,seg25_out);

reg [4:0] seg26_num;
wire [7:0] seg26_out;
seg_show seg26(seg26_num,seg26_out);

wire[4:0] total_hundred = current_total / 100;
wire[4:0] total_ten = (current_total % 100) / 10;
wire[4:0] total_one = (current_total % 100) % 10;
wire[4:0] left_hundred = current_left / 100;      
wire[4:0] left_ten= (current_left % 100) / 10;   
wire[4:0] left_one= (current_left % 100) % 10;   
wire[4:0] start_ten= current_start / 10;   
wire[4:0] start_one= current_start % 10;   
wire[4:0] add_ten= current_add / 10;   
wire[4:0] add_one= current_add % 10;   
 
parameter NULL = 8'b1111_1111;

always @(*) begin
  if(view == 0) begin
    if(current_park == 0) begin
      {i0, i1, i2, i3, i4, i5, i6, i7} = {8{NULL}};
    end
    else begin
        case(current_park)
           1:seg0_num <= 5'ha;
           2:seg0_num <= 5'hb;
        endcase
        seg1_num <= 5'ha;
        seg2_num <= 5'd16;
        seg3_num <= 5'd16;
        seg4_num <= total_hundred;
        seg5_num <= total_ten;
        seg6_num <= total_one;
        
        seg7_num <= 5'd16; //L
        seg8_num <= 5'he;
        seg9_num <= 5'hf;
        seg10_num <= 5'd17; //t
        seg11_num <= left_hundred;
        seg12_num <= left_ten;
        seg13_num <= left_one;
        
        seg14_num <= 5'd18; //S
        seg15_num <= 5'd17;//t
        seg16_num <= 5'ha;
        seg17_num <= 5'd19; //r
        seg18_num <= 5'd17;//t
        seg19_num <= start_ten;
        seg20_num <= start_one;
        
        seg21_num <= 5'he;
        seg22_num <= 5'ha;
        seg23_num <= 5'hc;
        seg24_num <= 5'd20; //h
        seg25_num <= add_ten;
        seg26_num <= add_one;              
         case(pos) 
          0:begin  
              {i0,i1,i2,i3,i4,i5,i6,i7}={8{NULL}};
          end
          1:begin  
              {i7}={seg0_out};
              {i0,i1,i2,i3,i4,i5,i6}={7{NULL}};
          end
          2:begin 
              {i6}={seg0_out};
              {i0,i1,i2,i3,i4,i5,i7}={7{NULL}};
          end
          3:begin
              {i5,i7}={seg0_out,seg1_out};
              {i0,i1,i2,i3,i4,i6}={6{NULL}};
          end
          4:begin  
              {i4,i6,i7}={seg0_out,seg1_out,seg2_out};
              {i0,i1,i2,i3,i5}={5{NULL}};
          end
          5:begin  
              {i3,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out};
              {i0,i1,i2,i4}={4{NULL}};
          end 
          6:begin  
              {i2,i4,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out};
              {i0,i1,i3,i7}={4{NULL}};
          end 
          7:begin  
              {i1,i3,i4,i5,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
              {i0,i2,i6}={3{NULL}};
          end             
          8:begin  
          {i0,i2,i3,i4,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
          {i1,i5}={2{NULL}};
          end
          9:begin
          {i1,i2,i3,i5,i6,i7}={seg1_out,seg2_out,seg3_out,seg4_out,seg5_out,seg6_out};
          {i0,i4}={2{NULL}};
          end
          10:begin
          {i0,i1,i2,i4,i5,i6}={seg1_out,seg2_out,seg3_out,seg4_out,seg5_out,seg6_out};
          {i3,i7}={2{NULL}};
          end
          11:begin
          {i0,i1,i3,i4,i5,i7}={seg2_out,seg3_out,seg4_out,seg5_out,seg6_out,seg7_out};
          {i2,i6}={2{NULL}};
          end
          12:begin
          {i0,i2,i3,i4,i6,i7}={seg3_out,seg4_out,seg5_out,seg6_out,seg7_out,seg8_out};
          {i1,i5}={2{NULL}};
          end
          13:begin
          {i1,i2,i3,i5,i6,i7}={seg4_out,seg5_out,seg6_out,seg7_out,seg8_out,seg9_out};
          {i0,i4}={2{NULL}};
          end
          14:begin
          {i0,i1,i2,i4,i5,i6,i7}={seg4_out,seg5_out,seg6_out,seg7_out,seg8_out,seg9_out,seg10_out};
          {i3}={1{NULL}};
          end
          15:begin
          {i0,i1,i3,i4,i5,i6}={seg5_out,seg6_out,seg7_out,seg8_out,seg9_out,seg10_out};
          {i2,i7}={2{NULL}};
          end
          16:begin
          {i0,i2,i3,i4,i5,i7}={seg6_out,seg7_out,seg8_out,seg9_out,seg10_out,seg11_out};
          {i1,i6}={2{NULL}};
          end
          17:begin
          {i1,i2,i3,i4,i6,i7}={seg7_out,seg8_out,seg9_out,seg10_out,seg11_out,seg12_out};
          {i0,i5}={2{NULL}};
          end
          18:begin
          {i0,i1,i2,i3,i5,i6,i7}={seg7_out,seg8_out,seg9_out,seg10_out,seg11_out,seg12_out,seg13_out};
          {i4}={1{NULL}};
          end
          19:begin
          {i0,i1,i2,i4,i5,i6}={seg8_out,seg9_out,seg10_out,seg11_out,seg12_out,seg13_out};
          {i3,i7}={2{NULL}};
          end
          20:begin
          {i0,i1,i3,i4,i5,i7}={seg9_out,seg10_out,seg11_out,seg12_out,seg13_out,seg14_out};
          {i2,i6}={2{NULL}};
          end
          21:begin
          {i0,i2,i3,i4,i6,i7}={seg10_out,seg11_out,seg12_out,seg13_out,seg14_out,seg15_out};
          {i1,i5}={2{NULL}};
          end
          22:begin
          {i1,i2,i3,i5,i6,i7}={seg11_out,seg12_out,seg13_out,seg14_out,seg15_out,seg16_out};
          {i0,i4}={2{NULL}};
          end
          23:begin
          {i0,i1,i2,i4,i5,i6,i7}={seg11_out,seg12_out,seg13_out,seg14_out,seg15_out,seg16_out,seg17_out};
          {i3}={1{NULL}};
          end                    
          24:begin
          {i0,i1,i3,i4,i5,i6,i7}={seg12_out,seg13_out,seg14_out,seg15_out,seg16_out,seg17_out,seg18_out};
          {i2}={1{NULL}};
          end                             
          25:begin
          {i0,i2,i3,i4,i5,i6}={seg13_out,seg14_out,seg15_out,seg16_out,seg17_out,seg18_out};
          {i1,i7}={2{NULL}};
          end
          26:begin
          {i1,i2,i3,i4,i5,i7}={seg14_out,seg15_out,seg16_out,seg17_out,seg18_out,seg19_out};
          {i0,i6}={2{NULL}};
          end
          27:begin
          {i0,i1,i2,i3,i4,i6,i7}={seg14_out,seg15_out,seg16_out,seg17_out,seg18_out,seg19_out,seg20_out};
          {i5}={1{NULL}};
          end
          28:begin
          {i0,i1,i2,i3,i5,i6}={seg15_out,seg16_out,seg17_out,seg18_out,seg19_out,seg20_out};
          {i4,i7}={2{NULL}};
          end
          29:begin
          {i0,i1,i2,i4,i5,i7}={seg16_out,seg17_out,seg18_out,seg19_out,seg20_out,seg21_out};
          {i3,i6}={2{NULL}};
          end          
          30:begin
          {i0,i1,i3,i4,i6,i7}={seg17_out,seg18_out,seg19_out,seg20_out,seg21_out,seg22_out};
          {i2,i5}={2{NULL}};
          end   
          31:begin
          {i0,i2,i3,i5,i6,i7}={seg18_out,seg19_out,seg20_out,seg21_out,seg22_out,seg23_out};
          {i1,i4}={2{NULL}};
          end
          32:begin
          {i1,i2,i4,i5,i6,i7}={seg19_out,seg20_out,seg21_out,seg22_out,seg23_out,seg24_out};
          {i0,i3}={2{NULL}};
          end
          33:begin
          {i0,i1,i3,i4,i5,i6}={seg19_out,seg20_out,seg21_out,seg22_out,seg23_out,seg24_out};
          {i2,i7}={2{NULL}};
          end
          34:begin
          {i0,i2,i3,i4,i5,i7}={seg20_out,seg21_out,seg22_out,seg23_out,seg24_out,seg25_out};
          {i1,i6}={2{NULL}};
          end
          35:begin
          {i1,i2,i3,i4,i6,i7}={seg21_out,seg22_out,seg23_out,seg24_out,seg25_out,seg26_out};
          {i0,i5}={2{NULL}};
          end 
          36:begin
          {i0,i1,i2,i3,i5,i6}={seg21_out,seg22_out,seg23_out,seg24_out,seg25_out,seg26_out};
          {i4,i7}={2{NULL}};
          end
          37:begin
          {i0,i1,i2,i4,i5}={seg22_out,seg23_out,seg24_out,seg25_out,seg26_out};
          {i3,i6,i7}={3{NULL}};
          end 
          38:begin
          {i0,i1,i3,i4}={seg23_out,seg24_out,seg25_out,seg26_out};
          {i2,i5,i6,i7}={4{NULL}};
          end
          39:begin
          {i0,i2,i3}={seg24_out,seg25_out,seg26_out};
          {i1,i4,i5,i6,i7}={5{NULL}};
          end
          40:begin
          {i1,i2}={seg25_out,seg26_out};
          {i0,i3,i4,i5,i6,i7}={6{NULL}};
          end
          41:begin
          {i0,i1}={seg25_out,seg26_out};
          {i2,i3,i4,i5,i6,i7}={6{NULL}};
          end
          42:begin
          {i0}={seg26_out};
          {i1,i2,i3,i4,i5,i6,i7}={7{NULL}};
          end
          43:begin
          {i0,i1,i2,i3,i4,i5,i6,i7}={8{NULL}};
          end                                             
        endcase
      end
  end
end
endmodule