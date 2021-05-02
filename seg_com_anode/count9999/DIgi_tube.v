`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjian University
// Engineer: Xlxlqqq
// 
// Create Date: 2021/04/14 10:41:35
// Design Name: 
// Module Name: DIgi_tube
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
clk：系统时钟，100MHz
rst：复位按键
data：每4位对应一个数码管，里面包含了所有要显示的数字
dis_data:包含了每一位要显示的数字，但是没有进行BCD转换
seg_data：转换成的段码
seg_cs：位码
*/

module DIgi_tube(
   input clk,
   input rst,
   input [15:0]data,
   output reg [7:0]seg_data,
   output reg [3:0]seg_cs
    );
   
 reg clk_500HZ;      //一个新的脉冲信号，频率为50Hz
 integer clk_cnt;
   
//产生一个50Hz的新脉冲信号
 always @(posedge clk or posedge rst)
 begin
    if(rst)
    begin
        clk_500HZ <= 0;
        clk_cnt <= 0;
    end
    else
    begin
        if(clk_cnt >= 100_000)
            begin
                clk_cnt <= 0;
                clk_500HZ <= ~clk_500HZ;
            end
            else
            begin
                clk_cnt <= clk_cnt + 1;
            end
    end
 end
 
////快速更新片选信号，高帧率刷新利用视觉暂留
always @ (posedge clk_500HZ or posedge rst)
    if(rst) 
        seg_cs <= 4'b0001;
    else
        seg_cs <= {seg_cs[2:0], seg_cs[3]};

   
//根据seg_cs信号确定要显示的数字
reg [3:0] dis_data;
always @(seg_cs)
    case(seg_cs)
    4'b0001:dis_data = data[3:0];
    4'b0010:dis_data = data[7:4];
    4'b0100:dis_data = data[11:8];
    4'b1000:dis_data = data[15:12];
    default:dis_data = 4'hf;
    endcase

//BCD转换，生成段码
always @(dis_data)
case(dis_data)
    04'h0:seg_data = 8'h3F;
    04'h1:seg_data = 8'h06;
    04'h2:seg_data = 8'h5B;
    04'h3:seg_data = 8'h4F;
    04'h4:seg_data = 8'h66;
    04'h5:seg_data = 8'h6D;
    04'h6:seg_data = 8'h7D;
    04'h7:seg_data = 8'h07;
    04'h8:seg_data = 8'h7F;
    04'h9:seg_data = 8'h6F;
    04'ha:seg_data = 8'h77;
    04'hb:seg_data = 8'h7C;
    04'hc:seg_data = 8'h39;
    04'hd:seg_data = 8'h5E;
    04'he:seg_data = 8'h79;
    04'hf:seg_data = 8'h71;
    default:seg_data = 8'hFF;
    endcase

endmodule






