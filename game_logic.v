
module Game_Logic (
    input wire clk,
    input wire reset,
    input wire [3:0] DPBs,
    input wire [3:0] SCENs,
    input wire clk25,
    input bright,
    input [9:0] hcount, vcount,

    output reg [11:0] rgb,   // RGB output
    output reg lost,
    output reg [7:0] player_x_pos,
    output reg [7:0] player_y_pos,
    output reg [$clog2(21)-1:0] addr_out
);

    localparam x_offset = 144;
    localparam y_offset = 35;
    localparam ADDRW_MAP = $clog2(21);
    reg [ADDRW_MAP-1:0] addr;
    wire [29:0] map_data_out;


    localparam MAP_WIDTH = 30;
    localparam MAP_HEIGHT = 21; 
    rom #( .WIDTH(MAP_WIDTH), .DEPTH(MAP_HEIGHT), .INIT_F("map.mem")) map_rom_inst (
        .clk(clk25),
        .addr(addr),
        .addr_out(),
        .data_out(map_data_out)
    );


    integer show_map_duration;

   

    // ----------------------------------------------------------------------------------
    // Game State ENUM definitions
    // overall game state
    reg [3:0] game_state;
    localparam GAME_STATE_in_menu = 4'b0001;
    localparam GAME_STATE_in_game = 4'b0010;
    localparam GAME_STATE_lost = 4'b0100;
    localparam GAME_STATE_won = 4'b1000;
    //
    // substates for in menu (choose start, difficulty, instructions)
    reg [2:0] game_state_menu;
    localparam GAME_STATE_MENU_start = 3'b001;
    localparam GAME_STATE_MENU_difficulty = 3'b010;
    localparam GAME_STATE_MENU_instructions = 3'b100;
    //
    //substates for menu difficulty selection (easy, medium, hard) use these states to display which difficulty is currently selected
    reg [2:0] game_state_difficulty;
    localparam GAME_STATE_DIFFICULTY_easy = 5'b001;
    localparam GAME_STATE_DIFFICULTY_medium = 5'b010;
    localparam GAME_STATE_DIFFICULTY_hard = 5'b100;
    //
    // substates for in game (show map, hide map, playing)
    reg [2:0] game_state_game;
    localparam GAME_STATE_GAME_show_map = 3'b001;
    localparam GAME_STATE_GAME_hide_map = 3'b010;
    localparam GAME_STATE_GAME_playing = 3'b100;
    //
    // ----------------------------------------------------------------------------------

    
    reg [9:0] y_coord;
    reg [9:0] x_coord;


    initial begin
        player_x_pos = 8'd0;
        player_y_pos = 8'd11;
        addr = 0;
        game_state = GAME_STATE_in_game;
        game_state_menu = GAME_STATE_MENU_start;
        game_state_difficulty = GAME_STATE_DIFFICULTY_easy;
        game_state_game = GAME_STATE_GAME_playing;
        show_map_duration = 0;
        x_coord = 0;
        y_coord = 0;
    end


    always @(posedge clk) begin
        if(game_state == GAME_STATE_GAME_show_map) begin
            show_map_duration <= show_map_duration + 1;
        end
        if (show_map_duration == 1000000) begin
            game_state <= GAME_STATE_GAME_hide_map;
            show_map_duration <= 0;
        end

        if (reset) begin
            player_x_pos <= 8'd0;
            player_y_pos <= 8'd11;
        end
        if (game_state == GAME_STATE_in_game) begin
            if (SCENs[0] && player_y_pos > 0) begin
                player_y_pos <= player_y_pos - 1;
            end
            if (SCENs[1] && player_y_pos < MAP_HEIGHT) begin
                player_y_pos <= player_y_pos + 1;
            end
            if (SCENs[2] && player_x_pos > 0) begin
                player_x_pos <= player_x_pos - 1;
            end
            if (SCENs[3] && player_x_pos < MAP_WIDTH) begin
                player_x_pos <= player_x_pos + 1;
            end
        end

    
    end

    localparam player_width = 16;
    localparam player_width_log = 4;


    wire [9:0] x_pixel;
    wire [9:0] y_pixel;
    assign x_pixel = hcount - x_offset;
    assign y_pixel = vcount - y_offset;

    wire player_fill;
    assign player_fill = (x_pixel>= (player_width*player_x_pos) && x_pixel <= (player_width*player_x_pos + player_width) && (y_pixel >= (player_width*player_y_pos)) && (y_pixel <= (player_width*player_y_pos + player_width)));
    wire map_fill;
    assign map_fill = map_data_out[x_coord];

    always @ (*) begin
        if (bright) begin

            y_coord = (y_pixel >> player_width_log);
            x_coord = (x_pixel >> player_width_log);

            addr = y_coord[ADDRW_MAP-1:0];

            if (map_fill) begin
                rgb = 12'b000000000000; 
            end else if (player_fill) begin
                rgb = 12'b111100000000; 
            end else begin 
                rgb = 12'b111111111111;
            end

        
        
        end else begin
            rgb = 12'b000000000000; // Black color temp background
        end
        
        end


    
endmodule
