`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 14:54:26
// Design Name: 
// Module Name: DFF_tb
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


module DFF_tb( );
reg clk, D;
wire Q;
DFF FF(clk,D,Q);

initial begin
    clk<=0;
    #30 D<=0;
    #30 D<=1;
    #30 D<=0;
    #30 D<=1;
    #30 D<=0;
    #30 D<=1;
    #30 D<=0;
end

always begin
    #5 clk<=~clk;
end
endmodule
