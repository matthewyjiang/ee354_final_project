`timescale 1ns / 1ps

module vga_controller(
    input wire clk,          // Main clock
    output wire hsync,       // Horizontal sync output
    output wire vsync,       // Vertical sync output
    
    output reg [9:0] hCount, // Horizontal counter
    output reg [9:0] vCount,  // Vertical counter
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
	end

    always @(posedge clk)
		pulse = ~pulse;
	always @(posedge pulse)
		clk25 = ~clk25;
		
    // VGA signal generation logic goes here
    always @(posedge clk25) begin
		if (hCount < H_MAX)
			begin
			hCount <= hCount + 1;
			end
		else if (vCount < V_MAX)
			begin
			hCount <= 0;
			vCount <= vCount + 1;
			end
		else
			begin
			hCount <= 0;
			vCount <= 0;
			end
    end

        // Generate sync signals
    assign hsync = (hCount < H_SYNC_PULSE) ? 0 : 1;
    assign vsync = (vCount < V_SYNC_PULSE) ? 0 : 1;

    always @(posedge clk25)
		begin
		if(hCount > 10'd143 && hCount < 10'd784 && vCount > 10'd34 && vCount < 10'd516)
			bright <= 1;
		else
			bright <= 0;
		end	



endmodule