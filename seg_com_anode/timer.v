`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: Xlxlqqq
// 
// Create Date: 2021/04/14 11:30:11
// Design Name: 
// Module Name: timer
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


module timer(
    input clk,
    input rst,
    output [7:0] seg_data,
    output [3:0] seg_cs
    );
integer timer_cnt;
reg [15:0] seconds;
reg [15:0] data;

always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            timer_cnt <= 0;
            seconds <= 0;
        end
        else if(timer_cnt >= 100_000_000)
        begin
            timer_cnt <= 0;
            if(seconds >= 9999)
                seconds <= 0;
            else 
                seconds <= seconds + 1;
        end
        else
            timer_cnt <= timer_cnt + 1;
    end
    
always @(seconds)
    begin
        data[15:12] = seconds / 1000;
        data[11:8] = (seconds - data[15:12]*1000)/100;
        data[7:4] = (seconds-data[15:12]*1000 - data[11:8]*100)/10;
        data[3:0] = seconds - data[15:12]*1000 - data[11:8]*100-data[7:4]*10;
    end
    
DIgi_tube  u1(
        .clk(clk),
        .data(data),
        .seg_data(seg_data),
        .seg_cs(seg_cs),
        .rst(rst)
);


endmodule
