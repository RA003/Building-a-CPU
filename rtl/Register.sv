module Register #(
    parameter int DATA_WIDTH = 8
) 
(
    //Input
    input  logic                   i_clk,   // Clock Signal
    input  logic                   i_rst,   // Synchronous Reset
    input  logic                   i_we,    // Write Enable
    input  logic [DATA_WIDTH-1:0]  i_bus,   // Input from the Bus

    //Output
    output logic [DATA_WIDTH-1:0]  o_data,  // Dedicated Output
    output logic [DATA_WIDTH-1:0]  o_bus    // Output to the Bus
);

    logic [DATA_WIDTH-1:0] reg_value;

    always_ff @(posedge i_clk) begin
        if (i_rst)
            reg_value <= 8'b0;
        else if (i_we)
            reg_value <= i_bus;
    end

    assign o_data = reg_value;
    assign o_bus  = reg_value; 

endmodule