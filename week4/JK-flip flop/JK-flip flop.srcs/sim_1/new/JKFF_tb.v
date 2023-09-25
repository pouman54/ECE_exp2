`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 15:08:20
// Design Name: 
// Module Name: JKFF_tb
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

module JKFF_tb;  
   reg j,k;
   reg clk=0;
   wire q;
   always #5 clk = ~clk;  
  
  JKFF FF(j,k,clk,q); 
  
   initial begin  
      j <= 0;  
      k <= 0;  
      #30 j <= 0;  
         k <= 1;  
      #30 j <= 0;  
          k <= 0;  
      #30 j <= 1;  
          k <= 0;
      #30 j <= 0;  
          k <= 0;
      #30 j <= 1;  
          k <= 1;
      #30 j <= 0;  
          k <= 0;
   end  
endmodule  