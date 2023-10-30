`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 15:28:32
// Design Name: 
// Module Name: SM1_tb
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
module SM1_tb;
  reg clk,rst,x;
  wire [1:0] state;
  wire y;

  SM1 dut (
    .clk(clk),
    .rst(rst),
    .x(x),
    .y(y),
    .state(state)
  );

  initial begin
    clk = 0;
    rst = 1;
    x = 0;

    #10 rst = 0;
    #10 rst = 1;
  end

  always #5 clk = ~clk;

endmodule



