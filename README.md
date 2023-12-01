# Blind Maze Game (FPGA Game)

Blind Maze Game for **Digilent Nexys A7** by Matthew Jiang and Kelvin Cao.

Final project for EE354 (Introduction to Digital Circuit Design) at USC

## Game Objective

The objective of the game is too reach the end point, which is marked green and exactly 30 units across from the start.

The player is shown the maze layout for a short duration, depending on the difficulty selection. The player now needs to attempt to navigate the to the end point, with a lack of information. If a maze obstacle is hit, the player loses and must reset the game by pressing btnC.

## Map Generation

Maps are randomly generated and validated using a script, and later read into FPGA memory. The map generation script is written using the rust language but simply outputs a text file with a map, 1 representing an obstacle and 0 representing a clear space. Map generation rules can be altered.

## Controls

The game is controlled by the FPGA push buttons. 

- Center Button: reset game
- Top Button: move up
- Bottom Button: move down
- Left Button: move left
- Right Button: move right

- In starting menu (blue), top button -> start
- When lost (red) or won (green), center button -> reset game 

## Build Instructions

- Clone the project and import it into Vivado, select all verilog files to add to project. 
- Generate the bitstream file and upload it to the FPGA Board. 
- **This project is designed for the Nexys A7 Variant and thus only contains design constraints (.xdc file) to support the Nexys A7 board.**
