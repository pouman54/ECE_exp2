`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 15:07:54
// Design Name: 
// Module Name: JKFF
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

module JKFF(j,k,clk,q);
input j,k,clk;
output reg q;
  
   always @ (posedge clk)  
      case ({j,k})  
         2'b00 :  q <= q;  
         2'b01 :  q <= 0;  
         2'b10 :  q <= 1;  
         2'b11 :  q <= ~q;  
      endcase  
endmodule  