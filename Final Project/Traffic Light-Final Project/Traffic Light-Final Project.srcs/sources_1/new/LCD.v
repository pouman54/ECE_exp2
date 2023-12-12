`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/28 22:48:06
// Design Name: 
// Module Name: LCD
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

module LCD(rst,clk,state_traffic,day_night,hour_ten,hour_one,min_ten,min_one,sec_ten,sec_one,LCD_E,LCD_RS,LCD_RW,LCD_DATA);
input rst,clk,day_night;
input [3:0] hour_ten;
input [3:0] hour_one;
input [3:0] min_ten;
input [3:0] min_one;
input [3:0] sec_ten;
input [3:0] sec_one;
input [3:0] state_traffic;
output LCD_E,LCD_RS,LCD_RW;
output reg[7:0] LCD_DATA;
wire LCD_E;
reg LCD_RS,LCD_RW;
reg [2:0] state;
reg [7:0] cnt;

parameter DELAY=3'b000,
          FUNCTION_SET=3'b001,
          ENTRY_MODE  =3'b010,
          DISP_ONOFF  =3'b011,
          LINE1       =3'b100,
          LINE2       =3'b101,
          DELAY_T     =3'b110,
          CLEAR_DISP  =3'b111;

always @(posedge clk or negedge rst) begin
    if(!rst)
        state<=DELAY;
    else begin
        case(state)
            DELAY:
                if(cnt==70) state<=FUNCTION_SET;
            FUNCTION_SET:
                if(cnt==30) state<=DISP_ONOFF;
            DISP_ONOFF:
                if(cnt==30) state<=ENTRY_MODE;
            ENTRY_MODE:
                if(cnt==30) state<=LINE1;
            LINE1:
                if(cnt==20) state<=LINE2;
            LINE2:
                if(cnt==20) state<=DELAY_T;
            DELAY_T:
                if(cnt==200) state<=CLEAR_DISP;
            CLEAR_DISP:
                if(cnt==5) state<=LINE1;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        cnt<=8'b0000_0000;
    else begin
        case(state)
            DELAY:
                if(cnt>=70)cnt<=0;
                else cnt<=cnt+1;
            FUNCTION_SET:
                if(cnt>=30)cnt<=0;
                else cnt<=cnt+1;
            DISP_ONOFF:
                if(cnt>=30)cnt<=0;
                else cnt<=cnt+1;
            ENTRY_MODE:
                if(cnt>=30)cnt<=0;
                else cnt<=cnt+1;
            LINE1:
                if(cnt>=20)cnt<=0;
                else cnt<=cnt+1;
            LINE2:
                if(cnt>=20)cnt<=0;
                else cnt<=cnt+1;
            DELAY_T:
                if(cnt>=200)cnt<=0;
                else cnt<=cnt+1;
            CLEAR_DISP:
                if(cnt>=5)cnt<=0;
                else cnt<=cnt+1;
            default:state=DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst)
        {LCD_RS,LCD_RW,LCD_DATA}=10'b1_1_00000000;
    else begin
        case(state)
            FUNCTION_SET:
                {LCD_RS,LCD_RW,LCD_DATA}=10'b0_0_0011_1000;
            DISP_ONOFF:
                {LCD_RS,LCD_RW,LCD_DATA}=10'b0_0_0000_1100;
            ENTRY_MODE:
                {LCD_RS,LCD_RW,LCD_DATA}=10'b0_0_0000_0110;

LINE1:
    begin
        case(cnt)
            00:{LCD_RS,LCD_RW,LCD_DATA}=10'b0_0_1000_0000;
            01:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0101_0100; // T
            02:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_1001; // i
            03:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_1101; // m
            04:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_0101; // e
            05:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; // 
            06:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_1010; // :
            07:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; // 
            08:begin
                case(hour_ten)
                4'b0001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0001; // 1
                4'b0010:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0010; // 2
                4'b0011:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0011; // 3
                4'b0100:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0100; // 4
                4'b0101:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0101; // 5
                4'b0110:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0110; // 6
                4'b0111:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0111; // 7
                4'b1000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1000; // 8
                4'b1001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1001; // 9
                4'b0000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0000; // 0
                endcase
            end
            09:begin
                case(hour_one)
                4'b0001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0001; // 1
                4'b0010:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0010; // 2
                4'b0011:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0011; // 3
                4'b0100:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0100; // 4
                4'b0101:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0101; // 5
                4'b0110:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0110; // 6
                4'b0111:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0111; // 7
                4'b1000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1000; // 8
                4'b1001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1001; // 9
                4'b0000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0000; // 0
                endcase
            end
            10:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_1010; // :
            11:begin
                case(min_ten)
                4'b0001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0001; // 1
                4'b0010:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0010; // 2
                4'b0011:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0011; // 3
                4'b0100:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0100; // 4
                4'b0101:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0101; // 5
                4'b0110:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0110; // 6
                4'b0111:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0111; // 7
                4'b1000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1000; // 8
                4'b1001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1001; // 9
                4'b0000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0000; // 0
                endcase
            end
            12:begin
                case(min_one)
                4'b0001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0001; // 1
                4'b0010:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0010; // 2
                4'b0011:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0011; // 3
                4'b0100:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0100; // 4
                4'b0101:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0101; // 5
                4'b0110:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0110; // 6
                4'b0111:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0111; // 7
                4'b1000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1000; // 8
                4'b1001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1001; // 9
                4'b0000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0000; // 0
                endcase
            end
            13:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_1010; // :
            14:begin
                case(sec_ten)
                4'b0001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0001; // 1
                4'b0010:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0010; // 2
                4'b0011:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0011; // 3
                4'b0100:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0100; // 4
                4'b0101:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0101; // 5
                4'b0110:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0110; // 6
                4'b0111:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0111; // 7
                4'b1000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1000; // 8
                4'b1001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1001; // 9
                4'b0000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0000; // 0
                endcase
            end
            15:begin
                case(sec_one)
                4'b0001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0001; // 1
                4'b0010:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0010; // 2
                4'b0011:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0011; // 3
                4'b0100:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0100; // 4
                4'b0101:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0101; // 5
                4'b0110:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0110; // 6
                4'b0111:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0111; // 7
                4'b1000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1000; // 8
                4'b1001:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_1001; // 9
                4'b0000:{LCD_RS,LCD_RW,LCD_DATA}<=10'b1_0_0011_0000; // 0
                endcase
            end
            16:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; //
            default:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; //
        endcase
    end

LINE2:
    begin
        case(cnt)
            00:{LCD_RS,LCD_RW,LCD_DATA}=10'b0_0_1100_0000;
            01:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0101_0011; // S
            02:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0111_0100; // t
            03:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_0001; // a
            04:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0111_0100; // t
            05:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_0101; // e
            06:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_1010; // :
            07:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; // 
            08: begin
                case(state_traffic)
                    4'b0000:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0001; // A
                    4'b0001:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0010; // B
                    4'b0010:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0011; // C
                    4'b0011:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0100; // D
                    4'b0100:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0101; // E
                    4'b0101:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0110; // F
                    4'b0110:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0111; // G
                    4'b0111:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_1000; // H
                    4'b1000:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0001; // A
                endcase
            end
            09:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_1000; // (
            10:begin
                case(day_night)
                    0:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_0100; // d
                    1:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_1110; // n
                endcase
            end
            11:begin
                case(day_night)
                    0:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_0001; // a
                    1:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_1001; // i
                endcase
            end
            12:begin
                case(day_night)
                    0:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0111_1001; // y
                    1:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_0111; // g
                endcase
            end
            13:begin
                case(day_night)
                    0:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_1001; // )
                    1:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0110_1000; // h
                endcase
            end
            14:begin
                case(day_night)
                    0:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; // 
                    1:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0111_0100; // t
                endcase
            end
            15:begin
                case(day_night)
                    0:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; // 
                    1:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_1001; // )
                endcase
            end
            16:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; // 
            default:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; // 
        endcase
    end
            DELAY_T:
                {LCD_RS,LCD_RW,LCD_DATA}=10'b0_0_0000_0010;
            CLEAR_DISP:
                {LCD_RS,LCD_RW,LCD_DATA}=10'b0_0_0000_0001;
            default:
                {LCD_RS,LCD_RW,LCD_DATA}=10'b1_1_0000_0000;
        endcase
    end
end

assign LCD_E=clk;

endmodule
