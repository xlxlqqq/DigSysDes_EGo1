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


module uart_tx1( 
    input    clk,            //100Mhz 
    input    rst_n,          //复位
    input    btn_S2,         //中间按钮
    input    [7:0]sw_pin,    //最左边8位拨码
    input    PC_Uart_rxd,    // 串口接收 
    output   PC_Uart_txd
    );                       // 串口发送    

wire btn_rise_pulse;

btn_rise_edge  u1(           //调用一个模块延时去抖检测按键上升沿，
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
          .clk_bd(clk_bd),               //波特率16倍时钟
          .datain(sw_pin),               //拨码开关值作为发送的数据
          .wrsig(btn_rise_pulse),        //按键上升沿脉冲作为发送写信号
          .busy(busy),                   //不用的信号可以空着
          .tx(PC_Uart_txd));             //串口发送管脚，与约束文件一致   

endmodule



