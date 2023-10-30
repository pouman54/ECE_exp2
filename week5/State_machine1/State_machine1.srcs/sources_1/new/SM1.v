`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/27 15:15:44
// Design Name: 
// Module Name: SM1
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

module SM1(clk,rst,x,y,state);

input clk,rst,x;
output reg [1:0] state;
output reg y;

always@(negedge rst or posedge clk) begin
    if(!rst) state<=2'b00;
    else if (state==2'b00&&x==1'b0){state,y}<=3'b000;
    else if (state==2'b00&&x==1'b1){state,y}<=3'b010;
    else if (state==2'b01&&x==1'b0){state,y}<=3'b001;
    else if (state==2'b01&&x==1'b1){state,y}<=3'b110;
    else if (state==2'b10&&x==1'b0){state,y}<=3'b001;
    else if (state==2'b10&&x==1'b1){state,y}<=3'b100;
    else if (state==2'b11&&x==1'b0){state,y}<=3'b001;
    else if (state==2'b11&&x==1'b1){state,y}<=3'b100;
end
endmodule