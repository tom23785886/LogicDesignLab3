module clock_divider(clk,clk_div);
    parameter n=26;
    input clk;
    output clk_div;

    reg [n-1:0] num;
    wire [n-1:0] nextnum;
    always@(posedge clk)
        begin
            num=nextnum;
        end
    assign nextnum=num+1;
    assign clk_div = num[n-1];
endmodule