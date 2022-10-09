module TFF (
    input clk, rst, t,
    output reg q
);

    always @(posedge clk or posedge rst) begin
        if (rst) q<=0;
        else if (t) q<=~q;
    end
    
endmodule