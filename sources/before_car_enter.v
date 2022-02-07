`timescale 1ns / 1ps

module before_car_enter(
    input clk,
    input rst,
    input[4:0] bt_out,
    input [2:0] view,
    output reg[2:0] choose_parking,
    output reg[2:0] state,
    input [15:0] key_out
    );
    wire left_bt_in, right_bt_in, mid_bt_in;
    assign left_bt_in = bt_out[1];
    assign right_bt_in = bt_out[0];
    assign mid_bt_in = bt_out[3];
    
    reg ispressed;
    reg [4:0] change_time = 5'd0;
    
    always @(posedge clk) begin
        if(!left_bt_in && !right_bt_in && !mid_bt_in)begin 
              ispressed = 0;
            end
        if(rst) begin
            state <= 1;
        end 
        else
        begin
            if(view == 0) 
            begin
                if (left_bt_in && !ispressed) begin
                    ispressed = 1;
                    if(state == 1)
                        state <= 2;
                    else
                        state <= state - 1;
                end
                else if (right_bt_in && !ispressed) begin
                    ispressed = 1;
                    if(state == 2)
                        state <= 1;
                    else
                        state <= state + 1;
                end
                case(key_out[11:10])
                2'b01: state <= 1;
                2'b10: state <= 2;
                endcase
            end
        end
    end

endmodule
