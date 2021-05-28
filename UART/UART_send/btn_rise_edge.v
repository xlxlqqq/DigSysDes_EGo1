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


module  btn_rise_edge(
        input    clk,
        input    rst_n,
        input    btn,
        output   btn_rise_pulse
    );
reg  key_vc;   //保持按键当前值
reg  key_vp;  //保存按键上一个旧值
reg  [19:0]keycnt;   //间隔延时计数


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)  
    begin keycnt<=0;  
        key_vc <=0; 
    end 
    else if(keycnt>=20'd999_999) 
    begin   
        keycnt<=0;
        key_vc <= btn;  //读管脚
    end     
    else   keycnt<=keycnt + 20'd1;
end

always @(posedge clk)
    key_vp<=key_vc;       //老值跟踪
        
assign  btn_rise_pulse= (~key_vp) & key_vc;
endmodule

