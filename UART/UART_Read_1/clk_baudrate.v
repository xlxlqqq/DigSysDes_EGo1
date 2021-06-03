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


module clk_baudrate(
    clkin,
    rst_n,
    clkout);
    
input    clkin;
input    rst_n; 
output   clkout;
reg      clkout;

parameter   clks=100000000;   
parameter   baudrate = 9600;  
wire [31:0]cntmax;
integer  cnt;

assign    cntmax = (clks / baudrate / 16) - 1;           
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

