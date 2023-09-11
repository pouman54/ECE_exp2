`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 12:51:18
// Design Name: 
// Module Name: logic_gate_tb
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

module logic_gate_tb();
reg a,b;
wire c,d,e,f,g;
logic_gate U1(a,b,c,d,e,f,g);

initial begin
    a = 0;
    b = 0;
end
    
always begin
    #100 a = ~a;
    #100 b = ~b;
end

endmodule