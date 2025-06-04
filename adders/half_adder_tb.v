`include "half_adder.v"
module half_adder_tb;
	reg		r_bit1	=0;
	reg		r_bit2	=0;
	wire	w_sum;
	wire w_carry;
	half_adder half_adder_dut
	(
		.i_bit1(r_bit1),
		.i_bit2(r_bit2),
		.o_sum(w_sum),
		.o_carry(w_carry)
		);
	initial begin
		$dumpfile("waveform.vcd");
		$dumpvars(0,half_adder_tb);
		$monitor("r_bit1=%b|r_bit2=%b|w_sum=%b|w_carry=%b",r_bit1,r_bit2,w_sum,w_carry);
			r_bit1	=1'b0;
			r_bit2	=1'b0;
			#10;
			r_bit1	=1'b0;
			r_bit2	=1'b1;
			#10;
			r_bit1	=1'b1;
			r_bit2	=1'b0;
			#10;
			r_bit1	=1'b1;
			r_bit2	=1'b1;
			#10;
			$finish;
		end
endmodule
