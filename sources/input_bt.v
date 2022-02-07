`timescale 1ns / 1ps

module input_bt(
    input clk, rst,
    input[4:0] bt,
    output[4:0] bt_link
    );
    button_link bt_0(clk, bt[0], bt_link[0]);
    button_link bt_1(clk, bt[1], bt_link[1]);
    button_link bt_2(clk, bt[2], bt_link[2]);
    button_link bt_3(clk, bt[3], bt_link[3]);
    button_link bt_4(clk, bt[4], bt_link[4]);
endmodule
