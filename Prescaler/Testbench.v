`include "Prescaler.v"
`timescale 1ns/100ps

module Testbench;

    reg tb_clk, tb_rst, tb_en;
    wire tb_p_e;

    always #5 tb_clk=~tb_clk;

    Prescaler #(.PERIOD(5)) UUT (.clk(tb_clk),.rst(tb_rst),.en(tb_en),.p_e(tb_p_e));

    initial begin
        $dumpvars;
        tb_clk=0;
        tb_rst=1;
        tb_en=0;

        #10
        tb_rst=0;
        #10
        tb_en=1;
        #270
        tb_en=0;
        #60
        tb_rst=1;
        #20
        $finish;
    end

endmodule