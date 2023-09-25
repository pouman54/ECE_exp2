`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/18 10:01:24
// Design Name: 
// Module Name: mux_4to1_tb
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


module mux_4to1_tb();
reg [3:0] I0,I1,I2,I3;
reg S0,S1;
wire Y;
mux_4to1 mux(I0,I1,I2,I3,S0,S1,Y);

initial begin
         S1 = 0; S0 = 0;
         I0 = 4'b00; I1 = 4'b01; I2 = 4'b10; I3 = 4'b11;
    #100 S1 = 0; S0 = 1;
    #100 S1 = 1; S0 = 0;
    #100 S1 = 1; S0 = 1;
    #100 S1 = 0; S0 = 0;
end
endmodule
