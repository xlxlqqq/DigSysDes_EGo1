`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/05/26 11:17:06
// Design Name: 
// Module Name: btn_rise_edge
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
将按键S2设置为边沿触发
包含消抖程序
*/
module  btn_rise_edge(
        input    clk,
        input    rst_n,
        input    btn,
        output   btn_rise_pulse
    );
reg  key_vc;         //Current Value
reg  key_vp;         //Previous Value
reg  [19:0]keycnt;   //间隔延时计数，用于延时采样的消抖


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)  
    begin keycnt<=0;  
        key_vc <=0; 
    end 
    else if(keycnt>=20'd999_999) 
    begin   
        keycnt<=0;
        key_vc <= btn;  //管脚状态
    end     
    else   keycnt<=keycnt + 20'd1;
end

always @(posedge clk)
    key_vp<=key_vc;       //将按键当前值赋值给下个时钟周期的按键值
        
//边沿触发效果
assign  btn_rise_pulse= (~key_vp) & key_vc;
endmodule

