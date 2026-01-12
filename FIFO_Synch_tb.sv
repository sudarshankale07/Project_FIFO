`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// sudarshan
//////////////////////////////////////////////////////////////////////////////////



module tb_FIFO_Synch;

    // Clock and control signals
    logic clk;
    logic reset;
    logic wn;
    logic rn;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic full;
    logic empty;

    
    FIFO_Synch dut (
        .clk(clk),
        .reset(reset),
        .wn(wn),
        .rn(rn),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generator: 10 ns period (5 ns high, 5 ns low)
    always begin
        #5 clk = ~clk;
    end

    // Test sequence
    initial begin
       
        clk = 0;
        reset = 1;
        wn = 0;
        rn = 0;
        data_in = 8'h00;

        // Hold reset for 20 ns
        #20 reset = 0;

        $display("=== FIFO Test Started ===");

        // Test 1: Fill the FIFO completely (8 writes)
        $display("\n--- Filling FIFO (8 writes) ---");
        repeat(8) begin
            @(posedge clk);
            data_in = data_in + 1;
            wn = 1;
            $display("Write: %0d | full=%0b empty=%0b", data_in, full, empty);
        end
        wn = 0;
        @(posedge clk);
        $display("After fill → full=%0b, empty=%0b", full, empty);

        // Test 2: Read all 8 values
        $display("\n--- Reading FIFO (8 reads) ---");
        repeat(8) begin
            @(posedge clk);
            rn = 1;
            $display("Read: %0d | full=%0b empty=%0b", data_out, full, empty);
        end
        rn = 0;
        @(posedge clk);
        $display("After drain  full=%0b, empty=%0b", full, empty);

        // Test 3: Simultaneous read and write (when partially full)
        $display("\n--- Simultaneous R/W ---");
        wn = 1; rn = 1;
        data_in = 8'hAA;
        @(posedge clk);
        $display("R/W: wrote AA, read %0h | full=%0b empty=%0b", data_out, full, empty);
        wn = 0; rn = 0;

        // Test 4: Attempt write when full (should be ignored)
        $display("\n--- Try writing when full ---");
        // Refill FIFO
        repeat(8) begin @(posedge clk); wn=1; data_in=data_in+1; end
        wn = 0;
        @(posedge clk);
        // Now try extra write
        wn = 1; data_in = 8'hFF;
        @(posedge clk);
        $display("Tried write when full  full=%0b (should stay 1)", full);
        wn = 0;

        // Test 5: Attempt read when empty (should be ignored)
        $display("\n--- Try reading when empty ---");
        // Drain again
        repeat(8) begin @(posedge clk); rn=1; end
        rn = 0;
        @(posedge clk);
        rn = 1;
        @(posedge clk);
        $display("Tried read when empty  empty=%0b (should stay 1)", empty);
        rn = 0;

        $display("\n=== Test Completed ===");
        $finish;
    end

    // Optional: Generate waveform dump (for viewing in Vivado Simulator)
    initial begin
        $dumpfile("fifo_waveform.vcd");
        $dumpvars(0, tb_FIFO_Synch);
    end

endmodule