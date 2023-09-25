`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 14:34:56
// Design Name: 
// Module Name: encoder_4X3_tb
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


module encoder_4X3_tb();
reg [3:0] D;
wire x,y,v;
encoder_4to3 ec(x,y,v,D);
initial begin
         D=4'b0000;
    #100 D=4'b1000;
    #100 D=4'b1011;
    #100 D=4'b0101;
    #100 D=4'b0001;
end
endmodule
