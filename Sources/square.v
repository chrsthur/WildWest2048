`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2020 06:36:12 PM
// Design Name: 
// Module Name: square
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


module square(
    input [11:0] color,
    input [9:0] sx,
    input [9:0] sy,
    input [9:0] cx,
    input [9:0] cy,
    input [9:0] size,
    output [3:0] VGA_R,
    output [3:0] VGA_G,
    output [3:0] VGA_B,
    output draw
    );
    
    assign draw = ((cx >= sx) && (cx < sx + size)) && ((cy >= sy) && (cy < sy + size));
    assign VGA_R = color[11:8];
    assign VGA_G = color[7:4];
    assign VGA_B = color[3:0];     
endmodule
