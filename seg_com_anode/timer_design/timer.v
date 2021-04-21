`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/04/21 10:21:57
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
    output [7:0] seg_data_1,
    output [7:0] seg_data_2,
    output [3:0] seg_cs_1,
    output [3:0] seg_cs_2
    );

integer timer_cnt;
reg [16:0] seconds;
always @(posedge clk or posedge rst)
begin
    if(rst)   
    begin      
        timer_cnt <= 0; 
        seconds <= 0;
    end
    else if(timer_cnt>=100_000_000) 
    begin
        timer_cnt<=0;
        if(seconds>=86399)  
            seconds <=0;
        else        
            seconds <= seconds +1; 
    end
    else timer_cnt<=timer_cnt+1;
end
    
wire [15:0]data1;
wire [15:0]data2;
wire [5:0] H,M,S;
assign H = seconds /3600; 
assign M = (seconds-H*3600)/60;
assign S = (seconds-H*3600- M*60);
assign data2[15:12] = H/10;
assign data2[11:8]  = H-data2[15:12]*10;
assign data2[7:4]   = 15; 
assign data2[3:0]   = M/10;
assign data1[15:12] = M-data2[3:0]*10;
assign data1[11:8]  = 15;
assign data1[7:4]   = S/10;
assign data1[3:0]   = S-data1[7:4]*10;

time_design  u1(  
    .clk(clk),
    .rst(rst),
    .data(data1),
    . seg_data(seg_data_1),
    . seg_cs(seg_cs_1)  
);

time_design  u2(  
    .clk(clk),
    .rst(rst),
    .data(data2),
    .seg_data(seg_data_2),
    .seg_cs(seg_cs_2)
);

endmodule
