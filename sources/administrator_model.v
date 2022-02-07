`timescale 1ns / 1ps

module administrator_model(
    input clk,
    input rst,
    input [2:0] view,
    output reg [4:0] state,
    output reg [3:0] discount,
    output reg [2:0] open_a,
    output reg [2:0] open_b,
    output reg  a_clean,
    output reg  b_clean,
    output reg is_clean_profit,
    output reg [5:0] a_pos,
    output reg [5:0] b_pos,
    output reg [1:0] start_a,
    output reg [1:0] start_b,
    output reg [1:0] each_a,
    output reg [1:0] each_b,
    output reg [19:0] ps_write,
    output reg [2:0] cnt_ps,
    output reg [2:0] ps_error_time,
    output reg [3:0] select1,
    output reg [3:0] select2,
    output reg [2:0] select3,
    output reg cnt_starta,
    output reg [1:0]show_starta,
    output reg cnt_startb,
    output reg [1:0]show_startb,
    output reg cnt_eacha,
    output reg [1:0]show_eacha, 
    output reg cnt_eachb,
    output reg [1:0]show_eachb, 
    output reg cnt_toa,
    output reg [2:0]show_toa,   
    output reg cnt_tob,
    output reg [2:0]show_tob, 
    output reg cnt_dis,
    output reg [3:0] show_dis,
    input [15:0] key_out,
    input [4:0] bt
    );
    wire up_bt, down_bt, mid_bt,left_bt,right_bt;
    assign up_bt = bt[2];
    assign left_bt = bt[1];
    assign right_bt = bt[0];
    assign down_bt = bt[4];
    assign mid_bt = bt[3];
    //a.璁剧疆鍋滆溅璧锋浠蜂互鍙婃瘡灏忔�?鐨勪�?���???
    //b.鏌ョ湅鍋滆溅鍦虹洰鍓嶇殑�?��敹鍏ヤ互鍙婃竻绌�?��棰濄??
    //c.缁熻杞﹁締鐨勫钩鍧囧仠鐣欐椂闂�???
    //d.娓呯┖鍋滆溅�??,閲嶅惎绯荤粺�??
    //e.璁剧疆鎬荤殑鍋滆溅浣嶇殑鏁伴噺銆?
    //f.璁剧疆浼�?��浼樻�?��跺�?锛堝浼�?��鐨勮捣�?ヤ环杈冧綆锛屾垨浼氬憳浠樻鏃舵墦鍏�?绛�?�?
    reg is_ps_right;
    reg ispressed;
    reg [3:0] chos_ab;
    reg [19:0] psword = 20'b0010_0011_0101_0110_1000;
    reg is_chos_ab;
    reg [1:0]  is_clr;
    reg is_chos_clr;
    reg isProfit;
    reg is3;
    
    always @(posedge clk) begin
        if(!left_bt && !right_bt && !mid_bt && !up_bt && !down_bt) begin 
              ispressed = 0;
            end
        if(view != 1) state <= 1;
        if(rst && view == 1) begin
             state <= 1;
        end 
        else
        begin
            if(view == 1) 
            begin
                if(mid_bt && !ispressed) begin
                    ispressed = 1;
                    case({state})
                    //杩涘叆杈撳瘑�?��ā�??
                    1: state <= 2;
                    2: begin
                                 if(is_ps_right)
                                             state <= 3;
                                     else begin
                                             if(ps_error_time <= 4 && ps_error_time >= 0)
                                                     state <= 4; //error
                                     end
                             end
                    3:begin
                    if(is3)begin
                               case({select1})
                             2: state <= 5;
                             3: state <= 6;
                             5: state <= 8;
                             4'ha: state <= 7;
                             endcase
                    end
                     end
                    //閿欒鍥炲埌杈撳瘑鐮?
                    4: state <= 2;
                    5: begin
                              case(select2)
                              4'ha: state <= 9;
                              4'he: state <= 10;
                              4'hd: state <= 11;
                              endcase
                        end
                    6: begin
                    case(select3)
                    2:state <= 12;
                    3:state <= 13;
                    endcase
                    end
                    7: state <= 3;
                    8: begin
                    if(is_chos_ab) begin
                         case(chos_ab)
                         10: state <= 21;
                         11: state <= 22;
                         endcase
                         end
                    end
                    9: if(cnt_starta == 1) state<= 16;
                    10: if(cnt_toa == 1) state <= 19;
                    11: state <= 20;
                    12: state <= 6; //鏄剧ずprofit鐨勫?? - 12
                    13: state <= 6;//鏄剧ずdone - 13
                    14: state <= 3;
                    16: if(cnt_startb == 1) state<= 17;
                    17:  if(cnt_eacha == 1) state<=18;
                    18:  if(cnt_eachb == 1) state<=20;
                    19: if(cnt_tob == 1) state <= 20;
                    20: state <= 5;
                    //涓嶆竻绌哄仠杞﹀満
                    21: if(is_chos_clr && is_clr == 2) state <= 14;
                    22: if(is_chos_clr && is_clr == 2) state <= 14;
                    endcase 
                end
                else if(up_bt && !ispressed) begin
                    ispressed = 1;
                    case(state)
                    //杈撻敊瀵嗙爜鍥炲埌1
                    3: state <= 1;
                    2: state <= 1; 
                    6: state <= 3;
                    5: state <= 3;
                    8: state <= 3;
                    endcase
                end
            end
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin
             open_a <= 3;
             open_b <= 3;
             //left_a <= 3;
             //left_b <= 3;
             discount <= 8;
             start_a <= 1;
             start_b <= 2;
             each_a <=1;
             each_b <= 2;
        end
        else begin
        if(view == 1) begin
            case({state})
            1:begin
            //杈撳叆瀵嗙�?
               ps_write <= 0;
               cnt_ps <= 0;
               ps_error_time <= 0;
               select1 <= 0;
               select2 <= 0;
               select3 <= 0;
               cnt_starta <= 0;
               show_starta<= 0;
               cnt_startb<= 0;
                show_startb<= 0;
               cnt_eacha<= 0;
                show_eacha<= 0;
               cnt_eachb<= 0;
               show_eachb<= 0;
               cnt_toa <= 0;
                show_toa<= 0;
               cnt_tob<= 0;
               is_clean_profit <= 0;
                show_tob <= 0;
               cnt_dis <= 0;
                show_dis<= 0;
               is_ps_right <= 0;
              chos_ab <= 0;
              is_chos_ab <= 0;
              isProfit <= 0;
            end
            2:begin
                   if(cnt_ps == 0) begin
                   case(key_out[12:1])
                        12'b000_000_000_001:begin ps_write[19:16] <= 1; cnt_ps = cnt_ps + 1; end
                        12'b000_000_000_010:begin ps_write[19:16] <= 2; cnt_ps = cnt_ps + 1; end
                        12'b000_000_000_100:begin ps_write[19:16] <= 3; cnt_ps = cnt_ps + 1; end
                        12'b000_000_001_000:begin ps_write[19:16] <= 4; cnt_ps = cnt_ps + 1; end
                        12'b000_000_010_000:begin ps_write[19:16] <= 5; cnt_ps = cnt_ps + 1; end
                        12'b000_000_100_000:begin ps_write[19:16] <= 6; cnt_ps = cnt_ps + 1; end
                        12'b000_001_000_000:begin ps_write[19:16] <= 7; cnt_ps = cnt_ps + 1; end
                        12'b000_010_000_000:begin ps_write[19:16] <= 8; cnt_ps = cnt_ps + 1; end
                        12'b000_100_000_000:begin ps_write[19:16] <= 9; cnt_ps = cnt_ps + 1; end
                        12'b001_000_000_000:begin ps_write[19:16] <= 4'ha; cnt_ps = cnt_ps + 1; end
                        12'b010_000_000_000:begin ps_write[19:16] <= 4'hb; cnt_ps = cnt_ps + 1; end
                        12'b100_000_000_000:begin ps_write[19:16] <= 4'hc; cnt_ps = cnt_ps + 1; end
                    endcase             
                    end
                    else if(cnt_ps == 1) begin
                    case(key_out[12:1])
                        12'b000_000_000_001:begin ps_write[15:12] <= 1; cnt_ps = cnt_ps + 1; end
                        12'b000_000_000_010:begin ps_write[15:12] <= 2; cnt_ps = cnt_ps + 1; end
                        12'b000_000_000_100:begin ps_write[15:12] <= 3; cnt_ps = cnt_ps + 1; end
                        12'b000_000_001_000:begin ps_write[15:12] <= 4; cnt_ps = cnt_ps + 1; end
                        12'b000_000_010_000:begin ps_write[15:12] <= 5; cnt_ps = cnt_ps + 1; end
                        12'b000_000_100_000:begin ps_write[15:12] <= 6; cnt_ps = cnt_ps + 1; end
                        12'b000_001_000_000:begin ps_write[15:12] <= 7; cnt_ps = cnt_ps + 1; end
                        12'b000_010_000_000:begin ps_write[15:12] <= 8; cnt_ps = cnt_ps + 1; end
                        12'b000_100_000_000:begin ps_write[15:12] <= 9; cnt_ps = cnt_ps + 1; end
                        12'b001_000_000_000:begin ps_write[15:12] <= 4'ha; cnt_ps = cnt_ps+ 1; end
                        12'b010_000_000_000:begin ps_write[15:12] <= 4'hb; cnt_ps = cnt_ps+ 1; end
                        12'b100_000_000_000:begin ps_write[15:12] <= 4'hc; cnt_ps = cnt_ps+ 1; end
                    endcase             
                    end
                    else if(cnt_ps == 2) begin
                    case(key_out[12:1])
                        12'b000_000_000_001:begin ps_write[11:8] <= 1; cnt_ps = cnt_ps + 1; end
                        12'b000_000_000_010:begin ps_write[11:8] <= 2; cnt_ps = cnt_ps + 1; end
                        12'b000_000_000_100:begin ps_write[11:8] <= 3; cnt_ps = cnt_ps + 1; end
                        12'b000_000_001_000:begin ps_write[11:8] <= 4; cnt_ps = cnt_ps + 1; end
                        12'b000_000_010_000:begin ps_write[11:8] <= 5; cnt_ps = cnt_ps + 1; end
                        12'b000_000_100_000:begin ps_write[11:8] <= 6; cnt_ps = cnt_ps + 1; end
                        12'b000_001_000_000:begin ps_write[11:8] <= 7; cnt_ps = cnt_ps + 1; end
                        12'b000_010_000_000:begin ps_write[11:8] <= 8; cnt_ps = cnt_ps + 1; end
                        12'b000_100_000_000:begin ps_write[11:8] <= 9; cnt_ps = cnt_ps + 1; end
                        12'b001_000_000_000:begin ps_write[11:8] <= 4'ha; cnt_ps = cnt_ps + 1; end
                        12'b010_000_000_000:begin ps_write[11:8] <= 4'hb; cnt_ps = cnt_ps + 1; end
                        12'b100_000_000_000:begin ps_write[11:8] <= 4'hc; cnt_ps = cnt_ps + 1; end
                    endcase             
                    end
                    else if(cnt_ps == 3) begin
                    case(key_out[12:1])
                        12'b000_000_000_001:begin ps_write[7:4] <= 1; cnt_ps = cnt_ps + 1; end
                        12'b000_000_000_010:begin ps_write[7:4] <= 2; cnt_ps = cnt_ps + 1; end
                        12'b000_000_000_100:begin ps_write[7:4] <= 3; cnt_ps = cnt_ps + 1; end
                        12'b000_000_001_000:begin ps_write[7:4] <= 4; cnt_ps = cnt_ps + 1; end
                        12'b000_000_010_000:begin ps_write[7:4] <= 5; cnt_ps = cnt_ps + 1; end
                        12'b000_000_100_000:begin ps_write[7:4] <= 6; cnt_ps = cnt_ps + 1; end
                        12'b000_001_000_000:begin ps_write[7:4] <= 7; cnt_ps = cnt_ps + 1; end
                        12'b000_010_000_000:begin ps_write[7:4] <= 8; cnt_ps = cnt_ps + 1; end
                        12'b000_100_000_000:begin ps_write[7:4] <= 9; cnt_ps = cnt_ps + 1; end
                        12'b001_000_000_000:begin ps_write[7:4] <= 4'ha; cnt_ps = cnt_ps + 1; end
                        12'b010_000_000_000:begin ps_write[7:4] <= 4'hb; cnt_ps = cnt_ps + 1; end
                        12'b100_000_000_000:begin ps_write[7:4] <= 4'hc; cnt_ps = cnt_ps + 1; end
                    endcase             
                    end
                    else if(cnt_ps == 4) begin
                            case(key_out[12:1])
                                  12'b000_000_000_001:begin ps_write[3:0] <= 1; cnt_ps = cnt_ps + 1; end
                                  12'b000_000_000_010:begin ps_write[3:0] <= 2; cnt_ps = cnt_ps + 1; end
                                  12'b000_000_000_100:begin ps_write[3:0] <= 3; cnt_ps = cnt_ps + 1; end
                                  12'b000_000_001_000:begin ps_write[3:0] <= 4; cnt_ps = cnt_ps + 1; end
                                  12'b000_000_010_000:begin ps_write[3:0] <= 5; cnt_ps = cnt_ps + 1; end
                                  12'b000_000_100_000:begin ps_write[3:0] <= 6; cnt_ps = cnt_ps + 1; end
                                  12'b000_001_000_000:begin ps_write[3:0] <= 7; cnt_ps = cnt_ps + 1; end
                                  12'b000_010_000_000:begin ps_write[3:0] <= 8; cnt_ps = cnt_ps + 1; end
                                  12'b000_100_000_000:begin ps_write[3:0] <= 9; cnt_ps = cnt_ps + 1; end
                                  12'b001_000_000_000:begin ps_write[3:0] <= 4'ha; cnt_ps = cnt_ps + 1; end
                                  12'b010_000_000_000:begin ps_write[3:0] <= 4'hb; cnt_ps = cnt_ps + 1; end
                                  12'b100_000_000_000:begin ps_write[3:0] <= 4'hc; cnt_ps = cnt_ps + 1; end
                           endcase             
                     end                                      
                    else if(cnt_ps == 5)begin
                        if(ps_write == psword)
                              is_ps_right <= 1'b1;
                        else begin
                               if(ps_error_time == 0 || ps_error_time == 1 || ps_error_time == 2 || ps_error_time == 3)
                                         ps_error_time <= ps_error_time + 1;
                       end                                                                                                                      
                   end
               end
            3:begin
                    a_clean <= 0;
                    b_clean <= 0;
                   is_clr <= 0;
                   is_chos_clr <= 0;
                   chos_ab <= 0;
                   is_chos_ab <= 0;
                    case(key_out[10:2])
                    9'b000_000_001:begin select1 <= 2 ;       is3 <= 1; end
                    9'b000_000_010:begin select1 <= 3 ;   is3 <= 1;      end 
                    9'b000_001_000:begin select1 <= 5 ;    is3 <= 1;     end 
                    9'b100_000_000:begin select1 <= 4'ha ;  is3 <= 1; end
                    endcase
                end
            4: begin
            ps_write <= 0;
            cnt_ps <= 0;
            ps_error_time <= 0;
            end
            5:begin
                          is3 <= 0; 
                           ps_write <= 0;
                           isProfit <= 0;
                           cnt_ps <= 0;
                           ps_error_time <= 0;
                           select1 <= 0;
                           select3 <= 0;
                           cnt_starta <= 0;
                           show_starta<= 0;
                           cnt_startb<= 0;
                            show_startb<= 0;
                           cnt_eacha<= 0;
                            show_eacha<= 0;
                           cnt_eachb<= 0;
                           show_eachb<= 0;
                           cnt_toa <= 0;
                            show_toa<= 0;
                           cnt_tob<= 0;
                            show_tob <= 0;
                           cnt_dis <= 0;
                            show_dis<= 0;
                           is_ps_right <= 0;
                     case(key_out[14:0])
                         15'b000_010_000_000_000:begin select2 <= 4'ha ; end
                         15'b100_000_000_000_000:begin select2 <= 4'he ; end 
                         15'b010_000_000_000_000:begin select2 <= 4'hd ; end
                         endcase
                     end
            6:begin
             is3 <= 0; 
             is_clean_profit <= 0;
                      case(key_out[3:2])
                      2'b01:begin select3 <= 2 ; isProfit <= 1; end
                      2'b10:begin select3 <= 3 ; isProfit <= 1; end
                      endcase
               end
            7: is3 <= 0; 
            8:begin
                is3 <= 0; 
                     case(key_out[11:10])
                      2'b01: begin chos_ab <= 4'ha;  is_chos_ab <= 1; end
                      2'b10: begin chos_ab <= 4'hb; is_chos_ab <= 1; end
                      endcase
               end
            9:begin
            select2 <= 0;
            if(cnt_starta == 0) begin
                case(key_out[3:0])
                     4'b0001:begin show_starta <= 0; cnt_starta = cnt_starta + 1; end
                     4'b0100:begin show_starta <= 2; cnt_starta = cnt_starta + 1; end
                     4'b1000:begin show_starta <= 3; cnt_starta = cnt_starta + 1; end
                 endcase
                 end
                 else if(cnt_starta == 1)begin
                        start_a <= show_starta;
                 end             
            end
            10:begin
            select2 <=0;
                  if(cnt_toa == 0) begin
                      case(key_out[3:0])
                           4'b0001:begin show_toa <= 0; cnt_toa = cnt_toa + 1; end
                           4'b0100:begin show_toa <= 2; cnt_toa = cnt_toa + 1; end
                           4'b1000:begin show_toa <= 3; cnt_toa = cnt_toa + 1; end
                       endcase
                       end
                       else if(cnt_toa == 1)begin
                              open_a <= show_toa;
                       end             
                  end
            11:begin
            select2 <= 0;
                 if(cnt_dis == 0) begin
                     case(key_out[9:5])
                          5'b00001:begin show_dis <= 5; cnt_dis = cnt_dis + 1; end
                          5'b00010:begin show_dis <= 6; cnt_dis = cnt_dis + 1; end
                          5'b00100:begin show_dis <= 7; cnt_dis = cnt_dis + 1; end
                          5'b01000:begin show_dis <= 8; cnt_dis = cnt_dis + 1; end
                          5'b10000:begin show_dis <= 9; cnt_dis = cnt_dis + 1; end
                      endcase
                      end
                      else if(cnt_dis == 1)begin
                             discount <= show_dis;
                      end             
                 end
            12: begin select3 <= 0;  isProfit <= 0; end
            13:begin
            select3 <= 0;
            isProfit <= 0;
            is_clean_profit <= 1;
            end
            14: is_chos_clr <= 0;
            16:begin
                 if(cnt_startb == 0) begin
                     case(key_out[3:0])
                          4'b0001:begin show_startb <= 0; cnt_startb = cnt_startb + 1; end
                          4'b0100:begin show_startb <= 2; cnt_startb = cnt_startb + 1; end
                          4'b1000:begin show_startb <= 3; cnt_startb = cnt_startb + 1; end
                      endcase
                      end
                      else if(cnt_startb == 1)begin
                             start_b <= show_startb;
                      end             
                 end
             17:begin
                   if(cnt_eacha == 0) begin
                       case(key_out[3:2])
                            2'b01:begin show_eacha <= 2; cnt_eacha = cnt_eacha + 1; end
                            2'b10:begin show_eacha <= 3; cnt_eacha = cnt_eacha + 1; end
                        endcase
                        end
                        else if(cnt_eacha == 1)begin
                               each_a <= show_eacha;
                        end             
                   end
             18:begin
                  if(cnt_eachb == 0) begin
                      case(key_out[3:2])
                           2'b01:begin show_eachb <= 2; cnt_eachb = cnt_eachb + 1; end
                           2'b10:begin show_eachb <= 3; cnt_eachb = cnt_eachb + 1; end
                       endcase
                       end
                       else if(cnt_eachb == 1)begin
                              each_b <= show_eachb;
                       end             
                  end
             19:begin
                    if(cnt_tob == 0) begin
                      case(key_out[3:0])
                         4'b0001:begin show_tob <= 0; cnt_tob = cnt_tob + 1; end
                         4'b0100:begin show_tob <= 2; cnt_tob = cnt_tob + 1; end
                         4'b1000:begin show_tob <= 3; cnt_tob = cnt_tob + 1; end
                         endcase
                         end
                         else if(cnt_tob == 1)begin
                                open_b <= show_tob;
                         end             
                    end
                    21: begin
                              case(key_out[2:0])
                              3'b001:begin is_clr<= 0; is_chos_clr <= 1; end
                              3'b100:begin is_clr<= 2; is_chos_clr <= 1; end
                              endcase
                              if(is_chos_clr && is_clr == 2) begin
                                      a_clean <= 1;
                                      //a_pos <= 0;
                              end
                    end
                    22: begin
                             case(key_out[2:0])
                             3'b001:begin is_clr<= 0; is_chos_clr <= 1; end
                             3'b100:begin is_clr<= 2; is_chos_clr <= 1; end
                             endcase
                             if(is_chos_clr && is_clr == 2) begin
                                       b_clean <= 1;
                                       //b_pos <= 0;
                             end
                   end
            endcase
          end 
        end     
    end
endmodule