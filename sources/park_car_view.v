module park_car_view (
    input clk,
    input rst,
    input [2:0] view,
    input [4:0] bt,

    input [2:0] open_a,
    input [2:0] open_b,
    input [8:0] count,
    input [2:0] leave_car,

    output reg [2:0] left_a,
    output reg [2:0] left_b,
    output reg [5:0] a_pos,
    output reg [5:0] b_pos,

    output reg [8:0] a1_count,
    output reg [8:0] a2_count,
    output reg [8:0] a3_count,
    output reg [8:0] b1_count,
    output reg [8:0] b2_count,
    output reg [8:0] b3_count,

    output [7:0] seg_out,
    output [7:0] seg_en,

    input a_clean,
    input b_clean
);
    //reg pcv_rst;
    //reg pcv_set;

    //alert_player pcv_ap(clk, pcv_rst, pcv_set, buzzer);

    reg [3:0] state; //0初�? 1�? 2ab 3标识�?
    reg [2:0] num;

    always @(posedge clk) begin

        if (view == 1) begin

            if (open_a < left_a ) left_a <= open_a;
            if (open_b < left_b ) left_b <= open_b; //report

            if (a_clean) begin 
                left_a <= open_a;
                a_pos = 0;
            end
            if (b_clean) begin 
                left_b <= open_b;
                b_pos = 0;
            end
        end

        if(view != 2) begin
            state <= 0;
            // pcv_rst <= 1;
            // pcv_set <= 0;

            if (rst) begin
                left_a <= open_a;
                left_b <= open_b;
                a_pos <= 6'b0;
                b_pos <= 6'b0;

                a1_count <= 0;
                a2_count <= 0;
                a3_count <= 0;
                b1_count <= 0;
                b2_count <= 0;
                b3_count <= 0;
            end

            //车走
            case (leave_car)
                3'b001: begin
                    a1_count <= 0;
                    a_pos <= a_pos - 1; //11 10 01
                    left_a <= left_a + 1;
                end
                3'b010: begin
                    a2_count <= 0;
                    a_pos <= a_pos - 6'b00_10_00;
                    left_a <= left_a + 1;
                end
                3'b011: begin
                    a3_count <= 0;
                    a_pos <= a_pos - 6'b11_00_00; 
                    left_a <= left_a + 1;
                end

                3'b101: begin
                    b1_count <= 0;
                    b_pos <= b_pos - 1; 
                    left_b <= left_b + 1;
                end
                3'b110: begin
                    b2_count <= 0;
                    b_pos <= b_pos - 6'b00_10_00; 
                    left_b <= left_b + 1;
                end
                3'b111: begin
                    b3_count <= 0;
                    b_pos <= b_pos - 6'b11_00_00; 
                    left_b <= left_b + 1;
                end 
            endcase
        end
        
        else if (view == 2) begin
            if (state == 0 && left_a == 0 && left_b == 0) state <= 1; 
            else if (state == 0) state <= 2;
            else if (state == 2 && (bt[1] || bt[0])) begin
                //没车位直接哭
                if (bt[1] && left_a == 0 || bt[0] && left_b == 0) state <= 1;
                else begin

                    state <= 3;
                    if (bt[1]) begin
                        left_a <= left_a - 1;
                        casex (a_pos)
                            6'bxx_xx_00: begin
                                num <= 3'b001; //a02
                                a_pos <= a_pos + 1;
                                a1_count <= count;
                            end 
                            6'bxx_00_01: begin
                                num <= 3'b010; //a20
                                a_pos <= a_pos + 8;
                                a2_count <= count;
                            end 
                            6'b00_10_01: begin
                                num <= 3'b011; //a22
                                a_pos <= 6'b 11_10_01;
                                a3_count <= count;
                            end 
                        endcase
                    end

                    if (bt[0]) begin
                        left_b <= left_b - 1;
                         casex (b_pos)
                            6'bxx_xx_00: begin
                                num <= 3'b101; //b02
                                b_pos <= b_pos + 1;
                                b1_count <= count;
                            end 
                            6'bxx_00_01: begin
                                num <= 3'b110; //b20
                                b_pos <= b_pos + 8;
                                b2_count <= count;
                            end 
                            6'b00_10_01: begin
                                num <= 3'b111; //b22
                                b_pos <= 6'b 11_10_01;
                                b3_count <= count;
                            end 
                        endcase
                    end 
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

    parameter NULL = 8'b1111_1111;


    always @(posedge clk) begin

        seg0_num <= 5'd28; //u
        seg1_num <= 5'd21; //n 
        seg2_num <= left_a;  
        seg3_num <= left_b;  
        seg4_num <= 4'ha; //a 
        seg5_num <= 4'hb; //b 

        //1 -> 2
        if(num[1:1] == 1) seg6_num <= 4'h2;
        else seg6_num <= num[1:1];  
        if(num[0:0] == 1) seg7_num <= 4'h2;
        else seg7_num <= num[0:0];  

        if (view == 2) begin
            case (state)
                1:begin
                    // - n -
                    {i4,i5,i6}={seg0_out, seg1_out, seg0_out};
                    {i0,i1,i2,i3,i7}={5{NULL}};
                end
                2:begin
                    // a: b:
                    {i1,i2} = {seg4_out, seg2_out};
                    {i5,i6} = {seg5_out, seg3_out};
                    {i0,i3,i4,i7} = {4{NULL}};
                end
                3:begin
                    //标识�?
                    if (num[2:2] == 0) i3 = seg4_out; //a
                    if (num[2:2] == 1) i3 = seg5_out; //b
                    {i4,i5} = {seg6_out, seg7_out};
                    {i0,i1,i2,i6,i7} = {5{NULL}};
                end
            endcase
        end
    end

    
    
endmodule