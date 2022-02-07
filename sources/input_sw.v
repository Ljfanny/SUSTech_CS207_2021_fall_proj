`timescale 1ns / 1ps

module input_sw(
    input clk, rst,
    input[23:0] sw,
    output[23:0] sw_link
    );
    button_link sw_0(clk, sw[0], sw_link[0]);
    button_link sw_1(clk, sw[1], sw_link[1]);
    button_link sw_2(clk, sw[2], sw_link[2]);
    button_link sw_3(clk, sw[3], sw_link[3]);
    button_link sw_4(clk, sw[4],  sw_link[4]);
    button_link sw_5(clk, sw[5],  sw_link[5]);
    button_link sw_6(clk, sw[6],  sw_link[6]);
    button_link sw_7(clk, sw[7],  sw_link[7]);
    button_link sw_8(clk, sw[8],  sw_link[8]);
    button_link sw_9(clk, sw[9],  sw_link[9]);
    button_link sw_10(clk, sw[10],  sw_link[10]);
    button_link sw_11(clk, sw[11],  sw_link[11]);
    button_link sw_12(clk, sw[12],  sw_link[12]);
    button_link sw_13(clk, sw[13],  sw_link[13]);
    button_link sw_14(clk, sw[14],  sw_link[14]);
    button_link sw_15(clk, sw[15],  sw_link[15]);
    button_link sw_16(clk, sw[16],  sw_link[16]);
    button_link sw_17(clk, sw[17],  sw_link[17]);
    button_link sw_18(clk, sw[18],  sw_link[18]);
    button_link sw_19(clk, sw[19],  sw_link[19]);
    button_link sw_20(clk, sw[20],  sw_link[20]);
    button_link sw_21(clk, sw[21],  sw_link[21]);
    button_link sw_22(clk, sw[22],  sw_link[22]);
    button_link sw_23(clk, sw[23],  sw_link[23]);
    
endmodule
