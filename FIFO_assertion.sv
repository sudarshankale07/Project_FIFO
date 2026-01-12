`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Sudarshan Kale
// 
//////////////////////////////////////////////////////////////////////////////////




module FIFO_Synch (
    input clk,
    input reset,  
    input wn,
    input rn,
    input  [7:0] data_in,
    output logic [7:0] data_out,
    output logic full,
    output logic empty
);

    // Memory: 8 x 8-bit
    logic [7:0] memory [0:7];

    // Pointers: 3-bit
    logic [2:0] wptr, rptr;

    // Flags
    assign full  = (wptr[2:1] == rptr[2:1]) && (wptr[0] != rptr[0]);
    assign empty = (wptr == rptr);

  
    always_ff @(posedge clk) begin
        if (reset) begin
            wptr <= 3'b0;
            rptr <= 3'b0;
            data_out <= 8'b0;
        end else begin
            // Write
            if (wn && !full) begin
                memory[wptr] <= data_in;
                wptr <= wptr + 1;
            end
            // Read
            if (rn && !empty) begin
                data_out <= memory[rptr];
                rptr <= rptr + 1;
            end
        end
    end

endmodule