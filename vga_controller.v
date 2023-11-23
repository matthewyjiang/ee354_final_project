`timescale 1ns / 1ps

module vga_controller(
    input wire clk,          // Main clock
    input wire reset,        // Reset signal
    output wire hsync,       // Horizontal sync output
    output wire vsync,       // Vertical sync output
    
    output reg [9:0] hCount, // Horizontal counter
    output reg [9:0] vCount  // Vertical counter
    output reg bright
);

    localparam H_MAX = 10'd799;
    localparam V_MAX = 10'd524;

    localparam H_SYNC_PULSE = 10'd96;
    localparam V_SYNC_PULSE = 10'd2;

    reg pulse;
    reg clk25;

    initial begin // Set all of them initially to 0
		clk25 = 0;
		pulse = 0;
        hCount = 10'b0000000000;
        vCount = 10'b0000000000;
	end

    always @(posedge clk)
		pulse = ~pulse;
	always @(posedge pulse)
		clk25 = ~clk25;
		
    // VGA signal generation logic goes here
    always @(posedge clk25) begin

        // Increment counters
        hCount <= (hCount == H_MAX) ? 0 : hCount + 1;
        if (hCount == H_MAX) begin
            vCount <= (vCount == V_MAX) ? 0 : vCount + 1;
        end
    end

    always @(posedge clk25)
		begin
		if(hCount > 10'd143 && hCount < 10'd784 && vCount > 10'd34 && vCount < 10'd516)
			bright <= 1;
		else
			bright <= 0;
		end	

    // Generate sync signals


assign hsync = (hCount < H_SYNC_PULSE) ? 1'b0 : 1'b1;
assign vsync = (vCount < V_SYNC_PULSE) ? 1'b0 : 1'b1;

endmodule