`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2020 07:38:21 PM
// Design Name: 
// Module Name: CLK60HZ
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


module CLK60HZ(
    input CLK100MHZ,
    output reg stb
    );
    
    reg [15:0] counter = 0;
    
    always @(posedge CLK100MHZ) 
        {stb, counter} <= counter + 16'h4000;
endmodule
