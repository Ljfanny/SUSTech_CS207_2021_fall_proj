`timescale 1ns / 1ps


module key_map(
    input[15:0] key_in,
    output[15:0] key_out
);

assign key_out[13] = ~key_in[15]; // D
assign key_out[12] = ~key_in[14]; // C
assign key_out[11] = ~key_in[13]; // B
assign key_out[10] = ~key_in[12]; // A
assign key_out[14] = ~key_in[11]; // #
assign key_out[9] = ~key_in[10];
assign key_out[6] = ~key_in[9];
assign key_out[3] = ~key_in[8];
assign key_out[0] = ~key_in[7];
assign key_out[8] = ~key_in[6];
assign key_out[5] = ~key_in[5];
assign key_out[2] = ~key_in[4];
assign key_out[15] = ~key_in[3]; // *
assign key_out[7] = ~key_in[2];
assign key_out[4] = ~key_in[1];
assign key_out[1] = ~key_in[0];

endmodule
