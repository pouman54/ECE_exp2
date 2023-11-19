`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/17 15:47:42
// Design Name: 
// Module Name: DAC
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

module DAC(clk, rst, btn, add_sel, dac_csn, dac_ldacn, dac_wrn, dac_a_b, dac_d, led_out, seg_data,seg_sel, LCD_E,LCD_RS,LCD_RW,LCD_DATA);

input clk, rst;
input [8:0] btn;
input add_sel;
output reg dac_csn, dac_ldacn, dac_wrn, dac_a_b;
output reg [7:0] dac_d;
output reg [7:0] led_out;
reg [7:0] dac_d_temp;
reg [7:0] cnt;
wire [8:0] btn_t;

reg [1:0] state;

parameter DELAY = 2'b00, SET_WRN = 2'b01, UP_DATA =2'b10;

oneshot_universal #(.WIDTH(9)) o1(clk, rst, {btn[8:0]}, {btn_t[8:0]});

always @(posedge clk or negedge rst) begin
 if(!rst) begin
  state <= DELAY;
 end
 else begin
  case(state)
   DELAY : if(cnt==200) state <= SET_WRN;
   SET_WRN : if(cnt==50) state <= UP_DATA;
   UP_DATA : if(cnt==30) state <= DELAY;
  endcase
 end
end

always @(posedge clk or negedge rst) begin
 if(!rst)
  cnt <= 8'b0000_0000;
 else begin
  case(state)
      DELAY : 
                 if(cnt>=200) cnt<=0;
                 else cnt <= cnt + 1;
      SET_WRN :                 
                 if(cnt>=50) cnt<=0;
                 else cnt <= cnt + 1;
      UP_DATA : 
                 if(cnt>=30) cnt<=0;
                 else cnt <= cnt + 1;
  endcase
 end
end


always @(posedge clk or negedge rst) begin
 if(!rst) begin
  dac_wrn <= 1;
 end
 else begin
  case(state)
      DELAY : 
                 dac_wrn <= 1;
      SET_WRN :                 
                 dac_wrn <= 0;
      UP_DATA : 
                 dac_d <= dac_d_temp;
  endcase
 end
end

always @(posedge clk or negedge rst) begin
 if(!rst) begin
  dac_d_temp <= 8'b0000_0000;
  led_out <= 8'b0101_0101;
 end
 else begin
  if(btn_t == 9'b100000000) dac_d_temp <= dac_d_temp -  8'b0000_0001; 
  else if(btn_t == 9'b001000000) dac_d_temp <= dac_d_temp +  8'b0000_0001; 
  else if(btn_t == 9'b000100000) dac_d_temp <= dac_d_temp -  8'b0000_0010;
  else if(btn_t == 9'b000001000) dac_d_temp <= dac_d_temp +  8'b0000_0010;
  else if(btn_t == 9'b000000100) dac_d_temp <= dac_d_temp -  8'b0000_1000;
  else if(btn_t == 9'b000000001) dac_d_temp <= dac_d_temp +  8'b0000_1000;
  led_out <= dac_d_temp;
 end
end

always @(posedge clk) begin
 dac_csn <= 0;
 dac_ldacn <= 0;
 dac_a_b <= add_sel; // 0 : select A, 1 : select B
end



output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

wire LCD_E;
reg LCD_RS, LCD_RW;

reg [2:0] state_0;
parameter DELAY_0     = 3'b000,
          FUNCTION_SET = 3'b001,
          ENTRY_MODE   = 3'b010,
          DISP_ONOFF   = 3'b011,
          LINE1        = 3'b100,
          LINE2        = 3'b101,
          DELAY_T      = 3'b110,
          CLEAR_DISP   = 3'b111;
          
integer cnt_0;

always @(posedge clk or negedge rst)
begin
    if(!rst)begin
        state_0 = DELAY_0;
        cnt_0 = 0;
    end
    else begin
        case(state_0)
            DELAY_0 : begin
                if(cnt_0 == 70) state_0 = FUNCTION_SET;
                if(cnt_0 >= 70) cnt_0 = 0;
                else cnt_0 = cnt_0 + 1;
            end
            FUNCTION_SET:begin

                if(cnt_0 == 30) state_0 = DISP_ONOFF;
                if(cnt_0 >= 30) cnt_0 = 0;
                else cnt_0 = cnt_0 + 1;

            end
            DISP_ONOFF:begin

                if(cnt_0 == 30) state_0 = ENTRY_MODE;
                if(cnt_0 >= 30) cnt_0 = 0;
                else cnt_0 = cnt_0 + 1;

            end
            ENTRY_MODE:begin

                if(cnt_0 == 30) state_0 = LINE1;
                 if(cnt_0 >= 30) cnt_0 = 0;
                else cnt_0 = cnt_0 + 1;

            end
            LINE1:begin

                if(cnt_0 == 20) state_0 = LINE2;
                if(cnt_0 >= 20) cnt_0 = 0;
                else cnt_0 = cnt_0 + 1;

            end
            LINE2:begin

                if(cnt_0 == 20) state_0 = DELAY_T;
                if(cnt_0 >= 20) cnt_0 = 0;
                else cnt_0 = cnt_0 + 1;

            end
            DELAY_T:begin
                if(cnt_0 == 5) state_0 = CLEAR_DISP;
                if(cnt_0 >= 5) cnt_0 = 0;
                else cnt_0 = cnt_0 + 1;

            end
            CLEAR_DISP:begin
                if(cnt_0 == 5) state_0 = LINE1;
                 if(cnt_0 >= 5) cnt_0 = 0;
                else cnt_0 = cnt_0 + 1;

            end
            default: state_0 = DELAY_0;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000;
    else begin
        case(state_0)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_0000;
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100;
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110;
            LINE1 : begin
                case(cnt_0)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000;
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = {9'b1_0_0011_000, dac_d[7]}; //
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = {9'b1_0_0011_000, dac_d[6]}; //
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = {9'b1_0_0011_000, dac_d[5]}; //
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = {9'b1_0_0011_000, dac_d[4]}; //
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = {9'b1_0_0011_000, dac_d[3]}; //
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = {9'b1_0_0011_000, dac_d[2]}; //
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = {9'b1_0_0011_000, dac_d[1]}; ///
                    08 : {LCD_RS, LCD_RW, LCD_DATA} = {9'b1_0_0011_000, dac_d[0]}; //
                    09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                endcase
            end
            LINE2 : begin
                case(cnt_0)
                    00:{LCD_RS,LCD_RW,LCD_DATA}=10'b0_0_1100_0011;
                    01:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0010; // 2
                    02:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0000; // 0
                    03:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0010; // 2
                    04:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0000; // 0
                    05:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0100; // 4
                    06:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0100; // 4
                    07:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0000; // 0
                    08:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0000; // 0
                    09:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0011; // 3
                    10:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_1000; // 8
                    11:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0011_0000; // 
                    12:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_1011; // K
                    13:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0011; // C
                    14:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0100_0101; // E
                    15:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; // 
                    16:{LCD_RS,LCD_RW,LCD_DATA}=10'b1_0_0010_0000; //
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                endcase
            end
            DELAY_T :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
            CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
            default :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000;
        endcase
    end
end

assign LCD_E = clk;



output reg [7:0] seg_data;
output reg [7:0] seg_sel;

reg dac_da;

always @(posedge clk or negedge rst) begin
    if(!rst) seg_sel <= 8'b11111110;
    else begin
        seg_sel <= {seg_sel[6:0], seg_sel[7]};
    end
end

always @(*) begin
    case(dac_da)
        0 : seg_data = 8'b11111100;
        1 : seg_data = 8'b01100000;
        default : seg_data = 8'b00000000;
     endcase
end

always @(*) begin
    case(seg_sel)
        8'b11111110 : dac_da = dac_d[0];
        8'b11111101 : dac_da = dac_d[1];
        8'b11111011 : dac_da = dac_d[2];
        8'b11110111 : dac_da = dac_d[3];
        8'b11101111 : dac_da = dac_d[4];
        8'b11011111 : dac_da = dac_d[5];
        8'b10111111 : dac_da = dac_d[6];
        8'b01111111 : dac_da = dac_d[7];
        default : dac_da = 1'b0;
    endcase
end

endmodule
