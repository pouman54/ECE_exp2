`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 16:16:43
// Design Name: 
// Module Name: FA
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

module FA(x,y,z,s,c);

input x,y,z;
output s,c;
wire s,c;
wire s1,c1,c2;

HA u1(x,y,s1,c1);
HA u2(z,s1,s,c2);

assign c=c1 | c2;

endmodule
