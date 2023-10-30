`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 21:35:43
// Design Name: 
// Module Name: SM2_tb
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


module SM2_tb;
    reg clk, rst, A, B, C;
    wire [2:0] state;
    wire y;

    SM2 dut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .C(C),
        .state(state),
        .y(y)
    );
    
initial begin
    clk = 0;
    rst = 0;
    A = 0;
    B = 0;
    C = 0;
    
    #10 rst = 1;
    
    #20 A = 1;
    #10 A = 0;
    #20 B = 1;
    #10 B = 0;
    #20 A = 1;
    #10 A = 0;
    #20 B = 1;
    #10 B = 0;
    #20 C = 1;
    #10 C = 0;
    
    #20 rst = 0;
    #10 rst = 1;
    
    #20 A = 1;
    #10 A = 0;
    #20 B = 1;
    #10 B = 0;
    #20 C = 1;
    #10 C = 0;
end

always begin
    #5 clk = ~clk;
end

endmodule
