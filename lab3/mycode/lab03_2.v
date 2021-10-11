module lab03_2(clk,rst,en,dir,led);
    input clk;
    input rst;
    input en;
    input dir;
    output [15:0] led;
    wire smallclk;
    wire bigclk;
    reg [15:0] mr1pos;
    reg [15:0] mr3pos;
    reg [15:0] nextmr1pos;
    reg [15:0] nextmr3pos;
    reg [15:0] led;
    reg mr1clk;
    reg mr3clk;
    clk_divider23 clk2(.clk(clk),.clk_div(smallclk));
    clk_divider26 clk1(.clk(clk),.clk_div(bigclk));
    
    always@(posedge mr1clk)
        begin
            mr1pos=nextmr1pos;
        end
    always@(posedge mr3clk)
        begin
            mr3pos=nextmr3pos;
        end
    always@(rst,en,dir)
        begin
            casex({rst,en,dir})
                3'b1xx: 
                    begin
                        nextmr1pos={1'b1,{15{1'b0}}};
                       nextmr3pos={{3{1'b1}},{13{1'b0}}};
                    end   
                3'b011: 
                    begin 
                        nextmr1pos={mr1pos[14:0],mr1pos[15]};
                       nextmr3pos={mr3pos[14:0],mr3pos[15]};
                    end
                3'b010: 
                    begin
                        nextmr1pos={mr1pos[0],mr1pos[15:1]};
                        nextmr3pos={mr3pos[0],mr3pos[15:1]};
                    end
                default:
                    begin
                        nextmr1pos=mr1pos;
                        nextmr3pos=mr3pos;
                    end
            endcase
        end
    always@(mr1pos,mr3pos)
        begin
            led=(mr1pos | mr3pos);
        end
    always@(dir)
        begin
            if(dir==1'b1)
                begin
                    mr1clk=bigclk;
                    mr3clk=smallclk;
                end
            else
                begin
                    mr1clk=smallclk;
                    mr3clk=bigclk;
                end
        end
endmodule
module clk_divider26(clk,clk_div);
    input clk;
    output clk_div;

    reg [25:0] num;
    wire [25:0] nextnum;
    always@(posedge clk)
        begin
            num=nextnum;
        end
    assign nextnum=num+1;
    assign clk_div=num[25];
endmodule
module clk_divider23(clk,clk_div);
    input clk;
    output clk_div;
    reg [22:0] num;
    wire [22:0] nextnum;
    always@(posedge clk)
        begin
            num=nextnum;
        end
    assign nextnum=num+1;
    assign clk_div=num[22];
endmodule