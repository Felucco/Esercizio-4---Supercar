`include "../lib/BCD_7Seg.v"
`include "../lib/Bouncing_SHR.v"
`include "../lib/Edge_Trigger.v"
`include "../lib/Prescaler.v"
`include "../lib/TFF.v"
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
    parameter REAL_CLOCK = 1000;

    wire reset, mode1, mode2;
    reg mode3;
    assign reset=~KEY[0];
    assign mode1=~KEY[1];
    assign mode2=~KEY[2];

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) mode3<=0;
        else mode3<=~KEY[3];
    end

    // ---------- Controllo contatori H0...H3 e comando 7 segmenti -------------------

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
            BCD_7Seg B_7 (.A(BCD_in[4*hex+3:4*hex]),.HEX0(BCD_out[7*hex+6:7*hex])); //Output pilotato in ipotesi di 7 segment active low, si può gestire con relativo parametro
        end
    endgenerate

    assign HEX_in = SEG_AL ? BCD_out : ~BCD_out;
    assign HEX0 = reset ? HEX_in[6:0] : 7'd0;
    assign HEX1 = HEX_in[13:7];
    assign HEX2 = HEX_in[20:14];
    assign HEX3 = HEX_in[27:21];

    // ------------------ Fine comando 7 segmenti

    // ------------------ Mode3 = 1 -> Bouncing logic -------------

    wire pre100_p_e;

    Prescaler #(.PERIOD(REAL_CLOCK/100)) Pre100 (.clk(CLOCK_50),.rst(reset),.en(mode3),.p_e(pre100_p_e));

    wire b_shr_sin;
    wire [9:0] b_shr_pout;
    Edge_Trigger Mode3_ET (.clk(CLOCK_50),.rst(reset),.in(~KEY[3]),.out(b_shr_sin)); //Si può sfruttare direttamente l'ingresso non campionato dato che ET campiona internamente

    Bouncing_SHR #(.N_BIT(10)) B_SHR (.clk(CLOCK_50),.rst(reset),.en(pre100_p_e),.sin(b_shr_sin),.pout(b_shr_pout));

    // --------------- Mode3 = 0 -> Led lampeggianti ---------------
    wire pre2_p_e;

    Prescaler #(.PERIOD(REAL_CLOCK/2)) Pre2 (.clk(CLOCK_50),.rst(reset),.en(~mode3),.p_e(pre2_p_e));

    wire [9:0] tff_out;

    genvar t_idx;
    generate
        for (t_idx = 0; t_idx<10; t_idx=t_idx+1) begin : T_FF_Generate
            TFF T_FF (.clk(CLOCK_50),.rst(reset),.t(pre2_p_e),.q(tff_out[t_idx]));
        end
    endgenerate

    // -------------- Mode3 output selection --------------
    assign LEDR = mode3 ? b_shr_pout : tff_out;
endmodule