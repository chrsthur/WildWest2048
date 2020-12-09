`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2020 01:35:17 PM
// Design Name: 
// Module Name: board_move
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


module board(
    input CLK100MHZ,
    input CPU_RESETN,
    input [1:0] direction,
    input [1:0] row,
    input [1:0] col,
    input de,
    input newMove,
    input start,
    output [16:0] data,
    output [1:0] state,
    output reg done
    );
    
    reg [16:0] board[0:3][0:3];
    reg [2:0] i = 0;
    reg [2:0] j = 0;
    reg [1:0] curState = 0;
    reg [1:0] nextState = 0;
    reg movCurState = 0;
    reg movNextState = 0;
    reg [1:0] rndrow = 0;
    reg [1:0] rndcol = 0;
    reg [1:0] startCounter = 0;
    reg [1:0] frameCounter = 2;
    reg addBlock = 1;
    reg deCounter = 0;
    reg stb = 0;
    reg stbCounter = 0;
    reg moving = 0;
    
    wire [16:0] newBoard[0:3][0:3];
    wire [3:0] rnd;
    wire frame_done;
       
    LFSR random(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .rnd(rnd));
    /*board_move move(.CLK100MHZ(CLK100MHZ), .CPU_RESETN(CPU_RESETN), .board(board), 
                    .direction(direction), .state(curState), .de(de), .stb(stb), .newMove(newMove), 
                    .outBoard(newBoard), .done(done), .frame_done(frame_done));*/
    
    assign data = board[row][col];
    assign state = movCurState;
    
    always @(posedge CLK100MHZ)begin
        if(~CPU_RESETN)begin
            nextState <= 0;
            startCounter <= 0;
            addBlock <= 1;
            movNextState <= 0;
            moving = 0;
        end else begin
            case(curState)
                0: begin                        
                        for(i = 0; i < 4; i = i + 1)begin
                            for(j = 0; j < 4; j = j + 1)begin
                                board[i][j] <= 0;
                            end        
                        end
                        
                        if(start)begin
                            nextState <= 1;
                        end
                   end
                1: begin
                        if(startCounter == 0)begin
                            for(i = 0; i < 4; i = i + 1)begin
                                for(j = 0; j < 4; j = j + 1)begin
                                    board[i][j] <= 0;
                                end        
                            end
                    
                            rndrow <= rnd[1:0];
                            rndcol <= rnd[3:2];
                        
                            board[rndrow][rndcol] <= 2;
                        
                            startCounter <= startCounter + 1;
                        end
                    
                        rndrow <= rnd[1:0];
                        rndcol <= rnd[3:2];
                    
                        if((board[rndrow][rndcol] == 0) & (startCounter <= 1))begin
                            board[rndrow][rndcol] <= 2;
                            startCounter <= startCounter + 1;
                        end
                                            
                        if(newMove)begin
                            frameCounter <= 0;
                            movNextState <= 1;
                            nextState <= 2;
                        end
                   end
                2: begin                        
                        if(start)begin
                            startCounter <= 0;
                            nextState <= 1;
                        end
                        
                        case(movCurState)
                            0: begin
                                    if(addBlock)begin
                                        rndrow <= rnd[1:0];
                                        rndcol <= rnd[3:2];
                                                               
                                        if(board[rndrow][rndcol] == 0)begin
                                            board[rndrow][rndcol] = 2;
                                            addBlock <= 0;
                                        end
                                    end else begin
                                        if(newMove)begin
                                            stb <= 1;
                                            movNextState <= 1;
                                        end
                                    end
                               end
                            1: begin                                    
                                    if(~de)begin
                                        moving = 0;
                                        
                                        case(direction)
                                            0: begin //move board left
                                                for(i = 0; i < 4; i = i + 1)begin
                                                    for(j = 1; j < 4; j = j + 1)begin
                                                        if(board[i][j-1] == 0)begin
                                                            board[i][j-1] <= board[i][j];
                                                            board[i][j] <= 0;
                                                            moving = 1;
                                                        end else if (board[i][j-1] == board[i][j])begin
                                                            board[i][j-1] <= board[i][j-1] + board[i][j];
                                                            board[i][j] <= 0;
                                                            moving = 1;
                                                        end                                            
                                                    end
                                                end
                                               end
                                            1: begin //move board right
                                                for(i = 0; i < 4; i = i + 1)begin
                                                    for(j = 0; j < 3; j = j + 1)begin
                                                        if(board[i][3-j] == 0)begin
                                                            board[i][3-j] <= board[i][2-j];
                                                            board[i][2-j] <= 0;
                                                            moving = 1;
                                                        end else if (board[i][3-j] == board[i][2-j])begin
                                                            board[i][3-j] <= board[i][3-j] + board[i][2-j];
                                                            board[i][2-j] <= 0;
                                                            moving = 1;
                                                        end
                                                    end
                                                end
                                               end
                                            2: begin //move board up
                                                for(i = 1; i < 4; i = i + 1)begin
                                                    for(j = 0; j < 4; j = j + 1)begin
                                                        if(board[i-1][j] == 0)begin
                                                            board[i-1][j] <= board[i][j];
                                                            board[i][j] <= 0;
                                                            moving = 1;
                                                        end else if (board[i-1][j] == board[i][j])begin
                                                            board[i-1][j] <= board[i-1][j] + board[i][j];
                                                            board[i][j] <= 0;
                                                            moving = 1;
                                                        end
                                                    end
                                                end
                                               end
                                            3: begin //move board down
                                                for(i = 0; i < 3; i = i + 1)begin
                                                    for(j = 0; j < 4; j = j + 1)begin
                                                        if(board[3-i][j] == 0)begin
                                                            board[3-i][j] <= board[2-i][j];
                                                            board[2-i][j] <= 0;
                                                            moving = 1;
                                                        end else if (board[3-i][j] == board[2-i][j])begin
                                                            board[3-i][j] <= board[3-i][j] + board[2-i][j];
                                                            board[2-i][j] <= 0;
                                                            moving = 1;
                                                        end
                                                    end
                                                end
                                           end   
                                        endcase
                                    
                                        done = moving;
                                    
                                        if(~moving)begin
                                            addBlock <= 1;
                                            movNextState <= 0;
                                        end
                                    end
                               end
                        endcase
                   end
                3:;
            endcase
        end
    end
    
    always @(negedge CLK100MHZ)begin
        if(~CPU_RESETN)begin
            curState <= 0;
            movCurState <= 0;
        end else begin
            curState <= nextState;
            movCurState <= movNextState;
        end
    end
endmodule