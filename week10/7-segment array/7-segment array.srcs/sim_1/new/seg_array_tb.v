`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 16:16:03
// Design Name: 
// Module Name: seg_array_tb
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

module seg_array_tb;
    reg clk,rst,btn;
    wire [7:0] seg_data;
    wire [7:0] seg_sel;

    seg_array uut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .seg_data(seg_data),
        .seg_sel(seg_sel)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        btn = 0;

        #10 rst = 0;
        #10 rst = 1;

        #120 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
        #60 btn = 1;
        #20 btn = 0;
    end
endmodule
