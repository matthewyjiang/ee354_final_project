`timescale 1ns / 1ps


module Input_Interface (
    input wire clk,
    input wire reset,
    input wire [7:0] switches, // Replace N with the number of switches
    input wire [3:0] buttons // Replace M with the number of buttons
);

    // Input processing logic goes here, including debouncing

endmodule

module Game_Logic (
    input wire clk,
    input wire reset
    // Game state signals, e.g., player position, maze state, etc.
    // ...
);

    // Game logic goes here, including maze generation and collision detection

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

    // VGA Controller instance
    vga_controller vga_controller_inst (
        .clk(clk_25MHz),
        .reset(reset),
        .hsync(hSync),
        .vsync(vSync),
        .rgb(rgb),
        .h_counter(hc),
        .v_counter(vc)
    );

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

    // // Input Interface instance
    // Input_Interface input_interface_inst (
    //     .clk(clk),
    //     .reset(reset),
    //     .switches(switches), // Connect switches
    //     .buttons(buttons) // Connect buttons
    // );

    // // Game Logic instance
    // Game_Logic game_logic_inst (
    //     .clk(clk),
    //     .reset(reset)
    //     // Connect other ports
    // );

    assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];

    // disable mamory ports
	assign {QuadSpiFlashCS} = 1'b1;

    
	
	
endmodule
