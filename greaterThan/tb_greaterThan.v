`timescale 1ns/1ps

module tb_greaterThan;
  reg [3:0] i_a, i_b;
  wire o_ab;
  // Instantiate DUT
  greaterThan dut (
    .i_a(i_a),
    .i_b(i_b),
    .o_ab(o_ab)
  );
  // Waveform generation
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars(0, tb_greaterThan);
    // Test cases
    i_a = 4'b0000; i_b = 4'b0000; #10;  // A == B
    i_a = 4'b1000; i_b = 4'b0111; #10;  // A > B
    i_a = 4'b0010; i_b = 4'b0100; #10;  // A < B
    i_a = 4'b1111; i_b = 4'b1110; #10;  // A > B
    i_a = 4'b0001; i_b = 4'b0010; #10;  // A < B
    $finish; // End simulation
  end
endmodule
