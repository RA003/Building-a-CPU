module Ram #(
    parameter int DATA_WIDTH = 8,
    parameter int MEM_SIZE   = 16
) (
    input  logic                   i_clk,      
    input  logic                   i_we,           
    input  logic                   i_jmp_imme,     
    input  logic [DATA_WIDTH-1:0]  i_addr,         
    input  logic [DATA_WIDTH-1:0]  i_bus_data,     

    output logic [DATA_WIDTH-1:0]  o_bus_data      
);
    //[ 7:4 (Opcode) , 3:0 (Address) ] 

    // 4 bit addressing for 16 words of memory
    logic [DATA_WIDTH-1:0] mem [0:MEM_SIZE-1];  // Memory array is unpacked array of DATA_WIDTH-wide words

    always_ff @(posedge i_clk) begin
        if (i_we) begin
            //mapping the lower 4 bits of input address to 16 memory locations
            mem[i_addr[3:0]] <= i_bus_data;
        end
    end

    // --- Combinational Logic: Reading ---
    // This part effectively acts as a 2-to-1 Mux internal to the RAM
    // to choose between raw data and "Jump-formatted" data.
    always_comb begin
        if (i_jmp_imme) begin
            // Jump Read to instruct PC to jump to this address
            // Upper 4 bits are zeroed out for jump instruction to only read the address
            o_bus_data = {4'h0, mem[i_addr[3:0]][3:0]};
        end else begin
            // Normal Read during fetch 
            o_bus_data = mem[i_addr[3:0]];
        end
    end

endmodule