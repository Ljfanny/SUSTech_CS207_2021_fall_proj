`timescale 1ns / 1ps
//会员模式是view = 2�?
module member_model(
    input clk,
    input rst,
    input [4:0] bt_out,
    input [2:0] view,
    output reg [14:0] s,
    output reg [21:0] one,
    output reg [21:0] two,
    output reg [21:0] three,
    output reg [21:0] four,
    output reg [21:0] five,
    output reg [3:0] account,
    output reg [15:0] psword,//会员登录输入的密�?
    output reg [2:0] cnt_psword,//会员登录输入的密码的位数
    output reg [1:0] ps_error_time, //会员登录输入的密码的错�?次数，超过三次返回账号输入界�?
    output reg [15:0] becomeMemPsword,//成为会员密码�?
    output reg [2:0] cnt_ch_psword,//成为会员记录输入密码位数�? 
    output reg [2:0] be_account,//分发的会员号�?
    output reg [1:0] select_op,//会员选择的操�?
    output reg isCancel, isChoosed,//�?��注销
    //刚注册的充钱！充钱数
    output reg [5:0] be_money, //总数
    output reg [1:0] cnt_be_money, //计数�?
    output reg [2:0] be_money_ten, //十位�?    
    output reg [3:0] be_money_one, //�?���?
    //会员重新充钱�?
    output reg [5:0] money, //总数
    output reg [1:0] cnt_money, //计数�?
    output reg [2:0] money_ten, //十位�?    
    output reg [3:0] money_one, //�?���?
    output reg [5:0] le_money, //退还的钱钱
    output reg [15:0] now_ps,
    output reg [2:0] cnt_ps,
//    output reg [3:0] music_play,
//    output reg [3:0]current,
    output reg [4:0] state,
    input [15:0] key_out,
    output reg isM,
    input is_money_change,
    input [5:0] change_pay,
    input [3:0] account_pay
    );
    //左右�?��以切换注册还�?��录，�?��进入�?
    wire left_bt, right_bt, mid_bt, up_bt,down_bt;
    assign left_bt = bt_out[1];
    assign right_bt = bt_out[0];
    assign mid_bt = bt_out[3];
    assign up_bt = bt_out[2];
    assign down_bt = bt_out[4];
    reg ispressed;
    //�?��有账�?
    reg isPer = 1'b0;
    //�?���?���?,以及�?��输入过；
    reg isMem = 1'b0;
    //密码输入�?��正确
    reg isMemRight;
    //选择�?��成为会员,以及�?��输入�?
    reg isBecomeMem;
    reg isBecomeInput;
    //�?��分配成功
    reg isCanBeMem;
    
    always @(posedge clk) begin
        if(!left_bt && !right_bt && !mid_bt)begin 
              ispressed = 0;
            end
        if(view != 5) state <= 1;    
        if(rst && view == 5) begin
            state <= 1;
//            s = 20'b000_000_101_000_011_010_001;
//            two = 21'b0010_0010_0010_0010_000111;
        end 
        else
        begin
            if(view == 5) 
            begin
                if (left_bt && !ispressed) begin
                    ispressed = 1;
                    if(state == 1)
                        state <= 2;
                    else if(state == 2)
                        state <= 1;
                end
                else if (right_bt && !ispressed) begin
                    ispressed = 1;
                    if(state == 2)
                        state <= 1;
                    else if(state == 1)
                        state <= 2;
                end
                else if(mid_bt && !ispressed) begin
                    ispressed = 1;
                    case({state})
                    1: state <= 3;
                    2: state <= 4;
                    3: begin
                            if(~isMem && isM)
                                            state <= 5;
                            else if(isMem && isM)
                                            state <= 6;
                    end
                    4: begin
                            if(isBecomeInput) begin
                                    if(~isBecomeMem)
                                            state <= 1;
                                     else state <= 7; 
                            end
                    end
                    5: state <= 1;
                    6: begin
                            if(isMemRight)
                                       state <= 9;
                            else begin
                                    if(ps_error_time <= 3 && ps_error_time >= 0)
                                            state <= 11;
                            end
                    end
                    7: begin
                            if(isCanBeMem) state <= 8;
                            else state <= 18;
                    end
                    8: begin
                    if(cnt_ch_psword == 4)  state <= 10;
                    end
                    9: begin
                            case({select_op})
                            1: state <= 14;
                            2: state <= 15;
                            3: state <= 16;
                            endcase
                    end
                    10: state <=12;
                    11: state <= 6;
                    12: begin
                            if(cnt_be_money == 2) state <= 13;
                    end
                    13: state <= 1;
                    14: begin
                            if(isChoosed) begin
                                    if(~isCancel) state <= 9;
                                    else state <= 21;
                            end
                    end
                    15:begin
                    if(cnt_money == 2)  state <= 19;
                    end
                    16: begin
                    if(cnt_ps == 4)  state <= 17; 
                    end
                    17: state <= 9;
                    18: state <= 1;
                    19: state <= 9; //显示充值成功，并返回状�?9
                    21: state <= 1;
                    endcase 
                end
                else if(up_bt && !ispressed) begin
                    ispressed = 1;
                    if(state == 3 || state == 4)
                         state <= 1;
                    else if(state == 9)
                         state <= 1;
                end
                else if(down_bt && !ispressed) begin
                        ispressed = 1;
                        //滚动显示�?��员账号和余�?
                        if(state == 9)
                                state <= 20;
                        else if (state == 20)
                                state <= 9;
                end
            end
        end
    end
    
    always @(posedge clk) begin
        if(rst) begin
            //3
            isMem <= 0;
            isM <= 0;
            //4
            isBecomeMem <= 0;
            isBecomeInput <= 0; 
            //6
            psword <= 0;
            cnt_psword <= 0;
            ps_error_time <= 0;
            isMemRight <= 0;
            //9
            select_op <= 0;
            //8
            becomeMemPsword <= 0;
            cnt_ch_psword <= 0;
            //7
            isCanBeMem <= 0;
            //14
            isCancel <= 0;
            isChoosed <= 0;
            //15
            money <= 0;
            cnt_money <= 0;
            money_ten <= 0;
            money_one <= 0;
            le_money <= 0;
            //16
            now_ps <= 0;
            cnt_ps <= 0;
            //12
            be_money <= 0;
            cnt_be_money <= 0;
            be_money_ten <= 0; 
            be_money_one <= 0;
        end
        else if (view == 5)begin
            if (state == 9) begin
                psword <= 0;
//                select_op <= 0;
                isCancel <= 0;
                isChoosed <= 0;
                cnt_psword <= 0;
                isMemRight <= 0;
                money <= 0;
                cnt_money <= 0;
                money_ten <= 0;
                money_one <= 0;
                now_ps <= 0;
                cnt_ps <= 0;
                cnt_ch_psword <= 0;
                ps_error_time <= 0;
                psword <= 0;
                cnt_psword <= 0;                
            end
            case({state})
            1:begin
                       isMem <= 0;
                       isM <= 0;
                       isBecomeMem <= 0;
                       isBecomeInput <= 0; 
                       psword <= 0;
                       cnt_psword <= 0;
                       ps_error_time <= 0;
                       isMemRight <= 0;
                       select_op <= 0;
                       becomeMemPsword <= 0;
                       cnt_ch_psword <= 0;
                       isCanBeMem <= 0;
                       isCancel <= 0;
                       isChoosed <= 0;
                       money <= 0;
                       cnt_money <= 0;
                       money_ten <= 0;
                       money_one <= 0;
                       now_ps <= 0;
                       cnt_ps <= 0;
                       be_money <= 0;
                       cnt_be_money <= 0;
                       be_money_ten <= 0; 
                       be_money_one <= 0;
            end
            3:                    
            begin
                if(~isM)begin    
                    case(key_out[5:1])
                    5'b0_0001:begin account <= 1; isM <= 1;end
                    5'b0_0010:begin account <= 2; isM <= 1;end
                    5'b0_0100:begin account <= 3; isM <= 1;end
                    5'b0_1000:begin account <= 4; isM <= 1;end
                    5'b1_0000:begin account <= 5; isM <= 1;end
                    endcase
                end
                else begin
                case({account})
                1: begin 
                if(s[2:0] != 0) isMem <= 1;
                else isMem <= 0;
                end
                2: begin
                if(s[5:3] != 0) isMem <= 1;
                else isMem <= 0;
                end
                3:begin
                if(s[8:6] != 0) isMem <= 1;
                else isMem <= 0;
                end
                4:begin
                if(s[11:9] != 0) isMem <= 1;
                else isMem <= 0;
                end
                5:begin
                if(s[14:12] != 0) isMem <= 1;
                else isMem <= 0;
                end
              endcase
             end
            end   
            4: begin
                case(key_out[2:0])
                3'b001:begin isBecomeMem <= 0; isBecomeInput <= 1; end
                3'b100:begin isBecomeMem <= 1; isBecomeInput <= 1; end 
                endcase
            end
            5:begin
                isMem <= 0;
                isM <= 0;
            end
            6:begin
                isMem <= 0;
                isM <= 0;                
                if(cnt_psword == 0) begin
                case(key_out[12:1])
                     12'b000_000_000_001:begin psword[15:12] <= 1; cnt_psword = cnt_psword + 1; end
                     12'b000_000_000_010:begin psword[15:12] <= 2; cnt_psword = cnt_psword + 1; end
                     12'b000_000_000_100:begin psword[15:12] <= 3; cnt_psword = cnt_psword + 1; end
                     12'b000_000_001_000:begin psword[15:12] <= 4; cnt_psword = cnt_psword + 1; end
                     12'b000_000_010_000:begin psword[15:12] <= 5; cnt_psword = cnt_psword + 1; end
                     12'b000_000_100_000:begin psword[15:12] <= 6; cnt_psword = cnt_psword + 1; end
                     12'b000_001_000_000:begin psword[15:12] <= 7; cnt_psword = cnt_psword + 1; end
                     12'b000_010_000_000:begin psword[15:12] <= 8; cnt_psword = cnt_psword + 1; end
                     12'b000_100_000_000:begin psword[15:12] <= 9; cnt_psword = cnt_psword + 1; end
                     12'b001_000_000_000:begin psword[15:12] <= 4'ha; cnt_psword = cnt_psword + 1; end
                     12'b010_000_000_000:begin psword[15:12] <= 4'hb; cnt_psword = cnt_psword + 1; end
                     12'b100_000_000_000:begin psword[15:12] <= 4'hc; cnt_psword = cnt_psword + 1; end
                 endcase             
                 end
                 else if(cnt_psword == 1) begin
                 case(key_out[12:1])
                     12'b000_000_000_001:begin psword[11:8] <= 1; cnt_psword = cnt_psword + 1; end
                     12'b000_000_000_010:begin psword[11:8] <= 2; cnt_psword = cnt_psword + 1; end
                     12'b000_000_000_100:begin psword[11:8] <= 3; cnt_psword = cnt_psword + 1; end
                     12'b000_000_001_000:begin psword[11:8] <= 4; cnt_psword = cnt_psword + 1; end
                     12'b000_000_010_000:begin psword[11:8] <= 5; cnt_psword = cnt_psword + 1; end
                     12'b000_000_100_000:begin psword[11:8] <= 6; cnt_psword = cnt_psword + 1; end
                     12'b000_001_000_000:begin psword[11:8] <= 7; cnt_psword = cnt_psword + 1; end
                     12'b000_010_000_000:begin psword[11:8] <= 8; cnt_psword = cnt_psword + 1; end
                     12'b000_100_000_000:begin psword[11:8] <= 9; cnt_psword = cnt_psword + 1; end
                     12'b001_000_000_000:begin psword[11:8] <= 4'ha; cnt_psword = cnt_psword + 1; end
                     12'b010_000_000_000:begin psword[11:8] <= 4'hb; cnt_psword = cnt_psword + 1; end
                     12'b100_000_000_000:begin psword[11:8] <= 4'hc; cnt_psword = cnt_psword + 1; end
                 endcase             
                 end
                 else if(cnt_psword == 2) begin
                 case(key_out[12:1])
                     12'b000_000_000_001:begin psword[7:4] <= 1; cnt_psword = cnt_psword + 1; end
                     12'b000_000_000_010:begin psword[7:4] <= 2; cnt_psword = cnt_psword + 1; end
                     12'b000_000_000_100:begin psword[7:4] <= 3; cnt_psword = cnt_psword + 1; end
                     12'b000_000_001_000:begin psword[7:4] <= 4; cnt_psword = cnt_psword + 1; end
                     12'b000_000_010_000:begin psword[7:4] <= 5; cnt_psword = cnt_psword + 1; end
                     12'b000_000_100_000:begin psword[7:4] <= 6; cnt_psword = cnt_psword + 1; end
                     12'b000_001_000_000:begin psword[7:4] <= 7; cnt_psword = cnt_psword + 1; end
                     12'b000_010_000_000:begin psword[7:4] <= 8; cnt_psword = cnt_psword + 1; end
                     12'b000_100_000_000:begin psword[7:4] <= 9; cnt_psword = cnt_psword + 1; end
                     12'b001_000_000_000:begin psword[7:4] <= 4'ha; cnt_psword = cnt_psword + 1; end
                     12'b010_000_000_000:begin psword[7:4] <= 4'hb; cnt_psword = cnt_psword + 1; end
                     12'b100_000_000_000:begin psword[7:4] <= 4'hc; cnt_psword = cnt_psword + 1; end
                 endcase             
                 end
                 else if(cnt_psword == 3) begin
                 case(key_out[12:1])
                     12'b000_000_000_001:begin psword[3:0] <= 1; cnt_psword = cnt_psword + 1; end
                     12'b000_000_000_010:begin psword[3:0] <= 2; cnt_psword = cnt_psword + 1; end
                     12'b000_000_000_100:begin psword[3:0] <= 3; cnt_psword = cnt_psword + 1; end
                     12'b000_000_001_000:begin psword[3:0] <= 4; cnt_psword = cnt_psword + 1; end
                     12'b000_000_010_000:begin psword[3:0] <= 5; cnt_psword = cnt_psword + 1; end
                     12'b000_000_100_000:begin psword[3:0] <= 6; cnt_psword = cnt_psword + 1; end
                     12'b000_001_000_000:begin psword[3:0] <= 7; cnt_psword = cnt_psword + 1; end
                     12'b000_010_000_000:begin psword[3:0] <= 8; cnt_psword = cnt_psword + 1; end
                     12'b000_100_000_000:begin psword[3:0] <= 9; cnt_psword = cnt_psword + 1; end
                     12'b001_000_000_000:begin psword[3:0] <= 4'ha; cnt_psword = cnt_psword + 1; end
                     12'b010_000_000_000:begin psword[3:0] <= 4'hb; cnt_psword = cnt_psword + 1; end
                     12'b100_000_000_000:begin psword[3:0] <= 4'hc; cnt_psword = cnt_psword + 1; end
                 endcase             
                 end                                    
                 else if(cnt_psword == 4)begin
                     if(account == 1 && psword == one[21:6])
                        isMemRight <= 1'b1;
                     else if(account == 2 && psword == two[21:6])
                        isMemRight <= 1'b1;
                     else if(account == 3 && psword == three[21:6])
                        isMemRight <= 1'b1;
                     else if(account == 4 && psword == four[21:6])
                        isMemRight <= 1'b1;
                     else if(account == 5 && psword == five[21:6])
                        isMemRight <= 1'b1;
                     else begin
                            if(ps_error_time == 0 || ps_error_time == 1 || ps_error_time == 2)
                                      ps_error_time <= ps_error_time + 1;
                    end                                                                                                                      
                end
            end
            7:begin
                if(s[2:0] == 3'b000)       begin be_account <= 1; isCanBeMem <= 1;end
                else if(s[5:3] == 3'b000)  begin be_account <= 2; isCanBeMem <= 1;end
                else if(s[8:6] == 3'b000)  begin be_account <= 3; isCanBeMem <= 1;end
                else if(s[11:9] == 3'b000) begin be_account <= 4; isCanBeMem <= 1;end
                else if(s[14:12] == 3'b000)begin be_account <= 5; isCanBeMem <= 1;end
                else isCanBeMem <= 0;
            end
            8:begin
             case({be_account})
                     1: s[2:0] <= 3'b001;  
                     2: s[5:3] <= 3'b010;  
                     3: s[8:6] <= 3'b011;  
                     4: s[11:9] <= 3'b100; 
                     5: s[14:12] <= 3'b101;
             endcase
              if(cnt_ch_psword == 0)
              begin
              case(key_out[12:1])
              12'b000_000_000_001:begin becomeMemPsword[15:12] <= 1; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_000_010:begin becomeMemPsword[15:12] <= 2; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_000_100:begin becomeMemPsword[15:12] <= 3; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_001_000:begin becomeMemPsword[15:12] <= 4; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_010_000:begin becomeMemPsword[15:12] <= 5; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_100_000:begin becomeMemPsword[15:12] <= 6; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_001_000_000:begin becomeMemPsword[15:12] <= 7; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_010_000_000:begin becomeMemPsword[15:12] <= 8; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_100_000_000:begin becomeMemPsword[15:12] <= 9; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b001_000_000_000:begin becomeMemPsword[15:12] <= 4'ha; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b010_000_000_000:begin becomeMemPsword[15:12] <= 4'hb; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b100_000_000_000:begin becomeMemPsword[15:12] <= 4'hc; cnt_ch_psword = cnt_ch_psword + 1; end
              endcase
              end
              else if(cnt_ch_psword == 1) begin
              case(key_out[12:1])
              12'b000_000_000_001:begin becomeMemPsword[11:8] <= 1; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_000_010:begin becomeMemPsword[11:8] <= 2; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_000_100:begin becomeMemPsword[11:8] <= 3; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_001_000:begin becomeMemPsword[11:8] <= 4; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_010_000:begin becomeMemPsword[11:8] <= 5; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_100_000:begin becomeMemPsword[11:8] <= 6; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_001_000_000:begin becomeMemPsword[11:8] <= 7; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_010_000_000:begin becomeMemPsword[11:8] <= 8; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_100_000_000:begin becomeMemPsword[11:8] <= 9; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b001_000_000_000:begin becomeMemPsword[11:8] <= 4'ha; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b010_000_000_000:begin becomeMemPsword[11:8] <= 4'hb; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b100_000_000_000:begin becomeMemPsword[11:8] <= 4'hc; cnt_ch_psword = cnt_ch_psword + 1; end
              endcase              
              end
              else if(cnt_ch_psword == 2) begin
              case(key_out[12:1])
              12'b000_000_000_001:begin becomeMemPsword[7:4] <= 1; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_000_010:begin becomeMemPsword[7:4] <= 2; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_000_100:begin becomeMemPsword[7:4] <= 3; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_001_000:begin becomeMemPsword[7:4] <= 4; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_010_000:begin becomeMemPsword[7:4] <= 5; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_100_000:begin becomeMemPsword[7:4] <= 6; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_001_000_000:begin becomeMemPsword[7:4] <= 7; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_010_000_000:begin becomeMemPsword[7:4] <= 8; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_100_000_000:begin becomeMemPsword[7:4] <= 9; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b001_000_000_000:begin becomeMemPsword[7:4] <= 4'ha; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b010_000_000_000:begin becomeMemPsword[7:4] <= 4'hb; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b100_000_000_000:begin becomeMemPsword[7:4] <= 4'hc; cnt_ch_psword = cnt_ch_psword + 1; end
              endcase              
              end
              else if(cnt_ch_psword == 3) begin
              case(key_out[12:1])
              12'b000_000_000_001:begin becomeMemPsword[3:0] <= 1; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_000_010:begin becomeMemPsword[3:0] <= 2; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_000_100:begin becomeMemPsword[3:0] <= 3; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_001_000:begin becomeMemPsword[3:0] <= 4; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_010_000:begin becomeMemPsword[3:0] <= 5; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_000_100_000:begin becomeMemPsword[3:0] <= 6; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_001_000_000:begin becomeMemPsword[3:0] <= 7; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_010_000_000:begin becomeMemPsword[3:0] <= 8; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b000_100_000_000:begin becomeMemPsword[3:0] <= 9; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b001_000_000_000:begin becomeMemPsword[3:0] <= 4'ha; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b010_000_000_000:begin becomeMemPsword[3:0] <= 4'hb; cnt_ch_psword = cnt_ch_psword + 1; end
              12'b100_000_000_000:begin becomeMemPsword[3:0] <= 4'hc; cnt_ch_psword = cnt_ch_psword + 1; end
              endcase              
              end
              else begin
              case(be_account)                                                              
              1:  one[21:6] <= becomeMemPsword;                   
              2:  two[21:6] <= becomeMemPsword;                   
              3:  three[21:6]<= becomeMemPsword;                 
              4:  four[21:6]<= becomeMemPsword;                  
              5:  five[21:6] <= becomeMemPsword;              
              endcase                                                                       
              end
              end
            9:begin
                case(key_out[10:2])
                    9'b0_000_000_01:begin select_op <= 1;end //14
                    9'b0_000_000_10:begin select_op <= 2;end //15
                    9'b1_000_000_00:begin select_op <= 3;end //16
                endcase
                case({account})
                1: money <= one[5:0];
                2: money <= two[5:0];
                3: money <= three[5:0];
                4: money <= four[5:0];
                5: money <= five[5:0];
                endcase 
            end
            11:begin
                psword <= 0;
                cnt_psword <= 0;
            end
            12:begin
              if(cnt_be_money == 0)
              begin
              case(key_out[5:0])
              6'b00_0001:begin be_money_ten <= 0; cnt_be_money = cnt_be_money + 1; end
              6'b00_0010:begin be_money_ten <= 1; cnt_be_money = cnt_be_money + 1; end
              6'b00_0100:begin be_money_ten <= 2; cnt_be_money = cnt_be_money + 1; end
              6'b00_1000:begin be_money_ten <= 3; cnt_be_money = cnt_be_money + 1; end
              6'b01_0000:begin be_money_ten <= 4; cnt_be_money = cnt_be_money + 1; end
              6'b10_0000:begin be_money_ten <= 5; cnt_be_money = cnt_be_money + 1; end
              endcase
              end
              else if(cnt_be_money == 1) begin
              case(key_out[9:0])
              10'b000_000_0001:begin be_money_one <= 0; cnt_be_money = cnt_be_money + 1; end
              10'b000_000_0010:begin be_money_one <= 1; cnt_be_money = cnt_be_money + 1; end
              10'b000_000_0100:begin be_money_one <= 2; cnt_be_money = cnt_be_money + 1; end
              10'b000_000_1000:begin be_money_one <= 3; cnt_be_money = cnt_be_money + 1; end
              10'b000_001_0000:begin be_money_one <= 4; cnt_be_money = cnt_be_money + 1; end
              10'b000_010_0000:begin be_money_one <= 5; cnt_be_money = cnt_be_money + 1; end
              10'b000_100_0000:begin be_money_one <= 6; cnt_be_money = cnt_be_money + 1; end
              10'b001_000_0000:begin be_money_one <= 7; cnt_be_money = cnt_be_money + 1; end
              10'b010_000_0000:begin be_money_one <= 8; cnt_be_money = cnt_be_money + 1; end
              10'b100_000_0000:begin be_money_one <= 9; cnt_be_money = cnt_be_money + 1; end
              endcase              
              end
              else begin
              case(be_account)
              1: one[5:0] <=  be_money_ten*10 +  be_money_one; 
              2: two[5:0] <=be_money_ten*10 +  be_money_one; 
              3: three[5:0] <= be_money_ten*10 +  be_money_one; 
              4: four[5:0] <= be_money_ten*10 +  be_money_one;
              5: five[5:0] <= be_money_ten*10 +  be_money_one;
              endcase
            end   
            end
            14:begin
                if(~isChoosed)
                begin
                case(key_out[2:0])
                3'b001:begin isChoosed <= 1; isCancel <= 0; end
                3'b100:begin 
                isChoosed <= 1; isCancel <= 1; 
                case(account)
                1:begin s[2:0]   <= 3'b000; one    [21:0] <= 0;     end
                2:begin s[5:3]   <= 3'b000; two    [21:0] <= 0;     end
                3:begin s[8:6]   <= 3'b000; three [21:0] <= 0;   end
                4:begin s[11:9]  <= 3'b000; four  [21:0] <= 0;     end
                5:begin s[14:12] <= 3'b000; five [21:0] <= 0;   end
                endcase
                end
                endcase
                end
            end
            15:begin
                if(cnt_money == 0)
                begin
                case(key_out[5:0])
                6'b00_0001:begin money_ten <= 0; cnt_money = cnt_money + 1; end
                6'b00_0010:begin money_ten <= 1; cnt_money = cnt_money + 1; end
                6'b00_0100:begin money_ten <= 2; cnt_money = cnt_money + 1; end
                6'b00_1000:begin money_ten <= 3; cnt_money = cnt_money + 1; end
                6'b01_0000:begin money_ten <= 4; cnt_money = cnt_money + 1; end
                6'b10_0000:begin money_ten <= 5; cnt_money = cnt_money + 1; end
                endcase
                end
                else if(cnt_money == 1) begin
                case(key_out[9:0])
                10'b000_000_0001:begin money_one <= 0; cnt_money = cnt_money + 1; end
                10'b000_000_0010:begin money_one <= 1; cnt_money = cnt_money + 1; end
                10'b000_000_0100:begin money_one <= 2; cnt_money = cnt_money + 1; end
                10'b000_000_1000:begin money_one <= 3; cnt_money = cnt_money + 1; end
                10'b000_001_0000:begin money_one <= 4; cnt_money = cnt_money + 1; end
                10'b000_010_0000:begin money_one <= 5; cnt_money = cnt_money + 1; end
                10'b000_100_0000:begin money_one <= 6; cnt_money = cnt_money + 1; end
                10'b001_000_0000:begin money_one <= 7; cnt_money = cnt_money + 1; end
                10'b010_000_0000:begin money_one <= 8; cnt_money = cnt_money + 1; end
                10'b100_000_0000:begin money_one <= 9; cnt_money = cnt_money + 1; end
                endcase
                end
                else begin
                          case(account)
                          1:begin
                          if(money + money_ten * 10 + money_one <= 50) begin 
                          one[5:0]  <= money + money_ten * 10 + money_one;
                          le_money <= 0;
                          end
                          else begin
                              le_money <= money_ten * 10 + money_one - (50 - money);
                              one[5:0] <= 6'd50;
                          end
                          end
                          2:begin 
                         if(money + money_ten * 10 + money_one <= 50) begin 
                         two[5:0]  <= money + money_ten * 10 + money_one;
                         le_money <= 5'd0;
                         end
                         else begin
                             le_money <= money_ten * 10 + money_one - (50 - money);
                             two[5:0] <= 6'd50;
                         end
                          end
                          3:begin 
                           if(money + money_ten * 10 + money_one <= 50) begin 
                           three[5:0]  <= money + money_ten * 10 + money_one;
                           le_money <= 5'd0;
                           end
                           else begin
                               le_money <= money_ten * 10 + money_one - (50 - money);
                              three[5:0] <= 6'd50;
                           end
                          end
                          4:begin 
                            if(money + money_ten * 10 + money_one <= 50) begin 
                            four[5:0]  <= money + money_ten * 10 + money_one;
                            le_money <= 5'd0;
                            end
                            else begin
                                le_money <= money_ten * 10 + money_one - (50 - money);
                               four[5:0] <= 6'd50;
                            end
                           end
                          5:begin 
                           if(money + money_ten * 10 + money_one <= 50) begin 
                           five[5:0]  <= money + money_ten * 10 + money_one;
                           le_money <= 5'd0;
                           end
                           else begin
                               le_money <= money_ten * 10 + money_one - (50 - money);
                              five[5:0] <= 6'd50;
                           end
                          end
                          endcase
                        end              
                end 
            16:begin
                if(cnt_ps == 0)
                begin
                case(key_out[12:1])
                12'b000_000_000_001:begin now_ps[15:12] <= 1; cnt_ps = cnt_ps + 1; end
                12'b000_000_000_010:begin now_ps[15:12] <= 2; cnt_ps = cnt_ps + 1; end
                12'b000_000_000_100:begin now_ps[15:12] <= 3; cnt_ps = cnt_ps + 1; end
                12'b000_000_001_000:begin now_ps[15:12] <= 4; cnt_ps = cnt_ps + 1; end
                12'b000_000_010_000:begin now_ps[15:12] <= 5; cnt_ps = cnt_ps + 1; end
                12'b000_000_100_000:begin now_ps[15:12] <= 6; cnt_ps = cnt_ps + 1; end
                12'b000_001_000_000:begin now_ps[15:12] <= 7; cnt_ps = cnt_ps + 1; end
                12'b000_010_000_000:begin now_ps[15:12] <= 8; cnt_ps = cnt_ps + 1; end
                12'b000_100_000_000:begin now_ps[15:12] <= 9; cnt_ps = cnt_ps + 1; end
                12'b001_000_000_000:begin now_ps[15:12] <= 4'ha; cnt_ps = cnt_ps + 1; end
                12'b010_000_000_000:begin now_ps[15:12] <= 4'hb; cnt_ps = cnt_ps + 1; end
                12'b100_000_000_000:begin now_ps[15:12] <= 4'hc; cnt_ps = cnt_ps + 1; end
                endcase                         
                end
                else if(cnt_ps == 1)
                begin
                case(key_out[12:1])
                12'b000_000_000_001:begin now_ps[11:8] <= 1; cnt_ps = cnt_ps + 1; end
                12'b000_000_000_010:begin now_ps[11:8] <= 2; cnt_ps = cnt_ps + 1; end
                12'b000_000_000_100:begin now_ps[11:8] <= 3; cnt_ps = cnt_ps + 1; end
                12'b000_000_001_000:begin now_ps[11:8] <= 4; cnt_ps = cnt_ps + 1; end
                12'b000_000_010_000:begin now_ps[11:8] <= 5; cnt_ps = cnt_ps + 1; end
                12'b000_000_100_000:begin now_ps[11:8] <= 6; cnt_ps = cnt_ps + 1; end
                12'b000_001_000_000:begin now_ps[11:8] <= 7; cnt_ps = cnt_ps + 1; end
                12'b000_010_000_000:begin now_ps[11:8] <= 8; cnt_ps = cnt_ps + 1; end
                12'b000_100_000_000:begin now_ps[11:8] <= 9; cnt_ps = cnt_ps + 1; end
                12'b001_000_000_000:begin now_ps[11:8] <= 4'ha; cnt_ps = cnt_ps + 1; end
                12'b010_000_000_000:begin now_ps[11:8] <= 4'hb; cnt_ps = cnt_ps + 1; end
                12'b100_000_000_000:begin now_ps[11:8] <= 4'hc; cnt_ps = cnt_ps + 1; end
                endcase                         
                end
                else if(cnt_ps == 2)
                begin
                case(key_out[12:1])
                12'b000_000_000_001:begin now_ps[7:4] <= 1; cnt_ps = cnt_ps + 1; end
                12'b000_000_000_010:begin now_ps[7:4] <= 2; cnt_ps = cnt_ps + 1; end
                12'b000_000_000_100:begin now_ps[7:4] <= 3; cnt_ps = cnt_ps + 1; end
                12'b000_000_001_000:begin now_ps[7:4] <= 4; cnt_ps = cnt_ps + 1; end
                12'b000_000_010_000:begin now_ps[7:4] <= 5; cnt_ps = cnt_ps + 1; end
                12'b000_000_100_000:begin now_ps[7:4] <= 6; cnt_ps = cnt_ps + 1; end
                12'b000_001_000_000:begin now_ps[7:4] <= 7; cnt_ps = cnt_ps + 1; end
                12'b000_010_000_000:begin now_ps[7:4] <= 8; cnt_ps = cnt_ps + 1; end
                12'b000_100_000_000:begin now_ps[7:4] <= 9; cnt_ps = cnt_ps + 1; end
                12'b001_000_000_000:begin now_ps[7:4] <= 4'ha; cnt_ps = cnt_ps + 1; end
                12'b010_000_000_000:begin now_ps[7:4] <= 4'hb; cnt_ps = cnt_ps + 1; end
                12'b100_000_000_000:begin now_ps[7:4] <= 4'hc; cnt_ps = cnt_ps + 1; end
                endcase                         
                end 
                else if(cnt_ps == 3)
                begin
                case(key_out[12:1])
                12'b000_000_000_001:begin now_ps[3:0] <= 1; cnt_ps = cnt_ps + 1; end
                12'b000_000_000_010:begin now_ps[3:0] <= 2; cnt_ps = cnt_ps + 1; end
                12'b000_000_000_100:begin now_ps[3:0] <= 3; cnt_ps = cnt_ps + 1; end
                12'b000_000_001_000:begin now_ps[3:0] <= 4; cnt_ps = cnt_ps + 1; end
                12'b000_000_010_000:begin now_ps[3:0] <= 5; cnt_ps = cnt_ps + 1; end
                12'b000_000_100_000:begin now_ps[3:0] <= 6; cnt_ps = cnt_ps + 1; end
                12'b000_001_000_000:begin now_ps[3:0] <= 7; cnt_ps = cnt_ps + 1; end
                12'b000_010_000_000:begin now_ps[3:0] <= 8; cnt_ps = cnt_ps + 1; end
                12'b000_100_000_000:begin now_ps[3:0] <= 9; cnt_ps = cnt_ps + 1; end
                12'b001_000_000_000:begin now_ps[3:0] <= 4'ha; cnt_ps = cnt_ps + 1; end
                12'b010_000_000_000:begin now_ps[3:0] <= 4'hb; cnt_ps = cnt_ps + 1; end
                12'b100_000_000_000:begin now_ps[3:0] <= 4'hc; cnt_ps = cnt_ps + 1; end
                endcase                        
                end
                else begin
                  case(account)
                           1:begin one[9:6] <= now_ps[3:0]; one[13:10] <= now_ps[7:4];
                                   one[17:14] <= now_ps[11:8]; one[21:18] <= now_ps[15:12]; end
                           2:begin two[9:6] <= now_ps[3:0]; two[13:10] <= now_ps[7:4];
                                   two[17:14] <= now_ps[11:8]; two[21:18] <= now_ps[15:12]; end
                           3:begin three[9:6] <= now_ps[3:0]; three[13:10] <= now_ps[7:4];
                                   three[17:14] <= now_ps[11:8]; three[21:18] <= now_ps[15:12]; end
                           4:begin four[9:6] <= now_ps[3:0]; four[13:10] <= now_ps[7:4];
                                   four[17:14] <= now_ps[11:8]; four[21:18] <= now_ps[15:12]; end
                           5:begin five[9:6] <= now_ps[3:0]; five[13:10] <= now_ps[7:4];
                                   five[17:14] <= now_ps[11:8]; five[21:18] <= now_ps[15:12]; end
                            endcase
                 end 
              end
            endcase
          end
          else if(view == 4) begin
                    if(is_money_change) begin
                            case(account_pay)
                            1: one[5:0] <= change_pay;
                            2: two[5:0] <= change_pay;
                            3: three[5:0] <= change_pay;
                            4: four[5:0] <= change_pay;
                            5: five[5:0] <= change_pay;
                            endcase
                    end
          end 
        end     
endmodule
