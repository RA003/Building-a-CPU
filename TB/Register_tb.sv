`timescale 1ns/1ns

`define assert(signal, value) \
    if (signal !== value) begin \
        $display("ASSERTION FAILED at %2d: expected %h, got %h", $time, value, signal); \
        $finish; \
    end

module register_tb;
    localparam integer DATA_WIDTH = 8;

    logic clk;
    logic rst;
    logic we;
    logic [DATA_WIDTH-1:0] i_bus;
    
    wire [DATA_WIDTH-1:0] o_data;
    wire [DATA_WIDTH-1:0] o_bus;

    // Instantiate DUT
    Register #(.DATA_WIDTH(DATA_WIDTH)) dut (
        .i_clk(clk),
        .i_rst(rst),
        .i_we(we),
        .i_bus(i_bus),
        .o_data(o_data),
        .o_bus(o_bus)
    );

    // Clock generation: 10ns period 
    always #5 clk = ~clk;

initial begin
        // Initialization
        clk = 0; 
  		rst = 1; 
  		we = 0; 
  		i_bus = 8'h00;

        @(posedge clk); 
        #1; 
        rst = 0; 
  		
  		// 10 random data signals
        repeat (10) begin
          logic [DATA_WIDTH-1:0] data;
          data = $urandom(); // 32 bit data truncated to DATA_WIDTH

            @(posedge clk);
            #1;
            i_bus = data;
            we    = 1'b1;

            @(posedge clk);
            #1;
          `assert(o_data, data); // Verify o_data matches the random input
          `assert(o_bus,  data); // Verify o_bus matches the random input
        end
  
        //Synchronous Reset Check
        @(posedge clk);
        #1;
        rst = 1;
 		$display("Applying reset at time %t", $time);
		
//         Check value on current 
//         `assert(o_data !== 8'h00, o_data); 

        //Check value on next clock cycle
        @(posedge clk); 
        #1;
        `assert(o_data, 8'h00); 

        rst = 0;
        
        #20;
        $display("SUCCESS: Randomized testing passed!");
        $finish;
    end

    initial begin
        $dumpfile("register.vcd");
        $dumpvars(0, register_tb);
    end
endmodule