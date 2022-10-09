`include "Supercar.v"
`timescale 1ns/1ps

module Testbench;

    reg tb_clk, tb_rst, tb_m1, tb_m2, tb_m3;
    wire [6:0] tb_HEX0, tb_HEX1, tb_HEX2, tb_HEX3;
    wire [9:0] tb_LEDR;

    always #5 tb_clk=~tb_clk;

    Supercar UUT (.KEY({~tb_m3,~tb_m2,~tb_m1,~tb_rst}),.CLOCK_50(tb_clk),.HEX0(tb_HEX0),
                    .HEX1(tb_HEX1),.HEX2(tb_HEX2),.HEX3(tb_HEX3),.LEDR(tb_LEDR));
    
    initial begin
        $dumpvars;

        tb_clk=0;
        tb_rst=1;
        tb_m1=0;
        tb_m2=0;
        tb_m3=0;
        #10
        tb_rst=0;
        #50
        tb_m1=1;
        #20
        tb_m1=0;
        tb_m2=1;
        #20
        tb_m1=1;
        tb_m2=0;
        #10
        tb_m1=0;
        tb_m2=1;
        #30
        tb_m2=0;
        #20
        tb_rst=1;
        #10
        $finish;
    end

endmodule;