`timescale 1ns / 1ps

 module administrator_model_display(
        input clk,
        input rst,
        input [2:0] view,
        //state浼犺繘鏉?
        input [4:0] state,
        //�??鏈�?俊鎭?!
        input [3:0] discount,
        input [2:0] open_a,
        input [2:0] open_b,
        input [2:0] left_a,
        input [2:0] left_b,
        input [8:0] profit,
        input [5:0] a_pos,
        input [5:0] b_pos,
        input [1:0] start_a,
        input [1:0] start_b,
        input [1:0] each_a,
        input [1:0] each_b,
        input[19:0] ps_write,
        input [2:0] cnt_ps,
        input [2:0] ps_error_time,
        input [3:0] select1,
        input [3:0] select2,
        input [2:0] select3,
        input cnt_starta,
        input [1:0]show_starta,
        input cnt_startb,
        input [1:0]show_startb,
        input cnt_eacha,
        input [1:0]show_eacha, 
        input cnt_eachb,
        input [1:0]show_eachb, 
        input cnt_toa,
        input [2:0]show_toa,   
        input cnt_tob,
        input [2:0] show_tob, 
        input cnt_dis,
        input [3:0] show_dis,
        output [7:0] seg_out,
        output [7:0] seg_en,
        input [8:0] time_avg
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
    
    reg [4:0] seg7_num;
    wire [7:0] seg7_out;
    seg_show seg7(seg7_num,seg7_out);
   
    reg change;

     always @(*) begin
      if(view == 1)begin
        case(state)
        1:begin
        seg0_num <= 5'ha;
        seg1_num <= 5'hd;
        seg2_num <= 5'd26;
        seg3_num <= 5'd25;        
        seg4_num <= 5'd26;
        {i1,i2,i4,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
        {i0,i3,i7}={3{NULL}};        
        end
        2:begin
           seg0_num <= 5'd24;
           seg1_num <= 5'd5;
           if(cnt_ps == 0)begin  
           {i0,i1}={seg0_out,seg1_out};
           {i2,i3,i4,i5,i6,i7}={6{NULL}}; 
           end
           else if(cnt_ps == 1)begin
           seg2_num <= ps_write[19:16];
           {i0,i1,i3}={seg0_out,seg1_out,seg2_out};
           {i2,i4,i5,i6,i7}={5{NULL}};               
           end
           else if(cnt_ps== 2)begin
           seg2_num <= ps_write[19:16];
           seg3_num <= ps_write[15:12];
           {i0,i1,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out};
           {i2,i5,i6,i7}={4{NULL}};               
           end              
           else if(cnt_ps == 3)begin
           seg2_num <= ps_write[19:16];
           seg3_num <= ps_write[15:12];
           seg4_num <= ps_write[11:8];
           {i0,i1,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
           {i2,i6,i7}={3{NULL}};               
           end                
           else if(cnt_ps == 4)begin
           seg2_num <= ps_write[19:16];
           seg3_num <= ps_write[15:12];
           seg4_num <= ps_write[11:8];
           seg5_num <= ps_write[7:4];
           {i0,i1,i3,i4,i5,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
           {i2,i7}={2{NULL}}; 
           end
           else if(cnt_ps == 5)begin
           seg2_num <= ps_write[19:16];
           seg3_num <= ps_write[15:12];
           seg4_num <= ps_write[11:8];
           seg5_num <= ps_write[7:4];
           seg6_num <= ps_write[3:0];
           {i0,i1,i3,i4,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out,seg6_out};
           {i2}={1{NULL}}; 
           end
         end
        3:begin
           seg0_num <= 5'd2;
           seg1_num <= 5'd19;
           seg2_num <= 5'd3;
           seg3_num <= 5'hb;
           seg4_num <= 5'ha;
           seg5_num <= 5'hc;
           seg6_num <= 5'd5;
           seg7_num <= 5'hd;
           {i0,i1,i2,i3,i4,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out,seg6_out,seg7_out};
       end
        4:begin
            seg0_num <= 5'he;
            seg1_num <= 5'd19;
            seg2_num <= 5'd19;
            seg3_num <= 5'd0;
            seg4_num <= 5'd19;
            {i1,i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
            {i0,i6,i7}={3{NULL}}; 
      end
        5:begin
                  seg0_num <= 5'ha;
                  seg1_num <= 5'd5;
                  seg2_num <= 5'he;
                  seg3_num <= 5'he;
                  seg4_num <= 5'hc;
                  seg5_num <= 5'hd;
                  seg6_num <= 5'hd;
                  {i0,i1,i2,i4,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out,seg6_out};
                  {i3}={1{NULL}}; 
            end
        6:begin
              seg0_num <= 5'd2;
              seg1_num <= 5'd1;
              seg2_num <= 5'd21;
              seg3_num <= 5'd3;
              seg4_num <= 5'hc;
              seg5_num <= 5'd16;
              seg6_num <= 5'd19;
              {i0,i1,i2,i4,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out,seg6_out};
              {i3}={1{NULL}};  
        end
        7:begin
        seg0_num <= 5'ha;
        seg1_num <= 5'd25;
        seg2_num <= 5'd22;
        seg3_num <= time_avg / 100;
        seg4_num <= (time_avg % 100) / 10;
        seg5_num <= (time_avg % 100) % 10;
        {i0,i1,i2,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
        {i3,i4}={2{NULL}};   
          end
        8:begin
                seg0_num <= 5'ha;
                 seg1_num <= 5'd0;
                 seg2_num <= 5'd19;
                 seg3_num <= 5'hb;
                 {i1,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out};
                 {i0,i2,i5,i7}={4{NULL}}; 
          end
        9:begin
               seg0_num <= 5'd5;
               seg1_num <= 5'd17;
               seg2_num <= 5'ha;
               seg3_num <= 5'd19;
               seg4_num <= 5'd17;
               seg5_num <= 5'ha;
               if(cnt_starta) begin
               seg6_num <= show_starta;
               {i0,i1,i2,i3,i4,i5,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out,seg6_out};
              {i6}={1{NULL}};  
               end
               else begin
                {i0,i1,i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
               {i6,i7}={2{NULL}}; 
            end
         end
        10:begin
                 seg0_num <= 5'd0;
                 seg1_num <= 5'd24;
                 seg2_num <= 5'he;
                 seg3_num <= 5'd21;
                 seg4_num <= 5'ha;
                 if(cnt_toa) begin
                 seg5_num <= show_toa;
                 {i0,i1,i2,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                 {i5,i7}={2{NULL}};  
                 end
                 else begin
                  {i0,i1,i2,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out };
                 {i5,i6,i7}={3{NULL}};  
                 end       
              end
        11:begin
               seg0_num <= 5'hd;
               seg1_num <= 5'd1;
               seg2_num <= 5'd18;
               if(cnt_dis) begin
               seg3_num <= show_dis;
               {i0,i1,i2,i4}={seg0_out,seg1_out,seg2_out,seg3_out};
               {i3,i5,i6,i7}={4{NULL}};  
               end
               else begin
                {i0,i1,i2}={seg0_out,seg1_out,seg2_out};
                {i3,i4,i5,i6,i7}={5{NULL}};  
            end
         end
        12:begin
                  seg0_num <= 5'he;
                  seg1_num <= 5'ha;
                  seg2_num <= 5'd19;
                  seg3_num <= 5'd21;
                  seg4_num <= profit / 100;
                  seg5_num <= (profit % 100) / 10;
                  seg6_num <= (profit % 100) % 10;
                  {i0,i1,i2,i3,i5,i6,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out ,seg6_out};
                  {i4}={1{NULL}};  
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
                 seg0_num <= 5'hd;
                 seg1_num <= 5'd0;
                 seg2_num <= 5'd21;
                 seg3_num <= 5'he;
                 {i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out};
                 {i0,i1,i6,i7}={4{NULL}};  
           end
        16:begin
                seg0_num <= 5'd5;
                seg1_num <= 5'd17;
                seg2_num <= 5'ha;
                seg3_num <= 5'd19;
                seg4_num <= 5'd17;
                seg5_num <= 5'hb;
                if(cnt_startb) begin
                seg6_num <= show_startb;
                {i0,i1,i2,i3,i4,i5,i7}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out,seg6_out};
                {i6}={1{NULL}};  
                end
                else begin
                 {i0,i1,i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                {i6,i7}={2{NULL}};
              end
           end 
        17:begin
                   seg0_num <= 5'he;
                   seg1_num <= 5'ha;
                   seg2_num <= 5'hc;
                   seg3_num <= 5'd20;
                   seg4_num <= 5'ha;
                   if(cnt_eacha) begin
                   seg5_num <= show_eacha;
                   {i0,i1,i2,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                  {i5,i7}={2{NULL}};  
                   end
                   else begin
                    {i0,i1,i2,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
                   {i5,i6,i7}={3{NULL}};  
              end
           end
        18:begin
             seg0_num <= 5'he;
             seg1_num <= 5'ha;
             seg2_num <= 5'hc;
             seg3_num <= 5'd20;
             seg4_num <= 5'hb;
             if(cnt_eachb) begin
             seg5_num <= show_eachb;
             {i0,i1,i2,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
             {i5,i7}={2{NULL}};  
             end
             else begin
              {i0,i1,i2,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out};
             {i5,i6,i7}={3{NULL}};  
            end
         end
        19: begin
                      seg0_num <= 5'd0;
                      seg1_num <= 5'd24;
                      seg2_num <= 5'he;
                      seg3_num <= 5'd21;
                      seg4_num <= 5'hb;
                      if(cnt_tob) begin
                      seg5_num <= show_tob;
                      {i0,i1,i2,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out,seg5_out};
                      {i5,i7}={2{NULL}};  
                      end
                      else begin
                       {i0,i1,i2,i3,i4}={seg0_out,seg1_out,seg2_out,seg3_out,seg4_out };
                      {i5,i6,i7}={3{NULL}};     
                     end
         end
         20: begin
         seg0_num <= 5'hd;
         seg1_num <= 5'd0;
         seg2_num <= 5'd21;
         seg3_num <= 5'he;
         {i2,i3,i4,i5}={seg0_out,seg1_out,seg2_out,seg3_out};
         {i0,i1,i6,i7}={4{NULL}}; 
         end
         21: begin
                seg0_num <= 5'd0;
                seg1_num <= 5'd21;
                seg2_num <= 5'd2;
                seg3_num <= 5'd23;
                {i1,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out};
                {i0,i2,i5,i7}={4{NULL}}; 
         end
         22: begin
                    seg0_num <= 5'd0;
                    seg1_num <= 5'd21;
                    seg2_num <= 5'd2;
                    seg3_num <= 5'd23;
                    {i1,i3,i4,i6}={seg0_out,seg1_out,seg2_out,seg3_out};
                    {i0,i2,i5,i7}={4{NULL}}; 
         end
         endcase
   end
   end

    endmodule
