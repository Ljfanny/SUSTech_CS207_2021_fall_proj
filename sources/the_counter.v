module the_counter (
    input clk,
    input rst,
    
    output reg [8:0] count,
    output reg led
);

    reg [15:0] cnt_period = 10_000; //1000_000æ—¶å¤§æ¦?17s 10_000æ—?10s
    wire cnt_judge;
    
    wire c100000k;
    wire c50k;
    divide_clk #(100_000) divclk1(clk, rst, c100000k);//1000_000
    divide_clk #(100_0) divclk2(c100000k, rst, c50k);
    
 always @(posedge c50k) begin
        if(rst) begin
            count <= 0;
            led <= 0;
        end 
        else begin
            count <= count + 1;
            led <= ~led;
        end
    end
endmodule
