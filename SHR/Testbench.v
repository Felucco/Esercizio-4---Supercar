`include "SHR.v"
`timescale 1ns/100ps

module Testbench;

    reg tb_clk, tb_rst, tb_en, tb_l_nr, tb_pl, tb_sin;
    reg [7:0] tb_pin;
    wire tb_sout;
    wire [7:0] tb_pout;

    SHR #(.N_BIT(8)) UUT (.clk(tb_clk), .rst(tb_rst), .en(tb_en),
                        .l_nr(tb_l_nr), .pl(tb_pl), .sin(tb_sin),
                        .pin(tb_pin),.sout(tb_sout),.pout(tb_pout));
    
    always #5 tb_clk=~tb_clk;

    initial begin
        $dumpvars;
        tb_clk=0;
        tb_rst=1;
        tb_en=0;
        tb_l_nr=0;
        tb_pl=0;
        tb_sin=0;
        tb_pin=0;

        #10
        tb_rst=0;
        tb_sin=1;
        tb_en=1;

        repeat (2) @(posedge tb_clk);
        #5
        tb_sin=0;
        #50
        tb_en=0;
        #30
        tb_pin=8'b1010_0110;
        tb_pl=1;
        #10
        tb_en=1;
        #10
        tb_pl=0;
        tb_l_nr=1;
        #30
        tb_sin=1;
        #30
        tb_rst=1;
        #10
        $finish;
    end

endmodule