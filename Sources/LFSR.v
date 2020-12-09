`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2020 12:50:11 PM
// Design Name: 
// Module Name: LFSR
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


module LFSR(
    input CLK100MHZ,
    input CPU_RESETN,
    output reg [3:0] rnd = 0
    );
    
    reg [3:0] random = 4'ha;
    reg [3:0] random_next = 0;
    reg [2:0] counter = 0;
    reg [2:0] counter_next = 0;
    
    wire feedback = random[3] ^ random[2];
    
    always @(posedge CLK100MHZ)begin
        if(~CPU_RESETN)begin
            random <= 4'hf;
            counter <= 0;
        end else begin
            random <= random_next;
            counter <= counter_next;
        end
        
        if(counter == 3)begin
            counter <= 0;
            rnd = random;
        end    
    end
    
    always @(*)begin
        random_next = random;
        counter_next = counter;
        
        random_next = {random[2:0], feedback};
        counter_next = counter + 1;
    end
endmodule