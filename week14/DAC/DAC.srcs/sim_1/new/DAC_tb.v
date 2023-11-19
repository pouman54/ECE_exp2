`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 14:25:27
// Design Name: 
// Module Name: DAC_tb
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

module testbench;
  reg clk,rst, add_sel;
  reg [8:0] btn;
  wire dac_csn, dac_ldacn, dac_wrn, dac_a_b;
  wire [7:0] dac_d;
  wire [7:0] led_out;

  DAC uut (
    .clk(clk), 
    .rst(rst), 
    .btn(btn), 
    .add_sel(add_sel), 
    .dac_csn(dac_csn), 
    .dac_ldacn(dac_ldacn), 
    .dac_wrn(dac_wrn), 
    .dac_a_b(dac_a_b), 
    .dac_d(dac_d), 
    .led_out(led_out)
  );

  always begin
    #5 clk = ~clk;
  end

  initial begin
   clk = 0;
   rst = 0;
   add_sel = 0;
   btn = 9'b000000000;
   #50 rst = 1;
   #10 btn = 9'b000000001;
   #10 btn = 9'b000000100;
   #10 btn = 9'b000001000;
   #10 btn = 9'b000100000;
   #10 btn = 9'b001000000;
   #10 btn = 9'b100000000;
  end

endmodule
