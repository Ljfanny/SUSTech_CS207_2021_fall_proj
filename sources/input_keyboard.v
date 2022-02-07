`timescale 1ns / 1ps

//keyboard linked
module input_keyboard(
    input clk, rst,
    input[3:0] row,
    output[3:0] col,
    output[15:0] key_link
    );

    wire[15:0] key;
    state_machine states(clk, rst, row, col, key);

    button_link key_0(clk, key[0],  key_link[0]);
    button_link key_1(clk, key[1],  key_link[1]);
    button_link key_2(clk, key[2],  key_link[2]);
    button_link key_3(clk, key[3],  key_link[3]);
    button_link key_4(clk, key[4],  key_link[4]);
    button_link key_5(clk, key[5],  key_link[5]);
    button_link key_6(clk, key[6],  key_link[6]);
    button_link key_7(clk, key[7],  key_link[7]);
    button_link key_8(clk, key[8],  key_link[8]);
    button_link key_9(clk, key[9],  key_link[9]);
    button_link key_10(clk, key[10], key_link[10]);
    button_link key_11(clk, key[11],  key_link[11]);
    button_link key_12(clk, key[12],  key_link[12]);
    button_link key_13(clk, key[13],  key_link[13]);
    button_link key_14(clk, key[14],  key_link[14]);
    button_link key_15(clk, key[15],  key_link[15]);

endmodule