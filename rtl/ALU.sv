module ALU #(
    parameter int DATA_WIDTH = 8
) 
(
    input  logic                   i_clk,
    input  logic                   i_rst,          // Synchronous Reset
    input  logic [DATA_WIDTH-1:0]  i_a,            // Operand A
    input  logic [DATA_WIDTH-1:0]  i_b,            // Operand B
    input  logic                   i_opcode,       // 1 = ADD, 0 = SUB 
    input  logic                   i_bus_wr_en,    // Bus Write Enable
    
    output logic [DATA_WIDTH-1:0]  o_result,        // Result output
    output logic                   o_carry_flag,    // used for addition by the controller
    output logic                   o_zero_flag      // used for both addition and subtraction by the controller
);

    logic [DATA_WIDTH-1:0] result;
    logic                  carry_out;  
    
    always_comb begin
        result    = '0;
        carry_out = 1'b0;

        case (i_opcode)
            1'b1: begin // ADDITION
                {carry_out, result} = i_a + i_b;
            end
            
            1'b0: begin // SUBTRACTION
                result = i_a - i_b;
                carry_out = 1'b0; // Not used in subtraction
            end

            default: begin
                result    = '0;
                carry_out = 1'b0;
            end
        endcase
    end


    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            o_carry_flag <= 1'b0;
            o_zero_flag  <= 1'b0;
        end else if (i_bus_wr_en) begin 
            o_carry_flag <= carry_out;
            o_zero_flag  <= (result == '0);
        end
    end

    assign o_result = result;

endmodule