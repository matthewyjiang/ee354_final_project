 
module rom #(parameter WIDTH=8,
    parameter DEPTH=256,
    parameter INIT_F="",
    localparam ADDRW=$clog2(DEPTH)
    )    (
        input wire clk,
        input wire [ADDRW-1:0] addr,
        output reg [ADDRW-1:0] addr_out, // to track delayed address
        output reg [WIDTH-1:0] data_out
    );

    (* rom_style = "block" *)

    reg [WIDTH-1:0] memory [DEPTH-1:0]; 

    initial begin
        if (INIT_F != 0) begin
            // $display("Creating rom_async from init file '%s'.", INIT_F);
            $readmemh(INIT_F, memory);
        end
    end

    always @(posedge clk)
    begin
        data_out <= memory[addr];
        addr_out <= addr; // debugging
    end
    
    integer i;

    initial begin // for debugging: checking memory -> address
        // $display("rdata:");
        // for (i=0; i < DEPTH; i=i+1)
            // $display("%d:%h",i,memory[i]);
    end
endmodule
