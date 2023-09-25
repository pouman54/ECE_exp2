`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 14:53:50
// Design Name: 
// Module Name: mux_8X1_tb
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


module mux_8X1_tb();
reg [3:0] I0,I1,I2,I3,I4,I5,I6,I7;
reg S0,S1,S2;
wire Y;
mux_8X1 mux(I0,I1,I2,I3,S0,S1,Y);

initial begin
         S1 = 0; S0 = 0;
         I0 = 4'b0000; I1 = 4'b0010; I2 = 4'b0100; I3 = 4'b1000;
    #100 S1 = 0; S0 = 1;
    #100 S1 = 1; S0 = 0;
    #100 S1 = 1; S0 = 1;
    #100 S1 = 0; S0 = 0;
end
endmodule
