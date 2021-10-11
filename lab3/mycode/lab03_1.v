module lab03_1(clk,rst,en,dir,led);
    input clk,rst,en,dir;
    output [15:0] led;
    wire clk_div;
    reg [15:0] led;
    clock_divider clk1(.clk(clk),.clk_div(clk_div));

    always@(posedge clk_div or posedge rst)
    begin
        if(rst==1'b1)
        begin
        led={1'b1,{15{1'b0}}};
        end
        else
        begin
            if(en==1'b1)
            begin
                if(dir==1'b1)
                begin
                    led={led[14:0],led[15]};
                end
                else
                begin
                    led={led[0],led[15:1]};
                end
            end
            else
            begin
                led=led;
            end
        end
    end
endmodule