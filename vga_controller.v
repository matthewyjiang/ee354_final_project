`timescale 1ns / 1ps

module vga_controller(
    input wire clk,          // Main clock
    input wire reset,        // Reset signal
    input wire [7:0] player_x_pos,
    input wire[7:0] player_y_pos,
    output wire hsync,       // Horizontal sync output
    output wire vsync,       // Vertical sync output
    output reg [11:0] rgb,   // RGB output
    output reg [9:0] hCount, // Horizontal counter
    output reg [9:0] vCount  // Vertical counter
);
    localparam ADDRW = $clog2(21);

    reg [ADDRW-1:0] addr;
    wire [29:0] map_data_out; // 30 bits for 21x30 map

    rom  #( .WIDTH(30), .DEPTH(21), .INIT_F("map.mem")) map_rom_inst  (
        .clk(clk),
        .addr(addr),
        .addr_out(),
        .data_out(map_data_out)
    );
    
    localparam player_width = 20;

    localparam H_MAX = 10'799;
    localparam V_MAX = 10'520;

    localparam H_SYNC_PULSE = 10'd96;
    localparam V_SYNC_PULSE = 10'd2;

    reg pulse;
    reg clk25;

    initial begin // Set all of them initially to 0
		clk25 = 0;
		pulse = 0;
        h_counter = 10'b0000000000;
        v_counter = 10'b0000000000;
	end

    always @(posedge clk)
		pulse = ~pulse;
	always @(posedge pulse)
		clk25 = ~clk25;
		
		
	integer y_coord;
    integer x_coord;

    wire player_fill;
    assign player_fill = h_counter >= (player_width*player_x_pos) && h_counter <= (player_width*player_x_pos) + player_width && v_counter >= (player_width*player_y_pos) && v_counter <= (player_width*player_y_pos) + player_width;




    // VGA signal generation logic goes here
    always @(posedge clk25) begin
        // Generate sync pulses and pixel data here
        rgb = 12'b111111111111; // Black color temp background

        //draw map

        
        // compute the map coordinates and rom address
        y_coord = h_counter / player_width;
        addr = y_coord;
        x_coord = v_counter / player_width;

        if (y_coord >= 0 && y_coord <= 20 && x_coord >= 0 && x_coord <= 29) begin
            if (map_data_out[x_coord]) begin
                rgb = 12'b111111110000; // Brown color temp
            end
        end

        // draw player! 
        if (player_fill) begin
            rgb = 12'b111111111111; // WHITE color temp
        end

        // Increment counters
        hCount <= (hCount == H_MAX) ? 0 : hCount + 1;
        if (hCount == H_MAX) begin
            vCount <= (vCount == V_MAX) ? 0 : vCount + 1;
        end
    end


assign hsync = (hCount < H_SYNC_PULSE) ? 1'b0 : 1'b1;
assign vsync = (vCount < V_SYNC_PULSE) ? 1'b0 : 1'b1;

endmodule