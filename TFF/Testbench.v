`include "TFF.v"
`timescale 1ns/100ps

module Testbench;

    reg clk, rst, t;
    wire q;

    TFF UUT (.clk(clk), .rst(rst),.t(t),.q(q));

    always #5 clk = ~clk;

    initial begin
        $dumpvars;
        clk=0;
        rst=1;
        t=0;

        #10
        rst=0;
        t=1;
        #60
        t=0;
        #60
        rst=1;
        #10
        $finish;
    end

endmodule