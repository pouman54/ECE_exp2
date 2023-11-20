`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/20 14:43:58
// Design Name: 
// Module Name: bin2bcd
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

module bin2bcd(clk,rst,dac_d,bcd);
input clk,rst;
input [3:0]dac_d;
output reg [7:0] bcd;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        bcd<={4'd0,4'd0};
    end
    else begin
        case(dac_d)
            0:bcd<={4'd0,4'd0};
            1:bcd<={4'd0,4'd1};
            2:bcd<={4'd0,4'd2};
            3:bcd<={4'd0,4'd3};
            4:bcd<={4'd0,4'd4};
            5:bcd<={4'd0,4'd5};
            6:bcd<={4'd0,4'd6};
            7:bcd<={4'd0,4'd7};
            8:bcd<={4'd0,4'd8};
            9:bcd<={4'd0,4'd9};
            10:bcd<={4'd1,4'd0};
            11:bcd<={4'd1,4'd1};
            12:bcd<={4'd1,4'd2};
            13:bcd<={4'd1,4'd3};
            14:bcd<={4'd1,4'd4};
            15:bcd<={4'd1,4'd5};
            default:bcd<={4'd0,4'd0};
        endcase
    end
end
endmodule
