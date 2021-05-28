`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/05/26 11:07:50
// Design Name: 
// Module Name: uart_tx1
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
承担调用任务的主函数
*/
module uart_tx1( 
    input    clk,            //100MHz时钟
    input    rst_n,          //复位
    input    btn_S2,         //Send按键状态
    input    [7:0]sw_pin,    //Switch组状态
    input    PC_Uart_rxd,    //接受位
    output   PC_Uart_txd     //发送位
    );                       

wire btn_rise_pulse;

btn_rise_edge  u1(           //判断按键是否有下降沿
        .clk(clk),
        .rst_n(rst_n),
        .btn(btn_S2),
        .btn_rise_pulse(btn_rise_pulse)
    );

wire clk_bd;
                     
clk_baudrate #(.clks(100000000),
               .baudrate(9600))
                u2(.clkin(clk),
                   .rst_n(rst_n),
                   .clkout(clk_bd));

wire busy;

uarttx u3(.clk(clk),
          .clk_bd(clk_bd),               //16倍波特率时钟
          .datain(sw_pin),               //按键组的状态
          .wrsig(btn_rise_pulse),        
          .busy(busy),                   
          .tx(PC_Uart_txd));

endmodule



