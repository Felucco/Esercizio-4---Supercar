`include "../lib/BCD_7Seg.v"
`include "../lib/Bouncing_SHR.v"
`include "../lib/Edge_Trigger.v"
`include "../lib/Prescaler.v"
`include "../lib/TFF.v"
`include "../lib/UDL_CNT.v"
`include "../lib/CNT.v"

module Supercar (
    input [3:0] KEY,
    input CLOCK_50,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [9:0] LEDR
);

    parameter SEG_AL=1; //Mettere a 0 se i 7 segmenti vanno pilotati in active high e non active low

    wire reset, mode1, mode2, mode3;
    assign reset=~KEY[0];
    assign mode1=~KEY[1];
    assign mode2=~KEY[2];
    assign mode3=~KEY[3];

    wire mode1_et, mode2_et;

    Edge_Trigger Mode1_ET (.clk(CLOCK_50),.rst(reset),.in(mode1),.out(mode1_et));
    Edge_Trigger Mode2_ET (.clk(CLOCK_50),.rst(reset),.in(mode2),.out(mode2_et));

    wire [3:0] H0, H1, H2, H3_c; //H3_c è H3 all'ingresso del relativo registro di campionamento, quindi ancora combinatorio dal sommatore
    reg [3:0] H3;

    CNT H1_CNT (.clk(CLOCK_50),.rst(reset),.en(mode1_et),.d_nu(1'b0),.cnt(H1));
    CNT H2_CNT (.clk(CLOCK_50),.rst(reset),.en(mode2_et),.d_nu(1'b1),.cnt(H2));

    assign H3_c=H1+H2;
    assign H0=0;

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) H3<=0;
        else H3<=H3_c;
    end

    wire [15:0] BCD_in = {H3, H2, H1, H0};
    wire [27:0] BCD_out, HEX_in;

    genvar hex;
    generate
        for (hex = 0; hex<4; hex = hex+1) begin : Gen_BCD_7Seg
            BCD_7Seg B_7 (.A(BCD_in[4*hex+3:4*hex]),.HEX0(BCD_out[7*hex+6:7*hex]));
        end
    endgenerate

    assign HEX_in = SEG_AL ? BCD_out : ~BCD_out;
    assign HEX0 = reset ? HEX_in[3:0] : 7'd0;
    assign HEX1 = HEX_in[7:4];
    assign HEX2 = HEX_in[11:8];
    assign HEX3 = HEX_in[15:12];
endmodule