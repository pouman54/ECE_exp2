`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 14:06:00
// Design Name: 
// Module Name: decoder_3X8_tb
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


module decoder_3X8_tb();
reg x,y,z;
wire [7:0] D;
decoder_3X8 dc(x,y,z,D);

initial begin
         x=0; y=0; z=0;
    #100 x=0; y=0; z=1;
    #100 x=0; y=1; z=0;
    #100 x=0; y=1; z=1;
    #100 x=1; y=0; z=0;
    #100 x=1; y=0; z=1;
    #100 x=1; y=1; z=0;
    #100 x=1; y=1; z=1;
end
endmodule
