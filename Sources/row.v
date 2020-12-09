`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2020 09:46:12 AM
// Design Name: 
// Module Name: row
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


module row(
    input CLK100MHZ,
    input [16:0] data,
    input [9:0] sy,
    input [9:0] cx,
    input [9:0] cy,
    output [11:0] VGA_color,
    output [1:0] position,
    output draw
    );
    
    reg [11:0] color = 0;
    
    wire [11:0] col1_color;
    wire [11:0] col2_color;
    wire [11:0] col3_color;
    wire [11:0] col4_color;
    wire [3:0] col_draw;
    
    square col1(.color(color), .sx(10'd182), .sy(sy), .cx(cx), .cy(cy), .size(10'd60),
                    .VGA_R(col1_color[11:8]), .VGA_G(col1_color[7:4]), .VGA_B(col1_color[3:0]),
                    .draw(col_draw[0]));
    square col2(.color(color), .sx(10'd254), .sy(sy), .cx(cx), .cy(cy), .size(10'd60),
                    .VGA_R(col2_color[11:8]), .VGA_G(col2_color[7:4]), .VGA_B(col2_color[3:0]),
                    .draw(col_draw[1]));
    square col3(.color(color), .sx(10'd326), .sy(sy), .cx(cx), .cy(cy), .size(10'd60),
                    .VGA_R(col3_color[11:8]), .VGA_G(col3_color[7:4]), .VGA_B(col3_color[3:0]),
                    .draw(col_draw[2]));
    square col4(.color(color), .sx(10'd398), .sy(sy), .cx(cx), .cy(cy), .size(10'd60),
                    .VGA_R(col4_color[11:8]), .VGA_G(col4_color[7:4]), .VGA_B(col4_color[3:0]), 
                    .draw(col_draw[3]));
                    
    assign draw = col_draw[3] | col_draw[2] | col_draw[1] | col_draw[0];
    assign position = col_draw[3] ? 3: col_draw[2] ? 2: col_draw[1] ? 1: col_draw[0] ? 0: 0;
    assign VGA_color = col_draw[3] ? col4_color: col_draw[2] ? col3_color: 
                    col_draw[1] ? col2_color: col_draw[0] ? col1_color: 0;
    
    always @(*)begin
        case(data)
            0: color <= 12'hccb;
            2: color <= 12'h00f;
            4: color <= 12'h0f0;
            8: color <= 12'hf00;
            16: color <= 12'hf0f;
            32: color <= 12'hff0;
            64: color <= 12'h0ff;
            128: color <= 12'h123;
            256: color <= 12'h953;
            512: color <= 12'h501;
            1024: color <= 12'h459;
            2048: color <= 12'haaa;
            default: color <= color;
        endcase
    end
endmodule
