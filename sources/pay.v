`timescale 1ns/1ps

module pay (
    input clk,
    input rst,
    input [2:0] view,
    output reg [4:0] state,
    input [23:0] sw,
    output reg led,
    //input [15:0] key_in,
    input [15:0] key_out,
    //input [4:0] bt,
    input [4:0] bt_out, 
    input [14:0] s,
    input [21:0] one,
    input [21:0] two,
    input [21:0] three,
    input [21:0] four,
    input [21:0] five,
    output reg [3:0] account,
    output reg [15:0] psword,
    output reg [2:0] cnt_psword,
    output reg [1:0] ps_error_time,
    output reg isM,
    input [2:0] num,
    output reg[2:0] the_car,//鏀粯鎴愬姛�?氳泲鐨勮�? 
    input [8:0] main_count,
    input [8:0] a1_count,
    input [8:0] a2_count,
    input [8:0] a3_count,
    input [8:0] b1_count,
    input [8:0] b2_count,
    input [8:0] b3_count,
    input [1:0] start_a,
    input [1:0] start_b,
    input [1:0] each_a,
    input [1:0] each_b,
    output reg [8:0] fee,
    output reg [8:0] ch4nge,
    output reg [8:0] fee_mem,
    input [3:0] discount,
    output reg [8:0] rest,
    output reg [8:0] change_mem,
    output reg [8:0] change_m2m,
    output reg [8:0] fee_r,
    output reg [8:0] count, //�??瑕佺粨绠楃殑count锛屼細闅忔�?闂村彉鍖栧�??
    output reg is_money_change,
    output reg [8:0] profit,
    input is_clean_profit,
    output reg [8:0]time_avg
);

reg [10:0] time_sum;
reg [5:0] cars_out;
wire left_bt, right_bt, mid_bt, up_bt;
assign left_bt = bt_out[1];
assign right_bt = bt_out[0];
assign mid_bt = bt_out[3];
assign up_bt = bt_out[2];
reg [8:0] prof1t;
reg ispressed;
reg isout;
reg ispay;
reg isMem = 1'b0;
reg isMemRight;
reg ismempay;
reg ispay2;
reg [8:0] pay1;
reg [8:0] pay2;
wire c100000k;
wire c50k;
reg [6:0] djs;
parameter daojishi = 60;
//涓�?潰浣跨敤鐨勫彉閲忥紝鏍�?嵁num鍒ゆ柇鍙朼鍖篵鍖哄摢涓�?
reg [1:0] start;
reg [1:0] each;
reg c4r;

//state = 14 show fail => gundong; state = 13 show done => gundong
always @(posedge clk) begin
    if(view != 4) state<=1;
    if(!left_bt && !right_bt && !mid_bt) begin
        ispressed = 0;
    end
     if(view == 4  && djs > daojishi) state <= 14;
     if(rst) begin
             state <= 1;
     end
    else begin
        if(view == 4) begin
            if (state==13) begin
                state<=15;
            end
            if (left_bt && !ispressed) begin
                ispressed = 1;
                if (state == 1) 
                    state <= 2;
                else if (state == 2)
                    state <= 1;
            end
            else if (right_bt && !ispressed) begin
                ispressed = 1;
                if (state == 1)
                    state <= 2;
                else if (state == 2)
                    state <= 1;
            end
            else if(mid_bt && !ispressed) begin
                ispressed = 1;
                case ({state})
                    1:begin if (ispay) begin
                        state <= 3;
                    end
                    else begin
                        state <= 4;
                    end
                    end
                    2:state <= 5;
                    3:state <= 13; //婊氬洖鍘?
                    4:state <= 1;
                    5:begin
                        if(~isMem && isM)
                            state <= 11;
                        else if(isMem && isM)
                            state <= 12;
                    end
                    6:begin if (ismempay) begin
                        state <= 7;
                    end
                    else begin
                        state <= 8;
                    end
                    end
                    7:state <= 13;
                    8:begin if (ispay2) begin
                        state <= 9;
                    end
                    else begin
                        state <= 10;
                    end
                    end
                    9:state <= 13;
                    10:state <= 8;
                    11:state <= 1;
                    12:begin
                        if(isMemRight)
                            state <= 6;
                        else state <= 11;
                    end
                    // 13: state <= 15;
                    14: state <= 15;
                endcase
            end
        end
    end
end

//鍒ゆ柇鍝釜杞﹁蛋浜?
always @(posedge clk) begin
if(cars_out!=0) time_avg<=time_sum/cars_out;
else if (cars_out==0) begin
    time_avg<=0;
end
if(view == 4) begin
   if (isout) the_car <= num;
   case (num)
        3'b001:begin
            count <= (main_count - a1_count)/2;
            start <= start_a;
            each = each_a;
        end 
        3'b010:begin
            count <= (main_count - a2_count)/2;
            start <= start_a;
            each = each_a;
        end
        3'b011:begin
            count <= (main_count - a3_count)/2;
            start <= start_a;
            each = each_a;
        end
        3'b101:begin
            count <= (main_count - b1_count)/2;
            start <= start_b;
            each = each_b;
        end
        3'b110:begin
            count <= (main_count - b2_count)/2;
            start <= start_b;
            each = each_b;
        end
        3'b111:begin
            count <= (main_count - b3_count)/2;
            start <= start_b;
            each = each_b;
        end
    endcase
end
else begin  the_car <= 0; end
end

always @(posedge clk) begin
    if(view == 1 && is_clean_profit)  profit<=0;
    if(rst) begin
        ispay <= 0;
        isMemRight <= 0;
        ismempay <= 0;
        ispay2 <= 0;
        pay1 <= 0;
        pay2 <= 0;
        isout <= 0;
        isMem <= 0;
        isM <= 0;
        psword <= 0;
        cnt_psword <= 0;
        ps_error_time <= 0;
        isMemRight <= 0;
        fee <= 0;
        ch4nge <= 0;
        fee_mem <= 0;
        rest <= 0;
        change_mem <= 0;
        fee_r <= 0;
        account <= 0;
        prof1t <= 0;
    end
    else if (view == 4 )begin
        case (state)
            1:begin
                account <= 0;
                isMemRight <= 0;
                ismempay <= 0;
                ispay2 <= 0;
                pay2 <= 0;
                isout <= 0;
                isMem <= 0;
                isM <= 0;
                psword <= 0;
                cnt_psword <= 0;
                ps_error_time <= 0;
                isMemRight <= 0;
                ch4nge <= 0;
                fee_mem <= 0;
                rest <= 0;
                change_mem <= 0;
                fee_r <= 0;
                fee <= start + (each * count);
                pay1 <= sw[10:2];
                prof1t <= 0;
                c4r<=0;
                if (pay1 >= fee) begin
                    ispay <= 1;
                end
                else begin
                    ispay <= 0;
                end
            end
            2: begin account <= 0;
                   isMem <= 0;
                    isM <= 0;
                    psword <= 0;
                    cnt_psword <= 0;
                    ps_error_time <= 0;
                    isMemRight <= 0;
            end
            3:begin
                ch4nge = pay1 - fee;
                prof1t <= fee;
                // isout <= 1;
            end
            5:begin
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
                    1:begin 
                        if(s[2:0] != 0) isMem <= 1;
                        else isMem <= 0;
                    end
                    2:begin
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
            6:begin
                fee_mem <= fee * discount / 10;
                case ({account})
                    1:rest <= one[5:0];
                    2:rest <= two[5:0];
                    3:rest <= three[5:0];
                    4:rest <= four[5:0];
                    5:rest <= five[5:0];
                endcase
                if (fee_mem > rest) begin
                    ismempay <= 0;
                end
                else begin
                    ismempay <= 1;
                end
            end
            7:begin
                change_mem <= rest - fee_mem;
                is_money_change <= 1;
                prof1t <= fee_mem;
//                case ({account})
//                    1:one[5:0] <= change_mem;
//                    2:two[5:0] <= change_mem;
//                    3:three[5:0] <= change_mem;
//                    4:four[5:0] <= change_mem;
//                    5:five[5:0] <= change_mem;
//                endcase
                // isout <= 1;
            end
            8:begin
                is_money_change <= 1;
                change_mem <= 0;
                fee_r <= fee_mem - rest;
                pay2 <= sw[10:2];
                if (pay2 < fee_r) begin
                    ispay2 <= 0;
                end
                else begin
                    ispay2 <= 1;
                end
            end
            9:begin
                change_m2m <= pay2 - fee_r;
               prof1t <= fee_mem;
                // isout <= 1;
            end
            11:begin
                isMem <= 0;
                isM <= 0;
            end
            12:begin
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
                else if(cnt_psword == 4) begin
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
            13:begin isout <= 1; account <= 0; is_money_change <= 0; change_mem <= 0; c4r<=1; end
            14:begin isout <= 0; account <= 0; is_money_change <= 0; change_mem <= 0; prof1t <= 0; c4r<=0; end
            15:begin time_sum <= time_sum + count; cars_out <= cars_out + c4r; profit <= profit + prof1t; isout <= 0;end
        endcase
    end
end

//鍊掕鏃?
divide_clk #(100_000) divclk1(clk, rst, c100000k);//1000_000
divide_clk #(100_0) divclk2(c100000k, rst, c50k);
//wire ms100;
//generate_bound ms100_edge(clk, c50k, ms100);
//reg [3:0] timer;

// always @(posedge clk) begin
//      if(rst) begin led <= 0;  djs <= 0; timer <= 0; end
//     else if(view == 4)begin
//       if( djs <= daojishi) begin
//            if(timer == 10) begin
//                   djs <= djs + 1;
//                   led <= ~led;
//                   timer <= 0;
//                   end
//            else begin
//                    timer <= timer  + 1;
//            end       
//       end
//       else begin  djs <= 0; led <= 0;  timer <= 0; end
//     end 
//     else begin
//           djs <= 0; 
//           led <= 0;
//           timer <= 0;
//     end
//   end

always @(posedge c50k) begin
    if(rst) begin led <= 0;  djs <= 0;  end
   else if(view == 4 && state != 13 && state != 14 && state != 15) begin
          led <= ~led;
    if (djs <= daojishi)
          djs <= djs + 1;
    end
    else if(view == 4 && state == 13) begin
                djs <= 0;
                led <= 0;
    end
    // else if( view != 4) begin
    //             djs <= 0;
    //             led <= 0;
    // end
    else if(view == 4 && state == 4) begin
                    djs <= 0;
    end
    else if(view == 4 && state == 14) begin
                     djs <= 0;
                     led <= 0;
    end
//    else if(view == 4 && state == 13) begin
//            djs <= 0;
//            led <= 0;
//    end
//    else if(state == 14 && view == 4) begin
//                djs <= 0;
//                led <= 0;
//        end
end
endmodule