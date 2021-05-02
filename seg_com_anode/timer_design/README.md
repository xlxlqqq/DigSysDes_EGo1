The project is made to design a floatLed.

#Design Step:
1.Get a clock signal from 100MHz signal, which is too fast to use.
  if you want the led to twinkle every second, you should divide the clk signal.
2.When the new clock signal changes, you make the last bit of LED_Pin to the first one or make the first bit to the last one.
3.Finally you can get floatLeds.

#Attention:
1.Design a Special pin to reset the floatLeds.
2.If you want design a floatLeds project which can be controled to float in a definately direction, define a direction pin.
