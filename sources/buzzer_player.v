`timescale 1ns/1ps

module buzzer_player(
    input clk,
    input[11:0] hz_next, //
    output reg buzzer
);

reg[31:0] cnt;
reg[11:0] hz;

reg[31:0] reach;

reg reach_edge;

always @(posedge clk) begin

    if(cnt == (reach >> 1) - 1) begin
        cnt <= 0;
        reach_edge <= 1;

        if(hz != 0) begin
            buzzer <= ~buzzer;
        end
    end
    else begin
        cnt <= cnt + 1;
    end

    if(reach_edge) begin
        reach_edge <= 0;
        hz <= hz_next;
        if(hz_next == 0) begin
            reach <= 100_000;
        end else begin
            reach <= 100_000_000 / hz_next;
        end
    end

end

endmodule