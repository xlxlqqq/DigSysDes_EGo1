`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/06/02 09:22:52
// Design Name: 
// Module Name: display_7seg
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

/*数码管显示*/
module display_7seg(
        input clk,       	           //初始时钟(100MHz)
        input rst,                     
        input [15:0]data,              //需要显示的16bits数据，4bits对应一个数码管
        output reg [7:0] seg_data,     //经BCD处理后的显示数据(段码)
        output reg [3:0] seg_cs        //片选
    );

reg  	clk_500hz;              //用于刷新显示
integer clk_cnt;              //32??????¡À?????????¡¤???????????????0
always @(posedge clk or posedge rst)
begin
    if(rst)   
    begin    
        clk_500hz<=0;    
        clk_cnt<=0;           
    end
    else     
    begin
        if(clk_cnt>=100_000)            //¡Á???????¡¤???????
        begin
            clk_cnt<= 0;
            clk_500hz<=~clk_500hz;
        end
        else   
        begin   
            clk_cnt<= clk_cnt+1;
        end
    end 
end

//reg [3:0] seg_cs;                              //???????????¡§????reg
//???¡À500hz????????????????????,?????¡À??4??b0001
always@(posedge  clk_500hz or posedge rst)   
      if(rst)   seg_cs <= 4'b0001;           
      else      seg_cs <= {seg_cs [2:0], seg_cs [3]}; //??????????????
    
reg [3:0]dis_data;                         //?¨¨????????4??16????????
always@(seg_cs or data)                         //???¡À????????¡À?????2ms¡À?????
   case(seg_cs)
   4'b0001: dis_data <= data[3:0];    //????????????????????
   4'b0010: dis_data <= data[7:4]; 	
   4'b0100: dis_data <= data[11:8];
   4'b1000: dis_data <= data[15:12]; 
   default:  dis_data  <= 4'hf;                      //?????????????¨¢????
   endcase

//reg [7:0] seg_data;
 always @(dis_data )   //4-16????
     case(dis_data )
     04'h0: seg_data = 8'h3F;
     04'h1: seg_data = 8'h06;
     04'h2: seg_data = 8'h5B;
     04'h3: seg_data = 8'h4F;
     04'h4: seg_data = 8'h66;
     04'h5: seg_data = 8'h6D;
     04'h6: seg_data = 8'h7D;
     04'h7: seg_data = 8'h07;
     04'h8: seg_data = 8'h7F;
     04'h9: seg_data = 8'h6F;
     04'ha: seg_data = 8'h77;
     04'hb: seg_data = 8'h7C;
     04'hc: seg_data = 8'h39;
     04'hd: seg_data = 8'h5E;
     04'he: seg_data = 8'h79;
     04'hf: seg_data =  8'h40;//8'h71;
     default: seg_data = 8'hFF;
     endcase

endmodule