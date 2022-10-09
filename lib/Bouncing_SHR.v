`include "../lib/SHR.v"

module Bouncing_SHR #(
    parameter N_BIT=4
) (
    input clk, rst, en, sin,
    output wire[N_BIT-1:0] pout
);
    wire shr_en, shr_sout;
    reg l_nr;
    wire l_nr_in;
    wire [N_BIT-1:0] shr_pin;

    assign shr_en=en|sin;
    assign shr_pin=0;

    SHR #(.N_BIT(N_BIT)) core_SHR (.clk(clk), .rst(rst), .en(shr_en), .l_nr(l_nr),
                                    .pl(1'b0), .sin(sin), .pin(shr_pin), .sout(shr_out), .pout(pout));
    
    assign l_nr_in = l_nr ? ~pout[N_BIT-1] : pout[0];

    always @(posedge clk or posedge rst) begin
        if (rst) l_nr<=0;
        else l_nr<=l_nr_in;
    end
endmodule