# ee354_final_project

Blind Maze Game by Matthew Jiang and Kelvin Cao, A.K.A Ash Ketchum Saves Pikachu -_-

### Map Generation

Maps are randomly generated and validated using a script, and later read into FPGA memory. The map generation script is written using the rust language but simply outputs a text file with a map, 1 representing an obstacle and 0 representing a clear space. Map generation rules can be altered.
