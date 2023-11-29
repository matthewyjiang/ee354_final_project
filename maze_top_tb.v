`timescale 1ns/1ps

module maze_top_tb;
    reg Clk, Reset;
    reg BtnC;
    reg BtnU;
    reg BtnD;
    reg BtnL;
    reg BtnR;

    wire hSync;
    wire vSync;
    wire [3:0] vgaR;
    wire [3:0] vgaG;
    wire [3:0] vgaB;

    wire An0, An1, An2, An3, An4, An5, An6, An7;
    wire Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp;

    wire map_data_out_debug;

    reg [4:0] Addr;
    wire [29:0] Data_out;
    wire [9:0] x_coord;
    wire [9:0] y_coord;


    // Instantiate the maze_top module
    vga_top dut (
        .ClkPort(Clk),
        .BtnC(BtnC),
        .BtnU(BtnU),
        .BtnD(BtnD),
        .BtnL(BtnL),
        .BtnR(BtnR),
        .hSync(hSync),
        .vSync(vSync),
        .vgaR(vgaR),
        .vgaG(vgaG),
        .vgaB(vgaB),
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
        .Dp(Dp),
        .x_coord(x_coord),
        .y_coord(y_coord),
        .map_data_out_debug(map_data_out_debug)
    );

    initial 
		  begin
			Clk = 0; // Initialize clock
            Addr = 0;
		  end
		
		always  begin #10; Clk = ~ Clk; end

    // Apply stimulus to the inputs
    initial begin
        // Initialize inputs
        // ...
        Reset = 1;
        Clk = 0;

        #120 Reset = 0; // Deassert reset


        #43000 



        // Apply stimulus
        // ...

        // Wait for some time
        #200;

        // End the simulation
        $finish;
    end

    // Monitor the outputs and check for expected results
    always @(posedge Clk) begin
        // Monitor outputs
        // ...

        Addr = Addr + 1;

        if(Addr == 30'd20) begin
            Addr = 0;
        end

        



        // Check for expected results
        // ...
    end

endmodule
