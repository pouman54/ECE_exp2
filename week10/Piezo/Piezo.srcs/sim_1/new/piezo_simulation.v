`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/04 17:36:16
// Design Name: 
// Module Name: piezo_simulation
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

module piezo_basic_tb();

reg clk, rst;
reg [7:0] btn;
wire piezo;

piezo_basic p1(clk, rst, btn, piezo);

initial begin
    clk <=0;
    rst <=1;
    btn <= 8'b00000000;
    #1e+6; rst <= 0;
    #1e+6; rst <= 1;
    #1e+6; btn <= 8'b00000001;
    #1e+6; btn <= 8'b00000010;
    #1e+6; btn <= 8'b00000100;
    #1e+6; btn <= 8'b00001000;
    #1e+6; btn <= 8'b00010000;
    #1e+6; btn <= 8'b00100000;
    #1e+6; btn <= 8'b01000000;
    #1e+6; btn <= 8'b10000000;
end

always begin
    #0.5 clk <= ~clk;
end

endmodule
