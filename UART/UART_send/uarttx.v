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

input clk;               //系统时钟
input clk_bd;            //UART时钟
input [7:0] datain;      //需要发送的数据
input wrsig;             //发送脉冲，上升沿有效
output busy;             //线路状态指示，高电平为忙
output tx;               //发送数据信号

reg  busy, tx;
reg  send; 
reg  wrsigbuf, wrsigrise;  //获取wrsig的上升沿
reg  presult;                     //存储校验位的
reg[7:0] cnt;                  //计数器

parameter  paritymode = 1'b0; //偶校验   

//检测发送命令，判断wrsig的上升沿
always @(posedge clk)
begin
   wrsigbuf <= wrsig;
   wrsigrise <= (~wrsigbuf) & wrsig;
end

always @(posedge clk)       //send信号管理
  if(wrsigrise &&  (~busy))
    send <= 1'b1;
  else if(cnt == 8'd168)  
    send <= 1'b0;

always @(posedge clk)
    if(send)  begin   
        if(clk_bd)   
        begin        //clk_bd有效时
            case(cnt)
                8'd0:  begin    tx <= 1'b0;  busy <= 1'b1; end
                8'd16: begin    tx <= datain[0];    //bit0
                  presult <= datain[0]^paritymode;end
                8'd32: begin    tx <= datain[1];    //bit1
                  presult <= datain[1]^presult; end
                8'd48: begin    tx <= datain[2];    //bit2
                  presult <= datain[2]^presult; end
                8'd64: begin    tx <= datain[3];    //bit3
                  presult <= datain[3]^presult; end
                8'd80: begin    tx <= datain[4];   //bit4
                  presult <= datain[4]^presult; end
                8'd96: begin      tx <= datain[5]; //bit5
                  presult <= datain[5]^presult;  end
                8'd112: begin    tx <= datain[6];  //bit6
                  presult <= datain[6]^presult;  end
                8'd128: begin    tx <= datain[7];  //bit7
                  presult <= datain[7]^presult;  end  
                8'd144:   tx <= presult;  //校验位            
                8'd160:   tx <= 1'b1;       //停止位
                8'd168:   busy <= 1'b0;  //一帧结束
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


