`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/23 15:27:31
// Design Name: 
// Module Name: traffic_light
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

module traffic_light (clk,rst,dip,ad_hour_btn,emergency_btn,S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN,S_W_RED, N_W_RED, W_W_RED, E_W_RED,S_GREEN, N_GREEN, W_GREEN, E_GREEN,S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW,S_RED, N_RED, W_RED, E_RED,S_LEFT, N_LEFT, W_LEFT, E_LEFT, LCD_E, LCD_RS, LCD_RW, LCD_DATA);
input clk,rst;       // 클럭, rst
input ad_hour_btn;   // 1시간 추가 버튼
input emergency_btn; // 수동 조작 버튼
input [1:0] dip;     // 배율 버튼 (00:1배, 01:10배, 10:100배, 11:200배)
output LCD_E, LCD_RS, LCD_RW;
output [7:0] LCD_DATA;
output reg S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN; // 녹색 보행신호
output reg S_W_RED, N_W_RED, W_W_RED, E_W_RED;         // 적색 보행신호
output reg S_GREEN, N_GREEN, W_GREEN, E_GREEN;         // 녹색 주행신호
output reg S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW;     // 황색 주행신호
output reg S_RED, N_RED, W_RED, E_RED;                 // 적색 주행신호
output reg S_LEFT, N_LEFT, W_LEFT, E_LEFT;             // 좌회전 주행신호

reg [3:0] state;            // 상태
reg [3:0] main_state;       // 메인 상태
reg [3:0] pre_main_state;   // 이전 메인 상태
reg [3:0] pre_state;        // 이전 상태
reg day_night;              // 주간/야간 (0:주간, 1:야간)
reg pre_day_night;          // 주간/야간 바뀌기 전 상태
reg [31:0] timer;           // 타이머
reg [31:0] emergency_timer; // 긴급상황 타이머
reg [31:0] real_time;       // 실제 시간

reg [3:0] hour_ten; // 십의자리 시간
reg [3:0] hour_one; // 일의자리 시간
reg [3:0] min_ten;  // 십의자리 분
reg [3:0] min_one;  // 일의자리 분
reg [3:0] sec_ten;  // 십의자리 초
reg [3:0] sec_one;  // 일의자리 초

wire ad_hour_btn_t;   // 1시간 추가 버튼 트리거
wire emergency_btn_t; // 수동조작 버튼 트리거

parameter A_state  = 4'b0000, // 각 상태 정의(A,B,C,D,E,F,G,H,EA)
          B_state  = 4'b0001,
          C_state  = 4'b0010,
          D_state  = 4'b0011,
          E_state  = 4'b0100,
          F_state  = 4'b0101,
          G_state  = 4'b0110,
          H_state  = 4'b0111,
          EA_state = 4'b1000;

LCD L1(rst, clk, state, day_night, hour_ten, hour_one, min_ten, min_one, sec_ten, sec_one, LCD_E, LCD_RS, LCD_RW, LCD_DATA[7:0]); // LCD 모듈
oneshot #(.WIDTH(2)) O1(clk, rst, {ad_hour_btn,emergency_btn}, {ad_hour_btn_t,emergency_btn_t});                                  // 원샷 모듈


// 실제 시간에 따른 주간,야간 상태 변경 + 1시간 추가 기능 + 시간 배율 조정
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        day_night <= 1;             // 시작시, 야간(00:00:00)으로 설정
        pre_day_night <= day_night; // 현재 주/야간 상태를 이전 주/야간 상태에 저장
        real_time <= 0;             // 실제 시간 초기화
        hour_ten <= 0;              // 십의자리 시간 초기화
        hour_one <= 0;              // 일의자리 시간 초기화
        min_ten <= 0;               // 십의자리 분 초기화
        min_one <= 0;               // 일의자리 분 초기화
        sec_ten <= 0;               // 십의자리 초 초기화
        sec_one <= 0;               // 일의자리 초 초기화
    end
    else begin
        if (real_time >= 86400000) real_time <= 0;                    // 실제 시간이 '24:00'(24*60*60*1000)이 되면, 실제 시간 초기화
        else if (ad_hour_btn_t) real_time <= real_time + 32'd3600000; // '1시간 추가 버튼'을 누르면, 실제 시간에 1시간(1*60*60*1000) 추가
        else begin
            case(dip)                                // dip 스위치의 상태(00:1배, 01:10배, 10:100배, 11:200배)에 따라 실제 시간 배율 조정
            2'b00: real_time <= real_time + 32'd1;   // 1배 시간 증가
            2'b01: real_time <= real_time + 32'd10;  // 10배 시간 증가
            2'b10: real_time <= real_time + 32'd100; // 100배 시간 증가
            2'b11: real_time <= real_time + 32'd200; // 200배 시간 증가
            endcase
            
            pre_day_night <= day_night; // 현재 주/야간 상태를 이전 주/야간 상태에 저장
            
            // 시, 분, 초 계산
            hour_ten <= real_time / 36000000;             // 시간의 십의 자리 숫자
            hour_one <= (real_time % 36000000) / 3600000; // 시간의 일의 자리 숫자
            min_ten <= (real_time % 3600000) / 600000;    // 분의 십의 자리 숫자
            min_one <= (real_time % 600000) / 60000;      // 분의 일의 자리 숫자
            sec_ten <= (real_time % 60000) / 10000;       // 초의 십의 자리 숫자
            sec_one <= (real_time % 10000) / 1000;        // 초의 일의 자리 숫자
        
            if (real_time >= 28800000 && real_time < 82800000) day_night <= 0; // 실제 시간이 '08:00'(8*60*60*1000)보다 크거나 '23:00'(23*60*60*1000)보다 작으면, 주간으로 전환
            else day_night <= 1;                                               // 그 외의 실제 시간에는 야간으로 전환
        end
    end
end


// 시간에 따른 상태 변경 + 신호등 수동 조작
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= B_state;             // 상태 초기화(시작 시, 야간이므로 B_state)
        main_state <= 1;              // 메인 상태 초기화(시작시, 첫번째 순서로 시작)
        timer <= 0;                   // 타이머 초기화
        emergency_timer <= 0;         // 긴급상황 타이머 초기화
        pre_state <= state;           // 이전 상태 저장
        pre_main_state <= main_state; // 이전 메인 상태 저장
    end
    else begin
        if (emergency_btn_t) begin        // '수동 조작 버튼' 누를시,
            pre_state <= state;           // 현재 상태를 이전 상태에 저장
            pre_main_state <= main_state; // 현재 메인 상태를 이전 메인 상태에 저장
            main_state <= 7;              // 현재 메인 상태를 7(1초 대기 순서)로 전환 -> 메인 상태 7,8은 수동조작이므로 주/야간 모두 동일한 코드임
        end
        
        else if (day_night == 0) begin    // 주간일 때:A->D->F->E->G->E
            if (pre_day_night == 1) begin // 이전 주/야간 상태가 야간이었다면,
                main_state <= 1;          // 메인 상태 초기화(첫번째 순서로 시작)
                state <= A_state;         // 상태 초기화(주간이므로 A_state)
                timer <= 0;               // 타이머 초기화
            end
            else begin
                case(main_state)
                    1:begin                               // 첫번째 순서
                        if(timer == 5000) begin           // 타이머가 5초(5*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= D_state;             // 상태 전환(A->D)
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    2:begin                               // 두번째 순서
                        if(timer == 5000) begin           // 타이머가 5초(5*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= F_state;             // 상태 전환(D->F)
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    3:begin                               // 세번째 순서
                        if(timer == 5000) begin           // 타이머가 5초(5*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= E_state;             // 상태 전환(F->E)
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    4:begin                               // 네번째 순서
                        if(timer == 5000) begin           // 타이머가 5초(5*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= G_state;             // 상태 전환(E->G)
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    5:begin                               // 다섯번째 순서
                        if(timer == 5000) begin           // 타이머가 5초(5*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= E_state;             // 상태 전환(G->E)
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    6:begin                               // 여섯번째 순서
                        if(timer == 5000) begin           // 타이머가 5초(5*1000)가 되면,
                            main_state <= 1;              // 첫번째 순서로 전환
                            state <= A_state;             // 상태 전환(E->A)
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    7:begin                                          // 1초 대기 순서
                        if (emergency_timer >= 1000) begin           // 1초(1*1000)가 지나면,
                            timer <= 0;                              // 타이머 초기화
                            emergency_timer <= 0;                    // 긴급상황 타이머 초기화
                            main_state <= 8;                         // 현재 메인 상태를 8(긴급상황)로 전환
                            state <= EA_state;                       // 상태 전환(현재 상태->EA_state)
                        end
                        else emergency_timer <= emergency_timer + 1; // 긴급상황 타이머 증가
                    end
                    8:begin                                          // 긴급상황
                        if (emergency_timer >= 15000) begin          // 15초가 지나면,
                            emergency_timer <= 0;                    // 긴급상황 타이머 초기화
                            main_state <= pre_main_state;            // 이전 메인 상태로 돌아감
                            state <= pre_state;                      // 이전 상태로 돌아감
                        end
                        else emergency_timer <= emergency_timer + 1; // 긴급상황 타이머 증가
                    end
                    default:state <= A_state;
                endcase
            end
        end
    
        else if (day_night == 1) begin    // 야간일 때:B->A->C->A->E->H
            if (pre_day_night == 0) begin // 이전 주/야간 상태가 주간이었다면,
                main_state <= 1;          // 메인 상태 초기화(첫번째 순서로 시작)
                state <= B_state;         // 상태 초기화(야간이므로 B_state)
                timer <= 0;               // 타이머 초기화
            end
            else begin
                case(main_state)
                    1:begin                               // 첫번째 순서
                        if(timer == 10000) begin          // 타이머가 10초(10*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= A_state;             // 상태 전환 B->A
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    2:begin                               // 두번째 순서
                        if(timer == 10000) begin          // 타이머가 10초(10*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= C_state;             // 상태 전환 A->C
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    3:begin                               // 세번째 순서
                        if(timer == 10000) begin          // 타이머가 10초(10*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= A_state;             // 상태 전환 C->A
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    4:begin                               // 네번째 순서
                        if(timer == 10000) begin          // 타이머가 10초(10*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= E_state;             // 상태 전환 A->E
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    5:begin                               // 다섯번째 순서
                        if(timer == 10000) begin          // 타이머가 10초(10*1000)가 되면,
                            main_state <= main_state + 1; // 다음 순서로 전환
                            state <= H_state;             // 상태 전환 E->H
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    6:begin                               // 여섯번째 순서
                        if(timer == 10000) begin          // 타이머가 10초(10*1000)가 되면,
                            main_state <= 1;              // 첫번째 순서로 전환
                            state <= B_state;             // 상태 전환 H->B
                            timer <= 0;                   // 타이머 초기화
                        end
                        else timer <= timer + 1;          // 타이머 증가
                    end
                    7:begin                                          // 1초 대기 순서
                        if (emergency_timer >= 1000) begin           // 1초(1*1000)가 지나면,
                            timer <= 0;                              // 타이머 초기화
                            emergency_timer <= 0;                    // 긴급상황 타이머 초기화
                            main_state <= 8;                         // 현재 메인 상태를 8(긴급상황)로 전환
                            state <= EA_state;                       // 상태 전환(현재 상태->EA_state)
                        end
                        else emergency_timer <= emergency_timer + 1; // 긴급상황 타이머 증가
                    end
                    8:begin                                          // 긴급상황
                        if (emergency_timer >= 15000) begin          // 15초가 지나면,
                            emergency_timer <= 0;                    // 긴급상황 타이머 초기화
                            main_state <= pre_main_state;            // 이전 메인 상태로 돌아감
                            state <= pre_state;                      // 이전 상태로 돌아감
                        end
                        else emergency_timer <= emergency_timer + 1; // 긴급상황 타이머 증가
                    end
                    default:state<=B_state;
                endcase
            end
        end
    end
end


// 상태에 따른 신호등 출력
always @(posedge clk or negedge rst) begin
    if(!rst) begin                                              // 시작시, 모든 적색 신호만 켜기
        S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
        S_RED = 1; N_RED = 1; W_RED = 1; E_RED = 1;
        S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
        
        S_W_GREEN=0; N_W_GREEN=0; W_W_GREEN=0; E_W_GREEN=0;
        S_W_RED=1; N_W_RED=1; W_W_RED=1; E_W_RED=1;
    end
    else begin
        case (state)
            A_state: begin                                                          // 상태 A
                S_GREEN = 1; N_GREEN = 1; W_GREEN = 0; E_GREEN = 0;
                S_RED = 0; N_RED = 0; W_RED = 1; E_RED = 1;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                S_W_RED = 1; N_W_RED = 1; W_W_RED = 0; E_W_RED = 0;
                
                if (day_night == 0) begin                                           // 주간 보행신호 점멸 + 황색 코드
                    if(timer>=2500 && timer<3000) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=3000 && timer<3500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(timer>=3500 && timer<4000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(timer>=4000 && timer<4500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(timer>=4500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                end
                
                else if (day_night == 1) begin                                      // 야간 보행신호 점멸 + 황색 코드
                    if(timer>=5000 && timer<5500) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=5500 && timer<6000) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(timer>=6000 && timer<6500) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=6500 && timer<7000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(timer>=7000 && timer<7500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=7500 && timer<8000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(timer>=8000 && timer<8500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=8500 && timer<9000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(timer>=9000 && timer<9500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(timer>=9500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                end
            end
            
            B_state: begin                                                          // 상태 B
                S_GREEN = 0; N_GREEN = 1; W_GREEN = 0; E_GREEN = 0;
                S_RED = 1; N_RED = 0; W_RED = 1; E_RED = 1;
                S_LEFT = 0; N_LEFT = 1; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 1;
                S_W_RED = 1; N_W_RED = 1; W_W_RED = 1; E_W_RED = 0;
                
                if (day_night == 1) begin                                           // 야간 보행신호 점멸 + 황색 코드
                    if(timer>=5000 && timer<5500) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=5500 && timer<6000) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 1;
                    end
                    else if(timer>=6000 && timer<6500) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=6500 && timer<7000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 1;
                    end
                    else if(timer>=7000 && timer<7500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=7500 && timer<8000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 1;
                    end
                    else if(timer>=8000 && timer<8500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=8500 && timer<9000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 1;
                        S_YELLOW = 0; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(timer>=9000 && timer<9500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(timer>9500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 1;
                        S_YELLOW = 0; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                end
            end
            
            C_state: begin                                                          // 상태 C
                S_GREEN = 1; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
                S_RED = 0; N_RED = 1; W_RED = 1; E_RED = 1;
                S_LEFT = 1; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 0;
                S_W_RED = 1; N_W_RED = 1; W_W_RED = 0; E_W_RED = 1;
                
                if (day_night == 1) begin                                           // 야간 보행신호 점멸 + 황색 코드
                    if(timer>=5000 && timer<5500) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=5500 && timer<6000) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 0;
                    end
                    else if(timer>=6000 && timer<6500) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=6500 && timer<7000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 0;
                    end
                    else if(timer>=7000 && timer<7500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=7500 && timer<8000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 0;
                    end
                    else if(timer>=8000 && timer<8500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=8500 && timer<9000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 0;
                        S_YELLOW = 1; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(timer>=9000 && timer<9500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 1; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(timer>9500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 0;
                        S_YELLOW = 1; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                    end
                end
            end
            
            D_state: begin                                                  // 상태 D
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
                S_RED = 0; N_RED = 0; W_RED = 1; E_RED = 1;
                S_LEFT = 1; N_LEFT = 1; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
               
                S_W_GREEN=0; N_W_GREEN=0; W_W_GREEN=0; E_W_GREEN=0;
                S_W_RED=1; N_W_RED=1; W_W_RED=1; E_W_RED=1;
                
                if (day_night == 0 && timer > 3500) begin                   // 주간 황색 코드
                    S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                end
            end
            
            E_state: begin                                                          // 상태 E
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 1; E_GREEN = 1;
                S_RED = 1; N_RED = 1; W_RED = 0; E_RED = 0;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                S_W_RED = 0; N_W_RED = 0; W_W_RED = 1; E_W_RED = 1;
                
                if (day_night == 0) begin                                           // 주간 보행신호 점멸 + 황색 코드
                    if(timer>=2500 && timer<3000) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=3000 && timer<3500)begin
                        S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=3500 && timer<4000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 1;
                    end
                    else if(timer>=4000 && timer<4500)begin
                        S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 1;
                    end
                    else if(timer>4500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 1;
                    end
                end
                
                else if (day_night == 1) begin                                      // 야간 보행신호 점멸 + 황색 코드
                    if(timer>=5000 && timer<5500) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=5500 && timer<6000) begin
                        S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=6000 && timer<6500) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=6500 && timer<7000)begin
                        S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=7000 && timer<7500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=7500 && timer<8000)begin
                        S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=8000 && timer<8500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=8500 && timer<9000)begin
                        S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 1;
                    end
                    else if(timer>=9000 && timer<9500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 1;
                    end
                    else if(timer>9500)begin
                        S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 1;
                    end
                end
            end
            
            F_state: begin                                                          // 상태 F
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 1; E_GREEN = 0;
                S_RED = 1; N_RED = 1; W_RED = 0; E_RED = 1;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 1; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                S_W_RED = 1; N_W_RED = 0; W_W_RED = 1; E_W_RED = 1;
                
                if (day_night == 0) begin                                           // 주간 보행신호 점멸 + 황색 코드
                    if(timer>=2500 && timer<3000) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=3000 && timer<3500)begin
                        S_W_GREEN = 0; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=3500 && timer<4000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 0;
                    end
                    else if(timer>=4000 && timer<4500)begin
                        S_W_GREEN = 0; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 0;
                    end
                    else if(timer>4500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 0;
                    end
                end
            end
            
            G_state: begin                                                          // 상태 G
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 1;
                S_RED = 1; N_RED = 1; W_RED = 1; E_RED = 0;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 1;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 1; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                S_W_RED = 0; N_W_RED = 1; W_W_RED = 1; E_W_RED = 1;
                
                if (day_night == 0) begin                                           // 주간 보행신호 점멸 + 황색 코드
                    if(timer>=2500 && timer<3000) begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=3000 && timer<3500)begin
                        S_W_GREEN = 1; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(timer>=3500 && timer<4000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 1;
                    end
                    else if(timer>=4000 && timer<4500)begin
                        S_W_GREEN = 1; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 1;
                    end
                    else if(timer>4500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 1;
                    end
                end
            end
            
            H_state: begin                                                  // 상태 H
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
                S_RED = 1; N_RED = 1; W_RED = 0; E_RED = 0;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 1; E_LEFT = 1;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN=0; N_W_GREEN=0; W_W_GREEN=0; E_W_GREEN=0;
                S_W_RED=1; N_W_RED=1; W_W_RED=1; E_W_RED=1;
                
                if (day_night == 1 && timer > 8500) begin                   // 야간 황색 코드
                    S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 1;
                end
            end
            
            EA_state: begin                                                         // 상태 EA
                S_GREEN = 1; N_GREEN = 1; W_GREEN = 0; E_GREEN = 0;
                S_RED = 0; N_RED = 0; W_RED = 1; E_RED = 1;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                S_W_RED = 1; N_W_RED = 1; W_W_RED = 0; E_W_RED = 0;
                
                if (day_night == 0 || day_night == 1) begin                         // 보행신호 점멸 + 황색 코드(주/야간 구분 없음)
                    if(emergency_timer>=7500 && emergency_timer<8000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(emergency_timer>=8000 && emergency_timer<8500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(emergency_timer>=8500 && emergency_timer<9000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(emergency_timer>=9000 && emergency_timer<9500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(emergency_timer>=9500 && emergency_timer<10000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(emergency_timer>=10000 && emergency_timer<10500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(emergency_timer>=10500 && emergency_timer<11000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(emergency_timer>=11000 && emergency_timer<11500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(emergency_timer>=11500 && emergency_timer<12000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(emergency_timer>=12000 && emergency_timer<12500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(emergency_timer>=12500 && emergency_timer<13000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                    end
                    else if(emergency_timer>=13000 && emergency_timer<13500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                    end
                    else if(emergency_timer>=13500 && emergency_timer<14000)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(emergency_timer>=14000 && emergency_timer<14500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                    else if(emergency_timer>=14500)begin
                        S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                        S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                    end
                end
            end
            default: begin                                              // 모든 신호 끄기
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                S_RED = 1; N_RED = 1; W_RED = 1; E_RED = 1;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                
                S_W_GREEN=0; N_W_GREEN=0; W_W_GREEN=0; E_W_GREEN=0;
                S_W_RED=1; N_W_RED=1; W_W_RED=1; E_W_RED=1;
            end
        endcase
    end
end
endmodule
