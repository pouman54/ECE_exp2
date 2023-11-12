`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/10 02:26:21
// Design Name: 
// Module Name: text_LCD_basic_tb
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

module text_LCD_basic_tb;
reg rst,clk;
wire LCD_E,LCD_RS,LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

text_LCD_basic uut (
    .rst(rst), 
    .clk(clk), 
    .LCD_E(LCD_E), 
    .LCD_RS(LCD_RS), 
    .LCD_RW(LCD_RW), 
    .LCD_DATA(LCD_DATA), 
    .LED_out(LED_out)
);

initial begin
    rst = 0;
    clk = 0;
    
    #10 rst = 1;

end

always #5 clk = ~clk;

endmodule
