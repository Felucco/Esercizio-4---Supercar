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
        tb_m3=1;
        #4000
        tb_rst=1;
        #30
        tb_m3=0;
        #50
        tb_rst=0;
        #20000
        tb_rst=1;
        #100
        $finish;
    end

    initial begin
        #50
        tb_m1=1;
        #200
        tb_m1=0;
        tb_m2=1;
        #300
        tb_m1=1;
        tb_m2=0;
        #200
        tb_m1=0;
        tb_m2=1;
        #250
        tb_m2=0;
        #300
        tb_m1=1;
        #150
        tb_m1=0;
        tb_m2=1;
        #200
        tb_m1=1;
        tb_m2=0;
        #250
        tb_m1=0;
        tb_m2=1;
        #300
        tb_m2=0;
        #2000
        tb_m1=1;
        tb_m2=1;
        #300
        tb_m2=0;
        #200
        tb_m2=1;
        #200
        tb_m2=0;
        #230
        tb_m1=0;
        tb_m2=1;
        #250
        tb_m1=1;
        #300
        tb_m2=0;
        tb_m1=0;
        #200
        repeat (10) begin
            tb_m1=1;
            #150
            tb_m1=0;
            #150;
        end
        tb_m2=1;
        #300
        tb_m2=0;
        repeat (10) begin
            tb_m2=1;
            #200
            tb_m2=0;
            #100;
        end
        repeat (30) begin
            tb_m1=$urandom%2;
            tb_m2=$urandom%2;
            #250;
        end
    end

endmodule;