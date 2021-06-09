`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/06/09 10:17:06
// Design Name: 
// Module Name: number
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


module number(
    input   clk,rst,
    input   [31:0]data,
    output reg[7:0]seg_data,
    output reg[7:0]seg_data2,
    output reg[7:0]seg_cs
    );
reg clk_500hz;
integer clk_cnt;
always @(posedge clk or negedge rst) 
    begin
    if(!rst)
        begin
        clk_500hz<=0;
        clk_cnt<=0;
        end
    else
        begin
        if(clk_cnt>=100_000)
            begin
            clk_cnt<=0;
            clk_500hz<=~clk_500hz;
            end
        else
            begin
            clk_cnt<=clk_cnt+1;
            end
        end
    end

always @(posedge clk_500hz or negedge rst) 
    begin
    if(!rst) seg_cs<=8'b00000001;
    else    seg_cs<={seg_cs[6:0],seg_cs[7]};
    end

reg[7:0]dis_data;
always @(seg_cs) 
    begin
    case(seg_cs)
    8'b00000001:dis_data=data[3:0];
    8'b00000010:dis_data=data[7:4];
    8'b00000100:dis_data=data[11:8];
    8'b00001000:dis_data=data[15:12];
    8'b00010000:dis_data=data[19:16];
    8'b00100000:dis_data=data[23:20];
    8'b01000000:dis_data=data[27:24];
    8'b10000000:dis_data=data[31:28];
    default:dis_data=4'hf;
    endcase
    end

// reg [7:0] seg_data; 
always @(dis_data )
    begin
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
    04'he: seg_data = 8'h76;   //79¸Ä76HºÅ
    04'hf: seg_data = 8'h40;   //71¸Ä40-ºÅ
    default: seg_data = 8'h40;
    endcase
    case(dis_data )
    04'h0: seg_data2 = 8'h3F;
    04'h1: seg_data2 = 8'h06;
    04'h2: seg_data2 = 8'h5B;
    04'h3: seg_data2 = 8'h4F;
    04'h4: seg_data2 = 8'h66;
    04'h5: seg_data2 = 8'h6D;
    04'h6: seg_data2 = 8'h7D;
    04'h7: seg_data2 = 8'h07;
    04'h8: seg_data2 = 8'h7F;
    04'h9: seg_data2 = 8'h6F;
    04'ha: seg_data2 = 8'h77;
    04'hb: seg_data2 = 8'h7C;
    04'hc: seg_data2 = 8'h39;
    04'hd: seg_data2 = 8'h5E;
    04'he: seg_data2 = 8'h76;   //79æ�??76Hå?
    04'hf: seg_data2 = 8'h40;   //71æ�??40-å?
    default: seg_data2 = 8'h40;
    endcase
    end

endmodule
