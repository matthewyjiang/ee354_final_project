module top_design (
    input clk,
    input reset,
    output reg [7:0] led
);

// Instantiate the maze module
maze maze_inst (
    .clk(clk),
    .reset(reset),
    .led(led)
);

endmodule

// Instantiate the maze module
module maze (
    input clk,
    input reset,
    output reg [7:0] led
);

// Your maze module code here

endmodule
