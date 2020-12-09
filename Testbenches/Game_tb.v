`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2020 06:05:33 PM
// Design Name: 
// Module Name: Game_tb
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


module Game_tb();
    reg CLK100MHZ;
    reg CPU_RESETN;
    reg PS2_CLK;
    reg PS2_DATA;
    
    wire [3:0] VGA_R;
    wire [3:0] VGA_G;
    wire [3:0] VGA_B;
    wire VGA_HS;
    wire VGA_VS;
    
    Game game(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .PS2_CLK(PS2_CLK), .PS2_DATA(PS2_DATA),
                .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS));
    
    always
        #5 CLK100MHZ = ~CLK100MHZ;
        
    initial begin
        CLK100MHZ = 0; CPU_RESETN = 0; PS2_CLK = 0; PS2_DATA = 0;
        
        #20 CPU_RESETN = 1;
    end
endmodule
