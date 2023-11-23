module Input_Interface (
    input wire clk,
    input wire reset,
    input wire [3:0] buttons, // Replace M with the number of buttons

    output wire [3:0] DPBs,
    output wire [3:0] SCENs,
    output wire [3:0] MCENs,
    output wire [3:0] CCENs
);

    debouncer debouncer_inst0 (
        .clk(clk),
        .reset(reset),
        .PB(buttons[0]),
        .DPB(DPBs[0]),
        .SCEN(SCENs[0]),
        .MCEN(MCENs[0]),
        .CCEN(CCENs[0])
    );

    debouncer debouncer_inst1 (
        .clk(clk),
        .reset(reset),
        .PB(buttons[1]),
        .DPB(DPBs[1]),
        .SCEN(SCENs[1]),
        .MCEN(MCENs[1]),
        .CCEN(CCENs[1])
    );
    
    debouncer debouncer_inst2 (
        .clk(clk),
        .reset(reset),
        .PB(buttons[2]),
        .DPB(DPBs[2]),
        .SCEN(SCENs[2]),
        .MCEN(MCENs[2]),
        .CCEN(CCENs[2])
    );

    debouncer debouncer_inst3 (
        .clk(clk),
        .reset(reset),
        .PB(buttons[3]),
        .DPB(DPBs[3]),
        .SCEN(SCENs[3]),
        .MCEN(MCENs[3]),
        .CCEN(CCENs[3])
    ); 

endmodule