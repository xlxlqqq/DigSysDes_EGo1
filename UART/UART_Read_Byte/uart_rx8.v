`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/06/02 09:01:13
// Design Name: 
// Module Name: uart_rx8
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

/*主模块*/
module uart_rx8(input clk,
                input    rst_n,
                output   [7:0]seg_data_0_pin,
                output   [7:0]seg_data_1_pin,
                output   [3:0]seg_cs_0,
                output   [3:0]seg_cs_1,
                input    PC_Uart_rxd,  // EGo1的RX 
                output   PC_Uart_txd); // EGo1的TX        

wire  clk_bd;
wire [7:0]dataout;
wire rd;
reg   rdbuf,rdfall;   //为了得到rx的下降沿而设置
reg   [7:0]rx_data_buf[0:3];
reg   [1:0]rx_dp;

clk_baudrate #(.clks(100000000),.baudrate(9600)) 
u1( .clkin(clk),
    .rst_n(rst_n),
    .clkout(clk_bd));

uartrx u2(	.clk(clk),
            .clk_bd(clk_bd),
            .rx(PC_Uart_rxd),
            .dataout(dataout),
            .rdsig(rd),
            .dataerror(),
            .frameerror());

/*得到RX信号的下降沿，意味着传输的开始*/
always @(posedge clk) 
begin
    rdbuf  <= rd;
    rdfall <= rdbuf & (~rd);
end

/**/
always@(posedge clk or negedge rst_n)
if(!rst_n)
begin 
    rx_dp<=2'b00; 
    rx_data_buf[0] <= 8'h00;
    rx_data_buf[1] <= 8'h00;
    rx_data_buf[2] <= 8'h00;
    rx_data_buf[3] <= 8'h00;
end         
else if(rdfall) 
begin
    rx_data_buf[rx_dp] <= dataout;    
    if(rx_dp >= 2'b11)
        rx_dp <= 2'b00;
    else
        rx_dp <= rx_dp+1'b1;
end

wire  [15:0]dis_data[0:1];
assign dis_data[0] = {rx_data_buf[0],rx_data_buf[1]};
assign dis_data[1] = {rx_data_buf[2],rx_data_buf[3]};

display_7seg u3(.clk(clk),
    .rst(~rst_n),
    .data(dis_data[0]),
    .seg_data(seg_data_0_pin),
    .seg_cs(seg_cs_0) );

display_7seg  u4(.clk(clk),
    .rst(~rst_n),
    .data(dis_data[1]),
    .seg_data(seg_data_1_pin),
    .seg_cs(seg_cs_1) );
    
endmodule




