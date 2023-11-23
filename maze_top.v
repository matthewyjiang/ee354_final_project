`timescale 1ns / 1ps



module maze_top (
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
    wire reset;
    assign reset=BtnC;
    wire bright;
	wire[9:0] hc, vc;
	wire up,down,left,right;
	wire [3:0] anode;
	wire [11:0] rgb;
    
    wire [3:0]	SSD3, SSD2, SSD1, SSD0;

    reg [7:0] SSD_CATHODES;

    
	wire [1:0] 	ssdscan_clk;

    reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge reset)  
	begin : CLOCK_DIVIDER
      if (reset)
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

    // test if the clock is working
    
    assign SSD0 = 4'b1111;
    assign SSD1 = vgaR;
    assign SSD2 = vgaG;
    assign SSD3 = vgaB;

    wire [7:0] player_x_pos;
    wire [7:0] player_y_pos;
    

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

    

    assign buttons = {BtnU, BtnD, BtnL, BtnR};
    wire [3:0] DPBs;
    wire [3:0] SCENs;
    wire [3:0] MCENs;
    wire [3:0] CCENs;

    // signals for input to game logic


    // // Input Interface instance
    Input_Interface input_interface_inst (
        .clk(ClkPort),
        .reset(reset),
        .buttons(buttons),// Connect buttons
        .DPBs(DPBs),
        .SCENs(SCENs),
        .MCENs(MCENs),
        .CCENs(CCENs)
    );

    wire lost;

    // Game Logic instance
    Game_Logic game_logic_inst (
        .clk(ClkPort),
        .reset(reset),
        .DPBs(DPBs),
        .SCENs(SCENs),
        .lost(lost),
        .rgb(rgb),
        .bright(bright),
        .player_x_pos(player_x_pos),
        .player_y_pos(player_y_pos)
    );

    // VGA Controller instance
    vga_controller vga_controller_inst (
        .clk(ClkPort),
        .reset(reset),
        .hsync(hSync),
        .vsync(vSync),
        .bright(bright),
        .hCount(hc),
        .vCount(vc)
    );

    assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
    

    // disable mamory ports
	assign {QuadSpiFlashCS} = 1'b1;

    
	
	
endmodule
