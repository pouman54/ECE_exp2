`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 14:47:38
// Design Name: 
// Module Name: half_adder2
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

module half_adder(a,b,sum,cout);
input a,b;
output reg sum,cout; // sum and carry

  
always @(*)
  begin 
  case ({a,b})
  3'b00: sum = 0;
  3'b01: sum = 1;
  3'b10: sum = 1;
  3'b11: sum = 0;
  default : sum = 0;
  endcase 
  
  case ({a,b})
  3'b00: cout = 0;
  3'b01: cout = 0;
  3'b10: cout = 0;
  3'b11: cout = 1;
  default : cout = 0;
  endcase 
  end  
endmodule

