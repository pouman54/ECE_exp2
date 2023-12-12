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
input clk,rst;       // Ŭ��, rst
input ad_hour_btn;   // 1�ð� �߰� ��ư
input emergency_btn; // ���� ���� ��ư
input [1:0] dip;     // ���� ��ư (00:1��, 01:10��, 10:100��, 11:200��)
output LCD_E, LCD_RS, LCD_RW;
output [7:0] LCD_DATA;
output reg S_W_GREEN, N_W_GREEN, W_W_GREEN, E_W_GREEN; // ��� �����ȣ
output reg S_W_RED, N_W_RED, W_W_RED, E_W_RED;         // ���� �����ȣ
output reg S_GREEN, N_GREEN, W_GREEN, E_GREEN;         // ��� �����ȣ
output reg S_YELLOW, N_YELLOW, W_YELLOW, E_YELLOW;     // Ȳ�� �����ȣ
output reg S_RED, N_RED, W_RED, E_RED;                 // ���� �����ȣ
output reg S_LEFT, N_LEFT, W_LEFT, E_LEFT;             // ��ȸ�� �����ȣ

reg [3:0] state;            // ����
reg [3:0] main_state;       // ���� ����
reg [3:0] pre_main_state;   // ���� ���� ����
reg [3:0] pre_state;        // ���� ����
reg day_night;              // �ְ�/�߰� (0:�ְ�, 1:�߰�)
reg pre_day_night;          // �ְ�/�߰� �ٲ�� �� ����
reg [31:0] timer;           // Ÿ�̸�
reg [31:0] emergency_timer; // ��޻�Ȳ Ÿ�̸�
reg [31:0] real_time;       // ���� �ð�

reg [3:0] hour_ten; // �����ڸ� �ð�
reg [3:0] hour_one; // �����ڸ� �ð�
reg [3:0] min_ten;  // �����ڸ� ��
reg [3:0] min_one;  // �����ڸ� ��
reg [3:0] sec_ten;  // �����ڸ� ��
reg [3:0] sec_one;  // �����ڸ� ��

wire ad_hour_btn_t;   // 1�ð� �߰� ��ư Ʈ����
wire emergency_btn_t; // �������� ��ư Ʈ����

parameter A_state  = 4'b0000, // �� ���� ����(A,B,C,D,E,F,G,H,EA)
          B_state  = 4'b0001,
          C_state  = 4'b0010,
          D_state  = 4'b0011,
          E_state  = 4'b0100,
          F_state  = 4'b0101,
          G_state  = 4'b0110,
          H_state  = 4'b0111,
          EA_state = 4'b1000;

LCD L1(rst, clk, state, day_night, hour_ten, hour_one, min_ten, min_one, sec_ten, sec_one, LCD_E, LCD_RS, LCD_RW, LCD_DATA[7:0]); // LCD ���
oneshot #(.WIDTH(2)) O1(clk, rst, {ad_hour_btn,emergency_btn}, {ad_hour_btn_t,emergency_btn_t});                                  // ���� ���


// ���� �ð��� ���� �ְ�,�߰� ���� ���� + 1�ð� �߰� ��� + �ð� ���� ����
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        day_night <= 1;             // ���۽�, �߰�(00:00:00)���� ����
        pre_day_night <= day_night; // ���� ��/�߰� ���¸� ���� ��/�߰� ���¿� ����
        real_time <= 0;             // ���� �ð� �ʱ�ȭ
        hour_ten <= 0;              // �����ڸ� �ð� �ʱ�ȭ
        hour_one <= 0;              // �����ڸ� �ð� �ʱ�ȭ
        min_ten <= 0;               // �����ڸ� �� �ʱ�ȭ
        min_one <= 0;               // �����ڸ� �� �ʱ�ȭ
        sec_ten <= 0;               // �����ڸ� �� �ʱ�ȭ
        sec_one <= 0;               // �����ڸ� �� �ʱ�ȭ
    end
    else begin
        if (real_time >= 86400000) real_time <= 0;                    // ���� �ð��� '24:00'(24*60*60*1000)�� �Ǹ�, ���� �ð� �ʱ�ȭ
        else if (ad_hour_btn_t) real_time <= real_time + 32'd3600000; // '1�ð� �߰� ��ư'�� ������, ���� �ð��� 1�ð�(1*60*60*1000) �߰�
        else begin
            case(dip)                                // dip ����ġ�� ����(00:1��, 01:10��, 10:100��, 11:200��)�� ���� ���� �ð� ���� ����
            2'b00: real_time <= real_time + 32'd1;   // 1�� �ð� ����
            2'b01: real_time <= real_time + 32'd10;  // 10�� �ð� ����
            2'b10: real_time <= real_time + 32'd100; // 100�� �ð� ����
            2'b11: real_time <= real_time + 32'd200; // 200�� �ð� ����
            endcase
            
            pre_day_night <= day_night; // ���� ��/�߰� ���¸� ���� ��/�߰� ���¿� ����
            
            // ��, ��, �� ���
            hour_ten <= real_time / 36000000;             // �ð��� ���� �ڸ� ����
            hour_one <= (real_time % 36000000) / 3600000; // �ð��� ���� �ڸ� ����
            min_ten <= (real_time % 3600000) / 600000;    // ���� ���� �ڸ� ����
            min_one <= (real_time % 600000) / 60000;      // ���� ���� �ڸ� ����
            sec_ten <= (real_time % 60000) / 10000;       // ���� ���� �ڸ� ����
            sec_one <= (real_time % 10000) / 1000;        // ���� ���� �ڸ� ����
        
            if (real_time >= 28800000 && real_time < 82800000) day_night <= 0; // ���� �ð��� '08:00'(8*60*60*1000)���� ũ�ų� '23:00'(23*60*60*1000)���� ������, �ְ����� ��ȯ
            else day_night <= 1;                                               // �� ���� ���� �ð����� �߰����� ��ȯ
        end
    end
end


// �ð��� ���� ���� ���� + ��ȣ�� ���� ����
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= B_state;             // ���� �ʱ�ȭ(���� ��, �߰��̹Ƿ� B_state)
        main_state <= 1;              // ���� ���� �ʱ�ȭ(���۽�, ù��° ������ ����)
        timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
        emergency_timer <= 0;         // ��޻�Ȳ Ÿ�̸� �ʱ�ȭ
        pre_state <= state;           // ���� ���� ����
        pre_main_state <= main_state; // ���� ���� ���� ����
    end
    else begin
        if (emergency_btn_t) begin        // '���� ���� ��ư' ������,
            pre_state <= state;           // ���� ���¸� ���� ���¿� ����
            pre_main_state <= main_state; // ���� ���� ���¸� ���� ���� ���¿� ����
            main_state <= 7;              // ���� ���� ���¸� 7(1�� ��� ����)�� ��ȯ -> ���� ���� 7,8�� ���������̹Ƿ� ��/�߰� ��� ������ �ڵ���
        end
        
        else if (day_night == 0) begin    // �ְ��� ��:A->D->F->E->G->E
            if (pre_day_night == 1) begin // ���� ��/�߰� ���°� �߰��̾��ٸ�,
                main_state <= 1;          // ���� ���� �ʱ�ȭ(ù��° ������ ����)
                state <= A_state;         // ���� �ʱ�ȭ(�ְ��̹Ƿ� A_state)
                timer <= 0;               // Ÿ�̸� �ʱ�ȭ
            end
            else begin
                case(main_state)
                    1:begin                               // ù��° ����
                        if(timer == 5000) begin           // Ÿ�̸Ӱ� 5��(5*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= D_state;             // ���� ��ȯ(A->D)
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    2:begin                               // �ι�° ����
                        if(timer == 5000) begin           // Ÿ�̸Ӱ� 5��(5*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= F_state;             // ���� ��ȯ(D->F)
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    3:begin                               // ����° ����
                        if(timer == 5000) begin           // Ÿ�̸Ӱ� 5��(5*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= E_state;             // ���� ��ȯ(F->E)
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    4:begin                               // �׹�° ����
                        if(timer == 5000) begin           // Ÿ�̸Ӱ� 5��(5*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= G_state;             // ���� ��ȯ(E->G)
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    5:begin                               // �ټ���° ����
                        if(timer == 5000) begin           // Ÿ�̸Ӱ� 5��(5*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= E_state;             // ���� ��ȯ(G->E)
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    6:begin                               // ������° ����
                        if(timer == 5000) begin           // Ÿ�̸Ӱ� 5��(5*1000)�� �Ǹ�,
                            main_state <= 1;              // ù��° ������ ��ȯ
                            state <= A_state;             // ���� ��ȯ(E->A)
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    7:begin                                          // 1�� ��� ����
                        if (emergency_timer >= 1000) begin           // 1��(1*1000)�� ������,
                            timer <= 0;                              // Ÿ�̸� �ʱ�ȭ
                            emergency_timer <= 0;                    // ��޻�Ȳ Ÿ�̸� �ʱ�ȭ
                            main_state <= 8;                         // ���� ���� ���¸� 8(��޻�Ȳ)�� ��ȯ
                            state <= EA_state;                       // ���� ��ȯ(���� ����->EA_state)
                        end
                        else emergency_timer <= emergency_timer + 1; // ��޻�Ȳ Ÿ�̸� ����
                    end
                    8:begin                                          // ��޻�Ȳ
                        if (emergency_timer >= 15000) begin          // 15�ʰ� ������,
                            emergency_timer <= 0;                    // ��޻�Ȳ Ÿ�̸� �ʱ�ȭ
                            main_state <= pre_main_state;            // ���� ���� ���·� ���ư�
                            state <= pre_state;                      // ���� ���·� ���ư�
                        end
                        else emergency_timer <= emergency_timer + 1; // ��޻�Ȳ Ÿ�̸� ����
                    end
                    default:state <= A_state;
                endcase
            end
        end
    
        else if (day_night == 1) begin    // �߰��� ��:B->A->C->A->E->H
            if (pre_day_night == 0) begin // ���� ��/�߰� ���°� �ְ��̾��ٸ�,
                main_state <= 1;          // ���� ���� �ʱ�ȭ(ù��° ������ ����)
                state <= B_state;         // ���� �ʱ�ȭ(�߰��̹Ƿ� B_state)
                timer <= 0;               // Ÿ�̸� �ʱ�ȭ
            end
            else begin
                case(main_state)
                    1:begin                               // ù��° ����
                        if(timer == 10000) begin          // Ÿ�̸Ӱ� 10��(10*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= A_state;             // ���� ��ȯ B->A
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    2:begin                               // �ι�° ����
                        if(timer == 10000) begin          // Ÿ�̸Ӱ� 10��(10*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= C_state;             // ���� ��ȯ A->C
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    3:begin                               // ����° ����
                        if(timer == 10000) begin          // Ÿ�̸Ӱ� 10��(10*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= A_state;             // ���� ��ȯ C->A
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    4:begin                               // �׹�° ����
                        if(timer == 10000) begin          // Ÿ�̸Ӱ� 10��(10*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= E_state;             // ���� ��ȯ A->E
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    5:begin                               // �ټ���° ����
                        if(timer == 10000) begin          // Ÿ�̸Ӱ� 10��(10*1000)�� �Ǹ�,
                            main_state <= main_state + 1; // ���� ������ ��ȯ
                            state <= H_state;             // ���� ��ȯ E->H
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    6:begin                               // ������° ����
                        if(timer == 10000) begin          // Ÿ�̸Ӱ� 10��(10*1000)�� �Ǹ�,
                            main_state <= 1;              // ù��° ������ ��ȯ
                            state <= B_state;             // ���� ��ȯ H->B
                            timer <= 0;                   // Ÿ�̸� �ʱ�ȭ
                        end
                        else timer <= timer + 1;          // Ÿ�̸� ����
                    end
                    7:begin                                          // 1�� ��� ����
                        if (emergency_timer >= 1000) begin           // 1��(1*1000)�� ������,
                            timer <= 0;                              // Ÿ�̸� �ʱ�ȭ
                            emergency_timer <= 0;                    // ��޻�Ȳ Ÿ�̸� �ʱ�ȭ
                            main_state <= 8;                         // ���� ���� ���¸� 8(��޻�Ȳ)�� ��ȯ
                            state <= EA_state;                       // ���� ��ȯ(���� ����->EA_state)
                        end
                        else emergency_timer <= emergency_timer + 1; // ��޻�Ȳ Ÿ�̸� ����
                    end
                    8:begin                                          // ��޻�Ȳ
                        if (emergency_timer >= 15000) begin          // 15�ʰ� ������,
                            emergency_timer <= 0;                    // ��޻�Ȳ Ÿ�̸� �ʱ�ȭ
                            main_state <= pre_main_state;            // ���� ���� ���·� ���ư�
                            state <= pre_state;                      // ���� ���·� ���ư�
                        end
                        else emergency_timer <= emergency_timer + 1; // ��޻�Ȳ Ÿ�̸� ����
                    end
                    default:state<=B_state;
                endcase
            end
        end
    end
end


// ���¿� ���� ��ȣ�� ���
always @(posedge clk or negedge rst) begin
    if(!rst) begin                                              // ���۽�, ��� ���� ��ȣ�� �ѱ�
        S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
        S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
        S_RED = 1; N_RED = 1; W_RED = 1; E_RED = 1;
        S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
        
        S_W_GREEN=0; N_W_GREEN=0; W_W_GREEN=0; E_W_GREEN=0;
        S_W_RED=1; N_W_RED=1; W_W_RED=1; E_W_RED=1;
    end
    else begin
        case (state)
            A_state: begin                                                          // ���� A
                S_GREEN = 1; N_GREEN = 1; W_GREEN = 0; E_GREEN = 0;
                S_RED = 0; N_RED = 0; W_RED = 1; E_RED = 1;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                S_W_RED = 1; N_W_RED = 1; W_W_RED = 0; E_W_RED = 0;
                
                if (day_night == 0) begin                                           // �ְ� �����ȣ ���� + Ȳ�� �ڵ�
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
                
                else if (day_night == 1) begin                                      // �߰� �����ȣ ���� + Ȳ�� �ڵ�
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
            
            B_state: begin                                                          // ���� B
                S_GREEN = 0; N_GREEN = 1; W_GREEN = 0; E_GREEN = 0;
                S_RED = 1; N_RED = 0; W_RED = 1; E_RED = 1;
                S_LEFT = 0; N_LEFT = 1; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 1;
                S_W_RED = 1; N_W_RED = 1; W_W_RED = 1; E_W_RED = 0;
                
                if (day_night == 1) begin                                           // �߰� �����ȣ ���� + Ȳ�� �ڵ�
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
            
            C_state: begin                                                          // ���� C
                S_GREEN = 1; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
                S_RED = 0; N_RED = 1; W_RED = 1; E_RED = 1;
                S_LEFT = 1; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 0;
                S_W_RED = 1; N_W_RED = 1; W_W_RED = 0; E_W_RED = 1;
                
                if (day_night == 1) begin                                           // �߰� �����ȣ ���� + Ȳ�� �ڵ�
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
            
            D_state: begin                                                  // ���� D
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
                S_RED = 0; N_RED = 0; W_RED = 1; E_RED = 1;
                S_LEFT = 1; N_LEFT = 1; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
               
                S_W_GREEN=0; N_W_GREEN=0; W_W_GREEN=0; E_W_GREEN=0;
                S_W_RED=1; N_W_RED=1; W_W_RED=1; E_W_RED=1;
                
                if (day_night == 0 && timer > 3500) begin                   // �ְ� Ȳ�� �ڵ�
                    S_YELLOW = 1; N_YELLOW = 1; W_YELLOW = 0; E_YELLOW = 0;
                end
            end
            
            E_state: begin                                                          // ���� E
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 1; E_GREEN = 1;
                S_RED = 1; N_RED = 1; W_RED = 0; E_RED = 0;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 1; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                S_W_RED = 0; N_W_RED = 0; W_W_RED = 1; E_W_RED = 1;
                
                if (day_night == 0) begin                                           // �ְ� �����ȣ ���� + Ȳ�� �ڵ�
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
                
                else if (day_night == 1) begin                                      // �߰� �����ȣ ���� + Ȳ�� �ڵ�
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
            
            F_state: begin                                                          // ���� F
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 1; E_GREEN = 0;
                S_RED = 1; N_RED = 1; W_RED = 0; E_RED = 1;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 1; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 1; W_W_GREEN = 0; E_W_GREEN = 0;
                S_W_RED = 1; N_W_RED = 0; W_W_RED = 1; E_W_RED = 1;
                
                if (day_night == 0) begin                                           // �ְ� �����ȣ ���� + Ȳ�� �ڵ�
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
            
            G_state: begin                                                          // ���� G
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 1;
                S_RED = 1; N_RED = 1; W_RED = 1; E_RED = 0;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 1;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 1; N_W_GREEN = 0; W_W_GREEN = 0; E_W_GREEN = 0;
                S_W_RED = 0; N_W_RED = 1; W_W_RED = 1; E_W_RED = 1;
                
                if (day_night == 0) begin                                           // �ְ� �����ȣ ���� + Ȳ�� �ڵ�
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
            
            H_state: begin                                                  // ���� H
                S_GREEN = 0; N_GREEN = 0; W_GREEN = 0; E_GREEN = 0;
                S_RED = 1; N_RED = 1; W_RED = 0; E_RED = 0;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 1; E_LEFT = 1;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN=0; N_W_GREEN=0; W_W_GREEN=0; E_W_GREEN=0;
                S_W_RED=1; N_W_RED=1; W_W_RED=1; E_W_RED=1;
                
                if (day_night == 1 && timer > 8500) begin                   // �߰� Ȳ�� �ڵ�
                    S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 1; E_YELLOW = 1;
                end
            end
            
            EA_state: begin                                                         // ���� EA
                S_GREEN = 1; N_GREEN = 1; W_GREEN = 0; E_GREEN = 0;
                S_RED = 0; N_RED = 0; W_RED = 1; E_RED = 1;
                S_LEFT = 0; N_LEFT = 0; W_LEFT = 0; E_LEFT = 0;
                S_YELLOW = 0; N_YELLOW = 0; W_YELLOW = 0; E_YELLOW = 0;
                
                S_W_GREEN = 0; N_W_GREEN = 0; W_W_GREEN = 1; E_W_GREEN = 1;
                S_W_RED = 1; N_W_RED = 1; W_W_RED = 0; E_W_RED = 0;
                
                if (day_night == 0 || day_night == 1) begin                         // �����ȣ ���� + Ȳ�� �ڵ�(��/�߰� ���� ����)
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
            default: begin                                              // ��� ��ȣ ����
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
