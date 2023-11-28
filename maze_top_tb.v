`timescale 1ns/1ns

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

    // Instantiate the maze_top module
    maze_top dut (
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
        .Dp(Dp)
    );

    initial 
		  begin
			Clk = 0; // Initialize clock
		  end
		
		always  begin #10; Clk = ~ Clk; end

    // Apply stimulus to the inputs
    initial begin
        // Initialize inputs
        Reset = 1;
        BtnC = 0;
        BtnU = 0;
        BtnD = 0;
        BtnL = 0;
        BtnR = 0;
        
        // Reset the system
        #20;
        Reset = 0;

        // Moving through the maze (Up Right Down Left)
        #100;
        BtnU = 1; //Move Up
        #20;
        BtnU = 0;
        #100;
        BtnR = 1; //Move Right
        #20;
        BtnR = 0;
        #100;
        BtnD = 1; //Move Down
        #20;
        BtnD = 0;
        #100;
        BtnL = 1;//Move Left
        #20;
        BtnL = 0;
        #100;
        // Wait for some time
        #1000;

        BtnU = 1; //Move Up
        #20;
        BtnU = 1;
        #20;
        BtnU = 1;
        #20
        BtnU = 0;
        #20
        BtnR = 1; //Move Right
        #20;
        BtnR = 1;
        #20;
        BtnR = 1;
        #20;
        BtnR = 0;
        #100;
        BtnD = 1; //Move Down
        #20;
        BtnD = 1; //Move Down
        #20;
        BtnD = 0;
        #100;
        BtnL = 1;//Move Left
        #20;
        BtnL = 1;//Move Left
        #20;
        BtnL = 1;//Move Left
        #20;
        BtnL = 0;
        #100;




        // End the simulation
        $finish;
    end

    // Monitor the outputs and check for expected results
    always @(posedge Clk) begin
        // Monitor outputs
        // ...

        // Check for expected results
        // ...
    end

endmodule
