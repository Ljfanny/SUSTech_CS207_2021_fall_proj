`timescale 1ns/1ps

module music_player(
    input clk,
    input rst,
    input sw,
    output buzzer
);

parameter _4C  = 12'd262;
parameter _4D  = 12'd294;
parameter _4E  = 12'd330;
parameter _4F  = 12'd350;
parameter _4G  = 12'd392;
parameter _4A  = 12'd441;
parameter _4B  = 12'd495;

parameter _5C  = 12'd525;
parameter _5D  = 12'd589;
parameter _5E  = 12'd661;
parameter _5F  = 12'd700;
parameter _5G  = 12'd786;
parameter _5A  = 12'd882;
parameter _5B  = 12'd990;

parameter NO_VOICE = 12'd0;

parameter slice = 200;

parameter sect_count = 8'd17;

wire ms_clk;
divide_clk #(100_000) ms_clk_inst(clk, rst, ms_clk);

reg[11:0] cnt;
wire ms_edge;
edge_gen ms_edge_inst(clk, ms_clk, ms_edge);

//reg play_end;
reg[11:0] slices = 0;
reg[11:0] hz;
reg[11:0] next_hz;


always @(posedge clk) begin
    
    if(rst) begin
        cnt <= 0;
        slices <= 0;
    end
    else begin
            if(ms_edge && sw) begin
                if(cnt == slice) begin
                    cnt <= 0;
                    if (slices == 12'd120) begin
                        
                        slices = 12'd0;
                    end

                    else begin
                        slices <= slices + 1;
                    end
                end
                 else begin
                     cnt <= cnt + 1;//
                 end

            end
        end
    end

buzzer_player player(clk, hz, buzzer);

always @(*) begin
    if(rst == 0) begin
        case(slices)

        12'd010: next_hz = _4G;
        12'd012: next_hz = _5C;
        12'd014: next_hz = _5C;
        12'd015: next_hz = _5D;
        12'd016: next_hz = _5C;
        12'd017: next_hz = _4B;
        12'd019: next_hz = _4A;
        12'd021: next_hz = _4A;
        12'd023: next_hz = NO_VOICE;

        12'd024: next_hz = _4A;
        12'd026: next_hz = _5D;
        12'd028: next_hz = _5D;
        12'd029: next_hz = _5E;
        12'd030: next_hz = _5D;
        12'd031: next_hz = _5C;
        12'd032: next_hz = _4B;
        12'd034: next_hz = _4G;
        12'd036: next_hz = NO_VOICE;

        12'd037: next_hz = _4G;
        12'd039: next_hz = _5E;
        12'd041: next_hz = _5E;
        12'd042: next_hz = _5F;
        12'd043: next_hz = _5E;
        12'd044: next_hz = _5D;
        12'd045: next_hz = _5C;
        12'd047: next_hz = _4A;
        12'd049: next_hz = _4G;
        12'd050: next_hz = _4G;
        12'd051: next_hz = _4A;
        12'd053: next_hz = _5D;
        12'd055: next_hz = _4B;
        12'd057: next_hz = _5C;
        12'd061: next_hz = NO_VOICE;

        12'd063: next_hz = _4G;
        12'd065: next_hz = _5C;
        12'd067: next_hz = _5C;
        12'd069: next_hz = _5C;
        12'd071: next_hz = _4B;
        12'd075: next_hz = _4B;
        12'd077: next_hz = _5C;
        12'd079: next_hz = _4B;
        12'd081: next_hz = _4A;
        12'd083: next_hz = _4G;
        12'd087: next_hz = _5D;
        12'd089: next_hz = _5E;
        12'd091: next_hz = _5D;
        12'd093: next_hz = _5C;
        12'd095: next_hz = _5G;
        12'd097: next_hz = _4G;
        12'd099: next_hz = _4G;
        12'd100: next_hz = _4G;
        12'd101: next_hz = _4A;
        12'd103: next_hz = _5D;
        12'd105: next_hz = _4B;
        12'd107: next_hz = _5C;
        12'd113: next_hz = NO_VOICE;

        default: next_hz = hz;

        endcase
    end else begin
        next_hz = NO_VOICE;
    end
end

always @(posedge clk) begin
    if(rst ||slices == 12'd120 || ~sw) begin
        hz <= 12'b0;
    end else if(sw && slices!=12'd120) begin
        hz <= next_hz;
    end
end

endmodule