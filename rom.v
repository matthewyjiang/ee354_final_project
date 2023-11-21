module rom #(parameter WIDTH=30, parameter DEPTH=21, parameter INIT_F="", localparam ADDRW=$clog2(DEPTH))
    (
        input wire clk,
        input wire [ADDRW-1:0] addr,
        output reg [ADDRW-1:0] addr_out, //to track delayed address
        output reg [WIDTH-1:0] data_out
    );

    (* rom_style = "block" *)

    reg [WIDTH-1:0] memory [DEPTH-1:0];

    initial begin 
        if (INIT_F != 0) begin
            $readmemh(INIT_F, memory);
        end
    end

    always @(posedge clk) begin
        addr_out <= addr;
        data_out <= memory[addr];
    end

endmodule