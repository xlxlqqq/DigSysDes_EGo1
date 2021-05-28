`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/05/26 10:54:14
// Design Name: 
// Module Name: clk_baudrate
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

/*
产生需要的波特率
*/
module clk_baudrate(
    clkin,
    rst_n,
    clkout);
    
input    clkin;           //输入时钟100MHz
input    rst_n; 
output   clkout;          //输出固定16倍波特率时钟
reg      clkout;

parameter   clks=100000000;   
parameter   baudrate = 9600;        //可自定义
wire [31:0]cntmax;
integer  cnt;

assign cntmax = (clks / baudrate / 16) - 1;

always @(posedge clkin or negedge rst_n)
    if(!rst_n)
    begin   
        clkout <= 0;  cnt <=0; 
    end
    else if(cnt >= cntmax)    
        begin  
            clkout <= 1;  
            cnt <= 0;
        end
    else
    begin  
        clkout <= 0;
        cnt <= cnt+1'b1;  
    end

endmodule


/*
关于输出16倍波特率的时钟：
因为每一个时钟周期内，需要输出一个bit
而一个时钟周期需要进行过采样，才能够尽可能地保证采样的准确性
避免因为噪声的存在导致时钟不准确
而输出是16而不是14，15
应该是为了便于分频设计
参考STM32的分频时钟设计
*/

