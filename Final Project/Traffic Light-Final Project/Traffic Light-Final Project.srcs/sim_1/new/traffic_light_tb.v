`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 15:27:51
// Design Name: 
// Module Name: traffic_light_tb
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

module traffic_light_tb;
    reg clk;
    reg rst;
    reg [1:0] dip;
    reg ad_hour_btn;
    reg emergency_btn;
    wire LCD_E;
    wire LCD_RS;
    wire LCD_RW;
    wire [7:0] LCD_DATA;
    wire [3:0] S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN;
    wire [3:0] S_W_RED, N_W_RED, W_W_RED, E_W_RED;
    wire [3:0] S_GREEN, N_GREEN, W_GREEN, E_GREEN;
    wire [3:0] S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW;
    wire [3:0] S_RED, N_RED, W_RED, E_RED;
    wire [3:0] S_LEFT, N_LEFT, W_LEFT, E_LEFT;

    traffic_light uut (
        .clk(clk),
        .rst(rst),
        .dip(dip),
        .ad_hour_btn(ad_hour_btn),
        .emergency_btn(emergency_btn),
        .S_W_GREEN(S_W_GREEN),
        .N_W_GREEN(N_W_GREEN),
        .W_W_GREEN(W_W_GREEN),
        .E_W_GREEN(E_W_GREEN),
        .S_W_RED(S_W_RED),
        .N_W_RED(N_W_RED),
        .W_W_RED(W_W_RED),
        .E_W_RED(E_W_RED),
        .S_GREEN(S_GREEN),
        .N_GREEN(N_GREEN),
        .W_GREEN(W_GREEN),
        .E_GREEN(E_GREEN),
        .S_YELLOW(S_YELLOW),
        .N_YELLOW(N_YELLOW),
        .W_YELLOW(W_YELLOW),
        .E_YELLOW(E_YELLOW),
        .S_RED(S_RED),
        .N_RED(N_RED),
        .W_RED(W_RED),
        .E_RED(E_RED),
        .S_LEFT(S_LEFT),
        .N_LEFT(N_LEFT),
        .W_LEFT(W_LEFT),
        .E_LEFT(E_LEFT),
        .LCD_E(LCD_E),
        .LCD_RS(LCD_RS),
        .LCD_RW(LCD_RW),
        .LCD_DATA(LCD_DATA)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk <=0;
        rst <= 1;
        dip <= 2'b00;
        ad_hour_btn <= 0;
        emergency_btn <= 0;
        #10 rst <= 0;
    end
    
endmodule
