
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
    output reg [$clog2(21)-1:0] addr_out,
        
    output wire [9:0] y_coord,
    output wire [9:0] x_coord,
    output reg [29:0] map_data_out_debug,
    output reg [4:0] addr_out_debug
);

    localparam x_offset = 144;
    localparam y_offset = 35;
    localparam ADDRW_MAP = $clog2(21);
    wire [ADDRW_MAP-1:0] addr;
    reg [ADDRW_MAP-1:0] addr1;
    wire [29:0] map_data_out;
    wire [29:0] map_data_out1;


    localparam MAP_WIDTH = 30;
    localparam MAP_HEIGHT = 21; 

    rom #(.WIDTH(30), .DEPTH(21), .INIT_F("map.mem")) rom_inst (
        .clk(clk),
        .addr(addr),
        .addr_out(map_addr_out),
        .data_out(map_data_out)
    );

    rom #(.WIDTH(30), .DEPTH(21), .INIT_F("map.mem")) rom_inst1 (
        .clk(clk),
        .addr(addr1),
        .addr_out(),
        .data_out(map_data_out1)
    );

    wire [4:0] map_addr_out;


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
    localparam GAME_STATE_GAME_playing = 3'b100;
    //
    // ----------------------------------------------------------------------------------




    initial begin
        player_x_pos = 8'd0;
        player_y_pos = 8'd10;
        game_state = GAME_STATE_in_game;
        game_state_menu = GAME_STATE_MENU_start;
        game_state_difficulty = GAME_STATE_DIFFICULTY_easy;
        game_state_game = GAME_STATE_GAME_show_map;
        show_map_duration = 0;
    end


    always @(posedge clk) begin
        

        if (reset) begin
            player_x_pos <= 8'd0;
            player_y_pos <= 8'd10;
            game_state <= GAME_STATE_in_menu;
            show_map_duration <= 0;
        end

        case (game_state)
            GAME_STATE_in_game: begin
                case (game_state_game)
                    GAME_STATE_GAME_show_map: begin
                        show_map_duration <= show_map_duration + 1;
                        if (show_map_duration == 300000000) begin
                            game_state_game <= GAME_STATE_GAME_playing;
                            show_map_duration <= 0;
                        end
                    end
                    GAME_STATE_GAME_playing: begin
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
                        if(player_x_pos == 29 && player_y_pos == 11) begin
                            game_state <= GAME_STATE_won;
                        end
                        addr1 <= player_y_pos;
                        if(map_data_out1[player_x_pos]) begin
                            game_state <= GAME_STATE_lost;
                        end   
                    end
                endcase
            end
            GAME_STATE_in_menu: begin
                if (DPBs[0]) begin
                    game_state <= GAME_STATE_in_game;
                    game_state_game <= GAME_STATE_GAME_show_map;
                end
            end
        endcase

    
    end

    localparam player_width = 16;
    localparam player_width_log = 4;


    wire [9:0] x_pixel;
    wire [9:0] y_pixel;
    assign x_pixel = hcount - x_offset;
    assign y_pixel = vcount - y_offset;

    wire player_fill;
    assign player_fill = (x_pixel >= (player_width*player_x_pos) && x_pixel < (player_width*player_x_pos + player_width) && (y_pixel >= (player_width*player_y_pos)) && (y_pixel < (player_width*player_y_pos + player_width)));
    wire map_fill;

    wire finish_tile;
    assign finish_tile = (x_coord == 29 && y_coord == 11);

    assign y_coord = (y_pixel >> player_width_log);
    assign x_coord = (x_pixel >> player_width_log);


    wire on_map;
    assign on_map = y_coord >= 0 && y_coord < 21 && x_coord >= 0 && x_coord < 30;

    assign addr = y_coord;

    always @ (*) begin

        addr_out_debug <= map_addr_out;

        if (bright) begin

            case (game_state)
                GAME_STATE_in_game: begin
                    if (on_map) begin 
                        map_data_out_debug = map_data_out;
                        if (finish_tile) begin
                            rgb = 12'b000011110000;
                        end else if (map_data_out[x_coord] && game_state_game == GAME_STATE_GAME_show_map) begin
                            rgb = 12'b000000000000; 
                        end else if (player_fill) begin
                            rgb = 12'b111100000000; 
                        end 
                        else begin 
                            rgb = 12'b111111111111;
                        end
                    end
                    else begin 
                        rgb = 12'b000000000001;
                    end
                end
                GAME_STATE_in_menu: begin
                    rgb = 12'h8CF;
                end
                GAME_STATE_lost: begin
                    rgb = 12'hF00;
                end

                GAME_STATE_won: begin
                    rgb = 12'h5E7;
                end
            endcase

        
        
        end else begin
            rgb = 12'b000000000000; // Black color temp background
        end
        
        end


    
endmodule
