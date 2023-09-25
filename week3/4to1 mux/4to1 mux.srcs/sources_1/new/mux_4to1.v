`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/18 10:00:50
// Design Name: 
// Module Name: mux_4to1
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


module mux_4to1(I0,I1,I2,I3,S0,S1,A, B);
input [1:0] I0,I1,I2,I3;
input S0,S1;
output A, B;

assign {A,B} = S1 ? (S0 ? I3:I2):(S0 ? I1:I0);

endmodule
