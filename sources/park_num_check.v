module park_num_check (
    input rst,
    input clk,
    input[15:0] key,
    input [4:0] bt,

    input [2:0] view,
    input [5:0] a_pos,
    input [5:0] b_pos,
    
    //output reg clock

    output reg num_correct,
    output reg [2:0] num,
    output [7:0] seg_out,
    output [7:0] seg_en
);

    reg [2:0] state; // 1输入 2�?�� 3临时
    wire mid_bt;
    assign mid_bt = bt[3];

    reg [11:0] input_num; // 4 4 4
    reg [2:0] input_cnt; 

    //reg flag; //判断标识�? 
    
    always @(posedge clk) begin
        if (view == 0 || view == 1 || view == 2) begin
            num_correct <= 0;
        end

        if (view != 3) begin
            state <= 1;
            input_cnt <= 0;
            input_num <= 0;
        end 

        if (view == 3) begin
            case (state) 
            1 : begin
                if (input_cnt == 0) begin
                    case (key[11:10])
                    2'b01: begin input_num[11:8] <= 4'ha; input_cnt = input_cnt + 1; end
                    2'b10: begin input_num[11:8] <= 4'hb; input_cnt = input_cnt + 1; end
                    endcase
                end
                
                else if (input_cnt == 1) begin
                    case (key[9:0])
                    10'b00_0000_0001: begin input_num[7:4] <= 4'h0; input_cnt = input_cnt + 1; end
                    10'b00_0000_0010: begin input_num[7:4] <= 4'h1; input_cnt = input_cnt + 1; end
                    10'b00_0000_0100: begin input_num[7:4] <= 4'h2; input_cnt = input_cnt + 1; end
                    10'b00_0000_1000: begin input_num[7:4] <= 4'h3; input_cnt = input_cnt + 1; end
                    10'b00_0001_0000: begin input_num[7:4] <= 4'h4; input_cnt = input_cnt + 1; end
                    10'b00_0010_0000: begin input_num[7:4] <= 4'h5; input_cnt = input_cnt + 1; end
                    10'b00_0100_0000: begin input_num[7:4] <= 4'h6; input_cnt = input_cnt + 1; end
                    10'b00_1000_0000: begin input_num[7:4] <= 4'h7; input_cnt = input_cnt + 1; end
                    10'b01_0000_0000: begin input_num[7:4] <= 4'h8; input_cnt = input_cnt + 1; end
                    10'b10_0000_0000: begin input_num[7:4] <= 4'h9; input_cnt = input_cnt + 1; end
                    endcase
                end

                else if (input_cnt == 2) begin
                    case (key[9:0])
                    10'b00_0000_0001: begin input_num[3:0] <= 4'h0; input_cnt = input_cnt + 1; end
                    10'b00_0000_0010: begin input_num[3:0] <= 4'h1; input_cnt = input_cnt + 1; end
                    10'b00_0000_0100: begin input_num[3:0] <= 4'h2; input_cnt = input_cnt + 1; end
                    10'b00_0000_1000: begin input_num[3:0] <= 4'h3; input_cnt = input_cnt + 1; end
                    10'b00_0001_0000: begin input_num[3:0] <= 4'h4; input_cnt = input_cnt + 1; end
                    10'b00_0010_0000: begin input_num[3:0] <= 4'h5; input_cnt = input_cnt + 1; end
                    10'b00_0100_0000: begin input_num[3:0] <= 4'h6; input_cnt = input_cnt + 1; end
                    10'b00_1000_0000: begin input_num[3:0] <= 4'h7; input_cnt = input_cnt + 1; end
                    10'b01_0000_0000: begin input_num[3:0] <= 4'h8; input_cnt = input_cnt + 1; end
                    10'b10_0000_0000: begin input_num[3:0] <= 4'h9; input_cnt = input_cnt + 1; end
                    endcase
                end

                if (input_cnt != 3 && mid_bt) state <= 2;
                if (input_cnt == 3 && mid_bt) begin
                    if (input_num[11:8] == 4'ha) begin
                        case (input_num[7:0])
                            6'b0000_0010: begin
                                if (a_pos[1:0] == 2'b01) begin
                                    num <= 3'b001;
                                    num_correct <= 1;
                                end else state <= 2;
                            end 
                            6'b0010_0000: begin
                                if (a_pos[3:2] == 2'b10) begin
                                    num <= 3'b010;
                                    num_correct <= 1;

                                end else state <= 2;
                            end 
                            6'b0010_0010: begin
                                if (a_pos[5:4] == 2'b11) begin
                                    num <= 3'b011;
                                    num_correct <= 1;
                                end else state <= 2;
                            end 
                            default : state <= 2;
                        endcase
                    end

                    if (input_num[11:8] == 4'hb) begin
                        case(input_num[7:0])
                            6'b0000_0010: begin
                                if (b_pos[1:0] == 2'b01) begin
                                    num <= 3'b101;
                                    num_correct <= 1;
                                end else state <= 2;
                            end 
                            6'b0010_0000: begin
                                if (b_pos[3:2] == 2'b10) begin
                                    num <= 3'b110;
                                    num_correct <= 1;
                                end else state <= 2;
                            end 
                            6'b0010_0010: begin
                                if (b_pos[5:4] == 2'b11) begin
                                    num <= 3'b111;
                                    num_correct <= 1;
                                end else state <= 2;
                            end 
                            default : state <= 2;
                        endcase
                    end
                end
            end 

            2: if (mid_bt) begin
                input_cnt = 0;
                input_num = 0;
                state <= 1;
            end

        endcase 
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


    parameter NULL = 8'b1111_1111;

    always @(posedge clk) begin

        //code
        seg0_num <= 4'hc;
        seg1_num <= 4'h0;
        seg2_num <= 4'hd;
        seg3_num <= 4'he;

        seg7_num <= 5'd28; //u
        seg8_num <= 5'd21; //n  

        if (view == 3) begin
            case (state)
                1: begin
                    {i0,i1,i2,i3}={seg0_out, seg1_out, seg2_out, seg3_out};
                    {i4,i5,i6,i7}={4{NULL}};

                    if (input_cnt == 0) begin
                        {i5,i6,i7} = {3{NULL}};
                    end

                    else if (input_cnt == 1) begin
                        seg4_num <= input_num[11:8];
                        i5 = seg4_out;
                        {i6,i7} = {2{NULL}};
                    end

                    else if (input_cnt == 2) begin
                        seg5_num <= input_num[7:4];
                        i5 = seg4_out;
                        i6 = seg5_out;
                        {i7} = {NULL};
                    end
                    else if (input_cnt == 3) begin
                        seg6_num <= input_num[3:0];
                        i5 = seg4_out;
                        i6 = seg5_out;
                        i7 = seg6_out;
                    end

                end 
                2: begin
                    {i4,i5,i6}={seg7_out, seg8_out, seg7_out};
                    {i0,i1,i2,i3,i7}={5{NULL}};
                end 
                3: begin
                    //test
                    {i4,i5}={seg7_out, seg7_out};
                    {i0,i1,i2,i3,i6,i7}={5{NULL}};
                end
            endcase
        end
        
    end


endmodule