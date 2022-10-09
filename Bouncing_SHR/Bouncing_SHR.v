`include "../lib/SHR.v"

module Bouncing_SHR #(
    parameter N_BIT=4
) (
    input clk, rst, en, sin,
    output wire[N_BIT-1:0] pout
);
    wire shr_en, shr_sout;
    reg l_nr;
    wire [N_BIT-1:0] shr_pin;

    assign shr_en=en|sin;
    assign shr_pin=0;

    SHR #(.N_BIT(N_BIT)) core_SHR (.clk(clk), .rst(rst), .en(shr_en), .l_nr(l_nr),
                                    .pl(1'b0), .sin(sin), .pin(shr_pin), .sout(shr_out), .pout(pout));
    
    always @(posedge clk or posedge rst) begin
        if (rst) l_nr<=0;
        else begin
            case (l_nr)
                1'b1: l_nr <= ~pout[N_BIT-2]; 
                default: l_nr <= pout[1];
            endcase
        end
    end
endmodule