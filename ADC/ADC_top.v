`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tianjin University
// Engineer: xlxlqqq
// 
// Create Date: 2021/06/05 13:31:53
// Design Name: 
// Module Name: ADC_top
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


module ADC_top(
    input clk,
    input rst_n,
    input XADC_AUX_v_p,     //外部差动模拟输入通道
    input XADC_AUX_v_n,
    output [7:0]seg_data_0_pin,
    output [3:0]seg_cs_0
    );

    wire [6:0]addr;       //访问寄存器的地址
    reg  den;                  //DRP总线有效控制信号
    wire ready;             //DRP数据准备好指示信号
    wire [15:0]data;     //输出数据的16位总线

xadc_wiz_0 u1(
          .daddr_in(addr),           // Address bus for the dynamic reconfiguration port
          .dclk_in(clk),             // Clock input for the dynamic reconfiguration port
          .den_in(den),              // Enable Signal for the dynamic reconfiguration port
          .di_in(),                  // Input data bus for the dynamic reconfiguration port
          .dwe_in(1'b0),             // Write Enable for the dynamic reconfiguration port
          .reset_in(!rst_n),         // Reset signal for the System Monitor control logic
          .vauxp1(XADC_AUX_v_p),     // Auxiliary channel 1
          .vauxn1(XADC_AUX_v_n),
          .busy_out(),            // ADC Busy signal
          .channel_out(),         // Channel Selection Outputs
          .do_out(data),              // Output data bus for dynamic reconfiguration port
          .drdy_out(ready),            // Data ready signal for the dynamic reconfiguration port
          .eoc_out(),             // End of Conversion Signal
          .eos_out(),             // End of Sequence Signal
          .alarm_out(),           // OR'ed output of all the Alarms    
          .vp_in(),               // Dedicated Analog Input Pair
          .vn_in());
          
 assign addr = 7'h11;
 reg [15:0]ad_data;
 always@(posedge clk or negedge rst_n)
 begin
    if(!rst_n)
        den <= 0;
    else if(ready)
    begin
        den <= 0;
        ad_data = data;
    end
    else
        den <= 1;
 end
 
 integer clk_cnt;
 reg clk_2Hz;
 
 
 always @(posedge clk or negedge rst_n)
 begin
    if(!rst_n)
    begin
        clk_cnt <= 0;
        clk_2Hz <= 0;
    end
    else
    begin
        if(clk_cnt >= 32'd50000000)
        begin
            clk_cnt <= 0;
            clk_2Hz <= 1'b1;
        end    
        else
        begin
            clk_cnt <= clk_cnt + 1;
            clk_2Hz <= 1'b0;
        end
    end
 end

reg[3:0] Units, decimal1, decimal2, decimal3;
reg[15:0] dis_data;

always@(posedge clk or negedge rst_n) 
begin
    if(!rst_n)   
    dis_data<=0;
    else if(clk_2Hz)
    begin
        if(ad_data[15:4]==12'hfff) 
        begin 
            Units <= 1;
            decimal1 <= 0;
            decimal2 <= 0;
            decimal3 <= 0;
        end
        else
        begin
        Units <= 0;
        decimal1 <= ad_data[15:4]*10/4096;
        decimal2 <= (ad_data[15:4]*10 - (ad_data[15:4]*10/4096*4096))*10/4096;
        decimal3 <= (ad_data[15:4]*100 - (ad_data[15:4]*10/4096)*4096*10 -  
             ((ad_data[15:4]*10 - (ad_data[15:4]*10/4096*4096))*10/4096)*4096)*10/4096;
        end
        
        dis_data <= Units * 4096 + decimal1 * 256 + decimal2 * 16 + decimal3;
    end
end

 
 display_7seg u2(
        .clk(clk),
        .rst_n(rst_n),
        .data(dis_data),
        .seg_data(seg_data_0_pin),
        .seg_cs(seg_cs_0)
 );
  
endmodule

