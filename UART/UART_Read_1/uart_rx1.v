`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin Univerity
// Engineer: xlxlqqq
// 
// Create Date: 2021/06/02 08:46:51
// Design Name: 
// Module Name: uart_rx1
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


module uart_rx1(
    input    clk,            // 100Mhz 
    input    rst_n,          //复位
    input    btn_S2,         //没用到
    output   [7:0]led,       //显示数据
    input    PC_Uart_rxd,    // 串口接收 
    output   PC_Uart_txd);   // 串口发送

wire  clk_bd;
clk_baudrate #(.clks(100000000),.baudrate(9600))
        u2( .clkin(clk),
            .rst_n(rst_n),
            .clkout(clk_bd));
        
wire [7:0]dataout;
wire rd;

uartrx  u5(
    .clk(clk),
	.clk_bd(clk_bd),
	.rx(PC_Uart_rxd),
	.dataout(dataout),
	.rdsig(rd),
	.dataerror(),
	.frameerror());

assign led = dataout;
endmodule

