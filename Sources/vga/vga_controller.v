`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2020 07:53:13 PM
// Design Name: 
// Module Name: vga_controller
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


module vga_controller(
    input CLK100MHZ,     // board clock
    input CPU_RESETN,    // reset
    input [16:0] data,
    output [3:0] VGA_R,  // 4-bit red output
    output [3:0] VGA_G,  // 4-bit green output
    output [3:0] VGA_B,  // 4-bit blue output
    output [1:0] row,
    output [1:0] col,
    output VGA_HS,       // horizontal sync output
    output VGA_VS,       // vertical sync output
    output de
    );
    
    reg [3:0] cur_r;
    reg [3:0] cur_g;
    reg [3:0] cur_b;
    
    wire [11:0] board_color;
    wire [9:0] cx;
    wire [9:0] cy;
    wire pix_stb;
    wire board_draw;
    
    CLK60HZ rr(.CLK100MHZ(CLK100MHZ), .stb(pix_stb));
    vga640x480 display(.CLK100MHZ(CLK100MHZ), .pix_stb(pix_stb), .reset(~CPU_RESETN), 
                        .hs(VGA_HS), .vs(VGA_VS), .de(de), .x(cx), .y(cy));
    board_disp board_graphics(.CLK100MHZ(CLK100MHZ), .data(data), .cx(cx), .cy(cy), .pix_stb(pix_stb),
                                .VGA_color(board_color), .row(row), .col(col), .draw(board_draw));
  
    assign VGA_R = de ? cur_r: 4'h0;
    assign VGA_G = de ? cur_g: 4'h0;
    assign VGA_B = de ? cur_b: 4'h0;
        
    always @(posedge pix_stb)begin
        if(board_draw)begin
            cur_r <= board_color[11:8];
            cur_g <= board_color[7:4];
            cur_b <= board_color[3:0];
        end else begin
            cur_r <= 4'hf;
            cur_g <= 4'hf;
            cur_b <= 4'he;
        end
    end    
endmodule