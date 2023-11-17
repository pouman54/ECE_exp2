`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/15 00:59:00
// Design Name: 
// Module Name: LCD_cursor_tb
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

module LCD_cursor_tb;
    reg clk, rst;
    reg [9:0] number_btn;
    reg [1:0] control_btn;
    wire LCD_E,LCD_RS,LCD_RW;
    wire [7:0] LCD_DATA;
    wire [7:0] LED_out;

    LCD_cursor uut(rst,clk,LCD_E,LCD_RS,LCD_RW,LCD_DATA,LED_out,number_btn,control_btn);

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        rst = 0;
        number_btn = 10'b0;
        control_btn = 2'b00;
        #10 rst = 1;
        
        #100000 number_btn = 10'b1000_0000_00; // 숫자버튼 1 누름
        #100000 number_btn = 10'b0; // 버튼 떼기
        #100000 number_btn = 10'b0100_0000_00; // 숫자버튼 2 누름
        #100000 number_btn = 10'b0; // 버튼 떼기
        #100000 control_btn = 2'b10; // 왼쪽 쉬프트 버튼 누름
        #100000 control_btn = 2'b00; // 버튼 떼기
        #100000 control_btn = 2'b01; // 오른쪽 쉬프트 버튼 누름
        #100000 control_btn = 2'b00; // 버튼 떼기
    end

endmodule
