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

module encoder_4to3(x,y);
input [3:0] x;
output reg[2:0] y;
  
  always @*
  begin
    case (x)
      4'b0000: y = 3'b000;
      4'b0001: y = 3'b001;
      4'b0010: y = 3'b011;
      4'b0011: y = 3'b011;
      4'b0100: y = 3'b101;
      4'b0101: y = 3'b101;
      4'b0110: y = 3'b101;
      4'b0111: y = 3'b101;
      4'b1000: y = 3'b111;
      4'b1001: y = 3'b111;
      4'b1010: y = 3'b111;
      4'b1011: y = 3'b111;
      4'b1100: y = 3'b111;
      4'b1101: y = 3'b111;
      4'b1110: y = 3'b111;
      4'b1111: y = 3'b111;
      default: y = 3'b000;
    endcase
  end
endmodule

