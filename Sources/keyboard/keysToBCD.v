`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2020 11:38:01 AM
// Design Name: 
// Module Name: keysToBCD
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

module keysToBCD(
    input CLK100MHZ,
    input CPU_RESETN,
    input PS2_CLK,
    input PS2_DATA,
    output reg [3:0] BCD = 4'b1111,
    output newVal
    );
    
    wire [31:0] keypress;
    
    keyboard KB(.PS2_CLK(PS2_CLK), .PS2_DATA(PS2_DATA), .keypress(keypress), .newVal(newVal));
    
    always @(posedge CLK100MHZ)begin
        if(~CPU_RESETN)begin
            BCD <= 4'b1111;
        end else begin
            if(newVal)begin
                if(keypress[15:8] == 8'hf0)begin
                    if((keypress[23:16] == 8'he0) | (keypress[7:0] == 8'h2d))begin
                        case(keypress[7:0])
                            8'h6b: BCD <= 4'b0000; //0 (Left)
                            8'h74: BCD <= 4'b0001; //1 (Right)
                            8'h75: BCD <= 4'b0010; //2 (Up)
                            8'h72: BCD <= 4'b0011; //3 (Down)
                            8'h2d: BCD <= 4'b1000; //R (Reset)                    
                            default: BCD <= 4'b1111;
                        endcase
                    end else
                        BCD <= 4'b1111;
                end 
            end
        end
    end
endmodule