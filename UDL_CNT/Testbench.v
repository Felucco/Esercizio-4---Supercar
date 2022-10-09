`include "UDL_CNT.v"
`timescale 1ns/100ps

module Testbench;
reg tb_clk, tb_rst, tb_en, tb_d_nu, tb_pl;
reg [3:0] tb_pin;
wire [3:0] tb_cnt;

UDL_CNT uut
(
    .clk(tb_clk),
    .rst(tb_rst),
    .en(tb_en),
    .d_nu(tb_d_nu),
    .pl(tb_pl),
    .pin(tb_pin),
    .cnt(tb_cnt)
);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) tb_clk=~tb_clk;

initial begin
    $dumpvars;
    tb_clk=1'b0;
    tb_rst=1'b1;
    tb_en=1'b1;
    tb_d_nu=1'b0;
    tb_pl=1'b0;
    tb_pin=4'd11;

    #10
    tb_rst=1'b0;

    #20
    tb_en=1'b0;

    #20
    tb_en=1'b1;
    tb_pl=1'b1;

    #10
    tb_pl=1'b0;
    tb_d_nu=1'b1;

    #20
    $finish;
end

endmodule