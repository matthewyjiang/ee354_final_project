`timescale 1ns / 1ps

module vga_controller(
    input wire clk,          // Main clock
    input wire reset,        // Reset signal
    output wire hsync,       // Horizontal sync output
    output wire vsync,       // Vertical sync output
    output reg [11:0] rgb,   // RGB output
    output reg [9:0] h_counter, // Horizontal counter
    output reg [9:0] v_counter  // Vertical counter
    
);

    
    

    localparam H_MAX = 10'd799;
    localparam V_MAX = 10'd599;

    localparam H_SYNC_PULSE = 10'd96;
    localparam V_SYNC_PULSE = 10'd2;

    reg pulse;
    reg clk25;

    initial begin // Set all of them initially to 0
		clk25 = 0;
		pulse = 0;
        h_counter = 10'b0000000000;
        v_counter = 10'b0000000000;
        rgb = 12'b111100000000;
	end

    always @(posedge clk)
		pulse = ~pulse;
	always @(posedge pulse)
		clk25 = ~clk25;
		

    // VGA signal generation logic goes here
    always @(posedge clk25) begin
        // Generate sync pulses and pixel data here
        rgb <= 12'b111100000000; // Black color temp

        // Increment counters
        h_counter <= (h_counter == H_MAX) ? 0 : h_counter + 1;
        if (h_counter == H_MAX) begin
            v_counter <= (v_counter == V_MAX) ? 0 : v_counter + 1;
        end
    end


assign hsync = (h_counter < H_SYNC_PULSE) ? 1'b0 : 1'b1;
assign vsync = (v_counter < V_SYNC_PULSE) ? 1'b0 : 1'b1;

endmodule