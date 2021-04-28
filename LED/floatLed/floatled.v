`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/04/28 11:10:35
// Design Name: 
// Module Name: floatled
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


module floatled(   
    input clk,
    input rst_n,
    input key_1,key_2,
    output reg [15:0] led
    );

reg direct;
always @(posedge clk or negedge rst_n)
    if(!rst_n)  direct <= 0;
    else
        if(key_1)   direct <= 1;
        else if(key_2)  direct <= 0;
        else    direct <= direct;


reg [19:0] cnt;
reg clk_50hz;
parameter countmax = 20'd999_999;
//parameter countmax = 20'd9_999;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        cnt  <= 0;
        clk_50hz <= 0;
    end
    else
    begin
        if(cnt >= countmax)
        begin
            cnt <= 0;
            clk_50hz = ~ clk_50hz;
        end
        else
            cnt <= cnt + 20'd1;
    end
end

reg [3:0] led_count;
always @(posedge clk_50hz or negedge rst_n)
    if(!rst_n)
    begin
        led_count <= 0;
        led <= 16'd1;
    end
    else
        if(led_count >9)
        begin
            led_count <= 0;
            if(direct)
                led <= {led[14:0],led[15]};
            else
                led <= {led[0],led[15:1]};
        end
        else
            led_count <= led_count + 4'd1;
    
    
    
endmodule
