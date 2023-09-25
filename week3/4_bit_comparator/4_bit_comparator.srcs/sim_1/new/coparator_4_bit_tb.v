`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 13:17:07
// Design Name: 
// Module Name: coparator_4_bit_tb
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


module coparator_4_bit_tb();
reg[3:0] a,b;
wire x,y,z;

comparator_4_bit cp(a,b,x,y,z);
initial begin
          a = 4'b0011; b = 4'b1000;
    #100; a = 4'b0111; b = 4'b0001;
    #100; a = 4'b1001; b = 4'b1001;
    #100; a = 4'b1011; b = 4'b1111;
end
endmodule
