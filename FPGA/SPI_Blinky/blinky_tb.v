`timescale 1ns/1ns

module blinky_tb;
reg clk;
wire LED1, LED2, LED3, LED4, LED5;

{LED1, LED2, LED3, LED4, LED5} = 0;


initial begin
    clk = 0;
end

blinky test_blink(clk, LED0, LED1, LED2, LED3, LED4);

always #1 clk = !clk;

endmodule