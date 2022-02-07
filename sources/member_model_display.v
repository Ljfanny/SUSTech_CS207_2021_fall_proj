`timescale 1ns / 1ps

module member_model_display(
    input clk,
    input rst,
    input [2:0] view,
    //state传进�?
    input [4:0] state,
    //所有信�?!
    input [3:0] account,
    input [15:0] psword,//会员登录输入的密�?
    input [2:0] cnt_psword,//会员登录输入的密码的位数
    input [1:0] ps_error_time, //会员登录输入的密码的错�?次数，超过三次返回账号输入界�?
    input [15:0] becomeMemPsword,//成为会员密码�?
    input [2:0] cnt_ch_psword,//成为会员记录输入密码位数�? 
    input [2:0] be_account,//分发的会员号�?
    input [1:0] select_op,//会员选择的操�?
    input isCancel, isChoosed,//�?��注销
    //刚注册的充钱！充钱数
    input [5:0] be_money, //总数
    input [1:0] cnt_be_money, //计数�?
    input [2:0] be_money_ten, //十位�?    
    input [3:0] be_money_one, //�?���?
    //会员重新充钱�?
    input [5:0] money, //总数
    input [1:0] cnt_money, //计数�?
    input [2:0] money_ten, //十位�?    
    input [3:0] money_one, //�?���?
    input [5:0] le_money, //退还的钱钱
    input [15:0] now_ps, //会员�?��密码
    input [2:0] cnt_ps, //�?��密码的位�?
    output [7:0] seg_out,
    output [7:0] seg_en,
    input isM,
    input  [21:0] one, 
    input [21:0] two,    
    input [21:0] three,   
    input [21:0] four,    
    input [21:0] five    
    );
    parameter NULL = 8'b1111_1111;
    reg [5:0] pos;
    reg [6:0] ms100_pass;
    
    wire ms_clk;
    divide_clk #(100_000) ms_clk_inst(clk, rst, ms_clk);
    wire ms100_clk;
    divide_clk #(70) ms100_clk_inst(ms_clk, rst, ms100_clk);
    wire ms100_edge;
    generate_bound ms100_edge_inst(clk, ms100_clk, ms100_edge);
    
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
    
    reg change;

//    always @(clk, view, state, account ,isM ,account,psword,cnt_psword,ps_error_time,
//    becomeMemPsword,cnt_ch_psword,be_account,select_op, isCancel, isChoosed,be_money, 
//    cnt_be_money, be_money_ten, be_money_one, money,cnt_money, money_ten, 
//     money_one, le_money,now_ps,cnt_ps) begin
     always @(*) begin
      if(view == 5)begin
        case({state})
        1:begin
        seg0_num <= 5'd16;
        seg1_num <= 5'd0;
        seg2_num <= 5'd22;
        seg3_num <= 5'd1;        
        seg4_num <= 5'd21;
        {i1,i2,i3,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
        {i0,i4,i7}={3{NULL}};        
        end
        2:begin
         seg0_num <= 5'd5;
         seg1_num <= 5'd1;
         seg2_num <= 5'd22;//g
         seg3_num <= 5'd21;//n      
         seg4_num <= 5'd1;
         seg5_num <= 5'd21;//n
         {i0,i1,i2,i3,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
         {i4,i7}={2{NULL}}; 
         end
        3:begin
           if(isM)begin
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
        4:begin
            seg0_num <= 5'd0;
            seg1_num <= 5'd21;
            seg2_num <= 5'd1;
            seg3_num <= 5'd23;
            {i1,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out};
            {i0,i2,i5,i7}={4{NULL}}; 
      end
        5:begin
                  seg0_num <= 5'he;
                  seg1_num <= 5'd19;
                  seg2_num <= 5'd19;
                  seg3_num <= 5'd0;
                  seg4_num <= 5'd19;
                  {i1,i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
                  {i0,i6,i7}={3{NULL}}; 
            end
        6:begin
              seg0_num <= 5'd24;
              seg1_num <= 5'd5;
              if(cnt_psword == 0)begin  
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
        7:begin
            seg0_num <= 5'd5;
            seg1_num <= be_account;
            {i0,i1}={seg0_out,seg1_out};
            {i2,i3,i4,i5,i6,i7}={6{NULL}};  
          end
        8:begin
                seg0_num <= 5'd24;
                seg1_num <= 5'd5;
                if(cnt_ch_psword == 0)begin  
                {i0,i1}={seg0_out,seg1_out};
                {i2,i3,i4,i5,i6,i7}={6{NULL}}; 
                end
                else if(cnt_ch_psword == 1)begin
                seg2_num <= becomeMemPsword[15:12];
                {i0,i1,i3}={seg0_out,seg1_out,seg2_out};
                {i2,i4,i5,i6,i7}={5{NULL}};               
                end
                else if(cnt_ch_psword == 2)begin
                seg2_num <= becomeMemPsword[15:12];
                seg3_num <= becomeMemPsword[11:8];
                {i0,i1,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out};
                {i2,i5,i6,i7}={4{NULL}};               
                end              
                else if(cnt_ch_psword == 3)begin
                seg2_num <= becomeMemPsword[15:12];
                seg3_num <= becomeMemPsword[11:8];
                seg4_num <= becomeMemPsword[7:4];
                {i0,i1,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
                {i2,i6,i7}={3{NULL}};               
                end                
                else if(cnt_ch_psword == 4)begin
                seg2_num <= becomeMemPsword[15:12];
                seg3_num <= becomeMemPsword[11:8];
                seg4_num <= becomeMemPsword[7:4];
                seg5_num <= becomeMemPsword[3:0];
                {i0,i1,i3,i4,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                {i2,i7}={2{NULL}};             
             end
          end
        9:begin
               seg0_num <= 5'd1;
               seg1_num <= 5'hb;
               seg2_num <= 5'd2;
               seg3_num <= 5'd17;
               seg4_num <= 5'd3;
               seg5_num <= 5'hc;
               {i0,i1,i3,i4,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
               {i2,i5}={2{NULL}};   
         end
        10:begin
                 seg0_num <= 5'hd;
                 seg1_num <= 5'd0;
                 seg2_num <= 5'd21;
                 seg3_num <= 5'he;
                 {i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out};
                 {i0,i1,i6,i7}={4{NULL}};  
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
                  seg0_num <= 5'd17;
                  seg1_num <= 5'd0;
                  seg2_num <= 5'd24;
                  seg3_num <= 5'd25;
                  seg4_num <= 5'd24;
                  if(cnt_be_money == 0)begin  
                  {i0,i1,i2,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
                  {i5,i6,i7}={3{NULL}}; 
                  end
                  else if(cnt_be_money == 1)begin
                  seg5_num <= be_money_ten;
                  {i0,i1,i2,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                  {i5,i7}={2{NULL}};              
                  end
                  else if(cnt_be_money == 2)begin
                  seg5_num <= be_money_ten;
                  seg6_num <= be_money_one;
                  {i0,i1,i2,i3,i4,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out ,seg6_out};
                  {i5}={1{NULL}};             
               end
            end
        13:begin
                 seg0_num <= 5'hd;
                 seg1_num <= 5'd0;
                 seg2_num <= 5'd21;
                 seg3_num <= 5'he;
                 {i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out};
                 {i0,i1,i6,i7}={4{NULL}};
           end
        14:begin
                 seg0_num <= 5'd0;
                 seg1_num <= 5'd21;
                 seg2_num <= 5'd1;
                 seg3_num <= 5'd23;
                 {i1,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out};
                 {i0,i2,i5,i7}={4{NULL}};
           end
        15:begin
                  if(cnt_money == 0)
                  {i0,i1,i2,i3,i4,i5,i6,i7}={8{NULL}}; 
                  else if(cnt_money == 1)begin
                  seg0_num <= money_ten;
                  {i0}={seg0_out};
                  {i1,i2,i3,i4,i5,i6,i7}={7{NULL}};              
                  end
                  else if(cnt_money == 2)begin
                  seg2_num <= money  / 10;
                  seg3_num <= money % 10;
                  seg0_num <= money_ten;
                  seg1_num <= money_one;
                  seg4_num <= le_money / 10;
                  seg5_num <= le_money % 10;
                  {i0,i1,i3,i4,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                  {i2,i5}={2{NULL}};        
               end
            end
        16:begin
                 seg0_num <= 5'd24;
                 seg1_num <= 5'd5;
                 if(cnt_ps == 0)begin  
                 {i0,i1}={seg0_out,seg1_out};
                 {i2,i3,i4,i5,i6,i7}={6{NULL}}; 
                 end
                 else if(cnt_ps == 1)begin
                 seg2_num <= now_ps[15:12];
                 {i0,i1,i3}={seg0_out,seg1_out,seg2_out};
                 {i2,i4,i5,i6,i7}={5{NULL}};               
                 end
                 else if(cnt_ps == 2)begin
                 seg2_num <= now_ps[15:12];
                 seg3_num <= now_ps[11:8];
                 {i0,i1,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out};
                 {i2,i5,i6,i7}={4{NULL}};               
                 end              
                 else if(cnt_ps == 3)begin
                 seg2_num <= now_ps[15:12];
                 seg3_num <= now_ps[11:8];
                 seg4_num <= now_ps[7:4];
                 {i0,i1,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
                 {i2,i6,i7}={3{NULL}};               
                 end                
                 else if(cnt_ps == 4)begin
                 seg2_num <= now_ps[15:12];
                 seg3_num <= now_ps[11:8];
                 seg4_num <= now_ps[7:4];
                 seg5_num <= now_ps[3:0];
                 {i0,i1,i3,i4,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                 {i2,i7}={2{NULL}};       
              end
           end 
        17:begin
                 seg0_num <= 5'hd;
                 seg1_num <= 5'd0;
                 seg2_num <= 5'd21;
                 seg3_num <= 5'he;
                 {i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out};
                 {i0,i1,i6,i7}={4{NULL}}; 
           end
        18:begin
             seg0_num <= 5'hf;
             seg1_num <= 5'd25;
             seg2_num <= 5'd16;
             seg3_num <= 5'd16;
             {i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out};
             {i0,i1,i6,i7}={4{NULL}};    
         end
         19: begin
                      seg0_num <= 5'hd;
                      seg1_num <= 5'd0;
                      seg2_num <= 5'd21;
                      seg3_num <= 5'he;
                      case({account})
                      1: begin seg4_num <= one[5:0] / 10; seg5_num <= one[5:0] % 10; end
                      2: begin seg4_num <= two[5:0]/ 10; seg5_num <= two[5:0] % 10; end
                      3: begin seg4_num <= three[5:0]/ 10; seg5_num <=three[5:0] % 10; end
                      4: begin seg4_num <= four[5:0]/ 10; seg5_num <= four[5:0] % 10; end
                      5: begin seg4_num <= five[5:0]/ 10; seg5_num <= five[5:0] %10; end
                      endcase
                      {i0,i1,i2,i3,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                      {i4,i7}={2{NULL}};  
         end
         20: begin
                    seg7_num <= 5'd18;
                    case({account})
                    1: begin seg8_num <=  5'd1;seg10_num <= one[5:0] % 10;  seg9_num <= one[5:0] / 10;  end
                    2: begin seg8_num <= 5'd2; seg10_num <= two[5:0] % 10;  seg9_num <= two[5:0] / 10;   end
                    3: begin seg8_num <= 5'd3; seg10_num <=three[5:0] % 10; seg9_num <=three[5:0] / 10; end
                    4: begin seg8_num <= 5'd4; seg10_num <= four[5:0] % 10; seg9_num <= four[5:0] / 10;  end
                    5: begin seg8_num <= 5'd5; seg10_num <= five[5:0] %10;  seg9_num <= five[5:0] /10;   end
                    endcase
                    case({pos})
                    0:   begin  {i0 ,i1 ,i3,i4}={seg7_out,seg8_out,seg9_out,seg10_out};  
                     {i2,i5,i6,i7}={4{NULL}};   
                    end
                    1:   begin {i1,i2,i4,i5}={seg7_out,seg8_out,seg9_out,seg10_out};  
                                             {i0,i3,i6,i7}={4{NULL}};      
                     end                                                                                                                    
                    2:   begin {i2,i3,i5,i6}={seg7_out,seg8_out,seg9_out,seg10_out};  
                                       {i0,i1,i4,i7}={4{NULL}};  
                    end
                    3:   begin  {i3,i4,i6,i7}={seg7_out,seg8_out,seg9_out,seg10_out};  
                                        {i0,i1,i2,i5}={4{NULL}}; 
                    end
                    4:   begin  {i3,i4,i6,i7}={seg7_out,seg8_out,seg9_out,seg10_out};  
                                       {i0,i1,i2,i5}={4{NULL}};  
                     end
                    5:   begin {i2,i3,i5,i6}={seg7_out,seg8_out,seg9_out,seg10_out};  
                                        {i0,i1,i4,i7}={4{NULL}};  
                     end
                    6:   begin{i1,i2,i4,i5}={seg7_out,seg8_out,seg9_out,seg10_out};  
                                      {i0,i3,i6,i7}={4{NULL}};    
                     end
                    7:   begin {i0,i1,i3,i4}={seg7_out,seg8_out,seg9_out,seg10_out};  
                                       {i2,i5,i6,i7}={4{NULL}};   
                     end
                    endcase
            end
         21:begin
                          seg0_num <= 5'hd;
                          seg1_num <= 5'd0;
                          seg2_num <= 5'd21;
                          seg3_num <= 5'he;
                          {i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out};
                          {i0,i1,i6,i7}={4{NULL}};  
                    end
         endcase
   end
   end
   
   always @(posedge clk) begin
     if(view == 5 && state == 20)begin
       if( pos <= 7) begin
         if( ms100_pass == 10 ) begin
           if( pos != 7)
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

    endmodule