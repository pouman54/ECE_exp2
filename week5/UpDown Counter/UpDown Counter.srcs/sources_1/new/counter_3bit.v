`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 00:54:22
// Design Name: 
// Module Name: counter_3bit
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
////////////////////////////////////////////////////////////////////////////

module counter_3bit(clk,rst,x,state);
input clk,rst,x;
reg x_reg,x_trig,cnt;
output reg [2:0] state;

always@(negedge rst or posedge clk)begin
    if(!rst)begin
        {x_reg,x_trig}<=3'b000;
    end
    else begin
        x_reg<=x;
        x_trig<=x&~x_reg;
    end
end

always@(negedge rst or posedge clk)begin
    if(!rst) begin
        state<=3'b000;
        cnt<=1'b1;
    end
    else begin
        if(cnt) begin
            case({state,cnt})
                4'b0001:{state,cnt}<=x_trig ? 4'b0011:4'b0001;
                4'b0011:{state,cnt}<=x_trig ? 4'b0101:4'b0011;
                4'b0101:{state,cnt}<=x_trig ? 4'b0111:4'b0101;
                4'b0111:{state,cnt}<=x_trig ? 4'b1001:4'b0111;
                4'b1001:{state,cnt}<=x_trig ? 4'b1011:4'b1001;
                4'b1011:{state,cnt}<=x_trig ? 4'b1101:4'b1011;
                4'b1101:{state,cnt}<=x_trig ? 4'b1110:4'b1101; 
            endcase
        end
        
        else if(!cnt) begin
            case({state,cnt})
                4'b1110:{state,cnt}<=x_trig ? 4'b1100:4'b1110;
                4'b1100:{state,cnt}<=x_trig ? 4'b1010:4'b1100;
                4'b1010:{state,cnt}<=x_trig ? 4'b1000:4'b1010;
                4'b1000:{state,cnt}<=x_trig ? 4'b0110:4'b1000;
                4'b0110:{state,cnt}<=x_trig ? 4'b0100:4'b0110;
                4'b0100:{state,cnt}<=x_trig ? 4'b0010:4'b0100;
                4'b0010:{state,cnt}<=x_trig ? 4'b0001:4'b0010; 
            endcase
        end
    end
end
endmodule
//////////////////////////////////////////////////////////////////////////////////

