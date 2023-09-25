`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 14:22:52
// Design Name: 
// Module Name: encoder_4X3
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

module encoder_4to3(x,y,v,D);
input [3:0] D;
output x,y,v;
wire x,y,v;
  
assign x=D[2]|D[3];
assign y=D[1]&(~D[2])|D[3];
assign v=D[3]|D[2]|D[1]|D[0];
endmodule

