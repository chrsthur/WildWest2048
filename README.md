# 2048: Wild West Edition

### Team 17 (EC311 - Fall 2020)
- Christian Arthur      U73865489
- Youssef Atti          U52172337
- Asbel Fontanez        U75551061
- Abdullah Gramish      U09439898

## Demo Video
Youtube Link: [Click Here!](youtube.com/...)

## Project Overview
### Description
Our game is a derivation of 2048, we call it the 2048 Wild West Edition. Where to actually start the game the user needs to figure out the pattern and speed to press the arrow keys. Once the real game starts random invisible blocks will be added to board, this will block combinations from occuring. Then multicolor blocks can be added randomly which a player may think they can combine but they may not be able to. Its the players task to figure out how to use the games bugs and quirks to keep the board clean for as long as possible.

### Game Goal
Keep the board free for as long as possible. Once the board is full of the evil little blocks then game is over no matter if there is possible combos.

## Installation and Usage Guide
### Downloading "2048: Wild West Edition" Game Files
To download go to the GitHub repository for the [2048: Wild West Edition](https://github.com/chrsthur/WildWest2048) and click on the green "Clone or Download" button on the top right. Then click "Download ZIP" right below the green button. Unzip the zip file once it finished downloading. An alternative is to clone the repository through a terminal (for example, Git bash) and do "git clone https://github.com/chrsthur/WildWest2048". The repository would hold the source, simulation, and constraint files for the game.

### Installing Pre-requisites
To run the game, you need to have Vivado 2020.2. If you do not have the latest version yet, please update it by downloading the newest version from the [Xilinx website](https://www.xilinx.com/support/download.html). The game is also designed to be used on the Nexys A7 FPGA board as well so you would not be able to use a different FPGA board model to run the game.

### Installing and Running the Game
1. Run Vivado 2020.2
2. Import the modules (in the Sources folder) into the project srcs/sources folder
3. Import the constraint file to the project
4. Run the RTL analysis process for the project
5. Run the synthesis process for the project
6. Run the implementation process for the project
7. Generate the bitstream
8. Program the bitstream to the FPGA board
9. Connect a keyboard and a screen with a VGA output to play and display the game.
10. HAVE FUN!

## Code Structure (Overview)
### Keyboard Input
**keysToBCD and keyboard module**<br/>
These modules work by receiving input from a key pressed by the user on the keyboard (arrow keys) and translating it to an encoding of the command which includes:
- Move Up
- Move Down
- Move Left
- Move Right
- Reset (Board)

These commands would be encoded in BCD format to be processed by the game and board modules.<br/><br/>

### Board
**Random Value and Block Generator + LFSR**<br/>
The LFSR (Linear Feedback Shift Register) module would generate random numbers for the block values and the block location on the game board. This would be used in the Finite State Machine implemented in the board module to place random blocks with random values (symbolized with different colors) on the game board.<br/><br/>

**Finite State Machine (FSM)**<br/>
The Finite State Machine would control what state the board is in. This state machine would have 3 different states:
- Initial State
  - This state would generate a blank game board by generating a value of 0 for each cells in the game board.
- Start State
  - This state would use the random values and block location generated by the LFSR and place it on the game board.
- Move State
  - This state would process the keyboard input encoded in BCD format and translate it into a movement by updating the current board accordingly.

**Movement Logic**<br/>
 This would be a case statement to move the blocks accordingly based on the keyboard input that was read through the keysToBCD module. <br/><br/>

### Display
**vga_controller module**<br/>
Generates RGB output for the VGA based on the outputs of the board_graphics module. <br/><br/>

**CLK60HZ module**<br/>
A clock divider module to create a clock with a frequency/refresh rate of 60 Hz based on the 100 MHz clock on FPGA. <br/><br/>

**vga640x480 module**<br/>
Generates the VGA output for a screen with resolution of 640x480 pixels. This module would refresh the screen at a refresh rate of 60Hz using the divided clock created by the CLK60HZ module. <br/><br/>

**row module**<br/>
The row module is a combination of 4 square cells. The row module also retrieves the data from the board module and decides what color to make the current cell.

**square module**<br/>
The square takes color, position, size, and current position as inputs that then is used to decided if this square needs to be drawn and what color needs to be drawn. This is used to make the individual cells and the overall board.

## Note from the Developer
This game may first bring you to anger and to rage quit. This isn't the purpose of the game. We made this game for the player to learn how to look inside themselves and be as patient as possible. Through this patience they learn how to deal with the bugs and quirks of the game allowing them to live as long as possible in the game. Which translate to real life where people need to learn how to deal with the curveballs thrown at them, and with this game we use the randominess to force the player to deal with this as well.
