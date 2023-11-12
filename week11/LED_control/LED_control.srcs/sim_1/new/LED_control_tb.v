`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 15:10:02
// Design Name: 
// Module Name: LED_control_tb
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

module LED_control_tb();
reg clk, rst;
reg [7:0] bin;
wire [7:0] seg_data;
wire [7:0] seg_sel;
wire led_signal;

LED_control uut (
  .clk(clk),
  .rst(rst),
  .bin(bin),
  .seg_data(seg_data),
  .seg_sel(seg_sel),
  .led_signal(led_signal)
);

initial begin
    clk=0;
    rst=0;
    #10 bin=8'b00000000;
    
    #1e+5 rst<=1;
    
    #1e+5 rst<=0;
    #1e+6 bin <= 8'b01000000;
    #1e+6 bin <= 8'b10000000;
    #1e+6 bin <= 8'b11000000;
    #1e+6 bin <= 8'b11111111;
  
end
always #0.5 clk <= ~clk;

endmodule
