`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2020 03:42:04 PM
// Design Name: 
// Module Name: Game
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


module Game(
    input CLK100MHZ,
    input CPU_RESETN,
    input PS2_CLK,
    input PS2_DATA,
    output [7:0] AN,
    output [6:0] seg,
    output [3:0] VGA_R,  // 4-bit red output
    output [3:0] VGA_G,  // 4-bit green output
    output [3:0] VGA_B,  // 4-bit blue output
    output VGA_HS,       // horizontal sync output
    output VGA_VS,       // vertical sync output
    output led1,
    output led2,
    output led3
    );
    
    reg [4:0] digit_holder = 0;
    reg [1:0] direction = 0;
    reg start = 0;
    reg newValCounter = 0;
    
    wire [16:0] data;
    wire [3:0] BCD;
    wire [2:0] rr;
    wire [1:0] state;
    wire [1:0] row;
    wire [1:0] col;
    wire newMove;
    wire de;
    wire newVal;
    wire done;
    
    board Board(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .direction(direction), 
                .row(row), .col(col), .de(de), .newMove(newMove), .start(start),
                .data(data), .state(state), .done(done));
    vga_controller disp(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .data(data),
                    .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .row(row), .col(col), 
                    .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .de(de));
    keysToBCD keyboard(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .PS2_CLK(PS2_CLK), 
                        .PS2_DATA(PS2_DATA), .BCD(BCD), .newVal(newVal));
    disp_7_seg disp_seg(.CLK100MHZ(CLK100MHZ), .digit_holder(digit_holder), .refresh_rate(rr), .AN(AN), .seg(seg));
    
    assign led1 = newVal;
    assign led2 = newValCounter;
    assign led3 = done;
    assign newMove = newVal & ~done;
    
    always @(negedge newVal)begin
        if(BCD <= 3)begin
            direction <= BCD[1:0];
        end else if(BCD == 4'b1000)begin
            
        end
    end
    
    always @(negedge CLK100MHZ)begin
        if(~CPU_RESETN)begin
            start <= 0;
        end else begin
            if((BCD == 4'b1000) & ~newVal)begin
                start <= 1;
            end
            
            if(newVal)begin
                start <= 0;
            end
        end
    end
    
    always @(posedge CLK100MHZ)begin
        case(rr)
            3'b000: digit_holder <= done;
            3'b111: digit_holder <= state;
            default: digit_holder <= 5'b10000;
        endcase
    end
endmodule
