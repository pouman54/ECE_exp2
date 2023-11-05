`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 23:27:03
// Design Name: 
// Module Name: counter_2bit_tb
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

module counter_2bit_tb;
  reg clk,rst,x;
  wire [1:0] state;

  counter_2bit dut (
    .clk(clk),
    .rst(rst),
    .x(x),
    .state(state)
  );

  always begin
    #5 clk = ~clk;
  end

  initial begin
    // Initialize signals
    clk = 0;
    rst = 0;
    x = 0;

    // Release reset
    #10 rst = 1;

    // Count sequence
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
end
endmodule

