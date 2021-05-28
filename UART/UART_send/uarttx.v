`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/05/26 10:58:02
// Design Name: 
// Module Name: uarttx
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


module uarttx(clk,clk_bd,datain, wrsig, busy, tx);

input clk;               
input clk_bd;            
input [7:0] datain;      //需要发送的数据(来自按键拨码状态)
input wrsig;             //发送指令，上升沿有效
output busy;             //忙碌
output tx;               //发送端口

reg  busy, tx;
reg  send; 
reg  wrsigbuf, wrsigrise;         //辅助判断是否有上升沿
reg  presult;                     //校验位
reg[7:0] cnt;                     //计数

parameter  paritymode = 1'b0; //Å

//检测按键的上升沿，是否需要发送命令
always @(posedge clk)
begin
   wrsigbuf <= wrsig;
   wrsigrise <= (~wrsigbuf) & wrsig;
end

always @(posedge clk)       //获得上升沿并且空闲的时候
  if(wrsigrise &&  (~busy))
    send <= 1'b1;
  else if(cnt == 8'd168)  
    send <= 1'b0;

always @(posedge clk)
    if(send)       //确认获得了send指令
    begin
        if(clk_bd)   
        begin        //具体需要发送的数据
            case(cnt)
                8'd0:  
                begin    
                  tx <= 1'b0;     //开始位
                  busy <= 1'b1;   //Busy位
                end
                8'd16: begin    tx <= datain[0];    //bit0
                  presult <= datain[0]^paritymode;end
                8'd32: begin    tx <= datain[1];    //bit1
                  presult <= datain[1]^presult; end
                8'd48: begin    tx <= datain[2];    //bit2
                  presult <= datain[2]^presult; end
                8'd64: begin    tx <= datain[3];    //bit3
                  presult <= datain[3]^presult; end
                8'd80: begin    tx <= datain[4];    //bit4
                  presult <= datain[4]^presult; end
                8'd96: begin      tx <= datain[5];  //bit5
                  presult <= datain[5]^presult;  end
                8'd112: begin    tx <= datain[6];   //bit6
                  presult <= datain[6]^presult;  end
                8'd128: begin    tx <= datain[7];   //bit7
                  presult <= datain[7]^presult;  end  
                8'd144:   tx <= presult;  //存入校验位
                8'd160:   tx <= 1'b1;     //停止位
                8'd168:   busy <= 1'b0;   //busy清零
                //default:
            endcase
            cnt <= cnt + 8'd1;
        end
    end
    else
    begin    
        tx <= 1'b1;
        cnt <= 8'd0;
        busy <= 1'b0;  
    end                  
endmodule


