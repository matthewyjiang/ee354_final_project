`timescale 1ns / 1ps



module Game_Logic (
    input wire clk,
    input wire reset,
    input wire [3:0] DPBs,
    input wire [3:0] SCENs,

    output wire lost
    output reg [7:0] player_x_pos,
    output reg [7:0] player_y_pos
);
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

    localparam ADDRW = $clog2(21);

    reg [ADDRW-1:0] addr;
    reg [29:0] data_out;

    // ROM instance to read map data from file

    rom map_rom_inst #( .WIDTH(30), .DEPTH(21), .INIT_F("map.mem")) (
        .clk(clk),
        .addr(addr),
        .addr_out(),
        .data_out(data_out),
    );


    wire SCEN_any;
    assign SCEN_any = SCENs[0] | SCENs[1] | SCENs[2] | SCENs[3];

    integer show_map_duration;

    initial begin
        player_x_pos = 8'd0;
        player_y_pos = 8'd20;

        game_state = GAME_STATE_in_menu;
        game_state_menu = GAME_STATE_MENU_start;
        game_state_difficulty = GAME_STATE_DIFFICULTY_easy;
        game_state_game = GAME_STATE_GAME_show_map;
        show_map_duration = 0;
    end

    always @ (posedge SCEN_any) begin // movement logic
        if (game_state == GAME_STATE_GAME_playing) begin
            if (SCENs[0]) begin
                player_y_pos <= player_y_pos - 1;
            end
            if (SCENs[1]) begin
                player_y_pos <= player_y_pos + 1;
            end
            if (SCENs[2]) begin
                player_x_pos <= player_x_pos - 1;
            end
            if (SCENs[3]) begin
                player_x_pos <= player_x_pos + 1;
            end
        end

        addr <= player_y_pos;
    end

    always @(posedge clk) begin
        if(game_state == GAME_STATE_GAME_show_map) begin
            show_map_duration <= show_map_duration + 1;
        end
        if (show_map_duration == 1000000) begin
            game_state <= GAME_STATE_GAME_hide_map;
            show_map_duration <= 0;
        end
    end

    always @ (posedge clk) begin 
        if (reset) begin
            player_x_pos <= 8'd0;
            player_y_pos <= 8'd20;
        end
        else begin // map collision logic
            if (data_out[player_x_pos]) begin
                lost <= 1'b1;
            end
        end
    end



    
endmodule

module Top_Level (
    input ClkPort,
	input BtnC,
	input BtnU,
	input BtnR,
	input BtnL,
	input BtnD,
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	output QuadSpiFlashCS
);
    wire Reset;
    assign Reset=BtnC;
    wire bright;
	wire[9:0] hc, vc;
	wire up,down,left,right;
	wire [3:0] anode;
	wire [11:0] rgb;
	wire rst;
    
    wire [3:0]	SSD3, SSD2, SSD1, SSD0;

    reg [7:0] SSD_CATHODES;

    
	wire [1:0] 	ssdscan_clk;

    reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	wire move_clk;
	assign move_clk=DIV_CLK[19]; //slower clock to drive the movement of objects on the vga screen
	wire [11:0] background;
    assign ssdscan_clk = DIV_CLK[19:18];
    // Instantiate modules and wire them up

    // Clock division and generation logic
    // Clock management to generate a 25MHz clock from the onboard clock

    wire clk_25MHz;

    assign clk_25MHz = DIV_CLK[25];

    reg [7:0] player_x_pos;
    reg [7:0] player_y_pos;
    

    // SSD Controller instance
    ssd_controller ssd_controller_inst (
        .ssdscan_clk(ssdscan_clk),
        .SSD3(SSD3),
        .SSD2(SSD2),
        .SSD1(SSD1),
        .SSD0(SSD0),
        .An0(An0),
        .An1(An1),
        .An2(An2),
        .An3(An3),
        .An4(An4),
        .An5(An5),
        .An6(An6),
        .An7(An7),
        .Ca(Ca),
        .Cb(Cb),
        .Cc(Cc),
        .Cd(Cd),
        .Ce(Ce),
        .Cf(Cf),
        .Cg(Cg),
        .Dp(Dp)
    );

    
    wire [3:0] buttons;
    assign buttons = {up, down, left, right, Reset};
    wire [3:0] DPBs;
    wire [3:0] SCENs;
    wire [3:0] MCENs;
    wire [3:0] CCENs;

    // signals for input to game logic

    reg [20:0] map [29:0];


    // // Input Interface instance
    Input_Interface input_interface_inst (
        .clk(clk),
        .reset(reset),
        .buttons(buttons) // Connect buttons
        .DPBs(DPBs),
        .SCENs(SCENs),
        .MCENs(MCENs),
        .CCENs(CCENs)
    );

    wire lost;

    // Game Logic instance
    Game_Logic game_logic_inst (
        .clk(clk),
        .reset(reset),
        .DPBs(DPBs),
        .SCENs(SCENs),
        .lost(lost),
        .player_x_pos(player_x_pos),
        .player_y_pos(player_y_pos)
    );

    // VGA Controller instance
    vga_controller vga_controller_inst (
        .clk(clk_25MHz),
        .reset(reset),
        .hsync(hSync),
        .vsync(vSync),
        .rgb(rgb),
        .h_counter(hc),
        .v_counter(vc),
        .player_x_pos(player_x_pos),
        .player_y_pos(player_y_pos)
    );

    assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];

    // disable mamory ports
	assign {QuadSpiFlashCS} = 1'b1;

    
	
	
endmodule
