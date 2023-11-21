# Blind Maze Game (FPGA Game)

Blind Maze Game for **Digilent Nexys A7** by Matthew Jiang and Kelvin Cao, A.K.A Ash Ketchum Saves Pikachu -_-

Final project for EE354 (Introduction to Digital Circuit Design) at USC

## Game Objective

The objective of the game is too reach the end point, which is marked and exactly 30 units across from the start.

The player is shown the maze layout for a short duration, depending on the difficulty selection. The player now needs to attempt to navigate the to the end point, with a lack of information. If a maze obstacle is hit, the player is reset to the beginning and shown the map layout again for a short duration. 

## Map Generation

Maps are randomly generated and validated using a script, and later read into FPGA memory. The map generation script is written using the rust language but simply outputs a text file with a map, 1 representing an obstacle and 0 representing a clear space. Map generation rules can be altered.

## Controls

The game is controlled by the FPGA push buttons. 

- Center Button: reset game
- Top Button: move up
- Bottom Button: move down
- Left Button: move left
- Right Button: move right

The buttons are also used to navigate the menu.

- Left Button: change selection left
- Right Button: change selection right
- Top Button: select item

## Build Instructions

- Clone the project and import it into Vivado, select all verilog files to add to project. 
- Generate the bitstream file and upload it to the FPGA Board. 
- **This project is designed for the Nexys A7 Variant and thus only contains design constraints (.xdc file) to support the Nexys A7 board.**
