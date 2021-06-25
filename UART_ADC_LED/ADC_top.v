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
    input button_ad,
    input [7:0]button_led,
    input XADC_AUX_v_p,     //外部差动模拟输入通道
    input XADC_AUX_v_n,
    input send_ad_id,
    
    input    btn_S2,         //????°???
//    input    [7:0]sw_pin,    //×?×ó±?8??????
    input    PC_Uart_rxd,    // ???????? 
    
    output   PC_Uart_txd,
    
    output [7:0]seg_data_0_pin,
    output [3:0]seg_cs_0,
    output [7:0]led
    );

    wire [6:0]addr;            //访问寄存器的地址
    reg  den;                  //DRP总线有效控制信号
    wire ready;                //DRP数据准备好指示信号
    wire [15:0]data;           //输出数据的16位总线


assign led = button_led;

xadc_wiz_0 u1(
          .daddr_in(addr),           // Address bus for the dynamic reconfiguration port
          .dclk_in(clk),             // Clock input for the dynamic reconfiguration port
          .den_in(den),              // Enable Signal for the dynamic reconfiguration port
          .di_in(),                  // Input data bus for the dynamic reconfiguration port
          .dwe_in(1'b0),             // Write Enable for the dynamic reconfiguration port
          .reset_in(!rst_n),         // Reset signal for the System Monitor control logic
          .vauxp1(XADC_AUX_v_p),     // Auxiliary channel 1
          .vauxn1(XADC_AUX_v_n),
          .busy_out(),               // ADC Busy signal
          .channel_out(),            // Channel Selection Outputs
          .do_out(data),             // Output data bus for dynamic reconfiguration port
          .drdy_out(ready),          // Data ready signal for the dynamic reconfiguration port
          .eoc_out(),                // End of Conversion Signal
          .eos_out(),                // End of Sequence Signal
          .alarm_out(),              // OR'ed output of all the Alarms    
          .vp_in(),                  // Dedicated Analog Input Pair
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

reg [7:0] ad_dis_UART[13:0];
always @(*) //??????????·?????×?·???
begin     //?¨??·?????×?·?
    ad_dis_UART[0] <= Units + 48;                            //????×?·?H
    ad_dis_UART[1] <= 46;                            //????×?·?e
    ad_dis_UART[2] <= decimal1 +48;                            //????×?·?l
    ad_dis_UART[3] <= decimal2 +48;                            //????×?·?l
    ad_dis_UART[4] <= decimal3 +48;                            //????×?·?o                         
    ad_dis_UART[5] <= 32;                            //????×?·?????
    ad_dis_UART[6] <= 32;                            //????×?·?W
    ad_dis_UART[7] <= 32;                            //????×?·?o
    ad_dis_UART[8] <= 32;                            //????×?·?r
    ad_dis_UART[9] <= 32;                            //????×?·?l
    ad_dis_UART[10] <= 32;                           //????×?·?d
    ad_dis_UART[12] <= 13;                           //????·?
    ad_dis_UART[13] <= 10;                           //????·?
end

reg ad_display;

always @(*)
begin
    if(button_ad)
        ad_display <= 1;
    else
        ad_display <= 0;
end

reg send_ad,send_id;

always @(*)
begin
    if(send_ad_id)
    begin
        send_ad <= 1;
    end
    else
        send_ad <= 0;
end

display_7seg u2(
    .clk(clk),
    .rst_n(rst_n),
    .data(dis_data),
    .seg_on(ad_display),
    .seg_data(seg_data_0_pin),
    .seg_cs(seg_cs_0)
);


wire  btn_rise_pulse;
btn_rise_edge  
    u3(
        .clk(clk),
        .rst_n(rst_n),
        .btn(btn_S2),
        .btn_rise_pulse(btn_rise_pulse)
    );
    
    wire   clk_bd;
clk_baudrate #(.clks(100000000),.baudrate(9600))  
    u4(	
        .clkin(clk),
        .rst_n(rst_n),
        .clkout(clk_bd)
	);

wire timer_2ms_en;
clk_baudrate #(.clks(100000000),.baudrate(30))     
    u5(
        .clkin(clk),
        .rst_n(rst_n),
        .clkout(timer_2ms_en)
    );


reg [7:0] store [13:0];              //????·???×?·?
always @(*) //??????????·?????×?·???
begin     //?¨??·?????×?·?
/*
    store[0] <= 72;                            //????×?·?H
    store[1] <= 101;                           //????×?·?e
    store[2] <= 108;                           //????×?·?l
    store[3] <= 108;                           //????×?·?l
    store[4] <= 111;                           //????×?·?o                         
    store[5] <= 32;                            //????×?·?????
    store[6] <= 87;                            //????×?·?W
    store[7] <= 111;                           //????×?·?o
    store[8] <= 114;                           //????×?·?r
    store[9] <= 108;                           //????×?·?l
    store[10] <= 100;                          //????×?·?d
    store[11] <= 32;                           //????×?·?????
    store[12] <= 13;                           //????·?
    store[13] <= 10;                           //????·?
*/

    store[0] <= 51;                            //????×?·?3
    store[1] <= 48;                            //????×?·?0
    store[2] <= 49;                            //????×?·?1
    store[3] <= 57;                            //????×?·?9
    store[4] <= 50;                            //????×?·?2                      
    store[5] <= 48;                            //????×?·0
    store[6] <= 50;                            //????×?·?2
    store[7] <= 48;                            //????×?·?0
    store[8] <= 53;                            //????×?·?5
    store[9] <= 57;                            //????×?·?9
    store[10] <= 32;                           //????×?·?space
    store[11] <= 32;                           //????×?·?????
    store[12] <= 13;                           //????·?
    store[13] <= 10;                           //????·?
end


reg  state;              //?????±?°×???
reg [3:0]txd_p;          //·???????????
reg [7:0]txdata1;         //??·?????????
reg [7:0]txdata2;
reg wrsig;               //·???????·?????
parameter IDLE=1'b0,SEND=1'b1;   //×???????
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)   
    begin 
        state <= IDLE; 
        txd_p <= 0; 
        wrsig <= 0;   
    end
    else 
        case(state)
        IDLE:   
        begin   wrsig<=0;
             if( btn_rise_pulse )  state <= SEND;
        end         
        SEND: if(timer_2ms_en)  
        begin
            if(txd_p == 13) 
            begin    
                txdata1 <= store[txd_p];
                txdata2 <= ad_dis_UART[txd_p];                
                wrsig <= 1; 
                txd_p <= 0;  
                state <= IDLE; 
            end 
            else
            begin
                txdata1 <= store[txd_p];
                txdata2 <= ad_dis_UART[txd_p];
                wrsig <= 1;
                txd_p <= txd_p + 1;
            end
        end
        else  wrsig <= 0;
        endcase
end
      
uarttx u6(
        .clk(clk), 
        .clk_bd(clk_bd),  
        .datain_sel(send_ad), 
        .datain_1(txdata1), 
        .datain_2(txdata2), 
        .wrsig(wrsig), 
        .busy(), 
        .tx(PC_Uart_txd)
        ); 
  
endmodule

