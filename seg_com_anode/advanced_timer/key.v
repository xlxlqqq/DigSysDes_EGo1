`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/05/08 11:02:15
// Design Name: 
// Module Name: key
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module key(
    input   clk,
    input   rst,
    input   [4:0]btn,
    output  [7:0]seg_data,
    output  [7:0]seg_data2,
    output  [7:0]seg_cs,
    output  reg[5:0]led1
    );

    reg [4:0]key_vc;
    reg [4:0]key_vp;
    reg [19:0]keycnt;
    always @(posedge clk or negedge rst) begin
        if(!rst)
            begin
                keycnt <= 0;
                key_vc <= 4'd0;
            end
        else
            begin
            if(keycnt>=20'd999_999)
                begin
                keycnt <= 0;
                key_vc <= btn;
                end
            else    keycnt<=keycnt+20'd1;
            end
    end

    always @(posedge clk) begin
        key_vp <= key_vc;
    end

    wire [4:0]key_rise_edge;
    assign key_rise_edge = (~key_vp[4:0])&key_vc[4:0];


    reg [5:0]seconds=0;
    reg [5:0]minutes=0;
    reg [4:0]hours  =0;
    integer statue = 0;

    reg [5:0]location = 5'b000001;
    parameter Sm = 5'b00100;   //中间
    parameter Su = 5'b10000;   //上
    parameter Sd = 5'b00010;   //下
    parameter Sl = 5'b01000;   //左
    parameter Sr = 5'b00001;   //右

    integer timer_cnt;

    always @(posedge clk or negedge rst) begin
        if(!rst)
            begin
            location[5:0] = 6'b000001;
            led1[5:0] = 6'b111111;
            statue=0;
            seconds=0;
            minutes=0;
            hours  =0;

            timer_cnt <= 0;
            end
        else
            begin
            if(key_rise_edge==Sm)
                begin
                statue=~statue;
                if(!statue)led1[5:0]=6'b111111;
                else led1[5:0]=6'b000001;
                end
            if(statue)
                begin
                case(key_rise_edge)
                    Sl: begin location[5:0]={location[4:0],location[5]};led1[5:0]=location[5:0];    end
                    Sr: begin location[5:0]={location[0],location[5:1]};led1[5:0]=location[5:0];    end
                    Su: 
                        case(location)
                            6'b000001:begin if(seconds   >=59)begin seconds=0;         if(minutes>=59)begin minutes=0;hours=0;end else minutes=minutes+1;end else seconds = seconds  +1;    end
                            6'b000010:begin if(seconds/10>=5) begin seconds=seconds%10;if(minutes>=59)begin minutes=0;hours=0;end else minutes=minutes+1;end else seconds = seconds  +10;   end
                            6'b000100:begin if(minutes   >=59)begin minutes=0;         if(hours>=23)hours=0;    else hours=hours+1;    end else minutes = minutes  +1;    end
                            6'b001000:begin if(minutes/10>=5) begin minutes=minutes%10;if(hours>=23)hours=0;    else hours=hours+1;    end else minutes = minutes  +10;   end
                            6'b010000:begin if(hours     >=23)begin hours=0;                                    end else hours   = hours    +1;    end
                            6'b100000:begin if(hours/10  >=2) begin hours=hours%10;end else begin hours   = hours  +10; if(hours>23)hours=23; end   end
                        endcase  
                    Sd:  
                        case(location) 
                            6'b000001:begin if(seconds   ==0)begin seconds=59;           if(minutes==0)begin minutes=59;hours=23;end else minutes=minutes-1;end else seconds = seconds  -1;    end
                            6'b000010:begin if(seconds/10==0)begin seconds=seconds%10+50;if(minutes==0)begin minutes=59;hours=23;end else minutes=minutes-1;end else seconds = seconds  -10;   end
                            6'b000100:begin if(minutes   ==0)begin minutes=59;           if(hours==0)hours=23;    else hours=hours-1;    end else minutes = minutes  -1;    end
                            6'b001000:begin if(minutes/10==0)begin minutes=minutes%10+50;if(hours==0)hours=23;    else hours=hours-1;    end else minutes = minutes  -10;   end
                            6'b010000:begin if(hours     ==0)begin hours=23;                               end else hours   = hours    -1;    end
                            6'b100000:begin if(hours/10  ==0)begin hours=hours%10+20;                      end else hours   = hours    -10;   end
                        endcase
                endcase
                
                end
            else if(statue==0 && timer_cnt>=100_000_000)
                begin
                timer_cnt<=0;
                if(seconds>=59)     
                    begin
                    seconds=0;
                    if(minutes>=59)     
                        begin
                        minutes=0;
                        if(hours>=23)     
                            begin
                            hours=0;
                            end
                        else    hours=hours+1;
                        end
                    else    minutes=minutes+1;
                    end
                else    seconds=seconds+1;
                end
            else    timer_cnt <= timer_cnt+1;
            end
    end

    
    reg [31:0] data;
    always @(seconds or minutes or hours) begin
        data[31:28] = (hours)/10;
        data[27:24] = (hours)%10;
        data[23:20] = 04'hf;
        data[19:16] = (minutes)/10;
        data[15:12] = (minutes)%10;
        data[11:8]  = 04'hf;
        data[7:4]   = (seconds)/10;
        data[3:0]   = (seconds)%10;
    end
  
    timer u2(  .clk(clk),
                .rst(rst),
                .data(data),
                .seg_data(seg_data),
                .seg_data2(seg_data2),
                .seg_cs(seg_cs)
            );
endmodule
