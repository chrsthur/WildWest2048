`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2020 11:47:35 AM
// Design Name: 
// Module Name: board_disp
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


module board_disp(
    input CLK100MHZ,
    input [16:0] data,
    input [9:0] cx,
    input [9:0] cy,
    input pix_stb,
    output reg [11:0] VGA_color = 0,
    output [1:0] row,
    output [1:0] col,
    output draw
    );
    
    wire [11:0] board_color;
    wire [11:0] row1_color;
    wire [11:0] row2_color;
    wire [11:0] row3_color;
    wire [11:0] row4_color;
    wire [4:0] cur_draw;
    wire [1:0] row1_col;
    wire [1:0] row2_col;
    wire [1:0] row3_col;
    wire [1:0] row4_col;
    
    square board(.color(12'hbba), .sx(10'd170), .sy(10'd90), .cx(cx), .cy(cy), .size(10'd300),
              .VGA_R(board_color[11:8]), .VGA_G(board_color[7:4]), .VGA_B(board_color[3:0]),
              .draw(cur_draw[0]));
    row row1(.CLK100MHZ(CLK100MHZ), .data(data), .sy(10'd102), .cx(cx), .cy(cy),
                .VGA_color(row1_color), .position(row1_col), .draw(cur_draw[1]));
    row row2(.CLK100MHZ(CLK100MHZ), .data(data), .sy(10'd174), .cx(cx), .cy(cy),
                .VGA_color(row2_color), .position(row2_col), .draw(cur_draw[2]));
    row row3(.CLK100MHZ(CLK100MHZ), .data(data), .sy(10'd246), .cx(cx), .cy(cy),
                .VGA_color(row3_color), .position(row3_col), .draw(cur_draw[3]));
    row row4(.CLK100MHZ(CLK100MHZ), .data(data), .sy(10'd318), .cx(cx), .cy(cy),
                .VGA_color(row4_color), .position(row4_col), .draw(cur_draw[4])); 
    
    assign draw = cur_draw[4] | cur_draw[3] | cur_draw[2] | cur_draw[1] | cur_draw[0];
    assign row = cur_draw[4] ? 3: cur_draw[3] ? 2: cur_draw[2] ? 1: 0;
    assign col = cur_draw[4] ? row4_col: cur_draw[3] ? row3_col: cur_draw[2] ? row2_col:
                    cur_draw[1] ? row1_col: 0; 
                        
    always @(*)begin
        if(cur_draw[4])
            VGA_color = row4_color;
        else if(cur_draw[3])
            VGA_color = row3_color;
        else if(cur_draw[2])
            VGA_color = row2_color;
        else if(cur_draw[1])
            VGA_color = row1_color;
        else
            VGA_color = board_color;
    end
endmodule