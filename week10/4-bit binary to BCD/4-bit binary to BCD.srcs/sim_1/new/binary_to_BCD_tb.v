`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/03 14:31:28
// Design Name: 
// Module Name: binary_to_BCD_tb
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

module binary_to_BCD_tb;
    reg clk,rst;
    reg [3:0] bin;
    wire [7:0] bcd;

    binary_to_BCD uut (
        .clk(clk), 
        .rst(rst), 
        .bin(bin), 
        .bcd(bcd)
    );

    initial begin
        clk = 0;
        rst = 0;
        bin = 0;

        #10 rst = 1;

        #10 bin = 1;
        #10 bin = 2;
        #10 bin = 3;
        #10 bin = 4;
        #10 bin = 5;
        #10 bin = 6;
        #10 bin = 7;
        #10 bin = 8;
        #10 bin = 9;
        #10 bin = 10;
        #10 bin = 11;
        #10 bin = 12;
        #10 bin = 13;
        #10 bin = 14;
        #10 bin = 15;
    end
    always #5 clk = ~clk;

endmodule
