`include "Bouncing_SHR.v"
`timescale 1ns/100ps

module Testbench;

    reg tb_clk, tb_rst, tb_en, tb_sin;
    wire[5:0] tb_pout;

    Bouncing_SHR #(.N_BIT(6)) UUT (.clk(tb_clk),.rst(tb_rst),.en(tb_en),.sin(tb_sin),.pout(tb_pout));

    always #5 tb_clk=~tb_clk;

    initial begin
        $dumpvars;

        tb_clk=0;
        tb_rst=1;
        tb_en=0;
        tb_sin=0;

        #10
        tb_rst=0;
        tb_sin=1;
        #10
        tb_sin=0;
        tb_en=1;
        #300
        tb_rst=1;
        #10
        $finish;
    end

endmodule

