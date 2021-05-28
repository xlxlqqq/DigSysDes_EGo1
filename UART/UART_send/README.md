Company: Tianjin University
Engineer: xlxlqqq

本项目用来实现从EGo1向PC端口发送按键信息

按键功能：
SW7-0:    按键表示的综合数字将会被发送到PC
S2：      当按键的状态确定了之后，按下S2，就可以完成发送
RESET：   复位键

PC+EGo1波特率：   9600

串口调试助手： HEX显示模式

子Module：
btn_rise_edge: 按键消抖，以及按键下降沿产生
clk_baudrate:  产生一个9600的波特率
uart_tx1:      主程序
uarttx:				 获取按键组的状态，存入一个八位变量中，并且逐位push到TX端口上
UART_constraints:  端口约束



