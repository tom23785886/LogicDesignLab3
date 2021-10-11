module lab03_3(clk,rst,en,led);
    input clk;
    input rst;
    input en;
    output [15:0] led;
    wire mr1clk;
    wire mr3clk;
    reg dir=1'b1;
    reg nextdir;
    reg nexttogether;
    reg [15:0] mr1pos;
    reg [15:0] mr3pos;
    reg [15:0] nextmr1pos;
    reg [15:0] nextmr3pos;
    //reg changepos;
    wire [15:0] led;
    reg past;
    reg now;
    clk_divider23 clk2(.clk(clk),.clk_div(mr1clk));
    clk_divider26 clk1(.clk(clk),.clk_div(mr3clk));
    
    always@(posedge mr1clk)
        begin
            mr1pos=nextmr1pos;
            dir=nextdir;
            past=now;
        end
    always@(posedge mr3clk)
        begin
            mr3pos=nextmr3pos;  
        end
    always@(*)
        begin
            casex({rst,en,dir})
                3'b1xx: 
                    begin
                        nextmr1pos={1'b1,{15{1'b0}}};
                       nextmr3pos={{3{1'b1}},{13{1'b0}}};
                       now=1'b0;
                    end   
                3'b011: 
                    begin 
                       nextmr3pos={mr3pos[0],mr3pos[15:1]};
                       if((mr1pos & mr3pos)!=0)
                        begin
                            if(past==1'b1)
                                begin
                                    now=1'b0;
                                    nextmr1pos={mr1pos[0],mr1pos[15:1]};
                                end
                            else
                                begin
                                    now=1'b1;
                                    nextmr1pos={mr1pos[14:0],mr1pos[15]};
                                end
                            
                        end
                        else
                            begin
                                now=1'b0;
                                nextmr1pos={mr1pos[0],mr1pos[15:1]};
                            end
                    end
                3'b010: 
                    begin
                        nextmr3pos={mr3pos[0],mr3pos[15:1]};
                        if((mr1pos & mr3pos)!=0)
                            begin
                                if(past==1'b1)
                                    begin
                                        now=1'b0;
                                        nextmr1pos={mr1pos[0],mr1pos[15:1]};
                                    end
                                else
                                    begin
                                        now=1'b1;
                                        nextmr1pos={mr1pos[0],mr1pos[15:1]};
                                    end
                                
                            end
                        else
                            begin
                                now=1'b0;
                                nextmr1pos={mr1pos[14:0],mr1pos[15]};
                             end
                    end
                default:
                    begin
                        nextmr1pos=mr1pos;
                        nextmr3pos=mr3pos;
                    end
            endcase
        end
        assign led=(mr1pos | mr3pos);
    always@(*)
        begin
            if((mr1pos & mr3pos)!=0)
                begin
                    if(past==1'b1)
                        begin
                            nextdir=dir;
                        end
                    else    
                        begin
                            nextdir=~dir;
                            //changepos=1'b1;
                        end
                    
                end
            else
                begin
                    nextdir=dir;
                    //changepos=1'b0;
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