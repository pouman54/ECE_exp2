`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 16:18:29
// Design Name: 
// Module Name: FA_tb
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


module FA_tb();
reg x,y,z;
wire s,c;

FA ut(x,y,z,s,c);
    initial begin
         x=0; y=0; z=0;
    #100 x=1; y=0; z=0;
    #100 x=0; y=1; z=0; 
    #100 x=1; y=1; z=0; 
    #100 x=0; y=0; z=1; 
    #100 x=1; y=0; z=1; 
    #100 x=0; y=1; z=1; 
    #100 x=1; y=1; z=1;
end
endmodule
