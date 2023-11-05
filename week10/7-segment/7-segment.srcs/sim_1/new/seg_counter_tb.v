`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/03 22:33:10
// Design Name: 
// Module Name: seg_counter_tb
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

module seg_counter_tb;
    reg clk,rst,btn;
    wire [7:0] seg;

    seg_counter uut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .seg(seg)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        btn = 0;

        #10 rst = 0;
        #10 rst = 1;

        #20;

        btn = 1;
        #10 btn = 0;
        #10 btn = 1;
        #10 btn = 0;
        #10 btn = 1;
        #10 btn = 0;
        #10 btn = 1;
        #10 btn = 0;
        #10 btn = 1;
        #10 btn = 0;
        #10 btn = 1;
        #10 btn = 0;
        #10 btn = 1;
        #10 btn = 0;
    end
endmodule
