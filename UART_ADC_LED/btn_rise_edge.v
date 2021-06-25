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
    
reg  key_vc;   //±£³Ö°´¼üµ±Ç°Öµ
reg  key_vp;  //±£´æ°´¼üÉÏÒ»¸ö¾ÉÖµ
reg  [19:0]keycnt;   //¼ä¸ôÑÓÊ±¼ÆÊý


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)  
    begin keycnt<=0;  
        key_vc <=0; 
    end 
    else if(keycnt>=20'd999_999) 
    begin   
        keycnt<=0;
        key_vc <= btn;  //¶Á¹Ü½Å
    end     
    else   keycnt<=keycnt + 20'd1;
end

always @(posedge clk)
    key_vp<=key_vc;       //ÀÏÖµ¸ú×Ù
        
assign  btn_rise_pulse= (~key_vp) & key_vc;
endmodule

