`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2020 01:04:02 PM
// Design Name: 
// Module Name: LFSR_tb
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


module LFSR_tb();
    reg CLK100MHZ;
    reg CPU_RESETN;
    
    wire [3:0] rnd;
    
    LFSR random(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(~CPU_RESETN), .rnd(rnd));
    
    always
        #5 CLK100MHZ = ~CLK100MHZ;
        
    initial begin
        CLK100MHZ = 0; CPU_RESETN = 0;
    end
endmodule
