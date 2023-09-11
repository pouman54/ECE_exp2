`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 12:30:30
// Design Name: 
// Module Name: logic_gate
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

module logic_gate(a,b,c,d,e,f,g);
input a,b;
output c,d,e,f,g;
wire c,d,e,f,g;

assign c = a & b;
assign d = a | b;
assign e = a ^ b;
assign f = ~(a | b);
assign g = ~(a & b);

endmodule
